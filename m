Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754999AbbAPMGH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Jan 2015 07:06:07 -0500
Received: from casper.infradead.org ([85.118.1.10]:44186 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754946AbbAPMGC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Jan 2015 07:06:02 -0500
From: Christoph Hellwig <hch@lst.de>
To: Jens Axboe <axboe@kernel.dk>, Dongsu Park <dongsu.park@profitbricks.com>
Cc: Kent Overstreet <kmo@daterainc.com>, linux-kernel@vger.kernel.org
Subject: [PATCH 5/7] block: merge __bio_map_kern into bio_map_kern
Date: Fri, 16 Jan 2015 13:04:53 +0100
Message-Id: <1421409895-21377-6-git-send-email-hch@lst.de>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1421409895-21377-1-git-send-email-hch@lst.de>
References: <1421409895-21377-1-git-send-email-hch@lst.de>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This saves a little code, and allow to simplify the error handling.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 block/bio.c | 50 +++++++++++++++++---------------------------------
 1 file changed, 17 insertions(+), 33 deletions(-)

diff --git a/block/bio.c b/block/bio.c
index 7d8c655..a69a9c9 100644
--- a/block/bio.c
+++ b/block/bio.c
@@ -1429,8 +1429,18 @@ static void bio_map_kern_endio(struct bio *bio, int err)
 	bio_put(bio);
 }
 
-static struct bio *__bio_map_kern(struct request_queue *q, void *data,
-				  unsigned int len, gfp_t gfp_mask)
+/**
+ *	bio_map_kern	-	map kernel address into bio
+ *	@q: the struct request_queue for the bio
+ *	@data: pointer to buffer to map
+ *	@len: length in bytes
+ *	@gfp_mask: allocation flags for bio allocation
+ *
+ *	Map the kernel address into a bio suitable for io to a block
+ *	device. Returns an error pointer in case of error.
+ */
+struct bio *bio_map_kern(struct request_queue *q, void *data, unsigned int len,
+			 gfp_t gfp_mask)
 {
 	unsigned long kaddr = (unsigned long)data;
 	unsigned long end = (kaddr + len + PAGE_SIZE - 1) >> PAGE_SHIFT;
@@ -1454,8 +1464,11 @@ static struct bio *__bio_map_kern(struct request_queue *q, void *data,
 			bytes = len;
 
 		if (bio_add_pc_page(q, bio, virt_to_page(data), bytes,
-				    offset) < bytes)
-			break;
+				    offset) < bytes) {
+			/* we don't support partial mappings */
+			bio_put(bio);
+			return ERR_PTR(-EINVAL);
+		}
 
 		data += bytes;
 		len -= bytes;
@@ -1465,35 +1478,6 @@ static struct bio *__bio_map_kern(struct request_queue *q, void *data,
 	bio->bi_end_io = bio_map_kern_endio;
 	return bio;
 }
-
-/**
- *	bio_map_kern	-	map kernel address into bio
- *	@q: the struct request_queue for the bio
- *	@data: pointer to buffer to map
- *	@len: length in bytes
- *	@gfp_mask: allocation flags for bio allocation
- *
- *	Map the kernel address into a bio suitable for io to a block
- *	device. Returns an error pointer in case of error.
- */
-struct bio *bio_map_kern(struct request_queue *q, void *data, unsigned int len,
-			 gfp_t gfp_mask)
-{
-	struct bio *bio;
-
-	bio = __bio_map_kern(q, data, len, gfp_mask);
-	if (IS_ERR(bio))
-		return bio;
-
-	if (bio->bi_iter.bi_size == len)
-		return bio;
-
-	/*
-	 * Don't support partial mappings.
-	 */
-	bio_put(bio);
-	return ERR_PTR(-EINVAL);
-}
 EXPORT_SYMBOL(bio_map_kern);
 
 static void bio_copy_kern_endio(struct bio *bio, int err)
-- 
1.9.1

