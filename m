Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934082Ab3CLXUh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Mar 2013 19:20:37 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:60126 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755793Ab3CLWcq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Mar 2013 18:32:46 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Lukas Czerner <lczerner@redhat.com>, "Theodore Tso" <tytso@mit.edu>
Subject: [ 017/100] ext4: convert number of blocks to clusters properly
Date: Tue, 12 Mar 2013 15:31:02 -0700
Message-Id: <20130312223124.851741523@linuxfoundation.org>
X-Mailer: git-send-email 1.8.1.rc1.5.g7e0651a
In-Reply-To: <20130312223122.884099393@linuxfoundation.org>
References: <20130312223122.884099393@linuxfoundation.org>
User-Agent: quilt/0.60-2.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.8-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Lukas Czerner <lczerner@redhat.com>

commit 810da240f221d64bf90020f25941b05b378186fe upstream.

We're using macro EXT4_B2C() to convert number of blocks to number of
clusters for bigalloc file systems.  However, we should be using
EXT4_NUM_B2C().

Signed-off-by: Lukas Czerner <lczerner@redhat.com>
Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 fs/ext4/balloc.c  |    2 +-
 fs/ext4/mballoc.c |    8 ++++----
 fs/ext4/resize.c  |    6 +++---
 fs/ext4/super.c   |    2 +-
 4 files changed, 9 insertions(+), 9 deletions(-)

--- a/fs/ext4/balloc.c
+++ b/fs/ext4/balloc.c
@@ -635,7 +635,7 @@ ext4_fsblk_t ext4_count_free_clusters(st
 	brelse(bitmap_bh);
 	printk(KERN_DEBUG "ext4_count_free_clusters: stored = %llu"
 	       ", computed = %llu, %llu\n",
-	       EXT4_B2C(EXT4_SB(sb), ext4_free_blocks_count(es)),
+	       EXT4_NUM_B2C(EXT4_SB(sb), ext4_free_blocks_count(es)),
 	       desc_count, bitmap_count);
 	return bitmap_count;
 #else
--- a/fs/ext4/mballoc.c
+++ b/fs/ext4/mballoc.c
@@ -3444,7 +3444,7 @@ ext4_mb_new_inode_pa(struct ext4_allocat
 			win = offs;
 
 		ac->ac_b_ex.fe_logical = ac->ac_o_ex.fe_logical -
-			EXT4_B2C(sbi, win);
+			EXT4_NUM_B2C(sbi, win);
 		BUG_ON(ac->ac_o_ex.fe_logical < ac->ac_b_ex.fe_logical);
 		BUG_ON(ac->ac_o_ex.fe_len > ac->ac_b_ex.fe_len);
 	}
@@ -4590,7 +4590,7 @@ do_more:
 			EXT4_BLOCKS_PER_GROUP(sb);
 		count -= overflow;
 	}
-	count_clusters = EXT4_B2C(sbi, count);
+	count_clusters = EXT4_NUM_B2C(sbi, count);
 	bitmap_bh = ext4_read_block_bitmap(sb, block_group);
 	if (!bitmap_bh) {
 		err = -EIO;
@@ -4832,11 +4832,11 @@ int ext4_group_add_blocks(handle_t *hand
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
 
--- a/fs/ext4/resize.c
+++ b/fs/ext4/resize.c
@@ -1247,7 +1247,7 @@ static int ext4_setup_new_descs(handle_t
 
 		ext4_inode_table_set(sb, gdp, group_data->inode_table);
 		ext4_free_group_clusters_set(sb, gdp,
-					     EXT4_B2C(sbi, group_data->free_blocks_count));
+			EXT4_NUM_B2C(sbi, group_data->free_blocks_count));
 		ext4_free_inodes_set(sb, gdp, EXT4_INODES_PER_GROUP(sb));
 		if (ext4_has_group_desc_csum(sb))
 			ext4_itable_unused_set(sb, gdp,
@@ -1349,7 +1349,7 @@ static void ext4_update_super(struct sup
 
 	/* Update the free space counts */
 	percpu_counter_add(&sbi->s_freeclusters_counter,
-			   EXT4_B2C(sbi, free_blocks));
+			   EXT4_NUM_B2C(sbi, free_blocks));
 	percpu_counter_add(&sbi->s_freeinodes_counter,
 			   EXT4_INODES_PER_GROUP(sb) * flex_gd->count);
 
@@ -1360,7 +1360,7 @@ static void ext4_update_super(struct sup
 	    sbi->s_log_groups_per_flex) {
 		ext4_group_t flex_group;
 		flex_group = ext4_flex_group(sbi, group_data[0].group);
-		atomic_add(EXT4_B2C(sbi, free_blocks),
+		atomic_add(EXT4_NUM_B2C(sbi, free_blocks),
 			   &sbi->s_flex_groups[flex_group].free_clusters);
 		atomic_add(EXT4_INODES_PER_GROUP(sb) * flex_gd->count,
 			   &sbi->s_flex_groups[flex_group].free_inodes);
--- a/fs/ext4/super.c
+++ b/fs/ext4/super.c
@@ -3235,7 +3235,7 @@ int ext4_calculate_overhead(struct super
 	}
 	/* Add the journal blocks as well */
 	if (sbi->s_journal)
-		overhead += EXT4_B2C(sbi, sbi->s_journal->j_maxlen);
+		overhead += EXT4_NUM_B2C(sbi, sbi->s_journal->j_maxlen);
 
 	sbi->s_overhead = overhead;
 	smp_wmb();


