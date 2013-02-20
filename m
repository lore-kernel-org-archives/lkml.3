Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935098Ab3BTAYH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Feb 2013 19:24:07 -0500
Received: from mail-pa0-f53.google.com ([209.85.220.53]:35637 "EHLO
	mail-pa0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935024Ab3BTAXS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Feb 2013 19:23:18 -0500
From: Kent Overstreet <koverstreet@google.com>
To: linux-kernel@vger.kernel.org
Cc: Kent Overstreet <koverstreet@google.com>, axboe@kernel.dk,
        NeilBrown <neilb@suse.de>
Subject: [PATCH 25/27] block: Add bio_alloc_pages()
Date: Tue, 19 Feb 2013 16:22:39 -0800
Message-Id: <1361319761-23873-26-git-send-email-koverstreet@google.com>
X-Mailer: git-send-email 1.7.12
In-Reply-To: <1361319761-23873-1-git-send-email-koverstreet@google.com>
References: <1361319761-23873-1-git-send-email-koverstreet@google.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

More utility code to replace stuff that's getting open coded.

Signed-off-by: Kent Overstreet <koverstreet@google.com>
CC: Jens Axboe <axboe@kernel.dk>
CC: NeilBrown <neilb@suse.de>
---
 drivers/md/raid1.c  | 16 +++-------------
 fs/bio.c            | 28 ++++++++++++++++++++++++++++
 include/linux/bio.h |  1 +
 3 files changed, 32 insertions(+), 13 deletions(-)

diff --git a/drivers/md/raid1.c b/drivers/md/raid1.c
index 981fd4f..95afd45 100644
--- a/drivers/md/raid1.c
+++ b/drivers/md/raid1.c
@@ -92,7 +92,6 @@ static void r1bio_pool_free(void *r1_bio, void *data)
 static void * r1buf_pool_alloc(gfp_t gfp_flags, void *data)
 {
 	struct pool_info *pi = data;
-	struct page *page;
 	struct r1bio *r1_bio;
 	struct bio *bio;
 	int i, j;
@@ -122,14 +121,10 @@ static void * r1buf_pool_alloc(gfp_t gfp_flags, void *data)
 		j = 1;
 	while(j--) {
 		bio = r1_bio->bios[j];
-		for (i = 0; i < RESYNC_PAGES; i++) {
-			page = alloc_page(gfp_flags);
-			if (unlikely(!page))
-				goto out_free_pages;
+		bio->bi_vcnt = RESYNC_PAGES;
 
-			bio->bi_io_vec[i].bv_page = page;
-			bio->bi_vcnt = i+1;
-		}
+		if (bio_alloc_pages(bio, gfp_flags))
+			goto out_free_bio;
 	}
 	/* If not user-requests, copy the page pointers to all bios */
 	if (!test_bit(MD_RECOVERY_REQUESTED, &pi->mddev->recovery)) {
@@ -143,11 +138,6 @@ static void * r1buf_pool_alloc(gfp_t gfp_flags, void *data)
 
 	return r1_bio;
 
-out_free_pages:
-	for (j=0 ; j < pi->raid_disks; j++)
-		for (i=0; i < r1_bio->bios[j]->bi_vcnt ; i++)
-			put_page(r1_bio->bios[j]->bi_io_vec[i].bv_page);
-	j = -1;
 out_free_bio:
 	while (++j < pi->raid_disks)
 		bio_put(r1_bio->bios[j]);
diff --git a/fs/bio.c b/fs/bio.c
index fe3aee90..e545a44 100644
--- a/fs/bio.c
+++ b/fs/bio.c
@@ -830,6 +830,34 @@ void bio_advance(struct bio *bio, unsigned bytes)
 EXPORT_SYMBOL(bio_advance);
 
 /**
+ * bio_alloc_pages - allocates a single page for each bvec in a bio
+ * @bio: bio to allocate pages for
+ * @gfp_mask: flags for allocation
+ *
+ * Allocates pages up to @bio->bi_vcnt.
+ *
+ * Returns 0 on success, -ENOMEM on failure. On failure, any allocated pages are
+ * freed.
+ */
+int bio_alloc_pages(struct bio *bio, gfp_t gfp_mask)
+{
+	int i;
+	struct bio_vec *bv;
+
+	bio_for_each_segment_all(bv, bio, i) {
+		bv->bv_page = alloc_page(gfp_mask);
+		if (!bv->bv_page) {
+			while (--bv >= bio->bi_io_vec)
+				__free_page(bv->bv_page);
+			return -ENOMEM;
+		}
+	}
+
+	return 0;
+}
+EXPORT_SYMBOL(bio_alloc_pages);
+
+/**
  * bio_copy_data - copy contents of data buffers from one chain of bios to
  * another
  * @src: source bio list
diff --git a/include/linux/bio.h b/include/linux/bio.h
index be2efa0..e25378f 100644
--- a/include/linux/bio.h
+++ b/include/linux/bio.h
@@ -298,6 +298,7 @@ static inline void bio_flush_dcache_pages(struct bio *bi)
 #endif
 
 extern void bio_copy_data(struct bio *dst, struct bio *src);
+extern int bio_alloc_pages(struct bio *bio, gfp_t gfp);
 
 extern struct bio *bio_copy_user(struct request_queue *, struct rq_map_data *,
 				 unsigned long, unsigned int, int, gfp_t);
-- 
1.7.12

