Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761287AbbA1CT7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Jan 2015 21:19:59 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:41037 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756473AbbA1B2L (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Jan 2015 20:28:11 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Jan Kara <jack@suse.cz>, Josh Hunt <johunt@akamai.com>
Subject: [PATCH 3.10 31/32] ext4: fix warning in ext4_da_update_reserve_space()
Date: Tue, 27 Jan 2015 17:27:01 -0800
Message-Id: <20150128012631.383820784@linuxfoundation.org>
X-Mailer: git-send-email 2.2.2
In-Reply-To: <20150128012627.081285723@linuxfoundation.org>
References: <20150128012627.081285723@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jan Kara <jack@suse.cz>

commit 7d7345322d60edb0fa49a64a89b31360f01d09cb upstream.

reaim workfile.dbase test easily triggers warning in
ext4_da_update_reserve_space():

EXT4-fs warning (device ram0): ext4_da_update_reserve_space:365:
ino 12, allocated 1 with only 0 reserved metadata blocks (releasing 1
blocks with reserved 9 data blocks)

The problem is that (one of) tests creates file and then randomly writes
to it with O_SYNC. That results in writing back pages of the file in
random order so we create extents for written blocks say 0, 2, 4, 6, 8
- this last allocation also allocates new block for extents. Then we
writeout block 1 so we have extents 0-2, 4, 6, 8 and we release
indirect extent block because extents fit in the inode again. Then we
writeout block 10 and we need to allocate indirect extent block again
which triggers the warning because we don't have the reservation
anymore.

Fix the problem by giving back freed metadata blocks resulting from
extent merging into inode's reservation pool.

Signed-off-by: Jan Kara <jack@suse.cz>
Cc: Josh Hunt <johunt@akamai.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 fs/ext4/ext4.h    |    1 +
 fs/ext4/extents.c |    3 ++-
 fs/ext4/mballoc.c |   21 +++++++++++++++++----
 3 files changed, 20 insertions(+), 5 deletions(-)

--- a/fs/ext4/ext4.h
+++ b/fs/ext4/ext4.h
@@ -589,6 +589,7 @@ enum {
 #define EXT4_FREE_BLOCKS_NO_QUOT_UPDATE	0x0008
 #define EXT4_FREE_BLOCKS_NOFREE_FIRST_CLUSTER	0x0010
 #define EXT4_FREE_BLOCKS_NOFREE_LAST_CLUSTER	0x0020
+#define EXT4_FREE_BLOCKS_RESERVE		0x0040
 
 /*
  * Flags used by ext4_discard_partial_page_buffers
--- a/fs/ext4/extents.c
+++ b/fs/ext4/extents.c
@@ -1722,7 +1722,8 @@ static void ext4_ext_try_to_merge_up(han
 
 	brelse(path[1].p_bh);
 	ext4_free_blocks(handle, inode, NULL, blk, 1,
-			 EXT4_FREE_BLOCKS_METADATA | EXT4_FREE_BLOCKS_FORGET);
+			 EXT4_FREE_BLOCKS_METADATA | EXT4_FREE_BLOCKS_FORGET |
+			 EXT4_FREE_BLOCKS_RESERVE);
 }
 
 /*
--- a/fs/ext4/mballoc.c
+++ b/fs/ext4/mballoc.c
@@ -4610,6 +4610,7 @@ void ext4_free_blocks(handle_t *handle,
 	struct buffer_head *gd_bh;
 	ext4_group_t block_group;
 	struct ext4_sb_info *sbi;
+	struct ext4_inode_info *ei = EXT4_I(inode);
 	struct ext4_buddy e4b;
 	unsigned int count_clusters;
 	int err = 0;
@@ -4808,7 +4809,6 @@ do_more:
 	ext4_block_bitmap_csum_set(sb, block_group, gdp, bitmap_bh);
 	ext4_group_desc_csum_set(sb, block_group, gdp);
 	ext4_unlock_group(sb, block_group);
-	percpu_counter_add(&sbi->s_freeclusters_counter, count_clusters);
 
 	if (sbi->s_log_groups_per_flex) {
 		ext4_group_t flex_group = ext4_flex_group(sbi, block_group);
@@ -4816,10 +4816,23 @@ do_more:
 			     &sbi->s_flex_groups[flex_group].free_clusters);
 	}
 
-	ext4_mb_unload_buddy(&e4b);
-
-	if (!(flags & EXT4_FREE_BLOCKS_NO_QUOT_UPDATE))
+	if (flags & EXT4_FREE_BLOCKS_RESERVE && ei->i_reserved_data_blocks) {
+		percpu_counter_add(&sbi->s_dirtyclusters_counter,
+				   count_clusters);
+		spin_lock(&ei->i_block_reservation_lock);
+		if (flags & EXT4_FREE_BLOCKS_METADATA)
+			ei->i_reserved_meta_blocks += count_clusters;
+		else
+			ei->i_reserved_data_blocks += count_clusters;
+		spin_unlock(&ei->i_block_reservation_lock);
+		if (!(flags & EXT4_FREE_BLOCKS_NO_QUOT_UPDATE))
+			dquot_reclaim_block(inode,
+					EXT4_C2B(sbi, count_clusters));
+	} else if (!(flags & EXT4_FREE_BLOCKS_NO_QUOT_UPDATE))
 		dquot_free_block(inode, EXT4_C2B(sbi, count_clusters));
+	percpu_counter_add(&sbi->s_freeclusters_counter, count_clusters);
+
+	ext4_mb_unload_buddy(&e4b);
 
 	/* We dirtied the bitmap block */
 	BUFFER_TRACE(bitmap_bh, "dirtied bitmap block");


