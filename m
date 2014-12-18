Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751905AbaLRJiO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Dec 2014 04:38:14 -0500
Received: from mailout1.samsung.com ([203.254.224.24]:63060 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750983AbaLRJiL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Dec 2014 04:38:11 -0500
X-AuditID: cbfee61b-f79d76d0000024d6-72-5492a081c0c7
From: Chao Yu <chao2.yu@samsung.com>
To: Jaegeuk Kim <jaegeuk@kernel.org>, Changman Lee <cm224.lee@samsung.com>
Cc: linux-f2fs-devel@lists.sourceforge.net, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [f2fs-dev] [PATCH v3] f2fs: merge two uchar variable in struct
 node_info to reduce memory cost
Date: Thu, 18 Dec 2014 17:37:21 +0800
Message-id: <005201d01aa6$5593d770$00bb8650$@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Outlook 14.0
Thread-index: AdAapi51LW0nL8ktQYyl++3eT+6mWQ==
Content-language: zh-cn
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrOLMWRmVeSWpSXmKPExsVy+t9jAd3GBZNCDH7ck7e4tq+RyeLJ+lnM
	FpcWuVvs2XuSxeLyrjlsDqwem1Z1snnsXvCZyaNvyypGj8+b5AJYorhsUlJzMstSi/TtErgy
	Fv08wlrQKFuxdGkLWwPjW7EuRk4OCQETiZ8z5zNC2GISF+6tZ+ti5OIQEljEKLHqx14o5wej
	xIT9u8Gq2ARUJJZ3/GcCsUUEvCQm7T/BAmIzC2RK3GuawdzFyMEhDGQ3/g8GCbMIqEo83nGB
	DcTmFbCUmL7+KxOELSjxY/I9qFYtifU7jzNB2PISm9e8ZYY4SEFix9nXjBCr9CSefFnIDlEj
	LrHxyC2WCYwCs5CMmoVk1Cwko2YhaVnAyLKKUTS1ILmgOCk910ivODG3uDQvXS85P3cTIzi4
	n0nvYFzVYHGIUYCDUYmHV0JvUogQa2JZcWXuIUYJDmYlEd7oHKAQb0piZVVqUX58UWlOavEh
	RmkOFiVxXiX7thAhgfTEktTs1NSC1CKYLBMHp1QDY2dxncXSVXGqPd+3sJUo5R5yuv/g0rOz
	mXZXLEvzZB/v/RBWK/Fa8vzSQ28WvH/Bd5qn4lpq4Kv9xbfXhfZY7DvVabYwdHfgxtzA+3U9
	ohm+R+ZWV5/IWh+za+VFiScfb/y3k/dhm/VZaY/rND2W+2a9f441FYYo7Nutds5NZufk97Y5
	MUde31ViKc5INNRiLipOBAAEhv0yagIAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch moves one member of struct nat_entry: _flag_ to struct node_info,
so _version_ in struct node_info and _flag_ which are unsigned char type will
merge to one 32-bit space in register/memory. So the size of nat_entry will be
reduced from 28 bytes to 24 bytes (for 64-bit machine, reduce its size from 40
bytes to 32 bytes) and then slab memory using by f2fs will be reduced.

changes from v2:
 o update description of memory usage gain for 64-bit machine suggested by
   Changman Lee.
changes from v1:
 o introduce inline copy_node_info() to copy valid data from node info suggested
   by Jaegeuk Kim, it can avoid bug.

Reviewed-by: Changman Lee <cm224.lee@samsung.com>
Signed-off-by: Chao Yu <chao2.yu@samsung.com>
---
 fs/f2fs/node.c |  4 ++--
 fs/f2fs/node.h | 33 ++++++++++++++++++++++-----------
 2 files changed, 24 insertions(+), 13 deletions(-)

diff --git a/fs/f2fs/node.c b/fs/f2fs/node.c
index f83326c..5aa54a0 100644
--- a/fs/f2fs/node.c
+++ b/fs/f2fs/node.c
@@ -268,7 +268,7 @@ static void set_node_addr(struct f2fs_sb_info *sbi, struct node_info *ni,
 	e = __lookup_nat_cache(nm_i, ni->nid);
 	if (!e) {
 		e = grab_nat_entry(nm_i, ni->nid);
-		e->ni = *ni;
+		copy_node_info(&e->ni, ni);
 		f2fs_bug_on(sbi, ni->blk_addr == NEW_ADDR);
 	} else if (new_blkaddr == NEW_ADDR) {
 		/*
@@ -276,7 +276,7 @@ static void set_node_addr(struct f2fs_sb_info *sbi, struct node_info *ni,
 		 * previous nat entry can be remained in nat cache.
 		 * So, reinitialize it with new information.
 		 */
-		e->ni = *ni;
+		copy_node_info(&e->ni, ni);
 		f2fs_bug_on(sbi, ni->blk_addr != NULL_ADDR);
 	}
 
diff --git a/fs/f2fs/node.h b/fs/f2fs/node.h
index d10b644..eb59167 100644
--- a/fs/f2fs/node.h
+++ b/fs/f2fs/node.h
@@ -29,6 +29,14 @@
 /* return value for read_node_page */
 #define LOCKED_PAGE	1
 
+/* For flag in struct node_info */
+enum {
+	IS_CHECKPOINTED,	/* is it checkpointed before? */
+	HAS_FSYNCED_INODE,	/* is the inode fsynced before? */
+	HAS_LAST_FSYNC,		/* has the latest node fsync mark? */
+	IS_DIRTY,		/* this nat entry is dirty? */
+};
+
 /*
  * For node information
  */
@@ -37,18 +45,11 @@ struct node_info {
 	nid_t ino;		/* inode number of the node's owner */
 	block_t	blk_addr;	/* block address of the node */
 	unsigned char version;	/* version of the node */
-};
-
-enum {
-	IS_CHECKPOINTED,	/* is it checkpointed before? */
-	HAS_FSYNCED_INODE,	/* is the inode fsynced before? */
-	HAS_LAST_FSYNC,		/* has the latest node fsync mark? */
-	IS_DIRTY,		/* this nat entry is dirty? */
+	unsigned char flag;	/* for node information bits */
 };
 
 struct nat_entry {
 	struct list_head list;	/* for clean or dirty nat list */
-	unsigned char flag;	/* for node information bits */
 	struct node_info ni;	/* in-memory node information */
 };
 
@@ -63,20 +64,30 @@ struct nat_entry {
 
 #define inc_node_version(version)	(++version)
 
+static inline void copy_node_info(struct node_info *dst,
+						struct node_info *src)
+{
+	dst->nid = src->nid;
+	dst->ino = src->ino;
+	dst->blk_addr = src->blk_addr;
+	dst->version = src->version;
+	/* should not copy flag here */
+}
+
 static inline void set_nat_flag(struct nat_entry *ne,
 				unsigned int type, bool set)
 {
 	unsigned char mask = 0x01 << type;
 	if (set)
-		ne->flag |= mask;
+		ne->ni.flag |= mask;
 	else
-		ne->flag &= ~mask;
+		ne->ni.flag &= ~mask;
 }
 
 static inline bool get_nat_flag(struct nat_entry *ne, unsigned int type)
 {
 	unsigned char mask = 0x01 << type;
-	return ne->flag & mask;
+	return ne->ni.flag & mask;
 }
 
 static inline void nat_reset_flag(struct nat_entry *ne)
-- 
2.1.2


