Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755278Ab3DLXML (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Apr 2013 19:12:11 -0400
Received: from mail-qe0-f44.google.com ([209.85.128.44]:64907 "EHLO
	mail-qe0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753976Ab3DLXLJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Apr 2013 19:11:09 -0400
From: Tejun Heo <tj@kernel.org>
To: lizefan@huawei.com
Cc: containers@lists.linux-foundation.org, cgroups@vger.kernel.org,
        mhocko@suse.cz, kamezawa.hiroyu@jp.fujitsu.com,
        linux-kernel@vger.kernel.org, glommer@parallels.com, vgoyal@redhat.com,
        Tejun Heo <tj@kernel.org>
Subject: [PATCH 1/4] cgroup: convert cgroupfs_root flag bits to masks and add CGRP_ prefix
Date: Fri, 12 Apr 2013 16:10:56 -0700
Message-Id: <1365808259-31073-2-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.8.1.4
In-Reply-To: <1365808259-31073-1-git-send-email-tj@kernel.org>
References: <1365808259-31073-1-git-send-email-tj@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There's no reason to be using bitops, which tends to be more
cumbersome, to handle root flags.  Convert them to masks.  Also, as
they'll be moved to include/linux/cgroup.h and it's generally a good
idea, add CGRP_ prefix.

Note that flags are assigned from (1 << 1).  The first bit will be
used by a flag which will be added soon.

Signed-off-by: Tejun Heo <tj@kernel.org>
---
 kernel/cgroup.c | 21 ++++++++++-----------
 1 file changed, 10 insertions(+), 11 deletions(-)

diff --git a/kernel/cgroup.c b/kernel/cgroup.c
index 678a22c..a372eaa 100644
--- a/kernel/cgroup.c
+++ b/kernel/cgroup.c
@@ -296,10 +296,10 @@ bool cgroup_is_descendant(struct cgroup *cgrp, struct cgroup *ancestor)
 }
 EXPORT_SYMBOL_GPL(cgroup_is_descendant);
 
-/* bits in struct cgroupfs_root flags field */
+/* cgroupfs_root->flags */
 enum {
-	ROOT_NOPREFIX,	/* mounted subsystems have no named prefix */
-	ROOT_XATTR,	/* supports extended attributes */
+	CGRP_ROOT_NOPREFIX	= (1 << 1), /* mounted subsystems have no named prefix */
+	CGRP_ROOT_XATTR		= (1 << 2), /* supports extended attributes */
 };
 
 static int cgroup_is_releasable(const struct cgroup *cgrp)
@@ -1137,9 +1137,9 @@ static int cgroup_show_options(struct seq_file *seq, struct dentry *dentry)
 	mutex_lock(&cgroup_root_mutex);
 	for_each_subsys(root, ss)
 		seq_printf(seq, ",%s", ss->name);
-	if (test_bit(ROOT_NOPREFIX, &root->flags))
+	if (root->flags & CGRP_ROOT_NOPREFIX)
 		seq_puts(seq, ",noprefix");
-	if (test_bit(ROOT_XATTR, &root->flags))
+	if (root->flags & CGRP_ROOT_XATTR)
 		seq_puts(seq, ",xattr");
 	if (strlen(root->release_agent_path))
 		seq_printf(seq, ",release_agent=%s", root->release_agent_path);
@@ -1202,7 +1202,7 @@ static int parse_cgroupfs_options(char *data, struct cgroup_sb_opts *opts)
 			continue;
 		}
 		if (!strcmp(token, "noprefix")) {
-			set_bit(ROOT_NOPREFIX, &opts->flags);
+			opts->flags |= CGRP_ROOT_NOPREFIX;
 			continue;
 		}
 		if (!strcmp(token, "clone_children")) {
@@ -1210,7 +1210,7 @@ static int parse_cgroupfs_options(char *data, struct cgroup_sb_opts *opts)
 			continue;
 		}
 		if (!strcmp(token, "xattr")) {
-			set_bit(ROOT_XATTR, &opts->flags);
+			opts->flags |= CGRP_ROOT_XATTR;
 			continue;
 		}
 		if (!strncmp(token, "release_agent=", 14)) {
@@ -1293,8 +1293,7 @@ static int parse_cgroupfs_options(char *data, struct cgroup_sb_opts *opts)
 	 * with the old cpuset, so we allow noprefix only if mounting just
 	 * the cpuset subsystem.
 	 */
-	if (test_bit(ROOT_NOPREFIX, &opts->flags) &&
-	    (opts->subsys_mask & mask))
+	if ((opts->flags & CGRP_ROOT_NOPREFIX) && (opts->subsys_mask & mask))
 		return -EINVAL;
 
 
@@ -2523,7 +2522,7 @@ static struct simple_xattrs *__d_xattrs(struct dentry *dentry)
 static inline int xattr_enabled(struct dentry *dentry)
 {
 	struct cgroupfs_root *root = dentry->d_sb->s_fs_info;
-	return test_bit(ROOT_XATTR, &root->flags);
+	return root->flags & CGRP_ROOT_XATTR;
 }
 
 static bool is_valid_xattr(const char *name)
@@ -2695,7 +2694,7 @@ static int cgroup_add_file(struct cgroup *cgrp, struct cgroup_subsys *subsys,
 
 	simple_xattrs_init(&cft->xattrs);
 
-	if (subsys && !test_bit(ROOT_NOPREFIX, &cgrp->root->flags)) {
+	if (subsys && !(cgrp->root->flags & CGRP_ROOT_NOPREFIX)) {
 		strcpy(name, subsys->name);
 		strcat(name, ".");
 	}
-- 
1.8.1.4

