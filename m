Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932423Ab3BIPCX (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 Feb 2013 10:02:23 -0500
Received: from mail-pb0-f51.google.com ([209.85.160.51]:35677 "EHLO
	mail-pb0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932382Ab3BIPCU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 Feb 2013 10:02:20 -0500
From: Namjae Jeon <linkinjeon@gmail.com>
To: hirofumi@mail.parknet.co.jp, akpm@linux-foundation.org
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        Namjae Jeon <linkinjeon@gmail.com>,
        Namjae Jeon <namjae.jeon@samsung.com>,
        Ravishankar N <ravi.n1@samsung.com>,
        Amit Sahrawat <a.sahrawat@samsung.com>
Subject: [PATCH v6 3/7] fat: introduce a helper fat_get_blknr_offset()
Date: Sun, 10 Feb 2013 00:02:10 +0900
Message-Id: <1360422130-12246-1-git-send-email-linkinjeon@gmail.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Namjae Jeon <namjae.jeon@samsung.com>

Introduce helper function to get the block number and offset for a given
i_pos value. Use it in __fat_write_inode() now and later on in nfs.c

Signed-off-by: Namjae Jeon <namjae.jeon@samsung.com>
Signed-off-by: Ravishankar N <ravi.n1@samsung.com>
Signed-off-by: Amit Sahrawat <a.sahrawat@samsung.com>
---
 fs/fat/fat.h   |    7 +++++++
 fs/fat/inode.c |    9 +++++----
 2 files changed, 12 insertions(+), 4 deletions(-)

diff --git a/fs/fat/fat.h b/fs/fat/fat.h
index f16948e..980c034 100644
--- a/fs/fat/fat.h
+++ b/fs/fat/fat.h
@@ -218,6 +218,13 @@ static inline sector_t fat_clus_to_blknr(struct msdos_sb_info *sbi, int clus)
 		+ sbi->data_start;
 }
 
+static inline void fat_get_blknr_offset(struct msdos_sb_info *sbi,
+				loff_t i_pos, sector_t *blknr, int *offset)
+{
+	*blknr = i_pos >> sbi->dir_per_block_bits;
+	*offset = i_pos & (sbi->dir_per_block - 1);
+}
+
 static inline loff_t fat_i_pos_read(struct msdos_sb_info *sbi,
 					struct inode *inode)
 {
diff --git a/fs/fat/inode.c b/fs/fat/inode.c
index d89f79f..8356a05 100644
--- a/fs/fat/inode.c
+++ b/fs/fat/inode.c
@@ -663,7 +663,8 @@ static int __fat_write_inode(struct inode *inode, int wait)
 	struct buffer_head *bh;
 	struct msdos_dir_entry *raw_entry;
 	loff_t i_pos;
-	int err;
+	sector_t blocknr;
+	int err, offset;
 
 	if (inode->i_ino == MSDOS_ROOT_INO)
 		return 0;
@@ -673,7 +674,8 @@ retry:
 	if (!i_pos)
 		return 0;
 
-	bh = sb_bread(sb, i_pos >> sbi->dir_per_block_bits);
+	fat_get_blknr_offset(sbi, i_pos, &blocknr, &offset);
+	bh = sb_bread(sb, blocknr);
 	if (!bh) {
 		fat_msg(sb, KERN_ERR, "unable to read inode block "
 		       "for updating (i_pos %lld)", i_pos);
@@ -686,8 +688,7 @@ retry:
 		goto retry;
 	}
 
-	raw_entry = &((struct msdos_dir_entry *) (bh->b_data))
-	    [i_pos & (sbi->dir_per_block - 1)];
+	raw_entry = &((struct msdos_dir_entry *) (bh->b_data))[offset];
 	if (S_ISDIR(inode->i_mode))
 		raw_entry->size = 0;
 	else
-- 
1.7.9.5

