Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752154AbaCHPcP (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 Mar 2014 10:32:15 -0500
Received: from mail-qa0-f47.google.com ([209.85.216.47]:43567 "EHLO
	mail-qa0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751206AbaCHPcN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 Mar 2014 10:32:13 -0500
Date: Sat, 8 Mar 2014 10:32:09 -0500
From: Tejun Heo <tj@kernel.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Li Zefan <lizefan@huawei.com>,
        containers@lists.linux-foundation.org, cgroups@vger.kernel.org
Subject: [GIT PULL] cgroup fixes for v3.14-rc5
Message-ID: <20140308153209.GC25021@htj.dyndns.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, Linus.

Two cpuset locking fixes from Li.  Both tagged for -stable.

The following changes since commit 532de3fc72adc2a6525c4d53c07bf81e1732083d:

  cgroup: update cgroup_enable_task_cg_lists() to grab siglock (2014-02-18 18:23:18 -0500)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/tj/cgroup.git for-3.14-fixes

for you to fetch changes up to 99afb0fd5f05aac467ffa85c36778fec4396209b:

  cpuset: fix a race condition in __cpuset_node_allowed_softwall() (2014-02-27 09:39:54 -0500)

Thanks.

----------------------------------------------------------------
Li Zefan (2):
      cpuset: fix a locking issue in cpuset_migrate_mm()
      cpuset: fix a race condition in __cpuset_node_allowed_softwall()

 kernel/cpuset.c | 10 +++-------
 1 file changed, 3 insertions(+), 7 deletions(-)

diff --git a/kernel/cpuset.c b/kernel/cpuset.c
index 4410ac6..e6b1b66 100644
--- a/kernel/cpuset.c
+++ b/kernel/cpuset.c
@@ -974,12 +974,6 @@ static int update_cpumask(struct cpuset *cs, struct cpuset *trialcs,
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
@@ -996,8 +990,10 @@ static void cpuset_migrate_mm(struct mm_struct *mm, const nodemask_t *from,
 
 	do_migrate_pages(mm, from, to, MPOL_MF_MOVE_ALL);
 
+	rcu_read_lock();
 	mems_cs = effective_nodemask_cpuset(task_cs(tsk));
 	guarantee_online_mems(mems_cs, &tsk->mems_allowed);
+	rcu_read_unlock();
 }
 
 /*
@@ -2486,9 +2482,9 @@ int __cpuset_node_allowed_softwall(int node, gfp_t gfp_mask)
 
 	task_lock(current);
 	cs = nearest_hardwall_ancestor(task_cs(current));
+	allowed = node_isset(node, cs->mems_allowed);
 	task_unlock(current);
 
-	allowed = node_isset(node, cs->mems_allowed);
 	mutex_unlock(&callback_mutex);
 	return allowed;
 }
