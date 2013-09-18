Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753876Ab3IRVPx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Sep 2013 17:15:53 -0400
Received: from mail-vc0-f176.google.com ([209.85.220.176]:45822 "EHLO
	mail-vc0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753714Ab3IRVPs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Sep 2013 17:15:48 -0400
From: Tejun Heo <tj@kernel.org>
To: gregkh@linuxfoundation.org
Cc: kay@vrfy.org, linux-kernel@vger.kernel.org, ebiederm@xmission.com,
        Tejun Heo <tj@kernel.org>
Subject: [PATCH 3/4] sysfs: make __sysfs_remove_dir() recursive
Date: Wed, 18 Sep 2013 17:15:37 -0400
Message-Id: <1379538938-5032-4-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1379538938-5032-1-git-send-email-tj@kernel.org>
References: <1379538938-5032-1-git-send-email-tj@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Currently, sysfs directory removal is inconsistent in that it would
remove any files directly under it but wouldn't recurse into
directories.  Thanks to group subdirectories, this doesn't even match
with kobject boundaries.  sysfs is in the process of being separated
out so that it can be used by multiple subsystems and we want to have
a consistent behavior - either removal of a sysfs_dirent should remove
every descendant entries or none instead of something inbetween.

This patch implements proper recursive removal in
__sysfs_remove_dir().  The function now walks its subtree in a
post-order walk to remove all descendants.

This is a behavior change but kobject / driver layer, which currently
is the only consumer, has already been updated to handle duplicate
removal attempts, so nothing should be broken after this change.

Signed-off-by: Tejun Heo <tj@kernel.org>
---
 fs/sysfs/dir.c | 75 +++++++++++++++++++++++++++++++++++++++++++++++++---------
 1 file changed, 64 insertions(+), 11 deletions(-)

diff --git a/fs/sysfs/dir.c b/fs/sysfs/dir.c
index 105a7e2..0cdfd81 100644
--- a/fs/sysfs/dir.c
+++ b/fs/sysfs/dir.c
@@ -789,27 +789,81 @@ void sysfs_remove_subdir(struct sysfs_dirent *sd)
 	remove_dir(sd);
 }
 
+static struct sysfs_dirent *sysfs_leftmost_descendant(struct sysfs_dirent *pos)
+{
+	struct sysfs_dirent *last;
+
+	while (true) {
+		struct rb_node *rbn;
+
+		last = pos;
+
+		if (sysfs_type(pos) != SYSFS_DIR)
+			break;
+
+		rbn = rb_first(&pos->s_dir.children);
+		if (!rbn)
+			break;
+
+		pos = to_sysfs_dirent(rbn);
+	}
+
+	return last;
+}
+
+/**
+ * sysfs_next_descendant_post - find the next descendant for post-order walk
+ * @pos: the current position (%NULL to initiate traversal)
+ * @root: sysfs_dirent whose descendants to walk
+ *
+ * Find the next descendant to visit for post-order traversal of @root's
+ * descendants.  @root is included in the iteration and the last node to be
+ * visited.
+ */
+static struct sysfs_dirent *sysfs_next_descendant_post(struct sysfs_dirent *pos,
+						       struct sysfs_dirent *root)
+{
+	struct rb_node *rbn;
+
+	lockdep_assert_held(&sysfs_mutex);
+
+	/* if first iteration, visit leftmost descendant which may be root */
+	if (!pos)
+		return sysfs_leftmost_descendant(root);
+
+	/* if we visited @root, we're done */
+	if (pos == root)
+		return NULL;
+
+	/* if there's an unvisited sibling, visit its leftmost descendant */
+	rbn = rb_next(&pos->s_rb);
+	if (rbn)
+		return sysfs_leftmost_descendant(to_sysfs_dirent(rbn));
+
+	/* no sibling left, visit parent */
+	return pos->s_parent;
+}
 
 static void __sysfs_remove_dir(struct sysfs_dirent *dir_sd)
 {
 	struct sysfs_addrm_cxt acxt;
-	struct rb_node *pos;
+	struct sysfs_dirent *pos, *next;
 
 	if (!dir_sd)
 		return;
 
 	pr_debug("sysfs %s: removing dir\n", dir_sd->s_name);
 	sysfs_addrm_start(&acxt);
-	pos = rb_first(&dir_sd->s_dir.children);
-	while (pos) {
-		struct sysfs_dirent *sd = to_sysfs_dirent(pos);
-		pos = rb_next(pos);
-		if (sysfs_type(sd) != SYSFS_DIR)
-			sysfs_remove_one(&acxt, sd);
-	}
-	sysfs_addrm_finish(&acxt);
 
-	remove_dir(dir_sd);
+	next = NULL;
+	do {
+		pos = next;
+		next = sysfs_next_descendant_post(pos, dir_sd);
+		if (pos)
+			sysfs_remove_one(&acxt, pos);
+	} while (next);
+
+	sysfs_addrm_finish(&acxt);
 }
 
 /**
@@ -820,7 +874,6 @@ static void __sysfs_remove_dir(struct sysfs_dirent *dir_sd)
  *	the directory before we remove the directory, and we've inlined
  *	what used to be sysfs_rmdir() below, instead of calling separately.
  */
-
 void sysfs_remove_dir(struct kobject *kobj)
 {
 	struct sysfs_dirent *sd = kobj->sd;
-- 
1.8.3.1

