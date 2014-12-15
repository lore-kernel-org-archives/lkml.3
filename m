Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753949AbaLOOm1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Dec 2014 09:42:27 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:38818 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752972AbaLOO2s (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Dec 2014 09:28:48 -0500
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Chris Mason <clm@fb.com>, Linus Torvalds <torvalds@linux-foundation.org>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.16.y-ckt 121/168] btrfs: zero out left over bytes after processing compression streams
Date: Mon, 15 Dec 2014 14:26:15 +0000
Message-Id: <1418653622-21105-122-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 2.1.3
In-Reply-To: <1418653622-21105-1-git-send-email-luis.henriques@canonical.com>
References: <1418653622-21105-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.16
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.16.7-ckt3 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Chris Mason <clm@fb.com>

commit 2f19cad94cee3c9bd52d0c9ca584ef506302fb7c upstream.

Don Bailey noticed that our page zeroing for compression at end-io time
isn't complete.  This reworks a patch from Linus to push the zeroing
into the zlib and lzo specific functions instead of trying to handle the
corners inside btrfs_decompress_buf2page

Signed-off-by: Chris Mason <clm@fb.com>
Reviewed-by: Josef Bacik <jbacik@fb.com>
Reported-by: Don A. Bailey <donb@securitymouse.com>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
[ luis: backported to 3.16: adjusted context ]
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 fs/btrfs/compression.c | 33 +++++++++++++++++++++++++++++++--
 fs/btrfs/compression.h |  4 +++-
 fs/btrfs/lzo.c         | 15 +++++++++++++++
 fs/btrfs/zlib.c        | 20 ++++++++++++++++++--
 4 files changed, 67 insertions(+), 5 deletions(-)

diff --git a/fs/btrfs/compression.c b/fs/btrfs/compression.c
index 1daea0b47187..6db91cdbd92d 100644
--- a/fs/btrfs/compression.c
+++ b/fs/btrfs/compression.c
@@ -1010,8 +1010,6 @@ int btrfs_decompress_buf2page(char *buf, unsigned long buf_start,
 		bytes = min(bytes, working_bytes);
 		kaddr = kmap_atomic(page_out);
 		memcpy(kaddr + *pg_offset, buf + buf_offset, bytes);
-		if (*pg_index == (vcnt - 1) && *pg_offset == 0)
-			memset(kaddr + bytes, 0, PAGE_CACHE_SIZE - bytes);
 		kunmap_atomic(kaddr);
 		flush_dcache_page(page_out);
 
@@ -1053,3 +1051,34 @@ int btrfs_decompress_buf2page(char *buf, unsigned long buf_start,
 
 	return 1;
 }
+
+/*
+ * When uncompressing data, we need to make sure and zero any parts of
+ * the biovec that were not filled in by the decompression code.  pg_index
+ * and pg_offset indicate the last page and the last offset of that page
+ * that have been filled in.  This will zero everything remaining in the
+ * biovec.
+ */
+void btrfs_clear_biovec_end(struct bio_vec *bvec, int vcnt,
+				   unsigned long pg_index,
+				   unsigned long pg_offset)
+{
+	while (pg_index < vcnt) {
+		struct page *page = bvec[pg_index].bv_page;
+		unsigned long off = bvec[pg_index].bv_offset;
+		unsigned long len = bvec[pg_index].bv_len;
+
+		if (pg_offset < off)
+			pg_offset = off;
+		if (pg_offset < off + len) {
+			unsigned long bytes = off + len - pg_offset;
+			char *kaddr;
+
+			kaddr = kmap_atomic(page);
+			memset(kaddr + pg_offset, 0, bytes);
+			kunmap_atomic(kaddr);
+		}
+		pg_index++;
+		pg_offset = 0;
+	}
+}
diff --git a/fs/btrfs/compression.h b/fs/btrfs/compression.h
index 0c803b4fbf93..d181f70caae0 100644
--- a/fs/btrfs/compression.h
+++ b/fs/btrfs/compression.h
@@ -45,7 +45,9 @@ int btrfs_submit_compressed_write(struct inode *inode, u64 start,
 				  unsigned long nr_pages);
 int btrfs_submit_compressed_read(struct inode *inode, struct bio *bio,
 				 int mirror_num, unsigned long bio_flags);
-
+void btrfs_clear_biovec_end(struct bio_vec *bvec, int vcnt,
+				   unsigned long pg_index,
+				   unsigned long pg_offset);
 struct btrfs_compress_op {
 	struct list_head *(*alloc_workspace)(void);
 
diff --git a/fs/btrfs/lzo.c b/fs/btrfs/lzo.c
index dfad8514f0da..70e84945d2fd 100644
--- a/fs/btrfs/lzo.c
+++ b/fs/btrfs/lzo.c
@@ -374,6 +374,8 @@ cont:
 	}
 done:
 	kunmap(pages_in[page_in_index]);
+	if (!ret)
+		btrfs_clear_biovec_end(bvec, vcnt, page_out_index, pg_offset);
 	return ret;
 }
 
@@ -411,10 +413,23 @@ static int lzo_decompress(struct list_head *ws, unsigned char *data_in,
 		goto out;
 	}
 
+	/*
+	 * the caller is already checking against PAGE_SIZE, but lets
+	 * move this check closer to the memcpy/memset
+	 */
+	destlen = min_t(unsigned long, destlen, PAGE_SIZE);
 	bytes = min_t(unsigned long, destlen, out_len - start_byte);
 
 	kaddr = kmap_atomic(dest_page);
 	memcpy(kaddr, workspace->buf + start_byte, bytes);
+
+	/*
+	 * btrfs_getblock is doing a zero on the tail of the page too,
+	 * but this will cover anything missing from the decompressed
+	 * data.
+	 */
+	if (bytes < destlen)
+		memset(kaddr+bytes, 0, destlen-bytes);
 	kunmap_atomic(kaddr);
 out:
 	return ret;
diff --git a/fs/btrfs/zlib.c b/fs/btrfs/zlib.c
index b67d8fc81277..1c9137348f53 100644
--- a/fs/btrfs/zlib.c
+++ b/fs/btrfs/zlib.c
@@ -302,6 +302,8 @@ done:
 	zlib_inflateEnd(&workspace->inf_strm);
 	if (data_in)
 		kunmap(pages_in[page_in_index]);
+	if (!ret)
+		btrfs_clear_biovec_end(bvec, vcnt, page_out_index, pg_offset);
 	return ret;
 }
 
@@ -313,10 +315,14 @@ static int zlib_decompress(struct list_head *ws, unsigned char *data_in,
 	struct workspace *workspace = list_entry(ws, struct workspace, list);
 	int ret = 0;
 	int wbits = MAX_WBITS;
-	unsigned long bytes_left = destlen;
+	unsigned long bytes_left;
 	unsigned long total_out = 0;
+	unsigned long pg_offset = 0;
 	char *kaddr;
 
+	destlen = min_t(unsigned long, destlen, PAGE_SIZE);
+	bytes_left = destlen;
+
 	workspace->inf_strm.next_in = data_in;
 	workspace->inf_strm.avail_in = srclen;
 	workspace->inf_strm.total_in = 0;
@@ -344,7 +350,6 @@ static int zlib_decompress(struct list_head *ws, unsigned char *data_in,
 		unsigned long buf_start;
 		unsigned long buf_offset;
 		unsigned long bytes;
-		unsigned long pg_offset = 0;
 
 		ret = zlib_inflate(&workspace->inf_strm, Z_NO_FLUSH);
 		if (ret != Z_OK && ret != Z_STREAM_END)
@@ -387,6 +392,17 @@ next:
 		ret = 0;
 
 	zlib_inflateEnd(&workspace->inf_strm);
+
+	/*
+	 * this should only happen if zlib returned fewer bytes than we
+	 * expected.  btrfs_get_block is responsible for zeroing from the
+	 * end of the inline extent (destlen) to the end of the page
+	 */
+	if (pg_offset < destlen) {
+		kaddr = kmap_atomic(dest_page);
+		memset(kaddr + pg_offset, 0, destlen - pg_offset);
+		kunmap_atomic(kaddr);
+	}
 	return ret;
 }
 
-- 
2.1.3

