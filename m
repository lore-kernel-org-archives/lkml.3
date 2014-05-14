Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751554AbaENSSb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 May 2014 14:18:31 -0400
Received: from mailrelay008.isp.belgacom.be ([195.238.6.174]:51480 "EHLO
	mailrelay008.isp.belgacom.be" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751339AbaENSSa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 May 2014 14:18:30 -0400
X-Belgacom-Dynamic: yes
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AuUNADWyc1NXQ68k/2dsb2JhbABZgwasaQQBAQEBAQEFAZodgSUXdIJTExwjGIECJBOIRQHRVYVUiHqERwEDjyqKJgGLDYgHgzg7
Date: Wed, 14 May 2014 20:18:28 +0200
From: Fabian Frederick <fabf@skynet.be>
To: linux-kernel <linux-kernel@vger.kernel.org>
Cc: Joe <joe@perches.com>, akpm <akpm@linux-foundation.org>
Subject: [PATCH V2 3/3] FS/EFS: convert printk(KERN_DEBUG to pr_debug
Message-Id: <20140514201828.18258cfe819f8174bf4ea520@skynet.be>
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
Remove #ifdef DEBUG around pr_debugs only (suggested by Joe Perches)

Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Joe Perches <joe@perches.com>
Signed-off-by: Fabian Frederick <fabf@skynet.be>
---
 fs/efs/dir.c   |  7 +++----
 fs/efs/inode.c | 18 ++++++------------
 fs/efs/super.c | 18 ++++++++----------
 3 files changed, 17 insertions(+), 26 deletions(-)

diff --git a/fs/efs/dir.c b/fs/efs/dir.c
index 7f97031..ce63b24 100644
--- a/fs/efs/dir.c
+++ b/fs/efs/dir.c
@@ -71,10 +71,9 @@ static int efs_readdir(struct file *file, struct dir_context *ctx)
 			inodenum = be32_to_cpu(dirslot->inode);
 			namelen  = dirslot->namelen;
 			nameptr  = dirslot->name;
-
-#ifdef DEBUG
-			printk(KERN_DEBUG "EFS: readdir(): block %d slot %d/%d: inode %u, name \"%s\", namelen %u\n", block, slot, dirblock->slots-1, inodenum, nameptr, namelen);
-#endif
+			pr_debug("%s(): block %d slot %d/%d: inode %u, name \"%s\", namelen %u\n",
+				 __func__, block, slot, dirblock->slots-1,
+				 inodenum, nameptr, namelen);
 			if (!namelen)
 				continue;
 			/* found the next entry */
diff --git a/fs/efs/inode.c b/fs/efs/inode.c
index 6c9684a..079d203 100644
--- a/fs/efs/inode.c
+++ b/fs/efs/inode.c
@@ -138,12 +138,8 @@ struct inode *efs_iget(struct super_block *super, unsigned long ino)
 	}
 
 	brelse(bh);
-   
-#ifdef DEBUG
-	printk(KERN_DEBUG "EFS: efs_iget(): inode %lu, extents %d, mode %o\n",
-		inode->i_ino, in->numextents, inode->i_mode);
-#endif
-
+	pr_debug("efs_iget(): inode %lu, extents %d, mode %o\n",
+		 inode->i_ino, in->numextents, inode->i_mode);
 	switch (inode->i_mode & S_IFMT) {
 		case S_IFDIR: 
 			inode->i_op = &efs_dir_inode_operations; 
@@ -239,9 +235,8 @@ efs_block_t efs_map_block(struct inode *inode, efs_block_t block) {
 		return 0;
 	}
 
-#ifdef DEBUG
-	printk(KERN_DEBUG "EFS: map_block(): indirect search for logical block %u\n", block);
-#endif
+	pr_debug("%s(): indirect search for logical block %u\n",
+		 __func__, block);
 	direxts = in->extents[0].cooked.ex_offset;
 	indexts = in->numextents;
 
@@ -285,9 +280,8 @@ efs_block_t efs_map_block(struct inode *inode, efs_block_t block) {
 				       __func__, iblock);
 				return 0;
 			}
-#ifdef DEBUG
-			printk(KERN_DEBUG "EFS: map_block(): read indirect extent block %d\n", iblock);
-#endif
+			pr_debug("%s(): read indirect extent block %d\n",
+				 __func__, iblock);
 			first = 0;
 			lastblock = iblock;
 		}
diff --git a/fs/efs/super.c b/fs/efs/super.c
index cd1399e..7fca462 100644
--- a/fs/efs/super.c
+++ b/fs/efs/super.c
@@ -184,7 +184,7 @@ static efs_block_t efs_validate_vh(struct volume_header *vh) {
 	}
 
 #ifdef DEBUG
-	printk(KERN_DEBUG "EFS: bf: \"%16s\"\n", vh->vh_bootfile);
+	pr_debug("bf: \"%16s\"\n", vh->vh_bootfile);
 
 	for(i = 0; i < NVDIR; i++) {
 		int	j;
@@ -196,9 +196,8 @@ static efs_block_t efs_validate_vh(struct volume_header *vh) {
 		name[j] = (char) 0;
 
 		if (name[0]) {
-			printk(KERN_DEBUG "EFS: vh: %8s block: 0x%08x size: 0x%08x\n",
-				name,
-				(int) be32_to_cpu(vh->vh_vd[i].vd_lbn),
+			pr_debug("vh: %8s block: 0x%08x size: 0x%08x\n",
+				name, (int) be32_to_cpu(vh->vh_vd[i].vd_lbn),
 				(int) be32_to_cpu(vh->vh_vd[i].vd_nbytes));
 		}
 	}
@@ -211,12 +210,11 @@ static efs_block_t efs_validate_vh(struct volume_header *vh) {
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
