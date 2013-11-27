Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756492Ab3K0AtE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Nov 2013 19:49:04 -0500
Received: from mail-pd0-f177.google.com ([209.85.192.177]:58400 "EHLO
	mail-pd0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754200Ab3K0AqJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Nov 2013 19:46:09 -0500
From: Kent Overstreet <kmo@daterainc.com>
To: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        hch@infradead.org
Cc: Kent Overstreet <kmo@daterainc.com>
Subject: [PATCH 17/25] block: Add bio_clone_fast()
Date: Tue, 26 Nov 2013 16:45:20 -0800
Message-Id: <1385513128-5035-17-git-send-email-kmo@daterainc.com>
X-Mailer: git-send-email 1.8.4.4
In-Reply-To: <1385513128-5035-1-git-send-email-kmo@daterainc.com>
References: <20131127004422.GB21305@kmo>
 <1385513128-5035-1-git-send-email-kmo@daterainc.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

bio_clone() just got more expensive - however, most users of bio_clone()
don't actually need to modify the biovec. If they aren't modifying the
biovec, and they can guarantee that the original bio isn't freed before
the clone (also true in most cases), we can just point the clone at the
original bio's biovec.

Signed-off-by: Kent Overstreet <kmo@daterainc.com>
---
 drivers/md/bcache/request.c |  8 ++----
 fs/bio.c                    | 60 +++++++++++++++++++++++++++++++++++++++++++++
 include/linux/bio.h         |  2 ++
 3 files changed, 64 insertions(+), 6 deletions(-)

diff --git a/drivers/md/bcache/request.c b/drivers/md/bcache/request.c
index 4c0a422..63451c7 100644
--- a/drivers/md/bcache/request.c
+++ b/drivers/md/bcache/request.c
@@ -613,7 +613,6 @@ struct search {
 
 	struct btree_op		op;
 	struct data_insert_op	iop;
-	struct bio_vec		bv[BIO_MAX_PAGES];
 };
 
 static void bch_cache_read_endio(struct bio *bio, int error)
@@ -761,9 +760,7 @@ static void do_bio_hook(struct search *s)
 	struct bio *bio = &s->bio.bio;
 
 	bio_init(bio);
-	bio->bi_io_vec		= s->bv;
-	bio->bi_max_vecs	= BIO_MAX_PAGES;
-	__bio_clone(bio, s->orig_bio);
+	__bio_clone_fast(bio, s->orig_bio);
 	bio->bi_end_io		= request_endio;
 	bio->bi_private		= &s->cl;
 
@@ -1065,8 +1062,7 @@ static void cached_dev_write(struct cached_dev *dc, struct search *s)
 			closure_bio_submit(flush, cl, s->d);
 		}
 	} else {
-		s->iop.bio = bio_clone_bioset(bio, GFP_NOIO,
-					      dc->disk.bio_split);
+		s->iop.bio = bio_clone_fast(bio, GFP_NOIO, dc->disk.bio_split);
 
 		closure_bio_submit(bio, cl, s->d);
 	}
diff --git a/fs/bio.c b/fs/bio.c
index 1628917..00dc189 100644
--- a/fs/bio.c
+++ b/fs/bio.c
@@ -549,6 +549,66 @@ void __bio_clone(struct bio *bio, struct bio *bio_src)
 EXPORT_SYMBOL(__bio_clone);
 
 /**
+ * 	__bio_clone_fast - clone a bio that shares the original bio's biovec
+ * 	@bio: destination bio
+ * 	@bio_src: bio to clone
+ *
+ *	Clone a &bio. Caller will own the returned bio, but not
+ *	the actual data it points to. Reference count of returned
+ * 	bio will be one.
+ *
+ * 	Caller must ensure that @bio_src is not freed before @bio.
+ */
+void __bio_clone_fast(struct bio *bio, struct bio *bio_src)
+{
+	BUG_ON(bio->bi_pool && BIO_POOL_IDX(bio) != BIO_POOL_NONE);
+
+	/*
+	 * most users will be overriding ->bi_bdev with a new target,
+	 * so we don't set nor calculate new physical/hw segment counts here
+	 */
+	bio->bi_bdev = bio_src->bi_bdev;
+	bio->bi_flags |= 1 << BIO_CLONED;
+	bio->bi_rw = bio_src->bi_rw;
+	bio->bi_iter = bio_src->bi_iter;
+	bio->bi_io_vec = bio_src->bi_io_vec;
+}
+EXPORT_SYMBOL(__bio_clone_fast);
+
+/**
+ *	bio_clone_fast - clone a bio that shares the original bio's biovec
+ *	@bio: bio to clone
+ *	@gfp_mask: allocation priority
+ *	@bs: bio_set to allocate from
+ *
+ * 	Like __bio_clone_fast, only also allocates the returned bio
+ */
+struct bio *bio_clone_fast(struct bio *bio, gfp_t gfp_mask, struct bio_set *bs)
+{
+	struct bio *b;
+
+	b = bio_alloc_bioset(gfp_mask, 0, bs);
+	if (!b)
+		return NULL;
+
+	__bio_clone_fast(b, bio);
+
+	if (bio_integrity(bio)) {
+		int ret;
+
+		ret = bio_integrity_clone(b, bio, gfp_mask);
+
+		if (ret < 0) {
+			bio_put(b);
+			return NULL;
+		}
+	}
+
+	return b;
+}
+EXPORT_SYMBOL(bio_clone_fast);
+
+/**
  * 	bio_clone_bioset - clone a bio
  * 	@bio_src: bio to clone
  *	@gfp_mask: allocation priority
diff --git a/include/linux/bio.h b/include/linux/bio.h
index 1a31f9d..1f83f4a 100644
--- a/include/linux/bio.h
+++ b/include/linux/bio.h
@@ -328,6 +328,8 @@ extern mempool_t *biovec_create_pool(struct bio_set *bs, int pool_entries);
 extern struct bio *bio_alloc_bioset(gfp_t, int, struct bio_set *);
 extern void bio_put(struct bio *);
 
+extern void __bio_clone_fast(struct bio *, struct bio *);
+extern struct bio *bio_clone_fast(struct bio *, gfp_t, struct bio_set *);
 extern void __bio_clone(struct bio *, struct bio *);
 extern struct bio *bio_clone_bioset(struct bio *, gfp_t, struct bio_set *bs);
 
-- 
1.8.4.4

