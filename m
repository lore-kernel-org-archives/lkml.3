Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753129Ab3GXOOM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Jul 2013 10:14:12 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:45842 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752389Ab3GXOGw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Jul 2013 10:06:52 -0400
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC: akpm@linux-foundation.org,
        "Linus Torvalds" <torvalds@linux-foundation.org>,
        "Mikulas Patocka" <mpatocka@artax.karlin.mff.cuni.cz>,
        "Mikulas Patocka" <mikulas@artax.karlin.mff.cuni.cz>
Date: Wed, 24 Jul 2013 15:02:45 +0100
Message-ID: <lsq.1374674565.458422748@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
Subject: [71/85] hpfs: better test for errors
In-Reply-To: <lsq.1374674564.753305150@decadent.org.uk>
X-SA-Exim-Connect-IP: 192.168.4.101
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2.49-rc1 review patch.  If anyone has any objections, please let me know.

------------------

From: Mikulas Patocka <mikulas@artax.karlin.mff.cuni.cz>

commit 3ebacb05044f82c5f0bb456a894eb9dc57d0ed90 upstream.

The test if bitmap access is out of bound could errorneously pass if the
device size is divisible by 16384 sectors and we are asking for one bitmap
after the end.

Check for invalid size in the superblock. Invalid size could cause integer
overflows in the rest of the code.

Signed-off-by: Mikulas Patocka <mpatocka@artax.karlin.mff.cuni.cz>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 fs/hpfs/map.c   | 3 ++-
 fs/hpfs/super.c | 8 +++++++-
 2 files changed, 9 insertions(+), 2 deletions(-)

--- a/fs/hpfs/map.c
+++ b/fs/hpfs/map.c
@@ -17,7 +17,8 @@ unsigned int *hpfs_map_bitmap(struct sup
 			 struct quad_buffer_head *qbh, char *id)
 {
 	secno sec;
-	if (hpfs_sb(s)->sb_chk) if (bmp_block * 16384 > hpfs_sb(s)->sb_fs_size) {
+	unsigned n_bands = (hpfs_sb(s)->sb_fs_size + 0x3fff) >> 14;
+	if (hpfs_sb(s)->sb_chk) if (bmp_block >= n_bands) {
 		hpfs_error(s, "hpfs_map_bitmap called with bad parameter: %08x at %s", bmp_block, id);
 		return NULL;
 	}
--- a/fs/hpfs/super.c
+++ b/fs/hpfs/super.c
@@ -553,7 +553,13 @@ static int hpfs_fill_super(struct super_
 	sbi->sb_cp_table = NULL;
 	sbi->sb_c_bitmap = -1;
 	sbi->sb_max_fwd_alloc = 0xffffff;
-	
+
+	if (sbi->sb_fs_size >= 0x80000000) {
+		hpfs_error(s, "invalid size in superblock: %08x",
+			(unsigned)sbi->sb_fs_size);
+		goto bail4;
+	}
+
 	/* Load bitmap directory */
 	if (!(sbi->sb_bmp_dir = hpfs_load_bitmap_directory(s, le32_to_cpu(superblock->bitmaps))))
 		goto bail4;

