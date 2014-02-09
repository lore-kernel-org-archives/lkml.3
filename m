Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752661AbaBINzM (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Feb 2014 08:55:12 -0500
Received: from mail-qa0-f54.google.com ([209.85.216.54]:56489 "EHLO
	mail-qa0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752369AbaBINxL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Feb 2014 08:53:11 -0500
From: Tejun Heo <tj@kernel.org>
To: lizefan@huawei.com
Cc: containers@lists.linux-foundation.org, cgroups@vger.kernel.org,
        linux-kernel@vger.kernel.org, Tejun Heo <tj@kernel.org>
Subject: [PATCH 10/16] cgroup: separate out put_css_set_locked() and remove put_css_set_taskexit()
Date: Sun,  9 Feb 2014 08:52:38 -0500
Message-Id: <1391953964-22088-11-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.8.5.3
In-Reply-To: <1391953964-22088-1-git-send-email-tj@kernel.org>
References: <1391953964-22088-1-git-send-email-tj@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

put_css_set() is performed in two steps - it first tries to put
without grabbing css_set_rwsem if such put wouldn't make the count
zero.  If that fails, it puts after write-locking css_set_rwsem.  This
patch separates out the second phase into put_css_set_locked() which
should be called with css_set_rwsem locked.

Also, put_css_set_taskexit() is droped and put_css_set() is made to
take @taskexit.  There are only a handful users of these functions.
No point in providing different variants.

put_css_locked() will be used by later changes.  This patch doesn't
introduce any functional changes.

Signed-off-by: Tejun Heo <tj@kernel.org>
---
 kernel/cgroup.c | 50 +++++++++++++++++++++++---------------------------
 1 file changed, 23 insertions(+), 27 deletions(-)

diff --git a/kernel/cgroup.c b/kernel/cgroup.c
index 8c1f840..63d1a4e 100644
--- a/kernel/cgroup.c
+++ b/kernel/cgroup.c
@@ -369,22 +369,14 @@ static unsigned long css_set_hash(struct cgroup_subsys_state *css[])
 	return key;
 }
 
-static void __put_css_set(struct css_set *cset, int taskexit)
+static void put_css_set_locked(struct css_set *cset, bool taskexit)
 {
 	struct cgrp_cset_link *link, *tmp_link;
 
-	/*
-	 * Ensure that the refcount doesn't hit zero while any readers
-	 * can see it. Similar to atomic_dec_and_lock(), but for an
-	 * rwlock
-	 */
-	if (atomic_add_unless(&cset->refcount, -1, 1))
-		return;
-	down_write(&css_set_rwsem);
-	if (!atomic_dec_and_test(&cset->refcount)) {
-		up_write(&css_set_rwsem);
+	lockdep_assert_held(&css_set_rwsem);
+
+	if (!atomic_dec_and_test(&cset->refcount))
 		return;
-	}
 
 	/* This css_set is dead. unlink it and release cgroup refcounts */
 	hash_del(&cset->hlist);
@@ -406,10 +398,24 @@ static void __put_css_set(struct css_set *cset, int taskexit)
 		kfree(link);
 	}
 
-	up_write(&css_set_rwsem);
 	kfree_rcu(cset, rcu_head);
 }
 
+static void put_css_set(struct css_set *cset, bool taskexit)
+{
+	/*
+	 * Ensure that the refcount doesn't hit zero while any readers
+	 * can see it. Similar to atomic_dec_and_lock(), but for an
+	 * rwlock
+	 */
+	if (atomic_add_unless(&cset->refcount, -1, 1))
+		return;
+
+	down_write(&css_set_rwsem);
+	put_css_set_locked(cset, taskexit);
+	up_write(&css_set_rwsem);
+}
+
 /*
  * refcounted get/put for css_set objects
  */
@@ -418,16 +424,6 @@ static inline void get_css_set(struct css_set *cset)
 	atomic_inc(&cset->refcount);
 }
 
-static inline void put_css_set(struct css_set *cset)
-{
-	__put_css_set(cset, 0);
-}
-
-static inline void put_css_set_taskexit(struct css_set *cset)
-{
-	__put_css_set(cset, 1);
-}
-
 /**
  * compare_css_sets - helper function for find_existing_css_set().
  * @cset: candidate css_set being tested
@@ -1751,7 +1747,7 @@ static void cgroup_task_migrate(struct cgroup *old_cgrp,
 	 * we're safe to drop it here; it will be freed under RCU.
 	 */
 	set_bit(CGRP_RELEASABLE, &old_cgrp->flags);
-	put_css_set(old_cset);
+	put_css_set(old_cset, false);
 }
 
 /**
@@ -1897,7 +1893,7 @@ out_put_css_set_refs:
 			tc = flex_array_get(group, i);
 			if (!tc->cset)
 				break;
-			put_css_set(tc->cset);
+			put_css_set(tc->cset, false);
 		}
 	}
 out_cancel_attach:
@@ -3714,7 +3710,7 @@ static int cgroup_destroy_locked(struct cgroup *cgrp)
 
 	/*
 	 * css_set_rwsem synchronizes access to ->cset_links and prevents
-	 * @cgrp from being removed while __put_css_set() is in progress.
+	 * @cgrp from being removed while put_css_set() is in progress.
 	 */
 	down_read(&css_set_rwsem);
 	empty = list_empty(&cgrp->cset_links);
@@ -4266,7 +4262,7 @@ void cgroup_exit(struct task_struct *tsk, int run_callbacks)
 	}
 	task_unlock(tsk);
 
-	put_css_set_taskexit(cset);
+	put_css_set(cset, true);
 }
 
 static void check_for_release(struct cgroup *cgrp)
-- 
1.8.5.3

