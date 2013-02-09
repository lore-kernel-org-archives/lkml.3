Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932403Ab3BIPCK (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 Feb 2013 10:02:10 -0500
Received: from mail-pa0-f47.google.com ([209.85.220.47]:64708 "EHLO
	mail-pa0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932382Ab3BIPCF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 Feb 2013 10:02:05 -0500
From: Namjae Jeon <linkinjeon@gmail.com>
To: hirofumi@mail.parknet.co.jp, akpm@linux-foundation.org
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        Namjae Jeon <linkinjeon@gmail.com>,
        Namjae Jeon <namjae.jeon@samsung.com>,
        Ravishankar N <ravi.n1@samsung.com>,
        Amit Sahrawat <a.sahrawat@samsung.com>
Subject: [PATCH v6 2/7] fat: move fat_i_pos_read to fat.h
Date: Sun, 10 Feb 2013 00:01:57 +0900
Message-Id: <1360422117-12212-1-git-send-email-linkinjeon@gmail.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Namjae Jeon <namjae.jeon@samsung.com>

Move fat_i_pos_read to fat.h so that it can be called from nfs.c in the
subsequent patches to encode the file handle.

Signed-off-by: Namjae Jeon <namjae.jeon@samsung.com>
Signed-off-by: Ravishankar N <ravi.n1@samsung.com>
Signed-off-by: Amit Sahrawat <a.sahrawat@samsung.com>
---
 fs/fat/fat.h   |   14 ++++++++++++++
 fs/fat/inode.c |   14 --------------
 2 files changed, 14 insertions(+), 14 deletions(-)

diff --git a/fs/fat/fat.h b/fs/fat/fat.h
index a7b1d86..f16948e 100644
--- a/fs/fat/fat.h
+++ b/fs/fat/fat.h
@@ -218,6 +218,20 @@ static inline sector_t fat_clus_to_blknr(struct msdos_sb_info *sbi, int clus)
 		+ sbi->data_start;
 }
 
+static inline loff_t fat_i_pos_read(struct msdos_sb_info *sbi,
+					struct inode *inode)
+{
+	loff_t i_pos;
+#if BITS_PER_LONG == 32
+	spin_lock(&sbi->inode_hash_lock);
+#endif
+	i_pos = MSDOS_I(inode)->i_pos;
+#if BITS_PER_LONG == 32
+	spin_unlock(&sbi->inode_hash_lock);
+#endif
+	return i_pos;
+}
+
 static inline void fat16_towchar(wchar_t *dst, const __u8 *src, size_t len)
 {
 #ifdef __BIG_ENDIAN
diff --git a/fs/fat/inode.c b/fs/fat/inode.c
index 82cef99..d89f79f 100644
--- a/fs/fat/inode.c
+++ b/fs/fat/inode.c
@@ -656,20 +656,6 @@ static int fat_statfs(struct dentry *dentry, struct kstatfs *buf)
 	return 0;
 }
 
-static inline loff_t fat_i_pos_read(struct msdos_sb_info *sbi,
-				    struct inode *inode)
-{
-	loff_t i_pos;
-#if BITS_PER_LONG == 32
-	spin_lock(&sbi->inode_hash_lock);
-#endif
-	i_pos = MSDOS_I(inode)->i_pos;
-#if BITS_PER_LONG == 32
-	spin_unlock(&sbi->inode_hash_lock);
-#endif
-	return i_pos;
-}
-
 static int __fat_write_inode(struct inode *inode, int wait)
 {
 	struct super_block *sb = inode->i_sb;
-- 
1.7.9.5

