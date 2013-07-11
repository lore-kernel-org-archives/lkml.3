Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757157Ab3GKWUH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Jul 2013 18:20:07 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:43298 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756988Ab3GKWUE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Jul 2013 18:20:04 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Mikulas Patocka <mpatocka@artax.karlin.mff.cuni.cz>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: [ 06/15] hpfs: better test for errors
Date: Thu, 11 Jul 2013 15:19:36 -0700
Message-Id: <20130711221256.710125212@linuxfoundation.org>
X-Mailer: git-send-email 1.8.3.rc0.20.gb99dd2e
In-Reply-To: <20130711221255.925669600@linuxfoundation.org>
References: <20130711221255.925669600@linuxfoundation.org>
User-Agent: quilt/0.60-5.1.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.9-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 fs/hpfs/map.c   |    3 ++-
 fs/hpfs/super.c |    8 +++++++-
 2 files changed, 9 insertions(+), 2 deletions(-)

--- a/fs/hpfs/map.c
+++ b/fs/hpfs/map.c
@@ -17,7 +17,8 @@ __le32 *hpfs_map_bitmap(struct super_blo
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
@@ -558,7 +558,13 @@ static int hpfs_fill_super(struct super_
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


