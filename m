Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752076AbaDAMSQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Apr 2014 08:18:16 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:42163 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751702AbaDALQW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Apr 2014 07:16:22 -0400
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Li Zefan <lizefan@huawei.com>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.11 020/144] cpuset: fix a locking issue in cpuset_migrate_mm()
Date: Tue,  1 Apr 2014 12:13:44 +0100
Message-Id: <1396350948-29910-21-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1396350948-29910-1-git-send-email-luis.henriques@canonical.com>
References: <1396350948-29910-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.11.10.7 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Li Zefan <lizefan@huawei.com>

commit 4729583006772b9530404bc1bb7c3aa4a10ffd4d upstream.

I can trigger a lockdep warning:

  # mount -t cgroup -o cpuset xxx /cgroup
  # mkdir /cgroup/cpuset
  # mkdir /cgroup/tmp
  # echo 0 > /cgroup/tmp/cpuset.cpus
  # echo 0 > /cgroup/tmp/cpuset.mems
  # echo 1 > /cgroup/tmp/cpuset.memory_migrate
  # echo $$ > /cgroup/tmp/tasks
  # echo 1 > /cgruop/tmp/cpuset.mems

  ===============================
  [ INFO: suspicious RCU usage. ]
  3.14.0-rc1-0.1-default+ #32 Not tainted
  -------------------------------
  include/linux/cgroup.h:682 suspicious rcu_dereference_check() usage!
  ...
    [<ffffffff81582174>] dump_stack+0x72/0x86
    [<ffffffff810b8f01>] lockdep_rcu_suspicious+0x101/0x140
    [<ffffffff81105ba1>] cpuset_migrate_mm+0xb1/0xe0
  ...

We used to hold cgroup_mutex when calling cpuset_migrate_mm(), but now
we hold cpuset_mutex, which causes task_css() to complain.

This is not a false-positive but a real issue.

Holding cpuset_mutex won't prevent a task from migrating to another
cpuset, and it won't prevent the original task->cgroup from destroying
during this change.

Fixes: 5d21cc2db040 (cpuset: replace cgroup_mutex locking with cpuset internal locking)
Signed-off-by: Li Zefan <lizefan@huawei.com>
Sigend-off-by: Tejun Heo <tj@kernel.org>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 kernel/cpuset.c | 8 ++------
 1 file changed, 2 insertions(+), 6 deletions(-)

diff --git a/kernel/cpuset.c b/kernel/cpuset.c
index b49f24a..84773c7 100644
--- a/kernel/cpuset.c
+++ b/kernel/cpuset.c
@@ -985,12 +985,6 @@ static int update_cpumask(struct cpuset *cs, struct cpuset *trialcs,
  *    Temporarilly set tasks mems_allowed to target nodes of migration,
  *    so that the migration code can allocate pages on these nodes.
  *
- *    Call holding cpuset_mutex, so current's cpuset won't change
- *    during this call, as manage_mutex holds off any cpuset_attach()
- *    calls.  Therefore we don't need to take task_lock around the
- *    call to guarantee_online_mems(), as we know no one is changing
- *    our task's cpuset.
- *
  *    While the mm_struct we are migrating is typically from some
  *    other task, the task_struct mems_allowed that we are hacking
  *    is for our current task, which must allocate new pages for that
@@ -1007,8 +1001,10 @@ static void cpuset_migrate_mm(struct mm_struct *mm, const nodemask_t *from,
 
 	do_migrate_pages(mm, from, to, MPOL_MF_MOVE_ALL);
 
+	rcu_read_lock();
 	mems_cs = effective_nodemask_cpuset(task_cs(tsk));
 	guarantee_online_mems(mems_cs, &tsk->mems_allowed);
+	rcu_read_unlock();
 }
 
 /*
-- 
1.9.1

