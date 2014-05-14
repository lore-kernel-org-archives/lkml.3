Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756635AbaENRPj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 May 2014 13:15:39 -0400
Received: from mailrelay005.isp.belgacom.be ([195.238.6.171]:44033 "EHLO
	mailrelay005.isp.belgacom.be" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756173AbaENRPf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 May 2014 13:15:35 -0400
X-Belgacom-Dynamic: yes
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AuUNAGOkc1NXQ68k/2dsb2JhbABZgwasaQQBAQEBAQEFAZodgSMXdIJTExwjGIECJBOIRQHRToVUiHqERwEDjyqKJgGLDYgHgzg7
Date: Wed, 14 May 2014 19:15:31 +0200
From: Fabian Frederick <fabf@skynet.be>
To: linux-kernel <linux-kernel@vger.kernel.org>
Cc: Joe <joe@perches.com>, akpm <akpm@linux-foundation.org>
Subject: [PATCH 3/3] FS/EFS: convert printk(KERN_DEBUG to pr_debug
Message-Id: <20140514191531.3dddab6232af1d0b53e25b90@skynet.be>
X-Mailer: Sylpheed 3.2.0beta5 (GTK+ 2.24.10; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

All KERN_DEBUG callsites being under #ifdef DEBUG
we can safely convert everything to pr_debug without changing
current behaviour.

Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Joe Perches <joe@perches.com>
Signed-off-by: Fabian Frederick <fabf@skynet.be>
---
 fs/efs/dir.c   |  4 +++-
 fs/efs/inode.c | 10 ++++++----
 fs/efs/super.c | 15 +++++++--------
 3 files changed, 16 insertions(+), 13 deletions(-)

diff --git a/fs/efs/dir.c b/fs/efs/dir.c
index 7f97031..4cdd580 100644
--- a/fs/efs/dir.c
+++ b/fs/efs/dir.c
@@ -73,7 +73,9 @@ static int efs_readdir(struct file *file, struct dir_context *ctx)
 			nameptr  = dirslot->name;
 
 #ifdef DEBUG
-			printk(KERN_DEBUG "EFS: readdir(): block %d slot %d/%d: inode %u, name \"%s\", namelen %u\n", block, slot, dirblock->slots-1, inodenum, nameptr, namelen);
+			pr_debug("%s(): block %d slot %d/%d: inode %u, name \"%s\", namelen %u\n",
+				 __func__, block, slot, dirblock->slots-1,
+				 inodenum, nameptr, namelen);
 #endif
 			if (!namelen)
 				continue;
diff --git a/fs/efs/inode.c b/fs/efs/inode.c
index 6c9684a..0603d9e 100644
--- a/fs/efs/inode.c
+++ b/fs/efs/inode.c
@@ -140,8 +140,8 @@ struct inode *efs_iget(struct super_block *super, unsigned long ino)
 	brelse(bh);
    
 #ifdef DEBUG
-	printk(KERN_DEBUG "EFS: efs_iget(): inode %lu, extents %d, mode %o\n",
-		inode->i_ino, in->numextents, inode->i_mode);
+	pr_debug("efs_iget(): inode %lu, extents %d, mode %o\n",
+		 inode->i_ino, in->numextents, inode->i_mode);
 #endif
 
 	switch (inode->i_mode & S_IFMT) {
@@ -240,7 +240,8 @@ efs_block_t efs_map_block(struct inode *inode, efs_block_t block) {
 	}
 
 #ifdef DEBUG
-	printk(KERN_DEBUG "EFS: map_block(): indirect search for logical block %u\n", block);
+	pr_debug("%s(): indirect search for logical block %u\n",
+		 __func__, block);
 #endif
 	direxts = in->extents[0].cooked.ex_offset;
 	indexts = in->numextents;
@@ -286,7 +287,8 @@ efs_block_t efs_map_block(struct inode *inode, efs_block_t block) {
 				return 0;
 			}
 #ifdef DEBUG
-			printk(KERN_DEBUG "EFS: map_block(): read indirect extent block %d\n", iblock);
+			pr_debug("%s(): read indirect extent block %d\n",
+				 __func__, iblock);
 #endif
 			first = 0;
 			lastblock = iblock;
diff --git a/fs/efs/super.c b/fs/efs/super.c
index cd1399e..57a176a 100644
--- a/fs/efs/super.c
+++ b/fs/efs/super.c
@@ -184,7 +184,7 @@ static efs_block_t efs_validate_vh(struct volume_header *vh) {
 	}
 
 #ifdef DEBUG
-	printk(KERN_DEBUG "EFS: bf: \"%16s\"\n", vh->vh_bootfile);
+	pr_debug("bf: \"%16s\"\n", vh->vh_bootfile);
 
 	for(i = 0; i < NVDIR; i++) {
 		int	j;
@@ -196,7 +196,7 @@ static efs_block_t efs_validate_vh(struct volume_header *vh) {
 		name[j] = (char) 0;
 
 		if (name[0]) {
-			printk(KERN_DEBUG "EFS: vh: %8s block: 0x%08x size: 0x%08x\n",
+			pr_debug("vh: %8s block: 0x%08x size: 0x%08x\n",
 				name,
 				(int) be32_to_cpu(vh->vh_vd[i].vd_lbn),
 				(int) be32_to_cpu(vh->vh_vd[i].vd_nbytes));
@@ -211,12 +211,11 @@ static efs_block_t efs_validate_vh(struct volume_header *vh) {
 		}
 #ifdef DEBUG
 		if (be32_to_cpu(vh->vh_pt[i].pt_nblks)) {
-			printk(KERN_DEBUG "EFS: pt %2d: start: %08d size: %08d type: 0x%02x (%s)\n",
-				i,
-				(int) be32_to_cpu(vh->vh_pt[i].pt_firstlbn),
-				(int) be32_to_cpu(vh->vh_pt[i].pt_nblks),
-				pt_type,
-				(pt_entry->pt_name) ? pt_entry->pt_name : "unknown");
+			pr_debug("pt %2d: start: %08d size: %08d type: 0x%02x (%s)\n",
+				 i, (int)be32_to_cpu(vh->vh_pt[i].pt_firstlbn),
+				 (int)be32_to_cpu(vh->vh_pt[i].pt_nblks),
+				 pt_type, (pt_entry->pt_name) ?
+				 pt_entry->pt_name : "unknown");
 		}
 #endif
 		if (IS_EFS(pt_type)) {
-- 
1.9.1

