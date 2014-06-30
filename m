Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753815AbaF3Mac (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jun 2014 08:30:32 -0400
Received: from ip4-83-240-18-248.cust.nbox.cz ([83.240.18.248]:53045 "EHLO
	ip4-83-240-18-248.cust.nbox.cz" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753290AbaF3Maa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jun 2014 08:30:30 -0400
From: Jiri Slaby <jslaby@suse.cz>
To: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Liu Bo <bo.li.liu@oracle.com>,
        Chris Mason <clm@fb.com>, Jiri Slaby <jslaby@suse.cz>
Subject: [PATCH 3.12 173/181] Btrfs: fix scrub_print_warning to handle skinny metadata extents
Date: Mon, 30 Jun 2014 13:53:14 +0200
Message-Id: <4908541104559c09ad4c15d63afafa37860effc6.1404128998.git.jslaby@suse.cz>
X-Mailer: git-send-email 2.0.0
In-Reply-To: <61844d8e25eb8899b0836afa9796fa239db80f1f.1404128997.git.jslaby@suse.cz>
References: <61844d8e25eb8899b0836afa9796fa239db80f1f.1404128997.git.jslaby@suse.cz>
In-Reply-To: <cover.1404128997.git.jslaby@suse.cz>
References: <cover.1404128997.git.jslaby@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Liu Bo <bo.li.liu@oracle.com>

3.12-stable review patch.  If anyone has any objections, please let me know.

===============

commit 6eda71d0c030af0fc2f68aaa676e6d445600855b upstream.

The skinny extents are intepreted incorrectly in scrub_print_warning(),
and end up hitting the BUG() in btrfs_extent_inline_ref_size.

Reported-by: Konstantinos Skarlatos <k.skarlatos@gmail.com>
Signed-off-by: Liu Bo <bo.li.liu@oracle.com>
Signed-off-by: Chris Mason <clm@fb.com>
Signed-off-by: Jiri Slaby <jslaby@suse.cz>
---
 fs/btrfs/backref.c | 30 +++++++++++++++++++-----------
 fs/btrfs/backref.h |  4 ++--
 fs/btrfs/scrub.c   |  5 +++--
 3 files changed, 24 insertions(+), 15 deletions(-)

diff --git a/fs/btrfs/backref.c b/fs/btrfs/backref.c
index 79559682255a..1f4ce7ac144d 100644
--- a/fs/btrfs/backref.c
+++ b/fs/btrfs/backref.c
@@ -1390,9 +1390,10 @@ int extent_from_logical(struct btrfs_fs_info *fs_info, u64 logical,
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
@@ -1402,9 +1403,16 @@ static int __get_extent_inline_ref(unsigned long *ptr, struct extent_buffer *eb,
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
@@ -1414,7 +1422,7 @@ static int __get_extent_inline_ref(unsigned long *ptr, struct extent_buffer *eb,
 	}
 
 	end = (unsigned long)ei + item_size;
-	*out_eiref = (struct btrfs_extent_inline_ref *)*ptr;
+	*out_eiref = (struct btrfs_extent_inline_ref *)(*ptr);
 	*out_type = btrfs_extent_inline_ref_type(eb, *out_eiref);
 
 	*ptr += btrfs_extent_inline_ref_size(*out_type);
@@ -1433,8 +1441,8 @@ static int __get_extent_inline_ref(unsigned long *ptr, struct extent_buffer *eb,
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
@@ -1445,8 +1453,8 @@ int tree_backref_for_extent(unsigned long *ptr, struct extent_buffer *eb,
 		return 1;
 
 	while (1) {
-		ret = __get_extent_inline_ref(ptr, eb, ei, item_size,
-						&eiref, &type);
+		ret = __get_extent_inline_ref(ptr, eb, key, ei, item_size,
+					      &eiref, &type);
 		if (ret < 0)
 			return ret;
 
diff --git a/fs/btrfs/backref.h b/fs/btrfs/backref.h
index a910b27a8ad9..519b49e51f57 100644
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
index a18e0e23f6a6..0b23100dd8ab 100644
--- a/fs/btrfs/scrub.c
+++ b/fs/btrfs/scrub.c
@@ -553,8 +553,9 @@ static void scrub_print_warning(const char *errstr, struct scrub_block *sblock)
 
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
2.0.0

