Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751992AbaLOJeB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Dec 2014 04:34:01 -0500
Received: from mailout4.samsung.com ([203.254.224.34]:47898 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751563AbaLOJd6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Dec 2014 04:33:58 -0500
X-AuditID: cbfee61a-f79c06d000004e71-c0-548eab03c137
From: Chao Yu <chao2.yu@samsung.com>
To: Jaegeuk Kim <jaegeuk@kernel.org>, Changman Lee <cm224.lee@samsung.com>
Cc: linux-f2fs-devel@lists.sourceforge.net, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [f2fs-dev][PATCH v2] f2fs: merge two uchar variable in struct
 node_info to reduce memory cost
Date: Mon, 15 Dec 2014 17:33:06 +0800
Message-id: <000001d0184a$3f09d580$bd1d8080$@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Outlook 14.0
Thread-index: AdAYSEr3mCwLdbdEQ7iR7lXZ5csjsg==
Content-language: zh-cn
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrBLMWRmVeSWpSXmKPExsVy+t9jQV3m1X0hBv33bSyu7Wtksniyfhaz
	xaVF7hZ79p5ksbi8aw6bA6vHplWdbB67F3xm8ujbsorR4/MmuQCWKC6blNSczLLUIn27BK6M
	1q/7GQtmS1d8fTCBqYFxo2gXIyeHhICJxMl/89kgbDGJC/fWA9lcHEIC0xkleq+vZIJwfjBK
	fO9dzwhSxSagIrG84z8TiC0i4CUxaf8JFhCbWSBT4l7TDGYQW1ggQ+L+4utgcRYBVYlVTS/Y
	QWxeAUuJR/++skDYghI/Jt+D6tWSWL/zOBOELS+xec1bZoiLFCR2nH3NCLFLT+LniX6oenGJ
	jUdusUxgFJiFZNQsJKNmIRk1C0nLAkaWVYyiqQXJBcVJ6bmGesWJucWleel6yfm5mxjB4f1M
	agfjygaLQ4wCHIxKPLwM/3tDhFgTy4orcw8xSnAwK4nwxs3pCxHiTUmsrEotyo8vKs1JLT7E
	KM3BoiTOq2TfFiIkkJ5YkpqdmlqQWgSTZeLglGpgZIm1PPA/cGLS5TvWc46f4ujNl9Wru2lz
	7F3WUaHStTH6mjaGcdd4xLck5dVOl004E2k8cYKgp1dB6KSLXGL+hZrK8343rr/iNqlkU+z3
	2oNLdGpiE289NDDcN/uoV0vBo2LNlh07J3xfx/d0lvyGdCVPlpntX+57pdYs2fXabLfFB/bz
	t29dUGIpzkg01GIuKk4EAPWRL2ZrAgAA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch moves one member of struct nat_entry: _flag_ to struct node_info,
so _version_ in struct node_info and _flag_ with unsigned char type will merge
to one 32-bit space in register/memory. Then the size of nat_entry will reduce
its size from 28 bytes to 24 bytes and slab memory using by f2fs will be
reduced.

changes from v1:
 o introduce inline copy_node_info() to copy valid data from node info suggested
   by Jaegeuk Kim, it can avoid bug.

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


