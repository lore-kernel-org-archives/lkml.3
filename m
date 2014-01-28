Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932527AbaA1X76 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Jan 2014 18:59:58 -0500
Received: from mail-qc0-f173.google.com ([209.85.216.173]:53853 "EHLO
	mail-qc0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932325AbaA1X7z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Jan 2014 18:59:55 -0500
From: Tejun Heo <tj@kernel.org>
To: lizefan@huawei.com
Cc: containers@lists.linux-foundation.org, cgroups@vger.kernel.org,
        linux-kernel@vger.kernel.org, Tejun Heo <tj@kernel.org>
Subject: [PATCH 3/8] cgroup: remove cftype_set
Date: Tue, 28 Jan 2014 18:59:40 -0500
Message-Id: <1390953585-16554-4-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.8.5.3
In-Reply-To: <1390953585-16554-1-git-send-email-tj@kernel.org>
References: <1390953585-16554-1-git-send-email-tj@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

cftype_set was added primarily to allow registering the same cftype
array more than once for different subsystems.  Nobody uses or needs
such thing and it's already broken because each cftype has ->ss
pointer which is initialized during registration.

Let's add list_head ->node to cftype and use the first cftype entry in
the array to link them instead of allocating separate cftype_set.
While at it, trigger WARN if cft seems previously initialized during
registration.

This simplifies cftype handling a bit.

Signed-off-by: Tejun Heo <tj@kernel.org>
---
 include/linux/cgroup.h | 26 +++++++++-----------------
 kernel/cgroup.c        | 41 +++++++++++++----------------------------
 2 files changed, 22 insertions(+), 45 deletions(-)

diff --git a/include/linux/cgroup.h b/include/linux/cgroup.h
index 6fe238e..3c0c7e4 100644
--- a/include/linux/cgroup.h
+++ b/include/linux/cgroup.h
@@ -410,12 +410,11 @@ struct cftype {
 	unsigned int flags;
 
 	/*
-	 * The subsys this file belongs to.  Initialized automatically
-	 * during registration.  NULL for cgroup core files.
+	 * Fields used for internal bookkeeping.  Initialized automatically
+	 * during registration.
 	 */
-	struct cgroup_subsys *ss;
-
-	/* kernfs_ops to use, initialized automatically during registration */
+	struct cgroup_subsys *ss;	/* NULL for cgroup core files */
+	struct list_head node;		/* anchored at ss->cfts */
 	struct kernfs_ops *kf_ops;
 
 	/*
@@ -470,16 +469,6 @@ struct cftype {
 };
 
 /*
- * cftype_sets describe cftypes belonging to a subsystem and are chained at
- * cgroup_subsys->cftsets.  Each cftset points to an array of cftypes
- * terminated by zero length name.
- */
-struct cftype_set {
-	struct list_head		node;	/* chained at subsys->cftsets */
-	struct cftype			*cfts;
-};
-
-/*
  * See the comment above CGRP_ROOT_SANE_BEHAVIOR for details.  This
  * function can be called as long as @cgrp is accessible.
  */
@@ -595,8 +584,11 @@ struct cgroup_subsys {
 	/* link to parent, protected by cgroup_lock() */
 	struct cgroupfs_root *root;
 
-	/* list of cftype_sets */
-	struct list_head cftsets;
+	/*
+	 * List of cftypes.  Each entry is the first entry of an array
+	 * terminated by zero length name.
+	 */
+	struct list_head cfts;
 
 	/* base cftypes, automatically registered with subsys itself */
 	struct cftype *base_cftypes;
diff --git a/kernel/cgroup.c b/kernel/cgroup.c
index 16eaf82..64eccb2 100644
--- a/kernel/cgroup.c
+++ b/kernel/cgroup.c
@@ -1014,12 +1014,12 @@ static void cgroup_clear_dir(struct cgroup *cgrp, unsigned long subsys_mask)
 	int i;
 
 	for_each_subsys(ss, i) {
-		struct cftype_set *set;
+		struct cftype *cfts;
 
 		if (!test_bit(i, &subsys_mask))
 			continue;
-		list_for_each_entry(set, &ss->cftsets, node)
-			cgroup_addrm_files(cgrp, set->cfts, false);
+		list_for_each_entry(cfts, &ss->cfts, node)
+			cgroup_addrm_files(cgrp, cfts, false);
 	}
 }
 
@@ -2374,6 +2374,8 @@ static int cgroup_init_cftypes(struct cgroup_subsys *ss, struct cftype *cfts)
 	for (cft = cfts; cft->name[0] != '\0'; cft++) {
 		struct kernfs_ops *kf_ops;
 
+		WARN_ON(cft->ss || cft->kf_ops);
+
 		if (cft->seq_start)
 			kf_ops = &cgroup_kf_ops;
 		else
@@ -2412,26 +2414,15 @@ static int cgroup_init_cftypes(struct cgroup_subsys *ss, struct cftype *cfts)
  */
 int cgroup_rm_cftypes(struct cftype *cfts)
 {
-	struct cftype *found = NULL;
-	struct cftype_set *set;
-
 	if (!cfts || !cfts[0].ss)
 		return -ENOENT;
 
 	cgroup_cfts_prepare();
+	list_del(&cfts->node);
+	cgroup_cfts_commit(cfts, false);
 
-	list_for_each_entry(set, &cfts[0].ss->cftsets, node) {
-		if (set->cfts == cfts) {
-			list_del(&set->node);
-			kfree(set);
-			found = cfts;
-			break;
-		}
-	}
-
-	cgroup_cfts_commit(found, false);
 	cgroup_exit_cftypes(cfts);
-	return found ? 0 : -ENOENT;
+	return 0;
 }
 
 /**
@@ -2450,20 +2441,14 @@ int cgroup_rm_cftypes(struct cftype *cfts)
  */
 int cgroup_add_cftypes(struct cgroup_subsys *ss, struct cftype *cfts)
 {
-	struct cftype_set *set;
 	int ret;
 
-	set = kzalloc(sizeof(*set), GFP_KERNEL);
-	if (!set)
-		return -ENOMEM;
-
 	ret = cgroup_init_cftypes(ss, cfts);
 	if (ret)
 		return ret;
 
 	cgroup_cfts_prepare();
-	set->cfts = cfts;
-	list_add_tail(&set->node, &ss->cftsets);
+	list_add_tail(&cfts->node, &ss->cfts);
 	ret = cgroup_cfts_commit(cfts, true);
 	if (ret)
 		cgroup_rm_cftypes(cfts);
@@ -3556,13 +3541,13 @@ static int cgroup_populate_dir(struct cgroup *cgrp, unsigned long subsys_mask)
 
 	/* process cftsets of each subsystem */
 	for_each_subsys(ss, i) {
-		struct cftype_set *set;
+		struct cftype *cfts;
 
 		if (!test_bit(i, &subsys_mask))
 			continue;
 
-		list_for_each_entry(set, &ss->cftsets, node) {
-			ret = cgroup_addrm_files(cgrp, set->cfts, true);
+		list_for_each_entry(cfts, &ss->cfts, node) {
+			ret = cgroup_addrm_files(cgrp, cfts, true);
 			if (ret < 0)
 				goto err;
 		}
@@ -4151,7 +4136,7 @@ static void __init cgroup_init_subsys(struct cgroup_subsys *ss)
 	mutex_lock(&cgroup_tree_mutex);
 	mutex_lock(&cgroup_mutex);
 
-	INIT_LIST_HEAD(&ss->cftsets);
+	INIT_LIST_HEAD(&ss->cfts);
 
 	/* Create the top cgroup state for this subsystem */
 	ss->root = &cgroup_dummy_root;
-- 
1.8.5.3

