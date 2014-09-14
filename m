Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753211AbaINWPf (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Sep 2014 18:15:35 -0400
Received: from mail.kernel.org ([198.145.19.201]:32898 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753076AbaINWOf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Sep 2014 18:14:35 -0400
From: Jaegeuk Kim <jaegeuk@kernel.org>
To: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        linux-f2fs-devel@lists.sourceforge.net
Cc: Jaegeuk Kim <jaegeuk@kernel.org>
Subject: [PATCH 08/10] f2fs: remove redundant operation during roll-forward recovery
Date: Sun, 14 Sep 2014 15:14:22 -0700
Message-Id: <1410732864-53069-8-git-send-email-jaegeuk@kernel.org>
X-Mailer: git-send-email 1.8.5.2 (Apple Git-48)
In-Reply-To: <1410732864-53069-1-git-send-email-jaegeuk@kernel.org>
References: <1410732864-53069-1-git-send-email-jaegeuk@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If same data is updated multiple times, we don't need to redo whole the
operations.
Let's just update the lastest one.

Signed-off-by: Jaegeuk Kim <jaegeuk@kernel.org>
---
 fs/f2fs/f2fs.h     |  4 +++-
 fs/f2fs/recovery.c | 41 +++++++++++++++++------------------------
 2 files changed, 20 insertions(+), 25 deletions(-)

diff --git a/fs/f2fs/f2fs.h b/fs/f2fs/f2fs.h
index 48d7d46..74dde99 100644
--- a/fs/f2fs/f2fs.h
+++ b/fs/f2fs/f2fs.h
@@ -137,7 +137,9 @@ struct discard_entry {
 struct fsync_inode_entry {
 	struct list_head list;	/* list head */
 	struct inode *inode;	/* vfs inode pointer */
-	block_t blkaddr;	/* block address locating the last inode */
+	block_t blkaddr;	/* block address locating the last fsync */
+	block_t last_dentry;	/* block address locating the last dentry */
+	block_t last_inode;	/* block address locating the last inode */
 };
 
 #define nats_in_cursum(sum)		(le16_to_cpu(sum->n_nats))
diff --git a/fs/f2fs/recovery.c b/fs/f2fs/recovery.c
index 6f7fbfa..95d9dc9 100644
--- a/fs/f2fs/recovery.c
+++ b/fs/f2fs/recovery.c
@@ -66,7 +66,7 @@ static struct fsync_inode_entry *get_fsync_inode(struct list_head *head,
 	return NULL;
 }
 
-static int recover_dentry(struct page *ipage, struct inode *inode)
+static int recover_dentry(struct inode *inode, struct page *ipage)
 {
 	struct f2fs_inode *raw_inode = F2FS_INODE(ipage);
 	nid_t pino = le32_to_cpu(raw_inode->i_pino);
@@ -140,7 +140,7 @@ out:
 	return err;
 }
 
-static void __recover_inode(struct inode *inode, struct page *page)
+static void recover_inode(struct inode *inode, struct page *page)
 {
 	struct f2fs_inode *raw = F2FS_INODE(page);
 
@@ -152,21 +152,9 @@ static void __recover_inode(struct inode *inode, struct page *page)
 	inode->i_atime.tv_nsec = le32_to_cpu(raw->i_mtime_nsec);
 	inode->i_ctime.tv_nsec = le32_to_cpu(raw->i_ctime_nsec);
 	inode->i_mtime.tv_nsec = le32_to_cpu(raw->i_mtime_nsec);
-}
-
-static int recover_inode(struct inode *inode, struct page *node_page)
-{
-	if (!IS_INODE(node_page))
-		return 0;
-
-	__recover_inode(inode, node_page);
-
-	if (is_dent_dnode(node_page))
-		return recover_dentry(node_page, inode);
 
 	f2fs_msg(inode->i_sb, KERN_NOTICE, "recover_inode: ino = %x, name = %s",
-			ino_of_node(node_page), F2FS_INODE(node_page)->i_name);
-	return 0;
+			ino_of_node(page), F2FS_INODE(page)->i_name);
 }
 
 static int find_fsync_dnodes(struct f2fs_sb_info *sbi, struct list_head *head)
@@ -214,12 +202,11 @@ static int find_fsync_dnodes(struct f2fs_sb_info *sbi, struct list_head *head)
 			}
 
 			/* add this fsync inode to the list */
-			entry = kmem_cache_alloc(fsync_entry_slab, GFP_NOFS);
+			entry = kmem_cache_alloc(fsync_entry_slab, GFP_F2FS_ZERO);
 			if (!entry) {
 				err = -ENOMEM;
 				break;
 			}
-
 			/*
 			 * CP | dnode(F) | inode(DF)
 			 * For this case, we should not give up now.
@@ -236,9 +223,11 @@ static int find_fsync_dnodes(struct f2fs_sb_info *sbi, struct list_head *head)
 		}
 		entry->blkaddr = blkaddr;
 
-		err = recover_inode(entry->inode, page);
-		if (err && err != -ENOENT)
-			break;
+		if (IS_INODE(page)) {
+			entry->last_inode = blkaddr;
+			if (is_dent_dnode(page))
+				entry->last_dentry = blkaddr;
+		}
 next:
 		/* check next segment */
 		blkaddr = next_blkaddr_of_node(page);
@@ -455,11 +444,15 @@ static int recover_data(struct f2fs_sb_info *sbi,
 		/*
 		 * inode(x) | CP | inode(x) | dnode(F)
 		 * In this case, we can lose the latest inode(x).
-		 * So, call __recover_inode for the inode update.
+		 * So, call recover_inode for the inode update.
 		 */
-		if (IS_INODE(page))
-			__recover_inode(entry->inode, page);
-
+		if (entry->last_inode == blkaddr)
+			recover_inode(entry->inode, page);
+		if (entry->last_dentry == blkaddr) {
+			err = recover_dentry(entry->inode, page);
+			if (err)
+				break;
+		}
 		err = do_recover_data(sbi, entry->inode, page, blkaddr);
 		if (err)
 			break;
-- 
1.8.5.2 (Apple Git-48)

