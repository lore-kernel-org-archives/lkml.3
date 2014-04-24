Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754420AbaDXVGt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Apr 2014 17:06:49 -0400
Received: from mail-qc0-f171.google.com ([209.85.216.171]:37445 "EHLO
	mail-qc0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753488AbaDXVC0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Apr 2014 17:02:26 -0400
From: Tejun Heo <tj@kernel.org>
To: lizefan@huawei.com
Cc: cgroups@vger.kernel.org, linux-kernel@vger.kernel.org, hannes@cmpxchg.org,
        mhocko@suse.cz, nasa4836@gmail.com, Tejun Heo <tj@kernel.org>
Subject: [PATCH 3/6] cgroup: protect cgroup_root->cgroup_idr with a spinlock
Date: Thu, 24 Apr 2014 17:02:10 -0400
Message-Id: <1398373333-1521-4-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.9.0
In-Reply-To: <1398373333-1521-1-git-send-email-tj@kernel.org>
References: <1398373333-1521-1-git-send-email-tj@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Currently, cgroup_root->cgroup_idr is protected by cgroup_mutex, which
ends up requiring cgroup_put() to be invoked under sleepable context.
This is okay for now but is an unusual requirement and we'll soon add
css->id which will have the same problem but won't be able to simply
grab cgroup_mutex as removal will have to happen from css_release()
which can't sleep.

Introduce cgroup_idr_lock and idr_alloc/replace/remove() wrappers
which protects the idr operations with the lock and use them for
cgroup_root->cgroup_idr.  cgroup_put() no longer needs to grab
cgroup_mutex and css_from_id() is updated to always require RCU read
lock instead of either RCU read lock or cgroup_mutex, which doesn't
affect the existing users.

Signed-off-by: Tejun Heo <tj@kernel.org>
---
 kernel/cgroup.c | 51 +++++++++++++++++++++++++++++++++++++++++++--------
 1 file changed, 43 insertions(+), 8 deletions(-)

diff --git a/kernel/cgroup.c b/kernel/cgroup.c
index 3fa0463..7cb9c08 100644
--- a/kernel/cgroup.c
+++ b/kernel/cgroup.c
@@ -100,6 +100,12 @@ static DECLARE_RWSEM(css_set_rwsem);
 #endif
 
 /*
+ * Protects cgroup_idr so that IDs can be released without grabbing
+ * cgroup_mutex.
+ */
+static DEFINE_SPINLOCK(cgroup_idr_lock);
+
+/*
  * Protects cgroup_subsys->release_agent_path.  Modifying it also requires
  * cgroup_mutex.  Reading requires either cgroup_mutex or this spinlock.
  */
@@ -190,6 +196,37 @@ static int cgroup_addrm_files(struct cgroup *cgrp, struct cftype cfts[],
 			      bool is_add);
 static void cgroup_pidlist_destroy_all(struct cgroup *cgrp);
 
+/* IDR wrappers which synchronize using cgroup_idr_lock */
+static int cgroup_idr_alloc(struct idr *idr, void *ptr, int start, int end,
+			    gfp_t gfp_mask)
+{
+	int ret;
+
+	idr_preload(gfp_mask);
+	spin_lock(&cgroup_idr_lock);
+	ret = idr_alloc(idr, ptr, start, end, gfp_mask);
+	spin_unlock(&cgroup_idr_lock);
+	idr_preload_end();
+	return ret;
+}
+
+static void *cgroup_idr_replace(struct idr *idr, void *ptr, int id)
+{
+	void *ret;
+
+	spin_lock(&cgroup_idr_lock);
+	ret = idr_replace(idr, ptr, id);
+	spin_unlock(&cgroup_idr_lock);
+	return ret;
+}
+
+static void cgroup_idr_remove(struct idr *idr, int id)
+{
+	spin_lock(&cgroup_idr_lock);
+	idr_remove(idr, id);
+	spin_unlock(&cgroup_idr_lock);
+}
+
 /**
  * cgroup_css - obtain a cgroup's css for the specified subsystem
  * @cgrp: the cgroup of interest
@@ -1058,9 +1095,7 @@ static void cgroup_put(struct cgroup *cgrp)
 	 * per-subsystem and moved to css->id so that lookups are
 	 * successful until the target css is released.
 	 */
-	mutex_lock(&cgroup_mutex);
-	idr_remove(&cgrp->root->cgroup_idr, cgrp->id);
-	mutex_unlock(&cgroup_mutex);
+	cgroup_idr_remove(&cgrp->root->cgroup_idr, cgrp->id);
 	cgrp->id = -1;
 
 	call_rcu(&cgrp->rcu_head, cgroup_free_rcu);
@@ -1531,7 +1566,7 @@ static int cgroup_setup_root(struct cgroup_root *root, unsigned int ss_mask)
 	lockdep_assert_held(&cgroup_tree_mutex);
 	lockdep_assert_held(&cgroup_mutex);
 
-	ret = idr_alloc(&root->cgroup_idr, root_cgrp, 1, 2, GFP_KERNEL);
+	ret = cgroup_idr_alloc(&root->cgroup_idr, root_cgrp, 1, 2, GFP_NOWAIT);
 	if (ret < 0)
 		goto out;
 	root_cgrp->id = ret;
@@ -4225,7 +4260,7 @@ static long cgroup_create(struct cgroup *parent, const char *name,
 	 * Temporarily set the pointer to NULL, so idr_find() won't return
 	 * a half-baked cgroup.
 	 */
-	cgrp->id = idr_alloc(&root->cgroup_idr, NULL, 2, 0, GFP_KERNEL);
+	cgrp->id = cgroup_idr_alloc(&root->cgroup_idr, NULL, 2, 0, GFP_NOWAIT);
 	if (cgrp->id < 0) {
 		err = -ENOMEM;
 		goto err_unlock;
@@ -4268,7 +4303,7 @@ static long cgroup_create(struct cgroup *parent, const char *name,
 	 * @cgrp is now fully operational.  If something fails after this
 	 * point, it'll be released via the normal destruction path.
 	 */
-	idr_replace(&root->cgroup_idr, cgrp, cgrp->id);
+	cgroup_idr_replace(&root->cgroup_idr, cgrp, cgrp->id);
 
 	err = cgroup_kn_set_ugid(kn);
 	if (err)
@@ -4302,7 +4337,7 @@ static long cgroup_create(struct cgroup *parent, const char *name,
 	return 0;
 
 err_free_id:
-	idr_remove(&root->cgroup_idr, cgrp->id);
+	cgroup_idr_remove(&root->cgroup_idr, cgrp->id);
 err_unlock:
 	mutex_unlock(&cgroup_mutex);
 err_unlock_tree:
@@ -5162,7 +5197,7 @@ struct cgroup_subsys_state *css_from_id(int id, struct cgroup_subsys *ss)
 {
 	struct cgroup *cgrp;
 
-	cgroup_assert_mutexes_or_rcu_locked();
+	WARN_ON_ONCE(!rcu_read_lock_held());
 
 	cgrp = idr_find(&ss->root->cgroup_idr, id);
 	if (cgrp)
-- 
1.9.0

