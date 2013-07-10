Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754801Ab3GJRT0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Jul 2013 13:19:26 -0400
Received: from perches-mx.perches.com ([206.117.179.246]:40960 "EHLO
	labridge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754497Ab3GJRTX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Jul 2013 13:19:23 -0400
Message-ID: <1373476760.14604.52.camel@joe-AO722>
Subject: [PATCH -next] btrfs: Convert printk() to pr_<level>
From: Joe Perches <joe@perches.com>
To: Chris Mason <chris.mason@fusionio.com>
Cc: LKML <linux-kernel@vger.kernel.org>, linux-btrfs@vger.kernel.org
Date: Wed, 10 Jul 2013 10:19:20 -0700
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.6.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use more a current logging style by converting
printks to pr_<level>.

All pr_<level> messages are now prefixed with "btrfs: "
or "btrfsic: " instead of a mixture of "BTRFS", "btrfs:"
"btrfsic: " and no prefix at all.  If dmesg log scrapers
were used, these may need rewrite.

Add #define pr_fmt(fmt) as necessary.
Add "btrfsic: " to check-integrity, KBUILD_MODNAME otherwise.
Remove unnecessary OOM messages after k.allocs.
(There are other OOM messages after internal functions)
Fix a couple of typos and add a couple missing newlines.
Remove embedded prefixes.
Coalesce formats, align multiline arguments.

Signed-off-by: Joe Perches <joe@perches.com>
---
 fs/btrfs/check-integrity.c  | 998 +++++++++++++++++++-------------------------
 fs/btrfs/compression.c      |  12 +-
 fs/btrfs/ctree.c            |  22 +-
 fs/btrfs/ctree.h            |   3 +-
 fs/btrfs/delayed-inode.c    |  26 +-
 fs/btrfs/dev-replace.c      |  26 +-
 fs/btrfs/dir-item.c         |  13 +-
 fs/btrfs/disk-io.c          | 137 +++---
 fs/btrfs/extent-tree.c      |  46 +-
 fs/btrfs/extent_io.c        |  32 +-
 fs/btrfs/file-item.c        |  11 +-
 fs/btrfs/free-space-cache.c |  32 +-
 fs/btrfs/inode.c            |   9 +-
 fs/btrfs/ioctl.c            |  37 +-
 fs/btrfs/lzo.c              |   8 +-
 fs/btrfs/ordered-data.c     |  20 +-
 fs/btrfs/print-tree.c       | 178 ++++----
 fs/btrfs/qgroup.c           |  32 +-
 fs/btrfs/reada.c            |  26 +-
 fs/btrfs/relocation.c       |  10 +-
 fs/btrfs/root-tree.c        |  15 +-
 fs/btrfs/scrub.c            |  26 +-
 fs/btrfs/send.c             |  11 +-
 fs/btrfs/super.c            |  94 ++---
 fs/btrfs/transaction.c      |   5 +-
 fs/btrfs/volumes.c          |  56 ++-
 fs/btrfs/zlib.c             |   8 +-
 27 files changed, 854 insertions(+), 1039 deletions(-)

diff --git a/fs/btrfs/check-integrity.c b/fs/btrfs/check-integrity.c
index 1431a69..95ca66f 100644
--- a/fs/btrfs/check-integrity.c
+++ b/fs/btrfs/check-integrity.c
@@ -79,6 +79,8 @@
  * include and compile the integrity check tool.
  */
 
+#define pr_fmt(fmt) "btrfsic: " fmt
+
 #include <linux/sched.h>
 #include <linux/slab.h>
 #include <linux/buffer_head.h>
@@ -658,10 +660,8 @@ static int btrfsic_process_superblock(struct btrfsic_state *state,
 
 	BUG_ON(NULL == state);
 	selected_super = kzalloc(sizeof(*selected_super), GFP_NOFS);
-	if (NULL == selected_super) {
-		printk(KERN_INFO "btrfsic: error, kmalloc failed!\n");
+	if (NULL == selected_super)
 		return -1;
-	}
 
 	list_for_each_entry(device, dev_head, dev_list) {
 		int i;
@@ -684,7 +684,7 @@ static int btrfsic_process_superblock(struct btrfsic_state *state,
 	}
 
 	if (NULL == state->latest_superblock) {
-		printk(KERN_INFO "btrfsic: no superblock found!\n");
+		pr_info("no superblock found!\n");
 		kfree(selected_super);
 		return -1;
 	}
@@ -701,15 +701,15 @@ static int btrfsic_process_superblock(struct btrfsic_state *state,
 			next_bytenr = btrfs_super_root(selected_super);
 			if (state->print_mask &
 			    BTRFSIC_PRINT_MASK_ROOT_CHUNK_LOG_TREE_LOCATION)
-				printk(KERN_INFO "root@%llu\n",
-				       (unsigned long long)next_bytenr);
+				pr_info("root@%llu\n",
+					(unsigned long long)next_bytenr);
 			break;
 		case 1:
 			next_bytenr = btrfs_super_chunk_root(selected_super);
 			if (state->print_mask &
 			    BTRFSIC_PRINT_MASK_ROOT_CHUNK_LOG_TREE_LOCATION)
-				printk(KERN_INFO "chunk@%llu\n",
-				       (unsigned long long)next_bytenr);
+				pr_info("chunk@%llu\n",
+					(unsigned long long)next_bytenr);
 			break;
 		case 2:
 			next_bytenr = btrfs_super_log_root(selected_super);
@@ -717,8 +717,8 @@ static int btrfsic_process_superblock(struct btrfsic_state *state,
 				continue;
 			if (state->print_mask &
 			    BTRFSIC_PRINT_MASK_ROOT_CHUNK_LOG_TREE_LOCATION)
-				printk(KERN_INFO "log@%llu\n",
-				       (unsigned long long)next_bytenr);
+				pr_info("log@%llu\n",
+					(unsigned long long)next_bytenr);
 			break;
 		}
 
@@ -726,8 +726,8 @@ static int btrfsic_process_superblock(struct btrfsic_state *state,
 		    btrfs_num_copies(state->root->fs_info,
 				     next_bytenr, state->metablock_size);
 		if (state->print_mask & BTRFSIC_PRINT_MASK_NUM_COPIES)
-			printk(KERN_INFO "num_copies(log_bytenr=%llu) = %d\n",
-			       (unsigned long long)next_bytenr, num_copies);
+			pr_info("num_copies(log_bytenr=%llu) = %d\n",
+				(unsigned long long)next_bytenr, num_copies);
 
 		for (mirror_num = 1; mirror_num <= num_copies; mirror_num++) {
 			struct btrfsic_block *next_block;
@@ -739,11 +739,9 @@ static int btrfsic_process_superblock(struct btrfsic_state *state,
 						&tmp_next_block_ctx,
 						mirror_num);
 			if (ret) {
-				printk(KERN_INFO "btrfsic:"
-				       " btrfsic_map_block(root @%llu,"
-				       " mirror %d) failed!\n",
-				       (unsigned long long)next_bytenr,
-				       mirror_num);
+				pr_info("btrfsic_map_block(root @%llu, mirror %d) failed!\n",
+					(unsigned long long)next_bytenr,
+					mirror_num);
 				kfree(selected_super);
 				return -1;
 			}
@@ -765,10 +763,9 @@ static int btrfsic_process_superblock(struct btrfsic_state *state,
 
 			ret = btrfsic_read_block(state, &tmp_next_block_ctx);
 			if (ret < (int)PAGE_CACHE_SIZE) {
-				printk(KERN_INFO
-				       "btrfsic: read @logical %llu failed!\n",
-				       (unsigned long long)
-				       tmp_next_block_ctx.start);
+				pr_info("read @logical %llu failed!\n",
+					(unsigned long long)
+					tmp_next_block_ctx.start);
 				btrfsic_release_block_ctx(&tmp_next_block_ctx);
 				kfree(selected_super);
 				return -1;
@@ -829,7 +826,7 @@ static int btrfsic_process_superblock_dev_mirror(
 	if (NULL == superblock_tmp) {
 		superblock_tmp = btrfsic_block_alloc();
 		if (NULL == superblock_tmp) {
-			printk(KERN_INFO "btrfsic: error, kmalloc failed!\n");
+			pr_info("error, kmalloc failed!\n");
 			brelse(bh);
 			return -1;
 		}
@@ -905,8 +902,8 @@ static int btrfsic_process_superblock_dev_mirror(
 		    btrfs_num_copies(state->root->fs_info,
 				     next_bytenr, state->metablock_size);
 		if (state->print_mask & BTRFSIC_PRINT_MASK_NUM_COPIES)
-			printk(KERN_INFO "num_copies(log_bytenr=%llu) = %d\n",
-			       (unsigned long long)next_bytenr, num_copies);
+			pr_info("num_copies(log_bytenr=%llu) = %d\n",
+				(unsigned long long)next_bytenr, num_copies);
 		for (mirror_num = 1; mirror_num <= num_copies; mirror_num++) {
 			struct btrfsic_block *next_block;
 			struct btrfsic_block_data_ctx tmp_next_block_ctx;
@@ -916,10 +913,9 @@ static int btrfsic_process_superblock_dev_mirror(
 					      state->metablock_size,
 					      &tmp_next_block_ctx,
 					      mirror_num)) {
-				printk(KERN_INFO "btrfsic: btrfsic_map_block("
-				       "bytenr @%llu, mirror %d) failed!\n",
-				       (unsigned long long)next_bytenr,
-				       mirror_num);
+				pr_info("btrfsic_map_block(bytenr @%llu, mirror %d) failed!\n",
+					(unsigned long long)next_bytenr,
+					mirror_num);
 				brelse(bh);
 				return -1;
 			}
@@ -959,9 +955,7 @@ static struct btrfsic_stack_frame *btrfsic_stack_frame_alloc(void)
 	struct btrfsic_stack_frame *sf;
 
 	sf = kzalloc(sizeof(*sf), GFP_NOFS);
-	if (NULL == sf)
-		printk(KERN_INFO "btrfsic: alloc memory failed!\n");
-	else
+	if (sf)
 		sf->magic = BTRFSIC_BLOCK_STACK_FRAME_MAGIC_NUMBER;
 	return sf;
 }
@@ -1006,16 +1000,14 @@ continue_with_new_stack_frame:
 			sf->nr = le32_to_cpu(leafhdr->header.nritems);
 
 			if (state->print_mask & BTRFSIC_PRINT_MASK_VERBOSE)
-				printk(KERN_INFO
-				       "leaf %llu items %d generation %llu"
-				       " owner %llu\n",
-				       (unsigned long long)
-				       sf->block_ctx->start,
-				       sf->nr,
-				       (unsigned long long)
-				       le64_to_cpu(leafhdr->header.generation),
-				       (unsigned long long)
-				       le64_to_cpu(leafhdr->header.owner));
+				pr_info("leaf %llu items %d generation %llu owner %llu\n",
+					(unsigned long long)
+					sf->block_ctx->start,
+					sf->nr,
+					(unsigned long long)
+					le64_to_cpu(leafhdr->header.generation),
+					(unsigned long long)
+					le64_to_cpu(leafhdr->header.owner));
 		}
 
 continue_with_current_leaf_stack_frame:
@@ -1037,10 +1029,9 @@ continue_with_current_leaf_stack_frame:
 			if (disk_item_offset + sizeof(struct btrfs_item) >
 			    sf->block_ctx->len) {
 leaf_item_out_of_bounce_error:
-				printk(KERN_INFO
-				       "btrfsic: leaf item out of bounce at logical %llu, dev %s\n",
-				       sf->block_ctx->start,
-				       sf->block_ctx->dev->name);
+				pr_info("leaf item out of bounce at logical %llu, dev %s\n",
+					sf->block_ctx->start,
+					sf->block_ctx->dev->name);
 				goto one_stack_frame_backwards;
 			}
 			btrfsic_read_from_block_data(sf->block_ctx,
@@ -1133,15 +1124,14 @@ leaf_item_out_of_bounce_error:
 			sf->nr = le32_to_cpu(nodehdr->header.nritems);
 
 			if (state->print_mask & BTRFSIC_PRINT_MASK_VERBOSE)
-				printk(KERN_INFO "node %llu level %d items %d"
-				       " generation %llu owner %llu\n",
-				       (unsigned long long)
-				       sf->block_ctx->start,
-				       nodehdr->header.level, sf->nr,
-				       (unsigned long long)
-				       le64_to_cpu(nodehdr->header.generation),
-				       (unsigned long long)
-				       le64_to_cpu(nodehdr->header.owner));
+				pr_info("node %llu level %d items %d generation %llu owner %llu\n",
+					(unsigned long long)
+					sf->block_ctx->start,
+					nodehdr->header.level, sf->nr,
+					(unsigned long long)
+					le64_to_cpu(nodehdr->header.generation),
+					(unsigned long long)
+					le64_to_cpu(nodehdr->header.owner));
 		}
 
 continue_with_current_node_stack_frame:
@@ -1159,10 +1149,9 @@ continue_with_current_node_stack_frame:
 					  (uintptr_t)nodehdr;
 			if (key_ptr_offset + sizeof(struct btrfs_key_ptr) >
 			    sf->block_ctx->len) {
-				printk(KERN_INFO
-				       "btrfsic: node item out of bounce at logical %llu, dev %s\n",
-				       sf->block_ctx->start,
-				       sf->block_ctx->dev->name);
+				pr_info("node item out of bounce at logical %llu, dev %s\n",
+					sf->block_ctx->start,
+					sf->block_ctx->dev->name);
 				goto one_stack_frame_backwards;
 			}
 			btrfsic_read_from_block_data(
@@ -1289,8 +1278,8 @@ static int btrfsic_create_link_to_next_block(
 		    btrfs_num_copies(state->root->fs_info,
 				     next_bytenr, state->metablock_size);
 		if (state->print_mask & BTRFSIC_PRINT_MASK_NUM_COPIES)
-			printk(KERN_INFO "num_copies(log_bytenr=%llu) = %d\n",
-			       (unsigned long long)next_bytenr, *num_copiesp);
+			pr_info("num_copies(log_bytenr=%llu) = %d\n",
+				(unsigned long long)next_bytenr, *num_copiesp);
 		*mirror_nump = 1;
 	}
 
@@ -1298,16 +1287,14 @@ static int btrfsic_create_link_to_next_block(
 		return 0;
 
 	if (state->print_mask & BTRFSIC_PRINT_MASK_VERBOSE)
-		printk(KERN_INFO
-		       "btrfsic_create_link_to_next_block(mirror_num=%d)\n",
-		       *mirror_nump);
+		pr_info("btrfsic_create_link_to_next_block(mirror_num=%d)\n",
+			*mirror_nump);
 	ret = btrfsic_map_block(state, next_bytenr,
 				state->metablock_size,
 				next_block_ctx, *mirror_nump);
 	if (ret) {
-		printk(KERN_INFO
-		       "btrfsic: btrfsic_map_block(@%llu, mirror=%d) failed!\n",
-		       (unsigned long long)next_bytenr, *mirror_nump);
+		pr_info("btrfsic_map_block(@%llu, mirror=%d) failed!\n",
+			(unsigned long long)next_bytenr, *mirror_nump);
 		btrfsic_release_block_ctx(next_block_ctx);
 		*next_blockp = NULL;
 		return -1;
@@ -1331,25 +1318,20 @@ static int btrfsic_create_link_to_next_block(
 		if (next_block->logical_bytenr != next_bytenr &&
 		    !(!next_block->is_metadata &&
 		      0 == next_block->logical_bytenr)) {
-			printk(KERN_INFO
-			       "Referenced block @%llu (%s/%llu/%d)"
-			       " found in hash table, %c,"
-			       " bytenr mismatch (!= stored %llu).\n",
-			       (unsigned long long)next_bytenr,
-			       next_block_ctx->dev->name,
-			       (unsigned long long)next_block_ctx->dev_bytenr,
-			       *mirror_nump,
-			       btrfsic_get_block_type(state, next_block),
-			       (unsigned long long)next_block->logical_bytenr);
+			pr_info("Referenced block @%llu (%s/%llu/%d) found in hash table, %c, bytenr mismatch (!= stored %llu)\n",
+				(unsigned long long)next_bytenr,
+				next_block_ctx->dev->name,
+				(unsigned long long)next_block_ctx->dev_bytenr,
+				*mirror_nump,
+				btrfsic_get_block_type(state, next_block),
+				(unsigned long long)next_block->logical_bytenr);
 		} else if (state->print_mask & BTRFSIC_PRINT_MASK_VERBOSE)
-			printk(KERN_INFO
-			       "Referenced block @%llu (%s/%llu/%d)"
-			       " found in hash table, %c.\n",
-			       (unsigned long long)next_bytenr,
-			       next_block_ctx->dev->name,
-			       (unsigned long long)next_block_ctx->dev_bytenr,
-			       *mirror_nump,
-			       btrfsic_get_block_type(state, next_block));
+			pr_info("Referenced lock @%llu (%s/%llu/%d) found in hash table, %c\n",
+				(unsigned long long)next_bytenr,
+				next_block_ctx->dev->name,
+				(unsigned long long)next_block_ctx->dev_bytenr,
+				*mirror_nump,
+				btrfsic_get_block_type(state, next_block));
 		next_block->logical_bytenr = next_bytenr;
 
 		next_block->mirror_num = *mirror_nump;
@@ -1365,7 +1347,7 @@ static int btrfsic_create_link_to_next_block(
 	if (NULL == l) {
 		l = btrfsic_block_link_alloc();
 		if (NULL == l) {
-			printk(KERN_INFO "btrfsic: error, kmalloc failed!\n");
+			pr_info("error, kmalloc failed!\n");
 			btrfsic_release_block_ctx(next_block_ctx);
 			*next_blockp = NULL;
 			return -1;
@@ -1398,9 +1380,8 @@ static int btrfsic_create_link_to_next_block(
 	if (limit_nesting > 0 && did_alloc_block_link) {
 		ret = btrfsic_read_block(state, next_block_ctx);
 		if (ret < (int)next_block_ctx->len) {
-			printk(KERN_INFO
-			       "btrfsic: read block @logical %llu failed!\n",
-			       (unsigned long long)next_bytenr);
+			pr_info("read block @logical %llu failed!\n",
+				(unsigned long long)next_bytenr);
 			btrfsic_release_block_ctx(next_block_ctx);
 			*next_blockp = NULL;
 			return -1;
@@ -1434,9 +1415,8 @@ static int btrfsic_handle_extent_data(
 	if (file_extent_item_offset +
 	    offsetof(struct btrfs_file_extent_item, disk_num_bytes) >
 	    block_ctx->len) {
-		printk(KERN_INFO
-		       "btrfsic: file item out of bounce at logical %llu, dev %s\n",
-		       block_ctx->start, block_ctx->dev->name);
+		pr_info("file item out of bounce at logical %llu, dev %s\n",
+			block_ctx->start, block_ctx->dev->name);
 		return -1;
 	}
 
@@ -1446,18 +1426,17 @@ static int btrfsic_handle_extent_data(
 	if (BTRFS_FILE_EXTENT_REG != file_extent_item.type ||
 	    ((u64)0) == le64_to_cpu(file_extent_item.disk_bytenr)) {
 		if (state->print_mask & BTRFSIC_PRINT_MASK_VERY_VERBOSE)
-			printk(KERN_INFO "extent_data: type %u, disk_bytenr = %llu\n",
-			       file_extent_item.type,
-			       (unsigned long long)
-			       le64_to_cpu(file_extent_item.disk_bytenr));
+			pr_info("extent_data: type %u, disk_bytenr = %llu\n",
+				file_extent_item.type,
+				(unsigned long long)
+				le64_to_cpu(file_extent_item.disk_bytenr));
 		return 0;
 	}
 
 	if (file_extent_item_offset + sizeof(struct btrfs_file_extent_item) >
 	    block_ctx->len) {
-		printk(KERN_INFO
-		       "btrfsic: file item out of bounce at logical %llu, dev %s\n",
-		       block_ctx->start, block_ctx->dev->name);
+		pr_info("file item out of bounce at logical %llu, dev %s\n",
+			block_ctx->start, block_ctx->dev->name);
 		return -1;
 	}
 	btrfsic_read_from_block_data(block_ctx, &file_extent_item,
@@ -1470,13 +1449,12 @@ static int btrfsic_handle_extent_data(
 	generation = le64_to_cpu(file_extent_item.generation);
 
 	if (state->print_mask & BTRFSIC_PRINT_MASK_VERY_VERBOSE)
-		printk(KERN_INFO "extent_data: type %u, disk_bytenr = %llu,"
-		       " offset = %llu, num_bytes = %llu\n",
-		       file_extent_item.type,
-		       (unsigned long long)
-		       le64_to_cpu(file_extent_item.disk_bytenr),
-		       (unsigned long long)le64_to_cpu(file_extent_item.offset),
-		       (unsigned long long)num_bytes);
+		pr_info("extent_data: type %u, disk_bytenr = %llu, offset = %llu, num_bytes = %llu\n",
+			file_extent_item.type,
+			(unsigned long long)
+			le64_to_cpu(file_extent_item.disk_bytenr),
+			(unsigned long long)le64_to_cpu(file_extent_item.offset),
+			(unsigned long long)num_bytes);
 	while (num_bytes > 0) {
 		u32 chunk_len;
 		int num_copies;
@@ -1491,30 +1469,27 @@ static int btrfsic_handle_extent_data(
 		    btrfs_num_copies(state->root->fs_info,
 				     next_bytenr, state->datablock_size);
 		if (state->print_mask & BTRFSIC_PRINT_MASK_NUM_COPIES)
-			printk(KERN_INFO "num_copies(log_bytenr=%llu) = %d\n",
-			       (unsigned long long)next_bytenr, num_copies);
+			pr_info("num_copies(log_bytenr=%llu) = %d\n",
+				(unsigned long long)next_bytenr, num_copies);
 		for (mirror_num = 1; mirror_num <= num_copies; mirror_num++) {
 			struct btrfsic_block_data_ctx next_block_ctx;
 			struct btrfsic_block *next_block;
 			int block_was_created;
 
 			if (state->print_mask & BTRFSIC_PRINT_MASK_VERBOSE)
-				printk(KERN_INFO "btrfsic_handle_extent_data("
-				       "mirror_num=%d)\n", mirror_num);
+				pr_info("%s(mirror_num=%d)\n",
+					__func__, mirror_num);
 			if (state->print_mask & BTRFSIC_PRINT_MASK_VERY_VERBOSE)
-				printk(KERN_INFO
-				       "\tdisk_bytenr = %llu, num_bytes %u\n",
-				       (unsigned long long)next_bytenr,
-				       chunk_len);
+				pr_info("\tdisk_bytenr = %llu, num_bytes %u\n",
+					(unsigned long long)next_bytenr,
+					chunk_len);
 			ret = btrfsic_map_block(state, next_bytenr,
 						chunk_len, &next_block_ctx,
 						mirror_num);
 			if (ret) {
-				printk(KERN_INFO
-				       "btrfsic: btrfsic_map_block(@%llu,"
-				       " mirror=%d) failed!\n",
-				       (unsigned long long)next_bytenr,
-				       mirror_num);
+				pr_info("btrfsic_map_block(@%llu, mirror=%d) failed!\n",
+					(unsigned long long)next_bytenr,
+					mirror_num);
 				return -1;
 			}
 
@@ -1528,8 +1503,7 @@ static int btrfsic_handle_extent_data(
 					mirror_num,
 					&block_was_created);
 			if (NULL == next_block) {
-				printk(KERN_INFO
-				       "btrfsic: error, kmalloc failed!\n");
+				pr_info("error, kmalloc failed!\n");
 				btrfsic_release_block_ctx(&next_block_ctx);
 				return -1;
 			}
@@ -1537,19 +1511,14 @@ static int btrfsic_handle_extent_data(
 				if (next_block->logical_bytenr != next_bytenr &&
 				    !(!next_block->is_metadata &&
 				      0 == next_block->logical_bytenr)) {
-					printk(KERN_INFO
-					       "Referenced block"
-					       " @%llu (%s/%llu/%d)"
-					       " found in hash table, D,"
-					       " bytenr mismatch"
-					       " (!= stored %llu).\n",
-					       (unsigned long long)next_bytenr,
-					       next_block_ctx.dev->name,
-					       (unsigned long long)
-					       next_block_ctx.dev_bytenr,
-					       mirror_num,
-					       (unsigned long long)
-					       next_block->logical_bytenr);
+					pr_info("Referenced block @%llu (%s/%llu/%d) found in hash table, D, bytenr mismatch (!= stored %llu)\n",
+						(unsigned long long)next_bytenr,
+						next_block_ctx.dev->name,
+						(unsigned long long)
+						next_block_ctx.dev_bytenr,
+						mirror_num,
+						(unsigned long long)
+						next_block->logical_bytenr);
 				}
 				next_block->logical_bytenr = next_bytenr;
 				next_block->mirror_num = mirror_num;
@@ -1608,7 +1577,7 @@ static int btrfsic_map_block(struct btrfsic_state *state, u64 bytenr, u32 len,
 	kfree(multi);
 	if (NULL == block_ctx_out->dev) {
 		ret = -ENXIO;
-		printk(KERN_INFO "btrfsic: error, cannot lookup dev (#1)!\n");
+		pr_info("error, cannot lookup dev (#1)!\n");
 	}
 
 	return ret;
@@ -1628,7 +1597,7 @@ static int btrfsic_map_superblock(struct btrfsic_state *state, u64 bytenr,
 	if (NULL != block_ctx_out->dev) {
 		return 0;
 	} else {
-		printk(KERN_INFO "btrfsic: error, cannot lookup dev (#2)!\n");
+		pr_info("error, cannot lookup dev (#2)!\n");
 		return -ENXIO;
 	}
 }
@@ -1673,9 +1642,8 @@ static int btrfsic_read_block(struct btrfsic_state *state,
 	BUG_ON(block_ctx->pagev);
 	BUG_ON(block_ctx->mem_to_free);
 	if (block_ctx->dev_bytenr & ((u64)PAGE_CACHE_SIZE - 1)) {
-		printk(KERN_INFO
-		       "btrfsic: read_block() with unaligned bytenr %llu\n",
-		       (unsigned long long)block_ctx->dev_bytenr);
+		pr_info("read_block() with unaligned bytenr %llu\n",
+			(unsigned long long)block_ctx->dev_bytenr);
 		return -1;
 	}
 
@@ -1702,9 +1670,8 @@ static int btrfsic_read_block(struct btrfsic_state *state,
 
 		bio = btrfs_io_bio_alloc(GFP_NOFS, num_pages - i);
 		if (!bio) {
-			printk(KERN_INFO
-			       "btrfsic: bio_alloc() for %u pages failed!\n",
-			       num_pages - i);
+			pr_info("bio_alloc() for %u pages failed!\n",
+				num_pages - i);
 			return -1;
 		}
 		bio->bi_bdev = block_ctx->dev->bdev;
@@ -1719,8 +1686,7 @@ static int btrfsic_read_block(struct btrfsic_state *state,
 				break;
 		}
 		if (j == i) {
-			printk(KERN_INFO
-			       "btrfsic: error, failed to add a single page!\n");
+			pr_info("error, failed to add a single page!\n");
 			return -1;
 		}
 		submit_bio(READ, bio);
@@ -1729,9 +1695,8 @@ static int btrfsic_read_block(struct btrfsic_state *state,
 		wait_for_completion(&complete);
 
 		if (!test_bit(BIO_UPTODATE, &bio->bi_flags)) {
-			printk(KERN_INFO
-			       "btrfsic: read error at logical %llu dev %s!\n",
-			       block_ctx->start, block_ctx->dev->name);
+			pr_info("read error at logical %llu dev %s!\n",
+				block_ctx->start, block_ctx->dev->name);
 			bio_put(bio);
 			return -1;
 		}
@@ -1742,8 +1707,8 @@ static int btrfsic_read_block(struct btrfsic_state *state,
 	for (i = 0; i < num_pages; i++) {
 		block_ctx->datav[i] = kmap(block_ctx->pagev[i]);
 		if (!block_ctx->datav[i]) {
-			printk(KERN_INFO "btrfsic: kmap() failed (dev %s)!\n",
-			       block_ctx->dev->name);
+			pr_info("kmap() failed (dev %s)!\n",
+				block_ctx->dev->name);
 			return -1;
 		}
 	}
@@ -1762,7 +1727,7 @@ static void btrfsic_dump_database(struct btrfsic_state *state)
 
 	BUG_ON(NULL == state);
 
-	printk(KERN_INFO "all_blocks_list:\n");
+	pr_info("all_blocks_list:\n");
 	list_for_each(elem_all, &state->all_blocks_list) {
 		const struct btrfsic_block *const b_all =
 		    list_entry(elem_all, struct btrfsic_block,
@@ -1770,12 +1735,12 @@ static void btrfsic_dump_database(struct btrfsic_state *state)
 		struct list_head *elem_ref_to;
 		struct list_head *elem_ref_from;
 
-		printk(KERN_INFO "%c-block @%llu (%s/%llu/%d)\n",
-		       btrfsic_get_block_type(state, b_all),
-		       (unsigned long long)b_all->logical_bytenr,
-		       b_all->dev_state->name,
-		       (unsigned long long)b_all->dev_bytenr,
-		       b_all->mirror_num);
+		pr_info("%c-block @%llu (%s/%llu/%d)\n",
+			btrfsic_get_block_type(state, b_all),
+			(unsigned long long)b_all->logical_bytenr,
+			b_all->dev_state->name,
+			(unsigned long long)b_all->dev_bytenr,
+			b_all->mirror_num);
 
 		list_for_each(elem_ref_to, &b_all->ref_to_list) {
 			const struct btrfsic_block_link *const l =
@@ -1783,21 +1748,19 @@ static void btrfsic_dump_database(struct btrfsic_state *state)
 				       struct btrfsic_block_link,
 				       node_ref_to);
 
-			printk(KERN_INFO " %c @%llu (%s/%llu/%d)"
-			       " refers %u* to"
-			       " %c @%llu (%s/%llu/%d)\n",
-			       btrfsic_get_block_type(state, b_all),
-			       (unsigned long long)b_all->logical_bytenr,
-			       b_all->dev_state->name,
-			       (unsigned long long)b_all->dev_bytenr,
-			       b_all->mirror_num,
-			       l->ref_cnt,
-			       btrfsic_get_block_type(state, l->block_ref_to),
-			       (unsigned long long)
-			       l->block_ref_to->logical_bytenr,
-			       l->block_ref_to->dev_state->name,
-			       (unsigned long long)l->block_ref_to->dev_bytenr,
-			       l->block_ref_to->mirror_num);
+			pr_info(" %c @%llu (%s/%llu/%d) refers %u* to %c @%llu (%s/%llu/%d)\n",
+				btrfsic_get_block_type(state, b_all),
+				(unsigned long long)b_all->logical_bytenr,
+				b_all->dev_state->name,
+				(unsigned long long)b_all->dev_bytenr,
+				b_all->mirror_num,
+				l->ref_cnt,
+				btrfsic_get_block_type(state, l->block_ref_to),
+				(unsigned long long)
+				l->block_ref_to->logical_bytenr,
+				l->block_ref_to->dev_state->name,
+				(unsigned long long)l->block_ref_to->dev_bytenr,
+				l->block_ref_to->mirror_num);
 		}
 
 		list_for_each(elem_ref_from, &b_all->ref_from_list) {
@@ -1806,25 +1769,23 @@ static void btrfsic_dump_database(struct btrfsic_state *state)
 				       struct btrfsic_block_link,
 				       node_ref_from);
 
-			printk(KERN_INFO " %c @%llu (%s/%llu/%d)"
-			       " is ref %u* from"
-			       " %c @%llu (%s/%llu/%d)\n",
-			       btrfsic_get_block_type(state, b_all),
-			       (unsigned long long)b_all->logical_bytenr,
-			       b_all->dev_state->name,
-			       (unsigned long long)b_all->dev_bytenr,
-			       b_all->mirror_num,
-			       l->ref_cnt,
-			       btrfsic_get_block_type(state, l->block_ref_from),
-			       (unsigned long long)
-			       l->block_ref_from->logical_bytenr,
-			       l->block_ref_from->dev_state->name,
-			       (unsigned long long)
-			       l->block_ref_from->dev_bytenr,
-			       l->block_ref_from->mirror_num);
+			pr_info(" %c @%llu (%s/%llu/%d) is ref %u* from %c @%llu (%s/%llu/%d)\n",
+				btrfsic_get_block_type(state, b_all),
+				(unsigned long long)b_all->logical_bytenr,
+				b_all->dev_state->name,
+				(unsigned long long)b_all->dev_bytenr,
+				b_all->mirror_num,
+				l->ref_cnt,
+				btrfsic_get_block_type(state, l->block_ref_from),
+				(unsigned long long)
+				l->block_ref_from->logical_bytenr,
+				l->block_ref_from->dev_state->name,
+				(unsigned long long)
+				l->block_ref_from->dev_bytenr,
+				l->block_ref_from->mirror_num);
 		}
 
-		printk(KERN_INFO "\n");
+		pr_info("\n");
 	}
 }
 
@@ -1900,8 +1861,7 @@ again:
 					      mapped_datav[0])->bytenr);
 			if (num_pages * PAGE_CACHE_SIZE <
 			    BTRFS_SUPER_INFO_SIZE) {
-				printk(KERN_INFO
-				       "btrfsic: cannot work with too short bios!\n");
+				pr_info("cannot work with too short bios!\n");
 				return;
 			}
 			is_metadata = 1;
@@ -1909,8 +1869,7 @@ again:
 			processed_len = BTRFS_SUPER_INFO_SIZE;
 			if (state->print_mask &
 			    BTRFSIC_PRINT_MASK_TREE_BEFORE_SB_WRITE) {
-				printk(KERN_INFO
-				       "[before new superblock is written]:\n");
+				pr_info("[before new superblock is written]:\n");
 				btrfsic_dump_tree_sub(state, block, 0);
 			}
 		}
@@ -1918,8 +1877,7 @@ again:
 			if (!block->is_superblock) {
 				if (num_pages * PAGE_CACHE_SIZE <
 				    state->metablock_size) {
-					printk(KERN_INFO
-					       "btrfsic: cannot work with too short bios!\n");
+					pr_info("cannot work with too short bios!\n");
 					return;
 				}
 				processed_len = state->metablock_size;
@@ -1930,93 +1888,76 @@ again:
 							       dev_bytenr);
 			}
 			if (block->logical_bytenr != bytenr) {
-				printk(KERN_INFO
-				       "Written block @%llu (%s/%llu/%d)"
-				       " found in hash table, %c,"
-				       " bytenr mismatch"
-				       " (!= stored %llu).\n",
-				       (unsigned long long)bytenr,
-				       dev_state->name,
-				       (unsigned long long)dev_bytenr,
-				       block->mirror_num,
-				       btrfsic_get_block_type(state, block),
-				       (unsigned long long)
-				       block->logical_bytenr);
+				pr_info("Written block @%llu (%s/%llu/%d) found in hash table, %c, bytenr mismatch (!= stored %llu)\n",
+					(unsigned long long)bytenr,
+					dev_state->name,
+					(unsigned long long)dev_bytenr,
+					block->mirror_num,
+					btrfsic_get_block_type(state, block),
+					(unsigned long long)
+					block->logical_bytenr);
 				block->logical_bytenr = bytenr;
 			} else if (state->print_mask &
 				   BTRFSIC_PRINT_MASK_VERBOSE)
-				printk(KERN_INFO
-				       "Written block @%llu (%s/%llu/%d)"
-				       " found in hash table, %c.\n",
-				       (unsigned long long)bytenr,
-				       dev_state->name,
-				       (unsigned long long)dev_bytenr,
-				       block->mirror_num,
-				       btrfsic_get_block_type(state, block));
+				pr_info("Written block @%llu (%s/%llu/%d) found in hash table, %c\n",
+					(unsigned long long)bytenr,
+					dev_state->name,
+					(unsigned long long)dev_bytenr,
+					block->mirror_num,
+					btrfsic_get_block_type(state, block));
 		} else {
 			if (num_pages * PAGE_CACHE_SIZE <
 			    state->datablock_size) {
-				printk(KERN_INFO
-				       "btrfsic: cannot work with too short bios!\n");
+				pr_info("cannot work with too short bios!\n");
 				return;
 			}
 			processed_len = state->datablock_size;
 			bytenr = block->logical_bytenr;
 			if (state->print_mask & BTRFSIC_PRINT_MASK_VERBOSE)
-				printk(KERN_INFO
-				       "Written block @%llu (%s/%llu/%d)"
-				       " found in hash table, %c.\n",
-				       (unsigned long long)bytenr,
-				       dev_state->name,
-				       (unsigned long long)dev_bytenr,
-				       block->mirror_num,
-				       btrfsic_get_block_type(state, block));
+				pr_info("Written block @%llu (%s/%llu/%d) found in hash table, %c\n",
+					(unsigned long long)bytenr,
+					dev_state->name,
+					(unsigned long long)dev_bytenr,
+					block->mirror_num,
+					btrfsic_get_block_type(state, block));
 		}
 
 		if (state->print_mask & BTRFSIC_PRINT_MASK_VERBOSE)
-			printk(KERN_INFO
-			       "ref_to_list: %cE, ref_from_list: %cE\n",
-			       list_empty(&block->ref_to_list) ? ' ' : '!',
-			       list_empty(&block->ref_from_list) ? ' ' : '!');
+			pr_info("ref_to_list: %cE, ref_from_list: %cE\n",
+				list_empty(&block->ref_to_list) ? ' ' : '!',
+				list_empty(&block->ref_from_list) ? ' ' : '!');
 		if (btrfsic_is_block_ref_by_superblock(state, block, 0)) {
-			printk(KERN_INFO "btrfs: attempt to overwrite %c-block"
-			       " @%llu (%s/%llu/%d), old(gen=%llu,"
-			       " objectid=%llu, type=%d, offset=%llu),"
-			       " new(gen=%llu),"
-			       " which is referenced by most recent superblock"
-			       " (superblockgen=%llu)!\n",
-			       btrfsic_get_block_type(state, block),
-			       (unsigned long long)bytenr,
-			       dev_state->name,
-			       (unsigned long long)dev_bytenr,
-			       block->mirror_num,
-			       (unsigned long long)block->generation,
-			       (unsigned long long)
-			       le64_to_cpu(block->disk_key.objectid),
-			       block->disk_key.type,
-			       (unsigned long long)
-			       le64_to_cpu(block->disk_key.offset),
-			       (unsigned long long)
-			       le64_to_cpu(((struct btrfs_header *)
-					    mapped_datav[0])->generation),
-			       (unsigned long long)
-			       state->max_superblock_generation);
+			pr_info("attempt to overwrite %c-block @%llu (%s/%llu/%d), old(gen=%llu, objectid=%llu, type=%d, offset=%llu), new(gen=%llu), which is referenced by most recent superblock (superblockgen=%llu)!\n",
+				btrfsic_get_block_type(state, block),
+				(unsigned long long)bytenr,
+				dev_state->name,
+				(unsigned long long)dev_bytenr,
+				block->mirror_num,
+				(unsigned long long)block->generation,
+				(unsigned long long)
+				le64_to_cpu(block->disk_key.objectid),
+				block->disk_key.type,
+				(unsigned long long)
+				le64_to_cpu(block->disk_key.offset),
+				(unsigned long long)
+				le64_to_cpu(((struct btrfs_header *)
+					     mapped_datav[0])->generation),
+				(unsigned long long)
+				state->max_superblock_generation);
 			btrfsic_dump_tree(state);
 		}
 
 		if (!block->is_iodone && !block->never_written) {
-			printk(KERN_INFO "btrfs: attempt to overwrite %c-block"
-			       " @%llu (%s/%llu/%d), oldgen=%llu, newgen=%llu,"
-			       " which is not yet iodone!\n",
-			       btrfsic_get_block_type(state, block),
-			       (unsigned long long)bytenr,
-			       dev_state->name,
-			       (unsigned long long)dev_bytenr,
-			       block->mirror_num,
-			       (unsigned long long)block->generation,
-			       (unsigned long long)
-			       le64_to_cpu(((struct btrfs_header *)
-					    mapped_datav[0])->generation));
+			pr_info("attempt to overwrite %c-block @%llu (%s/%llu/%d), oldgen=%llu, newgen=%llu, which is not yet iodone!\n",
+				btrfsic_get_block_type(state, block),
+				(unsigned long long)bytenr,
+				dev_state->name,
+				(unsigned long long)dev_bytenr,
+				block->mirror_num,
+				(unsigned long long)block->generation,
+				(unsigned long long)
+				le64_to_cpu(((struct btrfs_header *)
+					     mapped_datav[0])->generation));
 			/* it would not be safe to go on */
 			btrfsic_dump_tree(state);
 			goto continue_loop;
@@ -2054,9 +1995,8 @@ again:
 			ret = btrfsic_map_block(state, bytenr, processed_len,
 						&block_ctx, 0);
 		if (ret) {
-			printk(KERN_INFO
-			       "btrfsic: btrfsic_map_block(root @%llu)"
-			       " failed!\n", (unsigned long long)bytenr);
+			pr_info("btrfsic_map_block(root @%llu) failed!\n",
+				(unsigned long long)bytenr);
 			goto continue_loop;
 		}
 		block_ctx.datav = mapped_datav;
@@ -2124,8 +2064,7 @@ again:
 						mapped_datav[0]);
 				if (state->print_mask &
 				    BTRFSIC_PRINT_MASK_TREE_AFTER_SB_WRITE) {
-					printk(KERN_INFO
-					"[after new superblock is written]:\n");
+					pr_info("[after new superblock is written]:\n");
 					btrfsic_dump_tree_sub(state, block, 0);
 				}
 			} else {
@@ -2137,10 +2076,8 @@ again:
 						0, 0);
 			}
 			if (ret)
-				printk(KERN_INFO
-				       "btrfsic: btrfsic_process_metablock"
-				       "(root @%llu) failed!\n",
-				       (unsigned long long)dev_bytenr);
+				pr_info("btrfsic_process_metablock(root @%llu) failed!\n",
+					(unsigned long long)dev_bytenr);
 		} else {
 			block->is_metadata = 0;
 			block->mirror_num = 0;	/* unknown */
@@ -2166,10 +2103,9 @@ again:
 		if (!is_metadata) {
 			processed_len = state->datablock_size;
 			if (state->print_mask & BTRFSIC_PRINT_MASK_VERBOSE)
-				printk(KERN_INFO "Written block (%s/%llu/?)"
-				       " !found in hash table, D.\n",
-				       dev_state->name,
-				       (unsigned long long)dev_bytenr);
+				pr_info("Written block (%s/%llu/?) !found in hash table, D\n",
+					dev_state->name,
+					(unsigned long long)dev_bytenr);
 			if (!state->include_extent_data) {
 				/* ignore that written D block */
 				goto continue_loop;
@@ -2189,20 +2125,16 @@ again:
 			btrfsic_cmp_log_and_dev_bytenr(state, bytenr, dev_state,
 						       dev_bytenr);
 			if (state->print_mask & BTRFSIC_PRINT_MASK_VERBOSE)
-				printk(KERN_INFO
-				       "Written block @%llu (%s/%llu/?)"
-				       " !found in hash table, M.\n",
-				       (unsigned long long)bytenr,
-				       dev_state->name,
-				       (unsigned long long)dev_bytenr);
+				pr_info("Written block @%llu (%s/%llu/?) !found in hash table, M\n",
+					(unsigned long long)bytenr,
+					dev_state->name,
+					(unsigned long long)dev_bytenr);
 
 			ret = btrfsic_map_block(state, bytenr, processed_len,
 						&block_ctx, 0);
 			if (ret) {
-				printk(KERN_INFO
-				       "btrfsic: btrfsic_map_block(root @%llu)"
-				       " failed!\n",
-				       (unsigned long long)dev_bytenr);
+				pr_info("btrfsic_map_block(root @%llu) failed!\n",
+					(unsigned long long)dev_bytenr);
 				goto continue_loop;
 			}
 		}
@@ -2214,7 +2146,7 @@ again:
 
 		block = btrfsic_block_alloc();
 		if (NULL == block) {
-			printk(KERN_INFO "btrfsic: error, kmalloc failed!\n");
+			pr_info("error, kmalloc failed!\n");
 			btrfsic_release_block_ctx(&block_ctx);
 			goto continue_loop;
 		}
@@ -2264,13 +2196,12 @@ again:
 			block->next_in_same_bio = NULL;
 		}
 		if (state->print_mask & BTRFSIC_PRINT_MASK_VERBOSE)
-			printk(KERN_INFO
-			       "New written %c-block @%llu (%s/%llu/%d)\n",
-			       is_metadata ? 'M' : 'D',
-			       (unsigned long long)block->logical_bytenr,
-			       block->dev_state->name,
-			       (unsigned long long)block->dev_bytenr,
-			       block->mirror_num);
+			pr_info("New written %c-block @%llu (%s/%llu/%d)\n",
+				is_metadata ? 'M' : 'D',
+				(unsigned long long)block->logical_bytenr,
+				block->dev_state->name,
+				(unsigned long long)block->dev_bytenr,
+				block->mirror_num);
 		list_add(&block->all_blocks_node, &state->all_blocks_list);
 		btrfsic_block_hashtable_add(block, &state->block_hashtable);
 
@@ -2278,10 +2209,8 @@ again:
 			ret = btrfsic_process_metablock(state, block,
 							&block_ctx, 0, 0);
 			if (ret)
-				printk(KERN_INFO
-				       "btrfsic: process_metablock(root @%llu)"
-				       " failed!\n",
-				       (unsigned long long)dev_bytenr);
+				pr_info("process_metablock(root @%llu) failed!\n",
+					(unsigned long long)dev_bytenr);
 		}
 		btrfsic_release_block_ctx(&block_ctx);
 	}
@@ -2315,25 +2244,23 @@ static void btrfsic_bio_end_io(struct bio *bp, int bio_error_status)
 
 		if ((dev_state->state->print_mask &
 		     BTRFSIC_PRINT_MASK_END_IO_BIO_BH))
-			printk(KERN_INFO
-			       "bio_end_io(err=%d) for %c @%llu (%s/%llu/%d)\n",
-			       bio_error_status,
-			       btrfsic_get_block_type(dev_state->state, block),
-			       (unsigned long long)block->logical_bytenr,
-			       dev_state->name,
-			       (unsigned long long)block->dev_bytenr,
-			       block->mirror_num);
+			pr_info("bio_end_io(err=%d) for %c @%llu (%s/%llu/%d)\n",
+				bio_error_status,
+				btrfsic_get_block_type(dev_state->state, block),
+				(unsigned long long)block->logical_bytenr,
+				dev_state->name,
+				(unsigned long long)block->dev_bytenr,
+				block->mirror_num);
 		next_block = block->next_in_same_bio;
 		block->iodone_w_error = iodone_w_error;
 		if (block->submit_bio_bh_rw & REQ_FLUSH) {
 			dev_state->last_flush_gen++;
 			if ((dev_state->state->print_mask &
 			     BTRFSIC_PRINT_MASK_END_IO_BIO_BH))
-				printk(KERN_INFO
-				       "bio_end_io() new %s flush_gen=%llu\n",
-				       dev_state->name,
-				       (unsigned long long)
-				       dev_state->last_flush_gen);
+				pr_info("bio_end_io() new %s flush_gen=%llu\n",
+					dev_state->name,
+					(unsigned long long)
+					dev_state->last_flush_gen);
 		}
 		if (block->submit_bio_bh_rw & REQ_FUA)
 			block->flush_gen = 0; /* FUA completed means block is
@@ -2354,24 +2281,22 @@ static void btrfsic_bh_end_io(struct buffer_head *bh, int uptodate)
 	BUG_ON(NULL == block);
 	dev_state = block->dev_state;
 	if ((dev_state->state->print_mask & BTRFSIC_PRINT_MASK_END_IO_BIO_BH))
-		printk(KERN_INFO
-		       "bh_end_io(error=%d) for %c @%llu (%s/%llu/%d)\n",
-		       iodone_w_error,
-		       btrfsic_get_block_type(dev_state->state, block),
-		       (unsigned long long)block->logical_bytenr,
-		       block->dev_state->name,
-		       (unsigned long long)block->dev_bytenr,
-		       block->mirror_num);
+		pr_info("bh_end_io(error=%d) for %c @%llu (%s/%llu/%d)\n",
+			iodone_w_error,
+			btrfsic_get_block_type(dev_state->state, block),
+			(unsigned long long)block->logical_bytenr,
+			block->dev_state->name,
+			(unsigned long long)block->dev_bytenr,
+			block->mirror_num);
 
 	block->iodone_w_error = iodone_w_error;
 	if (block->submit_bio_bh_rw & REQ_FLUSH) {
 		dev_state->last_flush_gen++;
 		if ((dev_state->state->print_mask &
 		     BTRFSIC_PRINT_MASK_END_IO_BIO_BH))
-			printk(KERN_INFO
-			       "bh_end_io() new %s flush_gen=%llu\n",
-			       dev_state->name,
-			       (unsigned long long)dev_state->last_flush_gen);
+			pr_info("bh_end_io() new %s flush_gen=%llu\n",
+				dev_state->name,
+				(unsigned long long)dev_state->last_flush_gen);
 	}
 	if (block->submit_bio_bh_rw & REQ_FUA)
 		block->flush_gen = 0; /* FUA completed means block is on disk */
@@ -2393,30 +2318,26 @@ static int btrfsic_process_written_superblock(
 	if (!(superblock->generation > state->max_superblock_generation ||
 	      0 == state->max_superblock_generation)) {
 		if (state->print_mask & BTRFSIC_PRINT_MASK_SUPERBLOCK_WRITE)
-			printk(KERN_INFO
-			       "btrfsic: superblock @%llu (%s/%llu/%d)"
-			       " with old gen %llu <= %llu\n",
-			       (unsigned long long)superblock->logical_bytenr,
-			       superblock->dev_state->name,
-			       (unsigned long long)superblock->dev_bytenr,
-			       superblock->mirror_num,
-			       (unsigned long long)
-			       btrfs_super_generation(super_hdr),
-			       (unsigned long long)
-			       state->max_superblock_generation);
+			pr_info("superblock @%llu (%s/%llu/%d) with old gen %llu <= %llu\n",
+				(unsigned long long)superblock->logical_bytenr,
+				superblock->dev_state->name,
+				(unsigned long long)superblock->dev_bytenr,
+				superblock->mirror_num,
+				(unsigned long long)
+				btrfs_super_generation(super_hdr),
+				(unsigned long long)
+				state->max_superblock_generation);
 	} else {
 		if (state->print_mask & BTRFSIC_PRINT_MASK_SUPERBLOCK_WRITE)
-			printk(KERN_INFO
-			       "btrfsic: got new superblock @%llu (%s/%llu/%d)"
-			       " with new gen %llu > %llu\n",
-			       (unsigned long long)superblock->logical_bytenr,
-			       superblock->dev_state->name,
-			       (unsigned long long)superblock->dev_bytenr,
-			       superblock->mirror_num,
-			       (unsigned long long)
-			       btrfs_super_generation(super_hdr),
-			       (unsigned long long)
-			       state->max_superblock_generation);
+			pr_info("got new superblock @%llu (%s/%llu/%d) with new gen %llu > %llu\n",
+				(unsigned long long)superblock->logical_bytenr,
+				superblock->dev_state->name,
+				(unsigned long long)superblock->dev_bytenr,
+				superblock->mirror_num,
+				(unsigned long long)
+				btrfs_super_generation(super_hdr),
+				(unsigned long long)
+				state->max_superblock_generation);
 
 		state->max_superblock_generation =
 		    btrfs_super_generation(super_hdr);
@@ -2445,8 +2366,8 @@ static int btrfsic_process_written_superblock(
 			next_bytenr = btrfs_super_root(super_hdr);
 			if (state->print_mask &
 			    BTRFSIC_PRINT_MASK_ROOT_CHUNK_LOG_TREE_LOCATION)
-				printk(KERN_INFO "root@%llu\n",
-				       (unsigned long long)next_bytenr);
+				pr_info("root@%llu\n",
+					(unsigned long long)next_bytenr);
 			break;
 		case 1:
 			tmp_disk_key.objectid =
@@ -2455,8 +2376,8 @@ static int btrfsic_process_written_superblock(
 			next_bytenr = btrfs_super_chunk_root(super_hdr);
 			if (state->print_mask &
 			    BTRFSIC_PRINT_MASK_ROOT_CHUNK_LOG_TREE_LOCATION)
-				printk(KERN_INFO "chunk@%llu\n",
-				       (unsigned long long)next_bytenr);
+				pr_info("chunk@%llu\n",
+					(unsigned long long)next_bytenr);
 			break;
 		case 2:
 			tmp_disk_key.objectid =
@@ -2467,8 +2388,8 @@ static int btrfsic_process_written_superblock(
 				continue;
 			if (state->print_mask &
 			    BTRFSIC_PRINT_MASK_ROOT_CHUNK_LOG_TREE_LOCATION)
-				printk(KERN_INFO "log@%llu\n",
-				       (unsigned long long)next_bytenr);
+				pr_info("log@%llu\n",
+					(unsigned long long)next_bytenr);
 			break;
 		}
 
@@ -2476,25 +2397,22 @@ static int btrfsic_process_written_superblock(
 		    btrfs_num_copies(state->root->fs_info,
 				     next_bytenr, BTRFS_SUPER_INFO_SIZE);
 		if (state->print_mask & BTRFSIC_PRINT_MASK_NUM_COPIES)
-			printk(KERN_INFO "num_copies(log_bytenr=%llu) = %d\n",
-			       (unsigned long long)next_bytenr, num_copies);
+			pr_info("num_copies(log_bytenr=%llu) = %d\n",
+				(unsigned long long)next_bytenr, num_copies);
 		for (mirror_num = 1; mirror_num <= num_copies; mirror_num++) {
 			int was_created;
 
 			if (state->print_mask & BTRFSIC_PRINT_MASK_VERBOSE)
-				printk(KERN_INFO
-				       "btrfsic_process_written_superblock("
-				       "mirror_num=%d)\n", mirror_num);
+				pr_info("btrfsic_process_written_superblock(mirror_num=%d)\n",
+					mirror_num);
 			ret = btrfsic_map_block(state, next_bytenr,
 						BTRFS_SUPER_INFO_SIZE,
 						&tmp_next_block_ctx,
 						mirror_num);
 			if (ret) {
-				printk(KERN_INFO
-				       "btrfsic: btrfsic_map_block(@%llu,"
-				       " mirror=%d) failed!\n",
-				       (unsigned long long)next_bytenr,
-				       mirror_num);
+				pr_info("btrfsic_map_block(@%llu, mirror=%d) failed!\n",
+					(unsigned long long)next_bytenr,
+					mirror_num);
 				return -1;
 			}
 
@@ -2506,8 +2424,7 @@ static int btrfsic_process_written_superblock(
 					mirror_num,
 					&was_created);
 			if (NULL == next_block) {
-				printk(KERN_INFO
-				       "btrfsic: error, kmalloc failed!\n");
+				pr_info("error, kmalloc failed!\n");
 				btrfsic_release_block_ctx(&tmp_next_block_ctx);
 				return -1;
 			}
@@ -2558,8 +2475,7 @@ static int btrfsic_check_all_ref_blocks(struct btrfsic_state *state,
 		 * by the most recent super block.
 		 */
 		if (state->print_mask & BTRFSIC_PRINT_MASK_VERBOSE)
-			printk(KERN_INFO
-			       "btrfsic: abort cyclic linkage (case 1).\n");
+			pr_info("abort cyclic linkage (case 1)\n");
 
 		return ret;
 	}
@@ -2574,54 +2490,46 @@ static int btrfsic_check_all_ref_blocks(struct btrfsic_state *state,
 			       node_ref_to);
 
 		if (state->print_mask & BTRFSIC_PRINT_MASK_VERBOSE)
-			printk(KERN_INFO
-			       "rl=%d, %c @%llu (%s/%llu/%d)"
-			       " %u* refers to %c @%llu (%s/%llu/%d)\n",
-			       recursion_level,
-			       btrfsic_get_block_type(state, block),
-			       (unsigned long long)block->logical_bytenr,
-			       block->dev_state->name,
-			       (unsigned long long)block->dev_bytenr,
-			       block->mirror_num,
-			       l->ref_cnt,
-			       btrfsic_get_block_type(state, l->block_ref_to),
-			       (unsigned long long)
-			       l->block_ref_to->logical_bytenr,
-			       l->block_ref_to->dev_state->name,
-			       (unsigned long long)l->block_ref_to->dev_bytenr,
-			       l->block_ref_to->mirror_num);
+			pr_info("rl=%d, %c @%llu (%s/%llu/%d) %u* refers to %c @%llu (%s/%llu/%d)\n",
+				recursion_level,
+				btrfsic_get_block_type(state, block),
+				(unsigned long long)block->logical_bytenr,
+				block->dev_state->name,
+				(unsigned long long)block->dev_bytenr,
+				block->mirror_num,
+				l->ref_cnt,
+				btrfsic_get_block_type(state, l->block_ref_to),
+				(unsigned long long)
+				l->block_ref_to->logical_bytenr,
+				l->block_ref_to->dev_state->name,
+				(unsigned long long)l->block_ref_to->dev_bytenr,
+				l->block_ref_to->mirror_num);
 		if (l->block_ref_to->never_written) {
-			printk(KERN_INFO "btrfs: attempt to write superblock"
-			       " which references block %c @%llu (%s/%llu/%d)"
-			       " which is never written!\n",
-			       btrfsic_get_block_type(state, l->block_ref_to),
-			       (unsigned long long)
-			       l->block_ref_to->logical_bytenr,
-			       l->block_ref_to->dev_state->name,
-			       (unsigned long long)l->block_ref_to->dev_bytenr,
-			       l->block_ref_to->mirror_num);
+			pr_info("attempt to write superblock which references block %c @%llu (%s/%llu/%d) which is never written!\n",
+				btrfsic_get_block_type(state, l->block_ref_to),
+				(unsigned long long)
+				l->block_ref_to->logical_bytenr,
+				l->block_ref_to->dev_state->name,
+				(unsigned long long)l->block_ref_to->dev_bytenr,
+				l->block_ref_to->mirror_num);
 			ret = -1;
 		} else if (!l->block_ref_to->is_iodone) {
-			printk(KERN_INFO "btrfs: attempt to write superblock"
-			       " which references block %c @%llu (%s/%llu/%d)"
-			       " which is not yet iodone!\n",
-			       btrfsic_get_block_type(state, l->block_ref_to),
-			       (unsigned long long)
-			       l->block_ref_to->logical_bytenr,
-			       l->block_ref_to->dev_state->name,
-			       (unsigned long long)l->block_ref_to->dev_bytenr,
-			       l->block_ref_to->mirror_num);
+				pr_info("attempt to write superblock which references block %c @%llu (%s/%llu/%d) which is not yet iodone!\n",
+					btrfsic_get_block_type(state, l->block_ref_to),
+					(unsigned long long)
+					l->block_ref_to->logical_bytenr,
+					l->block_ref_to->dev_state->name,
+					(unsigned long long)l->block_ref_to->dev_bytenr,
+					l->block_ref_to->mirror_num);
 			ret = -1;
 		} else if (l->block_ref_to->iodone_w_error) {
-			printk(KERN_INFO "btrfs: attempt to write superblock"
-			       " which references block %c @%llu (%s/%llu/%d)"
-			       " which has write error!\n",
-			       btrfsic_get_block_type(state, l->block_ref_to),
-			       (unsigned long long)
-			       l->block_ref_to->logical_bytenr,
-			       l->block_ref_to->dev_state->name,
-			       (unsigned long long)l->block_ref_to->dev_bytenr,
-			       l->block_ref_to->mirror_num);
+			pr_info("attempt to write superblock which references block %c @%llu (%s/%llu/%d) which has write error!\n",
+				btrfsic_get_block_type(state, l->block_ref_to),
+				(unsigned long long)
+				l->block_ref_to->logical_bytenr,
+				l->block_ref_to->dev_state->name,
+				(unsigned long long)l->block_ref_to->dev_bytenr,
+				l->block_ref_to->mirror_num);
 			ret = -1;
 		} else if (l->parent_generation !=
 			   l->block_ref_to->generation &&
@@ -2629,35 +2537,28 @@ static int btrfsic_check_all_ref_blocks(struct btrfsic_state *state,
 			   l->parent_generation &&
 			   BTRFSIC_GENERATION_UNKNOWN !=
 			   l->block_ref_to->generation) {
-			printk(KERN_INFO "btrfs: attempt to write superblock"
-			       " which references block %c @%llu (%s/%llu/%d)"
-			       " with generation %llu !="
-			       " parent generation %llu!\n",
-			       btrfsic_get_block_type(state, l->block_ref_to),
-			       (unsigned long long)
-			       l->block_ref_to->logical_bytenr,
-			       l->block_ref_to->dev_state->name,
-			       (unsigned long long)l->block_ref_to->dev_bytenr,
-			       l->block_ref_to->mirror_num,
-			       (unsigned long long)l->block_ref_to->generation,
-			       (unsigned long long)l->parent_generation);
+			pr_info("attempt to write superblock which references block %c @%llu (%s/%llu/%d) with generation %llu != parent generation %llu!\n",
+				btrfsic_get_block_type(state, l->block_ref_to),
+				(unsigned long long)
+				l->block_ref_to->logical_bytenr,
+				l->block_ref_to->dev_state->name,
+				(unsigned long long)l->block_ref_to->dev_bytenr,
+				l->block_ref_to->mirror_num,
+				(unsigned long long)l->block_ref_to->generation,
+				(unsigned long long)l->parent_generation);
 			ret = -1;
 		} else if (l->block_ref_to->flush_gen >
 			   l->block_ref_to->dev_state->last_flush_gen) {
-			printk(KERN_INFO "btrfs: attempt to write superblock"
-			       " which references block %c @%llu (%s/%llu/%d)"
-			       " which is not flushed out of disk's write cache"
-			       " (block flush_gen=%llu,"
-			       " dev->flush_gen=%llu)!\n",
-			       btrfsic_get_block_type(state, l->block_ref_to),
-			       (unsigned long long)
-			       l->block_ref_to->logical_bytenr,
-			       l->block_ref_to->dev_state->name,
-			       (unsigned long long)l->block_ref_to->dev_bytenr,
-			       l->block_ref_to->mirror_num,
-			       (unsigned long long)block->flush_gen,
-			       (unsigned long long)
-			       l->block_ref_to->dev_state->last_flush_gen);
+			pr_info("attempt to write superblock which references block %c @%llu (%s/%llu/%d) which is not flushed out of disk's write cache (block flush_gen=%llu, dev->flush_gen=%llu)!\n",
+				btrfsic_get_block_type(state, l->block_ref_to),
+				(unsigned long long)
+				l->block_ref_to->logical_bytenr,
+				l->block_ref_to->dev_state->name,
+				(unsigned long long)l->block_ref_to->dev_bytenr,
+				l->block_ref_to->mirror_num,
+				(unsigned long long)block->flush_gen,
+				(unsigned long long)
+				l->block_ref_to->dev_state->last_flush_gen);
 			ret = -1;
 		} else if (-1 == btrfsic_check_all_ref_blocks(state,
 							      l->block_ref_to,
@@ -2680,8 +2581,7 @@ static int btrfsic_is_block_ref_by_superblock(
 	if (recursion_level >= 3 + BTRFS_MAX_LEVEL) {
 		/* refer to comment at "abort cyclic linkage (case 1)" */
 		if (state->print_mask & BTRFSIC_PRINT_MASK_VERBOSE)
-			printk(KERN_INFO
-			       "btrfsic: abort cyclic linkage (case 2).\n");
+			pr_info("abort cyclic linkage (case 2)\n");
 
 		return 0;
 	}
@@ -2696,23 +2596,21 @@ static int btrfsic_is_block_ref_by_superblock(
 			       node_ref_from);
 
 		if (state->print_mask & BTRFSIC_PRINT_MASK_VERBOSE)
-			printk(KERN_INFO
-			       "rl=%d, %c @%llu (%s/%llu/%d)"
-			       " is ref %u* from %c @%llu (%s/%llu/%d)\n",
-			       recursion_level,
-			       btrfsic_get_block_type(state, block),
-			       (unsigned long long)block->logical_bytenr,
-			       block->dev_state->name,
-			       (unsigned long long)block->dev_bytenr,
-			       block->mirror_num,
-			       l->ref_cnt,
-			       btrfsic_get_block_type(state, l->block_ref_from),
-			       (unsigned long long)
-			       l->block_ref_from->logical_bytenr,
-			       l->block_ref_from->dev_state->name,
-			       (unsigned long long)
-			       l->block_ref_from->dev_bytenr,
-			       l->block_ref_from->mirror_num);
+			pr_info("rl=%d, %c @%llu (%s/%llu/%d) is ref %u* from %c @%llu (%s/%llu/%d)\n",
+				recursion_level,
+				btrfsic_get_block_type(state, block),
+				(unsigned long long)block->logical_bytenr,
+				block->dev_state->name,
+				(unsigned long long)block->dev_bytenr,
+				block->mirror_num,
+				l->ref_cnt,
+				btrfsic_get_block_type(state, l->block_ref_from),
+				(unsigned long long)
+				l->block_ref_from->logical_bytenr,
+				l->block_ref_from->dev_state->name,
+				(unsigned long long)
+				l->block_ref_from->dev_bytenr,
+				l->block_ref_from->mirror_num);
 		if (l->block_ref_from->is_superblock &&
 		    state->latest_superblock->dev_bytenr ==
 		    l->block_ref_from->dev_bytenr &&
@@ -2732,39 +2630,35 @@ static int btrfsic_is_block_ref_by_superblock(
 static void btrfsic_print_add_link(const struct btrfsic_state *state,
 				   const struct btrfsic_block_link *l)
 {
-	printk(KERN_INFO
-	       "Add %u* link from %c @%llu (%s/%llu/%d)"
-	       " to %c @%llu (%s/%llu/%d).\n",
-	       l->ref_cnt,
-	       btrfsic_get_block_type(state, l->block_ref_from),
-	       (unsigned long long)l->block_ref_from->logical_bytenr,
-	       l->block_ref_from->dev_state->name,
-	       (unsigned long long)l->block_ref_from->dev_bytenr,
-	       l->block_ref_from->mirror_num,
-	       btrfsic_get_block_type(state, l->block_ref_to),
-	       (unsigned long long)l->block_ref_to->logical_bytenr,
-	       l->block_ref_to->dev_state->name,
-	       (unsigned long long)l->block_ref_to->dev_bytenr,
-	       l->block_ref_to->mirror_num);
+	pr_info("Add %u* link from %c @%llu (%s/%llu/%d) to %c @%llu (%s/%llu/%d)\n",
+		l->ref_cnt,
+		btrfsic_get_block_type(state, l->block_ref_from),
+		(unsigned long long)l->block_ref_from->logical_bytenr,
+		l->block_ref_from->dev_state->name,
+		(unsigned long long)l->block_ref_from->dev_bytenr,
+		l->block_ref_from->mirror_num,
+		btrfsic_get_block_type(state, l->block_ref_to),
+		(unsigned long long)l->block_ref_to->logical_bytenr,
+		l->block_ref_to->dev_state->name,
+		(unsigned long long)l->block_ref_to->dev_bytenr,
+		l->block_ref_to->mirror_num);
 }
 
 static void btrfsic_print_rem_link(const struct btrfsic_state *state,
 				   const struct btrfsic_block_link *l)
 {
-	printk(KERN_INFO
-	       "Rem %u* link from %c @%llu (%s/%llu/%d)"
-	       " to %c @%llu (%s/%llu/%d).\n",
-	       l->ref_cnt,
-	       btrfsic_get_block_type(state, l->block_ref_from),
-	       (unsigned long long)l->block_ref_from->logical_bytenr,
-	       l->block_ref_from->dev_state->name,
-	       (unsigned long long)l->block_ref_from->dev_bytenr,
-	       l->block_ref_from->mirror_num,
-	       btrfsic_get_block_type(state, l->block_ref_to),
-	       (unsigned long long)l->block_ref_to->logical_bytenr,
-	       l->block_ref_to->dev_state->name,
-	       (unsigned long long)l->block_ref_to->dev_bytenr,
-	       l->block_ref_to->mirror_num);
+	pr_info("Rem %u* link from %c @%llu (%s/%llu/%d) to %c @%llu (%s/%llu/%d)\n",
+		l->ref_cnt,
+		btrfsic_get_block_type(state, l->block_ref_from),
+		(unsigned long long)l->block_ref_from->logical_bytenr,
+		l->block_ref_from->dev_state->name,
+		(unsigned long long)l->block_ref_from->dev_bytenr,
+		l->block_ref_from->mirror_num,
+		btrfsic_get_block_type(state, l->block_ref_to),
+		(unsigned long long)l->block_ref_to->logical_bytenr,
+		l->block_ref_to->dev_state->name,
+		(unsigned long long)l->block_ref_to->dev_bytenr,
+		l->block_ref_to->mirror_num);
 }
 
 static char btrfsic_get_block_type(const struct btrfsic_state *state,
@@ -2873,8 +2767,7 @@ static struct btrfsic_block_link *btrfsic_block_link_lookup_or_add(
 	if (NULL == l) {
 		l = btrfsic_block_link_alloc();
 		if (NULL == l) {
-			printk(KERN_INFO
-			       "btrfsic: error, kmalloc" " failed!\n");
+			pr_info("error, kmalloc failed!\n");
 			return NULL;
 		}
 
@@ -2921,13 +2814,12 @@ static struct btrfsic_block *btrfsic_block_lookup_or_add(
 
 		block = btrfsic_block_alloc();
 		if (NULL == block) {
-			printk(KERN_INFO "btrfsic: error, kmalloc failed!\n");
+			pr_info("error, kmalloc failed!\n");
 			return NULL;
 		}
 		dev_state = btrfsic_dev_state_lookup(block_ctx->dev->bdev);
 		if (NULL == dev_state) {
-			printk(KERN_INFO
-			       "btrfsic: error, lookup dev_state failed!\n");
+			pr_info("error, lookup dev_state failed!\n");
 			btrfsic_block_free(block);
 			return NULL;
 		}
@@ -2939,14 +2831,13 @@ static struct btrfsic_block *btrfsic_block_lookup_or_add(
 		block->never_written = never_written;
 		block->mirror_num = mirror_num;
 		if (state->print_mask & BTRFSIC_PRINT_MASK_VERBOSE)
-			printk(KERN_INFO
-			       "New %s%c-block @%llu (%s/%llu/%d)\n",
-			       additional_string,
-			       btrfsic_get_block_type(state, block),
-			       (unsigned long long)block->logical_bytenr,
-			       dev_state->name,
-			       (unsigned long long)block->dev_bytenr,
-			       mirror_num);
+			pr_info("New %s%c-block @%llu (%s/%llu/%d)\n",
+				additional_string,
+				btrfsic_get_block_type(state, block),
+				(unsigned long long)block->logical_bytenr,
+				dev_state->name,
+				(unsigned long long)block->dev_bytenr,
+				mirror_num);
 		list_add(&block->all_blocks_node, &state->all_blocks_list);
 		btrfsic_block_hashtable_add(block, &state->block_hashtable);
 		if (NULL != was_created)
@@ -2977,10 +2868,8 @@ static void btrfsic_cmp_log_and_dev_bytenr(struct btrfsic_state *state,
 		ret = btrfsic_map_block(state, bytenr, state->metablock_size,
 					&block_ctx, mirror_num);
 		if (ret) {
-			printk(KERN_INFO "btrfsic:"
-			       " btrfsic_map_block(logical @%llu,"
-			       " mirror %d) failed!\n",
-			       (unsigned long long)bytenr, mirror_num);
+			pr_info("btrfsic_map_block(logical @%llu, mirror %d) failed!\n",
+				(unsigned long long)bytenr, mirror_num);
 			continue;
 		}
 
@@ -2994,11 +2883,9 @@ static void btrfsic_cmp_log_and_dev_bytenr(struct btrfsic_state *state,
 	}
 
 	if (!match) {
-		printk(KERN_INFO "btrfs: attempt to write M-block which contains logical bytenr that doesn't map to dev+physical bytenr of submit_bio,"
-		       " buffer->log_bytenr=%llu, submit_bio(bdev=%s,"
-		       " phys_bytenr=%llu)!\n",
-		       (unsigned long long)bytenr, dev_state->name,
-		       (unsigned long long)dev_bytenr);
+		pr_info("attempt to write M-block which contains logical bytenr that doesn't map to dev+physical bytenr of submit_bio, buffer->log_bytenr=%llu, submit_bio(bdev=%s, phys_bytenr=%llu)!\n",
+			(unsigned long long)bytenr, dev_state->name,
+			(unsigned long long)dev_bytenr);
 		for (mirror_num = 1; mirror_num <= num_copies; mirror_num++) {
 			ret = btrfsic_map_block(state, bytenr,
 						state->metablock_size,
@@ -3006,12 +2893,11 @@ static void btrfsic_cmp_log_and_dev_bytenr(struct btrfsic_state *state,
 			if (ret)
 				continue;
 
-			printk(KERN_INFO "Read logical bytenr @%llu maps to"
-			       " (%s/%llu/%d)\n",
-			       (unsigned long long)bytenr,
-			       block_ctx.dev->name,
-			       (unsigned long long)block_ctx.dev_bytenr,
-			       mirror_num);
+			pr_info("Read logical bytenr @%llu maps to (%s/%llu/%d)\n",
+				(unsigned long long)bytenr,
+				block_ctx.dev->name,
+				(unsigned long long)block_ctx.dev_bytenr,
+				mirror_num);
 		}
 		WARN_ON(1);
 	}
@@ -3047,31 +2933,25 @@ int btrfsic_submit_bh(int rw, struct buffer_head *bh)
 		dev_bytenr = 4096 * bh->b_blocknr;
 		if (dev_state->state->print_mask &
 		    BTRFSIC_PRINT_MASK_SUBMIT_BIO_BH)
-			printk(KERN_INFO
-			       "submit_bh(rw=0x%x, blocknr=%lu (bytenr %llu),"
-			       " size=%lu, data=%p, bdev=%p)\n",
-			       rw, (unsigned long)bh->b_blocknr,
-			       (unsigned long long)dev_bytenr,
-			       (unsigned long)bh->b_size, bh->b_data,
-			       bh->b_bdev);
+			pr_info("submit_bh(rw=0x%x, blocknr=%lu (bytenr %llu), size=%lu, data=%p, bdev=%p)\n",
+				rw, (unsigned long)bh->b_blocknr,
+				(unsigned long long)dev_bytenr,
+				(unsigned long)bh->b_size, bh->b_data,
+				bh->b_bdev);
 		btrfsic_process_written_block(dev_state, dev_bytenr,
 					      &bh->b_data, 1, NULL,
 					      NULL, bh, rw);
 	} else if (NULL != dev_state && (rw & REQ_FLUSH)) {
 		if (dev_state->state->print_mask &
 		    BTRFSIC_PRINT_MASK_SUBMIT_BIO_BH)
-			printk(KERN_INFO
-			       "submit_bh(rw=0x%x FLUSH, bdev=%p)\n",
-			       rw, bh->b_bdev);
+			pr_info("submit_bh(rw=0x%x FLUSH, bdev=%p)\n",
+				rw, bh->b_bdev);
 		if (!dev_state->dummy_block_for_bio_bh_flush.is_iodone) {
 			if ((dev_state->state->print_mask &
 			     (BTRFSIC_PRINT_MASK_SUBMIT_BIO_BH |
 			      BTRFSIC_PRINT_MASK_VERBOSE)))
-				printk(KERN_INFO
-				       "btrfsic_submit_bh(%s) with FLUSH"
-				       " but dummy block already in use"
-				       " (ignored)!\n",
-				       dev_state->name);
+				pr_info("btrfsic_submit_bh(%s) with FLUSH but dummy block already in use (ignored)!\n",
+					dev_state->name);
 		} else {
 			struct btrfsic_block *const block =
 				&dev_state->dummy_block_for_bio_bh_flush;
@@ -3116,12 +2996,10 @@ void btrfsic_submit_bio(int rw, struct bio *bio)
 		bio_is_patched = 0;
 		if (dev_state->state->print_mask &
 		    BTRFSIC_PRINT_MASK_SUBMIT_BIO_BH)
-			printk(KERN_INFO
-			       "submit_bio(rw=0x%x, bi_vcnt=%u,"
-			       " bi_sector=%lu (bytenr %llu), bi_bdev=%p)\n",
-			       rw, bio->bi_vcnt, (unsigned long)bio->bi_sector,
-			       (unsigned long long)dev_bytenr,
-			       bio->bi_bdev);
+			pr_info("submit_bio(rw=0x%x, bi_vcnt=%u, bi_sector=%lu (bytenr %llu), bi_bdev=%p)\n",
+				rw, bio->bi_vcnt, (unsigned long)bio->bi_sector,
+				(unsigned long long)dev_bytenr,
+				bio->bi_bdev);
 
 		mapped_datav = kmalloc(sizeof(*mapped_datav) * bio->bi_vcnt,
 				       GFP_NOFS);
@@ -3143,11 +3021,10 @@ void btrfsic_submit_bio(int rw, struct bio *bio)
 			    (dev_state->state->print_mask &
 			     (BTRFSIC_PRINT_MASK_SUBMIT_BIO_BH |
 			      BTRFSIC_PRINT_MASK_VERBOSE)))
-				printk(KERN_INFO
-				       "#%u: page=%p, len=%u, offset=%u\n",
-				       i, bio->bi_io_vec[i].bv_page,
-				       bio->bi_io_vec[i].bv_len,
-				       bio->bi_io_vec[i].bv_offset);
+				pr_info("#%u: page=%p, len=%u, offset=%u\n",
+					i, bio->bi_io_vec[i].bv_page,
+					bio->bi_io_vec[i].bv_len,
+					bio->bi_io_vec[i].bv_offset);
 		}
 		btrfsic_process_written_block(dev_state, dev_bytenr,
 					      mapped_datav, bio->bi_vcnt,
@@ -3161,18 +3038,14 @@ void btrfsic_submit_bio(int rw, struct bio *bio)
 	} else if (NULL != dev_state && (rw & REQ_FLUSH)) {
 		if (dev_state->state->print_mask &
 		    BTRFSIC_PRINT_MASK_SUBMIT_BIO_BH)
-			printk(KERN_INFO
-			       "submit_bio(rw=0x%x FLUSH, bdev=%p)\n",
-			       rw, bio->bi_bdev);
+			pr_info("submit_bio(rw=0x%x FLUSH, bdev=%p)\n",
+				rw, bio->bi_bdev);
 		if (!dev_state->dummy_block_for_bio_bh_flush.is_iodone) {
 			if ((dev_state->state->print_mask &
 			     (BTRFSIC_PRINT_MASK_SUBMIT_BIO_BH |
 			      BTRFSIC_PRINT_MASK_VERBOSE)))
-				printk(KERN_INFO
-				       "btrfsic_submit_bio(%s) with FLUSH"
-				       " but dummy block already in use"
-				       " (ignored)!\n",
-				       dev_state->name);
+				pr_info("btrfsic_submit_bio(%s) with FLUSH but dummy block already in use (ignored)!\n",
+					dev_state->name);
 		} else {
 			struct btrfsic_block *const block =
 				&dev_state->dummy_block_for_bio_bh_flush;
@@ -3205,32 +3078,28 @@ int btrfsic_mount(struct btrfs_root *root,
 	struct btrfs_device *device;
 
 	if (root->nodesize != root->leafsize) {
-		printk(KERN_INFO
-		       "btrfsic: cannot handle nodesize %d != leafsize %d!\n",
-		       root->nodesize, root->leafsize);
+		pr_info("cannot handle nodesize %d != leafsize %d!\n",
+			root->nodesize, root->leafsize);
 		return -1;
 	}
 	if (root->nodesize & ((u64)PAGE_CACHE_SIZE - 1)) {
-		printk(KERN_INFO
-		       "btrfsic: cannot handle nodesize %d not being a multiple of PAGE_CACHE_SIZE %ld!\n",
-		       root->nodesize, (unsigned long)PAGE_CACHE_SIZE);
+		pr_info("cannot handle nodesize %d not being a multiple of PAGE_CACHE_SIZE %ld!\n",
+			root->nodesize, (unsigned long)PAGE_CACHE_SIZE);
 		return -1;
 	}
 	if (root->leafsize & ((u64)PAGE_CACHE_SIZE - 1)) {
-		printk(KERN_INFO
-		       "btrfsic: cannot handle leafsize %d not being a multiple of PAGE_CACHE_SIZE %ld!\n",
-		       root->leafsize, (unsigned long)PAGE_CACHE_SIZE);
+		pr_info("cannot handle leafsize %d not being a multiple of PAGE_CACHE_SIZE %ld!\n",
+			root->leafsize, (unsigned long)PAGE_CACHE_SIZE);
 		return -1;
 	}
 	if (root->sectorsize & ((u64)PAGE_CACHE_SIZE - 1)) {
-		printk(KERN_INFO
-		       "btrfsic: cannot handle sectorsize %d not being a multiple of PAGE_CACHE_SIZE %ld!\n",
-		       root->sectorsize, (unsigned long)PAGE_CACHE_SIZE);
+		pr_info("cannot handle sectorsize %d not being a multiple of PAGE_CACHE_SIZE %ld!\n",
+			root->sectorsize, (unsigned long)PAGE_CACHE_SIZE);
 		return -1;
 	}
 	state = kzalloc(sizeof(*state), GFP_NOFS);
 	if (NULL == state) {
-		printk(KERN_INFO "btrfs check-integrity: kmalloc() failed!\n");
+		pr_info("kmalloc() failed!\n");
 		return -1;
 	}
 
@@ -3261,8 +3130,7 @@ int btrfsic_mount(struct btrfs_root *root,
 
 		ds = btrfsic_dev_state_alloc();
 		if (NULL == ds) {
-			printk(KERN_INFO
-			       "btrfs check-integrity: kmalloc() failed!\n");
+			pr_info("kmalloc() failed!\n");
 			mutex_unlock(&btrfsic_mutex);
 			return -1;
 		}
@@ -3328,9 +3196,7 @@ void btrfsic_unmount(struct btrfs_root *root,
 	}
 
 	if (NULL == state) {
-		printk(KERN_INFO
-		       "btrfsic: error, cannot find state information"
-		       " on umount!\n");
+		pr_info("error, cannot find state information on umount!\n");
 		mutex_unlock(&btrfsic_mutex);
 		return;
 	}
@@ -3365,14 +3231,12 @@ void btrfsic_unmount(struct btrfs_root *root,
 		if (b_all->is_iodone || b_all->never_written)
 			btrfsic_block_free(b_all);
 		else
-			printk(KERN_INFO "btrfs: attempt to free %c-block"
-			       " @%llu (%s/%llu/%d) on umount which is"
-			       " not yet iodone!\n",
-			       btrfsic_get_block_type(state, b_all),
-			       (unsigned long long)b_all->logical_bytenr,
-			       b_all->dev_state->name,
-			       (unsigned long long)b_all->dev_bytenr,
-			       b_all->mirror_num);
+			pr_info("attempt to free %c-block @%llu (%s/%llu/%d) on umount which is not yet iodone!\n",
+				btrfsic_get_block_type(state, b_all),
+				(unsigned long long)b_all->logical_bytenr,
+				b_all->dev_state->name,
+				(unsigned long long)b_all->dev_bytenr,
+				b_all->mirror_num);
 	}
 
 	mutex_unlock(&btrfsic_mutex);
diff --git a/fs/btrfs/compression.c b/fs/btrfs/compression.c
index b189bd1..a88a252 100644
--- a/fs/btrfs/compression.c
+++ b/fs/btrfs/compression.c
@@ -16,6 +16,8 @@
  * Boston, MA 021110-1307, USA.
  */
 
+#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
+
 #include <linux/kernel.h>
 #include <linux/bio.h>
 #include <linux/buffer_head.h>
@@ -129,12 +131,10 @@ static int check_compressed_csum(struct inode *inode,
 		kunmap_atomic(kaddr);
 
 		if (csum != *cb_sum) {
-			printk(KERN_INFO "btrfs csum failed ino %llu "
-			       "extent %llu csum %u "
-			       "wanted %u mirror %d\n",
-			       (unsigned long long)btrfs_ino(inode),
-			       (unsigned long long)disk_start,
-			       csum, *cb_sum, cb->mirror_num);
+			pr_info("csum failed ino %llu extent %llu csum %u wanted %u mirror %d\n",
+				(unsigned long long)btrfs_ino(inode),
+				(unsigned long long)disk_start,
+				csum, *cb_sum, cb->mirror_num);
 			ret = -EIO;
 			goto fail;
 		}
diff --git a/fs/btrfs/ctree.c b/fs/btrfs/ctree.c
index 5bf4c39..1f0e79b 100644
--- a/fs/btrfs/ctree.c
+++ b/fs/btrfs/ctree.c
@@ -16,6 +16,8 @@
  * Boston, MA 021110-1307, USA.
  */
 
+#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
+
 #include <linux/sched.h>
 #include <linux/slab.h>
 #include <linux/rbtree.h>
@@ -1324,7 +1326,7 @@ get_old_root(struct btrfs_root *root, u64 time_seq)
 		old = read_tree_block(root, logical, blocksize, 0);
 		if (!old || !extent_buffer_uptodate(old)) {
 			free_extent_buffer(old);
-			pr_warn("btrfs: failed to read tree block %llu from get_old_root\n",
+			pr_warn("failed to read tree block %llu from get_old_root\n",
 				logical);
 			WARN_ON(1);
 		} else {
@@ -3358,10 +3360,9 @@ noinline int btrfs_leaf_free_space(struct btrfs_root *root,
 	int ret;
 	ret = BTRFS_LEAF_DATA_SIZE(root) - leaf_space_used(leaf, 0, nritems);
 	if (ret < 0) {
-		printk(KERN_CRIT "leaf free space ret %d, leaf data size %lu, "
-		       "used %d nritems %d\n",
-		       ret, (unsigned long) BTRFS_LEAF_DATA_SIZE(root),
-		       leaf_space_used(leaf, 0, nritems), nritems);
+		pr_crit("leaf free space ret %d, leaf data size %lu, used %d nritems %d\n",
+			ret, (unsigned long) BTRFS_LEAF_DATA_SIZE(root),
+			leaf_space_used(leaf, 0, nritems), nritems);
 	}
 	return ret;
 }
@@ -4430,8 +4431,7 @@ void btrfs_extend_item(struct btrfs_root *root, struct btrfs_path *path,
 	BUG_ON(slot < 0);
 	if (slot >= nritems) {
 		btrfs_print_leaf(root, leaf);
-		printk(KERN_CRIT "slot %d too large, nritems %d\n",
-		       slot, nritems);
+		pr_crit("slot %d too large, nritems %d\n", slot, nritems);
 		BUG_ON(1);
 	}
 
@@ -4493,8 +4493,8 @@ void setup_items_for_insert(struct btrfs_root *root, struct btrfs_path *path,
 
 	if (btrfs_leaf_free_space(root, leaf) < total_size) {
 		btrfs_print_leaf(root, leaf);
-		printk(KERN_CRIT "not enough freespace need %u have %d\n",
-		       total_size, btrfs_leaf_free_space(root, leaf));
+		pr_crit("not enough freespace need %u have %d\n",
+			total_size, btrfs_leaf_free_space(root, leaf));
 		BUG();
 	}
 
@@ -4503,8 +4503,8 @@ void setup_items_for_insert(struct btrfs_root *root, struct btrfs_path *path,
 
 		if (old_data < data_end) {
 			btrfs_print_leaf(root, leaf);
-			printk(KERN_CRIT "slot %d old_data %d data_end %d\n",
-			       slot, old_data, data_end);
+			pr_crit("slot %d old_data %d data_end %d\n",
+				slot, old_data, data_end);
 			BUG_ON(1);
 		}
 		/*
diff --git a/fs/btrfs/ctree.h b/fs/btrfs/ctree.h
index e795bf1..2af5726 100644
--- a/fs/btrfs/ctree.h
+++ b/fs/btrfs/ctree.h
@@ -3746,8 +3746,7 @@ static inline void __btrfs_set_fs_incompat(struct btrfs_fs_info *fs_info,
 		if (!(features & flag)) {
 			features |= flag;
 			btrfs_set_super_incompat_flags(disk_super, features);
-			printk(KERN_INFO "btrfs: setting %llu feature flag\n",
-					 flag);
+			pr_info("setting %llu feature flag\n", flag);
 		}
 		spin_unlock(&fs_info->super_lock);
 	}
diff --git a/fs/btrfs/delayed-inode.c b/fs/btrfs/delayed-inode.c
index 3755109..f527fdd 100644
--- a/fs/btrfs/delayed-inode.c
+++ b/fs/btrfs/delayed-inode.c
@@ -17,6 +17,8 @@
  * Boston, MA 021110-1307, USA.
  */
 
+#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
+
 #include <linux/slab.h>
 #include "delayed-inode.h"
 #include "disk-io.h"
@@ -1470,13 +1472,11 @@ int btrfs_insert_delayed_dir_index(struct btrfs_trans_handle *trans,
 	mutex_lock(&delayed_node->mutex);
 	ret = __btrfs_add_delayed_insertion_item(delayed_node, delayed_item);
 	if (unlikely(ret)) {
-		printk(KERN_ERR "err add delayed dir index item(name: %s) into "
-				"the insertion tree of the delayed node"
-				"(root id: %llu, inode id: %llu, errno: %d)\n",
-				name,
-				(unsigned long long)delayed_node->root->objectid,
-				(unsigned long long)delayed_node->inode_id,
-				ret);
+		pr_err("err add delayed dir index item(name: %s) into the insertion tree of the delayed node (root id: %llu, inode id: %llu, errno: %d)\n",
+		       name,
+		       (unsigned long long)delayed_node->root->objectid,
+		       (unsigned long long)delayed_node->inode_id,
+		       ret);
 		BUG();
 	}
 	mutex_unlock(&delayed_node->mutex);
@@ -1544,13 +1544,11 @@ int btrfs_delete_delayed_dir_index(struct btrfs_trans_handle *trans,
 	mutex_lock(&node->mutex);
 	ret = __btrfs_add_delayed_deletion_item(node, item);
 	if (unlikely(ret)) {
-		printk(KERN_ERR "err add delayed dir index item(index: %llu) "
-				"into the deletion tree of the delayed node"
-				"(root id: %llu, inode id: %llu, errno: %d)\n",
-				(unsigned long long)index,
-				(unsigned long long)node->root->objectid,
-				(unsigned long long)node->inode_id,
-				ret);
+		pr_err("err add delayed dir index item(index: %llu) into the deletion tree of the delayed node (root id: %llu, inode id: %llu, errno: %d)\n",
+		       (unsigned long long)index,
+		       (unsigned long long)node->root->objectid,
+		       (unsigned long long)node->inode_id,
+		       ret);
 		BUG();
 	}
 	mutex_unlock(&node->mutex);
diff --git a/fs/btrfs/dev-replace.c b/fs/btrfs/dev-replace.c
index 4253ad5..7aac584 100644
--- a/fs/btrfs/dev-replace.c
+++ b/fs/btrfs/dev-replace.c
@@ -104,7 +104,7 @@ no_valid_dev_replace_entry_found:
 	ptr = btrfs_item_ptr(eb, slot, struct btrfs_dev_replace_item);
 
 	if (item_size != sizeof(struct btrfs_dev_replace_item)) {
-		pr_warn("btrfs: dev_replace entry found has unexpected size, ignore entry\n");
+		pr_warn("dev_replace entry found has unexpected size, ignore entry\n");
 		goto no_valid_dev_replace_entry_found;
 	}
 
@@ -147,13 +147,13 @@ no_valid_dev_replace_entry_found:
 		if (!dev_replace->srcdev &&
 		    !btrfs_test_opt(dev_root, DEGRADED)) {
 			ret = -EIO;
-			pr_warn("btrfs: cannot mount because device replace operation is ongoing and\n" "srcdev (devid %llu) is missing, need to run 'btrfs dev scan'?\n",
+			pr_warn("cannot mount because device replace operation is ongoing and srcdev (devid %llu) is missing, need to run 'btrfs dev scan'?\n",
 				(unsigned long long)src_devid);
 		}
 		if (!dev_replace->tgtdev &&
 		    !btrfs_test_opt(dev_root, DEGRADED)) {
 			ret = -EIO;
-			pr_warn("btrfs: cannot mount because device replace operation is ongoing and\n" "tgtdev (devid %llu) is missing, need to run btrfs dev scan?\n",
+			pr_warn("cannot mount because device replace operation is ongoing and tgtdev (devid %llu) is missing, need to run 'btrfs dev scan'?\n",
 				(unsigned long long)BTRFS_DEV_REPLACE_DEVID);
 		}
 		if (dev_replace->tgtdev) {
@@ -212,8 +212,7 @@ int btrfs_run_dev_replace(struct btrfs_trans_handle *trans,
 	}
 	ret = btrfs_search_slot(trans, dev_root, &key, path, -1, 1);
 	if (ret < 0) {
-		pr_warn("btrfs: error %d while searching for dev_replace item!\n",
-			ret);
+		pr_warn("error %d while searching for dev_replace item!\n", ret);
 		goto out;
 	}
 
@@ -232,7 +231,7 @@ int btrfs_run_dev_replace(struct btrfs_trans_handle *trans,
 		 */
 		ret = btrfs_del_item(trans, dev_root, path);
 		if (ret != 0) {
-			pr_warn("btrfs: delete too small dev_replace item failed %d!\n",
+			pr_warn("delete too small dev_replace item failed %d!\n",
 				ret);
 			goto out;
 		}
@@ -245,8 +244,7 @@ int btrfs_run_dev_replace(struct btrfs_trans_handle *trans,
 		ret = btrfs_insert_empty_item(trans, dev_root, path,
 					      &key, sizeof(*ptr));
 		if (ret < 0) {
-			pr_warn("btrfs: insert dev_replace item failed %d!\n",
-				ret);
+			pr_warn("insert dev_replace item failed %d!\n", ret);
 			goto out;
 		}
 	}
@@ -314,7 +312,7 @@ int btrfs_dev_replace_start(struct btrfs_root *root,
 	struct btrfs_device *src_device = NULL;
 
 	if (btrfs_fs_incompat(fs_info, RAID56)) {
-		pr_warn("btrfs: dev_replace cannot yet handle RAID5/RAID6\n");
+		pr_warn("dev_replace cannot yet handle RAID5/RAID6\n");
 		return -EINVAL;
 	}
 
@@ -334,7 +332,7 @@ int btrfs_dev_replace_start(struct btrfs_root *root,
 	ret = btrfs_init_dev_replace_tgtdev(root, args->start.tgtdev_name,
 					    &tgt_device);
 	if (ret) {
-		pr_err("btrfs: target device %s is invalid!\n",
+		pr_err("target device %s is invalid!\n",
 		       args->start.tgtdev_name);
 		mutex_unlock(&fs_info->volume_mutex);
 		return -EINVAL;
@@ -350,7 +348,7 @@ int btrfs_dev_replace_start(struct btrfs_root *root,
 	}
 
 	if (tgt_device->total_bytes < src_device->total_bytes) {
-		pr_err("btrfs: target device is smaller than source device!\n");
+		pr_err("target device is smaller than source device!\n");
 		ret = -EINVAL;
 		goto leave_no_lock;
 	}
@@ -708,7 +706,7 @@ void btrfs_dev_replace_suspend_for_unmount(struct btrfs_fs_info *fs_info)
 			BTRFS_IOCTL_DEV_REPLACE_STATE_SUSPENDED;
 		dev_replace->time_stopped = btrfs_get_seconds_since_1970();
 		dev_replace->item_needs_writeback = 1;
-		pr_info("btrfs: suspending dev_replace for unmount\n");
+		pr_info("suspending dev_replace for unmount\n");
 		break;
 	}
 
@@ -737,8 +735,8 @@ int btrfs_resume_dev_replace_async(struct btrfs_fs_info *fs_info)
 		break;
 	}
 	if (!dev_replace->tgtdev || !dev_replace->tgtdev->bdev) {
-		pr_info("btrfs: cannot continue dev_replace, tgtdev is missing\n"
-			"btrfs: you may cancel the operation after 'mount -o degraded'\n");
+		pr_info("cannot continue dev_replace, tgtdev is missing\n");
+		pr_info("you may cancel the operation after 'mount -o degraded'\n");
 		btrfs_dev_replace_unlock(dev_replace);
 		return 0;
 	}
diff --git a/fs/btrfs/dir-item.c b/fs/btrfs/dir-item.c
index 79e594e..e8e3456 100644
--- a/fs/btrfs/dir-item.c
+++ b/fs/btrfs/dir-item.c
@@ -16,6 +16,8 @@
  * Boston, MA 021110-1307, USA.
  */
 
+#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
+
 #include "ctree.h"
 #include "disk-io.h"
 #include "hash.h"
@@ -459,8 +461,7 @@ int verify_dir_item(struct btrfs_root *root,
 	u8 type = btrfs_dir_type(leaf, dir_item);
 
 	if (type >= BTRFS_FT_MAX) {
-		printk(KERN_CRIT "btrfs: invalid dir item type: %d\n",
-		       (int)type);
+		pr_crit("invalid dir item type: %d\n", (int)type);
 		return 1;
 	}
 
@@ -468,15 +469,15 @@ int verify_dir_item(struct btrfs_root *root,
 		namelen = XATTR_NAME_MAX;
 
 	if (btrfs_dir_name_len(leaf, dir_item) > namelen) {
-		printk(KERN_CRIT "btrfs: invalid dir item name len: %u\n",
-		       (unsigned)btrfs_dir_data_len(leaf, dir_item));
+		pr_crit("invalid dir item name len: %u\n",
+			(unsigned)btrfs_dir_data_len(leaf, dir_item));
 		return 1;
 	}
 
 	/* BTRFS_MAX_XATTR_SIZE is the same for all dir items */
 	if (btrfs_dir_data_len(leaf, dir_item) > BTRFS_MAX_XATTR_SIZE(root)) {
-		printk(KERN_CRIT "btrfs: invalid dir item data len: %u\n",
-		       (unsigned)btrfs_dir_data_len(leaf, dir_item));
+		pr_crit("invalid dir item data len: %u\n",
+			(unsigned)btrfs_dir_data_len(leaf, dir_item));
 		return 1;
 	}
 
diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
index 6b092a1..269fb61 100644
--- a/fs/btrfs/disk-io.c
+++ b/fs/btrfs/disk-io.c
@@ -16,6 +16,8 @@
  * Boston, MA 021110-1307, USA.
  */
 
+#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
+
 #include <linux/fs.h>
 #include <linux/blkdev.h>
 #include <linux/scatterlist.h>
@@ -299,12 +301,11 @@ static int csum_tree_block(struct btrfs_root *root, struct extent_buffer *buf,
 			memcpy(&found, result, csum_size);
 
 			read_extent_buffer(buf, &val, 0, csum_size);
-			printk_ratelimited(KERN_INFO "btrfs: %s checksum verify "
-				       "failed on %llu wanted %X found %X "
-				       "level %d\n",
-				       root->fs_info->sb->s_id,
-				       (unsigned long long)buf->start, val, found,
-				       btrfs_header_level(buf));
+			pr_info_ratelimited("%s checksum verify failed on %llu wanted %X found %X level %d\n",
+					    root->fs_info->sb->s_id,
+					    (unsigned long long)buf->start,
+					    val, found,
+					    btrfs_header_level(buf));
 			if (result != (char *)&inline_result)
 				kfree(result);
 			return 1;
@@ -385,14 +386,13 @@ static int btrfs_check_super_csum(char *raw_disk_sb)
 			ret = 1;
 
 		if (ret && btrfs_super_generation(disk_sb) < 10) {
-			printk(KERN_WARNING "btrfs: super block crcs don't match, older mkfs detected\n");
+			pr_warn("super block crcs don't match, older mkfs detected\n");
 			ret = 0;
 		}
 	}
 
 	if (csum_type >= ARRAY_SIZE(btrfs_csum_sizes)) {
-		printk(KERN_ERR "btrfs: unsupported checksum algorithm %u\n",
-				csum_type);
+		pr_err("unsupported checksum algorithm %u\n", csum_type);
 		ret = 1;
 	}
 
@@ -509,11 +509,11 @@ static int check_tree_block_fsid(struct btrfs_root *root,
 	return ret;
 }
 
-#define CORRUPT(reason, eb, root, slot)				\
-	printk(KERN_CRIT "btrfs: corrupt leaf, %s: block=%llu,"	\
-	       "root=%llu, slot=%d\n", reason,			\
-	       (unsigned long long)btrfs_header_bytenr(eb),	\
-	       (unsigned long long)root->objectid, slot)
+#define CORRUPT(reason, eb, root, slot)					\
+	pr_crit("corrupt leaf, %s: block=%llu, root=%llu, slot=%d\n",	\
+		reason,							\
+		(unsigned long long)btrfs_header_bytenr(eb),		\
+		(unsigned long long)root->objectid, slot)
 
 static noinline int check_leaf(struct btrfs_root *root,
 			       struct extent_buffer *leaf)
@@ -610,16 +610,15 @@ static int btree_readpage_end_io_hook(struct page *page, u64 start, u64 end,
 
 	found_start = btrfs_header_bytenr(eb);
 	if (found_start != eb->start) {
-		printk_ratelimited(KERN_INFO "btrfs bad tree block start "
-			       "%llu %llu\n",
-			       (unsigned long long)found_start,
-			       (unsigned long long)eb->start);
+		pr_info_ratelimited("bad tree block start %llu %llu\n",
+				    (unsigned long long)found_start,
+				    (unsigned long long)eb->start);
 		ret = -EIO;
 		goto err;
 	}
 	if (check_tree_block_fsid(root, eb)) {
-		printk_ratelimited(KERN_INFO "btrfs bad fsid on block %llu\n",
-			       (unsigned long long)eb->start);
+		pr_info_ratelimited("bad fsid on block %llu\n",
+				    (unsigned long long)eb->start);
 		ret = -EIO;
 		goto err;
 	}
@@ -1021,8 +1020,8 @@ static void btree_invalidatepage(struct page *page, unsigned int offset,
 	extent_invalidatepage(tree, page, offset);
 	btree_releasepage(page, GFP_NOFS);
 	if (PagePrivate(page)) {
-		printk(KERN_WARNING "btrfs warning page private not zero "
-		       "on page %llu\n", (unsigned long long)page_offset(page));
+		pr_warn("warning page private not zero on page %llu\n",
+			(unsigned long long)page_offset(page));
 		ClearPagePrivate(page);
 		set_page_private(page, 0);
 		page_cache_release(page);
@@ -2327,7 +2326,7 @@ int open_ctree(struct super_block *sb,
 	 * Pass the whole disk block of size BTRFS_SUPER_INFO_SIZE (4k).
 	 */
 	if (btrfs_check_super_csum(bh->b_data)) {
-		printk(KERN_ERR "btrfs: superblock checksum mismatch\n");
+		pr_err("superblock checksum mismatch\n");
 		err = -EINVAL;
 		goto fail_alloc;
 	}
@@ -2346,7 +2345,7 @@ int open_ctree(struct super_block *sb,
 
 	ret = btrfs_check_super_valid(fs_info, sb->s_flags & MS_RDONLY);
 	if (ret) {
-		printk(KERN_ERR "btrfs: superblock contains fatal errors\n");
+		pr_err("superblock contains fatal errors\n");
 		err = -EINVAL;
 		goto fail_alloc;
 	}
@@ -2381,8 +2380,7 @@ int open_ctree(struct super_block *sb,
 	features = btrfs_super_incompat_flags(disk_super) &
 		~BTRFS_FEATURE_INCOMPAT_SUPP;
 	if (features) {
-		printk(KERN_ERR "BTRFS: couldn't mount because of "
-		       "unsupported optional features (%Lx).\n",
+		pr_err("couldn't mount because of unsupported optional features (%Lx)\n",
 		       (unsigned long long)features);
 		err = -EINVAL;
 		goto fail_alloc;
@@ -2390,16 +2388,14 @@ int open_ctree(struct super_block *sb,
 
 	if (btrfs_super_leafsize(disk_super) !=
 	    btrfs_super_nodesize(disk_super)) {
-		printk(KERN_ERR "BTRFS: couldn't mount because metadata "
-		       "blocksizes don't match.  node %d leaf %d\n",
+		pr_err("couldn't mount because metadata blocksizes don't match.  node %d leaf %d\n",
 		       btrfs_super_nodesize(disk_super),
 		       btrfs_super_leafsize(disk_super));
 		err = -EINVAL;
 		goto fail_alloc;
 	}
 	if (btrfs_super_leafsize(disk_super) > BTRFS_MAX_METADATA_BLOCKSIZE) {
-		printk(KERN_ERR "BTRFS: couldn't mount because metadata "
-		       "blocksize (%d) was too large\n",
+		pr_err("couldn't mount because metadata blocksize (%d) was too large\n",
 		       btrfs_super_leafsize(disk_super));
 		err = -EINVAL;
 		goto fail_alloc;
@@ -2411,7 +2407,7 @@ int open_ctree(struct super_block *sb,
 		features |= BTRFS_FEATURE_INCOMPAT_COMPRESS_LZO;
 
 	if (features & BTRFS_FEATURE_INCOMPAT_SKINNY_METADATA)
-		printk(KERN_ERR "btrfs: has skinny extents\n");
+		pr_err("has skinny extents\n");
 
 	/*
 	 * flag our filesystem as having big metadata blocks if
@@ -2419,7 +2415,7 @@ int open_ctree(struct super_block *sb,
 	 */
 	if (btrfs_super_leafsize(disk_super) > PAGE_CACHE_SIZE) {
 		if (!(features & BTRFS_FEATURE_INCOMPAT_BIG_METADATA))
-			printk(KERN_INFO "btrfs flagging fs with big metadata feature\n");
+			pr_info("flagging fs with big metadata feature\n");
 		features |= BTRFS_FEATURE_INCOMPAT_BIG_METADATA;
 	}
 
@@ -2436,9 +2432,8 @@ int open_ctree(struct super_block *sb,
 	 */
 	if ((features & BTRFS_FEATURE_INCOMPAT_MIXED_GROUPS) &&
 	    (sectorsize != leafsize)) {
-		printk(KERN_WARNING "btrfs: unequal leaf/node/sector sizes "
-				"are not allowed for mixed block groups on %s\n",
-				sb->s_id);
+		pr_warn("unequal leaf/node/sector sizes are not allowed for mixed block groups on %s\n",
+			sb->s_id);
 		goto fail_alloc;
 	}
 
@@ -2451,8 +2446,7 @@ int open_ctree(struct super_block *sb,
 	features = btrfs_super_compat_ro_flags(disk_super) &
 		~BTRFS_FEATURE_COMPAT_RO_SUPP;
 	if (!(sb->s_flags & MS_RDONLY) && features) {
-		printk(KERN_ERR "BTRFS: couldn't mount RDWR because of "
-		       "unsupported option features (%Lx).\n",
+		pr_err("couldn't mount RDWR because of unsupported option features (%Lx)\n",
 		       (unsigned long long)features);
 		err = -EINVAL;
 		goto fail_alloc;
@@ -2576,13 +2570,13 @@ int open_ctree(struct super_block *sb,
 	sb->s_blocksize_bits = blksize_bits(sectorsize);
 
 	if (disk_super->magic != cpu_to_le64(BTRFS_MAGIC)) {
-		printk(KERN_INFO "btrfs: valid FS not found on %s\n", sb->s_id);
+		pr_info("valid FS not found on %s\n", sb->s_id);
 		goto fail_sb_buffer;
 	}
 
 	if (sectorsize != PAGE_SIZE) {
-		printk(KERN_WARNING "btrfs: Incompatible sector size(%lu) "
-		       "found on %s\n", (unsigned long)sectorsize, sb->s_id);
+		pr_warn("Incompatible sector size(%lu) found on %s\n",
+			(unsigned long)sectorsize, sb->s_id);
 		goto fail_sb_buffer;
 	}
 
@@ -2590,8 +2584,7 @@ int open_ctree(struct super_block *sb,
 	ret = btrfs_read_sys_array(tree_root);
 	mutex_unlock(&fs_info->chunk_mutex);
 	if (ret) {
-		printk(KERN_WARNING "btrfs: failed to read the system "
-		       "array on %s\n", sb->s_id);
+		pr_warn("failed to read the system array on %s\n", sb->s_id);
 		goto fail_sb_buffer;
 	}
 
@@ -2607,8 +2600,7 @@ int open_ctree(struct super_block *sb,
 					   blocksize, generation);
 	if (!chunk_root->node ||
 	    !test_bit(EXTENT_BUFFER_UPTODATE, &chunk_root->node->bflags)) {
-		printk(KERN_WARNING "btrfs: failed to read chunk root on %s\n",
-		       sb->s_id);
+		pr_warn("failed to read chunk root on %s\n", sb->s_id);
 		goto fail_tree_roots;
 	}
 	btrfs_set_root_node(&chunk_root->root_item, chunk_root->node);
@@ -2620,8 +2612,7 @@ int open_ctree(struct super_block *sb,
 
 	ret = btrfs_read_chunk_tree(chunk_root);
 	if (ret) {
-		printk(KERN_WARNING "btrfs: failed to read chunk tree on %s\n",
-		       sb->s_id);
+		pr_warn("failed to read chunk tree on %s\n", sb->s_id);
 		goto fail_tree_roots;
 	}
 
@@ -2632,8 +2623,7 @@ int open_ctree(struct super_block *sb,
 	btrfs_close_extra_devices(fs_info, fs_devices, 0);
 
 	if (!fs_devices->latest_bdev) {
-		printk(KERN_CRIT "btrfs: failed to read devices on %s\n",
-		       sb->s_id);
+		pr_crit("failed to read devices on %s\n", sb->s_id);
 		goto fail_tree_roots;
 	}
 
@@ -2647,8 +2637,7 @@ retry_root_backup:
 					  blocksize, generation);
 	if (!tree_root->node ||
 	    !test_bit(EXTENT_BUFFER_UPTODATE, &tree_root->node->bflags)) {
-		printk(KERN_WARNING "btrfs: failed to read tree root on %s\n",
-		       sb->s_id);
+		pr_warn("failed to read tree root on %s\n", sb->s_id);
 
 		goto recovery_tree_root;
 	}
@@ -2701,20 +2690,19 @@ retry_root_backup:
 
 	ret = btrfs_recover_balance(fs_info);
 	if (ret) {
-		printk(KERN_WARNING "btrfs: failed to recover balance\n");
+		pr_warn("failed to recover balance\n");
 		goto fail_block_groups;
 	}
 
 	ret = btrfs_init_dev_stats(fs_info);
 	if (ret) {
-		printk(KERN_ERR "btrfs: failed to init dev_stats: %d\n",
-		       ret);
+		pr_err("failed to init dev_stats: %d\n", ret);
 		goto fail_block_groups;
 	}
 
 	ret = btrfs_init_dev_replace(fs_info);
 	if (ret) {
-		pr_err("btrfs: failed to init dev_replace: %d\n", ret);
+		pr_err("failed to init dev_replace: %d\n", ret);
 		goto fail_block_groups;
 	}
 
@@ -2722,13 +2710,13 @@ retry_root_backup:
 
 	ret = btrfs_init_space_info(fs_info);
 	if (ret) {
-		printk(KERN_ERR "Failed to initial space info: %d\n", ret);
+		pr_err("Failed to initial space info: %d\n", ret);
 		goto fail_block_groups;
 	}
 
 	ret = btrfs_read_block_groups(extent_root);
 	if (ret) {
-		printk(KERN_ERR "Failed to read block groups: %d\n", ret);
+		pr_err("Failed to read block groups: %d\n", ret);
 		goto fail_block_groups;
 	}
 	fs_info->num_tolerated_disk_barrier_failures =
@@ -2736,8 +2724,7 @@ retry_root_backup:
 	if (fs_info->fs_devices->missing_devices >
 	     fs_info->num_tolerated_disk_barrier_failures &&
 	    !(sb->s_flags & MS_RDONLY)) {
-		printk(KERN_WARNING
-		       "Btrfs: too many missing devices, writeable mount is not allowed\n");
+		pr_warn("too many missing devices, writeable mount is not allowed\n");
 		goto fail_block_groups;
 	}
 
@@ -2755,8 +2742,7 @@ retry_root_backup:
 	if (!btrfs_test_opt(tree_root, SSD) &&
 	    !btrfs_test_opt(tree_root, NOSSD) &&
 	    !fs_info->fs_devices->rotating) {
-		printk(KERN_INFO "Btrfs detected SSD devices, enabling SSD "
-		       "mode\n");
+		pr_info("detected SSD devices, enabling SSD mode\n");
 		btrfs_set_opt(fs_info->mount_opt, SSD);
 	}
 
@@ -2768,8 +2754,8 @@ retry_root_backup:
 				    1 : 0,
 				    fs_info->check_integrity_print_mask);
 		if (ret)
-			printk(KERN_WARNING "btrfs: failed to initialize"
-			       " integrity check module %s\n", sb->s_id);
+			pr_warn("failed to initialize integrity check module %s\n",
+				sb->s_id);
 	}
 #endif
 	ret = btrfs_read_qgroup_config(fs_info);
@@ -2781,8 +2767,7 @@ retry_root_backup:
 		u64 bytenr = btrfs_super_log_root(disk_super);
 
 		if (fs_devices->rw_devices == 0) {
-			printk(KERN_WARNING "Btrfs log replay required "
-			       "on RO media\n");
+			pr_warn("log replay required on RO media\n");
 			err = -EIO;
 			goto fail_qgroup;
 		}
@@ -2804,7 +2789,7 @@ retry_root_backup:
 						      generation + 1);
 		if (!log_tree_root->node ||
 		    !extent_buffer_uptodate(log_tree_root->node)) {
-			printk(KERN_ERR "btrfs: failed to read log tree\n");
+			pr_err("failed to read log tree\n");
 			free_extent_buffer(log_tree_root->node);
 			kfree(log_tree_root);
 			goto fail_trans_kthread;
@@ -2837,8 +2822,7 @@ retry_root_backup:
 
 		ret = btrfs_recover_relocation(tree_root);
 		if (ret < 0) {
-			printk(KERN_WARNING
-			       "btrfs: failed to recover relocation\n");
+			pr_warn("failed to recover relocation\n");
 			err = -EINVAL;
 			goto fail_qgroup;
 		}
@@ -2868,14 +2852,14 @@ retry_root_backup:
 
 	ret = btrfs_resume_balance_async(fs_info);
 	if (ret) {
-		printk(KERN_WARNING "btrfs: failed to resume balance\n");
+		pr_warn("failed to resume balance\n");
 		close_ctree(tree_root);
 		return ret;
 	}
 
 	ret = btrfs_resume_dev_replace_async(fs_info);
 	if (ret) {
-		pr_warn("btrfs: failed to resume dev_replace\n");
+		pr_warn("failed to resume dev_replace\n");
 		close_ctree(tree_root);
 		return ret;
 	}
@@ -3071,8 +3055,8 @@ static int write_dev_supers(struct btrfs_device *device,
 			bh = __getblk(device->bdev, bytenr / 4096,
 				      BTRFS_SUPER_INFO_SIZE);
 			if (!bh) {
-				printk(KERN_ERR "btrfs: couldn't get super "
-				       "buffer head for bytenr %Lu\n", bytenr);
+				pr_err("couldn't get super buffer head for bytenr %llu\n",
+				       bytenr);
 				errors++;
 				continue;
 			}
@@ -3359,8 +3343,7 @@ static int write_all_supers(struct btrfs_root *root, int max_mirrors)
 			total_errors++;
 	}
 	if (total_errors > max_errors) {
-		printk(KERN_ERR "btrfs: %d errors while writing supers\n",
-		       total_errors);
+		pr_err("%d errors while writing supers\n", total_errors);
 
 		/* This shouldn't happen. FUA is masked off if unsupported */
 		BUG();
@@ -3527,7 +3510,7 @@ int close_ctree(struct btrfs_root *root)
 	if (!(fs_info->sb->s_flags & MS_RDONLY)) {
 		ret = btrfs_commit_super(root);
 		if (ret)
-			printk(KERN_ERR "btrfs: commit super ret %d\n", ret);
+			pr_err("commit super ret %d\n", ret);
 	}
 
 	if (test_bit(BTRFS_FS_STATE_ERROR, &fs_info->fs_state))
@@ -3544,8 +3527,8 @@ int close_ctree(struct btrfs_root *root)
 	btrfs_free_qgroup_config(root->fs_info);
 
 	if (percpu_counter_sum(&fs_info->delalloc_bytes)) {
-		printk(KERN_INFO "btrfs: at unmount delalloc count %lld\n",
-		       percpu_counter_sum(&fs_info->delalloc_bytes));
+		pr_info("at unmount delalloc count %lld\n",
+			percpu_counter_sum(&fs_info->delalloc_bytes));
 	}
 
 	btrfs_free_block_groups(fs_info);
@@ -3757,7 +3740,7 @@ int btrfs_destroy_delayed_refs(struct btrfs_transaction *trans,
 	spin_lock(&delayed_refs->lock);
 	if (delayed_refs->num_entries == 0) {
 		spin_unlock(&delayed_refs->lock);
-		printk(KERN_INFO "delayed_refs has NO entry\n");
+		pr_info("delayed_refs has NO entry\n");
 		return ret;
 	}
 
diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
index 0236de7..f2ff159 100644
--- a/fs/btrfs/extent-tree.c
+++ b/fs/btrfs/extent-tree.c
@@ -15,6 +15,9 @@
  * Free Software Foundation, Inc., 59 Temple Place - Suite 330,
  * Boston, MA 021110-1307, USA.
  */
+
+#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
+
 #include <linux/sched.h>
 #include <linux/pagemap.h>
 #include <linux/writeback.h>
@@ -6462,20 +6465,19 @@ static void dump_space_info(struct btrfs_space_info *info, u64 bytes,
 	int index = 0;
 
 	spin_lock(&info->lock);
-	printk(KERN_INFO "space_info %llu has %llu free, is %sfull\n",
-	       (unsigned long long)info->flags,
-	       (unsigned long long)(info->total_bytes - info->bytes_used -
-				    info->bytes_pinned - info->bytes_reserved -
-				    info->bytes_readonly),
-	       (info->full) ? "" : "not ");
-	printk(KERN_INFO "space_info total=%llu, used=%llu, pinned=%llu, "
-	       "reserved=%llu, may_use=%llu, readonly=%llu\n",
-	       (unsigned long long)info->total_bytes,
-	       (unsigned long long)info->bytes_used,
-	       (unsigned long long)info->bytes_pinned,
-	       (unsigned long long)info->bytes_reserved,
-	       (unsigned long long)info->bytes_may_use,
-	       (unsigned long long)info->bytes_readonly);
+	pr_info("space_info %llu has %llu free, is %sfull\n",
+		(unsigned long long)info->flags,
+		(unsigned long long)(info->total_bytes - info->bytes_used -
+				     info->bytes_pinned - info->bytes_reserved -
+				     info->bytes_readonly),
+		(info->full) ? "" : "not ");
+	pr_info("space_info total=%llu, used=%llu, pinned=%llu, reserved=%llu, may_use=%llu, readonly=%llu\n",
+		(unsigned long long)info->total_bytes,
+		(unsigned long long)info->bytes_used,
+		(unsigned long long)info->bytes_pinned,
+		(unsigned long long)info->bytes_reserved,
+		(unsigned long long)info->bytes_may_use,
+		(unsigned long long)info->bytes_readonly);
 	spin_unlock(&info->lock);
 
 	if (!dump_block_groups)
@@ -6485,13 +6487,13 @@ static void dump_space_info(struct btrfs_space_info *info, u64 bytes,
 again:
 	list_for_each_entry(cache, &info->block_groups[index], list) {
 		spin_lock(&cache->lock);
-		printk(KERN_INFO "block group %llu has %llu bytes, %llu used %llu pinned %llu reserved %s\n",
-		       (unsigned long long)cache->key.objectid,
-		       (unsigned long long)cache->key.offset,
-		       (unsigned long long)btrfs_block_group_used(&cache->item),
-		       (unsigned long long)cache->pinned,
-		       (unsigned long long)cache->reserved,
-		       cache->ro ? "[readonly]" : "");
+		pr_info("block group %llu has %llu bytes, %llu used %llu pinned %llu reserved %s\n",
+			(unsigned long long)cache->key.objectid,
+			(unsigned long long)cache->key.offset,
+			(unsigned long long)btrfs_block_group_used(&cache->item),
+			(unsigned long long)cache->pinned,
+			(unsigned long long)cache->reserved,
+			cache->ro ? "[readonly]" : "");
 		btrfs_dump_free_space(cache, bytes);
 		spin_unlock(&cache->lock);
 	}
@@ -7553,7 +7555,7 @@ int btrfs_drop_snapshot(struct btrfs_root *root,
 
 	while (1) {
 		if (!for_reloc && btrfs_need_cleaner_sleep(root)) {
-			pr_debug("btrfs: drop snapshot early exit\n");
+			pr_debug("drop snapshot early exit\n");
 			err = -EAGAIN;
 			goto out_end_trans;
 		}
diff --git a/fs/btrfs/extent_io.c b/fs/btrfs/extent_io.c
index 583d98b..e133b2f 100644
--- a/fs/btrfs/extent_io.c
+++ b/fs/btrfs/extent_io.c
@@ -1,3 +1,5 @@
+#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
+
 #include <linux/bitops.h>
 #include <linux/slab.h>
 #include <linux/bio.h>
@@ -59,8 +61,7 @@ void btrfs_leak_debug_check(void)
 
 	while (!list_empty(&states)) {
 		state = list_entry(states.next, struct extent_state, leak_list);
-		printk(KERN_ERR "btrfs state leak: start %llu end %llu "
-		       "state %lu in tree %p refs %d\n",
+		pr_err("state leak: start %llu end %llu state %lu in tree %p refs %d\n",
 		       (unsigned long long)state->start,
 		       (unsigned long long)state->end,
 		       state->state, state->tree, atomic_read(&state->refs));
@@ -70,8 +71,8 @@ void btrfs_leak_debug_check(void)
 
 	while (!list_empty(&buffers)) {
 		eb = list_entry(buffers.next, struct extent_buffer, leak_list);
-		printk(KERN_ERR "btrfs buffer leak start %llu len %lu "
-		       "refs %d\n", (unsigned long long)eb->start,
+		pr_err("buffer leak start %llu len %lu refs %d\n",
+		       (unsigned long long)eb->start,
 		       eb->len, atomic_read(&eb->refs));
 		list_del(&eb->leak_list);
 		kmem_cache_free(extent_buffer_cache, eb);
@@ -399,8 +400,8 @@ static int insert_state(struct extent_io_tree *tree,
 	if (node) {
 		struct extent_state *found;
 		found = rb_entry(node, struct extent_state, rb_node);
-		printk(KERN_ERR "btrfs found node %llu %llu on insert of "
-		       "%llu %llu\n", (unsigned long long)found->start,
+		pr_err("found node %llu %llu on insert of %llu %llu\n",
+		       (unsigned long long)found->start,
 		       (unsigned long long)found->end,
 		       (unsigned long long)start, (unsigned long long)end);
 		return -EEXIST;
@@ -3187,8 +3188,7 @@ static int __extent_writepage(struct page *page, struct writeback_control *wbc,
 
 			set_range_writeback(tree, cur, cur + iosize - 1);
 			if (!PageWriteback(page)) {
-				printk(KERN_ERR "btrfs warning page %lu not "
-				       "writeback, cur %llu end %llu\n",
+				pr_err("warning page %lu not writeback, cur %llu end %llu\n",
 				       page->index, (unsigned long long)cur,
 				       (unsigned long long)end);
 			}
@@ -5007,13 +5007,13 @@ void memcpy_extent_buffer(struct extent_buffer *dst, unsigned long dst_offset,
 	unsigned long src_i;
 
 	if (src_offset + len > dst->len) {
-		printk(KERN_ERR "btrfs memmove bogus src_offset %lu move "
-		       "len %lu dst len %lu\n", src_offset, len, dst->len);
+		pr_err("memmove bogus src_offset %lu move len %lu dst len %lu\n",
+		       src_offset, len, dst->len);
 		BUG_ON(1);
 	}
 	if (dst_offset + len > dst->len) {
-		printk(KERN_ERR "btrfs memmove bogus dst_offset %lu move "
-		       "len %lu dst len %lu\n", dst_offset, len, dst->len);
+		pr_err("memmove bogus dst_offset %lu move len %lu dst len %lu\n",
+		       dst_offset, len, dst->len);
 		BUG_ON(1);
 	}
 
@@ -5054,13 +5054,13 @@ void memmove_extent_buffer(struct extent_buffer *dst, unsigned long dst_offset,
 	unsigned long src_i;
 
 	if (src_offset + len > dst->len) {
-		printk(KERN_ERR "btrfs memmove bogus src_offset %lu move "
-		       "len %lu len %lu\n", src_offset, len, dst->len);
+		pr_err("memmove bogus src_offset %lu move len %lu len %lu\n",
+		       src_offset, len, dst->len);
 		BUG_ON(1);
 	}
 	if (dst_offset + len > dst->len) {
-		printk(KERN_ERR "btrfs memmove bogus dst_offset %lu move "
-		       "len %lu len %lu\n", dst_offset, len, dst->len);
+		pr_err("memmove bogus dst_offset %lu move len %lu len %lu\n",
+		       dst_offset, len, dst->len);
 		BUG_ON(1);
 	}
 	if (dst_offset < src_offset) {
diff --git a/fs/btrfs/file-item.c b/fs/btrfs/file-item.c
index a7bfc95..28bf52e 100644
--- a/fs/btrfs/file-item.c
+++ b/fs/btrfs/file-item.c
@@ -16,6 +16,8 @@
  * Boston, MA 021110-1307, USA.
  */
 
+#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
+
 #include <linux/bio.h>
 #include <linux/slab.h>
 #include <linux/pagemap.h>
@@ -220,11 +222,10 @@ static int __btrfs_lookup_bio_sums(struct btrfs_root *root,
 						offset + bvec->bv_len - 1,
 						EXTENT_NODATASUM, GFP_NOFS);
 				} else {
-					printk(KERN_INFO "btrfs no csum found "
-					       "for inode %llu start %llu\n",
-					       (unsigned long long)
-					       btrfs_ino(inode),
-					       (unsigned long long)offset);
+					pr_info("no csum found for inode %llu start %llu\n",
+						(unsigned long long)
+						btrfs_ino(inode),
+						(unsigned long long)offset);
 				}
 				item = NULL;
 				btrfs_release_path(path);
diff --git a/fs/btrfs/free-space-cache.c b/fs/btrfs/free-space-cache.c
index b21a3cd..1b33bd9 100644
--- a/fs/btrfs/free-space-cache.c
+++ b/fs/btrfs/free-space-cache.c
@@ -16,6 +16,8 @@
  * Boston, MA 021110-1307, USA.
  */
 
+#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
+
 #include <linux/pagemap.h>
 #include <linux/sched.h>
 #include <linux/slab.h>
@@ -350,8 +352,7 @@ static int io_ctl_prepare_pages(struct io_ctl *io_ctl, struct inode *inode,
 			btrfs_readpage(NULL, page);
 			lock_page(page);
 			if (!PageUptodate(page)) {
-				printk(KERN_ERR "btrfs: error reading free "
-				       "space cache\n");
+				pr_err("error reading free space cache\n");
 				io_ctl_drop_pages(io_ctl);
 				return -EIO;
 			}
@@ -408,9 +409,8 @@ static int io_ctl_check_generation(struct io_ctl *io_ctl, u64 generation)
 
 	gen = io_ctl->cur;
 	if (le64_to_cpu(*gen) != generation) {
-		printk_ratelimited(KERN_ERR "btrfs: space cache generation "
-				   "(%Lu) does not match inode (%Lu)\n", *gen,
-				   generation);
+		pr_err_ratelimited("space cache generation (%llu) does not match inode (%llu)\n",
+				   *gen, generation);
 		io_ctl_unmap_page(io_ctl);
 		return -EIO;
 	}
@@ -466,8 +466,7 @@ static int io_ctl_check_crc(struct io_ctl *io_ctl, int index)
 			      PAGE_CACHE_SIZE - offset);
 	btrfs_csum_final(crc, (char *)&crc);
 	if (val != crc) {
-		printk_ratelimited(KERN_ERR "btrfs: csum mismatch on free "
-				   "space cache\n");
+		pr_err_ratelimited("csum mismatch on free space cache\n");
 		io_ctl_unmap_page(io_ctl);
 		return -EIO;
 	}
@@ -1881,7 +1880,7 @@ out:
 	spin_unlock(&ctl->tree_lock);
 
 	if (ret) {
-		printk(KERN_CRIT "btrfs: unable to add free space :%d\n", ret);
+		pr_crit("unable to add free space :%d\n", ret);
 		BUG_ON(ret == -EEXIST);
 	}
 
@@ -1990,15 +1989,14 @@ void btrfs_dump_free_space(struct btrfs_block_group_cache *block_group,
 		info = rb_entry(n, struct btrfs_free_space, offset_index);
 		if (info->bytes >= bytes && !block_group->ro)
 			count++;
-		printk(KERN_CRIT "entry offset %llu, bytes %llu, bitmap %s\n",
-		       (unsigned long long)info->offset,
-		       (unsigned long long)info->bytes,
-		       (info->bitmap) ? "yes" : "no");
+		pr_crit("entry offset %llu, bytes %llu, bitmap %s\n",
+			(unsigned long long)info->offset,
+			(unsigned long long)info->bytes,
+			(info->bitmap) ? "yes" : "no");
 	}
-	printk(KERN_INFO "block group has cluster?: %s\n",
-	       list_empty(&block_group->cluster_list) ? "no" : "yes");
-	printk(KERN_INFO "%d blocks of free space at or bigger than bytes is"
-	       "\n", count);
+	pr_info("block group has cluster?: %s\n",
+		list_empty(&block_group->cluster_list) ? "no" : "yes");
+	pr_info("%d blocks of free space at or bigger than bytes is\n", count);
 }
 
 void btrfs_init_free_space_ctl(struct btrfs_block_group_cache *block_group)
@@ -3150,7 +3148,7 @@ again:
 	return 0;
 }
 
-#define test_msg(fmt, ...) printk(KERN_INFO "btrfs: selftest: " fmt, ##__VA_ARGS__)
+#define test_msg(fmt, ...) pr_info("selftest: " fmt, ##__VA_ARGS__)
 
 /*
  * This test just does basic sanity checking, making sure we can add an exten
diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index 6d1b93c..b5e6a49 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -16,6 +16,8 @@
  * Boston, MA 021110-1307, USA.
  */
 
+#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
+
 #include <linux/kernel.h>
 #include <linux/bio.h>
 #include <linux/buffer_head.h>
@@ -6932,10 +6934,9 @@ static void btrfs_end_dio_bio(struct bio *bio, int err)
 	struct btrfs_dio_private *dip = bio->bi_private;
 
 	if (err) {
-		printk(KERN_ERR "btrfs direct IO failed ino %llu rw %lu "
-		      "sector %#Lx len %u err no %d\n",
-		      (unsigned long long)btrfs_ino(dip->inode), bio->bi_rw,
-		      (unsigned long long)bio->bi_sector, bio->bi_size, err);
+		pr_err("direct IO failed ino %llu rw %lu sector %#Lx len %u err no %d\n",
+		       (unsigned long long)btrfs_ino(dip->inode), bio->bi_rw,
+		       (unsigned long long)bio->bi_sector, bio->bi_size, err);
 		dip->errors = 1;
 
 		/*
diff --git a/fs/btrfs/ioctl.c b/fs/btrfs/ioctl.c
index 238a055..0d07134 100644
--- a/fs/btrfs/ioctl.c
+++ b/fs/btrfs/ioctl.c
@@ -16,6 +16,8 @@
  * Boston, MA 021110-1307, USA.
  */
 
+#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
+
 #include <linux/kernel.h>
 #include <linux/bio.h>
 #include <linux/buffer_head.h>
@@ -1377,7 +1379,7 @@ static noinline int btrfs_ioctl_resize(struct file *file,
 
 	if (atomic_xchg(&root->fs_info->mutually_exclusive_operation_running,
 			1)) {
-		pr_info("btrfs: dev add/delete/balance/replace/resize operation in progress\n");
+		pr_info("dev add/delete/balance/replace/resize operation in progress\n");
 		mnt_drop_write_file(file);
 		return -EINVAL;
 	}
@@ -1403,22 +1405,20 @@ static noinline int btrfs_ioctl_resize(struct file *file,
 			ret = -EINVAL;
 			goto out_free;
 		}
-		printk(KERN_INFO "btrfs: resizing devid %llu\n",
-		       (unsigned long long)devid);
+		pr_info("resizing devid %llu\n", (unsigned long long)devid);
 	}
 
 	device = btrfs_find_device(root->fs_info, devid, NULL, NULL);
 	if (!device) {
-		printk(KERN_INFO "btrfs: resizer unable to find device %llu\n",
-		       (unsigned long long)devid);
+		pr_info("resizer unable to find device %llu\n",
+			(unsigned long long)devid);
 		ret = -ENODEV;
 		goto out_free;
 	}
 
 	if (!device->writeable) {
-		printk(KERN_INFO "btrfs: resizer unable to apply on "
-		       "readonly device %llu\n",
-		       (unsigned long long)devid);
+		pr_info("resizer unable to apply on readonly device %llu\n",
+			(unsigned long long)devid);
 		ret = -EPERM;
 		goto out_free;
 	}
@@ -1531,8 +1531,7 @@ static noinline int btrfs_ioctl_snap_create_transid(struct file *file,
 
 		src_inode = file_inode(src.file);
 		if (src_inode->i_sb != file_inode(file)->i_sb) {
-			printk(KERN_INFO "btrfs: Snapshot src from "
-			       "another FS\n");
+			pr_info("Snapshot src from another FS\n");
 			ret = -EINVAL;
 		} else {
 			ret = btrfs_mksubvol(&file->f_path, name, namelen,
@@ -1885,8 +1884,7 @@ static noinline int search_ioctl(struct inode *inode,
 		key.offset = (u64)-1;
 		root = btrfs_read_fs_root_no_name(info, &key);
 		if (IS_ERR(root)) {
-			printk(KERN_ERR "could not find root %llu\n",
-			       sk->tree_id);
+			pr_err("could not find root %llu\n", sk->tree_id);
 			btrfs_free_path(path);
 			return -ENOENT;
 		}
@@ -1980,7 +1978,7 @@ static noinline int btrfs_search_path_in_tree(struct btrfs_fs_info *info,
 	key.offset = (u64)-1;
 	root = btrfs_read_fs_root_no_name(info, &key);
 	if (IS_ERR(root)) {
-		printk(KERN_ERR "could not find root %llu\n", tree_id);
+		pr_err("could not find root %llu\n", tree_id);
 		ret = -ENOENT;
 		goto out;
 	}
@@ -2326,7 +2324,7 @@ static long btrfs_ioctl_add_dev(struct btrfs_root *root, void __user *arg)
 
 	if (atomic_xchg(&root->fs_info->mutually_exclusive_operation_running,
 			1)) {
-		pr_info("btrfs: dev add/delete/balance/replace/resize operation in progress\n");
+		pr_info("dev add/delete/balance/replace/resize operation in progress\n");
 		return -EINVAL;
 	}
 
@@ -2989,8 +2987,7 @@ static long btrfs_ioctl_default_subvol(struct file *file, void __user *argp)
 	if (IS_ERR_OR_NULL(di)) {
 		btrfs_free_path(path);
 		btrfs_end_transaction(trans, root);
-		printk(KERN_ERR "Umm, you don't have the default dir item, "
-		       "this isn't going to work\n");
+		pr_err("Umm, you don't have the default dir item, this isn't going to work\n");
 		ret = -ENOENT;
 		goto out;
 	}
@@ -3315,7 +3312,7 @@ static long btrfs_ioctl_dev_replace(struct btrfs_root *root, void __user *arg)
 		if (atomic_xchg(
 			&root->fs_info->mutually_exclusive_operation_running,
 			1)) {
-			pr_info("btrfs: dev add/delete/balance/replace/resize operation in progress\n");
+			pr_info("dev add/delete/balance/replace/resize operation in progress\n");
 			ret = -EINPROGRESS;
 		} else {
 			ret = btrfs_dev_replace_start(root, p);
@@ -3560,7 +3557,7 @@ again:
 	} else {
 		/* this is (1) */
 		mutex_unlock(&fs_info->balance_mutex);
-		pr_info("btrfs: dev add/delete/balance/replace/resize operation in progress\n");
+		pr_info("dev add/delete/balance/replace/resize operation in progress\n");
 		ret = -EINVAL;
 		goto out;
 	}
@@ -4046,7 +4043,7 @@ static int btrfs_ioctl_get_fslabel(struct file *file, void __user *arg)
 	int ret;
 
 	if (len == BTRFS_LABEL_SIZE) {
-		pr_warn("btrfs: label is too long, return the first %zu bytes\n",
+		pr_warn("label is too long, return the first %zu bytes\n",
 			--len);
 	}
 
@@ -4072,7 +4069,7 @@ static int btrfs_ioctl_set_fslabel(struct file *file, void __user *arg)
 		return -EFAULT;
 
 	if (strnlen(label, BTRFS_LABEL_SIZE) == BTRFS_LABEL_SIZE) {
-		pr_err("btrfs: unable to set label with more than %d bytes\n",
+		pr_err("unable to set label with more than %d bytes\n",
 		       BTRFS_LABEL_SIZE - 1);
 		return -EINVAL;
 	}
diff --git a/fs/btrfs/lzo.c b/fs/btrfs/lzo.c
index f93151a..9e49778 100644
--- a/fs/btrfs/lzo.c
+++ b/fs/btrfs/lzo.c
@@ -16,6 +16,8 @@
  * Boston, MA 021110-1307, USA.
  */
 
+#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
+
 #include <linux/kernel.h>
 #include <linux/slab.h>
 #include <linux/vmalloc.h>
@@ -141,7 +143,7 @@ static int lzo_compress_pages(struct list_head *ws,
 		ret = lzo1x_1_compress(data_in, in_len, workspace->cbuf,
 				       &out_len, workspace->mem);
 		if (ret != LZO_E_OK) {
-			printk(KERN_DEBUG "btrfs deflate in loop returned %d\n",
+			printk(KERN_DEBUG "btrfs: deflate in loop returned %d\n",
 			       ret);
 			ret = -1;
 			goto out;
@@ -355,7 +357,7 @@ cont:
 		if (need_unmap)
 			kunmap(pages_in[page_in_index - 1]);
 		if (ret != LZO_E_OK) {
-			printk(KERN_WARNING "btrfs decompress failed\n");
+			pr_warn("decompress failed\n");
 			ret = -1;
 			break;
 		}
@@ -399,7 +401,7 @@ static int lzo_decompress(struct list_head *ws, unsigned char *data_in,
 	out_len = PAGE_CACHE_SIZE;
 	ret = lzo1x_decompress_safe(data_in, in_len, workspace->buf, &out_len);
 	if (ret != LZO_E_OK) {
-		printk(KERN_WARNING "btrfs decompress failed!\n");
+		pr_warn("decompress failed!\n");
 		ret = -1;
 		goto out;
 	}
diff --git a/fs/btrfs/ordered-data.c b/fs/btrfs/ordered-data.c
index 8136982..df6558c 100644
--- a/fs/btrfs/ordered-data.c
+++ b/fs/btrfs/ordered-data.c
@@ -16,6 +16,8 @@
  * Boston, MA 021110-1307, USA.
  */
 
+#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
+
 #include <linux/slab.h>
 #include <linux/blkdev.h>
 #include <linux/writeback.h>
@@ -335,15 +337,15 @@ int btrfs_dec_test_first_ordered_pending(struct inode *inode,
 		      entry->len);
 	*file_offset = dec_end;
 	if (dec_start > dec_end) {
-		printk(KERN_CRIT "bad ordering dec_start %llu end %llu\n",
-		       (unsigned long long)dec_start,
-		       (unsigned long long)dec_end);
+		pr_crit("bad ordering dec_start %llu end %llu\n",
+			(unsigned long long)dec_start,
+			(unsigned long long)dec_end);
 	}
 	to_dec = dec_end - dec_start;
 	if (to_dec > entry->bytes_left) {
-		printk(KERN_CRIT "bad ordered accounting left %llu size %llu\n",
-		       (unsigned long long)entry->bytes_left,
-		       (unsigned long long)to_dec);
+		pr_crit("bad ordered accounting left %llu size %llu\n",
+			(unsigned long long)entry->bytes_left,
+			(unsigned long long)to_dec);
 	}
 	entry->bytes_left -= to_dec;
 	if (!uptodate)
@@ -402,9 +404,9 @@ have_entry:
 	}
 
 	if (io_size > entry->bytes_left) {
-		printk(KERN_CRIT "bad ordered accounting left %llu size %llu\n",
-		       (unsigned long long)entry->bytes_left,
-		       (unsigned long long)io_size);
+		pr_crit("bad ordered accounting left %llu size %llu\n",
+			(unsigned long long)entry->bytes_left,
+			(unsigned long long)io_size);
 	}
 	entry->bytes_left -= io_size;
 	if (!uptodate)
diff --git a/fs/btrfs/print-tree.c b/fs/btrfs/print-tree.c
index dc0024f..6e42fe6 100644
--- a/fs/btrfs/print-tree.c
+++ b/fs/btrfs/print-tree.c
@@ -16,6 +16,8 @@
  * Boston, MA 021110-1307, USA.
  */
 
+#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
+
 #include "ctree.h"
 #include "disk-io.h"
 #include "print-tree.h"
@@ -24,36 +26,34 @@ static void print_chunk(struct extent_buffer *eb, struct btrfs_chunk *chunk)
 {
 	int num_stripes = btrfs_chunk_num_stripes(eb, chunk);
 	int i;
-	printk(KERN_INFO "\t\tchunk length %llu owner %llu type %llu "
-	       "num_stripes %d\n",
-	       (unsigned long long)btrfs_chunk_length(eb, chunk),
-	       (unsigned long long)btrfs_chunk_owner(eb, chunk),
-	       (unsigned long long)btrfs_chunk_type(eb, chunk),
-	       num_stripes);
+	pr_info("\t\tchunk length %llu owner %llu type %llu num_stripes %d\n",
+		(unsigned long long)btrfs_chunk_length(eb, chunk),
+		(unsigned long long)btrfs_chunk_owner(eb, chunk),
+		(unsigned long long)btrfs_chunk_type(eb, chunk),
+		num_stripes);
 	for (i = 0 ; i < num_stripes ; i++) {
-		printk(KERN_INFO "\t\t\tstripe %d devid %llu offset %llu\n", i,
-		      (unsigned long long)btrfs_stripe_devid_nr(eb, chunk, i),
-		      (unsigned long long)btrfs_stripe_offset_nr(eb, chunk, i));
+		pr_info("\t\t\tstripe %d devid %llu offset %llu\n",
+			i,
+			(unsigned long long)btrfs_stripe_devid_nr(eb, chunk, i),
+			(unsigned long long)btrfs_stripe_offset_nr(eb, chunk, i));
 	}
 }
 static void print_dev_item(struct extent_buffer *eb,
 			   struct btrfs_dev_item *dev_item)
 {
-	printk(KERN_INFO "\t\tdev item devid %llu "
-	       "total_bytes %llu bytes used %llu\n",
-	       (unsigned long long)btrfs_device_id(eb, dev_item),
-	       (unsigned long long)btrfs_device_total_bytes(eb, dev_item),
-	       (unsigned long long)btrfs_device_bytes_used(eb, dev_item));
+	pr_info("\t\tdev item devid %llu total_bytes %llu bytes used %llu\n",
+		(unsigned long long)btrfs_device_id(eb, dev_item),
+		(unsigned long long)btrfs_device_total_bytes(eb, dev_item),
+		(unsigned long long)btrfs_device_bytes_used(eb, dev_item));
 }
 static void print_extent_data_ref(struct extent_buffer *eb,
 				  struct btrfs_extent_data_ref *ref)
 {
-	printk(KERN_INFO "\t\textent data backref root %llu "
-	       "objectid %llu offset %llu count %u\n",
-	       (unsigned long long)btrfs_extent_data_ref_root(eb, ref),
-	       (unsigned long long)btrfs_extent_data_ref_objectid(eb, ref),
-	       (unsigned long long)btrfs_extent_data_ref_offset(eb, ref),
-	       btrfs_extent_data_ref_count(eb, ref));
+	pr_info("\t\textent data backref root %llu objectid %llu offset %llu count %u\n",
+		(unsigned long long)btrfs_extent_data_ref_root(eb, ref),
+		(unsigned long long)btrfs_extent_data_ref_objectid(eb, ref),
+		(unsigned long long)btrfs_extent_data_ref_offset(eb, ref),
+		btrfs_extent_data_ref_count(eb, ref));
 }
 
 static void print_extent_item(struct extent_buffer *eb, int slot)
@@ -75,8 +75,7 @@ static void print_extent_item(struct extent_buffer *eb, int slot)
 		struct btrfs_extent_item_v0 *ei0;
 		BUG_ON(item_size != sizeof(*ei0));
 		ei0 = btrfs_item_ptr(eb, slot, struct btrfs_extent_item_v0);
-		printk(KERN_INFO "\t\textent refs %u\n",
-		       btrfs_extent_refs_v0(eb, ei0));
+		pr_info("\t\textent refs %u\n", btrfs_extent_refs_v0(eb, ei0));
 		return;
 #else
 		BUG();
@@ -86,21 +85,20 @@ static void print_extent_item(struct extent_buffer *eb, int slot)
 	ei = btrfs_item_ptr(eb, slot, struct btrfs_extent_item);
 	flags = btrfs_extent_flags(eb, ei);
 
-	printk(KERN_INFO "\t\textent refs %llu gen %llu flags %llu\n",
-	       (unsigned long long)btrfs_extent_refs(eb, ei),
-	       (unsigned long long)btrfs_extent_generation(eb, ei),
-	       (unsigned long long)flags);
+	pr_info("\t\textent refs %llu gen %llu flags %llu\n",
+		(unsigned long long)btrfs_extent_refs(eb, ei),
+		(unsigned long long)btrfs_extent_generation(eb, ei),
+		(unsigned long long)flags);
 
 	if (flags & BTRFS_EXTENT_FLAG_TREE_BLOCK) {
 		struct btrfs_tree_block_info *info;
 		info = (struct btrfs_tree_block_info *)(ei + 1);
 		btrfs_tree_block_key(eb, info, &key);
-		printk(KERN_INFO "\t\ttree block key (%llu %x %llu) "
-		       "level %d\n",
-		       (unsigned long long)btrfs_disk_key_objectid(&key),
-		       key.type,
-		       (unsigned long long)btrfs_disk_key_offset(&key),
-		       btrfs_tree_block_level(eb, info));
+		pr_info("\t\ttree block key (%llu %x %llu) level %d\n",
+			(unsigned long long)btrfs_disk_key_objectid(&key),
+			key.type,
+			(unsigned long long)btrfs_disk_key_offset(&key),
+			btrfs_tree_block_level(eb, info));
 		iref = (struct btrfs_extent_inline_ref *)(info + 1);
 	} else {
 		iref = (struct btrfs_extent_inline_ref *)(ei + 1);
@@ -114,12 +112,12 @@ static void print_extent_item(struct extent_buffer *eb, int slot)
 		offset = btrfs_extent_inline_ref_offset(eb, iref);
 		switch (type) {
 		case BTRFS_TREE_BLOCK_REF_KEY:
-			printk(KERN_INFO "\t\ttree block backref "
-				"root %llu\n", (unsigned long long)offset);
+			pr_info("\t\ttree block backref root %llu\n",
+				(unsigned long long)offset);
 			break;
 		case BTRFS_SHARED_BLOCK_REF_KEY:
-			printk(KERN_INFO "\t\tshared block backref "
-				"parent %llu\n", (unsigned long long)offset);
+			pr_info("\t\tshared block backref parent %llu\n",
+				(unsigned long long)offset);
 			break;
 		case BTRFS_EXTENT_DATA_REF_KEY:
 			dref = (struct btrfs_extent_data_ref *)(&iref->offset);
@@ -127,10 +125,9 @@ static void print_extent_item(struct extent_buffer *eb, int slot)
 			break;
 		case BTRFS_SHARED_DATA_REF_KEY:
 			sref = (struct btrfs_shared_data_ref *)(iref + 1);
-			printk(KERN_INFO "\t\tshared data backref "
-			       "parent %llu count %u\n",
-			       (unsigned long long)offset,
-			       btrfs_shared_data_ref_count(eb, sref));
+			pr_info("\t\tshared data backref parent %llu count %u\n",
+				(unsigned long long)offset,
+				btrfs_shared_data_ref_count(eb, sref));
 			break;
 		default:
 			BUG();
@@ -183,8 +180,7 @@ void btrfs_print_leaf(struct btrfs_root *root, struct extent_buffer *l)
 		item = btrfs_item_nr(l, i);
 		btrfs_item_key_to_cpu(l, &key, i);
 		type = btrfs_key_type(&key);
-		printk(KERN_INFO "\titem %d key (%llu %x %llu) itemoff %d "
-		       "itemsize %d\n",
+		pr_info("\titem %d key (%llu %x %llu) itemoff %d itemsize %d\n",
 			i,
 			(unsigned long long)key.objectid, type,
 			(unsigned long long)key.offset,
@@ -192,23 +188,22 @@ void btrfs_print_leaf(struct btrfs_root *root, struct extent_buffer *l)
 		switch (type) {
 		case BTRFS_INODE_ITEM_KEY:
 			ii = btrfs_item_ptr(l, i, struct btrfs_inode_item);
-			printk(KERN_INFO "\t\tinode generation %llu size %llu "
-			       "mode %o\n",
-			       (unsigned long long)
-			       btrfs_inode_generation(l, ii),
-			      (unsigned long long)btrfs_inode_size(l, ii),
-			       btrfs_inode_mode(l, ii));
+			pr_info("\t\tinode generation %llu size %llu mode %o\n",
+				(unsigned long long)
+				btrfs_inode_generation(l, ii),
+				(unsigned long long)btrfs_inode_size(l, ii),
+				btrfs_inode_mode(l, ii));
 			break;
 		case BTRFS_DIR_ITEM_KEY:
 			di = btrfs_item_ptr(l, i, struct btrfs_dir_item);
 			btrfs_dir_item_key_to_cpu(l, di, &found_key);
-			printk(KERN_INFO "\t\tdir oid %llu type %u\n",
+			pr_info("\t\tdir oid %llu type %u\n",
 				(unsigned long long)found_key.objectid,
 				btrfs_dir_type(l, di));
 			break;
 		case BTRFS_ROOT_ITEM_KEY:
 			ri = btrfs_item_ptr(l, i, struct btrfs_root_item);
-			printk(KERN_INFO "\t\troot data bytenr %llu refs %u\n",
+			pr_info("\t\troot data bytenr %llu refs %u\n",
 				(unsigned long long)
 				btrfs_disk_root_bytenr(l, ri),
 				btrfs_disk_root_refs(l, ri));
@@ -217,10 +212,10 @@ void btrfs_print_leaf(struct btrfs_root *root, struct extent_buffer *l)
 			print_extent_item(l, i);
 			break;
 		case BTRFS_TREE_BLOCK_REF_KEY:
-			printk(KERN_INFO "\t\ttree block backref\n");
+			pr_info("\t\ttree block backref\n");
 			break;
 		case BTRFS_SHARED_BLOCK_REF_KEY:
-			printk(KERN_INFO "\t\tshared block backref\n");
+			pr_info("\t\tshared block backref\n");
 			break;
 		case BTRFS_EXTENT_DATA_REF_KEY:
 			dref = btrfs_item_ptr(l, i,
@@ -230,33 +225,30 @@ void btrfs_print_leaf(struct btrfs_root *root, struct extent_buffer *l)
 		case BTRFS_SHARED_DATA_REF_KEY:
 			sref = btrfs_item_ptr(l, i,
 					      struct btrfs_shared_data_ref);
-			printk(KERN_INFO "\t\tshared data backref count %u\n",
-			       btrfs_shared_data_ref_count(l, sref));
+			pr_info("\t\tshared data backref count %u\n",
+				btrfs_shared_data_ref_count(l, sref));
 			break;
 		case BTRFS_EXTENT_DATA_KEY:
 			fi = btrfs_item_ptr(l, i,
 					    struct btrfs_file_extent_item);
 			if (btrfs_file_extent_type(l, fi) ==
 			    BTRFS_FILE_EXTENT_INLINE) {
-				printk(KERN_INFO "\t\tinline extent data "
-				       "size %u\n",
-				       btrfs_file_extent_inline_len(l, fi));
+				pr_info("\t\tinline extent data size %u\n",
+					btrfs_file_extent_inline_len(l, fi));
 				break;
 			}
-			printk(KERN_INFO "\t\textent data disk bytenr %llu "
-			       "nr %llu\n",
-			       (unsigned long long)
-			       btrfs_file_extent_disk_bytenr(l, fi),
-			       (unsigned long long)
-			       btrfs_file_extent_disk_num_bytes(l, fi));
-			printk(KERN_INFO "\t\textent data offset %llu "
-			       "nr %llu ram %llu\n",
-			       (unsigned long long)
-			       btrfs_file_extent_offset(l, fi),
-			       (unsigned long long)
-			       btrfs_file_extent_num_bytes(l, fi),
-			       (unsigned long long)
-			       btrfs_file_extent_ram_bytes(l, fi));
+			pr_info("\t\textent data disk bytenr %llu nr %llu\n",
+				(unsigned long long)
+				btrfs_file_extent_disk_bytenr(l, fi),
+				(unsigned long long)
+				btrfs_file_extent_disk_num_bytes(l, fi));
+			pr_info("\t\textent data offset %llu nr %llu ram %llu\n",
+				(unsigned long long)
+				btrfs_file_extent_offset(l, fi),
+				(unsigned long long)
+				btrfs_file_extent_num_bytes(l, fi),
+				(unsigned long long)
+				btrfs_file_extent_ram_bytes(l, fi));
 			break;
 		case BTRFS_EXTENT_REF_V0_KEY:
 #ifdef BTRFS_COMPAT_EXTENT_TREE_V0
@@ -268,9 +260,9 @@ void btrfs_print_leaf(struct btrfs_root *root, struct extent_buffer *l)
 		case BTRFS_BLOCK_GROUP_ITEM_KEY:
 			bi = btrfs_item_ptr(l, i,
 					    struct btrfs_block_group_item);
-			printk(KERN_INFO "\t\tblock group used %llu\n",
-			       (unsigned long long)
-			       btrfs_disk_block_group_used(l, bi));
+			pr_info("\t\tblock group used %llu\n",
+				(unsigned long long)
+				btrfs_disk_block_group_used(l, bi));
 			break;
 		case BTRFS_CHUNK_ITEM_KEY:
 			print_chunk(l, btrfs_item_ptr(l, i,
@@ -283,23 +275,23 @@ void btrfs_print_leaf(struct btrfs_root *root, struct extent_buffer *l)
 		case BTRFS_DEV_EXTENT_KEY:
 			dev_extent = btrfs_item_ptr(l, i,
 						    struct btrfs_dev_extent);
-			printk(KERN_INFO "\t\tdev extent chunk_tree %llu\n"
-			       "\t\tchunk objectid %llu chunk offset %llu "
-			       "length %llu\n",
-			       (unsigned long long)
-			       btrfs_dev_extent_chunk_tree(l, dev_extent),
-			       (unsigned long long)
-			       btrfs_dev_extent_chunk_objectid(l, dev_extent),
-			       (unsigned long long)
-			       btrfs_dev_extent_chunk_offset(l, dev_extent),
-			       (unsigned long long)
-			       btrfs_dev_extent_length(l, dev_extent));
+			pr_info("\t\tdev extent chunk_tree %llu\n",
+				(unsigned long long)
+				btrfs_dev_extent_chunk_tree(l, dev_extent));
+			pr_info("\t\tchunk objectid %llu chunk offset %llu length %llu\n",
+				(unsigned long long)
+				btrfs_dev_extent_chunk_objectid(l, dev_extent),
+				(unsigned long long)
+				btrfs_dev_extent_chunk_offset(l, dev_extent),
+				(unsigned long long)
+				btrfs_dev_extent_length(l, dev_extent));
+
 			break;
 		case BTRFS_DEV_STATS_KEY:
-			printk(KERN_INFO "\t\tdevice stats\n");
+			pr_info("\t\tdevice stats\n");
 			break;
 		case BTRFS_DEV_REPLACE_KEY:
-			printk(KERN_INFO "\t\tdev replace\n");
+			pr_info("\t\tdev replace\n");
 			break;
 		};
 	}
@@ -324,12 +316,12 @@ void btrfs_print_tree(struct btrfs_root *root, struct extent_buffer *c)
 		level, nr, (u32)BTRFS_NODEPTRS_PER_BLOCK(root) - nr);
 	for (i = 0; i < nr; i++) {
 		btrfs_node_key_to_cpu(c, &key, i);
-		printk(KERN_INFO "\tkey %d (%llu %u %llu) block %llu\n",
-		       i,
-		       (unsigned long long)key.objectid,
-		       key.type,
-		       (unsigned long long)key.offset,
-		       (unsigned long long)btrfs_node_blockptr(c, i));
+		pr_info("\tkey %d (%llu %u %llu) block %llu\n",
+			i,
+			(unsigned long long)key.objectid,
+			key.type,
+			(unsigned long long)key.offset,
+			(unsigned long long)btrfs_node_blockptr(c, i));
 	}
 	for (i = 0; i < nr; i++) {
 		struct extent_buffer *next = read_tree_block(root,
diff --git a/fs/btrfs/qgroup.c b/fs/btrfs/qgroup.c
index 1280eff..1865b42 100644
--- a/fs/btrfs/qgroup.c
+++ b/fs/btrfs/qgroup.c
@@ -16,6 +16,8 @@
  * Boston, MA 021110-1307, USA.
  */
 
+#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
+
 #include <linux/sched.h>
 #include <linux/pagemap.h>
 #include <linux/writeback.h>
@@ -297,16 +299,13 @@ int btrfs_read_qgroup_config(struct btrfs_fs_info *fs_info)
 
 			if (btrfs_qgroup_status_version(l, ptr) !=
 			    BTRFS_QGROUP_STATUS_VERSION) {
-				printk(KERN_ERR
-				 "btrfs: old qgroup version, quota disabled\n");
+				pr_err("old qgroup version, quota disabled\n");
 				goto out;
 			}
 			if (btrfs_qgroup_status_generation(l, ptr) !=
 			    fs_info->generation) {
 				flags |= BTRFS_QGROUP_STATUS_FLAG_INCONSISTENT;
-				printk(KERN_ERR
-					"btrfs: qgroup generation mismatch, "
-					"marked as inconsistent\n");
+				pr_err("qgroup generation mismatch, marked as inconsistent\n");
 			}
 			fs_info->qgroup_flags = btrfs_qgroup_status_flags(l,
 									  ptr);
@@ -321,7 +320,7 @@ int btrfs_read_qgroup_config(struct btrfs_fs_info *fs_info)
 		qgroup = find_qgroup_rb(fs_info, found_key.offset);
 		if ((qgroup && found_key.type == BTRFS_QGROUP_INFO_KEY) ||
 		    (!qgroup && found_key.type == BTRFS_QGROUP_LIMIT_KEY)) {
-			printk(KERN_ERR "btrfs: inconsitent qgroup config\n");
+			pr_err("inconsistent qgroup config\n");
 			flags |= BTRFS_QGROUP_STATUS_FLAG_INCONSISTENT;
 		}
 		if (!qgroup) {
@@ -392,8 +391,7 @@ next1:
 		ret = add_relation_rb(fs_info, found_key.objectid,
 				      found_key.offset);
 		if (ret == -ENOENT) {
-			printk(KERN_WARNING
-				"btrfs: orphan qgroup relation 0x%llx->0x%llx\n",
+			pr_warn("orphan qgroup relation 0x%llx->0x%llx\n",
 				(unsigned long long)found_key.objectid,
 				(unsigned long long)found_key.offset);
 			ret = 0;	/* ignore the error */
@@ -1173,8 +1171,8 @@ int btrfs_limit_qgroup(struct btrfs_trans_handle *trans,
 				       limit->rsv_excl);
 	if (ret) {
 		fs_info->qgroup_flags |= BTRFS_QGROUP_STATUS_FLAG_INCONSISTENT;
-		printk(KERN_INFO "unable to update quota limit for %llu\n",
-		       (unsigned long long)qgroupid);
+		pr_info("unable to update quota limit for %llu\n",
+			(unsigned long long)qgroupid);
 	}
 
 	spin_lock(&fs_info->qgroup_lock);
@@ -1852,10 +1850,10 @@ void assert_qgroups_uptodate(struct btrfs_trans_handle *trans)
 {
 	if (list_empty(&trans->qgroup_ref_list) && !trans->delayed_ref_elem.seq)
 		return;
-	pr_err("btrfs: qgroups not uptodate in trans handle %p: list is%s empty, seq is %#x.%x\n",
-		trans, list_empty(&trans->qgroup_ref_list) ? "" : " not",
-		(u32)(trans->delayed_ref_elem.seq >> 32),
-		(u32)trans->delayed_ref_elem.seq);
+	pr_err("qgroups not uptodate in trans handle %p: list is%s empty, seq is %#x.%x\n",
+	       trans, list_empty(&trans->qgroup_ref_list) ? "" : " not",
+	       (u32)(trans->delayed_ref_elem.seq >> 32),
+	       (u32)trans->delayed_ref_elem.seq);
 	BUG();
 }
 
@@ -2050,10 +2048,10 @@ out:
 	mutex_unlock(&fs_info->qgroup_rescan_lock);
 
 	if (err >= 0) {
-		pr_info("btrfs: qgroup scan completed%s\n",
+		pr_info("qgroup scan completed%s\n",
 			err == 2 ? " (inconsistency flag cleared)" : "");
 	} else {
-		pr_err("btrfs: qgroup scan failed with %d\n", err);
+		pr_err("qgroup scan failed with %d\n", err);
 	}
 
 	complete_all(&fs_info->qgroup_rescan_completion);
@@ -2109,7 +2107,7 @@ qgroup_rescan_init(struct btrfs_fs_info *fs_info, u64 progress_objectid,
 
 	if (ret) {
 err:
-		pr_info("btrfs: qgroup_rescan_init failed with %d\n", ret);
+		pr_info("qgroup_rescan_init failed with %d\n", ret);
 		return ret;
 	}
 
diff --git a/fs/btrfs/reada.c b/fs/btrfs/reada.c
index 1031b69..61da78b 100644
--- a/fs/btrfs/reada.c
+++ b/fs/btrfs/reada.c
@@ -16,6 +16,8 @@
  * Boston, MA 021110-1307, USA.
  */
 
+#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
+
 #include <linux/sched.h>
 #include <linux/pagemap.h>
 #include <linux/writeback.h>
@@ -365,8 +367,8 @@ static struct reada_extent *reada_find_extent(struct btrfs_root *root,
 		goto error;
 
 	if (bbio->num_stripes > BTRFS_MAX_MIRRORS) {
-		printk(KERN_ERR "btrfs readahead: more than %d copies not "
-				"supported", BTRFS_MAX_MIRRORS);
+		pr_err("readahead: more than %d copies not supported\n",
+		       BTRFS_MAX_MIRRORS);
 		goto error;
 	}
 
@@ -824,13 +826,13 @@ static void dump_devs(struct btrfs_fs_info *fs_info, int all)
 				"%d devs", zone->start, zone->end, zone->elems,
 				zone->locked);
 			for (j = 0; j < zone->ndevs; ++j) {
-				printk(KERN_CONT " %lld",
+				pr_cont(" %lld",
 					zone->devs[j]->devid);
 			}
 			if (device->reada_curr_zone == zone)
-				printk(KERN_CONT " curr off %llu",
+				pr_cont(" curr off %llu",
 					device->reada_next - zone->start);
-			printk(KERN_CONT "\n");
+			pr_cont("\n");
 			index = (zone->end >> PAGE_CACHE_SHIFT) + 1;
 		}
 		cnt = 0;
@@ -849,15 +851,15 @@ static void dump_devs(struct btrfs_fs_info *fs_info, int all)
 				re->scheduled_for->devid : -1);
 
 			for (i = 0; i < re->nzones; ++i) {
-				printk(KERN_CONT " zone %llu-%llu devs",
+				pr_cont(" zone %llu-%llu devs",
 					re->zones[i]->start,
 					re->zones[i]->end);
 				for (j = 0; j < re->zones[i]->ndevs; ++j) {
-					printk(KERN_CONT " %lld",
+					pr_cont(" %lld",
 						re->zones[i]->devs[j]->devid);
 				}
 			}
-			printk(KERN_CONT "\n");
+			pr_cont("\n");
 			index = (re->logical >> PAGE_CACHE_SHIFT) + 1;
 			if (++cnt > 15)
 				break;
@@ -882,20 +884,20 @@ static void dump_devs(struct btrfs_fs_info *fs_info, int all)
 			re->logical, re->blocksize, list_empty(&re->extctl),
 			re->scheduled_for ? re->scheduled_for->devid : -1);
 		for (i = 0; i < re->nzones; ++i) {
-			printk(KERN_CONT " zone %llu-%llu devs",
+			pr_cont(" zone %llu-%llu devs",
 				re->zones[i]->start,
 				re->zones[i]->end);
 			for (i = 0; i < re->nzones; ++i) {
-				printk(KERN_CONT " zone %llu-%llu devs",
+				pr_cont(" zone %llu-%llu devs",
 					re->zones[i]->start,
 					re->zones[i]->end);
 				for (j = 0; j < re->zones[i]->ndevs; ++j) {
-					printk(KERN_CONT " %lld",
+					pr_cont(" %lld",
 						re->zones[i]->devs[j]->devid);
 				}
 			}
 		}
-		printk(KERN_CONT "\n");
+		pr_cont("\n");
 		index = (re->logical >> PAGE_CACHE_SHIFT) + 1;
 	}
 	spin_unlock(&fs_info->reada_lock);
diff --git a/fs/btrfs/relocation.c b/fs/btrfs/relocation.c
index 1209649..ca2d62a 100644
--- a/fs/btrfs/relocation.c
+++ b/fs/btrfs/relocation.c
@@ -16,6 +16,8 @@
  * Boston, MA 021110-1307, USA.
  */
 
+#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
+
 #include <linux/sched.h>
 #include <linux/pagemap.h>
 #include <linux/writeback.h>
@@ -4218,9 +4220,9 @@ int btrfs_relocate_block_group(struct btrfs_root *extent_root, u64 group_start)
 		goto out;
 	}
 
-	printk(KERN_INFO "btrfs: relocating block group %llu flags %llu\n",
-	       (unsigned long long)rc->block_group->key.objectid,
-	       (unsigned long long)rc->block_group->flags);
+	pr_info("relocating block group %llu flags %llu\n",
+		(unsigned long long)rc->block_group->key.objectid,
+		(unsigned long long)rc->block_group->flags);
 
 	ret = btrfs_start_all_delalloc_inodes(fs_info, 0);
 	if (ret < 0) {
@@ -4241,7 +4243,7 @@ int btrfs_relocate_block_group(struct btrfs_root *extent_root, u64 group_start)
 		if (rc->extents_found == 0)
 			break;
 
-		printk(KERN_INFO "btrfs: found %llu extents\n",
+		pr_info("found %llu extents\n",
 			(unsigned long long)rc->extents_found);
 
 		if (rc->stage == MOVE_DATA_EXTENTS && rc->found_file_extent) {
diff --git a/fs/btrfs/root-tree.c b/fs/btrfs/root-tree.c
index ffb1036..0465268 100644
--- a/fs/btrfs/root-tree.c
+++ b/fs/btrfs/root-tree.c
@@ -16,6 +16,8 @@
  * Boston, MA 021110-1307, USA.
  */
 
+#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
+
 #include <linux/uuid.h>
 #include "ctree.h"
 #include "transaction.h"
@@ -44,12 +46,7 @@ void btrfs_read_root_item(struct extent_buffer *eb, int slot,
 	if (!need_reset && btrfs_root_generation(item)
 		!= btrfs_root_generation_v2(item)) {
 		if (btrfs_root_generation_v2(item) != 0) {
-			printk(KERN_WARNING "btrfs: mismatching "
-					"generation and generation_v2 "
-					"found in root item. This root "
-					"was probably mounted with an "
-					"older kernel. Resetting all "
-					"new fields.\n");
+			pr_warn("mismatching generation and generation_v2 found in root item. This root was probably mounted with an older kernel. Resetting all new fields.\n");
 		}
 		need_reset = 1;
 	}
@@ -154,9 +151,9 @@ int btrfs_update_root(struct btrfs_trans_handle *trans, struct btrfs_root
 
 	if (ret != 0) {
 		btrfs_print_leaf(root, path->nodes[0]);
-		printk(KERN_CRIT "unable to update root key %llu %u %llu\n",
-		       (unsigned long long)key->objectid, key->type,
-		       (unsigned long long)key->offset);
+		pr_crit("unable to update root key %llu %u %llu\n",
+			(unsigned long long)key->objectid, key->type,
+			(unsigned long long)key->offset);
 		BUG_ON(1);
 	}
 
diff --git a/fs/btrfs/scrub.c b/fs/btrfs/scrub.c
index 4ba2a69..57e9dec 100644
--- a/fs/btrfs/scrub.c
+++ b/fs/btrfs/scrub.c
@@ -16,6 +16,8 @@
  * Boston, MA 021110-1307, USA.
  */
 
+#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
+
 #include <linux/blkdev.h>
 #include <linux/ratelimit.h>
 #include "ctree.h"
@@ -1426,8 +1428,7 @@ static int scrub_repair_page_from_good_copy(struct scrub_block *sblock_bad,
 		DECLARE_COMPLETION_ONSTACK(complete);
 
 		if (!page_bad->dev->bdev) {
-			printk_ratelimited(KERN_WARNING
-				"btrfs: scrub_repair_page_from_good_copy(bdev == NULL) is unexpected!\n");
+			pr_warn_ratelimited("scrub_repair_page_from_good_copy(bdev == NULL) is unexpected!\n");
 			return -EIO;
 		}
 
@@ -1889,8 +1890,7 @@ static void scrub_submit(struct scrub_ctx *sctx)
 		 * this case it should already fail the mount.
 		 * This case is handled correctly (but _very_ slowly).
 		 */
-		printk_ratelimited(KERN_WARNING
-			"btrfs: scrub_submit(bio bdev == NULL) is unexpected!\n");
+		pr_warn_ratelimited("scrub_submit(bio bdev == NULL) is unexpected!\n");
 		bio_endio(sbio->bio, -EIO);
 	} else {
 		btrfsic_submit_bio(READ, sbio->bio);
@@ -2452,9 +2452,7 @@ static noinline_for_stack int scrub_stripe(struct scrub_ctx *sctx,
 
 			if (key.objectid < logical &&
 			    (flags & BTRFS_EXTENT_FLAG_TREE_BLOCK)) {
-				printk(KERN_ERR
-				       "btrfs scrub: tree block %llu spanning "
-				       "stripes, ignored. logical=%llu\n",
+				pr_err("scrub: tree block %llu spanning stripes, ignored. logical=%llu\n",
 				       (unsigned long long)key.objectid,
 				       (unsigned long long)logical);
 				goto next;
@@ -2841,8 +2839,7 @@ int btrfs_scrub_dev(struct btrfs_fs_info *fs_info, u64 devid, u64 start,
 	 * check some assumptions
 	 */
 	if (fs_info->chunk_root->nodesize != fs_info->chunk_root->leafsize) {
-		printk(KERN_ERR
-		       "btrfs_scrub: size assumption nodesize == leafsize (%d == %d) fails\n",
+		pr_err("scrub: size assumption nodesize == leafsize (%d == %d) fails\n",
 		       fs_info->chunk_root->nodesize,
 		       fs_info->chunk_root->leafsize);
 		return -EINVAL;
@@ -2854,16 +2851,14 @@ int btrfs_scrub_dev(struct btrfs_fs_info *fs_info, u64 devid, u64 start,
 		 * the way scrub is implemented. Do not handle this
 		 * situation at all because it won't ever happen.
 		 */
-		printk(KERN_ERR
-		       "btrfs_scrub: size assumption nodesize <= BTRFS_STRIPE_LEN (%d <= %d) fails\n",
+		pr_err("scrub: size assumption nodesize <= BTRFS_STRIPE_LEN (%d <= %d) fails\n",
 		       fs_info->chunk_root->nodesize, BTRFS_STRIPE_LEN);
 		return -EINVAL;
 	}
 
 	if (fs_info->chunk_root->sectorsize != PAGE_SIZE) {
 		/* not supported for data w/o checksums */
-		printk(KERN_ERR
-		       "btrfs_scrub: size assumption sectorsize != PAGE_SIZE (%d != %lld) fails\n",
+		pr_err("scrub: size assumption sectorsize != PAGE_SIZE (%d != %lld) fails\n",
 		       fs_info->chunk_root->sectorsize,
 		       (unsigned long long)PAGE_SIZE);
 		return -EINVAL;
@@ -2877,7 +2872,7 @@ int btrfs_scrub_dev(struct btrfs_fs_info *fs_info, u64 devid, u64 start,
 		 * would exhaust the array bounds of pagev member in
 		 * struct scrub_block
 		 */
-		pr_err("btrfs_scrub: size assumption nodesize and sectorsize <= SCRUB_MAX_PAGES_PER_BLOCK (%d <= %d && %d <= %d) fails\n",
+		pr_err("scrub: size assumption nodesize and sectorsize <= SCRUB_MAX_PAGES_PER_BLOCK (%d <= %d && %d <= %d) fails\n",
 		       fs_info->chunk_root->nodesize,
 		       SCRUB_MAX_PAGES_PER_BLOCK,
 		       fs_info->chunk_root->sectorsize,
@@ -3317,8 +3312,7 @@ static int write_page_nocow(struct scrub_ctx *sctx,
 	if (!dev)
 		return -EIO;
 	if (!dev->bdev) {
-		printk_ratelimited(KERN_WARNING
-			"btrfs: scrub write_page_nocow(bdev == NULL) is unexpected!\n");
+		pr_warn_ratelimited("scrub write_page_nocow(bdev == NULL) is unexpected!\n");
 		return -EIO;
 	}
 	bio = btrfs_io_bio_alloc(GFP_NOFS, 1);
diff --git a/fs/btrfs/send.c b/fs/btrfs/send.c
index d3f3b43..922bd28 100644
--- a/fs/btrfs/send.c
+++ b/fs/btrfs/send.c
@@ -16,6 +16,8 @@
  * Boston, MA 021110-1307, USA.
  */
 
+#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
+
 #include <linux/bsearch.h>
 #include <linux/fs.h>
 #include <linux/file.h>
@@ -1272,10 +1274,8 @@ static int find_extent_clone(struct send_ctx *sctx,
 	if (!backref_ctx->found_itself) {
 		/* found a bug in backref code? */
 		ret = -EIO;
-		printk(KERN_ERR "btrfs: ERROR did not find backref in "
-				"send_root. inode=%llu, offset=%llu, "
-				"disk_byte=%llu found extent=%llu\n",
-				ino, data_offset, disk_byte, found_key.objectid);
+		pr_err("ERROR did not find backref in send_root. inode=%llu, offset=%llu, disk_byte=%llu found extent=%llu\n",
+		       ino, data_offset, disk_byte, found_key.objectid);
 		goto out;
 	}
 
@@ -2435,8 +2435,7 @@ verbose_printk("btrfs: send_create_inode %llu\n", ino);
 	} else if (S_ISSOCK(mode)) {
 		cmd = BTRFS_SEND_C_MKSOCK;
 	} else {
-		printk(KERN_WARNING "btrfs: unexpected inode type %o",
-				(int)(mode & S_IFMT));
+		pr_warn("unexpected inode type %o\n", (int)(mode & S_IFMT));
 		ret = -ENOTSUPP;
 		goto out;
 	}
diff --git a/fs/btrfs/super.c b/fs/btrfs/super.c
index 8eb6191..c9aa62f 100644
--- a/fs/btrfs/super.c
+++ b/fs/btrfs/super.c
@@ -16,6 +16,8 @@
  * Boston, MA 021110-1307, USA.
  */
 
+#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
+
 #include <linux/blkdev.h>
 #include <linux/module.h>
 #include <linux/buffer_head.h>
@@ -151,11 +153,11 @@ void __btrfs_std_error(struct btrfs_fs_info *fs_info, const char *function,
 		vaf.fmt = fmt;
 		vaf.va = &args;
 
-		printk(KERN_CRIT "BTRFS error (device %s) in %s:%d: errno=%d %s (%pV)\n",
+		pr_crit("error (device %s) in %s:%d: errno=%d %s (%pV)\n",
 			sb->s_id, function, line, errno, errstr, &vaf);
 		va_end(args);
 	} else {
-		printk(KERN_CRIT "BTRFS error (device %s) in %s:%d: errno=%d %s\n",
+		pr_crit("error (device %s) in %s:%d: errno=%d %s\n",
 			sb->s_id, function, line, errno, errstr);
 	}
 
@@ -293,8 +295,8 @@ void __btrfs_panic(struct btrfs_fs_info *fs_info, const char *function,
 		panic(KERN_CRIT "BTRFS panic (device %s) in %s:%d: %pV (errno=%d %s)\n",
 			s_id, function, line, &vaf, errno, errstr);
 
-	printk(KERN_CRIT "BTRFS panic (device %s) in %s:%d: %pV (errno=%d %s)\n",
-	       s_id, function, line, &vaf, errno, errstr);
+	pr_crit("panic (device %s) in %s:%d: %pV (errno=%d %s)\n",
+		s_id, function, line, &vaf, errno, errstr);
 	va_end(args);
 	/* Caller calls BUG() */
 }
@@ -405,7 +407,7 @@ int btrfs_parse_options(struct btrfs_root *root, char *options)
 		token = match_token(p, tokens, args);
 		switch (token) {
 		case Opt_degraded:
-			printk(KERN_INFO "btrfs: allowing degraded mounts\n");
+			pr_info("allowing degraded mounts\n");
 			btrfs_set_opt(info->mount_opt, DEGRADED);
 			break;
 		case Opt_subvol:
@@ -418,15 +420,15 @@ int btrfs_parse_options(struct btrfs_root *root, char *options)
 			 */
 			break;
 		case Opt_nodatasum:
-			printk(KERN_INFO "btrfs: setting nodatasum\n");
+			pr_info("setting nodatasum\n");
 			btrfs_set_opt(info->mount_opt, NODATASUM);
 			break;
 		case Opt_nodatacow:
 			if (!btrfs_test_opt(root, COMPRESS) ||
 				!btrfs_test_opt(root, FORCE_COMPRESS)) {
-					printk(KERN_INFO "btrfs: setting nodatacow, compression disabled\n");
+				pr_info("setting nodatacow, compression disabled\n");
 			} else {
-				printk(KERN_INFO "btrfs: setting nodatacow\n");
+				pr_info("setting nodatacow\n");
 			}
 			info->compress_type = BTRFS_COMPRESS_NONE;
 			btrfs_clear_opt(info->mount_opt, COMPRESS);
@@ -468,31 +470,28 @@ int btrfs_parse_options(struct btrfs_root *root, char *options)
 
 			if (compress_force) {
 				btrfs_set_opt(info->mount_opt, FORCE_COMPRESS);
-				pr_info("btrfs: force %s compression\n",
+				pr_info("force %s compression\n",
 					compress_type);
 			} else
-				pr_info("btrfs: use %s compression\n",
-					compress_type);
+				pr_info("use %s compression\n", compress_type);
 			break;
 		case Opt_ssd:
-			printk(KERN_INFO "btrfs: use ssd allocation scheme\n");
+			pr_info("use ssd allocation scheme\n");
 			btrfs_set_opt(info->mount_opt, SSD);
 			break;
 		case Opt_ssd_spread:
-			printk(KERN_INFO "btrfs: use spread ssd "
-			       "allocation scheme\n");
+			pr_info("use spread ssd allocation scheme\n");
 			btrfs_set_opt(info->mount_opt, SSD);
 			btrfs_set_opt(info->mount_opt, SSD_SPREAD);
 			break;
 		case Opt_nossd:
-			printk(KERN_INFO "btrfs: not using ssd allocation "
-			       "scheme\n");
+			pr_info("not using ssd allocation scheme\n");
 			btrfs_set_opt(info->mount_opt, NOSSD);
 			btrfs_clear_opt(info->mount_opt, SSD);
 			btrfs_clear_opt(info->mount_opt, SSD_SPREAD);
 			break;
 		case Opt_nobarrier:
-			printk(KERN_INFO "btrfs: turning off barriers\n");
+			pr_info("turning off barriers\n");
 			btrfs_set_opt(info->mount_opt, NOBARRIER);
 			break;
 		case Opt_thread_pool:
@@ -512,7 +511,7 @@ int btrfs_parse_options(struct btrfs_root *root, char *options)
 						info->max_inline,
 						root->sectorsize);
 				}
-				printk(KERN_INFO "btrfs: max_inline at %llu\n",
+				pr_info("max_inline at %llu\n",
 					(unsigned long long)info->max_inline);
 			}
 			break;
@@ -523,8 +522,7 @@ int btrfs_parse_options(struct btrfs_root *root, char *options)
 				info->alloc_start = memparse(num, NULL);
 				mutex_unlock(&info->chunk_mutex);
 				kfree(num);
-				printk(KERN_INFO
-					"btrfs: allocations start at %llu\n",
+				pr_info("allocations start at %llu\n",
 					(unsigned long long)info->alloc_start);
 			}
 			break;
@@ -532,11 +530,11 @@ int btrfs_parse_options(struct btrfs_root *root, char *options)
 			root->fs_info->sb->s_flags &= ~MS_POSIXACL;
 			break;
 		case Opt_notreelog:
-			printk(KERN_INFO "btrfs: disabling tree log\n");
+			pr_info("disabling tree log\n");
 			btrfs_set_opt(info->mount_opt, NOTREELOG);
 			break;
 		case Opt_flushoncommit:
-			printk(KERN_INFO "btrfs: turning on flush-on-commit\n");
+			pr_info("turning on flush-on-commit\n");
 			btrfs_set_opt(info->mount_opt, FLUSHONCOMMIT);
 			break;
 		case Opt_ratio:
@@ -544,8 +542,8 @@ int btrfs_parse_options(struct btrfs_root *root, char *options)
 			match_int(&args[0], &intarg);
 			if (intarg) {
 				info->metadata_ratio = intarg;
-				printk(KERN_INFO "btrfs: metadata ratio %d\n",
-				       info->metadata_ratio);
+				pr_info("metadata ratio %d\n",
+					info->metadata_ratio);
 			}
 			break;
 		case Opt_discard:
@@ -555,15 +553,15 @@ int btrfs_parse_options(struct btrfs_root *root, char *options)
 			btrfs_set_opt(info->mount_opt, SPACE_CACHE);
 			break;
 		case Opt_no_space_cache:
-			printk(KERN_INFO "btrfs: disabling disk space caching\n");
+			pr_info("disabling disk space caching\n");
 			btrfs_clear_opt(info->mount_opt, SPACE_CACHE);
 			break;
 		case Opt_inode_cache:
-			printk(KERN_INFO "btrfs: enabling inode map caching\n");
+			pr_info("enabling inode map caching\n");
 			btrfs_set_opt(info->mount_opt, INODE_MAP_CACHE);
 			break;
 		case Opt_clear_cache:
-			printk(KERN_INFO "btrfs: force clearing of disk cache\n");
+			pr_info("force clearing of disk cache\n");
 			btrfs_set_opt(info->mount_opt, CLEAR_CACHE);
 			break;
 		case Opt_user_subvol_rm_allowed:
@@ -573,11 +571,11 @@ int btrfs_parse_options(struct btrfs_root *root, char *options)
 			btrfs_set_opt(info->mount_opt, ENOSPC_DEBUG);
 			break;
 		case Opt_defrag:
-			printk(KERN_INFO "btrfs: enabling auto defrag\n");
+			pr_info("enabling auto defrag\n");
 			btrfs_set_opt(info->mount_opt, AUTO_DEFRAG);
 			break;
 		case Opt_recovery:
-			printk(KERN_INFO "btrfs: enabling auto recovery\n");
+			pr_info("enabling auto recovery\n");
 			btrfs_set_opt(info->mount_opt, RECOVERY);
 			break;
 		case Opt_skip_balance:
@@ -585,14 +583,13 @@ int btrfs_parse_options(struct btrfs_root *root, char *options)
 			break;
 #ifdef CONFIG_BTRFS_FS_CHECK_INTEGRITY
 		case Opt_check_integrity_including_extent_data:
-			printk(KERN_INFO "btrfs: enabling check integrity"
-			       " including extent data\n");
+			pr_info("enabling check integrity including extent data\n");
 			btrfs_set_opt(info->mount_opt,
 				      CHECK_INTEGRITY_INCLUDING_EXTENT_DATA);
 			btrfs_set_opt(info->mount_opt, CHECK_INTEGRITY);
 			break;
 		case Opt_check_integrity:
-			printk(KERN_INFO "btrfs: enabling check integrity\n");
+			pr_info("enabling check integrity\n");
 			btrfs_set_opt(info->mount_opt, CHECK_INTEGRITY);
 			break;
 		case Opt_check_integrity_print_mask:
@@ -600,17 +597,15 @@ int btrfs_parse_options(struct btrfs_root *root, char *options)
 			match_int(&args[0], &intarg);
 			if (intarg) {
 				info->check_integrity_print_mask = intarg;
-				printk(KERN_INFO "btrfs:"
-				       " check_integrity_print_mask 0x%x\n",
-				       info->check_integrity_print_mask);
+				pr_info("check_integrity_print_mask 0x%x\n",
+					info->check_integrity_print_mask);
 			}
 			break;
 #else
 		case Opt_check_integrity_including_extent_data:
 		case Opt_check_integrity:
 		case Opt_check_integrity_print_mask:
-			printk(KERN_ERR "btrfs: support for check_integrity*"
-			       " not compiled in!\n");
+			pr_err("support for check_integrity* not compiled in!\n");
 			ret = -EINVAL;
 			goto out;
 #endif
@@ -627,8 +622,7 @@ int btrfs_parse_options(struct btrfs_root *root, char *options)
 			}
 			break;
 		case Opt_err:
-			printk(KERN_INFO "btrfs: unrecognized mount option "
-			       "'%s'\n", p);
+			pr_info("unrecognized mount option '%s'\n", p);
 			ret = -EINVAL;
 			goto out;
 		default:
@@ -637,7 +631,7 @@ int btrfs_parse_options(struct btrfs_root *root, char *options)
 	}
 out:
 	if (!ret && btrfs_test_opt(root, SPACE_CACHE))
-		printk(KERN_INFO "btrfs: disk space caching is enabled\n");
+		pr_info("disk space caching is enabled\n");
 	kfree(orig);
 	return ret;
 }
@@ -693,8 +687,7 @@ static int btrfs_parse_early_options(const char *options, fmode_t flags,
 			}
 			break;
 		case Opt_subvolrootid:
-			printk(KERN_WARNING
-				"btrfs: 'subvolrootid' mount option is deprecated and has no effect\n");
+			pr_warn("'subvolrootid' mount option is deprecated and has no effect\n");
 			break;
 		case Opt_device:
 			device_name = match_strdup(&args[0]);
@@ -823,7 +816,7 @@ static int btrfs_fill_super(struct super_block *sb,
 	sb->s_flags |= MS_I_VERSION;
 	err = open_ctree(sb, fs_devices, (char *)data);
 	if (err) {
-		printk("btrfs: open_ctree failed\n");
+		pr_err("open_ctree failed\n");
 		return err;
 	}
 
@@ -1045,8 +1038,7 @@ static struct dentry *mount_subvol(const char *subvol_name, int flags,
 		dput(root);
 		root = ERR_PTR(-EINVAL);
 		deactivate_locked_super(s);
-		printk(KERN_ERR "btrfs: '%s' is not a valid subvolume\n",
-				subvol_name);
+		pr_err("'%s' is not a valid subvolume\n", subvol_name);
 	}
 
 	return root;
@@ -1170,8 +1162,7 @@ static void btrfs_resize_thread_pool(struct btrfs_fs_info *fs_info,
 
 	fs_info->thread_pool_size = new_pool_size;
 
-	printk(KERN_INFO "btrfs: resize thread pool %d -> %d\n",
-	       old_pool_size, new_pool_size);
+	pr_info("resize thread pool %d -> %d\n", old_pool_size, new_pool_size);
 
 	btrfs_set_max_workers(&fs_info->generic_worker, new_pool_size);
 	btrfs_set_max_workers(&fs_info->workers, new_pool_size);
@@ -1276,8 +1267,7 @@ static int btrfs_remount(struct super_block *sb, int *flags, char *data)
 		if (fs_info->fs_devices->missing_devices >
 		     fs_info->num_tolerated_disk_barrier_failures &&
 		    !(*flags & MS_RDONLY)) {
-			printk(KERN_WARNING
-			       "Btrfs: too many missing devices, writeable remount is not allowed\n");
+			pr_warn("too many missing devices, writeable remount is not allowed\n");
 			ret = -EACCES;
 			goto restore;
 		}
@@ -1302,7 +1292,7 @@ static int btrfs_remount(struct super_block *sb, int *flags, char *data)
 
 		ret = btrfs_resume_dev_replace_async(fs_info);
 		if (ret) {
-			pr_warn("btrfs: failed to resume dev_replace\n");
+			pr_warn("failed to resume dev_replace\n");
 			goto restore;
 		}
 		sb->s_flags &= ~MS_RDONLY;
@@ -1681,12 +1671,12 @@ static int btrfs_interface_init(void)
 static void btrfs_interface_exit(void)
 {
 	if (misc_deregister(&btrfs_misc) < 0)
-		printk(KERN_INFO "btrfs: misc_deregister failed for control device\n");
+		pr_info("misc_deregister failed for control device\n");
 }
 
 static void btrfs_print_info(void)
 {
-	printk(KERN_INFO "Btrfs loaded"
+	pr_info("loaded"
 #ifdef CONFIG_BTRFS_DEBUG
 			", debug=on"
 #endif
diff --git a/fs/btrfs/transaction.c b/fs/btrfs/transaction.c
index d58cce7..01e25bf 100644
--- a/fs/btrfs/transaction.c
+++ b/fs/btrfs/transaction.c
@@ -16,6 +16,8 @@
  * Boston, MA 021110-1307, USA.
  */
 
+#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
+
 #include <linux/fs.h>
 #include <linux/slab.h>
 #include <linux/sched.h>
@@ -1928,8 +1930,7 @@ int btrfs_clean_one_deleted_snapshot(struct btrfs_root *root)
 	list_del(&root->root_list);
 	spin_unlock(&fs_info->trans_lock);
 
-	pr_debug("btrfs: cleaner removing %llu\n",
-			(unsigned long long)root->objectid);
+	pr_debug("cleaner removing %llu\n", (unsigned long long)root->objectid);
 
 	btrfs_kill_all_delayed_nodes(root);
 
diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
index 78b8717..1f564db 100644
--- a/fs/btrfs/volumes.c
+++ b/fs/btrfs/volumes.c
@@ -15,6 +15,9 @@
  * Free Software Foundation, Inc., 59 Temple Place - Suite 330,
  * Boston, MA 021110-1307, USA.
  */
+
+#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
+
 #include <linux/sched.h>
 #include <linux/bio.h>
 #include <linux/slab.h>
@@ -137,7 +140,7 @@ btrfs_get_bdev_and_sb(const char *device_path, fmode_t flags, void *holder,
 
 	if (IS_ERR(*bdev)) {
 		ret = PTR_ERR(*bdev);
-		printk(KERN_INFO "btrfs: open %s failed\n", device_path);
+		pr_info("open %s failed\n", device_path);
 		goto error;
 	}
 
@@ -875,13 +878,13 @@ int btrfs_scan_one_device(const char *path, fmode_t flags, void *holder,
 	if (disk_super->label[0]) {
 		if (disk_super->label[BTRFS_LABEL_SIZE - 1])
 			disk_super->label[BTRFS_LABEL_SIZE - 1] = '\0';
-		printk(KERN_INFO "device label %s ", disk_super->label);
+		pr_info("device label %s ", disk_super->label);
 	} else {
-		printk(KERN_INFO "device fsid %pU ", disk_super->fsid);
+		pr_info("device fsid %pU ", disk_super->fsid);
 	}
 
-	printk(KERN_CONT "devid %llu transid %llu %s\n",
-	       (unsigned long long)devid, (unsigned long long)transid, path);
+	pr_cont("devid %llu transid %llu %s\n",
+		(unsigned long long)devid, (unsigned long long)transid, path);
 
 	ret = device_list_add(path, disk_super, devid, fs_devices_ret);
 	if (!ret && fs_devices_ret)
@@ -1767,7 +1770,7 @@ int btrfs_find_device_missing_or_by_path(struct btrfs_root *root,
 		}
 
 		if (!*device) {
-			pr_err("btrfs: no missing device found\n");
+			pr_err("no missing device found\n");
 			return -ENOENT;
 		}
 
@@ -3021,8 +3024,7 @@ loop:
 error:
 	btrfs_free_path(path);
 	if (enospc_errors) {
-		printk(KERN_INFO "btrfs: %d enospc errors during balance\n",
-		       enospc_errors);
+		pr_info("%d enospc errors during balance\n", enospc_errors);
 		if (!ret)
 			ret = -ENOSPC;
 	}
@@ -3110,8 +3112,7 @@ int btrfs_balance(struct btrfs_balance_control *bctl,
 		if (!(bctl->flags & BTRFS_BALANCE_DATA) ||
 		    !(bctl->flags & BTRFS_BALANCE_METADATA) ||
 		    memcmp(&bctl->data, &bctl->meta, sizeof(bctl->data))) {
-			printk(KERN_ERR "btrfs: with mixed groups data and "
-			       "metadata balance options must be the same\n");
+			pr_err("with mixed groups, data and metadata balance options must be the same\n");
 			ret = -EINVAL;
 			goto out;
 		}
@@ -3137,8 +3138,7 @@ int btrfs_balance(struct btrfs_balance_control *bctl,
 	if ((bctl->data.flags & BTRFS_BALANCE_ARGS_CONVERT) &&
 	    (!alloc_profile_is_valid(bctl->data.target, 1) ||
 	     (bctl->data.target & ~allowed))) {
-		printk(KERN_ERR "btrfs: unable to start balance with target "
-		       "data profile %llu\n",
+		pr_err("unable to start balance with target data profile %llu\n",
 		       (unsigned long long)bctl->data.target);
 		ret = -EINVAL;
 		goto out;
@@ -3146,8 +3146,7 @@ int btrfs_balance(struct btrfs_balance_control *bctl,
 	if ((bctl->meta.flags & BTRFS_BALANCE_ARGS_CONVERT) &&
 	    (!alloc_profile_is_valid(bctl->meta.target, 1) ||
 	     (bctl->meta.target & ~allowed))) {
-		printk(KERN_ERR "btrfs: unable to start balance with target "
-		       "metadata profile %llu\n",
+		pr_err("unable to start balance with target metadata profile %llu\n",
 		       (unsigned long long)bctl->meta.target);
 		ret = -EINVAL;
 		goto out;
@@ -3155,8 +3154,7 @@ int btrfs_balance(struct btrfs_balance_control *bctl,
 	if ((bctl->sys.flags & BTRFS_BALANCE_ARGS_CONVERT) &&
 	    (!alloc_profile_is_valid(bctl->sys.target, 1) ||
 	     (bctl->sys.target & ~allowed))) {
-		printk(KERN_ERR "btrfs: unable to start balance with target "
-		       "system profile %llu\n",
+		pr_err("unable to start balance with target system profile %llu\n",
 		       (unsigned long long)bctl->sys.target);
 		ret = -EINVAL;
 		goto out;
@@ -3165,7 +3163,7 @@ int btrfs_balance(struct btrfs_balance_control *bctl,
 	/* allow dup'ed data chunks only in mixed mode */
 	if (!mixed && (bctl->data.flags & BTRFS_BALANCE_ARGS_CONVERT) &&
 	    (bctl->data.target & BTRFS_BLOCK_GROUP_DUP)) {
-		printk(KERN_ERR "btrfs: dup for data is not allowed\n");
+		pr_err("dup for data is not allowed\n");
 		ret = -EINVAL;
 		goto out;
 	}
@@ -3185,11 +3183,9 @@ int btrfs_balance(struct btrfs_balance_control *bctl,
 		     (fs_info->avail_metadata_alloc_bits & allowed) &&
 		     !(bctl->meta.target & allowed))) {
 			if (bctl->flags & BTRFS_BALANCE_FORCE) {
-				printk(KERN_INFO "btrfs: force reducing metadata "
-				       "integrity\n");
+				pr_info("force reducing metadata integrity\n");
 			} else {
-				printk(KERN_ERR "btrfs: balance will reduce metadata "
-				       "integrity, use force if you want this\n");
+				pr_err("balance will reduce metadata integrity, use force if you want this\n");
 				ret = -EINVAL;
 				goto out;
 			}
@@ -3275,7 +3271,7 @@ static int balance_kthread(void *data)
 	mutex_lock(&fs_info->balance_mutex);
 
 	if (fs_info->balance_ctl) {
-		printk(KERN_INFO "btrfs: continuing balance\n");
+		pr_info("continuing balance\n");
 		ret = btrfs_balance(fs_info->balance_ctl, NULL);
 	}
 
@@ -3297,7 +3293,7 @@ int btrfs_resume_balance_async(struct btrfs_fs_info *fs_info)
 	spin_unlock(&fs_info->balance_lock);
 
 	if (btrfs_test_opt(fs_info->tree_root, SKIP_BALANCE)) {
-		printk(KERN_INFO "btrfs: force skipping balance\n");
+		pr_info("force skipping balance\n");
 		return 0;
 	}
 
@@ -3744,8 +3740,7 @@ static int __btrfs_alloc_chunk(struct btrfs_trans_handle *trans,
 		max_stripe_size = 32 * 1024 * 1024;
 		max_chunk_size = 2 * max_stripe_size;
 	} else {
-		printk(KERN_ERR "btrfs: invalid chunk type 0x%llx requested\n",
-		       type);
+		pr_err("invalid chunk type 0x%llx requested\n", type);
 		BUG_ON(1);
 	}
 
@@ -4902,13 +4897,12 @@ int btrfs_rmap_block(struct btrfs_mapping_tree *map_tree,
 	read_unlock(&em_tree->lock);
 
 	if (!em) {
-		printk(KERN_ERR "btrfs: couldn't find em for chunk %Lu\n",
-		       chunk_start);
+		pr_err("couldn't find em for chunk %llu\n", chunk_start);
 		return -EIO;
 	}
 
 	if (em->start != chunk_start) {
-		printk(KERN_ERR "btrfs: bad chunk start, em=%Lu, wanted=%Lu\n",
+		pr_err("bad chunk start, em=%llu, wanted=%llu\n",
 		       em->start, chunk_start);
 		free_extent_map(em);
 		return -EIO;
@@ -5919,12 +5913,10 @@ int btrfs_get_dev_stats(struct btrfs_root *root,
 	mutex_unlock(&fs_devices->device_list_mutex);
 
 	if (!dev) {
-		printk(KERN_WARNING
-		       "btrfs: get dev_stats failed, device not found\n");
+		pr_warn("get dev_stats failed, device not found\n");
 		return -ENODEV;
 	} else if (!dev->dev_stats_valid) {
-		printk(KERN_WARNING
-		       "btrfs: get dev_stats failed, not yet valid\n");
+		pr_warn("get dev_stats failed, not yet valid\n");
 		return -ENODEV;
 	} else if (stats->flags & BTRFS_DEV_STATS_RESET) {
 		for (i = 0; i < BTRFS_DEV_STAT_VALUES_MAX; i++) {
diff --git a/fs/btrfs/zlib.c b/fs/btrfs/zlib.c
index 9acb846..b14486f 100644
--- a/fs/btrfs/zlib.c
+++ b/fs/btrfs/zlib.c
@@ -20,6 +20,8 @@
  * Created by David Woodhouse <dwmw2@infradead.org>
  */
 
+#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
+
 #include <linux/kernel.h>
 #include <linux/slab.h>
 #include <linux/zlib.h>
@@ -97,7 +99,7 @@ static int zlib_compress_pages(struct list_head *ws,
 	*total_in = 0;
 
 	if (Z_OK != zlib_deflateInit(&workspace->def_strm, 3)) {
-		printk(KERN_WARNING "btrfs: deflateInit failed\n");
+		pr_warn("deflateInit failed\n");
 		ret = -1;
 		goto out;
 	}
@@ -252,7 +254,7 @@ static int zlib_decompress_biovec(struct list_head *ws, struct page **pages_in,
 	}
 
 	if (Z_OK != zlib_inflateInit2(&workspace->inf_strm, wbits)) {
-		printk(KERN_WARNING "btrfs: inflateInit failed\n");
+		pr_warn("inflateInit failed\n");
 		return -1;
 	}
 	while (workspace->inf_strm.total_in < srclen) {
@@ -336,7 +338,7 @@ static int zlib_decompress(struct list_head *ws, unsigned char *data_in,
 	}
 
 	if (Z_OK != zlib_inflateInit2(&workspace->inf_strm, wbits)) {
-		printk(KERN_WARNING "btrfs: inflateInit failed\n");
+		pr_warn("inflateInit failed\n");
 		return -1;
 	}
 


