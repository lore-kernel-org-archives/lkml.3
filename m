Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752803AbaLCL3G (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Dec 2014 06:29:06 -0500
Received: from cantor2.suse.de ([195.135.220.15]:54634 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752659AbaLCL1v (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Dec 2014 06:27:51 -0500
From: Jiri Slaby <jslaby@suse.cz>
To: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Qi Yong <qiyong@fc-cn.com>,
        Josh Boyer <jwboyer@redhat.com>, Al Viro <viro@zeniv.linux.org.uk>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Jiri Slaby <jslaby@suse.cz>
Subject: [PATCH 3.12 098/101] minix zmap block counts calculation fix
Date: Wed,  3 Dec 2014 12:27:00 +0100
Message-Id: <692f067fb661c39cc800ae7407ab655173ca2de2.1417605922.git.jslaby@suse.cz>
X-Mailer: git-send-email 2.1.3
In-Reply-To: <f9a3dbb8fd1853c16930b2c95eefa34a324eca19.1417605922.git.jslaby@suse.cz>
References: <f9a3dbb8fd1853c16930b2c95eefa34a324eca19.1417605922.git.jslaby@suse.cz>
In-Reply-To: <cover.1417605922.git.jslaby@suse.cz>
References: <cover.1417605922.git.jslaby@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Qi Yong <qiyong@fc-cn.com>

3.12-stable review patch.  If anyone has any objections, please let me know.

===============

commit 6d6747f85314687f72012ae85cde401db531e130 upstream.

The original minix zmap blocks calculation was correct, in the formula of:

	sbi->s_nzones - sbi->s_firstdatazone + 1

It is

	sp->s_zones - (sp->s_firstdatazone - 1)

in the minix3 source code.

But a later commit 016e8d44bc06 ("fs/minix: Verify bitmap block counts
before mounting") has changed it unfortunately as:

  sbi->s_nzones - (sbi->s_firstdatazone + 1)

This would show free blocks one block less than the real when the total
data blocks are in "full zmap blocks plus one".

This patch corrects that zmap blocks calculation and tidy a printk
message while at it.

Signed-off-by: Qi Yong <qiyong@fc-cn.com>
Cc: Josh Boyer <jwboyer@redhat.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Jiri Slaby <jslaby@suse.cz>
---
 fs/minix/bitmap.c | 2 +-
 fs/minix/inode.c  | 4 ++--
 2 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/fs/minix/bitmap.c b/fs/minix/bitmap.c
index 4bc50dac8e97..742942a983be 100644
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
index 0332109162a5..a2e71752f011 100644
--- a/fs/minix/inode.c
+++ b/fs/minix/inode.c
@@ -266,12 +266,12 @@ static int minix_fill_super(struct super_block *s, void *data, int silent)
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
-- 
2.1.3

