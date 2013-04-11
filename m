Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762615Ab3DKU0f (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Apr 2013 16:26:35 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:9932 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760264Ab3DKU0Z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Apr 2013 16:26:25 -0400
X-Authority-Analysis: v=2.0 cv=C51rOHz+ c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=Ciwy3NGCPMMA:10 a=_GXHe7NCnvIA:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=meVymXHHAAAA:8 a=KyZaKOlnEq8A:10 a=XxtmG6sFAAAA:8 a=20KFwNOVAAAA:8 a=VwQbUJbxAAAA:8 a=m8Saba1QL18lr5pbNzIA:9 a=jTw9iyv7FngA:10 a=jEp0ucaQiEUA:10 a=jeBq3FmKZ4MA:10 a=6DSVHQHZSRt-Gw9j:21 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 74.67.115.198
Message-Id: <20130411202555.714686533@goodmis.org>
User-Agent: quilt/0.60-1
Date: Thu, 11 Apr 2013 16:26:01 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: "Theodore Tso" <tytso@mit.edu>, Lukas Czerner <lczerner@redhat.com>
Subject: [ 058/171 ] ext4: use atomic64_t for the per-flexbg free_clusters count
References: <20130411202503.783159048@goodmis.org>
Content-Disposition: inline; filename=0058-ext4-use-atomic64_t-for-the-per-flexbg-free_clusters.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.6.11.2 stable review patch.
If anyone has any objections, please let me know.

------------------

From: Theodore Ts'o <tytso@mit.edu>

[ Upstream commit 90ba983f6889e65a3b506b30dc606aa9d1d46cd2 ]

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
Cc: stable@vger.kernel.org
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 fs/ext4/ext4.h    |    6 +++---
 fs/ext4/ialloc.c  |    4 ++--
 fs/ext4/mballoc.c |   12 ++++++------
 fs/ext4/super.c   |    4 ++--
 4 files changed, 13 insertions(+), 13 deletions(-)

diff --git a/fs/ext4/ext4.h b/fs/ext4/ext4.h
index b686b43..1b3df8f 100644
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
index cc2d77c..c690ff9 100644
--- a/fs/ext4/ialloc.c
+++ b/fs/ext4/ialloc.c
@@ -324,8 +324,8 @@ error_return:
 }
 
 struct orlov_stats {
+	__u64 free_clusters;
 	__u32 free_inodes;
-	__u32 free_clusters;
 	__u32 used_dirs;
 };
 
@@ -342,7 +342,7 @@ static void get_orlov_stats(struct super_block *sb, ext4_group_t g,
 
 	if (flex_size > 1) {
 		stats->free_inodes = atomic_read(&flex_group[g].free_inodes);
-		stats->free_clusters = atomic_read(&flex_group[g].free_clusters);
+		stats->free_clusters = atomic64_read(&flex_group[g].free_clusters);
 		stats->used_dirs = atomic_read(&flex_group[g].used_dirs);
 		return;
 	}
diff --git a/fs/ext4/mballoc.c b/fs/ext4/mballoc.c
index b26410c..87b5519 100644
--- a/fs/ext4/mballoc.c
+++ b/fs/ext4/mballoc.c
@@ -2820,8 +2820,8 @@ ext4_mb_mark_diskspace_used(struct ext4_allocation_context *ac,
 	if (sbi->s_log_groups_per_flex) {
 		ext4_group_t flex_group = ext4_flex_group(sbi,
 							  ac->ac_b_ex.fe_group);
-		atomic_sub(ac->ac_b_ex.fe_len,
-			   &sbi->s_flex_groups[flex_group].free_clusters);
+		atomic64_sub(ac->ac_b_ex.fe_len,
+			     &sbi->s_flex_groups[flex_group].free_clusters);
 	}
 
 	err = ext4_handle_dirty_metadata(handle, NULL, bitmap_bh);
@@ -4670,8 +4670,8 @@ do_more:
 
 	if (sbi->s_log_groups_per_flex) {
 		ext4_group_t flex_group = ext4_flex_group(sbi, block_group);
-		atomic_add(count_clusters,
-			   &sbi->s_flex_groups[flex_group].free_clusters);
+		atomic64_add(count_clusters,
+			     &sbi->s_flex_groups[flex_group].free_clusters);
 	}
 
 	ext4_mb_unload_buddy(&e4b);
@@ -4815,8 +4815,8 @@ int ext4_group_add_blocks(handle_t *handle, struct super_block *sb,
 
 	if (sbi->s_log_groups_per_flex) {
 		ext4_group_t flex_group = ext4_flex_group(sbi, block_group);
-		atomic_add(EXT4_B2C(sbi, blocks_freed),
-			   &sbi->s_flex_groups[flex_group].free_clusters);
+		atomic64_add(EXT4_B2C(sbi, blocks_freed),
+			     &sbi->s_flex_groups[flex_group].free_clusters);
 	}
 
 	ext4_mb_unload_buddy(&e4b);
diff --git a/fs/ext4/super.c b/fs/ext4/super.c
index 2b5fb60..f581886 100644
--- a/fs/ext4/super.c
+++ b/fs/ext4/super.c
@@ -1945,8 +1945,8 @@ static int ext4_fill_flex_info(struct super_block *sb)
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
1.7.10.4


