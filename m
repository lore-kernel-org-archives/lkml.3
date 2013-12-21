Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753842Ab3LUKCo (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Dec 2013 05:02:44 -0500
Received: from mailout4.samsung.com ([203.254.224.34]:36990 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753303Ab3LUKCk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Dec 2013 05:02:40 -0500
X-AuditID: cbfee61b-b7f456d000006dfd-c8-52b5673e42b2
From: Chao Yu <chao2.yu@samsung.com>
To: ??? <jaegeuk.kim@samsung.com>
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-f2fs-devel@lists.sourceforge.net
Subject: [f2fs-dev] [PATCH 2/3] f2fs: update several comments
Date: Sat, 21 Dec 2013 18:02:14 +0800
Message-id: <000101cefe33$c7e0aaa0$57a1ffe0$@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Outlook 14.0
Thread-index: Ac7+LlgIJfM4BObSRVGLgBb8E6h0+g==
Content-language: zh-cn
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrDLMWRmVeSWpSXmKPExsVy+t9jAV379K1BBk+PM1pc3/WXyeLSIneL
	PXtPslhc3jWHzYHFY/eCz0wefVtWMXp83iQXwBzFZZOSmpNZllqkb5fAlTHl4BHmgklKFftP
	xTYwvpLsYuTkkBAwkZjZd4YZwhaTuHBvPVsXIxeHkMAiRolrszexQDg/GCVOd/YygVSxCahI
	LO/4D2aLCChKbHi/gR3EZhbIlJjzejJrFyMHh7CArcSFTTIgYRYBVYmerStYQWxeAUuJS1tb
	GSFsQYkfk++xQLRqSazfeZwJwpaX2LzmLdRBChI7zr5mhFilJzFrRz8bRI24xMYjt1gmMArM
	QjJqFpJRs5CMmoWkZQEjyypG0dSC5ILipPRcI73ixNzi0rx0veT83E2M4DB+Jr2DcVWDxSFG
	AQ5GJR5eicgtQUKsiWXFlbmHGCU4mJVEeD+Gbg0S4k1JrKxKLcqPLyrNSS0+xCjNwaIkznuw
	1TpQSCA9sSQ1OzW1ILUIJsvEwSnVwOjELb3/remM71MFT129sHriMjfJGecT/kzjvbzaIPpn
	otn8Y51GQmmhsaz1vky+rH0rakStVIotOGfs//31pYDSkuvW2ysV5u2fHexguf+rA8uDwgNT
	rpxZedd1fsPs6gq5uGsO335byUe6pTzZtnSiaP62u+vbtri3seczZT16aruwRCPquYMSS3FG
	oqEWc1FxIgB1Mxc4XwIAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Update several comments:
1. use f2fs_{un}lock_op install of mutex_{un}lock_op.
2. update comment of get_data_block().
3. update description of node offset.

Signed-off-by: Chao Yu <chao2.yu@samsung.com>
---
 fs/f2fs/data.c |   14 ++++++++------
 fs/f2fs/dir.c  |    4 ++--
 fs/f2fs/f2fs.h |    2 +-
 fs/f2fs/node.c |    8 ++++----
 fs/f2fs/node.h |    8 +++++++-
 5 files changed, 22 insertions(+), 14 deletions(-)

diff --git a/fs/f2fs/data.c b/fs/f2fs/data.c
index a0950bc..bdc6093 100644
--- a/fs/f2fs/data.c
+++ b/fs/f2fs/data.c
@@ -516,8 +516,8 @@ repeat:
  * Caller ensures that this data page is never allocated.
  * A new zero-filled data page is allocated in the page cache.
  *
- * Also, caller should grab and release a mutex by calling mutex_lock_op() and
- * mutex_unlock_op().
+ * Also, caller should grab and release a rwsem by calling f2fs_lock_op() and
+ * f2fs_unlock_op().
  * Note that, npage is set only by make_empty_dir.
  */
 struct page *get_new_data_page(struct inode *inode,
@@ -603,10 +603,12 @@ static int __allocate_data_block(struct dnode_of_data *dn)
 }
 
 /*
- * This function should be used by the data read flow only where it
- * does not check the "create" flag that indicates block allocation.
- * The reason for this special functionality is to exploit VFS readahead
- * mechanism.
+ * get_data_block() now supported readahead/bmap/rw direct_IO with mapped bh.
+ * If original data blocks are allocated, then give them to blockdev.
+ * Otherwise,
+ *     a. preallocate requested block addresses
+ *     b. do not use extent cache for better performance
+ *     c. give the block addresses to blockdev
  */
 static int get_data_block(struct inode *inode, sector_t iblock,
 			struct buffer_head *bh_result, int create)
diff --git a/fs/f2fs/dir.c b/fs/f2fs/dir.c
index 3f3b661..9781400 100644
--- a/fs/f2fs/dir.c
+++ b/fs/f2fs/dir.c
@@ -429,8 +429,8 @@ next:
 }
 
 /*
- * Caller should grab and release a mutex by calling mutex_lock_op() and
- * mutex_unlock_op().
+ * Caller should grab and release a rwsem by calling f2fs_lock_op() and
+ * f2fs_unlock_op().
  */
 int __f2fs_add_link(struct inode *dir, const struct qstr *name, struct inode *inode)
 {
diff --git a/fs/f2fs/f2fs.h b/fs/f2fs/f2fs.h
index 8cbc5a6..97080f1 100644
--- a/fs/f2fs/f2fs.h
+++ b/fs/f2fs/f2fs.h
@@ -165,7 +165,7 @@ enum {
 	LOOKUP_NODE,			/* look up a node without readahead */
 	LOOKUP_NODE_RA,			/*
 					 * look up a node with readahead called
-					 * by get_datablock_ro.
+					 * by get_data_block.
 					 */
 };
 
diff --git a/fs/f2fs/node.c b/fs/f2fs/node.c
index 3565caf..768bd96 100644
--- a/fs/f2fs/node.c
+++ b/fs/f2fs/node.c
@@ -394,8 +394,8 @@ got:
 
 /*
  * Caller should call f2fs_put_dnode(dn).
- * Also, it should grab and release a mutex by calling mutex_lock_op() and
- * mutex_unlock_op() only if ro is not set RDONLY_NODE.
+ * Also, it should grab and release a rwsem by calling f2fs_lock_op() and
+ * f2fs_unlock_op() only if ro is not set RDONLY_NODE.
  * In the case of RDONLY_NODE, we don't need to care about mutex.
  */
 int get_dnode_of_data(struct dnode_of_data *dn, pgoff_t index, int mode)
@@ -803,8 +803,8 @@ int truncate_xattr_node(struct inode *inode, struct page *page)
 }
 
 /*
- * Caller should grab and release a mutex by calling mutex_lock_op() and
- * mutex_unlock_op().
+ * Caller should grab and release a rwsem by calling f2fs_lock_op() and
+ * f2fs_unlock_op().
  */
 void remove_inode_page(struct inode *inode)
 {
diff --git a/fs/f2fs/node.h b/fs/f2fs/node.h
index 3496bb3..c4c7988 100644
--- a/fs/f2fs/node.h
+++ b/fs/f2fs/node.h
@@ -224,7 +224,13 @@ static inline block_t next_blkaddr_of_node(struct page *node_page)
  *    |            `- direct node (5 + N => 5 + 2N - 1)
  *    `- double indirect node (5 + 2N)
  *                 `- indirect node (6 + 2N)
- *                       `- direct node (x(N + 1))
+ *                       `- direct node
+ *                 ......
+ *                 `- indirect node ((6 + 2N) + x(N + 1))
+ *                       `- direct node
+ *                 ......
+ *                 `- indirect node ((6 + 2N) + (N - 1)(N + 1))
+ *                       `- direct node
  */
 static inline bool IS_DNODE(struct page *node_page)
 {
-- 
1.7.9.5

