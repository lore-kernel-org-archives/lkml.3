Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752947Ab3IPHIw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Sep 2013 03:08:52 -0400
Received: from lgeamrelo02.lge.com ([156.147.1.126]:46749 "EHLO
	LGEAMRELO02.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750828Ab3IPHIu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Sep 2013 03:08:50 -0400
X-AuditID: 9c93017e-b7b60ae000007051-35-5236ae816614
From: Minchan Kim <minchan@kernel.org>
To: Phillip Lougher <phillip@squashfs.org.uk>
Cc: linux-kernel@vger.kernel.org, ch0.han@lge.com, gunho.lee@lge.com,
        Minchan Kim <minchan@kernel.org>
Subject: [RFC 1/5] squashfs: clean up squashfs_read_data
Date: Mon, 16 Sep 2013 16:08:35 +0900
Message-Id: <1379315319-7752-2-git-send-email-minchan@kernel.org>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1379315319-7752-1-git-send-email-minchan@kernel.org>
References: <1379315319-7752-1-git-send-email-minchan@kernel.org>
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The squashfs_read_data functions has a role to read a block and
decompress for datablock and metadata.
This patch cleans it up so it has squashfs_read_datablock and
squashfs_meta_datablock and morever, squashfs_read_datablock
has two part, one is just request I/O and other part is decompress.

Such clean up is useful for code readability and supporting
readpages.

Signed-off-by: Minchan Kim <minchan@kernel.org>
---
 fs/squashfs/block.c        |  244 +++++++++++++++++++++++++++++---------------
 fs/squashfs/cache.c        |   16 ++-
 fs/squashfs/decompressor.c |    2 +-
 fs/squashfs/squashfs.h     |    6 +-
 4 files changed, 176 insertions(+), 92 deletions(-)

diff --git a/fs/squashfs/block.c b/fs/squashfs/block.c
index 41d108e..f33c6ef 100644
--- a/fs/squashfs/block.c
+++ b/fs/squashfs/block.c
@@ -77,99 +77,25 @@ static struct buffer_head *get_block_length(struct super_block *sb,
 }
 
 
-/*
- * Read and decompress a metadata block or datablock.  Length is non-zero
- * if a datablock is being read (the size is stored elsewhere in the
- * filesystem), otherwise the length is obtained from the first two bytes of
- * the metadata block.  A bit in the length field indicates if the block
- * is stored uncompressed in the filesystem (usually because compression
- * generated a larger block - this does occasionally happen with compression
- * algorithms).
- */
-int squashfs_read_data(struct super_block *sb, void **buffer, u64 index,
-			int length, u64 *next_index, int srclength, int pages)
-{
-	struct squashfs_sb_info *msblk = sb->s_fs_info;
-	struct buffer_head **bh;
-	int offset = index & ((1 << msblk->devblksize_log2) - 1);
-	u64 cur_index = index >> msblk->devblksize_log2;
-	int bytes, compressed, b = 0, k = 0, page = 0, avail;
-
-	bh = kcalloc(((srclength + msblk->devblksize - 1)
-		>> msblk->devblksize_log2) + 1, sizeof(*bh), GFP_KERNEL);
-	if (bh == NULL)
-		return -ENOMEM;
-
-	if (length) {
-		/*
-		 * Datablock.
-		 */
-		bytes = -offset;
-		compressed = SQUASHFS_COMPRESSED_BLOCK(length);
-		length = SQUASHFS_COMPRESSED_SIZE_BLOCK(length);
-		if (next_index)
-			*next_index = index + length;
-
-		TRACE("Block @ 0x%llx, %scompressed size %d, src size %d\n",
-			index, compressed ? "" : "un", length, srclength);
-
-		if (length < 0 || length > srclength ||
-				(index + length) > msblk->bytes_used)
-			goto read_failure;
-
-		for (b = 0; bytes < length; b++, cur_index++) {
-			bh[b] = sb_getblk(sb, cur_index);
-			if (bh[b] == NULL)
-				goto block_release;
-			bytes += msblk->devblksize;
-		}
-		ll_rw_block(READ, b, bh);
-	} else {
-		/*
-		 * Metadata block.
-		 */
-		if ((index + 2) > msblk->bytes_used)
-			goto read_failure;
-
-		bh[0] = get_block_length(sb, &cur_index, &offset, &length);
-		if (bh[0] == NULL)
-			goto read_failure;
-		b = 1;
-
-		bytes = msblk->devblksize - offset;
-		compressed = SQUASHFS_COMPRESSED(length);
-		length = SQUASHFS_COMPRESSED_SIZE(length);
-		if (next_index)
-			*next_index = index + length + 2;
-
-		TRACE("Block @ 0x%llx, %scompressed size %d\n", index,
-				compressed ? "" : "un", length);
 
-		if (length < 0 || length > srclength ||
-					(index + length) > msblk->bytes_used)
-			goto block_release;
-
-		for (; bytes < length; b++) {
-			bh[b] = sb_getblk(sb, ++cur_index);
-			if (bh[b] == NULL)
-				goto block_release;
-			bytes += msblk->devblksize;
-		}
-		ll_rw_block(READ, b - 1, bh + 1);
-	}
+int squashfs_decompress_block(struct squashfs_sb_info *msblk, int compressed,
+		void **buffer, struct buffer_head **bh, int nr_bh,
+		int offset, int length, int srclength, int pages)
+{
+	int k = 0;
 
 	if (compressed) {
-		length = squashfs_decompress(msblk, buffer, bh, b, offset,
-			 length, srclength, pages);
+		length = squashfs_decompress(msblk, buffer, bh, nr_bh,
+				offset, length, srclength, pages);
 		if (length < 0)
-			goto read_failure;
+			goto out;
 	} else {
 		/*
 		 * Block is uncompressed.
 		 */
-		int in, pg_offset = 0;
+		int bytes, in, avail, pg_offset = 0, page = 0;
 
-		for (bytes = length; k < b; k++) {
+		for (bytes = length; k < nr_bh; k++) {
 			in = min(bytes, msblk->devblksize - offset);
 			bytes -= in;
 			wait_on_buffer(bh[k]);
@@ -193,6 +119,154 @@ int squashfs_read_data(struct super_block *sb, void **buffer, u64 index,
 		}
 	}
 
+	return length;
+
+block_release:
+	for (; k < nr_bh; k++)
+		put_bh(bh[k]);
+out:
+	return length;
+}
+
+int squashfs_read_submit(struct super_block *sb, u64 index, int length,
+			int srclength, struct buffer_head **bh, int *nr_bh)
+{
+	struct squashfs_sb_info *msblk = sb->s_fs_info;
+	int offset = index & ((1 << msblk->devblksize_log2) - 1);
+	u64 cur_index = index >> msblk->devblksize_log2;
+	int bytes, b = 0, k = 0;
+
+	bytes = -offset;
+	if (length < 0 || length > srclength ||
+			(index + length) > msblk->bytes_used)
+		goto read_failure;
+
+	for (b = 0; bytes < length; b++, cur_index++) {
+		bh[b] = sb_getblk(sb, cur_index);
+		if (bh[b] == NULL)
+			goto block_release;
+		bytes += msblk->devblksize;
+	}
+
+	ll_rw_block(READ, b, bh);
+	*nr_bh = b;
+	return 0;
+
+block_release:
+	for (; k < b; k++)
+		put_bh(bh[k]);
+
+read_failure:
+	ERROR("squashfs_read_submit failed to read block 0x%llx\n",
+					(unsigned long long) index);
+	return -EIO;
+}
+
+/*
+ * Read and decompress a datablock. @length should be non-zero(the size is
+ * stored elsewhere in the filesystem). A bit in the length field indicates
+ * if the block is stored uncompressed in the filesystem (usually because
+ * compression generated a larger block - this does occasionally happen with
+ * compression algorithms).
+ */
+int squashfs_read_datablock(struct super_block *sb, void **buffer, u64 index,
+			int length, int srclength, int pages)
+{
+	struct squashfs_sb_info *msblk = sb->s_fs_info;
+	struct buffer_head **bh;
+	int offset = index & ((1 << msblk->devblksize_log2) - 1);
+	int compressed, ret, b = 0;
+
+	BUG_ON(!length);
+
+	bh = kcalloc(((srclength + msblk->devblksize - 1)
+		>> msblk->devblksize_log2) + 1, sizeof(*bh), GFP_KERNEL);
+	if (bh == NULL)
+		return -ENOMEM;
+
+	compressed = SQUASHFS_COMPRESSED_BLOCK(length);
+	length = SQUASHFS_COMPRESSED_SIZE_BLOCK(length);
+
+	ret = squashfs_read_submit(sb, index, length, srclength, bh, &b);
+	if (ret < 0) {
+		kfree(bh);
+		return ret;
+	}
+
+
+	TRACE("Data block @ 0x%llx, %scompressed size %d, src size %d\n",
+		index, compressed ? "" : "un", length, srclength);
+
+	length = squashfs_decompress_block(sb, compressed, buffer, bh,
+				b, offset, length, srclength, pages);
+	if (length < 0) {
+		ERROR("squashfs_read_datablock failed to read block 0x%llx\n",
+					(unsigned long long) index);
+		kfree(bh);
+		return -EIO;
+	}
+
+	kfree(bh);
+	return length;
+}
+
+/*
+ * Read and decompress a metadata block. @length is obtained from the first
+ * two bytes of the metadata block.  A bit in the length field indicates if
+ * the block is stored uncompressed in the filesystem (usually because
+ * compression generated a larger block - this does occasionally happen with
+ * compression algorithms).
+ */
+int squashfs_read_metablock(struct super_block *sb, void **buffer, u64 index,
+			int length, u64 *next_index, int srclength, int pages)
+{
+	struct squashfs_sb_info *msblk = sb->s_fs_info;
+	struct buffer_head **bh;
+	int offset = index & ((1 << msblk->devblksize_log2) - 1);
+	u64 cur_index = index >> msblk->devblksize_log2;
+	int bytes, compressed, b = 0, k = 0;
+
+	BUG_ON(length);
+
+	bh = kcalloc(((srclength + msblk->devblksize - 1)
+		>> msblk->devblksize_log2) + 1, sizeof(*bh), GFP_KERNEL);
+	if (bh == NULL)
+		return -ENOMEM;
+
+	if ((index + 2) > msblk->bytes_used)
+		goto read_failure;
+
+	bh[0] = get_block_length(sb, &cur_index, &offset, &length);
+	if (bh[0] == NULL)
+		goto read_failure;
+	b = 1;
+
+	bytes = msblk->devblksize - offset;
+	compressed = SQUASHFS_COMPRESSED(length);
+	length = SQUASHFS_COMPRESSED_SIZE(length);
+	if (next_index)
+		*next_index = index + length + 2;
+
+	TRACE("Meta block @ 0x%llx, %scompressed size %d\n", index,
+			compressed ? "" : "un", length);
+
+	if (length < 0 || length > srclength ||
+				(index + length) > msblk->bytes_used)
+		goto block_release;
+
+	for (; bytes < length; b++) {
+		bh[b] = sb_getblk(sb, ++cur_index);
+		if (bh[b] == NULL)
+			goto block_release;
+		bytes += msblk->devblksize;
+	}
+	ll_rw_block(READ, b - 1, bh + 1);
+
+	length = squashfs_decompress_block(msblk, compressed, buffer, bh, b,
+				offset, length, srclength, pages);
+	if (length < 0)
+		goto read_failure;
+
 	kfree(bh);
 	return length;
 
@@ -201,7 +275,7 @@ block_release:
 		put_bh(bh[k]);
 
 read_failure:
-	ERROR("squashfs_read_data failed to read block 0x%llx\n",
+	ERROR("squashfs_read_metablock failed to read block 0x%llx\n",
 					(unsigned long long) index);
 	kfree(bh);
 	return -EIO;
diff --git a/fs/squashfs/cache.c b/fs/squashfs/cache.c
index af0b738..6e6a616 100644
--- a/fs/squashfs/cache.c
+++ b/fs/squashfs/cache.c
@@ -119,9 +119,15 @@ struct squashfs_cache_entry *squashfs_cache_get(struct super_block *sb,
 			entry->error = 0;
 			spin_unlock(&cache->lock);
 
-			entry->length = squashfs_read_data(sb, entry->data,
-				block, length, &entry->next_index,
-				cache->block_size, cache->pages);
+			if (length)
+				entry->length = squashfs_read_datablock(sb,
+					entry->data, block, length,
+					cache->block_size, cache->pages);
+			else
+				entry->length = squashfs_read_metablock(sb,
+					entry->data, block, length,
+					&entry->next_index, cache->block_size,
+					cache->pages);
 
 			spin_lock(&cache->lock);
 
@@ -424,8 +430,8 @@ void *squashfs_read_table(struct super_block *sb, u64 block, int length)
 	for (i = 0; i < pages; i++, buffer += PAGE_CACHE_SIZE)
 		data[i] = buffer;
 
-	res = squashfs_read_data(sb, data, block, length |
-		SQUASHFS_COMPRESSED_BIT_BLOCK, NULL, length, pages);
+	res = squashfs_read_datablock(sb, data, block, length |
+		SQUASHFS_COMPRESSED_BIT_BLOCK, length, pages);
 
 	kfree(data);
 
diff --git a/fs/squashfs/decompressor.c b/fs/squashfs/decompressor.c
index 3f6271d..e47453e 100644
--- a/fs/squashfs/decompressor.c
+++ b/fs/squashfs/decompressor.c
@@ -97,7 +97,7 @@ void *squashfs_decompressor_init(struct super_block *sb, unsigned short flags)
 		if (buffer == NULL)
 			return ERR_PTR(-ENOMEM);
 
-		length = squashfs_read_data(sb, &buffer,
+		length = squashfs_read_metablock(sb, &buffer,
 			sizeof(struct squashfs_super_block), 0, NULL,
 			PAGE_CACHE_SIZE, 1);
 
diff --git a/fs/squashfs/squashfs.h b/fs/squashfs/squashfs.h
index d126651..405baed 100644
--- a/fs/squashfs/squashfs.h
+++ b/fs/squashfs/squashfs.h
@@ -28,8 +28,12 @@
 #define WARNING(s, args...)	pr_warning("SQUASHFS: "s, ## args)
 
 /* block.c */
-extern int squashfs_read_data(struct super_block *, void **, u64, int, u64 *,
+extern int squashfs_read_datablock(struct super_block *, void **, u64, int,
 				int, int);
+extern int squashfs_read_metablock(struct super_block *, void **, u64, int,
+				u64 *, int, int);
+extern int squashfs_read_submit(struct super_block *, u64, int, int,
+				struct buffer_head **, int *);
 
 /* cache.c */
 extern struct squashfs_cache *squashfs_cache_init(char *, int, int);
-- 
1.7.9.5

