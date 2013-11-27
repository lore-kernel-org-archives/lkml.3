Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754932Ab3K0Aqf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Nov 2013 19:46:35 -0500
Received: from mail-pd0-f180.google.com ([209.85.192.180]:60735 "EHLO
	mail-pd0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753440Ab3K0AqP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Nov 2013 19:46:15 -0500
From: Kent Overstreet <kmo@daterainc.com>
To: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        hch@infradead.org
Cc: Kent Overstreet <kmo@daterainc.com>, Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 20/25] block: Don't save/copy bvec array anymore
Date: Tue, 26 Nov 2013 16:45:23 -0800
Message-Id: <1385513128-5035-20-git-send-email-kmo@daterainc.com>
X-Mailer: git-send-email 1.8.4.4
In-Reply-To: <1385513128-5035-1-git-send-email-kmo@daterainc.com>
References: <20131127004422.GB21305@kmo>
 <1385513128-5035-1-git-send-email-kmo@daterainc.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Now that drivers have been converted to the bvec_iter primitives, they
shouldn't be modifying the biovec anymore and thus saving it is
unnecessary - code that was previously making a backup of the bvec array
can now just save bio->bi_iter.

Signed-off-by: Kent Overstreet <kmo@daterainc.com>
Cc: Jens Axboe <axboe@kernel.dk>
---
 fs/bio.c | 54 +++++++++++++-----------------------------------------
 1 file changed, 13 insertions(+), 41 deletions(-)

diff --git a/fs/bio.c b/fs/bio.c
index 6e42b68..9cff939 100644
--- a/fs/bio.c
+++ b/fs/bio.c
@@ -967,60 +967,33 @@ void bio_copy_data(struct bio *dst, struct bio *src)
 EXPORT_SYMBOL(bio_copy_data);
 
 struct bio_map_data {
-	struct bio_vec *iovecs;
-	struct sg_iovec *sgvecs;
 	int nr_sgvecs;
 	int is_our_pages;
+	struct sg_iovec sgvecs[];
 };
 
 static void bio_set_map_data(struct bio_map_data *bmd, struct bio *bio,
 			     struct sg_iovec *iov, int iov_count,
 			     int is_our_pages)
 {
-	memcpy(bmd->iovecs, bio->bi_io_vec, sizeof(struct bio_vec) * bio->bi_vcnt);
 	memcpy(bmd->sgvecs, iov, sizeof(struct sg_iovec) * iov_count);
 	bmd->nr_sgvecs = iov_count;
 	bmd->is_our_pages = is_our_pages;
 	bio->bi_private = bmd;
 }
 
-static void bio_free_map_data(struct bio_map_data *bmd)
-{
-	kfree(bmd->iovecs);
-	kfree(bmd->sgvecs);
-	kfree(bmd);
-}
-
 static struct bio_map_data *bio_alloc_map_data(int nr_segs,
 					       unsigned int iov_count,
 					       gfp_t gfp_mask)
 {
-	struct bio_map_data *bmd;
-
 	if (iov_count > UIO_MAXIOV)
 		return NULL;
 
-	bmd = kmalloc(sizeof(*bmd), gfp_mask);
-	if (!bmd)
-		return NULL;
-
-	bmd->iovecs = kmalloc(sizeof(struct bio_vec) * nr_segs, gfp_mask);
-	if (!bmd->iovecs) {
-		kfree(bmd);
-		return NULL;
-	}
-
-	bmd->sgvecs = kmalloc(sizeof(struct sg_iovec) * iov_count, gfp_mask);
-	if (bmd->sgvecs)
-		return bmd;
-
-	kfree(bmd->iovecs);
-	kfree(bmd);
-	return NULL;
+	return kmalloc(sizeof(struct bio_map_data) +
+		       sizeof(struct sg_iovec) * iov_count, gfp_mask);
 }
 
-static int __bio_copy_iov(struct bio *bio, struct bio_vec *iovecs,
-			  struct sg_iovec *iov, int iov_count,
+static int __bio_copy_iov(struct bio *bio, struct sg_iovec *iov, int iov_count,
 			  int to_user, int from_user, int do_free_page)
 {
 	int ret = 0, i;
@@ -1030,7 +1003,7 @@ static int __bio_copy_iov(struct bio *bio, struct bio_vec *iovecs,
 
 	bio_for_each_segment_all(bvec, bio, i) {
 		char *bv_addr = page_address(bvec->bv_page);
-		unsigned int bv_len = iovecs[i].bv_len;
+		unsigned int bv_len = bvec->bv_len;
 
 		while (bv_len && iov_idx < iov_count) {
 			unsigned int bytes;
@@ -1090,14 +1063,14 @@ int bio_uncopy_user(struct bio *bio)
 		 * don't copy into a random user address space, just free.
 		 */
 		if (current->mm)
-			ret = __bio_copy_iov(bio, bmd->iovecs, bmd->sgvecs,
-					     bmd->nr_sgvecs, bio_data_dir(bio) == READ,
+			ret = __bio_copy_iov(bio, bmd->sgvecs, bmd->nr_sgvecs,
+					     bio_data_dir(bio) == READ,
 					     0, bmd->is_our_pages);
 		else if (bmd->is_our_pages)
 			bio_for_each_segment_all(bvec, bio, i)
 				__free_page(bvec->bv_page);
 	}
-	bio_free_map_data(bmd);
+	kfree(bmd);
 	bio_put(bio);
 	return ret;
 }
@@ -1211,7 +1184,7 @@ struct bio *bio_copy_user_iov(struct request_queue *q,
 	 */
 	if ((!write_to_vm && (!map_data || !map_data->null_mapped)) ||
 	    (map_data && map_data->from_user)) {
-		ret = __bio_copy_iov(bio, bio->bi_io_vec, iov, iov_count, 0, 1, 0);
+		ret = __bio_copy_iov(bio, iov, iov_count, 0, 1, 0);
 		if (ret)
 			goto cleanup;
 	}
@@ -1225,7 +1198,7 @@ cleanup:
 
 	bio_put(bio);
 out_bmd:
-	bio_free_map_data(bmd);
+	kfree(bmd);
 	return ERR_PTR(ret);
 }
 
@@ -1542,16 +1515,15 @@ static void bio_copy_kern_endio(struct bio *bio, int err)
 
 	bio_for_each_segment_all(bvec, bio, i) {
 		char *addr = page_address(bvec->bv_page);
-		int len = bmd->iovecs[i].bv_len;
 
 		if (read)
-			memcpy(p, addr, len);
+			memcpy(p, addr, bvec->bv_len);
 
 		__free_page(bvec->bv_page);
-		p += len;
+		p += bvec->bv_len;
 	}
 
-	bio_free_map_data(bmd);
+	kfree(bmd);
 	bio_put(bio);
 }
 
-- 
1.8.4.4

