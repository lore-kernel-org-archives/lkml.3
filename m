Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755423Ab3CYBZu (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 Mar 2013 21:25:50 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:34052 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756017Ab3CYBQK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 Mar 2013 21:16:10 -0400
Message-Id: <20130325010529.453351912@decadent.org.uk>
User-Agent: quilt/0.60-1
Date: Mon, 25 Mar 2013 01:06:16 +0000
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: akpm@linux-foundation.org, Lukas Czerner <lczerner@redhat.com>,
        "Theodore Tso" <tytso@mit.edu>
Subject: [ 052/104] ext4: convert number of blocks to clusters properly
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
In-Reply-To: <20130325010524.240972766@decadent.org.uk>
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:f137:78a:b654:affb
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Lukas Czerner <lczerner@redhat.com>

commit 810da240f221d64bf90020f25941b05b378186fe upstream.

We're using macro EXT4_B2C() to convert number of blocks to number of
clusters for bigalloc file systems.  However, we should be using
EXT4_NUM_B2C().

Signed-off-by: Lukas Czerner <lczerner@redhat.com>
Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
[bwh: Backported to 3.2:
 - Adjust context
 - Drop changes in ext4_setup_new_descs() and ext4_calculate_overhead()]
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
--- a/fs/ext4/balloc.c
+++ b/fs/ext4/balloc.c
@@ -571,7 +571,7 @@ ext4_fsblk_t ext4_count_free_clusters(st
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
@@ -3485,7 +3485,7 @@ ext4_mb_new_inode_pa(struct ext4_allocat
 			win = offs;
 
 		ac->ac_b_ex.fe_logical = ac->ac_o_ex.fe_logical -
-			EXT4_B2C(sbi, win);
+			EXT4_NUM_B2C(sbi, win);
 		BUG_ON(ac->ac_o_ex.fe_logical < ac->ac_b_ex.fe_logical);
 		BUG_ON(ac->ac_o_ex.fe_len > ac->ac_b_ex.fe_len);
 	}
@@ -4634,7 +4634,7 @@ do_more:
 			EXT4_BLOCKS_PER_GROUP(sb);
 		count -= overflow;
 	}
-	count_clusters = EXT4_B2C(sbi, count);
+	count_clusters = EXT4_NUM_B2C(sbi, count);
 	bitmap_bh = ext4_read_block_bitmap(sb, block_group);
 	if (!bitmap_bh) {
 		err = -EIO;
@@ -4865,11 +4865,11 @@ int ext4_group_add_blocks(handle_t *hand
 	desc->bg_checksum = ext4_group_desc_csum(sbi, block_group, desc);
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
@@ -938,7 +938,7 @@ int ext4_group_add(struct super_block *s
 
 	/* Update the free space counts */
 	percpu_counter_add(&sbi->s_freeclusters_counter,
-			   EXT4_B2C(sbi, input->free_blocks_count));
+			   EXT4_NUM_B2C(sbi, input->free_blocks_count));
 	percpu_counter_add(&sbi->s_freeinodes_counter,
 			   EXT4_INODES_PER_GROUP(sb));
 
@@ -946,7 +946,7 @@ int ext4_group_add(struct super_block *s
 	    sbi->s_log_groups_per_flex) {
 		ext4_group_t flex_group;
 		flex_group = ext4_flex_group(sbi, input->group);
-		atomic_add(EXT4_B2C(sbi, input->free_blocks_count),
+		atomic_add(EXT4_NUM_B2C(sbi, input->free_blocks_count),
 			   &sbi->s_flex_groups[flex_group].free_clusters);
 		atomic_add(EXT4_INODES_PER_GROUP(sb),
 			   &sbi->s_flex_groups[flex_group].free_inodes);


