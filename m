Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751671AbaB0KWg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Feb 2014 05:22:36 -0500
Received: from szxga01-in.huawei.com ([119.145.14.64]:62830 "EHLO
	szxga01-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751026AbaB0KWd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Feb 2014 05:22:33 -0500
Message-ID: <530F1117.1020605@huawei.com>
Date: Thu, 27 Feb 2014 18:19:03 +0800
From: Li Zefan <lizefan@huawei.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:17.0) Gecko/20130801 Thunderbird/17.0.8
MIME-Version: 1.0
To: Tejun Heo <tj@kernel.org>
CC: LKML <linux-kernel@vger.kernel.org>, Cgroups <cgroups@vger.kernel.org>
Subject: [PATCH 1/2] cpuset: fix a locking issue in cpuset_migrate_mm()
Content-Type: text/plain; charset="GB2312"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.177.18.230]
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

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

Holding cpuset_mutex won't prevent a task's cpuset from changing, and
it won't prevent the original task->cgroup from destroying during this
change.

Fixes: 5d21cc2db040 (cpuset: replace cgroup_mutex locking with cpuset internal locking)
Cc: <stable@vger.kernel.org> # 3.9+
Signed-off-by: Li Zefan <lizefan@huawei.com>
---
 kernel/cpuset.c | 8 ++------
 1 file changed, 2 insertions(+), 6 deletions(-)

diff --git a/kernel/cpuset.c b/kernel/cpuset.c
index d8bec21..5f50ec6 100644
--- a/kernel/cpuset.c
+++ b/kernel/cpuset.c
@@ -948,12 +948,6 @@ static int update_cpumask(struct cpuset *cs, struct cpuset *trialcs,
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
@@ -970,8 +964,10 @@ static void cpuset_migrate_mm(struct mm_struct *mm, const nodemask_t *from,
 
 	do_migrate_pages(mm, from, to, MPOL_MF_MOVE_ALL);
 
+	rcu_read_lock();
 	mems_cs = effective_nodemask_cpuset(task_cs(tsk));
 	guarantee_online_mems(mems_cs, &tsk->mems_allowed);
+	rcu_read_unlock();
 }
 
 /*
-- 
1.8.0.2
