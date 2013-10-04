Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751166Ab3JDGJF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Oct 2013 02:09:05 -0400
Received: from mdfmta005.mxout.tch.inty.net ([91.221.169.46]:56524 "EHLO
	smtp.demon.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750728Ab3JDGJD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Oct 2013 02:09:03 -0400
Message-ID: <524E5B7A.4020909@lougher.demon.co.uk>
Date: Fri, 04 Oct 2013 07:08:58 +0100
From: Phillip Lougher <phillip@lougher.demon.co.uk>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130704 Icedove/17.0.7
MIME-Version: 1.0
To: minchan@kernel.org, linux-kernel@vger.kernel.org
CC: ch0.han@lge.com, gunho.lee@lge.com
Subject: re: [RFC,1/5] squashfs: clean up squashfs_read_data
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-MDF-HostID: 18
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Minchan Kim <minchan@kernel.org> wrote:
>The squashfs_read_data functions has a role to read a block and
>decompress for datablock and metadata.
>This patch cleans it up so it has squashfs_read_datablock and
>squashfs_meta_datablock and morever, squashfs_read_datablock
>has two part, one is just request I/O and other part is decompress.

I see the rationale for what you're doing here.  But I have the
horrible sense of breakage.

Your patch changes the one entry point into block.c, into four
functions:

We had:

squashfs_read_data() -- generic entry point into block.c to read blocks

We now have:

squashfs_read_metablock() -- read "metadata" block
squashfs_read_datablock() -- read "datablock"

and two functions which expose internal implementation, which were
once private

squashfs_read_submit() -- submit buffer head I/O
squashfs_decompress_block() -- decompress block after squashfs_read_submit

Both exposing internal implementation of squashfs_read_datablock()

You say:

"This patch cleans it up so it has squashfs_read_datablock and
squashfs_meta_datablock and morever, squashfs_read_datablock
has two part, one is just request I/O and other part is decompress.

Such clean up is useful for code readability and supporting
readpages."

But the fact is you've done this simply because you need to expose
internal implementation in block.c for your readpages implementation.
Don't pretend to make a virtue out of this.  Leave such PR
stunts for the marketing people.

Additionally separating squashfs_read_data() into

squashfs_read_metablock() -- read "metadata" block
squashfs_read_datablock() -- read "datablock"

from a Squashfs filesystem point of view is bogus.
Calling a block with length prepended a "metadata" block, and a block
with length stored elsewhere a "datablock" which your patch does,
is a misunderstanding of the Squashfs filesystem design.

There is simply one criteria which determines whether "a block
with length prepended" or a "block with length stored elsewhere"
is used to store either data or metadata, and it is how many entries
reference it.  The length field has to go somewhere, and if multiple
entries reference a block it makes sense to store the length
with the block, this saves space with respect to the other
alternative which is to store the length with the reference.  If we
had a 1000 references to a block,  storing the length prepended
to the block saves 1000 * 4 bytes as opposed to the alternative
of storing the length with each reference.

Now if we know we're only likely to have one reference to a block it
makes sense to store the length elsewhere, as this removes the
I/O stall when reading blocks with the length prepended (we have to
wait for the I/O for the block with the length in it to finish before
we can read the other blocks).

It just happens that the majority of metadata blocks end up with multiple
references to them, and datablocks end up with one reference to them.
But there are exceptions, namely with "squashfs tables", these are
metadata blocks, but which are stored with no prepended length,
because there is only one reference, and it's easier to compute
the length from data stored elsewhere.

So with your patch you have the *horribleness* of squashfs_read_table()
calling squashfs_read_datablock() to read metadata!

In summary, your patch here is simply to expose implementation
for your readpages implementation.

This patch adds 84 lines to expose the internals.  A quick count of
the submit code, and the decompress code is ~50 lines.  So why muck
about messing up the interface to block.c for the sake of
exposing a couple of internal functions?

Just add a specialised implementation of squashfs_read_submit() and
squashfs_decompress_block() to say block_readpages.c, and leave
block.c alone.  That way we additionally only get to
compile it if and only if readpages support is configured.

>---
>fs/squashfs/block.c        |  244 +++++++++++++++++++++++++++++---------------
> fs/squashfs/cache.c        |   16 ++-
> fs/squashfs/decompressor.c |    2 +-
> fs/squashfs/squashfs.h     |    6 +-
> 4 files changed, 176 insertions(+), 92 deletions(-)
>
>diff --git a/fs/squashfs/block.c b/fs/squashfs/block.c
>index 41d108e..f33c6ef 100644
>--- a/fs/squashfs/block.c
>+++ b/fs/squashfs/block.c
>@@ -77,99 +77,25 @@ static struct buffer_head *get_block_length(struct super_block *sb,
> }
>
>
>-/*
>- * Read and decompress a metadata block or datablock.  Length is non-zero
>- * if a datablock is being read (the size is stored elsewhere in the
>- * filesystem), otherwise the length is obtained from the first two bytes of
>- * the metadata block.  A bit in the length field indicates if the block
>- * is stored uncompressed in the filesystem (usually because compression
>- * generated a larger block - this does occasionally happen with compression
>- * algorithms).
>- */
>-int squashfs_read_data(struct super_block *sb, void **buffer, u64 index,
>-			int length, u64 *next_index, int srclength, int pages)
>-{
>-	struct squashfs_sb_info *msblk = sb->s_fs_info;
>-	struct buffer_head **bh;
>-	int offset = index & ((1 << msblk->devblksize_log2) - 1);
>-	u64 cur_index = index >> msblk->devblksize_log2;
>-	int bytes, compressed, b = 0, k = 0, page = 0, avail;
>-
>-	bh = kcalloc(((srclength + msblk->devblksize - 1)
>-		>> msblk->devblksize_log2) + 1, sizeof(*bh), GFP_KERNEL);
>-	if (bh == NULL)
>-		return -ENOMEM;
>-
>-	if (length) {
>-		/*
>-		 * Datablock.
>-		 */
>-		bytes = -offset;
>-		compressed = SQUASHFS_COMPRESSED_BLOCK(length);
>-		length = SQUASHFS_COMPRESSED_SIZE_BLOCK(length);
>-		if (next_index)
>-			*next_index = index + length;
>-
>-		TRACE("Block @ 0x%llx, %scompressed size %d, src size %d\n",
>-			index, compressed ? "" : "un", length, srclength);
>-
>-		if (length < 0 || length > srclength ||
>-				(index + length) > msblk->bytes_used)
>-			goto read_failure;
>-
>-		for (b = 0; bytes < length; b++, cur_index++) {
>-			bh[b] = sb_getblk(sb, cur_index);
>-			if (bh[b] == NULL)
>-				goto block_release;
>-			bytes += msblk->devblksize;
>-		}
>-		ll_rw_block(READ, b, bh);
>-	} else {
>-		/*
>-		 * Metadata block.
>-		 */
>-		if ((index + 2) > msblk->bytes_used)
>-			goto read_failure;
>-
>-		bh[0] = get_block_length(sb, &cur_index, &offset, &length);
>-		if (bh[0] == NULL)
>-			goto read_failure;
>-		b = 1;
>-
>-		bytes = msblk->devblksize - offset;
>-		compressed = SQUASHFS_COMPRESSED(length);
>-		length = SQUASHFS_COMPRESSED_SIZE(length);
>-		if (next_index)
>-			*next_index = index + length + 2;
>-
>-		TRACE("Block @ 0x%llx, %scompressed size %d\n", index,
>-				compressed ? "" : "un", length);
>
>-		if (length < 0 || length > srclength ||
>-					(index + length) > msblk->bytes_used)
>-			goto block_release;
>-
>-		for (; bytes < length; b++) {
>-			bh[b] = sb_getblk(sb, ++cur_index);
>-			if (bh[b] == NULL)
>-				goto block_release;
>-			bytes += msblk->devblksize;
>-		}
>-		ll_rw_block(READ, b - 1, bh + 1);
>-	}
>+int squashfs_decompress_block(struct squashfs_sb_info *msblk, int compressed,
>+		void **buffer, struct buffer_head **bh, int nr_bh,
>+		int offset, int length, int srclength, int pages)
>+{
>+	int k = 0;
>
> 	if (compressed) {
>-		length = squashfs_decompress(msblk, buffer, bh, b, offset,
>-			 length, srclength, pages);
>+		length = squashfs_decompress(msblk, buffer, bh, nr_bh,
>+				offset, length, srclength, pages);
> 		if (length < 0)
>-			goto read_failure;
>+			goto out;
> 	} else {
> 		/*
> 		 * Block is uncompressed.
> 		 */
>-		int in, pg_offset = 0;
>+		int bytes, in, avail, pg_offset = 0, page = 0;
>
>-		for (bytes = length; k < b; k++) {
>+		for (bytes = length; k < nr_bh; k++) {
> 			in = min(bytes, msblk->devblksize - offset);
> 			bytes -= in;
> 			wait_on_buffer(bh[k]);
>@@ -193,6 +119,154 @@ int squashfs_read_data(struct super_block *sb, void **buffer, u64 index,
> 		}
> 	}
>
>+	return length;
>+
>+block_release:
>+	for (; k < nr_bh; k++)
>+		put_bh(bh[k]);
>+out:
>+	return length;
>+}
>+
>+int squashfs_read_submit(struct super_block *sb, u64 index, int length,
>+			int srclength, struct buffer_head **bh, int *nr_bh)
>+{
>+	struct squashfs_sb_info *msblk = sb->s_fs_info;
>+	int offset = index & ((1 << msblk->devblksize_log2) - 1);
>+	u64 cur_index = index >> msblk->devblksize_log2;
>+	int bytes, b = 0, k = 0;
>+
>+	bytes = -offset;
>+	if (length < 0 || length > srclength ||
>+			(index + length) > msblk->bytes_used)
>+		goto read_failure;
>+
>+	for (b = 0; bytes < length; b++, cur_index++) {
>+		bh[b] = sb_getblk(sb, cur_index);
>+		if (bh[b] == NULL)
>+			goto block_release;
>+		bytes += msblk->devblksize;
>+	}
>+
>+	ll_rw_block(READ, b, bh);
>+	*nr_bh = b;
>+	return 0;
>+
>+block_release:
>+	for (; k < b; k++)
>+		put_bh(bh[k]);
>+
>+read_failure:
>+	ERROR("squashfs_read_submit failed to read block 0x%llx\n",
>+					(unsigned long long) index);
>+	return -EIO;
>+}
>+
>+/*
>+ * Read and decompress a datablock. @length should be non-zero(the size is
>+ * stored elsewhere in the filesystem). A bit in the length field indicates
>+ * if the block is stored uncompressed in the filesystem (usually because
>+ * compression generated a larger block - this does occasionally happen with
>+ * compression algorithms).
>+ */
>+int squashfs_read_datablock(struct super_block *sb, void **buffer, u64 index,
>+			int length, int srclength, int pages)
>+{
>+	struct squashfs_sb_info *msblk = sb->s_fs_info;
>+	struct buffer_head **bh;
>+	int offset = index & ((1 << msblk->devblksize_log2) - 1);
>+	int compressed, ret, b = 0;
>+
>+	BUG_ON(!length);
>+
>+	bh = kcalloc(((srclength + msblk->devblksize - 1)
>+		>> msblk->devblksize_log2) + 1, sizeof(*bh), GFP_KERNEL);
>+	if (bh == NULL)
>+		return -ENOMEM;
>+
>+	compressed = SQUASHFS_COMPRESSED_BLOCK(length);
>+	length = SQUASHFS_COMPRESSED_SIZE_BLOCK(length);
>+
>+	ret = squashfs_read_submit(sb, index, length, srclength, bh, &b);
>+	if (ret < 0) {
>+		kfree(bh);
>+		return ret;
>+	}
>+
>+
>+	TRACE("Data block @ 0x%llx, %scompressed size %d, src size %d\n",
>+		index, compressed ? "" : "un", length, srclength);
>+
>+	length = squashfs_decompress_block(sb, compressed, buffer, bh,
>+				b, offset, length, srclength, pages);
>+	if (length < 0) {
>+		ERROR("squashfs_read_datablock failed to read block 0x%llx\n",
>+					(unsigned long long) index);
>+		kfree(bh);
>+		return -EIO;
>+	}
>+
>+	kfree(bh);
>+	return length;
>+}
>+
>+/*
>+ * Read and decompress a metadata block. @length is obtained from the first
>+ * two bytes of the metadata block.  A bit in the length field indicates if
>+ * the block is stored uncompressed in the filesystem (usually because
>+ * compression generated a larger block - this does occasionally happen with
>+ * compression algorithms).
>+ */
>+int squashfs_read_metablock(struct super_block *sb, void **buffer, u64 index,
>+			int length, u64 *next_index, int srclength, int pages)
>+{
>+	struct squashfs_sb_info *msblk = sb->s_fs_info;
>+	struct buffer_head **bh;
>+	int offset = index & ((1 << msblk->devblksize_log2) - 1);
>+	u64 cur_index = index >> msblk->devblksize_log2;
>+	int bytes, compressed, b = 0, k = 0;
>+
>+	BUG_ON(length);
>+
>+	bh = kcalloc(((srclength + msblk->devblksize - 1)
>+		>> msblk->devblksize_log2) + 1, sizeof(*bh), GFP_KERNEL);
>+	if (bh == NULL)
>+		return -ENOMEM;
>+
>+	if ((index + 2) > msblk->bytes_used)
>+		goto read_failure;
>+
>+	bh[0] = get_block_length(sb, &cur_index, &offset, &length);
>+	if (bh[0] == NULL)
>+		goto read_failure;
>+	b = 1;
>+
>+	bytes = msblk->devblksize - offset;
>+	compressed = SQUASHFS_COMPRESSED(length);
>+	length = SQUASHFS_COMPRESSED_SIZE(length);
>+	if (next_index)
>+		*next_index = index + length + 2;
>+
>+	TRACE("Meta block @ 0x%llx, %scompressed size %d\n", index,
>+			compressed ? "" : "un", length);
>+
>+	if (length < 0 || length > srclength ||
>+				(index + length) > msblk->bytes_used)
>+		goto block_release;
>+
>+	for (; bytes < length; b++) {
>+		bh[b] = sb_getblk(sb, ++cur_index);
>+		if (bh[b] == NULL)
>+			goto block_release;
>+		bytes += msblk->devblksize;
>+	}
>+	ll_rw_block(READ, b - 1, bh + 1);
>+
>+	length = squashfs_decompress_block(msblk, compressed, buffer, bh, b,
>+				offset, length, srclength, pages);
>+	if (length < 0)
>+		goto read_failure;
>+
> 	kfree(bh);
> 	return length;
>
>@@ -201,7 +275,7 @@ block_release:
> 		put_bh(bh[k]);
>
> read_failure:
>-	ERROR("squashfs_read_data failed to read block 0x%llx\n",
>+	ERROR("squashfs_read_metablock failed to read block 0x%llx\n",
> 					(unsigned long long) index);
> 	kfree(bh);
> 	return -EIO;
>diff --git a/fs/squashfs/cache.c b/fs/squashfs/cache.c
>index af0b738..6e6a616 100644
>--- a/fs/squashfs/cache.c
>+++ b/fs/squashfs/cache.c
>@@ -119,9 +119,15 @@ struct squashfs_cache_entry *squashfs_cache_get(struct super_block *sb,
> 			entry->error = 0;
> 			spin_unlock(&cache->lock);
>
>-			entry->length = squashfs_read_data(sb, entry->data,
>-				block, length, &entry->next_index,
>-				cache->block_size, cache->pages);
>+			if (length)
>+				entry->length = squashfs_read_datablock(sb,
>+					entry->data, block, length,
>+					cache->block_size, cache->pages);
>+			else
>+				entry->length = squashfs_read_metablock(sb,
>+					entry->data, block, length,
>+					&entry->next_index, cache->block_size,
>+					cache->pages);
>
> 			spin_lock(&cache->lock);
>
>@@ -424,8 +430,8 @@ void *squashfs_read_table(struct super_block *sb, u64 block, int length)
> 	for (i = 0; i < pages; i++, buffer += PAGE_CACHE_SIZE)
> 		data[i] = buffer;
>
>-	res = squashfs_read_data(sb, data, block, length |
>-		SQUASHFS_COMPRESSED_BIT_BLOCK, NULL, length, pages);
>+	res = squashfs_read_datablock(sb, data, block, length |
>+		SQUASHFS_COMPRESSED_BIT_BLOCK, length, pages);
>
> 	kfree(data);
>
>diff --git a/fs/squashfs/decompressor.c b/fs/squashfs/decompressor.c
>index 3f6271d..e47453e 100644
>--- a/fs/squashfs/decompressor.c
>+++ b/fs/squashfs/decompressor.c
>@@ -97,7 +97,7 @@ void *squashfs_decompressor_init(struct super_block *sb, unsigned short flags)
> 		if (buffer == NULL)
> 			return ERR_PTR(-ENOMEM);
>
>-		length = squashfs_read_data(sb, &buffer,
>+		length = squashfs_read_metablock(sb, &buffer,
> 			sizeof(struct squashfs_super_block), 0, NULL,
> 			PAGE_CACHE_SIZE, 1);
>
>diff --git a/fs/squashfs/squashfs.h b/fs/squashfs/squashfs.h
>index d126651..405baed 100644
>--- a/fs/squashfs/squashfs.h
>+++ b/fs/squashfs/squashfs.h
>@@ -28,8 +28,12 @@
> #define WARNING(s, args...)	pr_warning("SQUASHFS: "s, ## args)
>
> /* block.c */
>-extern int squashfs_read_data(struct super_block *, void **, u64, int, u64 *,
>+extern int squashfs_read_datablock(struct super_block *, void **, u64, int,
> 				int, int);
>+extern int squashfs_read_metablock(struct super_block *, void **, u64, int,
>+				u64 *, int, int);
>+extern int squashfs_read_submit(struct super_block *, u64, int, int,
>+				struct buffer_head **, int *);
>
> /* cache.c */
> extern struct squashfs_cache *squashfs_cache_init(char *, int, int);
