Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932648Ab3FMEGf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Jun 2013 00:06:35 -0400
Received: from mail-pb0-f51.google.com ([209.85.160.51]:32958 "EHLO
	mail-pb0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752702Ab3FMEFQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Jun 2013 00:05:16 -0400
From: Tejun Heo <tj@kernel.org>
To: lizefan@huawei.com
Cc: containers@lists.linux-foundation.org, cgroups@vger.kernel.org,
        koverstreet@google.com, linux-kernel@vger.kernel.org,
        cl@linux-foundation.org, Tejun Heo <tj@kernel.org>
Subject: [PATCH 07/11] cgroup: drop unnecessary RCU dancing from __put_css_set()
Date: Wed, 12 Jun 2013 21:04:54 -0700
Message-Id: <1371096298-24402-8-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.8.2.1
In-Reply-To: <1371096298-24402-1-git-send-email-tj@kernel.org>
References: <1371096298-24402-1-git-send-email-tj@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

__put_css_set() does RCU read access on @cgrp across dropping
@cgrp->count so that it can continue accessing @cgrp even if the count
reached zero and destruction of the cgroup commenced.  Given that both
sides - __css_put() and cgroup_destroy_locked() - are cold paths, this
is unnecessary.  Just making cgroup_destroy_locked() grab css_set_lock
while checking @cgrp->count is enough.

Remove the RCU read locking from __put_css_set() and make
cgroup_destroy_locked() read-lock css_set_lock when checking
@cgrp->count.  This will also allow removing @cgrp->count.

Signed-off-by: Tejun Heo <tj@kernel.org>
---
 kernel/cgroup.c | 20 ++++++++++----------
 1 file changed, 10 insertions(+), 10 deletions(-)

diff --git a/kernel/cgroup.c b/kernel/cgroup.c
index 8f5fbcb..22f9729 100644
--- a/kernel/cgroup.c
+++ b/kernel/cgroup.c
@@ -407,19 +407,13 @@ static void __put_css_set(struct css_set *cset, int taskexit)
 		list_del(&link->cset_link);
 		list_del(&link->cgrp_link);
 
-		/*
-		 * We may not be holding cgroup_mutex, and if cgrp->count is
-		 * dropped to 0 the cgroup can be destroyed at any time, hence
-		 * rcu_read_lock is used to keep it alive.
-		 */
-		rcu_read_lock();
+		/* @cgrp can't go away while we're holding css_set_lock */
 		if (atomic_dec_and_test(&cgrp->count) &&
 		    notify_on_release(cgrp)) {
 			if (taskexit)
 				set_bit(CGRP_RELEASABLE, &cgrp->flags);
 			check_for_release(cgrp);
 		}
-		rcu_read_unlock();
 
 		kfree(link);
 	}
@@ -4373,11 +4367,19 @@ static int cgroup_destroy_locked(struct cgroup *cgrp)
 	struct cgroup *parent = cgrp->parent;
 	struct cgroup_event *event, *tmp;
 	struct cgroup_subsys *ss;
+	bool empty;
 
 	lockdep_assert_held(&d->d_inode->i_mutex);
 	lockdep_assert_held(&cgroup_mutex);
 
-	if (atomic_read(&cgrp->count) || !list_empty(&cgrp->children))
+	/*
+	 * css_set_lock prevents @cgrp from being removed while
+	 * __put_css_set() is in progress.
+	 */
+	read_lock(&css_set_lock);
+	empty = !atomic_read(&cgrp->count) && list_empty(&cgrp->children);
+	read_unlock(&css_set_lock);
+	if (!empty)
 		return -EBUSY;
 
 	/*
@@ -5054,8 +5056,6 @@ void cgroup_exit(struct task_struct *tsk, int run_callbacks)
 
 static void check_for_release(struct cgroup *cgrp)
 {
-	/* All of these checks rely on RCU to keep the cgroup
-	 * structure alive */
 	if (cgroup_is_releasable(cgrp) &&
 	    !atomic_read(&cgrp->count) && list_empty(&cgrp->children)) {
 		/*
-- 
1.8.2.1

