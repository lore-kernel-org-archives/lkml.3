Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757203Ab3KNU3r (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Nov 2013 15:29:47 -0500
Received: from gerard.telenet-ops.be ([195.130.132.48]:48612 "EHLO
	gerard.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756978Ab3KNU3j (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Nov 2013 15:29:39 -0500
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Vyacheslav Dubeyko <slava@dubeyko.com>,
        Andrew Morton <akpm@linux-foundation.org>
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        Geert Uytterhoeven <geert@linux-m68k.org>
Subject: [PATCH] hfsplus: Fix undefined __divdi3 in hfsplus_init_header_node()
Date: Thu, 14 Nov 2013 21:29:18 +0100
Message-Id: <1384460958-17314-1-git-send-email-geert@linux-m68k.org>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

ERROR: "__divdi3" [fs/hfsplus/hfsplus.ko] undefined!

Introduced by commit 099e9245e04d50bb12ed621b4fa61df0a4c9dba9 ("hfsplus:
implement attributes file's header node initialization code").

i_size_read() returns loff_t, which is long long, i.e. 64-bit.
node_size is size_t, which is either 32-bit or 64-bit.
Hence "i_size_read(attr_file) / node_size" is a 64-by-32 or 64-by-64
division, causing (some versions of) gcc to emit a call to __divdi3().

Fortunately node_size is actually 16-bit, as the sole caller of
hfsplus_init_header_node() passes a u16. Hence change its type from size_t
to u16, and use do_div() to perform a 64-by-32 division.

Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
---
Not seen in m68k/allmodconfig in -next, so it really depends on the
verion of gcc.

 fs/hfsplus/xattr.c |    9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

diff --git a/fs/hfsplus/xattr.c b/fs/hfsplus/xattr.c
index efc85b1377cc..3c6136f98c73 100644
--- a/fs/hfsplus/xattr.c
+++ b/fs/hfsplus/xattr.c
@@ -129,7 +129,7 @@ static int can_set_xattr(struct inode *inode, const char *name,
 
 static void hfsplus_init_header_node(struct inode *attr_file,
 					u32 clump_size,
-					char *buf, size_t node_size)
+					char *buf, u16 node_size)
 {
 	struct hfs_bnode_desc *desc;
 	struct hfs_btree_header_rec *head;
@@ -139,8 +139,9 @@ static void hfsplus_init_header_node(struct inode *attr_file,
 	char *bmp;
 	u32 used_nodes;
 	u32 used_bmp_bytes;
+	loff_t tmp;
 
-	hfs_dbg(ATTR_MOD, "init_hdr_attr_file: clump %u, node_size %zu\n",
+	hfs_dbg(ATTR_MOD, "init_hdr_attr_file: clump %u, node_size %u\n",
 				clump_size, node_size);
 
 	/* The end of the node contains list of record offsets */
@@ -154,7 +155,9 @@ static void hfsplus_init_header_node(struct inode *attr_file,
 
 	head = (struct hfs_btree_header_rec *)(buf + offset);
 	head->node_size = cpu_to_be16(node_size);
-	head->node_count = cpu_to_be32(i_size_read(attr_file) / node_size);
+	tmp = i_size_read(attr_file);
+	do_div(tmp, node_size);
+	head->node_count = cpu_to_be32(tmp);
 	head->free_nodes = cpu_to_be32(be32_to_cpu(head->node_count) - 1);
 	head->clump_size = cpu_to_be32(clump_size);
 	head->attributes |= cpu_to_be32(HFS_TREE_BIGKEYS | HFS_TREE_VARIDXKEYS);
-- 
1.7.9.5

