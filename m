Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754904AbaF1Rsz (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Jun 2014 13:48:55 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:53185 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754874AbaF1Rsx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Jun 2014 13:48:53 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Konstantinos Skarlatos <k.skarlatos@gmail.com>,
        Liu Bo <bo.li.liu@oracle.com>, Chris Mason <clm@fb.com>
Subject: [PATCH 3.10 72/77] Btrfs: fix scrub_print_warning to handle skinny metadata extents
Date: Sat, 28 Jun 2014 10:47:05 -0700
Message-Id: <20140628174525.383301551@linuxfoundation.org>
X-Mailer: git-send-email 2.0.1
In-Reply-To: <20140628174521.691276402@linuxfoundation.org>
References: <20140628174521.691276402@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Liu Bo <bo.li.liu@oracle.com>

commit 6eda71d0c030af0fc2f68aaa676e6d445600855b upstream.

The skinny extents are intepreted incorrectly in scrub_print_warning(),
and end up hitting the BUG() in btrfs_extent_inline_ref_size.

Reported-by: Konstantinos Skarlatos <k.skarlatos@gmail.com>
Signed-off-by: Liu Bo <bo.li.liu@oracle.com>
Signed-off-by: Chris Mason <clm@fb.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 fs/btrfs/backref.c |   30 +++++++++++++++++++-----------
 fs/btrfs/backref.h |    4 ++--
 fs/btrfs/scrub.c   |    5 +++--
 3 files changed, 24 insertions(+), 15 deletions(-)

--- a/fs/btrfs/backref.c
+++ b/fs/btrfs/backref.c
@@ -1347,9 +1347,10 @@ int extent_from_logical(struct btrfs_fs_
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
@@ -1359,9 +1360,16 @@ static int __get_extent_inline_ref(unsig
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
@@ -1371,7 +1379,7 @@ static int __get_extent_inline_ref(unsig
 	}
 
 	end = (unsigned long)ei + item_size;
-	*out_eiref = (struct btrfs_extent_inline_ref *)*ptr;
+	*out_eiref = (struct btrfs_extent_inline_ref *)(*ptr);
 	*out_type = btrfs_extent_inline_ref_type(eb, *out_eiref);
 
 	*ptr += btrfs_extent_inline_ref_size(*out_type);
@@ -1390,8 +1398,8 @@ static int __get_extent_inline_ref(unsig
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
@@ -1402,8 +1410,8 @@ int tree_backref_for_extent(unsigned lon
 		return 1;
 
 	while (1) {
-		ret = __get_extent_inline_ref(ptr, eb, ei, item_size,
-						&eiref, &type);
+		ret = __get_extent_inline_ref(ptr, eb, key, ei, item_size,
+					      &eiref, &type);
 		if (ret < 0)
 			return ret;
 
--- a/fs/btrfs/backref.h
+++ b/fs/btrfs/backref.h
@@ -42,8 +42,8 @@ int extent_from_logical(struct btrfs_fs_
 			u64 *flags);
 
 int tree_backref_for_extent(unsigned long *ptr, struct extent_buffer *eb,
-				struct btrfs_extent_item *ei, u32 item_size,
-				u64 *out_root, u8 *out_level);
+			    struct btrfs_key *key, struct btrfs_extent_item *ei,
+			    u32 item_size, u64 *out_root, u8 *out_level);
 
 int iterate_extent_inodes(struct btrfs_fs_info *fs_info,
 				u64 extent_item_objectid,
--- a/fs/btrfs/scrub.c
+++ b/fs/btrfs/scrub.c
@@ -545,8 +545,9 @@ static void scrub_print_warning(const ch
 
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


