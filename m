Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965099Ab3CZPvr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Mar 2013 11:51:47 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:53802 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964919Ab3CZPWl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Mar 2013 11:22:41 -0400
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: "Theodore Ts'o" <tytso@mit.edu>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 066/150] ext4: use atomic64_t for the per-flexbg free_clusters count
Date: Tue, 26 Mar 2013 15:19:25 +0000
Message-Id: <1364311249-14454-67-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1364311249-14454-1-git-send-email-luis.henriques@canonical.com>
References: <1364311249-14454-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.9 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Theodore Ts'o <tytso@mit.edu>

commit 90ba983f6889e65a3b506b30dc606aa9d1d46cd2 upstream.

A user who was using a 8TB+ file system and with a very large flexbg
size (> 65536) could cause the atomic_t used in the struct flex_groups
to overflow.  This was detected by PaX security patchset:

http://forums.grsecurity.net/viewtopic.php?f=3&t=3289&p=12551#p12551

This bug was introduced in commit 9f24e4208f7e, so it's been around
since 2.6.30.  :-(

Fix this by using an atomic64_t for struct orlav_stats's
free_clusters.

Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
Reviewed-by: Lukas Czerner <lczerner@redhat.com>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 fs/ext4/ext4.h    |  6 +++---
 fs/ext4/ialloc.c  |  4 ++--
 fs/ext4/mballoc.c | 12 ++++++------
 fs/ext4/resize.c  |  4 ++--
 fs/ext4/super.c   |  4 ++--
 5 files changed, 15 insertions(+), 15 deletions(-)

diff --git a/fs/ext4/ext4.h b/fs/ext4/ext4.h
index a14c45e..d929a80 100644
--- a/fs/ext4/ext4.h
+++ b/fs/ext4/ext4.h
@@ -329,9 +329,9 @@ struct ext4_group_desc
  */
 
 struct flex_groups {
-	atomic_t free_inodes;
-	atomic_t free_clusters;
-	atomic_t used_dirs;
+	atomic64_t	free_clusters;
+	atomic_t	free_inodes;
+	atomic_t	used_dirs;
 };
 
 #define EXT4_BG_INODE_UNINIT	0x0001 /* Inode table/bitmap not in use */
diff --git a/fs/ext4/ialloc.c b/fs/ext4/ialloc.c
index 536ac65..b1919af 100644
--- a/fs/ext4/ialloc.c
+++ b/fs/ext4/ialloc.c
@@ -325,8 +325,8 @@ error_return:
 }
 
 struct orlov_stats {
+	__u64 free_clusters;
 	__u32 free_inodes;
-	__u32 free_clusters;
 	__u32 used_dirs;
 };
 
@@ -343,7 +343,7 @@ static void get_orlov_stats(struct super_block *sb, ext4_group_t g,
 
 	if (flex_size > 1) {
 		stats->free_inodes = atomic_read(&flex_group[g].free_inodes);
-		stats->free_clusters = atomic_read(&flex_group[g].free_clusters);
+		stats->free_clusters = atomic64_read(&flex_group[g].free_clusters);
 		stats->used_dirs = atomic_read(&flex_group[g].used_dirs);
 		return;
 	}
diff --git a/fs/ext4/mballoc.c b/fs/ext4/mballoc.c
index 3631fbf..18571ac 100644
--- a/fs/ext4/mballoc.c
+++ b/fs/ext4/mballoc.c
@@ -2814,8 +2814,8 @@ ext4_mb_mark_diskspace_used(struct ext4_allocation_context *ac,
 	if (sbi->s_log_groups_per_flex) {
 		ext4_group_t flex_group = ext4_flex_group(sbi,
 							  ac->ac_b_ex.fe_group);
-		atomic_sub(ac->ac_b_ex.fe_len,
-			   &sbi->s_flex_groups[flex_group].free_clusters);
+		atomic64_sub(ac->ac_b_ex.fe_len,
+			     &sbi->s_flex_groups[flex_group].free_clusters);
 	}
 
 	err = ext4_handle_dirty_metadata(handle, NULL, bitmap_bh);
@@ -4665,8 +4665,8 @@ do_more:
 
 	if (sbi->s_log_groups_per_flex) {
 		ext4_group_t flex_group = ext4_flex_group(sbi, block_group);
-		atomic_add(count_clusters,
-			   &sbi->s_flex_groups[flex_group].free_clusters);
+		atomic64_add(count_clusters,
+			     &sbi->s_flex_groups[flex_group].free_clusters);
 	}
 
 	ext4_mb_unload_buddy(&e4b);
@@ -4811,8 +4811,8 @@ int ext4_group_add_blocks(handle_t *handle, struct super_block *sb,
 
 	if (sbi->s_log_groups_per_flex) {
 		ext4_group_t flex_group = ext4_flex_group(sbi, block_group);
-		atomic_add(EXT4_NUM_B2C(sbi, blocks_freed),
-			   &sbi->s_flex_groups[flex_group].free_clusters);
+		atomic64_add(EXT4_NUM_B2C(sbi, blocks_freed),
+			     &sbi->s_flex_groups[flex_group].free_clusters);
 	}
 
 	ext4_mb_unload_buddy(&e4b);
diff --git a/fs/ext4/resize.c b/fs/ext4/resize.c
index 86261ca..a2289bf 100644
--- a/fs/ext4/resize.c
+++ b/fs/ext4/resize.c
@@ -1272,8 +1272,8 @@ static void ext4_update_super(struct super_block *sb,
 	    sbi->s_log_groups_per_flex) {
 		ext4_group_t flex_group;
 		flex_group = ext4_flex_group(sbi, group_data[0].group);
-		atomic_add(EXT4_NUM_B2C(sbi, free_blocks),
-			   &sbi->s_flex_groups[flex_group].free_clusters);
+		atomic64_add(EXT4_NUM_B2C(sbi, free_blocks),
+			     &sbi->s_flex_groups[flex_group].free_clusters);
 		atomic_add(EXT4_INODES_PER_GROUP(sb) * flex_gd->count,
 			   &sbi->s_flex_groups[flex_group].free_inodes);
 	}
diff --git a/fs/ext4/super.c b/fs/ext4/super.c
index 5be2105..79881a6 100644
--- a/fs/ext4/super.c
+++ b/fs/ext4/super.c
@@ -1966,8 +1966,8 @@ static int ext4_fill_flex_info(struct super_block *sb)
 		flex_group = ext4_flex_group(sbi, i);
 		atomic_add(ext4_free_inodes_count(sb, gdp),
 			   &sbi->s_flex_groups[flex_group].free_inodes);
-		atomic_add(ext4_free_group_clusters(sb, gdp),
-			   &sbi->s_flex_groups[flex_group].free_clusters);
+		atomic64_add(ext4_free_group_clusters(sb, gdp),
+			     &sbi->s_flex_groups[flex_group].free_clusters);
 		atomic_add(ext4_used_dirs_count(sb, gdp),
 			   &sbi->s_flex_groups[flex_group].used_dirs);
 	}
-- 
1.8.1.2

