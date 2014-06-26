Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751525AbaFZTGL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jun 2014 15:06:11 -0400
Received: from mailrelay011.isp.belgacom.be ([195.238.6.178]:4012 "EHLO
	mailrelay011.isp.belgacom.be" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751361AbaFZTGK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jun 2014 15:06:10 -0400
X-Belgacom-Dynamic: yes
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: Ak8KAHFurFNXQz8N/2dsb2JhbABagw2rSAUBAQEBAQEFAW2Yf4ENF3WEMS8jgRo3iEYBwi0XhWSJHB2ELQWPeopfizqIO4NEOw
From: Fabian Frederick <fabf@skynet.be>
To: linux-kernel@vger.kernel.org
Cc: Fabian Frederick <fabf@skynet.be>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Bob Copeland <me@bobcopeland.com>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH V2] FS/OMFS: block number sanity check during fill_super operation
Date: Thu, 26 Jun 2014 21:04:10 +0200
Message-Id: <1403809450-11750-1-git-send-email-fabf@skynet.be>
X-Mailer: git-send-email 1.8.4.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch defines maximum block number to 2^31.
It also converts bitmap_size and array_size to
unsigned int in omfs_get_imap.

Suggested-By: Linus Torvalds <torvalds@linux-foundation.org>
Suggested-By: Bob Copeland <me@bobcopeland.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Bob Copeland <me@bobcopeland.com>
Cc: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Fabian Frederick <fabf@skynet.be>
---

This is untested.

V2: 
   use 1ul<<31 instead of 1<<31 to avoid comparing to negative value
   (suggested by Linus Torvalds).

 fs/omfs/inode.c   | 10 +++++++---
 fs/omfs/omfs_fs.h |  1 +
 2 files changed, 8 insertions(+), 3 deletions(-)

diff --git a/fs/omfs/inode.c b/fs/omfs/inode.c
index ec58c76..70d1d93 100644
--- a/fs/omfs/inode.c
+++ b/fs/omfs/inode.c
@@ -306,9 +306,7 @@ static const struct super_operations omfs_sops = {
  */
 static int omfs_get_imap(struct super_block *sb)
 {
-	int bitmap_size;
-	int array_size;
-	int count;
+	unsigned int bitmap_size, count, array_size;
 	struct omfs_sb_info *sbi = OMFS_SB(sb);
 	struct buffer_head *bh;
 	unsigned long **ptr;
@@ -473,6 +471,12 @@ static int omfs_fill_super(struct super_block *sb, void *data, int silent)
 	sbi->s_sys_blocksize = be32_to_cpu(omfs_sb->s_sys_blocksize);
 	mutex_init(&sbi->s_bitmap_lock);
 
+	if (sbi->s_num_blocks > OMFS_MAX_BLOCKS) {
+		printk(KERN_ERR "omfs: sysblock number (%llx) is out of range\n",
+		       (unsigned long long)sbi->s_num_blocks);
+		goto out_brelse_bh;
+	}
+
 	if (sbi->s_sys_blocksize > PAGE_SIZE) {
 		printk(KERN_ERR "omfs: sysblock size (%d) is out of range\n",
 			sbi->s_sys_blocksize);
diff --git a/fs/omfs/omfs_fs.h b/fs/omfs/omfs_fs.h
index ee5e432..83a9833 100644
--- a/fs/omfs/omfs_fs.h
+++ b/fs/omfs/omfs_fs.h
@@ -18,6 +18,7 @@
 #define OMFS_XOR_COUNT 19
 #define OMFS_MAX_BLOCK_SIZE 8192
 #define OMFS_MAX_CLUSTER_SIZE 8
+#define OMFS_MAX_BLOCKS (1ul << 31)
 
 struct omfs_super_block {
 	char s_fill1[256];
-- 
1.8.4.5

