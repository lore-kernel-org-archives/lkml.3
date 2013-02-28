Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760276Ab3B1Uf5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Feb 2013 15:35:57 -0500
Received: from mail-pb0-f51.google.com ([209.85.160.51]:40040 "EHLO
	mail-pb0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760247Ab3B1Ufs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Feb 2013 15:35:48 -0500
From: Kent Overstreet <koverstreet@google.com>
To: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        linux-aio@kvack.org
Cc: Kent Overstreet <koverstreet@google.com>, tytso@mit.edu, axboe@kernel.dk,
        zab@redhat.com, bcrl@kvack.org, anatol@google.com
Subject: [PATCH 4/4] block: Bio cancellation
Date: Thu, 28 Feb 2013 12:35:41 -0800
Message-Id: <1362083741-2429-4-git-send-email-koverstreet@google.com>
X-Mailer: git-send-email 1.7.12
In-Reply-To: <1362083741-2429-1-git-send-email-koverstreet@google.com>
References: <1362083741-2429-1-git-send-email-koverstreet@google.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If a bio is associated with a kiocb, allow it to be cancelled.

This is accomplished by adding a pointer to a kiocb in struct bio, and
when we go to dequeue a request we check if its bio has been cancelled -
if so, we end the request with -ECANCELED.

We don't currently try to cancel bios if IO has already been started -
that'd require a per bio callback function, and a way to find all the
outstanding bios for a given kiocb. Such a mechanism may or may not be
added in the future but this patch tries to start simple.

Currently this can only be triggered with aio and io_cancel(), but the
mechanism can be used for sync io too.

It can also be used for bios created by stacking drivers, and bio clones
in general - when cloning a bio, if the bi_iocb pointer is copied as
well the clone will then be cancellable. bio_clone() could be modified
to do this, but hasn't in this patch because all the bio_clone() users
would need to be auditied to make sure that it's safe. We can't blindly
make e.g. raid5 writes cancellable without the knowledge of the md code.

Initial patch by Anatol Pomazau (anatol@google.com).

Signed-off-by: Kent Overstreet <koverstreet@google.com>
---
 block/blk-core.c          | 14 ++++++++++++++
 fs/direct-io.c            |  1 +
 include/linux/bio.h       |  5 +++++
 include/linux/blk_types.h |  1 +
 4 files changed, 21 insertions(+)

diff --git a/block/blk-core.c b/block/blk-core.c
index ba16771..a829670 100644
--- a/block/blk-core.c
+++ b/block/blk-core.c
@@ -1746,6 +1746,11 @@ generic_make_request_checks(struct bio *bio)
 		goto end_io;
 	}
 
+	if (bio_cancelled(bio)) {
+		err = -ECANCELED;
+		goto end_io;
+	}
+
 	/*
 	 * Various block parts want %current->io_context and lazy ioc
 	 * allocation ends up trading a lot of pain for a small amount of
@@ -2099,6 +2104,12 @@ struct request *blk_peek_request(struct request_queue *q)
 			trace_block_rq_issue(q, rq);
 		}
 
+		if (rq->bio && !rq->bio->bi_next && bio_cancelled(rq->bio)) {
+			blk_start_request(rq);
+			__blk_end_request_all(rq, -ECANCELED);
+			continue;
+		}
+
 		if (!q->boundary_rq || q->boundary_rq == rq) {
 			q->end_sector = rq_end_sector(rq);
 			q->boundary_rq = NULL;
@@ -2284,6 +2295,8 @@ bool blk_update_request(struct request *req, int error, unsigned int nr_bytes,
 		char *error_type;
 
 		switch (error) {
+		case -ECANCELED:
+			goto noerr;
 		case -ENOLINK:
 			error_type = "recoverable transport";
 			break;
@@ -2304,6 +2317,7 @@ bool blk_update_request(struct request *req, int error, unsigned int nr_bytes,
 				   (unsigned long long)blk_rq_pos(req));
 
 	}
+noerr:
 
 	blk_account_io_completion(req, nr_bytes);
 
diff --git a/fs/direct-io.c b/fs/direct-io.c
index b054615..671673c 100644
--- a/fs/direct-io.c
+++ b/fs/direct-io.c
@@ -376,6 +376,7 @@ static inline void dio_bio_submit(struct dio *dio, struct dio_submit *sdio)
 	unsigned long flags;
 
 	bio->bi_private = dio;
+	bio->bi_iocb = dio->iocb;
 
 	spin_lock_irqsave(&dio->bio_lock, flags);
 	dio->refcount++;
diff --git a/include/linux/bio.h b/include/linux/bio.h
index 5f5491767..28d5e45 100644
--- a/include/linux/bio.h
+++ b/include/linux/bio.h
@@ -71,6 +71,11 @@
 
 void bio_endio_batch(struct bio *bio, int error, struct batch_complete *batch);
 
+static inline bool bio_cancelled(struct bio *bio)
+{
+	return bio->bi_iocb && kiocb_cancelled(bio->bi_iocb);
+}
+
 static inline unsigned int bio_cur_bytes(struct bio *bio)
 {
 	if (bio->bi_vcnt)
diff --git a/include/linux/blk_types.h b/include/linux/blk_types.h
index d4e7bab..4d08359 100644
--- a/include/linux/blk_types.h
+++ b/include/linux/blk_types.h
@@ -44,6 +44,7 @@ struct bio {
 						 * top bits priority
 						 */
 
+	struct kiocb		*bi_iocb;
 	short			bi_error;
 	unsigned short		bi_vcnt;	/* how many bio_vec's */
 	unsigned short		bi_idx;		/* current index into bvl_vec */
-- 
1.7.12

