Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932145AbaCEOZU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Mar 2014 09:25:20 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:40868 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756745AbaCEOZN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Mar 2014 09:25:13 -0500
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: "Theodore Ts'o" <tytso@mit.edu>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.11 036/131] ext4: fix online resize with very large inode tables
Date: Wed,  5 Mar 2014 14:22:40 +0000
Message-Id: <1394029455-23128-37-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.9.0
In-Reply-To: <1394029455-23128-1-git-send-email-luis.henriques@canonical.com>
References: <1394029455-23128-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.11.10.6 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Theodore Ts'o <tytso@mit.edu>

commit b93c95353413041a8cebad915a8109619f66bcc6 upstream.

If a file system has a large number of inodes per block group, all of
the metadata blocks in a flex_bg may be larger than what can fit in a
single block group.  Unfortunately, ext4_alloc_group_tables() in
resize.c was never tested to see if it would handle this case
correctly, and there were a large number of bugs which caused the
following sequence to result in a BUG_ON:

kernel bug at fs/ext4/resize.c:409!
   ...
call trace:
 [<ffffffff81256768>] ext4_flex_group_add+0x1448/0x1830
 [<ffffffff81257de2>] ext4_resize_fs+0x7b2/0xe80
 [<ffffffff8123ac50>] ext4_ioctl+0xbf0/0xf00
 [<ffffffff811c111d>] do_vfs_ioctl+0x2dd/0x4b0
 [<ffffffff811b9df2>] ? final_putname+0x22/0x50
 [<ffffffff811c1371>] sys_ioctl+0x81/0xa0
 [<ffffffff81676aa9>] system_call_fastpath+0x16/0x1b
code: c8 4c 89 df e8 41 96 f8 ff 44 89 e8 49 01 c4 44 29 6d d4 0
rip  [<ffffffff81254fa1>] set_flexbg_block_bitmap+0x171/0x180

This can be reproduced with the following command sequence:

   mke2fs -t ext4 -i 4096 /dev/vdd 1G
   mount -t ext4 /dev/vdd /vdd
   resize2fs /dev/vdd 8G

To fix this, we need to make sure the right thing happens when a block
group's inode table straddles two block groups, which means the
following bugs had to be fixed:

1) Not clearing the BLOCK_UNINIT flag in the second block group in
   ext4_alloc_group_tables --- the was proximate cause of the BUG_ON.

2) Incorrectly determining how many block groups contained contiguous
   free blocks in ext4_alloc_group_tables().

3) Incorrectly setting the start of the next block range to be marked
   in use after a discontinuity in setup_new_flex_group_blocks().

Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 fs/ext4/resize.c | 32 ++++++++++++++++++++------------
 1 file changed, 20 insertions(+), 12 deletions(-)

diff --git a/fs/ext4/resize.c b/fs/ext4/resize.c
index c5adbb3..69a6261 100644
--- a/fs/ext4/resize.c
+++ b/fs/ext4/resize.c
@@ -243,6 +243,7 @@ static int ext4_alloc_group_tables(struct super_block *sb,
 	ext4_group_t group;
 	ext4_group_t last_group;
 	unsigned overhead;
+	__u16 uninit_mask = (flexbg_size > 1) ? ~EXT4_BG_BLOCK_UNINIT : ~0;
 
 	BUG_ON(flex_gd->count == 0 || group_data == NULL);
 
@@ -266,7 +267,7 @@ next_group:
 	src_group++;
 	for (; src_group <= last_group; src_group++) {
 		overhead = ext4_group_overhead_blocks(sb, src_group);
-		if (overhead != 0)
+		if (overhead == 0)
 			last_blk += group_data[src_group - group].blocks_count;
 		else
 			break;
@@ -280,8 +281,7 @@ next_group:
 		group = ext4_get_group_number(sb, start_blk - 1);
 		group -= group_data[0].group;
 		group_data[group].free_blocks_count--;
-		if (flexbg_size > 1)
-			flex_gd->bg_flags[group] &= ~EXT4_BG_BLOCK_UNINIT;
+		flex_gd->bg_flags[group] &= uninit_mask;
 	}
 
 	/* Allocate inode bitmaps */
@@ -292,22 +292,30 @@ next_group:
 		group = ext4_get_group_number(sb, start_blk - 1);
 		group -= group_data[0].group;
 		group_data[group].free_blocks_count--;
-		if (flexbg_size > 1)
-			flex_gd->bg_flags[group] &= ~EXT4_BG_BLOCK_UNINIT;
+		flex_gd->bg_flags[group] &= uninit_mask;
 	}
 
 	/* Allocate inode tables */
 	for (; it_index < flex_gd->count; it_index++) {
-		if (start_blk + EXT4_SB(sb)->s_itb_per_group > last_blk)
+		unsigned int itb = EXT4_SB(sb)->s_itb_per_group;
+		ext4_fsblk_t next_group_start;
+
+		if (start_blk + itb > last_blk)
 			goto next_group;
 		group_data[it_index].inode_table = start_blk;
-		group = ext4_get_group_number(sb, start_blk - 1);
+		group = ext4_get_group_number(sb, start_blk);
+		next_group_start = ext4_group_first_block_no(sb, group + 1);
 		group -= group_data[0].group;
-		group_data[group].free_blocks_count -=
-					EXT4_SB(sb)->s_itb_per_group;
-		if (flexbg_size > 1)
-			flex_gd->bg_flags[group] &= ~EXT4_BG_BLOCK_UNINIT;
 
+		if (start_blk + itb > next_group_start) {
+			flex_gd->bg_flags[group + 1] &= uninit_mask;
+			overhead = start_blk + itb - next_group_start;
+			group_data[group + 1].free_blocks_count -= overhead;
+			itb -= overhead;
+		}
+
+		group_data[group].free_blocks_count -= itb;
+		flex_gd->bg_flags[group] &= uninit_mask;
 		start_blk += EXT4_SB(sb)->s_itb_per_group;
 	}
 
@@ -620,7 +628,7 @@ handle_ib:
 			if (err)
 				goto out;
 			count = group_table_count[j];
-			start = group_data[i].block_bitmap;
+			start = (&group_data[i].block_bitmap)[j];
 			block = start;
 		}
 
-- 
1.9.0

