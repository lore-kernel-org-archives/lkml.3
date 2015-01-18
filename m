Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751901AbbARPRg (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Jan 2015 10:17:36 -0500
Received: from casper.infradead.org ([85.118.1.10]:52059 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751090AbbARPRd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Jan 2015 10:17:33 -0500
From: Christoph Hellwig <hch@lst.de>
To: Jens Axboe <axboe@kernel.dk>, Dongsu Park <dongsu.park@profitbricks.com>
Cc: Kent Overstreet <kmo@daterainc.com>, linux-kernel@vger.kernel.org
Subject: [PATCH 1/7] block: simplify bio_map_kern
Date: Sun, 18 Jan 2015 16:16:28 +0100
Message-Id: <1421594194-25918-2-git-send-email-hch@lst.de>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1421594194-25918-1-git-send-email-hch@lst.de>
References: <1421594194-25918-1-git-send-email-hch@lst.de>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Just open code the trivial mapping from a kernel virtual address to
a bio instead of going through the complex user address mapping
machinery.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 block/bio.c | 60 ++++++++++++++++++++++++++++++++++++++++++++----------------
 1 file changed, 44 insertions(+), 16 deletions(-)

diff --git a/block/bio.c b/block/bio.c
index 471d738..54da51e 100644
--- a/block/bio.c
+++ b/block/bio.c
@@ -1563,9 +1563,8 @@ static void bio_copy_kern_endio(struct bio *bio, int err)
 {
 	struct bio_vec *bvec;
 	const int read = bio_data_dir(bio) == READ;
-	struct bio_map_data *bmd = bio->bi_private;
+	char *p = bio->bi_private;
 	int i;
-	char *p = bmd->sgvecs[0].iov_base;
 
 	bio_for_each_segment_all(bvec, bio, i) {
 		char *addr = page_address(bvec->bv_page);
@@ -1577,7 +1576,6 @@ static void bio_copy_kern_endio(struct bio *bio, int err)
 		p += bvec->bv_len;
 	}
 
-	kfree(bmd);
 	bio_put(bio);
 }
 
@@ -1595,28 +1593,58 @@ static void bio_copy_kern_endio(struct bio *bio, int err)
 struct bio *bio_copy_kern(struct request_queue *q, void *data, unsigned int len,
 			  gfp_t gfp_mask, int reading)
 {
-	struct bio *bio;
+	unsigned long kaddr = (unsigned long)data;
+	unsigned long end = (kaddr + len + PAGE_SIZE - 1) >> PAGE_SHIFT;
+	unsigned long start = kaddr >> PAGE_SHIFT;
 	struct bio_vec *bvec;
-	int i;
+	struct bio *bio;
+	void *p = data;
+	int nr_pages = 0, i;
 
-	bio = bio_copy_user(q, NULL, (unsigned long)data, len, 1, gfp_mask);
-	if (IS_ERR(bio))
-		return bio;
+	/*
+	 * Overflow, abort
+	 */
+	if (end < start)
+		return ERR_PTR(-EINVAL);
 
-	if (!reading) {
-		void *p = data;
+	nr_pages = end - start;
+	bio = bio_kmalloc(gfp_mask, nr_pages);
+	if (!bio)
+		return ERR_PTR(-ENOMEM);
 
-		bio_for_each_segment_all(bvec, bio, i) {
-			char *addr = page_address(bvec->bv_page);
+	while (len) {
+		struct page *page;
+		unsigned int bytes = PAGE_SIZE;
 
-			memcpy(addr, p, bvec->bv_len);
-			p += bvec->bv_len;
-		}
+		if (bytes > len)
+			bytes = len;
+
+		page = alloc_page(q->bounce_gfp | gfp_mask);
+		if (!page)
+			goto cleanup;
+
+		if (!reading)
+			memcpy(page_address(page), p, bytes);
+
+		if (bio_add_pc_page(q, bio, page, bytes, 0) < bytes)
+			break;
+
+		len -= bytes;
+		p += bytes;
 	}
 
-	bio->bi_end_io = bio_copy_kern_endio;
+	if (!reading)
+		bio->bi_rw |= REQ_WRITE;
 
+	bio->bi_private = data;
+	bio->bi_end_io = bio_copy_kern_endio;
 	return bio;
+
+cleanup:
+	bio_for_each_segment_all(bvec, bio, i)
+		__free_page(bvec->bv_page);
+	bio_put(bio);
+	return ERR_PTR(-ENOMEM);
 }
 EXPORT_SYMBOL(bio_copy_kern);
 
-- 
1.9.1

