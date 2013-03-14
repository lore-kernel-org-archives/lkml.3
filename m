Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757201Ab3CNKzn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Mar 2013 06:55:43 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:51873 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757065Ab3CNKh0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Mar 2013 06:37:26 -0400
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Lukas Czerner <lczerner@redhat.com>, "Theodore Ts'o" <tytso@mit.edu>,
        CAI Qian <caiqian@redhat.com>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 35/88] ext4: convert number of blocks to clusters properly
Date: Thu, 14 Mar 2013 10:35:28 +0000
Message-Id: <1363257381-15900-36-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1363257381-15900-1-git-send-email-luis.henriques@canonical.com>
References: <1363257381-15900-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.8 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Lukas Czerner <lczerner@redhat.com>

commit 810da240f221d64bf90020f25941b05b378186fe upstream.

We're using macro EXT4_B2C() to convert number of blocks to number of
clusters for bigalloc file systems.  However, we should be using
EXT4_NUM_B2C().

Signed-off-by: Lukas Czerner <lczerner@redhat.com>
Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
Signed-off-by: CAI Qian <caiqian@redhat.com>
[ caiqian: Adjust context; dropped change to ext4_calculate_overhead() ]
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 fs/ext4/balloc.c  | 2 +-
 fs/ext4/mballoc.c | 8 ++++----
 fs/ext4/resize.c  | 6 +++---
 3 files changed, 8 insertions(+), 8 deletions(-)

diff --git a/fs/ext4/balloc.c b/fs/ext4/balloc.c
index 2f2e0da..92e68b3 100644
--- a/fs/ext4/balloc.c
+++ b/fs/ext4/balloc.c
@@ -635,7 +635,7 @@ ext4_fsblk_t ext4_count_free_clusters(struct super_block *sb)
 	brelse(bitmap_bh);
 	printk(KERN_DEBUG "ext4_count_free_clusters: stored = %llu"
 	       ", computed = %llu, %llu\n",
-	       EXT4_B2C(EXT4_SB(sb), ext4_free_blocks_count(es)),
+	       EXT4_NUM_B2C(EXT4_SB(sb), ext4_free_blocks_count(es)),
 	       desc_count, bitmap_count);
 	return bitmap_count;
 #else
diff --git a/fs/ext4/mballoc.c b/fs/ext4/mballoc.c
index b5f8b5f..3631fbf 100644
--- a/fs/ext4/mballoc.c
+++ b/fs/ext4/mballoc.c
@@ -3430,7 +3430,7 @@ ext4_mb_new_inode_pa(struct ext4_allocation_context *ac)
 			win = offs;
 
 		ac->ac_b_ex.fe_logical = ac->ac_o_ex.fe_logical -
-			EXT4_B2C(sbi, win);
+			EXT4_NUM_B2C(sbi, win);
 		BUG_ON(ac->ac_o_ex.fe_logical < ac->ac_b_ex.fe_logical);
 		BUG_ON(ac->ac_o_ex.fe_len > ac->ac_b_ex.fe_len);
 	}
@@ -4574,7 +4574,7 @@ do_more:
 			EXT4_BLOCKS_PER_GROUP(sb);
 		count -= overflow;
 	}
-	count_clusters = EXT4_B2C(sbi, count);
+	count_clusters = EXT4_NUM_B2C(sbi, count);
 	bitmap_bh = ext4_read_block_bitmap(sb, block_group);
 	if (!bitmap_bh) {
 		err = -EIO;
@@ -4807,11 +4807,11 @@ int ext4_group_add_blocks(handle_t *handle, struct super_block *sb,
 	ext4_group_desc_csum_set(sb, block_group, desc);
 	ext4_unlock_group(sb, block_group);
 	percpu_counter_add(&sbi->s_freeclusters_counter,
-			   EXT4_B2C(sbi, blocks_freed));
+			   EXT4_NUM_B2C(sbi, blocks_freed));
 
 	if (sbi->s_log_groups_per_flex) {
 		ext4_group_t flex_group = ext4_flex_group(sbi, block_group);
-		atomic_add(EXT4_B2C(sbi, blocks_freed),
+		atomic_add(EXT4_NUM_B2C(sbi, blocks_freed),
 			   &sbi->s_flex_groups[flex_group].free_clusters);
 	}
 
diff --git a/fs/ext4/resize.c b/fs/ext4/resize.c
index 4c31b71..86261ca 100644
--- a/fs/ext4/resize.c
+++ b/fs/ext4/resize.c
@@ -1165,7 +1165,7 @@ static int ext4_setup_new_descs(handle_t *handle, struct super_block *sb,
 
 		ext4_inode_table_set(sb, gdp, group_data->inode_table);
 		ext4_free_group_clusters_set(sb, gdp,
-					     EXT4_B2C(sbi, group_data->free_blocks_count));
+			EXT4_NUM_B2C(sbi, group_data->free_blocks_count));
 		ext4_free_inodes_set(sb, gdp, EXT4_INODES_PER_GROUP(sb));
 		gdp->bg_flags = cpu_to_le16(*bg_flags);
 		ext4_group_desc_csum_set(sb, group, gdp);
@@ -1263,7 +1263,7 @@ static void ext4_update_super(struct super_block *sb,
 
 	/* Update the free space counts */
 	percpu_counter_add(&sbi->s_freeclusters_counter,
-			   EXT4_B2C(sbi, free_blocks));
+			   EXT4_NUM_B2C(sbi, free_blocks));
 	percpu_counter_add(&sbi->s_freeinodes_counter,
 			   EXT4_INODES_PER_GROUP(sb) * flex_gd->count);
 
@@ -1272,7 +1272,7 @@ static void ext4_update_super(struct super_block *sb,
 	    sbi->s_log_groups_per_flex) {
 		ext4_group_t flex_group;
 		flex_group = ext4_flex_group(sbi, group_data[0].group);
-		atomic_add(EXT4_B2C(sbi, free_blocks),
+		atomic_add(EXT4_NUM_B2C(sbi, free_blocks),
 			   &sbi->s_flex_groups[flex_group].free_clusters);
 		atomic_add(EXT4_INODES_PER_GROUP(sb) * flex_gd->count,
 			   &sbi->s_flex_groups[flex_group].free_inodes);
-- 
1.8.1.2

