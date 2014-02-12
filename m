Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753425AbaBLIaF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Feb 2014 03:30:05 -0500
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:50170 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752045AbaBLIOA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Feb 2014 03:14:00 -0500
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC: akpm@linux-foundation.org, "Emese Revfy" <re.emese@gmail.com>,
        "PaX Team" <pageexec@freemail.hu>, "Theodore Ts'o" <tytso@mit.edu>
Date: Wed, 12 Feb 2014 08:10:12 +0000
Message-ID: <lsq.1392192612.96540100@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
Subject: [PATCH 3.2 56/79] ext4: add explicit casts when masking cluster sizes
In-Reply-To: <lsq.1392192611.998273004@decadent.org.uk>
X-SA-Exim-Connect-IP: 91.84.160.45
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2.55-rc1 review patch.  If anyone has any objections, please let me know.

------------------

From: Theodore Ts'o <tytso@mit.edu>

commit f5a44db5d2d677dfbf12deee461f85e9ec633961 upstream.

The missing casts can cause the high 64-bits of the physical blocks to
be lost.  Set up new macros which allows us to make sure the right
thing happen, even if at some point we end up supporting larger
logical block numbers.

Thanks to the Emese Revfy and the PaX security team for reporting this
issue.

Reported-by: PaX Team <pageexec@freemail.hu>
Reported-by: Emese Revfy <re.emese@gmail.com>
Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
[bwh: Backported to 3.2:
 - Adjust context
 - Drop inapplicable change to ext4_ext_rm_leaf()]
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
--- a/fs/ext4/ext4.h
+++ b/fs/ext4/ext4.h
@@ -278,6 +278,16 @@ struct ext4_io_submit {
 /* Translate # of blks to # of clusters */
 #define EXT4_NUM_B2C(sbi, blks)	(((blks) + (sbi)->s_cluster_ratio - 1) >> \
 				 (sbi)->s_cluster_bits)
+/* Mask out the low bits to get the starting block of the cluster */
+#define EXT4_PBLK_CMASK(s, pblk) ((pblk) &				\
+				  ~((ext4_fsblk_t) (s)->s_cluster_ratio - 1))
+#define EXT4_LBLK_CMASK(s, lblk) ((lblk) &				\
+				  ~((ext4_lblk_t) (s)->s_cluster_ratio - 1))
+/* Get the cluster offset */
+#define EXT4_PBLK_COFF(s, pblk) ((pblk) &				\
+				 ((ext4_fsblk_t) (s)->s_cluster_ratio - 1))
+#define EXT4_LBLK_COFF(s, lblk) ((lblk) &				\
+				 ((ext4_lblk_t) (s)->s_cluster_ratio - 1))
 
 /*
  * Structure of a blocks group descriptor
--- a/fs/ext4/extents.c
+++ b/fs/ext4/extents.c
@@ -1659,8 +1659,7 @@ static unsigned int ext4_ext_check_overl
 	depth = ext_depth(inode);
 	if (!path[depth].p_ext)
 		goto out;
-	b2 = le32_to_cpu(path[depth].p_ext->ee_block);
-	b2 &= ~(sbi->s_cluster_ratio - 1);
+	b2 = EXT4_LBLK_CMASK(sbi, le32_to_cpu(path[depth].p_ext->ee_block));
 
 	/*
 	 * get the next allocated block if the extent in the path
@@ -1670,7 +1669,7 @@ static unsigned int ext4_ext_check_overl
 		b2 = ext4_ext_next_allocated_block(path);
 		if (b2 == EXT_MAX_BLOCKS)
 			goto out;
-		b2 &= ~(sbi->s_cluster_ratio - 1);
+		b2 = EXT4_LBLK_CMASK(sbi, b2);
 	}
 
 	/* check for wrap through zero on extent logical start block*/
@@ -2305,7 +2304,7 @@ static int ext4_remove_blocks(handle_t *
 		 * truncate operation has removed all of the blocks in
 		 * the cluster.
 		 */
-		if (pblk & (sbi->s_cluster_ratio - 1) &&
+		if (EXT4_PBLK_COFF(sbi, pblk) &&
 		    (ee_len == num))
 			*partial_cluster = EXT4_B2C(sbi, pblk);
 		else
@@ -3508,7 +3507,7 @@ int ext4_find_delalloc_cluster(struct in
 {
 	struct ext4_sb_info *sbi = EXT4_SB(inode->i_sb);
 	ext4_lblk_t lblk_start, lblk_end;
-	lblk_start = lblk & (~(sbi->s_cluster_ratio - 1));
+	lblk_start = EXT4_LBLK_CMASK(sbi, lblk);
 	lblk_end = lblk_start + sbi->s_cluster_ratio - 1;
 
 	return ext4_find_delalloc_range(inode, lblk_start, lblk_end,
@@ -3568,9 +3567,9 @@ get_reserved_cluster_alloc(struct inode
 	trace_ext4_get_reserved_cluster_alloc(inode, lblk_start, num_blks);
 
 	/* Check towards left side */
-	c_offset = lblk_start & (sbi->s_cluster_ratio - 1);
+	c_offset = EXT4_LBLK_COFF(sbi, lblk_start);
 	if (c_offset) {
-		lblk_from = lblk_start & (~(sbi->s_cluster_ratio - 1));
+		lblk_from = EXT4_LBLK_CMASK(sbi, lblk_start);
 		lblk_to = lblk_from + c_offset - 1;
 
 		if (ext4_find_delalloc_range(inode, lblk_from, lblk_to, 0))
@@ -3578,7 +3577,7 @@ get_reserved_cluster_alloc(struct inode
 	}
 
 	/* Now check towards right. */
-	c_offset = (lblk_start + num_blks) & (sbi->s_cluster_ratio - 1);
+	c_offset = EXT4_LBLK_COFF(sbi, lblk_start + num_blks);
 	if (allocated_clusters && c_offset) {
 		lblk_from = lblk_start + num_blks;
 		lblk_to = lblk_from + (sbi->s_cluster_ratio - c_offset) - 1;
@@ -3771,7 +3770,7 @@ static int get_implied_cluster_alloc(str
 				     struct ext4_ext_path *path)
 {
 	struct ext4_sb_info *sbi = EXT4_SB(sb);
-	ext4_lblk_t c_offset = map->m_lblk & (sbi->s_cluster_ratio-1);
+	ext4_lblk_t c_offset = EXT4_LBLK_COFF(sbi, map->m_lblk);
 	ext4_lblk_t ex_cluster_start, ex_cluster_end;
 	ext4_lblk_t rr_cluster_start, rr_cluster_end;
 	ext4_lblk_t ee_block = le32_to_cpu(ex->ee_block);
@@ -3790,8 +3789,7 @@ static int get_implied_cluster_alloc(str
 	    (rr_cluster_start == ex_cluster_start)) {
 		if (rr_cluster_start == ex_cluster_end)
 			ee_start += ee_len - 1;
-		map->m_pblk = (ee_start & ~(sbi->s_cluster_ratio - 1)) +
-			c_offset;
+		map->m_pblk = EXT4_PBLK_CMASK(sbi, ee_start) + c_offset;
 		map->m_len = min(map->m_len,
 				 (unsigned) sbi->s_cluster_ratio - c_offset);
 		/*
@@ -4069,7 +4067,7 @@ int ext4_ext_map_blocks(handle_t *handle
 	 */
 	map->m_flags &= ~EXT4_MAP_FROM_CLUSTER;
 	newex.ee_block = cpu_to_le32(map->m_lblk);
-	cluster_offset = map->m_lblk & (sbi->s_cluster_ratio-1);
+	cluster_offset = EXT4_LBLK_CMASK(sbi, map->m_lblk);
 
 	/*
 	 * If we are doing bigalloc, check to see if the extent returned
@@ -4137,7 +4135,7 @@ int ext4_ext_map_blocks(handle_t *handle
 	 * needed so that future calls to get_implied_cluster_alloc()
 	 * work correctly.
 	 */
-	offset = map->m_lblk & (sbi->s_cluster_ratio - 1);
+	offset = EXT4_LBLK_COFF(sbi, map->m_lblk);
 	ar.len = EXT4_NUM_B2C(sbi, offset+allocated);
 	ar.goal -= offset;
 	ar.logical -= offset;
--- a/fs/ext4/mballoc.c
+++ b/fs/ext4/mballoc.c
@@ -4067,7 +4067,7 @@ ext4_mb_initialize_context(struct ext4_a
 
 	/* set up allocation goals */
 	memset(ac, 0, sizeof(struct ext4_allocation_context));
-	ac->ac_b_ex.fe_logical = ar->logical & ~(sbi->s_cluster_ratio - 1);
+	ac->ac_b_ex.fe_logical = EXT4_LBLK_CMASK(sbi, ar->logical);
 	ac->ac_status = AC_STATUS_CONTINUE;
 	ac->ac_sb = sb;
 	ac->ac_inode = ar->inode;
@@ -4605,7 +4605,7 @@ void ext4_free_blocks(handle_t *handle,
 	 * blocks at the beginning or the end unless we are explicitly
 	 * requested to avoid doing so.
 	 */
-	overflow = block & (sbi->s_cluster_ratio - 1);
+	overflow = EXT4_PBLK_COFF(sbi, block);
 	if (overflow) {
 		if (flags & EXT4_FREE_BLOCKS_NOFREE_FIRST_CLUSTER) {
 			overflow = sbi->s_cluster_ratio - overflow;
@@ -4619,7 +4619,7 @@ void ext4_free_blocks(handle_t *handle,
 			count += overflow;
 		}
 	}
-	overflow = count & (sbi->s_cluster_ratio - 1);
+	overflow = EXT4_LBLK_COFF(sbi, count);
 	if (overflow) {
 		if (flags & EXT4_FREE_BLOCKS_NOFREE_LAST_CLUSTER) {
 			if (count > overflow)

