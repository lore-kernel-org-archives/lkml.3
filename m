Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752116Ab3JHBYP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Oct 2013 21:24:15 -0400
Received: from LGEMRELSE1Q.lge.com ([156.147.1.111]:42926 "EHLO
	LGEMRELSE1Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751644Ab3JHBYL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Oct 2013 21:24:11 -0400
X-AuditID: 9c93016f-b7c26ae000001f9f-e8-52535eb90e8c
Date: Tue, 8 Oct 2013 10:25:28 +0900
From: Minchan Kim <minchan@kernel.org>
To: Phillip Lougher <phillip@lougher.demon.co.uk>
Cc: linux-kernel@vger.kernel.org, ch0.han@lge.com, gunho.lee@lge.com
Subject: Re: [RFC,4/5] squashfs: support multiple decompress stream buffer
Message-ID: <20131008012528.GG25780@bbox>
References: <52522D60.1030206@lougher.demon.co.uk>
 <20131007060951.GA25780@bbox>
 <20131007063503.GB25780@bbox>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131007063503.GB25780@bbox>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 07, 2013 at 03:35:03PM +0900, Minchan Kim wrote:

< snip >

> > > 
> > > ha, the superblock flags should only be needed at mount time.  After
> > > mount time there shouldn't be anything in flags we need to look at.
> > > 
> > > You need to do this because flags is needed for the decompressor init
> > > function (COMP_OPTS(flags)) which is now called after mount time.
> > > 
> > > Once the compressor options parsing is moved back to being only
> > > at mount time, you won't need to store the flags anymore.
> > 
> > Hmm, I'd like to clarify your point further.
> > I agree it's unnecessary performance degradation if we read compressor
> > option from storage whenever we create new stream buffer.
> > But we need it to create new stream buffer(ex, xz_dec_init) dynamically
> > so we should keep compressor option into somewhere. It means we should
> > keep it to somewhere although we remove flags field from msblk.
> > Am I missing something?
> 
> I should have been more specific.
> My concern is that we could remove the flags from msblk but we need comp_opts
> to create new comp buffer dynamically so we should keep comp_opts into somewhere.
> So, I think best place to keep it is struct squashfs_sb_info like this.
> 
> struct squashfs_sb_info {
>         const struct squashfs_decompressor      *decompressor;
>         void                                    *comp_opts;
>         ...
> };
> 
> What do you think about it?

So, this is my thought. Could you review this? I'd like to rebase other patches
on this.


>From 04b050357f4d6bf1dec8b324c3ab70b0cd113e6c Mon Sep 17 00:00:00 2001
From: Minchan Kim <minchan@kernel.org>
Date: Mon, 7 Oct 2013 16:54:31 +0900
Subject: [PATCH] squashfs: separate decompressor option parse logic and
 stream allocation

Now, when we mount, squashfs parses(ie, read block on storage)
decompressor option and creates stream buffer. Both functions are
abstracted by "initialization" phase of decompressor all at once.

But decompressor option parsing could be done only mounted time
while stream buffer allocation could be done dynamically in future
so this patch try to separate them.

This patch adds new decompressor functions (alloc and destroy)
and changes init function's semantic.

Old :

init : parse decompressor option + create stream buffer

New :

init : parse decompressor option and keep it on memory.
alloc: create stream buffer
destroy: free decompressor option which is allocated in init phase.

Signed-off-by: Minchan Kim <minchan@kernel.org>
---
 fs/squashfs/decompressor.c   |   30 ++++++++++-------
 fs/squashfs/decompressor.h   |   10 +++++-
 fs/squashfs/lzo_wrapper.c    |   14 +++++++-
 fs/squashfs/squashfs.h       |    1 +
 fs/squashfs/squashfs_fs_sb.h |    1 +
 fs/squashfs/super.c          |    9 ++++-
 fs/squashfs/xz_wrapper.c     |   76 +++++++++++++++++++++++++++++++-----------
 fs/squashfs/zlib_wrapper.c   |   14 +++++++-
 8 files changed, 119 insertions(+), 36 deletions(-)

diff --git a/fs/squashfs/decompressor.c b/fs/squashfs/decompressor.c
index 3f6271d..b0004c5 100644
--- a/fs/squashfs/decompressor.c
+++ b/fs/squashfs/decompressor.c
@@ -37,29 +37,29 @@
  */
 
 static const struct squashfs_decompressor squashfs_lzma_unsupported_comp_ops = {
-	NULL, NULL, NULL, LZMA_COMPRESSION, "lzma", 0
+	NULL, NULL, NULL, NULL, NULL, LZMA_COMPRESSION, "lzma", 0
 };
 
 #ifndef CONFIG_SQUASHFS_LZO
 static const struct squashfs_decompressor squashfs_lzo_comp_ops = {
-	NULL, NULL, NULL, LZO_COMPRESSION, "lzo", 0
+	NULL, NULL, NULL, NULL, NULL, LZO_COMPRESSION, "lzo", 0
 };
 #endif
 
 #ifndef CONFIG_SQUASHFS_XZ
 static const struct squashfs_decompressor squashfs_xz_comp_ops = {
-	NULL, NULL, NULL, XZ_COMPRESSION, "xz", 0
+	NULL, NULL, NULL, NULL, NULL, XZ_COMPRESSION, "xz", 0
 };
 #endif
 
 #ifndef CONFIG_SQUASHFS_ZLIB
 static const struct squashfs_decompressor squashfs_zlib_comp_ops = {
-	NULL, NULL, NULL, ZLIB_COMPRESSION, "zlib", 0
+	NULL, NULL, NULL, NULL, NULL, ZLIB_COMPRESSION, "zlib", 0
 };
 #endif
 
 static const struct squashfs_decompressor squashfs_unknown_comp_ops = {
-	NULL, NULL, NULL, 0, "unknown", 0
+	NULL, NULL, NULL, NULL, NULL, 0, "unknown", 0
 };
 
 static const struct squashfs_decompressor *decompressor[] = {
@@ -82,11 +82,11 @@ const struct squashfs_decompressor *squashfs_lookup_decompressor(int id)
 	return decompressor[i];
 }
 
-
 void *squashfs_decompressor_init(struct super_block *sb, unsigned short flags)
 {
 	struct squashfs_sb_info *msblk = sb->s_fs_info;
-	void *strm, *buffer = NULL;
+	int err;
+	void *buffer = NULL;
 	int length = 0;
 
 	/*
@@ -102,15 +102,21 @@ void *squashfs_decompressor_init(struct super_block *sb, unsigned short flags)
 			PAGE_CACHE_SIZE, 1);
 
 		if (length < 0) {
-			strm = ERR_PTR(length);
-			goto finished;
+			kfree(buffer);
+			return ERR_PTR(length);
 		}
 	}
 
-	strm = msblk->decompressor->init(msblk, buffer, length);
-
-finished:
+	err = msblk->decompressor->init(msblk, buffer, length);
 	kfree(buffer);
 
+	return ERR_PTR(err);
+
+}
+
+void *squashfs_decompressor_alloc(struct super_block *sb)
+{
+	struct squashfs_sb_info *msblk = sb->s_fs_info;
+	void *strm = msblk->decompressor->alloc(msblk);
 	return strm;
 }
diff --git a/fs/squashfs/decompressor.h b/fs/squashfs/decompressor.h
index 330073e..0c108dd 100644
--- a/fs/squashfs/decompressor.h
+++ b/fs/squashfs/decompressor.h
@@ -24,15 +24,23 @@
  */
 
 struct squashfs_decompressor {
-	void	*(*init)(struct squashfs_sb_info *, void *, int);
+	int	(*init)(struct squashfs_sb_info *, void *, int);
+	void	*(*alloc)(struct squashfs_sb_info *);
 	void	(*free)(void *);
 	int	(*decompress)(struct squashfs_sb_info *, void **,
 		struct buffer_head **, int, int, int, int, int);
+	void	(*destroy)(struct squashfs_sb_info *);
 	int	id;
 	char	*name;
 	int	supported;
 };
 
+static inline void squashfs_decompressor_destroy(struct squashfs_sb_info *msblk)
+{
+	if (msblk->decompressor)
+		msblk->decompressor->destroy(msblk);
+}
+
 static inline void squashfs_decompressor_free(struct squashfs_sb_info *msblk,
 	void *s)
 {
diff --git a/fs/squashfs/lzo_wrapper.c b/fs/squashfs/lzo_wrapper.c
index 00f4dfc..f1ad2df 100644
--- a/fs/squashfs/lzo_wrapper.c
+++ b/fs/squashfs/lzo_wrapper.c
@@ -37,7 +37,17 @@ struct squashfs_lzo {
 	void	*output;
 };
 
-static void *lzo_init(struct squashfs_sb_info *msblk, void *buff, int len)
+static int lzo_init(struct squashfs_sb_info *msblk, void *buffer, int len)
+{
+	return 0;
+}
+
+static void lzo_destroy(struct squashfs_sb_info *msblk)
+{
+
+}
+
+static void *lzo_alloc(struct squashfs_sb_info *msblk)
 {
 	int block_size = max_t(int, msblk->block_size, SQUASHFS_METADATA_SIZE);
 
@@ -127,8 +137,10 @@ failed:
 
 const struct squashfs_decompressor squashfs_lzo_comp_ops = {
 	.init = lzo_init,
+	.alloc = lzo_alloc,
 	.free = lzo_free,
 	.decompress = lzo_uncompress,
+	.destroy = lzo_destroy,
 	.id = LZO_COMPRESSION,
 	.name = "lzo",
 	.supported = 1
diff --git a/fs/squashfs/squashfs.h b/fs/squashfs/squashfs.h
index d126651..6fc329f 100644
--- a/fs/squashfs/squashfs.h
+++ b/fs/squashfs/squashfs.h
@@ -49,6 +49,7 @@ extern void *squashfs_read_table(struct super_block *, u64, int);
 /* decompressor.c */
 extern const struct squashfs_decompressor *squashfs_lookup_decompressor(int);
 extern void *squashfs_decompressor_init(struct super_block *, unsigned short);
+extern void *squashfs_decompressor_alloc(struct super_block *);
 
 /* export.c */
 extern __le64 *squashfs_read_inode_lookup_table(struct super_block *, u64, u64,
diff --git a/fs/squashfs/squashfs_fs_sb.h b/fs/squashfs/squashfs_fs_sb.h
index 52934a2..a553ec4 100644
--- a/fs/squashfs/squashfs_fs_sb.h
+++ b/fs/squashfs/squashfs_fs_sb.h
@@ -54,6 +54,7 @@ struct squashfs_cache_entry {
 
 struct squashfs_sb_info {
 	const struct squashfs_decompressor	*decompressor;
+	void 					*decomp_opt;
 	int					devblksize;
 	int					devblksize_log2;
 	struct squashfs_cache			*block_cache;
diff --git a/fs/squashfs/super.c b/fs/squashfs/super.c
index 60553a9..47180b9 100644
--- a/fs/squashfs/super.c
+++ b/fs/squashfs/super.c
@@ -212,7 +212,12 @@ static int squashfs_fill_super(struct super_block *sb, void *data, int silent)
 		goto failed_mount;
 	}
 
-	msblk->stream = squashfs_decompressor_init(sb, flags);
+	if (squashfs_decompressor_init(sb, flags)) {
+		ERROR("Failed to initialize decompressor\n");
+		goto failed_mount;
+	}
+
+	msblk->stream = squashfs_decompressor_alloc(sb);
 	if (IS_ERR(msblk->stream)) {
 		err = PTR_ERR(msblk->stream);
 		msblk->stream = NULL;
@@ -337,6 +342,7 @@ failed_mount:
 	squashfs_cache_delete(msblk->fragment_cache);
 	squashfs_cache_delete(msblk->read_page);
 	squashfs_decompressor_free(msblk, msblk->stream);
+	squashfs_decompressor_destroy(msblk);
 	kfree(msblk->inode_lookup_table);
 	kfree(msblk->fragment_index);
 	kfree(msblk->id_table);
@@ -384,6 +390,7 @@ static void squashfs_put_super(struct super_block *sb)
 		squashfs_cache_delete(sbi->fragment_cache);
 		squashfs_cache_delete(sbi->read_page);
 		squashfs_decompressor_free(sbi, sbi->stream);
+		squashfs_decompressor_destroy(sbi);
 		kfree(sbi->id_table);
 		kfree(sbi->fragment_index);
 		kfree(sbi->meta_index);
diff --git a/fs/squashfs/xz_wrapper.c b/fs/squashfs/xz_wrapper.c
index 1760b7d1..60f30d7e2 100644
--- a/fs/squashfs/xz_wrapper.c
+++ b/fs/squashfs/xz_wrapper.c
@@ -38,38 +38,72 @@ struct squashfs_xz {
 	struct xz_buf buf;
 };
 
-struct comp_opts {
+struct comp_opts_ondisk {
 	__le32 dictionary_size;
 	__le32 flags;
 };
 
-static void *squashfs_xz_init(struct squashfs_sb_info *msblk, void *buff,
+struct comp_opts {
+	int dict_size;
+};
+
+static int squashfs_xz_init(struct squashfs_sb_info *msblk, void *buff,
 	int len)
 {
-	struct comp_opts *comp_opts = buff;
-	struct squashfs_xz *stream;
-	int dict_size = msblk->block_size;
-	int err, n;
+	int err = 0;
+	int dict_size, n;
+	struct comp_opts_ondisk *comp_opts_ondisk = buff;
+	struct comp_opts *comp_opts = NULL;
+	/* check compressor options are the expected length */
+	if (len < sizeof(*comp_opts_ondisk)) {
+		err = -EIO;
+		goto failed;
+	}
 
-	if (comp_opts) {
-		/* check compressor options are the expected length */
-		if (len < sizeof(*comp_opts)) {
-			err = -EIO;
-			goto failed;
-		}
+	comp_opts = kmalloc(sizeof(struct comp_opts), GFP_KERNEL);
+	if (!comp_opts) {
+		err = -ENOMEM;
+		goto failed;
+	}
 
-		dict_size = le32_to_cpu(comp_opts->dictionary_size);
+	dict_size = le32_to_cpu(comp_opts_ondisk->dictionary_size);
 
-		/* the dictionary size should be 2^n or 2^n+2^(n+1) */
-		n = ffs(dict_size) - 1;
-		if (dict_size != (1 << n) && dict_size != (1 << n) +
-						(1 << (n + 1))) {
-			err = -EIO;
-			goto failed;
-		}
+	/* the dictionary size should be 2^n or 2^n+2^(n+1) */
+	n = ffs(dict_size) - 1;
+	if (dict_size != (1 << n) && dict_size != (1 << n) +
+					(1 << (n + 1))) {
+		err = -EIO;
+		goto failed;
 	}
 
 	dict_size = max_t(int, dict_size, SQUASHFS_METADATA_SIZE);
+	comp_opts->dict_size = dict_size;
+	msblk->decomp_opt = comp_opts;
+	return 0;
+failed:
+	kfree(comp_opts);
+	return err;
+}
+
+static void squashfs_xz_destroy(struct squashfs_sb_info *msblk)
+{
+	if (msblk->decomp_opt)
+		kfree(msblk->decomp_opt);
+}
+
+static void *squashfs_xz_alloc(struct squashfs_sb_info *msblk)
+{
+	struct squashfs_xz *stream;
+	struct comp_opts *comp_opts = (struct comp_opts *)msblk->decomp_opt;
+	int err;
+	int dict_size;
+
+	if (comp_opts) {
+		dict_size = comp_opts->dict_size;
+	} else {
+		dict_size = max_t(int, msblk->block_size,
+				SQUASHFS_METADATA_SIZE);
+	}
 
 	stream = kmalloc(sizeof(*stream), GFP_KERNEL);
 	if (stream == NULL) {
@@ -172,8 +206,10 @@ release_mutex:
 
 const struct squashfs_decompressor squashfs_xz_comp_ops = {
 	.init = squashfs_xz_init,
+	.alloc = squashfs_xz_alloc,
 	.free = squashfs_xz_free,
 	.decompress = squashfs_xz_uncompress,
+	.destroy = squashfs_xz_destroy,
 	.id = XZ_COMPRESSION,
 	.name = "xz",
 	.supported = 1
diff --git a/fs/squashfs/zlib_wrapper.c b/fs/squashfs/zlib_wrapper.c
index 55d918f..e46e24d 100644
--- a/fs/squashfs/zlib_wrapper.c
+++ b/fs/squashfs/zlib_wrapper.c
@@ -33,7 +33,17 @@
 #include "squashfs.h"
 #include "decompressor.h"
 
-static void *zlib_init(struct squashfs_sb_info *dummy, void *buff, int len)
+static int zlib_init(struct squashfs_sb_info *dummy, void *buffer, int len)
+{
+	return 0;
+}
+
+static void zlib_destroy(struct squashfs_sb_info *dummy)
+{
+
+}
+
+static void *zlib_alloc(struct squashfs_sb_info *dummy)
 {
 	z_stream *stream = kmalloc(sizeof(z_stream), GFP_KERNEL);
 	if (stream == NULL)
@@ -140,8 +150,10 @@ release_mutex:
 
 const struct squashfs_decompressor squashfs_zlib_comp_ops = {
 	.init = zlib_init,
+	.alloc = zlib_alloc,
 	.free = zlib_free,
 	.decompress = zlib_uncompress,
+	.destroy = zlib_destroy,
 	.id = ZLIB_COMPRESSION,
 	.name = "zlib",
 	.supported = 1
-- 
1.7.9.5

-- 
Kind regards,
Minchan Kim
