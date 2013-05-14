Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756086Ab3ENBUw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 May 2013 21:20:52 -0400
Received: from mail-pd0-f178.google.com ([209.85.192.178]:62541 "EHLO
	mail-pd0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755801Ab3ENBTc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 May 2013 21:19:32 -0400
From: Kent Overstreet <koverstreet@google.com>
To: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        linux-aio@kvack.org
Cc: akpm@linux-foundation.org, Kent Overstreet <koverstreet@google.com>,
        Zach Brown <zab@redhat.com>, Joel Becker <jlbec@evilplan.org>,
        Jens Axboe <axboe@kernel.dk>, Jeff Moyer <jmoyer@redhat.com>,
        Al Viro <viro@zeniv.linux.org.uk>, Benjamin LaHaise <bcrl@kvack.org>
Subject: [PATCH 21/21] block: Bio cancellation
Date: Mon, 13 May 2013 18:18:58 -0700
Message-Id: <1368494338-7069-22-git-send-email-koverstreet@google.com>
X-Mailer: git-send-email 1.8.2.1
In-Reply-To: <1368494338-7069-1-git-send-email-koverstreet@google.com>
References: <1368494338-7069-1-git-send-email-koverstreet@google.com>
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
Cc: Zach Brown <zab@redhat.com>
Cc: Joel Becker <jlbec@evilplan.org>
Cc: Jens Axboe <axboe@kernel.dk>
Cc: Jeff Moyer <jmoyer@redhat.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: Benjamin LaHaise <bcrl@kvack.org>
---
 block/blk-core.c          | 15 +++++++++++++++
 fs/direct-io.c            |  1 +
 include/linux/aio.h       |  6 ++++++
 include/linux/blk_types.h |  1 +
 4 files changed, 23 insertions(+)

diff --git a/block/blk-core.c b/block/blk-core.c
index 94aa4e7..6bb99b6 100644
--- a/block/blk-core.c
+++ b/block/blk-core.c
@@ -31,6 +31,7 @@
 #include <linux/delay.h>
 #include <linux/ratelimit.h>
 #include <linux/pm_runtime.h>
+#include <linux/aio.h>
 
 #define CREATE_TRACE_POINTS
 #include <trace/events/block.h>
@@ -1744,6 +1745,11 @@ generic_make_request_checks(struct bio *bio)
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
@@ -2124,6 +2130,12 @@ struct request *blk_peek_request(struct request_queue *q)
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
@@ -2308,6 +2320,8 @@ bool blk_update_request(struct request *req, int error, unsigned int nr_bytes,
 		char *error_type;
 
 		switch (error) {
+		case -ECANCELED:
+			goto noerr;
 		case -ENOLINK:
 			error_type = "recoverable transport";
 			break;
@@ -2328,6 +2342,7 @@ bool blk_update_request(struct request *req, int error, unsigned int nr_bytes,
 				   (unsigned long long)blk_rq_pos(req));
 
 	}
+noerr:
 
 	blk_account_io_completion(req, nr_bytes);
 
diff --git a/fs/direct-io.c b/fs/direct-io.c
index 9ac3011..3ae5121 100644
--- a/fs/direct-io.c
+++ b/fs/direct-io.c
@@ -377,6 +377,7 @@ static inline void dio_bio_submit(struct dio *dio, struct dio_submit *sdio)
 	unsigned long flags;
 
 	bio->bi_private = dio;
+	bio->bi_iocb = dio->iocb;
 
 	spin_lock_irqsave(&dio->bio_lock, flags);
 	dio->refcount++;
diff --git a/include/linux/aio.h b/include/linux/aio.h
index 985e664..4893b8b 100644
--- a/include/linux/aio.h
+++ b/include/linux/aio.h
@@ -8,6 +8,7 @@
 #include <linux/rcupdate.h>
 #include <linux/atomic.h>
 #include <linux/batch_complete.h>
+#include <linux/blk_types.h>
 
 struct kioctx;
 struct kiocb;
@@ -105,6 +106,11 @@ static inline bool kiocb_cancelled(struct kiocb *kiocb)
 	return kiocb->ki_cancel == KIOCB_CANCELLED;
 }
 
+static inline bool bio_cancelled(struct bio *bio)
+{
+	return bio->bi_iocb && kiocb_cancelled(bio->bi_iocb);
+}
+
 static inline bool is_sync_kiocb(struct kiocb *kiocb)
 {
 	return kiocb->ki_ctx == NULL;
diff --git a/include/linux/blk_types.h b/include/linux/blk_types.h
index 9d3cafa..7252484 100644
--- a/include/linux/blk_types.h
+++ b/include/linux/blk_types.h
@@ -43,6 +43,7 @@ struct bio {
 						 * top bits priority
 						 */
 
+	struct kiocb		*bi_iocb;
 	short			bi_error;
 	unsigned short		bi_vcnt;	/* how many bio_vec's */
 	unsigned short		bi_idx;		/* current index into bvl_vec */
-- 
1.8.2.1

