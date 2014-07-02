Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754707AbaGBXw6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jul 2014 19:52:58 -0400
Received: from mail-qa0-f54.google.com ([209.85.216.54]:46730 "EHLO
	mail-qa0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751585AbaGBXvA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jul 2014 19:51:00 -0400
From: Tejun Heo <tj@kernel.org>
To: lizefan@huawei.com
Cc: cgroups@vger.kernel.org, linux-kernel@vger.kernel.org,
        Tejun Heo <tj@kernel.org>
Subject: [PATCH 1/5] cgroup: split cgroup_base_files[] into cgroup_{dfl|legacy}_base_files[]
Date: Wed,  2 Jul 2014 19:50:51 -0400
Message-Id: <1404345055-8196-2-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.9.3
In-Reply-To: <1404345055-8196-1-git-send-email-tj@kernel.org>
References: <1404345055-8196-1-git-send-email-tj@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Currently cgroup_base_files[] contains the cgroup core interface files
for both legacy and default hierarchies with each file tagged with
CFTYPE_INSANE and CFTYPE_ONLY_ON_DFL.  This is difficult to read.

Let's separate it out to two separate tables, cgroup_dfl_base_files[]
and cgroup_legacy_base_files[], and use the appropriate one in
cgroup_mkdir() depending on the hierarchy type.  This makes tagging
each file unnecessary.

This patch doesn't introduce any behavior changes.

Signed-off-by: Tejun Heo <tj@kernel.org>
---
 kernel/cgroup.c | 75 ++++++++++++++++++++++++++++++++++++---------------------
 1 file changed, 47 insertions(+), 28 deletions(-)

diff --git a/kernel/cgroup.c b/kernel/cgroup.c
index 1c56924..7210b3f 100644
--- a/kernel/cgroup.c
+++ b/kernel/cgroup.c
@@ -180,7 +180,8 @@ static u64 css_serial_nr_next = 1;
  */
 static int need_forkexit_callback __read_mostly;
 
-static struct cftype cgroup_base_files[];
+static struct cftype cgroup_dfl_base_files[];
+static struct cftype cgroup_legacy_base_files[];
 
 static void cgroup_put(struct cgroup *cgrp);
 static int rebind_subsystems(struct cgroup_root *dst_root,
@@ -1558,6 +1559,7 @@ static int cgroup_setup_root(struct cgroup_root *root, unsigned int ss_mask)
 {
 	LIST_HEAD(tmp_links);
 	struct cgroup *root_cgrp = &root->cgrp;
+	struct cftype *base_files;
 	struct css_set *cset;
 	int i, ret;
 
@@ -1595,7 +1597,12 @@ static int cgroup_setup_root(struct cgroup_root *root, unsigned int ss_mask)
 	}
 	root_cgrp->kn = root->kf_root->kn;
 
-	ret = cgroup_addrm_files(root_cgrp, cgroup_base_files, true);
+	if (root == &cgrp_dfl_root)
+		base_files = cgroup_dfl_base_files;
+	else
+		base_files = cgroup_legacy_base_files;
+
+	ret = cgroup_addrm_files(root_cgrp, base_files, true);
 	if (ret)
 		goto destroy_root;
 
@@ -3985,7 +3992,8 @@ static int cgroup_clone_children_write(struct cgroup_subsys_state *css,
 	return 0;
 }
 
-static struct cftype cgroup_base_files[] = {
+/* cgroup core interface files for the default hierarchy */
+static struct cftype cgroup_dfl_base_files[] = {
 	{
 		.name = "cgroup.procs",
 		.seq_start = cgroup_pidlist_start,
@@ -3997,46 +4005,51 @@ static struct cftype cgroup_base_files[] = {
 		.mode = S_IRUGO | S_IWUSR,
 	},
 	{
-		.name = "cgroup.clone_children",
-		.flags = CFTYPE_INSANE,
-		.read_u64 = cgroup_clone_children_read,
-		.write_u64 = cgroup_clone_children_write,
-	},
-	{
-		.name = "cgroup.sane_behavior",
-		.flags = CFTYPE_INSANE | CFTYPE_ONLY_ON_ROOT,
-		.seq_show = cgroup_sane_behavior_show,
-	},
-	{
 		.name = "cgroup.controllers",
-		.flags = CFTYPE_ONLY_ON_DFL | CFTYPE_ONLY_ON_ROOT,
+		.flags = CFTYPE_ONLY_ON_ROOT,
 		.seq_show = cgroup_root_controllers_show,
 	},
 	{
 		.name = "cgroup.controllers",
-		.flags = CFTYPE_ONLY_ON_DFL | CFTYPE_NOT_ON_ROOT,
+		.flags = CFTYPE_NOT_ON_ROOT,
 		.seq_show = cgroup_controllers_show,
 	},
 	{
 		.name = "cgroup.subtree_control",
-		.flags = CFTYPE_ONLY_ON_DFL,
 		.seq_show = cgroup_subtree_control_show,
 		.write = cgroup_subtree_control_write,
 	},
 	{
 		.name = "cgroup.populated",
-		.flags = CFTYPE_ONLY_ON_DFL | CFTYPE_NOT_ON_ROOT,
+		.flags = CFTYPE_NOT_ON_ROOT,
 		.seq_show = cgroup_populated_show,
 	},
+};
 
-	/*
-	 * Historical crazy stuff.  These don't have "cgroup."  prefix and
-	 * don't exist if sane_behavior.  If you're depending on these, be
-	 * prepared to be burned.
-	 */
+/* cgroup core interface files for the legacy hierarchies */
+static struct cftype cgroup_legacy_base_files[] = {
+	{
+		.name = "cgroup.procs",
+		.seq_start = cgroup_pidlist_start,
+		.seq_next = cgroup_pidlist_next,
+		.seq_stop = cgroup_pidlist_stop,
+		.seq_show = cgroup_pidlist_show,
+		.private = CGROUP_FILE_PROCS,
+		.write = cgroup_procs_write,
+		.mode = S_IRUGO | S_IWUSR,
+	},
+	{
+		.name = "cgroup.clone_children",
+		.read_u64 = cgroup_clone_children_read,
+		.write_u64 = cgroup_clone_children_write,
+	},
+	{
+		.name = "cgroup.sane_behavior",
+		.flags = CFTYPE_ONLY_ON_ROOT,
+		.seq_show = cgroup_sane_behavior_show,
+	},
 	{
 		.name = "tasks",
-		.flags = CFTYPE_INSANE,		/* use "procs" instead */
 		.seq_start = cgroup_pidlist_start,
 		.seq_next = cgroup_pidlist_next,
 		.seq_stop = cgroup_pidlist_stop,
@@ -4047,13 +4060,12 @@ static struct cftype cgroup_base_files[] = {
 	},
 	{
 		.name = "notify_on_release",
-		.flags = CFTYPE_INSANE,
 		.read_u64 = cgroup_read_notify_on_release,
 		.write_u64 = cgroup_write_notify_on_release,
 	},
 	{
 		.name = "release_agent",
-		.flags = CFTYPE_INSANE | CFTYPE_ONLY_ON_ROOT,
+		.flags = CFTYPE_ONLY_ON_ROOT,
 		.seq_show = cgroup_release_agent_show,
 		.write = cgroup_release_agent_write,
 		.max_write_len = PATH_MAX - 1,
@@ -4330,6 +4342,7 @@ static int cgroup_mkdir(struct kernfs_node *parent_kn, const char *name,
 	struct cgroup_root *root;
 	struct cgroup_subsys *ss;
 	struct kernfs_node *kn;
+	struct cftype *base_files;
 	int ssid, ret;
 
 	parent = cgroup_kn_lock_live(parent_kn);
@@ -4400,7 +4413,12 @@ static int cgroup_mkdir(struct kernfs_node *parent_kn, const char *name,
 	if (ret)
 		goto out_destroy;
 
-	ret = cgroup_addrm_files(cgrp, cgroup_base_files, true);
+	if (cgroup_on_dfl(cgrp))
+		base_files = cgroup_dfl_base_files;
+	else
+		base_files = cgroup_legacy_base_files;
+
+	ret = cgroup_addrm_files(cgrp, base_files, true);
 	if (ret)
 		goto out_destroy;
 
@@ -4719,7 +4737,8 @@ int __init cgroup_init(void)
 	unsigned long key;
 	int ssid, err;
 
-	BUG_ON(cgroup_init_cftypes(NULL, cgroup_base_files));
+	BUG_ON(cgroup_init_cftypes(NULL, cgroup_dfl_base_files));
+	BUG_ON(cgroup_init_cftypes(NULL, cgroup_legacy_base_files));
 
 	mutex_lock(&cgroup_mutex);
 
-- 
1.9.3

