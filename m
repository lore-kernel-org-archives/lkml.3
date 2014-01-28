Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932105AbaA1Pc0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Jan 2014 10:32:26 -0500
Received: from mail-qa0-f50.google.com ([209.85.216.50]:53980 "EHLO
	mail-qa0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932080AbaA1PcX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Jan 2014 10:32:23 -0500
From: Tejun Heo <tj@kernel.org>
To: lizefan@huawei.com
Cc: containers@lists.linux-foundation.org, cgroups@vger.kernel.org,
        linux-kernel@vger.kernel.org, Tejun Heo <tj@kernel.org>
Subject: [PATCH 4/4] cgroup: move the one-off opts sanity check in cgroup_root_from_opts() to parse_cgroupfs_options()
Date: Tue, 28 Jan 2014 10:32:05 -0500
Message-Id: <1390923125-4369-5-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.8.5.3
In-Reply-To: <1390923125-4369-1-git-send-email-tj@kernel.org>
References: <1390923125-4369-1-git-send-email-tj@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

cgroup_root_from_opts() checks whether (!opts->subsys_mask &&
!opts->none) and returns NULL if so.  After that, if allocation fails,
returns ERR_PTR(-ENOMEM).  The caller, cgroup_mount(), doesn't treat
NULL as an error but set opts.new_root to NULL; however, later on,
cgroup_set_super() fails with -EINVAL if new_root is NULL.

This is one bizarre error handling sequence especially when all other
opts sanity checks including the very close (!opts->subsys_mask &&
!opts->name) check are done in parse_cgroupfs_options().

Let's move the one-off check in cgroup_root_from_opts() to
parse_cgroupfs_options() where it can be combined with the
(!opts->subsys_mask && !opts->name) check.  cgroup_root_from_opts() is
updated to return NULL on memory allocation failure.

Signed-off-by: Tejun Heo <tj@kernel.org>
---
 kernel/cgroup.c | 19 ++++++-------------
 1 file changed, 6 insertions(+), 13 deletions(-)

diff --git a/kernel/cgroup.c b/kernel/cgroup.c
index b0e030f..5c8fe40 100644
--- a/kernel/cgroup.c
+++ b/kernel/cgroup.c
@@ -1265,10 +1265,10 @@ static int parse_cgroupfs_options(char *data, struct cgroup_sb_opts *opts)
 		return -EINVAL;
 
 	/*
-	 * We either have to specify by name or by subsystems. (So all
-	 * empty hierarchies must have a name).
+	 * We either have to specify by name or by subsystems.  All empty
+	 * hierarchies must have a name and also "none" option specified.
 	 */
-	if (!opts->subsys_mask && !opts->name)
+	if (!opts->subsys_mask && (!opts->name || !opts->none))
 		return -EINVAL;
 
 	return 0;
@@ -1417,12 +1417,9 @@ static struct cgroupfs_root *cgroup_root_from_opts(struct cgroup_sb_opts *opts)
 {
 	struct cgroupfs_root *root;
 
-	if (!opts->subsys_mask && !opts->none)
-		return NULL;
-
 	root = kzalloc(sizeof(*root), GFP_KERNEL);
 	if (!root)
-		return ERR_PTR(-ENOMEM);
+		return NULL;
 
 	init_cgroup_root(root);
 
@@ -1461,10 +1458,6 @@ static int cgroup_set_super(struct super_block *sb, void *data)
 	int ret;
 	struct cgroup_sb_opts *opts = data;
 
-	/* If we don't have a new root, we can't set up a new sb */
-	if (!opts->new_root)
-		return -EINVAL;
-
 	BUG_ON(!opts->subsys_mask && !opts->none);
 
 	ret = set_anon_super(sb, NULL);
@@ -1532,8 +1525,8 @@ static struct dentry *cgroup_mount(struct file_system_type *fs_type,
 	 * reusing an existing hierarchy.
 	 */
 	new_root = cgroup_root_from_opts(&opts);
-	if (IS_ERR(new_root)) {
-		ret = PTR_ERR(new_root);
+	if (!new_root) {
+		ret = -ENOMEM;
 		goto out_err;
 	}
 	opts.new_root = new_root;
-- 
1.8.5.3

