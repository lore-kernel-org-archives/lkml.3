Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758792Ab3FDRDu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Jun 2013 13:03:50 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:48627 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758595Ab3FDRDp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Jun 2013 13:03:45 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 45/75] fat: fix possible overflow for fat_clusters
Date: Tue,  4 Jun 2013 09:55:29 -0700
Message-Id: <1370364959-9475-46-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1370364959-9475-1-git-send-email-kamal@canonical.com>
References: <1370364959-9475-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.8.13.2 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>

commit 7b92d03c3239f43e5b86c9cc9630f026d36ee995 upstream.

Intermediate value of fat_clusters can be overflowed on 32bits arch.

Reported-by: Krzysztof Strasburger <strasbur@chkw386.ch.pwr.wroc.pl>
Signed-off-by: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
[ kamal: backport to 3.8 ]
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 fs/fat/inode.c | 15 ++++++++++++++-
 1 file changed, 14 insertions(+), 1 deletion(-)

diff --git a/fs/fat/inode.c b/fs/fat/inode.c
index f8f4916..14da0d5 100644
--- a/fs/fat/inode.c
+++ b/fs/fat/inode.c
@@ -1165,6 +1165,19 @@ static int fat_read_root(struct inode *inode)
 	return 0;
 }
 
+static unsigned long calc_fat_clusters(struct super_block *sb)
+{
+	struct msdos_sb_info *sbi = MSDOS_SB(sb);
+
+	/* Divide first to avoid overflow */
+	if (sbi->fat_bits != 12) {
+		unsigned long ent_per_sec = sb->s_blocksize * 8 / sbi->fat_bits;
+		return ent_per_sec * sbi->fat_length;
+	}
+
+	return sbi->fat_length * sb->s_blocksize * 8 / sbi->fat_bits;
+}
+
 /*
  * Read the super block of an MS-DOS FS.
  */
@@ -1363,7 +1376,7 @@ int fat_fill_super(struct super_block *sb, void *data, int silent, int isvfat,
 		sbi->fat_bits = (total_clusters > MAX_FAT12) ? 16 : 12;
 
 	/* check that FAT table does not overflow */
-	fat_clusters = sbi->fat_length * sb->s_blocksize * 8 / sbi->fat_bits;
+	fat_clusters = calc_fat_clusters(sb);
 	total_clusters = min(total_clusters, fat_clusters - FAT_START_ENT);
 	if (total_clusters > MAX_FAT(sb)) {
 		if (!silent)
-- 
1.8.1.2

