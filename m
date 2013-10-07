Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752437Ab3JGGIj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Oct 2013 02:08:39 -0400
Received: from LGEMRELSE1Q.lge.com ([156.147.1.111]:54850 "EHLO
	LGEMRELSE1Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751695Ab3JGGIi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Oct 2013 02:08:38 -0400
X-AuditID: 9c93016f-b7c26ae000001f9f-ea-52524fe4e97c
Date: Mon, 7 Oct 2013 15:09:51 +0900
From: Minchan Kim <minchan@kernel.org>
To: Phillip Lougher <phillip@lougher.demon.co.uk>
Cc: linux-kernel@vger.kernel.org, ch0.han@lge.com, gunho.lee@lge.com
Subject: Re: [RFC,4/5] squashfs: support multiple decompress stream buffer
Message-ID: <20131007060951.GA25780@bbox>
References: <52522D60.1030206@lougher.demon.co.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <52522D60.1030206@lougher.demon.co.uk>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Phillip,

On Mon, Oct 07, 2013 at 04:41:20AM +0100, Phillip Lougher wrote:
> Hi,
> 
> This a partial review, based on the stuff I've managed to review
> so far!
> 
> 1. This is a substantial performance improvement, which is great
>    stuff!

Thanks.

> 
>    But like the "squashfs: remove cache for normal data page" patch
>    it needs to be optional, with the previous behaviour retained as
>    default.  Again, without wanting to sound like a broken (vinyl)

Just FYI, I have a plan to drop "squashfs: remove cache for normal
data page" in next submit as you pointed out it could make regression.
So my plan is that squashfs_readpage uses the cache but squashfs_readpages
will not use the cache.
If you have any concern in my design, please tell me.

>    record, this is because as maintainer I get to worry about breaking
>    things for existing users of Squashfs when they upgrade their kernel.
> 
>    I know from consulting experience, many users of Squashfs are "on the
>    edge" of memory and CPU performance, and are using Squashfs to squeeze
>    a bit more performance out of a maxed out system.
> 
>    In these cases, changing Squashfs so it uses more memory and more
>    CPU than previously (and in this patch a lot more memory and CPU as
>    it will try and kick off multiple decompressors per core) is a bit
>    like robbing Peter to pay Paul, Squashfs may take CPU and memory
>    that are needed elsewhere, and used to be available.
> 
>    So, basically, users need to be able to explicitly select this.

Okay.

> 
> 2. The patch breaks the decompressor interface.  Compressor option
>    parsing is implemented in the decompressor init() function, which
>    means everytime a new decompressor is dynamically instantiated, we
>    need to read and parse the compression options again and again.  This
>    is an unnecessary performance degradation.
> 
>    Compressor option parsing and reading should be split out of init()
>    and into a separate function.

Indeed.

> 
>    Compression option parsing and reading is quite obscure, it is a
>    late addition to the filesystem format, and had to be squeezed into
>    the existing format.  This means it can be difficult to get it right
>    as the specification exists only in my head.

Hmm, I had a question. Please look at below.

> 
>    I'll help you here.
> 
> Specific comments follow in the patch.
> 
> Phillip
> 
> 
> 
> >Now squashfs have used for only one stream buffer for decompression
> >so it hurts concurrent read performance due to locking lock of getting
> >stream buffer.
> >
> >When file system mount, the number of stream buffer is started from
> >num_online_cpus() and grows up to num_online_cpus() * 2M / block_size * 2.
> >The rationale is MM does readahead chunk into 2M unit to prevent too much
> >memory pin and while one request is waitting, we should request another
> >chunk. That's why I multiply by 2.
> >
> >If it reveals too much memory problem, we can add shrinker routine.
> >
> >I did test following as
> >
> >Two 1G file dd read
> >
> >dd if=test/test1.dat of=/dev/null &
> >dd if=test/test2.dat of=/dev/null &
> >
> >old : 60sec -> new : 30 sec
> >
> >Signed-off-by: Minchan Kim <minchan@kernel.org>
> >
> >---
> >fs/squashfs/block.c          |    9 ++--
> >fs/squashfs/decompressor.c   |  105 ++++++++++++++++++++++++++++++++++++++----
> >fs/squashfs/decompressor.h   |   27 +++++------
> >fs/squashfs/lzo_wrapper.c    |   12 ++---
> >fs/squashfs/squashfs.h       |    3 +-
> >fs/squashfs/squashfs_fs_sb.h |    7 ++-
> >fs/squashfs/super.c          |   40 ++++++++++++----
> >fs/squashfs/xz_wrapper.c     |   20 ++++----
> >fs/squashfs/zlib_wrapper.c   |   12 ++---
> >9 files changed, 168 insertions(+), 67 deletions(-)
> >
> >diff --git a/fs/squashfs/block.c b/fs/squashfs/block.c
> >index f33c6ef..d41bac8 100644
> >--- a/fs/squashfs/block.c
> >+++ b/fs/squashfs/block.c
> >@@ -78,14 +78,14 @@ static struct buffer_head *get_block_length(struct super_block *sb,
> >
> >
> >
> >-int squashfs_decompress_block(struct squashfs_sb_info *msblk, int compressed,
> >+int squashfs_decompress_block(struct super_block *sb, int compressed,
> >		void **buffer, struct buffer_head **bh, int nr_bh,
> >		int offset, int length, int srclength, int pages)
> >{
> >	int k = 0;
> >
> >	if (compressed) {
> >-		length = squashfs_decompress(msblk, buffer, bh, nr_bh,
> >+		length = squashfs_decompress(sb, buffer, bh, nr_bh,
> >				offset, length, srclength, pages);
> >		if (length < 0)
> >			goto out;
> >@@ -93,6 +93,7 @@ int squashfs_decompress_block(struct squashfs_sb_info *msblk, int compressed,
> >		/*
> >		 * Block is uncompressed.
> >		 */
> >+		struct squashfs_sb_info *msblk = sb->s_fs_info;
> >		int bytes, in, avail, pg_offset = 0, page = 0;
> >
> >		for (bytes = length; k < nr_bh; k++) {
> >@@ -262,8 +263,8 @@ int squashfs_read_metablock(struct super_block *sb, void **buffer, u64 index,
> >	}
> >	ll_rw_block(READ, b - 1, bh + 1);
> >
> >-	length = squashfs_decompress_block(msblk, compressed, buffer, bh, b,
> >-				offset, length, srclength, pages);
> >+	length = squashfs_decompress_block(sb, compressed, buffer, bh,
> >+				b, offset, length, srclength, pages);
> >	if (length < 0)
> >		goto read_failure;
> >
> >diff --git a/fs/squashfs/decompressor.c b/fs/squashfs/decompressor.c
> >index e47453e..ed35b32 100644
> >--- a/fs/squashfs/decompressor.c
> >+++ b/fs/squashfs/decompressor.c
> >@@ -25,6 +25,8 @@
> >#include <linux/mutex.h>
> >#include <linux/slab.h>
> >#include <linux/buffer_head.h>
> >+#include <linux/sched.h>
> >+#include <linux/wait.h>
> >
> >#include "squashfs_fs.h"
> >#include "squashfs_fs_sb.h"
> >@@ -70,6 +72,80 @@ static const struct squashfs_decompressor *decompressor[] = {
> >	&squashfs_unknown_comp_ops
> >};
> >
> >+void squashfs_decompressor_free(struct squashfs_sb_info *msblk,
> >+	struct squashfs_decomp_strm *stream)
> >+{
> >+	if (msblk->decompressor)
> >+		msblk->decompressor->free(stream->strm);
> >+	kfree(stream);
> >+}
> >+
> >+static void *squashfs_get_decomp_strm(struct squashfs_sb_info *msblk)
> >+{
> >+	struct squashfs_decomp_strm *strm = NULL;
> >+	mutex_lock(&msblk->comp_strm_mutex);
> >+	if (!list_empty(&msblk->strm_list)) {
> >+		strm = list_entry(msblk->strm_list.next,
> >+				struct squashfs_decomp_strm, list);
> >+		list_del(&strm->list);
> >+		msblk->nr_avail_decomp--;
> >+		WARN_ON(msblk->nr_avail_decomp < 0);
> >+	}
> >+	mutex_unlock(&msblk->comp_strm_mutex);
> >+	return strm;
> >+}
> >+
> >+static bool full_decomp_strm(struct squashfs_sb_info *msblk)
> >+{
> >+	/* MM do readahread 2M unit */
> >+	int blocks = 2 * 1024 * 1024 / msblk->block_size;
> >+	return msblk->nr_avail_decomp > (num_online_cpus() * blocks * 2);
> >+}
> >+
> >+static void squashfs_put_decomp_strm(struct squashfs_sb_info *msblk,
> >+					struct squashfs_decomp_strm *strm)
> >+{
> >+	mutex_lock(&msblk->comp_strm_mutex);
> >+	if (full_decomp_strm(msblk)) {
> >+		mutex_unlock(&msblk->comp_strm_mutex);
> >+		squashfs_decompressor_free(msblk, strm);
> >+		return;
> >+	}
> >+
> >+	list_add(&strm->list, &msblk->strm_list);
> >+	msblk->nr_avail_decomp++;
> >+	mutex_unlock(&msblk->comp_strm_mutex);
> >+	wake_up(&msblk->decomp_wait_queue);
> >+}
> >+
> >+int squashfs_decompress(struct super_block *sb, void **buffer,
> >+			struct buffer_head **bh, int b, int offset, int length,
> >+			int srclength, int pages)
> >+{
> >+	int ret;
> >+	struct squashfs_decomp_strm *strm;
> >+	struct squashfs_sb_info *msblk = sb->s_fs_info;
> >+	while (1) {
> >+		strm = squashfs_get_decomp_strm(msblk);
> >+		if (strm)
> >+			break;
> >+
> >+		if (!full_decomp_strm(msblk)) {
> >+			strm = squashfs_decompressor_init(sb);
> 
> here you call squashfs_decompressor_dynamically to instantiate a new
> decompressor,  this needs to read and parse the compression options again.
> 
> >+			if (strm)
> >+				break;
> >+		}
> >+
> >+		wait_event(msblk->decomp_wait_queue, msblk->nr_avail_decomp);
> >+		continue;
> >+	}
> >+
> >+	ret = msblk->decompressor->decompress(msblk, strm->strm, buffer, bh,
> >+		b, offset, length, srclength, pages);
> >+
> >+	squashfs_put_decomp_strm(msblk, strm);
> >+	return ret;
> >+}
> >
> >const struct squashfs_decompressor *squashfs_lookup_decompressor(int id)
> >{
> >@@ -82,35 +158,48 @@ const struct squashfs_decompressor *squashfs_lookup_decompressor(int id)
> >	return decompressor[i];
> >}
> >
> >-
> >-void *squashfs_decompressor_init(struct super_block *sb, unsigned short flags)
> >+struct squashfs_decomp_strm *squashfs_decompressor_init(struct super_block *sb)
> >{
> >	struct squashfs_sb_info *msblk = sb->s_fs_info;
> >+	struct squashfs_decomp_strm *decomp_strm = NULL;
> >	void *strm, *buffer = NULL;
> >	int length = 0;
> >
> >+	decomp_strm = kmalloc(sizeof(struct squashfs_decomp_strm), GFP_KERNEL);
> >+	if (!decomp_strm)
> >+		return ERR_PTR(-ENOMEM);
> >	/*
> >	 * Read decompressor specific options from file system if present
> >	 */
> >-	if (SQUASHFS_COMP_OPTS(flags)) {
> >+	if (SQUASHFS_COMP_OPTS(msblk->flags)) {
> >		buffer = kmalloc(PAGE_CACHE_SIZE, GFP_KERNEL);
> >-		if (buffer == NULL)
> >-			return ERR_PTR(-ENOMEM);
> >+		if (buffer == NULL) {
> >+			decomp_strm = ERR_PTR(-ENOMEM);
> >+			goto finished;
> >+		}
> >
> >		length = squashfs_read_metablock(sb, &buffer,
> >			sizeof(struct squashfs_super_block), 0, NULL,
> >			PAGE_CACHE_SIZE, 1);
> >
> 
> This reads the compressor options each decompressor init().  This should
> only be done once at mount time.
> 
> >		if (length < 0) {
> >-			strm = ERR_PTR(length);
> >+			decomp_strm = ERR_PTR(length);
> >			goto finished;
> >		}
> >	}
> >
> 
> 
> >	strm = msblk->decompressor->init(msblk, buffer, length);
> >+	if (IS_ERR(strm)) {
> >+		decomp_strm = strm;
> >+		goto finished;
> >+	}
> >
> >-finished:
> >+	decomp_strm->strm = strm;
> >	kfree(buffer);
> >+	return decomp_strm;
> >
> >-	return strm;
> >+finished:
> >+	kfree(decomp_strm);
> >+	kfree(buffer);
> >+	return decomp_strm;
> >}
> >diff --git a/fs/squashfs/decompressor.h b/fs/squashfs/decompressor.h
> >index 330073e..207c810 100644
> >--- a/fs/squashfs/decompressor.h
> >+++ b/fs/squashfs/decompressor.h
> >@@ -26,27 +26,24 @@
> >struct squashfs_decompressor {
> >	void	*(*init)(struct squashfs_sb_info *, void *, int);
> >	void	(*free)(void *);
> >-	int	(*decompress)(struct squashfs_sb_info *, void **,
> >+	int	(*decompress)(struct squashfs_sb_info *, void*, void **,
> >		struct buffer_head **, int, int, int, int, int);
> >	int	id;
> >	char	*name;
> >	int	supported;
> >};
> >
> >-static inline void squashfs_decompressor_free(struct squashfs_sb_info *msblk,
> >-	void *s)
> >-{
> >-	if (msblk->decompressor)
> >-		msblk->decompressor->free(s);
> >-}
> >-
> >-static inline int squashfs_decompress(struct squashfs_sb_info *msblk,
> >-	void **buffer, struct buffer_head **bh, int b, int offset, int length,
> >-	int srclength, int pages)
> >-{
> >-	return msblk->decompressor->decompress(msblk, buffer, bh, b, offset,
> >-		length, srclength, pages);
> >-}
> >+struct squashfs_decomp_strm {
> >+	void *strm;
> >+	struct list_head list;
> >+};
> >+
> >+int squashfs_decompress(struct super_block *sb, void **buffer,
> >+			struct buffer_head **bh, int b, int offset, int length,
> >+			int srclength, int pages);
> >+
> >+void squashfs_decompressor_free(struct squashfs_sb_info *msblk,
> >+	struct squashfs_decomp_strm *stream);
> >
> >#ifdef CONFIG_SQUASHFS_XZ
> >extern const struct squashfs_decompressor squashfs_xz_comp_ops;
> >diff --git a/fs/squashfs/lzo_wrapper.c b/fs/squashfs/lzo_wrapper.c
> >index 00f4dfc..e1bf135 100644
> >--- a/fs/squashfs/lzo_wrapper.c
> >+++ b/fs/squashfs/lzo_wrapper.c
> >@@ -74,17 +74,15 @@ static void lzo_free(void *strm)
> >}
> >
> >
> >-static int lzo_uncompress(struct squashfs_sb_info *msblk, void **buffer,
> >-	struct buffer_head **bh, int b, int offset, int length, int srclength,
> >-	int pages)
> >+static int lzo_uncompress(struct squashfs_sb_info *msblk, void *strm,
> >+		void **buffer, struct buffer_head **bh, int b, int offset,
> >+		int length, int srclength, int pages)
> >{
> >-	struct squashfs_lzo *stream = msblk->stream;
> >+	struct squashfs_lzo *stream = strm;
> >	void *buff = stream->input;
> >	int avail, i, bytes = length, res;
> >	size_t out_len = srclength;
> >
> >-	mutex_lock(&msblk->read_data_mutex);
> >-
> >	for (i = 0; i < b; i++) {
> >		wait_on_buffer(bh[i]);
> >		if (!buffer_uptodate(bh[i]))
> >@@ -111,7 +109,6 @@ static int lzo_uncompress(struct squashfs_sb_info *msblk, void **buffer,
> >		bytes -= avail;
> >	}
> >
> >-	mutex_unlock(&msblk->read_data_mutex);
> >	return res;
> >
> >block_release:
> >@@ -119,7 +116,6 @@ block_release:
> >		put_bh(bh[i]);
> >
> >failed:
> >-	mutex_unlock(&msblk->read_data_mutex);
> >
> >	ERROR("lzo decompression failed, data probably corrupt\n");
> >	return -EIO;
> >diff --git a/fs/squashfs/squashfs.h b/fs/squashfs/squashfs.h
> >index 405baed..4bb1f90 100644
> >--- a/fs/squashfs/squashfs.h
> >+++ b/fs/squashfs/squashfs.h
> >@@ -52,7 +52,8 @@ extern void *squashfs_read_table(struct super_block *, u64, int);
> >
> >/* decompressor.c */
> >extern const struct squashfs_decompressor *squashfs_lookup_decompressor(int);
> >-extern void *squashfs_decompressor_init(struct super_block *, unsigned short);
> >+extern struct squashfs_decomp_strm *squashfs_decompressor_init(
> >+				struct super_block *);
> >
> >/* export.c */
> >extern __le64 *squashfs_read_inode_lookup_table(struct super_block *, u64, u64,
> >diff --git a/fs/squashfs/squashfs_fs_sb.h b/fs/squashfs/squashfs_fs_sb.h
> >index 52934a2..0a209e6 100644
> >--- a/fs/squashfs/squashfs_fs_sb.h
> >+++ b/fs/squashfs/squashfs_fs_sb.h
> >@@ -63,10 +63,10 @@ struct squashfs_sb_info {
> >	__le64					*id_table;
> >	__le64					*fragment_index;
> >	__le64					*xattr_id_table;
> >-	struct mutex				read_data_mutex;
> >+	struct mutex                            comp_strm_mutex;
> >	struct mutex				meta_index_mutex;
> >	struct meta_index			*meta_index;
> >-	void					*stream;
> >+	struct list_head			strm_list;
> >	__le64					*inode_lookup_table;
> >	u64					inode_table;
> >	u64					directory_table;
> >@@ -76,5 +76,8 @@ struct squashfs_sb_info {
> >	long long				bytes_used;
> >	unsigned int				inodes;
> >	int					xattr_ids;
> >+	wait_queue_head_t			decomp_wait_queue;
> >+	int					nr_avail_decomp;
> >+	unsigned short				flags;
> >};
> >#endif
> >diff --git a/fs/squashfs/super.c b/fs/squashfs/super.c
> >index 60553a9..70aa9c4 100644
> >--- a/fs/squashfs/super.c
> >+++ b/fs/squashfs/super.c
> >@@ -84,7 +84,7 @@ static int squashfs_fill_super(struct super_block *sb, void *data, int silent)
> >	unsigned short flags;
> >	unsigned int fragments;
> >	u64 lookup_table_start, xattr_id_table_start, next_table;
> >-	int err;
> >+	int err, i;
> >
> >	TRACE("Entered squashfs_fill_superblock\n");
> >
> >@@ -98,7 +98,9 @@ static int squashfs_fill_super(struct super_block *sb, void *data, int silent)
> >	msblk->devblksize = sb_min_blocksize(sb, SQUASHFS_DEVBLK_SIZE);
> >	msblk->devblksize_log2 = ffz(~msblk->devblksize);
> >
> >-	mutex_init(&msblk->read_data_mutex);
> >+	INIT_LIST_HEAD(&msblk->strm_list);
> >+	mutex_init(&msblk->comp_strm_mutex);
> >+	init_waitqueue_head(&msblk->decomp_wait_queue);
> 
> This should be done via a helper in decompressor.c, i.e. the implementation
> shouldn't be visible here.
> 
> When I added the decompressor framework, I should have done this.
> 
> >	mutex_init(&msblk->meta_index_mutex);
> >
> >	/*
> >@@ -176,6 +178,7 @@ static int squashfs_fill_super(struct super_block *sb, void *data, int silent)
> >	msblk->directory_table = le64_to_cpu(sblk->directory_table_start);
> >	msblk->inodes = le32_to_cpu(sblk->inodes);
> >	flags = le16_to_cpu(sblk->flags);
> >+	msblk->flags = flags;
> >
> 
> ha, the superblock flags should only be needed at mount time.  After
> mount time there shouldn't be anything in flags we need to look at.
> 
> You need to do this because flags is needed for the decompressor init
> function (COMP_OPTS(flags)) which is now called after mount time.
> 
> Once the compressor options parsing is moved back to being only
> at mount time, you won't need to store the flags anymore.

Hmm, I'd like to clarify your point further.
I agree it's unnecessary performance degradation if we read compressor
option from storage whenever we create new stream buffer.
But we need it to create new stream buffer(ex, xz_dec_init) dynamically
so we should keep compressor option into somewhere. It means we should
keep it to somewhere although we remove flags field from msblk.
Am I missing something?

-- 
Kind regards,
Minchan Kim
