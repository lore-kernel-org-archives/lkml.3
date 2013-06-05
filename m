Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933412Ab3FEWDK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Jun 2013 18:03:10 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:37722 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932539Ab3FEVfU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Jun 2013 17:35:20 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Krzysztof Strasburger <strasbur@chkw386.ch.pwr.wroc.pl>,
        OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: [ 036/127] fat: fix possible overflow for fat_clusters
Date: Wed,  5 Jun 2013 14:33:23 -0700
Message-Id: <20130605213222.050623677@linuxfoundation.org>
X-Mailer: git-send-email 1.8.3.rc0.20.gb99dd2e
In-Reply-To: <20130605213217.966891866@linuxfoundation.org>
References: <20130605213217.966891866@linuxfoundation.org>
User-Agent: quilt/0.60-5.1.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.9-stable review patch.  If anyone has any objections, please let me know.

------------------

From: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>

commit 7b92d03c3239f43e5b86c9cc9630f026d36ee995 upstream.

Intermediate value of fat_clusters can be overflowed on 32bits arch.

Reported-by: Krzysztof Strasburger <strasbur@chkw386.ch.pwr.wroc.pl>
Signed-off-by: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 fs/fat/inode.c |   15 ++++++++++++++-
 1 file changed, 14 insertions(+), 1 deletion(-)

--- a/fs/fat/inode.c
+++ b/fs/fat/inode.c
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


