Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755487AbaCMTxd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Mar 2014 15:53:33 -0400
Received: from mail-qc0-f170.google.com ([209.85.216.170]:36869 "EHLO
	mail-qc0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755042AbaCMTuW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Mar 2014 15:50:22 -0400
From: Tejun Heo <tj@kernel.org>
To: lizefan@huawei.com
Cc: cgroups@vger.kernel.org, containers@lists.linux-foundation.org,
        linux-kernel@vger.kernel.org, Tejun Heo <tj@kernel.org>
Subject: [PATCH 04/11] cgroup: use cgroup_setup_root() to initialize cgroup_dummy_root
Date: Thu, 13 Mar 2014 15:50:06 -0400
Message-Id: <1394740213-17626-5-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.8.5.3
In-Reply-To: <1394740213-17626-1-git-send-email-tj@kernel.org>
References: <1394740213-17626-1-git-send-email-tj@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

cgroup_dummy_root is used to host controllers which aren't attached to
any other hierarchy.  The root is minimally set up during kernfs
bootstrap and didn't go through full hierarchy initialization.  We're
planning to use cgroup_dummy_root for the default unified hierarchy
and thus want it to be fully functional.

Replace the special initialization, which was collected into
cgroup_init() by the previous patch, with an invocation of
cgroup_setup_root().  This simplifies the init path and makes
cgroup_dummy_root a full hierarchy with its own kernfs_root and all.

As this puts the dummy hierarchy on the cgroup_roots list, rename
for_each_active_root() to for_each_root() and update its users to skip
the dummy root for now.

This patch doesn't cause any userland visible behavior changes at this
point.

Signed-off-by: Tejun Heo <tj@kernel.org>
---
 kernel/cgroup.c | 43 ++++++++++++++++++++-----------------------
 1 file changed, 20 insertions(+), 23 deletions(-)

diff --git a/kernel/cgroup.c b/kernel/cgroup.c
index 12a0bda..2483f4e 100644
--- a/kernel/cgroup.c
+++ b/kernel/cgroup.c
@@ -289,8 +289,8 @@ static int notify_on_release(const struct cgroup *cgrp)
 	for ((ssid) = 0; (ssid) < CGROUP_SUBSYS_COUNT &&		\
 	     (((ss) = cgroup_subsys[ssid]) || true); (ssid)++)
 
-/* iterate across the active hierarchies */
-#define for_each_active_root(root)					\
+/* iterate across the hierarchies */
+#define for_each_root(root)						\
 	list_for_each_entry((root), &cgroup_roots, root_list)
 
 /**
@@ -354,7 +354,6 @@ static struct css_set init_css_set = {
 	.mg_node		= LIST_HEAD_INIT(init_css_set.mg_node),
 };
 
-static struct cgrp_cset_link init_cgrp_cset_link;
 static int css_set_count	= 1;	/* 1 for init_css_set */
 
 /*
@@ -693,14 +692,13 @@ static struct cgroupfs_root *cgroup_root_from_kf(struct kernfs_root *kf_root)
 	return top_cgrp->root;
 }
 
-static int cgroup_init_root_id(struct cgroupfs_root *root, int start, int end)
+static int cgroup_init_root_id(struct cgroupfs_root *root)
 {
 	int id;
 
 	lockdep_assert_held(&cgroup_mutex);
 
-	id = idr_alloc_cyclic(&cgroup_hierarchy_idr, root, start, end,
-			      GFP_KERNEL);
+	id = idr_alloc_cyclic(&cgroup_hierarchy_idr, root, 0, 0, GFP_KERNEL);
 	if (id < 0)
 		return id;
 
@@ -1405,8 +1403,7 @@ static int cgroup_setup_root(struct cgroupfs_root *root, unsigned long ss_mask)
 	if (ret)
 		goto out;
 
-	/* ID 0 is reserved for dummy root, 1 for unified hierarchy */
-	ret = cgroup_init_root_id(root, 2, 0);
+	ret = cgroup_init_root_id(root);
 	if (ret)
 		goto out;
 
@@ -1486,9 +1483,12 @@ retry:
 		goto out_unlock;
 
 	/* look for a matching existing root */
-	for_each_active_root(root) {
+	for_each_root(root) {
 		bool name_match = false;
 
+		if (root == &cgroup_dummy_root)
+			continue;
+
 		/*
 		 * If we asked for a name then it must match.  Also, if
 		 * name matches but sybsys_mask doesn't, we should fail.
@@ -2106,9 +2106,12 @@ int cgroup_attach_task_all(struct task_struct *from, struct task_struct *tsk)
 	int retval = 0;
 
 	mutex_lock(&cgroup_mutex);
-	for_each_active_root(root) {
+	for_each_root(root) {
 		struct cgroup *from_cgrp;
 
+		if (root == &cgroup_dummy_root)
+			continue;
+
 		down_read(&css_set_rwsem);
 		from_cgrp = task_cgroup_from_root(from, root);
 		up_read(&css_set_rwsem);
@@ -4073,26 +4076,17 @@ int __init cgroup_init(void)
 
 	BUG_ON(cgroup_init_cftypes(NULL, cgroup_base_files));
 
-	/* allocate id for the dummy hierarchy */
+	mutex_lock(&cgroup_tree_mutex);
 	mutex_lock(&cgroup_mutex);
 
 	/* Add init_css_set to the hash table */
 	key = css_set_hash(init_css_set.subsys);
 	hash_add(css_set_table, &init_css_set.hlist, key);
 
-	BUG_ON(cgroup_init_root_id(&cgroup_dummy_root, 0, 1));
-
-	err = idr_alloc(&cgroup_dummy_root.cgroup_idr, cgroup_dummy_top,
-			0, 1, GFP_KERNEL);
-	BUG_ON(err < 0);
-
-	cgroup_root_count = 1;
-	init_cgrp_cset_link.cset = &init_css_set;
-	init_cgrp_cset_link.cgrp = cgroup_dummy_top;
-	list_add(&init_cgrp_cset_link.cset_link, &cgroup_dummy_top->cset_links);
-	list_add(&init_cgrp_cset_link.cgrp_link, &init_css_set.cgrp_links);
+	BUG_ON(cgroup_setup_root(&cgroup_dummy_root, 0));
 
 	mutex_unlock(&cgroup_mutex);
+	mutex_unlock(&cgroup_tree_mutex);
 
 	for_each_subsys(ss, ssid) {
 		if (!ss->early_init)
@@ -4176,11 +4170,14 @@ int proc_cgroup_show(struct seq_file *m, void *v)
 	mutex_lock(&cgroup_mutex);
 	down_read(&css_set_rwsem);
 
-	for_each_active_root(root) {
+	for_each_root(root) {
 		struct cgroup_subsys *ss;
 		struct cgroup *cgrp;
 		int ssid, count = 0;
 
+		if (root == &cgroup_dummy_root)
+			continue;
+
 		seq_printf(m, "%d:", root->hierarchy_id);
 		for_each_subsys(ss, ssid)
 			if (root->subsys_mask & (1 << ssid))
-- 
1.8.5.3

