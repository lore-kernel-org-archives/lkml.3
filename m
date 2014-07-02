Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752385AbaGBXqI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jul 2014 19:46:08 -0400
Received: from mail-qa0-f42.google.com ([209.85.216.42]:63187 "EHLO
	mail-qa0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751754AbaGBXqD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jul 2014 19:46:03 -0400
From: Tejun Heo <tj@kernel.org>
To: lizefan@huawei.com
Cc: cgroups@vger.kernel.org, linux-kernel@vger.kernel.org,
        Tejun Heo <tj@kernel.org>
Subject: [PATCH 1/4] cgroup: remove CGRP_ROOT_OPTION_MASK
Date: Wed,  2 Jul 2014 19:45:44 -0400
Message-Id: <1404344747-7957-2-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.9.3
In-Reply-To: <1404344747-7957-1-git-send-email-tj@kernel.org>
References: <1404344747-7957-1-git-send-email-tj@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

cgroup_root->flags only contains CGRP_ROOT_* flags and there's no
reason to mask the flags.  Remove CGRP_ROOT_OPTION_MASK.

This doesn't cause any behavior differences.

Signed-off-by: Tejun Heo <tj@kernel.org>
---
 include/linux/cgroup.h | 3 ---
 kernel/cgroup.c        | 7 +++----
 2 files changed, 3 insertions(+), 7 deletions(-)

diff --git a/include/linux/cgroup.h b/include/linux/cgroup.h
index 8a111dd..7748e5b 100644
--- a/include/linux/cgroup.h
+++ b/include/linux/cgroup.h
@@ -312,9 +312,6 @@ enum {
 
 	CGRP_ROOT_NOPREFIX	= (1 << 1), /* mounted subsystems have no named prefix */
 	CGRP_ROOT_XATTR		= (1 << 2), /* supports extended attributes */
-
-	/* mount options live below bit 16 */
-	CGRP_ROOT_OPTION_MASK	= (1 << 16) - 1,
 };
 
 /*
diff --git a/kernel/cgroup.c b/kernel/cgroup.c
index 7868fc3..e27f4d4 100644
--- a/kernel/cgroup.c
+++ b/kernel/cgroup.c
@@ -1434,11 +1434,10 @@ static int cgroup_remount(struct kernfs_root *kf_root, int *flags, char *data)
 	removed_mask = root->subsys_mask & ~opts.subsys_mask;
 
 	/* Don't allow flags or name to change at remount */
-	if (((opts.flags ^ root->flags) & CGRP_ROOT_OPTION_MASK) ||
+	if ((opts.flags ^ root->flags) ||
 	    (opts.name && strcmp(opts.name, root->name))) {
 		pr_err("option or name mismatch, new: 0x%x \"%s\", old: 0x%x \"%s\"\n",
-		       opts.flags & CGRP_ROOT_OPTION_MASK, opts.name ?: "",
-		       root->flags & CGRP_ROOT_OPTION_MASK, root->name);
+		       opts.flags, opts.name ?: "", root->flags, root->name);
 		ret = -EINVAL;
 		goto out_unlock;
 	}
@@ -1706,7 +1705,7 @@ static struct dentry *cgroup_mount(struct file_system_type *fs_type,
 			goto out_unlock;
 		}
 
-		if ((root->flags ^ opts.flags) & CGRP_ROOT_OPTION_MASK) {
+		if (root->flags ^ opts.flags) {
 			if ((root->flags | opts.flags) & CGRP_ROOT_SANE_BEHAVIOR) {
 				pr_err("sane_behavior: new mount options should match the existing superblock\n");
 				ret = -EINVAL;
-- 
1.9.3

