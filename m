Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753292Ab3JUKt0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Oct 2013 06:49:26 -0400
Received: from mail-wg0-f54.google.com ([74.125.82.54]:54286 "EHLO
	mail-wg0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753076Ab3JUKtY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Oct 2013 06:49:24 -0400
Date: Mon, 21 Oct 2013 11:49:20 +0100
From: Tejun Heo <tj@kernel.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Li Zefan <lizefan@huawei.com>,
        cgroups@vger.kernel.org
Subject: [GIT PULL] cgroup fixes for v3.12-rc6
Message-ID: <20131021104920.GA26917@mtj.dyndns.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, Linus.

Two late fixes for cgroup.  One fixes descendant walk introduced
during this rc1 cycle.  The other fixes a post 3.9 bug during task
attach which can lead to hang.  Both fixes are critical and the fixes
are relatively straight-forward.

The two fixes are available in the following branch

  git://git.kernel.org/pub/scm/linux/kernel/git/tj/cgroup.git for-3.12-fixes

for you to fetch changes up to ea84753c98a7ac6b74e530b64c444a912b3835ca:

  cgroup: fix to break the while loop in cgroup_attach_task() correctly (2013-10-13 16:07:10 -0400)

Thanks.

----------------------------------------------------------------
Anjana V Kumar (1):
      cgroup: fix to break the while loop in cgroup_attach_task() correctly

Tejun Heo (1):
      cgroup: fix cgroup post-order descendant walk of empty subtree

 kernel/cgroup.c | 14 ++++++--------
 1 file changed, 6 insertions(+), 8 deletions(-)

diff --git a/kernel/cgroup.c b/kernel/cgroup.c
index e0aeb32..1bf4f7a1 100644
--- a/kernel/cgroup.c
+++ b/kernel/cgroup.c
@@ -2038,7 +2038,7 @@ static int cgroup_attach_task(struct cgroup *cgrp, struct task_struct *tsk,
 
 		/* @tsk either already exited or can't exit until the end */
 		if (tsk->flags & PF_EXITING)
-			continue;
+			goto next;
 
 		/* as per above, nr_threads may decrease, but not increase. */
 		BUG_ON(i >= group_size);
@@ -2046,7 +2046,7 @@ static int cgroup_attach_task(struct cgroup *cgrp, struct task_struct *tsk,
 		ent.cgrp = task_cgroup_from_root(tsk, root);
 		/* nothing to do if this task is already in the cgroup */
 		if (ent.cgrp == cgrp)
-			continue;
+			goto next;
 		/*
 		 * saying GFP_ATOMIC has no effect here because we did prealloc
 		 * earlier, but it's good form to communicate our expectations.
@@ -2054,7 +2054,7 @@ static int cgroup_attach_task(struct cgroup *cgrp, struct task_struct *tsk,
 		retval = flex_array_put(group, i, &ent, GFP_ATOMIC);
 		BUG_ON(retval != 0);
 		i++;
-
+	next:
 		if (!threadgroup)
 			break;
 	} while_each_thread(leader, tsk);
@@ -3187,11 +3187,9 @@ css_next_descendant_post(struct cgroup_subsys_state *pos,
 
 	WARN_ON_ONCE(!rcu_read_lock_held());
 
-	/* if first iteration, visit the leftmost descendant */
-	if (!pos) {
-		next = css_leftmost_descendant(root);
-		return next != root ? next : NULL;
-	}
+	/* if first iteration, visit leftmost descendant which may be @root */
+	if (!pos)
+		return css_leftmost_descendant(root);
 
 	/* if we visited @root, we're done */
 	if (pos == root)
