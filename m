Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754531AbaLHHOn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Dec 2014 02:14:43 -0500
Received: from mailout2.samsung.com ([203.254.224.25]:50177 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753941AbaLHHOl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Dec 2014 02:14:41 -0500
X-AuditID: cbfee61b-f79d76d0000024d6-cd-54854fdf97d8
From: Chao Yu <chao2.yu@samsung.com>
To: Jaegeuk Kim <jaegeuk@kernel.org>, Changman Lee <cm224.lee@samsung.com>
Cc: linux-f2fs-devel@lists.sourceforge.net, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [f2fs-dev][PATCH] f2fs: merge two uchar variable in struct nat_entry
 to reduce memory cost
Date: Mon, 08 Dec 2014 15:13:49 +0800
Message-id: <001c01d012b6$a0fbaaa0$e2f2ffe0$@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=US-ASCII
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Outlook 14.0
Thread-index: AdAStn8oh65xfBabRUSYTgjrP494Kg==
Content-language: zh-cn
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrBLMWRmVeSWpSXmKPExsVy+t9jAd37/q0hBuceiFpc29fIZPFk/Sxm
	i0uL3C327D3JYnF51xw2B1aPTas62Tx2L/jM5NG3ZRWjx+dNcgEsUVw2Kak5mWWpRfp2CVwZ
	298uZyxoEKyYdfoTewPjMt4uRk4OCQETiXdvz7NA2GISF+6tZ+ti5OIQEljEKLH20TZGCOcH
	o8StSedYQarYBFQklnf8ZwKxRQS8JCbtPwHWzSyQKXGvaQYziC0skCrxdfordhCbRUBV4lvb
	CrAaXgFLiUeXrzBC2IISPybfg+rVkti8rYkVwpaX2LzmLTPERQoSO86+ZoTYpSfxb8Z7qHpx
	iY1HbrFMYBSYhWTULCSjZiEZNQtJywJGllWMoqkFyQXFSem5RnrFibnFpXnpesn5uZsYweH9
	THoH46oGi0OMAhyMSjy8Cx+0hAixJpYVV+YeYpTgYFYS4fW0bw0R4k1JrKxKLcqPLyrNSS0+
	xCjNwaIkznvjZm6IkEB6YklqdmpqQWoRTJaJg1OqgbG7cPsDns0+zA+TjnmWTtFefUqqol1n
	6VQv7Rc7jkZveLLI+lLxtvPBLCxPbl3InXBDeeXP7TzSZwQ+Vp7ac+bezW87Ne67yQruZY/b
	6PVqkeC+i5xdZpvXae9W2ngssc3ad/b20z9Unwmevc/moqf8xWT1jt/TIqoUi3+EOwg/tFYu
	nZF233GXEktxRqKhFnNRcSIANB7Vx2sCAAA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch moves one member of struct nat_entry: _flag_ to struct node_info,
so _version_ in struct node_info and _flag_ with unsigned char type will merge
to one 32-bit space in register/memory. Then the size of nat_entry will reduce
its size from 28 bytes to 24 bytes and slab memory using by f2fs will be
reduced.

Signed-off-by: Chao Yu <chao2.yu@samsung.com>
---
 fs/f2fs/node.h | 23 ++++++++++++-----------
 1 file changed, 12 insertions(+), 11 deletions(-)

diff --git a/fs/f2fs/node.h b/fs/f2fs/node.h
index d10b644..27a7318 100644
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
 
@@ -68,15 +69,15 @@ static inline void set_nat_flag(struct nat_entry *ne,
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


