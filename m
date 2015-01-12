Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751670AbbALHOT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Jan 2015 02:14:19 -0500
Received: from mailout4.samsung.com ([203.254.224.34]:31475 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751105AbbALHOS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Jan 2015 02:14:18 -0500
X-AuditID: cbfee61a-f79c06d000004e71-b0-54b3744806e8
From: Chao Yu <chao2.yu@samsung.com>
To: Jaegeuk Kim <jaegeuk@kernel.org>, Changman Lee <cm224.lee@samsung.com>
Cc: linux-f2fs-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org
Subject: [f2fs-dev][RFC PATCH 05/10] f2fs: introduce infra macro and data
 structure of rb-tree extent cache
Date: Mon, 12 Jan 2015 15:13:32 +0800
Message-id: <000901d02e37$60f21060$22d63120$@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Outlook 14.0
Thread-index: AdAszU1hSruBiEOmTbqP0XU3zHsZrw==
Content-language: zh-cn
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrALMWRmVeSWpSXmKPExsVy+t9jAV2Pks0hBs9/yVtc29fIZPFk/Sxm
	i0uL3C0u75rD5sDisWlVJ5vH7gWfmTz6tqxi9Pi8SS6AJYrLJiU1J7MstUjfLoEro32XScFz
	qYqm5pOsDYx7RbsYOTgkBEwkPk7K7WLkBDLFJC7cW8/WxcjFISSwiFFixo5eZgjnB6PE1nUz
	2EGq2ARUJJZ3/GcCsUUEvCQm7T/BAmIzC3hINHZ8ZwWxhQVyJZ6dXwZWwyKgKjH733sWkGW8
	ApYSx5Zyg4R5BQQlfky+B9WqJbF+53EmCFteYvOat8wQBylI7Dj7mhFilZ7E5p7bUDXiEhuP
	3GKZwCgwC8moWUhGzUIyahaSlgWMLKsYRVMLkguKk9JzDfWKE3OLS/PS9ZLzczcxgsP5mdQO
	xpUNFocYBTgYlXh4LaQ2hwixJpYVV+YeYpTgYFYS4Q2zBgrxpiRWVqUW5ccXleakFh9ilOZg
	URLnVbJvCxESSE8sSc1OTS1ILYLJMnFwSjUwrtv0Ldhse1R5ppR3cWKM655LDZbHH1xpYjKz
	il/GaV+kMG1y7UIvHjZnx8vnvgh0cvY9W2k8P3GRvIKz9cvW3XM+nDjR/830/ySWgE2Rkreq
	Dyumf+lRm2Ks67reP9D94YLbK1rV/0/mNH6/9qZ6AKc8z1uF5nK+S5GHXDSEYro7mO3SxIKU
	WIozEg21mIuKEwG1yjKrYwIAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Introduce infra macro and data structure for rb-tree based extent cache:

Macros:
 * EXT_TREE_VEC_SIZE: indicate vector size for gang lookup in extent tree.
 * F2FS_MIN_EXTENT_LEN: indicate minimum length of extent managed in cache.
 * EXTENT_CACHE_SHRINK_NUMBER: indicate number of extent in cache will be shrunk.

Basic data structures for extent cache:
 * struct extent_tree: extent tree entry per inode.
 * struct extent_node: extent info node linked in extent tree.

Besides, adding new extent cache related fields in f2fs_sb_info.

Signed-off-by: Chao Yu <chao2.yu@samsung.com>
Signed-off-by: Jaegeuk Kim <jaegeuk@kernel.org>
Signed-off-by: Changman Lee <cm224.lee@samsung.com>
---
 fs/f2fs/f2fs.h | 36 ++++++++++++++++++++++++++++++++----
 fs/f2fs/node.h |  1 +
 2 files changed, 33 insertions(+), 4 deletions(-)

diff --git a/fs/f2fs/f2fs.h b/fs/f2fs/f2fs.h
index eb9ffae..6decfd2 100644
--- a/fs/f2fs/f2fs.h
+++ b/fs/f2fs/f2fs.h
@@ -267,13 +267,33 @@ enum {
 
 #define MAX_DIR_RA_PAGES	4	/* maximum ra pages of dir */
 
+/* vector size for gang look-up from extent cache that consists of radix tree */
+#define EXT_TREE_VEC_SIZE	64
+
 /* for in-memory extent cache entry */
-#define F2FS_MIN_EXTENT_LEN	16	/* minimum extent length */
+#define F2FS_MIN_EXTENT_LEN	64	/* minimum extent length */
+
+/* number of extent info in extent cache we try to shrink */
+#define EXTENT_CACHE_SHRINK_NUMBER	128
 
 struct extent_info {
-	unsigned int fofs;	/* start offset in a file */
-	u32 blk;		/* start block address of the extent */
-	unsigned int len;	/* length of the extent */
+	unsigned int fofs;		/* start offset in a file */
+	u32 blk;			/* start block address of the extent */
+	unsigned int len;		/* length of the extent */
+};
+
+struct extent_node {
+	struct rb_node rb_node;		/* rb node located in rb-tree */
+	struct list_head list;		/* node in global extent list of sbi */
+	struct extent_info ei;		/* extent info */
+};
+
+struct extent_tree {
+	nid_t ino;			/* inode number */
+	struct rb_root root;		/* root of extent info rb-tree */
+	rwlock_t lock;			/* protect extent info rb-tree */
+	atomic_t refcount;		/* reference count of rb-tree */
+	unsigned int count;		/* # of extent node in rb-tree*/
 };
 
 /*
@@ -552,6 +572,14 @@ struct f2fs_sb_info {
 	struct list_head dir_inode_list;	/* dir inode list */
 	spinlock_t dir_inode_lock;		/* for dir inode list lock */
 
+	/* for extent tree cache */
+	struct radix_tree_root extent_tree_root;/* cache extent cache entries */
+	struct rw_semaphore extent_tree_lock;	/* locking extent radix tree */
+	struct list_head extent_list;		/* lru list for shrinker */
+	spinlock_t extent_lock;			/* locking extent lru list */
+	int total_ext_tree;			/* extent tree count */
+	atomic_t total_ext_node;		/* extent info count */
+
 	/* basic filesystem units */
 	unsigned int log_sectors_per_block;	/* log2 sectors per block */
 	unsigned int log_blocksize;		/* log2 block size */
diff --git a/fs/f2fs/node.h b/fs/f2fs/node.h
index f405bbf..c56026f 100644
--- a/fs/f2fs/node.h
+++ b/fs/f2fs/node.h
@@ -120,6 +120,7 @@ enum mem_type {
 	NAT_ENTRIES,	/* indicates the cached nat entry */
 	DIRTY_DENTS,	/* indicates dirty dentry pages */
 	INO_ENTRIES,	/* indicates inode entries */
+	EXTENT_CACHE,	/* indicates extent cache */
 	BASE_CHECK,	/* check kernel status */
 };
 
-- 
2.2.1


