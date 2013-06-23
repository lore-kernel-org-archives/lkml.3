Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751169Ab3FWGH7 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Jun 2013 02:07:59 -0400
Received: from mail-pa0-f49.google.com ([209.85.220.49]:59237 "EHLO
	mail-pa0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751063Ab3FWGHz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Jun 2013 02:07:55 -0400
From: Namjae Jeon <linkinjeon@gmail.com>
To: tytso@mit.edu, adilger.kernel@dilger.ca
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-ext4@vger.kernel.org, a.sangwan@samsung.com,
        Namjae Jeon <linkinjeon@gmail.com>,
        Namjae Jeon <namjae.jeon@samsung.com>
Subject: [PATCH 2/3] ext4: make mext_next_extent non static and move get_ext_path
Date: Sun, 23 Jun 2013 15:07:48 +0900
Message-Id: <1371967668-3184-1-git-send-email-linkinjeon@gmail.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Namjae Jeon <namjae.jeon@samsung.com>

This patch makes mext_next_extent non static and moves the
defination of get_ext_path to ext4_extents.h as these 2
functions are used by EXT4_IOC_TRANSFER_BLOCK_RANGE introduced
in next patch.

Signed-off-by: Namjae Jeon <namjae.jeon@samsung.com>
Signed-off-by: Ashish Sangwan <a.sangwan@samsung.com>
---
 fs/ext4/ext4.h         |    2 ++
 fs/ext4/ext4_extents.h |   28 ++++++++++++++++++++++++++++
 fs/ext4/move_extent.c  |   31 +------------------------------
 3 files changed, 31 insertions(+), 30 deletions(-)

diff --git a/fs/ext4/ext4.h b/fs/ext4/ext4.h
index df2c411..246a03a 100644
--- a/fs/ext4/ext4.h
+++ b/fs/ext4/ext4.h
@@ -2712,6 +2712,8 @@ void ext4_inode_double_unlock(struct inode *inode1, struct inode *inode2);
 extern int ext4_move_extents(struct file *o_filp, struct file *d_filp,
 			     __u64 start_orig, __u64 start_donor,
 			     __u64 len, __u64 *moved_len);
+extern int mext_next_extent(struct inode *inode, struct ext4_ext_path *path,
+			    struct ext4_extent **extent);
 
 /* page-io.c */
 extern int __init ext4_init_pageio(void);
diff --git a/fs/ext4/ext4_extents.h b/fs/ext4/ext4_extents.h
index cc113cc..68f52a1 100644
--- a/fs/ext4/ext4_extents.h
+++ b/fs/ext4/ext4_extents.h
@@ -278,5 +278,33 @@ static inline void ext4_idx_store_pblock(struct ext4_extent_idx *ix,
 int __ext4_ext_dirty(const char *where, unsigned int line, handle_t *handle,
 		     struct inode *inode, struct ext4_ext_path *path);
 
+/**
+ * get_ext_path - Find an extent path for designated logical block number.
+ *
+ * @inode:	an inode which is searched
+ * @lblock:	logical block number to find an extent path
+ * @path:	pointer to an extent path pointer (for output)
+ *
+ * ext4_ext_find_extent wrapper. Return 0 on success, or a negative error value
+ * on failure.
+ */
+static inline int
+get_ext_path(struct inode *inode, ext4_lblk_t lblock,
+		struct ext4_ext_path **orig_path)
+{
+	int ret = 0;
+	struct ext4_ext_path *path;
+
+	path = ext4_ext_find_extent(inode, lblock, *orig_path);
+	if (IS_ERR(path))
+		ret = PTR_ERR(path);
+	else if (path[ext_depth(inode)].p_ext == NULL)
+		ret = -ENODATA;
+	else
+		*orig_path = path;
+
+	return ret;
+}
+
 #endif /* _EXT4_EXTENTS */
 
diff --git a/fs/ext4/move_extent.c b/fs/ext4/move_extent.c
index e86dddb..dd1e358 100644
--- a/fs/ext4/move_extent.c
+++ b/fs/ext4/move_extent.c
@@ -21,34 +21,6 @@
 #include "ext4_extents.h"
 
 /**
- * get_ext_path - Find an extent path for designated logical block number.
- *
- * @inode:	an inode which is searched
- * @lblock:	logical block number to find an extent path
- * @path:	pointer to an extent path pointer (for output)
- *
- * ext4_ext_find_extent wrapper. Return 0 on success, or a negative error value
- * on failure.
- */
-static inline int
-get_ext_path(struct inode *inode, ext4_lblk_t lblock,
-		struct ext4_ext_path **orig_path)
-{
-	int ret = 0;
-	struct ext4_ext_path *path;
-
-	path = ext4_ext_find_extent(inode, lblock, *orig_path);
-	if (IS_ERR(path))
-		ret = PTR_ERR(path);
-	else if (path[ext_depth(inode)].p_ext == NULL)
-		ret = -ENODATA;
-	else
-		*orig_path = path;
-
-	return ret;
-}
-
-/**
  * copy_extent_status - Copy the extent's initialization status
  *
  * @src:	an extent for getting initialize status
@@ -76,8 +48,7 @@ copy_extent_status(struct ext4_extent *src, struct ext4_extent *dest)
  * ext4_ext_path structure refers to the last extent, or a negative error
  * value on failure.
  */
-static int
-mext_next_extent(struct inode *inode, struct ext4_ext_path *path,
+int mext_next_extent(struct inode *inode, struct ext4_ext_path *path,
 		      struct ext4_extent **extent)
 {
 	struct ext4_extent_header *eh;
-- 
1.7.9.5

