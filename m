Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933059Ab3E1DzQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 May 2013 23:55:16 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:52582 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758838Ab3E1DyJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 May 2013 23:54:09 -0400
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC: akpm@linux-foundation.org,
        "Linus Torvalds" <torvalds@linux-foundation.org>,
        "OGAWA Hirofumi" <hirofumi@mail.parknet.co.jp>,
        "Krzysztof Strasburger" <strasbur@chkw386.ch.pwr.wroc.pl>
Date: Tue, 28 May 2013 04:49:53 +0100
Message-ID: <lsq.1369712993.278792880@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
Subject: [59/94] fat: fix possible overflow for fat_clusters
In-Reply-To: <lsq.1369712992.755341692@decadent.org.uk>
X-SA-Exim-Connect-IP: 192.168.4.101
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2.46-rc1 review patch.  If anyone has any objections, please let me know.

------------------

From: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>

commit 7b92d03c3239f43e5b86c9cc9630f026d36ee995 upstream.

Intermediate value of fat_clusters can be overflowed on 32bits arch.

Reported-by: Krzysztof Strasburger <strasbur@chkw386.ch.pwr.wroc.pl>
Signed-off-by: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 fs/fat/inode.c |   15 ++++++++++++++-
 1 file changed, 14 insertions(+), 1 deletion(-)

--- a/fs/fat/inode.c
+++ b/fs/fat/inode.c
@@ -1238,6 +1238,19 @@ static int fat_read_root(struct inode *i
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
@@ -1434,7 +1447,7 @@ int fat_fill_super(struct super_block *s
 		sbi->fat_bits = (total_clusters > MAX_FAT12) ? 16 : 12;
 
 	/* check that FAT table does not overflow */
-	fat_clusters = sbi->fat_length * sb->s_blocksize * 8 / sbi->fat_bits;
+	fat_clusters = calc_fat_clusters(sb);
 	total_clusters = min(total_clusters, fat_clusters - FAT_START_ENT);
 	if (total_clusters > MAX_FAT(sb)) {
 		if (!silent)

