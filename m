Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762469Ab3DBWZM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Apr 2013 18:25:12 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:33533 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933734Ab3DBWO2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Apr 2013 18:14:28 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        "Theodore Tso" <tytso@mit.edu>, Lukas Czerner <lczerner@redhat.com>,
        Lingzhu Xiang <lxiang@redhat.com>, CAI Qian <caiqian@redhat.com>
Subject: [ 41/68] ext4: use atomic64_t for the per-flexbg free_clusters count
Date: Tue,  2 Apr 2013 15:13:30 -0700
Message-Id: <20130402221334.687311313@linuxfoundation.org>
X-Mailer: git-send-email 1.8.1.rc1.5.g7e0651a
In-Reply-To: <20130402221329.915209206@linuxfoundation.org>
References: <20130402221329.915209206@linuxfoundation.org>
User-Agent: quilt/0.60-5.1.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.4-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Lingzhu Xiang <lxiang@redhat.com>
Reviewed-by: CAI Qian <caiqian@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 fs/ext4/ext4.h    |    6 +++---
 fs/ext4/ialloc.c  |    4 ++--
 fs/ext4/mballoc.c |   12 ++++++------
 fs/ext4/resize.c  |    4 ++--
 fs/ext4/super.c   |    4 ++--
 5 files changed, 15 insertions(+), 15 deletions(-)

--- a/fs/ext4/ext4.h
+++ b/fs/ext4/ext4.h
@@ -316,9 +316,9 @@ struct ext4_group_desc
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
--- a/fs/ext4/ialloc.c
+++ b/fs/ext4/ialloc.c
@@ -305,8 +305,8 @@ error_return:
 }
 
 struct orlov_stats {
+	__u64 free_clusters;
 	__u32 free_inodes;
-	__u32 free_clusters;
 	__u32 used_dirs;
 };
 
@@ -323,7 +323,7 @@ static void get_orlov_stats(struct super
 
 	if (flex_size > 1) {
 		stats->free_inodes = atomic_read(&flex_group[g].free_inodes);
-		stats->free_clusters = atomic_read(&flex_group[g].free_clusters);
+		stats->free_clusters = atomic64_read(&flex_group[g].free_clusters);
 		stats->used_dirs = atomic_read(&flex_group[g].used_dirs);
 		return;
 	}
--- a/fs/ext4/mballoc.c
+++ b/fs/ext4/mballoc.c
@@ -2813,8 +2813,8 @@ ext4_mb_mark_diskspace_used(struct ext4_
 	if (sbi->s_log_groups_per_flex) {
 		ext4_group_t flex_group = ext4_flex_group(sbi,
 							  ac->ac_b_ex.fe_group);
-		atomic_sub(ac->ac_b_ex.fe_len,
-			   &sbi->s_flex_groups[flex_group].free_clusters);
+		atomic64_sub(ac->ac_b_ex.fe_len,
+			     &sbi->s_flex_groups[flex_group].free_clusters);
 	}
 
 	err = ext4_handle_dirty_metadata(handle, NULL, bitmap_bh);
@@ -4667,8 +4667,8 @@ do_more:
 
 	if (sbi->s_log_groups_per_flex) {
 		ext4_group_t flex_group = ext4_flex_group(sbi, block_group);
-		atomic_add(count_clusters,
-			   &sbi->s_flex_groups[flex_group].free_clusters);
+		atomic64_add(count_clusters,
+			     &sbi->s_flex_groups[flex_group].free_clusters);
 	}
 
 	ext4_mb_unload_buddy(&e4b);
@@ -4812,8 +4812,8 @@ int ext4_group_add_blocks(handle_t *hand
 
 	if (sbi->s_log_groups_per_flex) {
 		ext4_group_t flex_group = ext4_flex_group(sbi, block_group);
-		atomic_add(EXT4_NUM_B2C(sbi, blocks_freed),
-			   &sbi->s_flex_groups[flex_group].free_clusters);
+		atomic64_add(EXT4_NUM_B2C(sbi, blocks_freed),
+			     &sbi->s_flex_groups[flex_group].free_clusters);
 	}
 
 	ext4_mb_unload_buddy(&e4b);
--- a/fs/ext4/resize.c
+++ b/fs/ext4/resize.c
@@ -1219,8 +1219,8 @@ static void ext4_update_super(struct sup
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
--- a/fs/ext4/super.c
+++ b/fs/ext4/super.c
@@ -1907,8 +1907,8 @@ static int ext4_fill_flex_info(struct su
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


