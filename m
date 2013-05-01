Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753753Ab3EAGoJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 May 2013 02:44:09 -0400
Received: from mail.parknet.co.jp ([210.171.160.6]:46249 "EHLO
	mail.parknet.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753206Ab3EAGoB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 May 2013 02:44:01 -0400
From: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
To: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>
Cc: Krzysztof Strasburger <strasbur@chkw386.ch.pwr.wroc.pl>
Subject: [PATCH] fat: Fix possible overflow for fat_clusters
References: <20130430172615.GA20597@chkw386.ch.pwr.wroc.pl>
	<87fvy74jbi.fsf@devron.myhome.or.jp>
	<20130501054916.GA23413@chkw386.ch.pwr.wroc.pl>
Date: Wed, 01 May 2013 15:43:58 +0900
In-Reply-To: <20130501054916.GA23413@chkw386.ch.pwr.wroc.pl> (Krzysztof
	Strasburger's message of "Wed, 1 May 2013 07:49:16 +0200")
Message-ID: <877gjj42tt.fsf_-_@devron.myhome.or.jp>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.3.50 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Intermediate value of fat_clusters can be overflowed on 32bits arch.

Reported-by: Krzysztof Strasburger <strasbur@chkw386.ch.pwr.wroc.pl>
Signed-off-by: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
---

 fs/fat/inode.c |   15 ++++++++++++++-
 1 file changed, 14 insertions(+), 1 deletion(-)

diff -puN fs/fat/inode.c~fat-fat_clusters-overflow-fix fs/fat/inode.c
--- linux/fs/fat/inode.c~fat-fat_clusters-overflow-fix	2013-05-01 09:37:27.000000000 +0900
+++ linux-hirofumi/fs/fat/inode.c	2013-05-01 09:43:13.000000000 +0900
@@ -1223,6 +1223,19 @@ static int fat_read_root(struct inode *i
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
@@ -1427,7 +1440,7 @@ int fat_fill_super(struct super_block *s
 		sbi->dirty = b->fat16.state & FAT_STATE_DIRTY;
 
 	/* check that FAT table does not overflow */
-	fat_clusters = sbi->fat_length * sb->s_blocksize * 8 / sbi->fat_bits;
+	fat_clusters = calc_fat_clusters(sb);
 	total_clusters = min(total_clusters, fat_clusters - FAT_START_ENT);
 	if (total_clusters > MAX_FAT(sb)) {
 		if (!silent)
_
-- 
OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
