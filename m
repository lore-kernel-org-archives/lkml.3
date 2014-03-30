Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753483AbaC3X1f (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 Mar 2014 19:27:35 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:36606 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753209AbaC3XZG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 Mar 2014 19:25:06 -0400
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC: akpm@linux-foundation.org, "Kamal Mostafa" <kamal@canonical.com>,
        "Mikulas Patocka" <mikulas@artax.karlin.mff.cuni.cz>,
        "Linus Torvalds" <torvalds@linux-foundation.org>
Date: Mon, 31 Mar 2014 00:23:35 +0100
Message-ID: <lsq.1396221815.398936511@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
Subject: [PATCH 3.2 182/200] hpfs: remember free space
In-Reply-To: <lsq.1396221814.369444335@decadent.org.uk>
X-SA-Exim-Connect-IP: 192.168.4.249
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2.56-rc1 review patch.  If anyone has any objections, please let me know.

------------------

From: Mikulas Patocka <mikulas@artax.karlin.mff.cuni.cz>

commit 2cbe5c76fc5e38e9af4b709593146e4b8272b69e upstream.

Previously, hpfs scanned all bitmaps each time the user asked for free
space using statfs.  This patch changes it so that hpfs scans the
bitmaps only once, remembes the free space and on next invocation of
statfs it returns the value instantly.

New versions of wine are hammering on the statfs syscall very heavily,
making some games unplayable when they're stored on hpfs, with load
times in minutes.

This should be backported to the stable kernels because it fixes
user-visible problem (excessive level load times in wine).

Signed-off-by: Mikulas Patocka <mikulas@artax.karlin.mff.cuni.cz>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
[ kamal: backport to 3.8 (no hpfs_prefetch_bitmap) ]
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 fs/hpfs/alloc.c   | 66 +++++++++++++++++++++++++++++++++++++++++++++++++++++--
 fs/hpfs/hpfs_fn.h |  2 +-
 fs/hpfs/super.c   | 32 ++++++++++++++++++++-------
 3 files changed, 89 insertions(+), 11 deletions(-)

--- a/fs/hpfs/alloc.c
+++ b/fs/hpfs/alloc.c
@@ -8,6 +8,58 @@
 
 #include "hpfs_fn.h"
 
+static void hpfs_claim_alloc(struct super_block *s, secno sec)
+{
+	struct hpfs_sb_info *sbi = hpfs_sb(s);
+	if (sbi->sb_n_free != (unsigned)-1) {
+		if (unlikely(!sbi->sb_n_free)) {
+			hpfs_error(s, "free count underflow, allocating sector %08x", sec);
+			sbi->sb_n_free = -1;
+			return;
+		}
+		sbi->sb_n_free--;
+	}
+}
+
+static void hpfs_claim_free(struct super_block *s, secno sec)
+{
+	struct hpfs_sb_info *sbi = hpfs_sb(s);
+	if (sbi->sb_n_free != (unsigned)-1) {
+		if (unlikely(sbi->sb_n_free >= sbi->sb_fs_size)) {
+			hpfs_error(s, "free count overflow, freeing sector %08x", sec);
+			sbi->sb_n_free = -1;
+			return;
+		}
+		sbi->sb_n_free++;
+	}
+}
+
+static void hpfs_claim_dirband_alloc(struct super_block *s, secno sec)
+{
+	struct hpfs_sb_info *sbi = hpfs_sb(s);
+	if (sbi->sb_n_free_dnodes != (unsigned)-1) {
+		if (unlikely(!sbi->sb_n_free_dnodes)) {
+			hpfs_error(s, "dirband free count underflow, allocating sector %08x", sec);
+			sbi->sb_n_free_dnodes = -1;
+			return;
+		}
+		sbi->sb_n_free_dnodes--;
+	}
+}
+
+static void hpfs_claim_dirband_free(struct super_block *s, secno sec)
+{
+	struct hpfs_sb_info *sbi = hpfs_sb(s);
+	if (sbi->sb_n_free_dnodes != (unsigned)-1) {
+		if (unlikely(sbi->sb_n_free_dnodes >= sbi->sb_dirband_size / 4)) {
+			hpfs_error(s, "dirband free count overflow, freeing sector %08x", sec);
+			sbi->sb_n_free_dnodes = -1;
+			return;
+		}
+		sbi->sb_n_free_dnodes++;
+	}
+}
+
 /*
  * Check if a sector is allocated in bitmap
  * This is really slow. Turned on only if chk==2
@@ -203,9 +255,15 @@ secno hpfs_alloc_sector(struct super_blo
 	}
 	sec = 0;
 	ret:
+	if (sec) {
+		i = 0;
+		do
+			hpfs_claim_alloc(s, sec + i);
+		while (unlikely(++i < n));
+	}
 	if (sec && f_p) {
 		for (i = 0; i < forward; i++) {
-			if (!hpfs_alloc_if_possible(s, sec + i + 1)) {
+			if (!hpfs_alloc_if_possible(s, sec + n + i)) {
 				hpfs_error(s, "Prealloc doesn't work! Wanted %d, allocated at %08x, can't allocate %d", forward, sec, i);
 				sec = 0;
 				break;
@@ -228,6 +286,7 @@ static secno alloc_in_dirband(struct sup
 	nr >>= 2;
 	sec = alloc_in_bmp(s, (~0x3fff) | nr, 1, 0);
 	if (!sec) return 0;
+	hpfs_claim_dirband_alloc(s, sec);
 	return ((sec & 0x3fff) << 2) + sbi->sb_dirband_start;
 }
 
@@ -242,6 +301,7 @@ int hpfs_alloc_if_possible(struct super_
 		bmp[(sec & 0x3fff) >> 5] &= cpu_to_le32(~(1 << (sec & 0x1f)));
 		hpfs_mark_4buffers_dirty(&qbh);
 		hpfs_brelse4(&qbh);
+		hpfs_claim_alloc(s, sec);
 		return 1;
 	}
 	hpfs_brelse4(&qbh);
@@ -275,6 +335,7 @@ void hpfs_free_sectors(struct super_bloc
 		return;
 	}
 	bmp[(sec & 0x3fff) >> 5] |= cpu_to_le32(1 << (sec & 0x1f));
+	hpfs_claim_free(s, sec);
 	if (!--n) {
 		hpfs_mark_4buffers_dirty(&qbh);
 		hpfs_brelse4(&qbh);
@@ -359,6 +420,7 @@ void hpfs_free_dnode(struct super_block
 		bmp[ssec >> 5] |= cpu_to_le32(1 << (ssec & 0x1f));
 		hpfs_mark_4buffers_dirty(&qbh);
 		hpfs_brelse4(&qbh);
+		hpfs_claim_dirband_free(s, dno);
 	}
 }
 
@@ -366,7 +428,7 @@ struct dnode *hpfs_alloc_dnode(struct su
 			 dnode_secno *dno, struct quad_buffer_head *qbh)
 {
 	struct dnode *d;
-	if (hpfs_count_one_bitmap(s, hpfs_sb(s)->sb_dmap) > FREE_DNODES_ADD) {
+	if (hpfs_get_free_dnodes(s) > FREE_DNODES_ADD) {
 		if (!(*dno = alloc_in_dirband(s, near)))
 			if (!(*dno = hpfs_alloc_sector(s, near, 4, 0))) return NULL;
 	} else {
--- a/fs/hpfs/hpfs_fn.h
+++ b/fs/hpfs/hpfs_fn.h
@@ -314,7 +314,7 @@ static inline struct hpfs_sb_info *hpfs_
 __printf(2, 3)
 void hpfs_error(struct super_block *, const char *, ...);
 int hpfs_stop_cycles(struct super_block *, int, int *, int *, char *);
-unsigned hpfs_count_one_bitmap(struct super_block *, secno);
+unsigned hpfs_get_free_dnodes(struct super_block *);
 
 /*
  * local time (HPFS) to GMT (Unix)
--- a/fs/hpfs/super.c
+++ b/fs/hpfs/super.c
@@ -115,7 +115,7 @@ static void hpfs_put_super(struct super_
 	kfree(sbi);
 }
 
-unsigned hpfs_count_one_bitmap(struct super_block *s, secno secno)
+static unsigned hpfs_count_one_bitmap(struct super_block *s, secno secno)
 {
 	struct quad_buffer_head qbh;
 	unsigned long *bits;
@@ -123,7 +123,7 @@ unsigned hpfs_count_one_bitmap(struct su
 
 	bits = hpfs_map_4sectors(s, secno, &qbh, 4);
 	if (!bits)
-		return 0;
+		return (unsigned)-1;
 	count = bitmap_weight(bits, 2048 * BITS_PER_BYTE);
 	hpfs_brelse4(&qbh);
 	return count;
@@ -134,29 +134,45 @@ static unsigned count_bitmaps(struct sup
 	unsigned n, count, n_bands;
 	n_bands = (hpfs_sb(s)->sb_fs_size + 0x3fff) >> 14;
 	count = 0;
-	for (n = 0; n < n_bands; n++)
-		count += hpfs_count_one_bitmap(s, le32_to_cpu(hpfs_sb(s)->sb_bmp_dir[n]));
+	for (n = 0; n < n_bands; n++) {
+		unsigned c;
+		c = hpfs_count_one_bitmap(s, le32_to_cpu(hpfs_sb(s)->sb_bmp_dir[n]));
+		if (c != (unsigned)-1)
+			count += c;
+	}
 	return count;
 }
 
+unsigned hpfs_get_free_dnodes(struct super_block *s)
+{
+	struct hpfs_sb_info *sbi = hpfs_sb(s);
+	if (sbi->sb_n_free_dnodes == (unsigned)-1) {
+		unsigned c = hpfs_count_one_bitmap(s, sbi->sb_dmap);
+		if (c == (unsigned)-1)
+			return 0;
+		sbi->sb_n_free_dnodes = c;
+	}
+	return sbi->sb_n_free_dnodes;
+}
+
 static int hpfs_statfs(struct dentry *dentry, struct kstatfs *buf)
 {
 	struct super_block *s = dentry->d_sb;
 	struct hpfs_sb_info *sbi = hpfs_sb(s);
 	u64 id = huge_encode_dev(s->s_bdev->bd_dev);
+
 	hpfs_lock(s);
 
-	/*if (sbi->sb_n_free == -1) {*/
+	if (sbi->sb_n_free == (unsigned)-1)
 		sbi->sb_n_free = count_bitmaps(s);
-		sbi->sb_n_free_dnodes = hpfs_count_one_bitmap(s, sbi->sb_dmap);
-	/*}*/
+
 	buf->f_type = s->s_magic;
 	buf->f_bsize = 512;
 	buf->f_blocks = sbi->sb_fs_size;
 	buf->f_bfree = sbi->sb_n_free;
 	buf->f_bavail = sbi->sb_n_free;
 	buf->f_files = sbi->sb_dirband_size / 4;
-	buf->f_ffree = sbi->sb_n_free_dnodes;
+	buf->f_ffree = hpfs_get_free_dnodes(s);
 	buf->f_fsid.val[0] = (u32)id;
 	buf->f_fsid.val[1] = (u32)(id >> 32);
 	buf->f_namelen = 254;

