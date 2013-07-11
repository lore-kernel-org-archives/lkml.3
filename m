Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933219Ab3GKOjn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Jul 2013 10:39:43 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:43126 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932940Ab3GKO0f (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Jul 2013 10:26:35 -0400
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Mikulas Patocka <mpatocka@artax.karlin.mff.cuni.cz>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 63/98] hpfs: better test for errors
Date: Thu, 11 Jul 2013 15:24:33 +0100
Message-Id: <1373552708-15235-64-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1373552708-15235-1-git-send-email-luis.henriques@canonical.com>
References: <1373552708-15235-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.17 -stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 fs/hpfs/map.c   | 3 ++-
 fs/hpfs/super.c | 8 +++++++-
 2 files changed, 9 insertions(+), 2 deletions(-)

diff --git a/fs/hpfs/map.c b/fs/hpfs/map.c
index 4acb19d..803d3da 100644
--- a/fs/hpfs/map.c
+++ b/fs/hpfs/map.c
@@ -17,7 +17,8 @@ __le32 *hpfs_map_bitmap(struct super_block *s, unsigned bmp_block,
 			 struct quad_buffer_head *qbh, char *id)
 {
 	secno sec;
-	if (hpfs_sb(s)->sb_chk) if (bmp_block * 16384 > hpfs_sb(s)->sb_fs_size) {
+	unsigned n_bands = (hpfs_sb(s)->sb_fs_size + 0x3fff) >> 14;
+	if (hpfs_sb(s)->sb_chk) if (bmp_block >= n_bands) {
 		hpfs_error(s, "hpfs_map_bitmap called with bad parameter: %08x at %s", bmp_block, id);
 		return NULL;
 	}
diff --git a/fs/hpfs/super.c b/fs/hpfs/super.c
index 706a12c..8d250192 100644
--- a/fs/hpfs/super.c
+++ b/fs/hpfs/super.c
@@ -552,7 +552,13 @@ static int hpfs_fill_super(struct super_block *s, void *options, int silent)
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
-- 
1.8.1.2

