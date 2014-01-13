Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755584AbaAMQok (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Jan 2014 11:44:40 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:53204 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753798AbaAMQCu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Jan 2014 11:02:50 -0500
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: "Theodore Ts'o" <tytso@mit.edu>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.11 083/208] ext4: add explicit casts when masking cluster sizes
Date: Mon, 13 Jan 2014 15:58:44 +0000
Message-Id: <1389628849-1614-84-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1389628849-1614-1-git-send-email-luis.henriques@canonical.com>
References: <1389628849-1614-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.11.10.3 -stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 fs/ext4/ext4.h    | 10 ++++++++++
 fs/ext4/extents.c | 26 ++++++++++++--------------
 fs/ext4/mballoc.c |  6 +++---
 3 files changed, 25 insertions(+), 17 deletions(-)

diff --git a/fs/ext4/ext4.h b/fs/ext4/ext4.h
index 0ab26fb..caa5e5b 100644
--- a/fs/ext4/ext4.h
+++ b/fs/ext4/ext4.h
@@ -270,6 +270,16 @@ struct ext4_io_submit {
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
diff --git a/fs/ext4/extents.c b/fs/ext4/extents.c
index f2eace4..f8d6668 100644
--- a/fs/ext4/extents.c
+++ b/fs/ext4/extents.c
@@ -1772,8 +1772,7 @@ static unsigned int ext4_ext_check_overlap(struct ext4_sb_info *sbi,
 	depth = ext_depth(inode);
 	if (!path[depth].p_ext)
 		goto out;
-	b2 = le32_to_cpu(path[depth].p_ext->ee_block);
-	b2 &= ~(sbi->s_cluster_ratio - 1);
+	b2 = EXT4_LBLK_CMASK(sbi, le32_to_cpu(path[depth].p_ext->ee_block));
 
 	/*
 	 * get the next allocated block if the extent in the path
@@ -1783,7 +1782,7 @@ static unsigned int ext4_ext_check_overlap(struct ext4_sb_info *sbi,
 		b2 = ext4_ext_next_allocated_block(path);
 		if (b2 == EXT_MAX_BLOCKS)
 			goto out;
-		b2 &= ~(sbi->s_cluster_ratio - 1);
+		b2 = EXT4_LBLK_CMASK(sbi, b2);
 	}
 
 	/* check for wrap through zero on extent logical start block*/
@@ -2463,7 +2462,7 @@ static int ext4_remove_blocks(handle_t *handle, struct inode *inode,
 		 * extent, we have to mark the cluster as used (store negative
 		 * cluster number in partial_cluster).
 		 */
-		unaligned = pblk & (sbi->s_cluster_ratio - 1);
+		unaligned = EXT4_PBLK_COFF(sbi, pblk);
 		if (unaligned && (ee_len == num) &&
 		    (*partial_cluster != -((long long)EXT4_B2C(sbi, pblk))))
 			*partial_cluster = EXT4_B2C(sbi, pblk);
@@ -2557,7 +2556,7 @@ ext4_ext_rm_leaf(handle_t *handle, struct inode *inode,
 			 * accidentally freeing it later on
 			 */
 			pblk = ext4_ext_pblock(ex);
-			if (pblk & (sbi->s_cluster_ratio - 1))
+			if (EXT4_PBLK_COFF(sbi, pblk))
 				*partial_cluster =
 					-((long long)EXT4_B2C(sbi, pblk));
 			ex--;
@@ -3697,7 +3696,7 @@ int ext4_find_delalloc_cluster(struct inode *inode, ext4_lblk_t lblk)
 {
 	struct ext4_sb_info *sbi = EXT4_SB(inode->i_sb);
 	ext4_lblk_t lblk_start, lblk_end;
-	lblk_start = lblk & (~(sbi->s_cluster_ratio - 1));
+	lblk_start = EXT4_LBLK_CMASK(sbi, lblk);
 	lblk_end = lblk_start + sbi->s_cluster_ratio - 1;
 
 	return ext4_find_delalloc_range(inode, lblk_start, lblk_end);
@@ -3756,9 +3755,9 @@ get_reserved_cluster_alloc(struct inode *inode, ext4_lblk_t lblk_start,
 	trace_ext4_get_reserved_cluster_alloc(inode, lblk_start, num_blks);
 
 	/* Check towards left side */
-	c_offset = lblk_start & (sbi->s_cluster_ratio - 1);
+	c_offset = EXT4_LBLK_COFF(sbi, lblk_start);
 	if (c_offset) {
-		lblk_from = lblk_start & (~(sbi->s_cluster_ratio - 1));
+		lblk_from = EXT4_LBLK_CMASK(sbi, lblk_start);
 		lblk_to = lblk_from + c_offset - 1;
 
 		if (ext4_find_delalloc_range(inode, lblk_from, lblk_to))
@@ -3766,7 +3765,7 @@ get_reserved_cluster_alloc(struct inode *inode, ext4_lblk_t lblk_start,
 	}
 
 	/* Now check towards right. */
-	c_offset = (lblk_start + num_blks) & (sbi->s_cluster_ratio - 1);
+	c_offset = EXT4_LBLK_COFF(sbi, lblk_start + num_blks);
 	if (allocated_clusters && c_offset) {
 		lblk_from = lblk_start + num_blks;
 		lblk_to = lblk_from + (sbi->s_cluster_ratio - c_offset) - 1;
@@ -3974,7 +3973,7 @@ static int get_implied_cluster_alloc(struct super_block *sb,
 				     struct ext4_ext_path *path)
 {
 	struct ext4_sb_info *sbi = EXT4_SB(sb);
-	ext4_lblk_t c_offset = map->m_lblk & (sbi->s_cluster_ratio-1);
+	ext4_lblk_t c_offset = EXT4_LBLK_COFF(sbi, map->m_lblk);
 	ext4_lblk_t ex_cluster_start, ex_cluster_end;
 	ext4_lblk_t rr_cluster_start;
 	ext4_lblk_t ee_block = le32_to_cpu(ex->ee_block);
@@ -3992,8 +3991,7 @@ static int get_implied_cluster_alloc(struct super_block *sb,
 	    (rr_cluster_start == ex_cluster_start)) {
 		if (rr_cluster_start == ex_cluster_end)
 			ee_start += ee_len - 1;
-		map->m_pblk = (ee_start & ~(sbi->s_cluster_ratio - 1)) +
-			c_offset;
+		map->m_pblk = EXT4_PBLK_CMASK(sbi, ee_start) + c_offset;
 		map->m_len = min(map->m_len,
 				 (unsigned) sbi->s_cluster_ratio - c_offset);
 		/*
@@ -4147,7 +4145,7 @@ int ext4_ext_map_blocks(handle_t *handle, struct inode *inode,
 	 */
 	map->m_flags &= ~EXT4_MAP_FROM_CLUSTER;
 	newex.ee_block = cpu_to_le32(map->m_lblk);
-	cluster_offset = map->m_lblk & (sbi->s_cluster_ratio-1);
+	cluster_offset = EXT4_LBLK_CMASK(sbi, map->m_lblk);
 
 	/*
 	 * If we are doing bigalloc, check to see if the extent returned
@@ -4215,7 +4213,7 @@ int ext4_ext_map_blocks(handle_t *handle, struct inode *inode,
 	 * needed so that future calls to get_implied_cluster_alloc()
 	 * work correctly.
 	 */
-	offset = map->m_lblk & (sbi->s_cluster_ratio - 1);
+	offset = EXT4_LBLK_COFF(sbi, map->m_lblk);
 	ar.len = EXT4_NUM_B2C(sbi, offset+allocated);
 	ar.goal -= offset;
 	ar.logical -= offset;
diff --git a/fs/ext4/mballoc.c b/fs/ext4/mballoc.c
index f243825..cb1ffce 100644
--- a/fs/ext4/mballoc.c
+++ b/fs/ext4/mballoc.c
@@ -4108,7 +4108,7 @@ ext4_mb_initialize_context(struct ext4_allocation_context *ac,
 	ext4_get_group_no_and_offset(sb, goal, &group, &block);
 
 	/* set up allocation goals */
-	ac->ac_b_ex.fe_logical = ar->logical & ~(sbi->s_cluster_ratio - 1);
+	ac->ac_b_ex.fe_logical = EXT4_LBLK_CMASK(sbi, ar->logical);
 	ac->ac_status = AC_STATUS_CONTINUE;
 	ac->ac_sb = sb;
 	ac->ac_inode = ar->inode;
@@ -4649,7 +4649,7 @@ void ext4_free_blocks(handle_t *handle, struct inode *inode,
 	 * blocks at the beginning or the end unless we are explicitly
 	 * requested to avoid doing so.
 	 */
-	overflow = block & (sbi->s_cluster_ratio - 1);
+	overflow = EXT4_PBLK_COFF(sbi, block);
 	if (overflow) {
 		if (flags & EXT4_FREE_BLOCKS_NOFREE_FIRST_CLUSTER) {
 			overflow = sbi->s_cluster_ratio - overflow;
@@ -4663,7 +4663,7 @@ void ext4_free_blocks(handle_t *handle, struct inode *inode,
 			count += overflow;
 		}
 	}
-	overflow = count & (sbi->s_cluster_ratio - 1);
+	overflow = EXT4_LBLK_COFF(sbi, count);
 	if (overflow) {
 		if (flags & EXT4_FREE_BLOCKS_NOFREE_LAST_CLUSTER) {
 			if (count > overflow)
-- 
1.8.3.2

