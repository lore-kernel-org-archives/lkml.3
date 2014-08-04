Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753262AbaHDBwf (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Aug 2014 21:52:35 -0400
Received: from [218.24.140.166] ([218.24.140.166]:36458 "EHLO virgo.fc-cn.com"
	rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1752975AbaHDBwe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Aug 2014 21:52:34 -0400
X-Greylist: delayed 351 seconds by postgrey-1.27 at vger.kernel.org; Sun, 03 Aug 2014 21:52:34 EDT
Message-ID: <53DEE61C.8060202@fc-cn.com>
Date: Mon, 04 Aug 2014 09:47:08 +0800
From: Qi Yong <qiyong@fc-cn.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: akpm@linux-foundation.org, jwboyer@redhat.com
CC: torvalds@linux-foundation.org, linux-kernel@vger.kernel.org
Subject: [patch] minix zmap block counts calculation fix
Content-Type: multipart/mixed;
 boundary="------------040805070908010704070500"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------040805070908010704070500
Content-Type: text/plain; charset=gb18030; format=flowed
Content-Transfer-Encoding: 7bit

Hello,

The original Linus' minix zmap blocks calculation was correct, in the
formula of: sbi->s_nzones - sbi->s_firstdatazone + 1. It is (sp->s_zones
- (sp->s_firstdatazone - 1) in the minix3 source code.

But a later patch (fs/minix: Verify bitmap block counts before mounting)
has changed it unfortunately as:
  sbi->s_nzones - (sbi->s_firstdatazone + 1).
This would show free blocks one block less than the real when the total
data blocks are in "full zmap blocks plus one".

commit 016e8d44bc06dd3322f26712bdd3f3a6973592d0
Author: Josh Boyer <jwboyer@redhat.com>
Date:   Fri Aug 19 14:50:26 2011 -0400

This patch corrects that zmap blocks calculation and tidy a printk
message while at it.

Signed-off-by: Qi Yong <qiyong@fc-cn.com>

-- 
Qi Yong


--------------040805070908010704070500
Content-Type: text/plain; charset=gb18030;
 name="mfs-zmap_blocks-fix.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="mfs-zmap_blocks-fix.patch"

diff --git a/fs/minix/bitmap.c b/fs/minix/bitmap.c
index 4bc50da..742942a 100644
--- a/fs/minix/bitmap.c
+++ b/fs/minix/bitmap.c
@@ -96,7 +96,7 @@ int minix_new_block(struct inode * inode)
 unsigned long minix_count_free_blocks(struct super_block *sb)
 {
 	struct minix_sb_info *sbi = minix_sb(sb);
-	u32 bits = sbi->s_nzones - (sbi->s_firstdatazone + 1);
+	u32 bits = sbi->s_nzones - sbi->s_firstdatazone + 1;
 
 	return (count_free(sbi->s_zmap, sb->s_blocksize, bits)
 		<< sbi->s_log_zone_size);
diff --git a/fs/minix/inode.c b/fs/minix/inode.c
index f007a33..3f57af1 100644
--- a/fs/minix/inode.c
+++ b/fs/minix/inode.c
@@ -267,12 +267,12 @@ static int minix_fill_super(struct super_block *s, void *data, int silent)
 	block = minix_blocks_needed(sbi->s_ninodes, s->s_blocksize);
 	if (sbi->s_imap_blocks < block) {
 		printk("MINIX-fs: file system does not have enough "
-				"imap blocks allocated.  Refusing to mount\n");
+				"imap blocks allocated.  Refusing to mount.\n");
 		goto out_no_bitmap;
 	}
 
 	block = minix_blocks_needed(
-			(sbi->s_nzones - (sbi->s_firstdatazone + 1)),
+			(sbi->s_nzones - sbi->s_firstdatazone + 1),
 			s->s_blocksize);
 	if (sbi->s_zmap_blocks < block) {
 		printk("MINIX-fs: file system does not have enough "

--------------040805070908010704070500--
