Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758785AbaGXJqz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jul 2014 05:46:55 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:54621 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758470AbaGXJqq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jul 2014 05:46:46 -0400
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Liu Bo <bo.li.liu@oracle.com>, Chris Mason <clm@fb.com>,
        David Sterba <dsterba@suse.cz>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.11 013/128] Btrfs: fix scrub_print_warning to handle skinny metadata extents
Date: Thu, 24 Jul 2014 10:44:22 +0100
Message-Id: <1406195177-8656-14-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1406195177-8656-1-git-send-email-luis.henriques@canonical.com>
References: <1406195177-8656-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.11.10.14 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Liu Bo <bo.li.liu@oracle.com>

commit 6eda71d0c030af0fc2f68aaa676e6d445600855b upstream.

The skinny extents are intepreted incorrectly in scrub_print_warning(),
and end up hitting the BUG() in btrfs_extent_inline_ref_size.

Reported-by: Konstantinos Skarlatos <k.skarlatos@gmail.com>
Signed-off-by: Liu Bo <bo.li.liu@oracle.com>
Signed-off-by: Chris Mason <clm@fb.com>
Cc: David Sterba <dsterba@suse.cz>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 fs/btrfs/backref.c | 30 +++++++++++++++++++-----------
 fs/btrfs/backref.h |  4 ++--
 fs/btrfs/scrub.c   |  5 +++--
 3 files changed, 24 insertions(+), 15 deletions(-)

diff --git a/fs/btrfs/backref.c b/fs/btrfs/backref.c
index 2b3d7ba4ad33..75b85578d98a 100644
--- a/fs/btrfs/backref.c
+++ b/fs/btrfs/backref.c
@@ -1369,9 +1369,10 @@ int extent_from_logical(struct btrfs_fs_info *fs_info, u64 logical,
  * returns <0 on error
  */
 static int __get_extent_inline_ref(unsigned long *ptr, struct extent_buffer *eb,
-				struct btrfs_extent_item *ei, u32 item_size,
-				struct btrfs_extent_inline_ref **out_eiref,
-				int *out_type)
+				   struct btrfs_key *key,
+				   struct btrfs_extent_item *ei, u32 item_size,
+				   struct btrfs_extent_inline_ref **out_eiref,
+				   int *out_type)
 {
 	unsigned long end;
 	u64 flags;
@@ -1381,9 +1382,16 @@ static int __get_extent_inline_ref(unsigned long *ptr, struct extent_buffer *eb,
 		/* first call */
 		flags = btrfs_extent_flags(eb, ei);
 		if (flags & BTRFS_EXTENT_FLAG_TREE_BLOCK) {
-			info = (struct btrfs_tree_block_info *)(ei + 1);
-			*out_eiref =
-				(struct btrfs_extent_inline_ref *)(info + 1);
+			if (key->type == BTRFS_METADATA_ITEM_KEY) {
+				/* a skinny metadata extent */
+				*out_eiref =
+				     (struct btrfs_extent_inline_ref *)(ei + 1);
+			} else {
+				WARN_ON(key->type != BTRFS_EXTENT_ITEM_KEY);
+				info = (struct btrfs_tree_block_info *)(ei + 1);
+				*out_eiref =
+				   (struct btrfs_extent_inline_ref *)(info + 1);
+			}
 		} else {
 			*out_eiref = (struct btrfs_extent_inline_ref *)(ei + 1);
 		}
@@ -1393,7 +1401,7 @@ static int __get_extent_inline_ref(unsigned long *ptr, struct extent_buffer *eb,
 	}
 
 	end = (unsigned long)ei + item_size;
-	*out_eiref = (struct btrfs_extent_inline_ref *)*ptr;
+	*out_eiref = (struct btrfs_extent_inline_ref *)(*ptr);
 	*out_type = btrfs_extent_inline_ref_type(eb, *out_eiref);
 
 	*ptr += btrfs_extent_inline_ref_size(*out_type);
@@ -1412,8 +1420,8 @@ static int __get_extent_inline_ref(unsigned long *ptr, struct extent_buffer *eb,
  * <0 on error.
  */
 int tree_backref_for_extent(unsigned long *ptr, struct extent_buffer *eb,
-				struct btrfs_extent_item *ei, u32 item_size,
-				u64 *out_root, u8 *out_level)
+			    struct btrfs_key *key, struct btrfs_extent_item *ei,
+			    u32 item_size, u64 *out_root, u8 *out_level)
 {
 	int ret;
 	int type;
@@ -1424,8 +1432,8 @@ int tree_backref_for_extent(unsigned long *ptr, struct extent_buffer *eb,
 		return 1;
 
 	while (1) {
-		ret = __get_extent_inline_ref(ptr, eb, ei, item_size,
-						&eiref, &type);
+		ret = __get_extent_inline_ref(ptr, eb, key, ei, item_size,
+					      &eiref, &type);
 		if (ret < 0)
 			return ret;
 
diff --git a/fs/btrfs/backref.h b/fs/btrfs/backref.h
index 8f2e76702932..a3bd63b06044 100644
--- a/fs/btrfs/backref.h
+++ b/fs/btrfs/backref.h
@@ -40,8 +40,8 @@ int extent_from_logical(struct btrfs_fs_info *fs_info, u64 logical,
 			u64 *flags);
 
 int tree_backref_for_extent(unsigned long *ptr, struct extent_buffer *eb,
-				struct btrfs_extent_item *ei, u32 item_size,
-				u64 *out_root, u8 *out_level);
+			    struct btrfs_key *key, struct btrfs_extent_item *ei,
+			    u32 item_size, u64 *out_root, u8 *out_level);
 
 int iterate_extent_inodes(struct btrfs_fs_info *fs_info,
 				u64 extent_item_objectid,
diff --git a/fs/btrfs/scrub.c b/fs/btrfs/scrub.c
index 64a157becbe5..8a56d4432522 100644
--- a/fs/btrfs/scrub.c
+++ b/fs/btrfs/scrub.c
@@ -545,8 +545,9 @@ static void scrub_print_warning(const char *errstr, struct scrub_block *sblock)
 
 	if (flags & BTRFS_EXTENT_FLAG_TREE_BLOCK) {
 		do {
-			ret = tree_backref_for_extent(&ptr, eb, ei, item_size,
-							&ref_root, &ref_level);
+			ret = tree_backref_for_extent(&ptr, eb, &found_key, ei,
+						      item_size, &ref_root,
+						      &ref_level);
 			printk_in_rcu(KERN_WARNING
 				"btrfs: %s at logical %llu on dev %s, "
 				"sector %llu: metadata %s (level %d) in tree "
-- 
1.9.1

