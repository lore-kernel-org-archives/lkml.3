Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756191Ab3ENBWG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 May 2013 21:22:06 -0400
Received: from mail-da0-f52.google.com ([209.85.210.52]:52272 "EHLO
	mail-da0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755900Ab3ENBTX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 May 2013 21:19:23 -0400
From: Kent Overstreet <koverstreet@google.com>
To: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        linux-aio@kvack.org
Cc: akpm@linux-foundation.org, Kent Overstreet <koverstreet@google.com>,
        Zach Brown <zab@redhat.com>, Felipe Balbi <balbi@ti.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Mark Fasheh <mfasheh@suse.com>, Joel Becker <jlbec@evilplan.org>,
        Rusty Russell <rusty@rustcorp.com.au>, Jens Axboe <axboe@kernel.dk>,
        Asai Thambi S P <asamymuthupa@micron.com>,
        Selvan Mani <smani@micron.com>, Sam Bradshaw <sbradshaw@micron.com>,
        Jeff Moyer <jmoyer@redhat.com>, Al Viro <viro@zeniv.linux.org.uk>,
        Benjamin LaHaise <bcrl@kvack.org>, "Theodore Ts'o" <tytso@mit.edu>,
        Minchan Kim <minchan@kernel.org>
Subject: [PATCH 14/21] block, aio: batch completion for bios/kiocbs
Date: Mon, 13 May 2013 18:18:51 -0700
Message-Id: <1368494338-7069-15-git-send-email-koverstreet@google.com>
X-Mailer: git-send-email 1.8.2.1
In-Reply-To: <1368494338-7069-1-git-send-email-koverstreet@google.com>
References: <1368494338-7069-1-git-send-email-koverstreet@google.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When completing a kiocb, there's some fixed overhead from touching the
kioctx's ring buffer the kiocb belongs to.  Some newer high end block
devices can complete multiple IOs per interrupt, much like many network
interfaces have been for some time.

This plumbs through infrastructure so we can take advantage of multiple
completions at the interrupt level, and complete multiple kiocbs at the
same time.

Drivers have to be converted to take advantage of this, but it's a simple
change and the next patches will convert a few drivers.

To use it, an interrupt handler (or any code that completes bios or
requests) declares and initializes a struct batch_complete:

struct batch_complete batch;
batch_complete_init(&batch);

Then, instead of calling bio_endio(), it calls
bio_endio_batch(bio, err, &batch). This just adds the bio to a list in
the batch_complete.

At the end, it calls

batch_complete(&batch);

This completes all the bios all at once, building up a list of kiocbs;
then the list of kiocbs are completed all at once.

[akpm@linux-foundation.org: fix warning]
[akpm@linux-foundation.org: fs/aio.c needs bio.h, move bio_endio_batch() declaration somewhere rational]
[akpm@linux-foundation.org: fix warnings]
[minchan@kernel.org: fix build error due to bio_endio_batch]
[akpm@linux-foundation.org: fix tracepoint in batch_complete()]
Signed-off-by: Kent Overstreet <koverstreet@google.com>
Cc: Zach Brown <zab@redhat.com>
Cc: Felipe Balbi <balbi@ti.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Mark Fasheh <mfasheh@suse.com>
Cc: Joel Becker <jlbec@evilplan.org>
Cc: Rusty Russell <rusty@rustcorp.com.au>
Cc: Jens Axboe <axboe@kernel.dk>
Cc: Asai Thambi S P <asamymuthupa@micron.com>
Cc: Selvan Mani <smani@micron.com>
Cc: Sam Bradshaw <sbradshaw@micron.com>
Cc: Jeff Moyer <jmoyer@redhat.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: Benjamin LaHaise <bcrl@kvack.org>
Cc: Theodore Ts'o <tytso@mit.edu>
Signed-off-by: Minchan Kim <minchan@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---
 block/blk-core.c               |  35 +++++---
 block/blk-flush.c              |   2 +-
 block/blk.h                    |   3 +-
 drivers/block/swim3.c          |   2 +-
 drivers/md/dm.c                |   2 +-
 fs/aio.c                       | 196 +++++++++++++++++++++++++----------------
 fs/bio.c                       |  49 +++++++----
 fs/direct-io.c                 |  12 +--
 include/linux/aio.h            |  24 ++++-
 include/linux/batch_complete.h |  22 +++++
 include/linux/bio.h            |  36 ++++++--
 include/linux/blk_types.h      |   1 +
 include/linux/blkdev.h         |  12 ++-
 13 files changed, 270 insertions(+), 126 deletions(-)
 create mode 100644 include/linux/batch_complete.h

diff --git a/block/blk-core.c b/block/blk-core.c
index 33c33bc..94aa4e7 100644
--- a/block/blk-core.c
+++ b/block/blk-core.c
@@ -153,7 +153,8 @@ void blk_rq_init(struct request_queue *q, struct request *rq)
 EXPORT_SYMBOL(blk_rq_init);
 
 static void req_bio_endio(struct request *rq, struct bio *bio,
-			  unsigned int nbytes, int error)
+			  unsigned int nbytes, int error,
+			  struct batch_complete *batch)
 {
 	if (error)
 		clear_bit(BIO_UPTODATE, &bio->bi_flags);
@@ -167,7 +168,7 @@ static void req_bio_endio(struct request *rq, struct bio *bio,
 
 	/* don't actually finish bio if it's part of flush sequence */
 	if (bio->bi_size == 0 && !(rq->cmd_flags & REQ_FLUSH_SEQ))
-		bio_endio(bio, error);
+		bio_endio_batch(bio, error, batch);
 }
 
 void blk_dump_rq_flags(struct request *rq, char *msg)
@@ -2281,7 +2282,8 @@ EXPORT_SYMBOL(blk_fetch_request);
  *     %false - this request doesn't have any more data
  *     %true  - this request has more data
  **/
-bool blk_update_request(struct request *req, int error, unsigned int nr_bytes)
+bool blk_update_request(struct request *req, int error, unsigned int nr_bytes,
+			struct batch_complete *batch)
 {
 	int total_bytes;
 
@@ -2337,7 +2339,7 @@ bool blk_update_request(struct request *req, int error, unsigned int nr_bytes)
 		if (bio_bytes == bio->bi_size)
 			req->bio = bio->bi_next;
 
-		req_bio_endio(req, bio, bio_bytes, error);
+		req_bio_endio(req, bio, bio_bytes, error, batch);
 
 		total_bytes += bio_bytes;
 		nr_bytes -= bio_bytes;
@@ -2390,14 +2392,15 @@ EXPORT_SYMBOL_GPL(blk_update_request);
 
 static bool blk_update_bidi_request(struct request *rq, int error,
 				    unsigned int nr_bytes,
-				    unsigned int bidi_bytes)
+				    unsigned int bidi_bytes,
+				    struct batch_complete *batch)
 {
-	if (blk_update_request(rq, error, nr_bytes))
+	if (blk_update_request(rq, error, nr_bytes, batch))
 		return true;
 
 	/* Bidi request must be completed as a whole */
 	if (unlikely(blk_bidi_rq(rq)) &&
-	    blk_update_request(rq->next_rq, error, bidi_bytes))
+	    blk_update_request(rq->next_rq, error, bidi_bytes, batch))
 		return true;
 
 	if (blk_queue_add_random(rq->q))
@@ -2480,7 +2483,7 @@ static bool blk_end_bidi_request(struct request *rq, int error,
 	struct request_queue *q = rq->q;
 	unsigned long flags;
 
-	if (blk_update_bidi_request(rq, error, nr_bytes, bidi_bytes))
+	if (blk_update_bidi_request(rq, error, nr_bytes, bidi_bytes, NULL))
 		return true;
 
 	spin_lock_irqsave(q->queue_lock, flags);
@@ -2506,9 +2509,11 @@ static bool blk_end_bidi_request(struct request *rq, int error,
  *     %true  - still buffers pending for this request
  **/
 bool __blk_end_bidi_request(struct request *rq, int error,
-				   unsigned int nr_bytes, unsigned int bidi_bytes)
+				   unsigned int nr_bytes,
+				   unsigned int bidi_bytes,
+				   struct batch_complete *batch)
 {
-	if (blk_update_bidi_request(rq, error, nr_bytes, bidi_bytes))
+	if (blk_update_bidi_request(rq, error, nr_bytes, bidi_bytes, batch))
 		return true;
 
 	blk_finish_request(rq, error);
@@ -2609,7 +2614,7 @@ EXPORT_SYMBOL_GPL(blk_end_request_err);
  **/
 bool __blk_end_request(struct request *rq, int error, unsigned int nr_bytes)
 {
-	return __blk_end_bidi_request(rq, error, nr_bytes, 0);
+	return __blk_end_bidi_request(rq, error, nr_bytes, 0, NULL);
 }
 EXPORT_SYMBOL(__blk_end_request);
 
@@ -2621,7 +2626,8 @@ EXPORT_SYMBOL(__blk_end_request);
  * Description:
  *     Completely finish @rq.  Must be called with queue lock held.
  */
-void __blk_end_request_all(struct request *rq, int error)
+void blk_end_request_all_batch(struct request *rq, int error,
+			       struct batch_complete *batch)
 {
 	bool pending;
 	unsigned int bidi_bytes = 0;
@@ -2629,10 +2635,11 @@ void __blk_end_request_all(struct request *rq, int error)
 	if (unlikely(blk_bidi_rq(rq)))
 		bidi_bytes = blk_rq_bytes(rq->next_rq);
 
-	pending = __blk_end_bidi_request(rq, error, blk_rq_bytes(rq), bidi_bytes);
+	pending = __blk_end_bidi_request(rq, error, blk_rq_bytes(rq),
+					 bidi_bytes, batch);
 	BUG_ON(pending);
 }
-EXPORT_SYMBOL(__blk_end_request_all);
+EXPORT_SYMBOL(blk_end_request_all_batch);
 
 /**
  * __blk_end_request_cur - Helper function to finish the current request chunk.
diff --git a/block/blk-flush.c b/block/blk-flush.c
index 762cfca..ab0ed23 100644
--- a/block/blk-flush.c
+++ b/block/blk-flush.c
@@ -316,7 +316,7 @@ void blk_insert_flush(struct request *rq)
 	 * complete the request.
 	 */
 	if (!policy) {
-		__blk_end_bidi_request(rq, 0, 0, 0);
+		__blk_end_bidi_request(rq, 0, 0, 0, NULL);
 		return;
 	}
 
diff --git a/block/blk.h b/block/blk.h
index e837b8f..dc8fee6 100644
--- a/block/blk.h
+++ b/block/blk.h
@@ -31,7 +31,8 @@ void blk_queue_bypass_end(struct request_queue *q);
 void blk_dequeue_request(struct request *rq);
 void __blk_queue_free_tags(struct request_queue *q);
 bool __blk_end_bidi_request(struct request *rq, int error,
-			    unsigned int nr_bytes, unsigned int bidi_bytes);
+			    unsigned int nr_bytes, unsigned int bidi_bytes,
+			    struct batch_complete *batch);
 
 void blk_rq_timed_out_timer(unsigned long data);
 void blk_delete_timer(struct request *);
diff --git a/drivers/block/swim3.c b/drivers/block/swim3.c
index 20e061c..9282e66 100644
--- a/drivers/block/swim3.c
+++ b/drivers/block/swim3.c
@@ -775,7 +775,7 @@ static irqreturn_t swim3_interrupt(int irq, void *dev_id)
 		if (intr & ERROR_INTR) {
 			n = fs->scount - 1 - resid / 512;
 			if (n > 0) {
-				blk_update_request(req, 0, n << 9);
+				blk_update_request(req, 0, n << 9, NULL);
 				fs->req_sector += n;
 			}
 			if (fs->retries < 5) {
diff --git a/drivers/md/dm.c b/drivers/md/dm.c
index 9101124..2901060 100644
--- a/drivers/md/dm.c
+++ b/drivers/md/dm.c
@@ -696,7 +696,7 @@ static void end_clone_bio(struct bio *clone, int error,
 	 * Do not use blk_end_request() here, because it may complete
 	 * the original request before the clone, and break the ordering.
 	 */
-	blk_update_request(tio->orig, 0, nr_bytes);
+	blk_update_request(tio->orig, 0, nr_bytes, NULL);
 }
 
 /*
diff --git a/fs/aio.c b/fs/aio.c
index a127e5a..aa39194 100644
--- a/fs/aio.c
+++ b/fs/aio.c
@@ -25,6 +25,7 @@
 #include <linux/file.h>
 #include <linux/mm.h>
 #include <linux/mman.h>
+#include <linux/bio.h>
 #include <linux/mmu_context.h>
 #include <linux/percpu.h>
 #include <linux/slab.h>
@@ -659,55 +660,11 @@ static struct kioctx *lookup_ioctx(unsigned long ctx_id)
 	return ret;
 }
 
-/* aio_complete
- *	Called when the io request on the given iocb is complete.
- */
-void aio_complete(struct kiocb *iocb, long res, long res2)
+static inline unsigned kioctx_ring_put(struct kioctx *ctx, struct kiocb *req,
+				       unsigned tail)
 {
-	struct kioctx	*ctx = iocb->ki_ctx;
-	struct aio_ring	*ring;
 	struct io_event	*ev_page, *event;
-	unsigned long	flags;
-	unsigned tail, pos;
-
-	/*
-	 * Special case handling for sync iocbs:
-	 *  - events go directly into the iocb for fast handling
-	 *  - the sync task with the iocb in its stack holds the single iocb
-	 *    ref, no other paths have a way to get another ref
-	 *  - the sync task helpfully left a reference to itself in the iocb
-	 */
-	if (is_sync_kiocb(iocb)) {
-		iocb->ki_user_data = res;
-		smp_wmb();
-		iocb->ki_ctx = ERR_PTR(-EXDEV);
-		wake_up_process(iocb->ki_obj.tsk);
-		return;
-	}
-
-	/*
-	 * Take rcu_read_lock() in case the kioctx is being destroyed, as we
-	 * need to issue a wakeup after incrementing reqs_available.
-	 */
-	rcu_read_lock();
-
-	if (iocb->ki_list.next) {
-		unsigned long flags;
-
-		spin_lock_irqsave(&ctx->ctx_lock, flags);
-		list_del(&iocb->ki_list);
-		spin_unlock_irqrestore(&ctx->ctx_lock, flags);
-	}
-
-	/*
-	 * Add a completion event to the ring buffer. Must be done holding
-	 * ctx->ctx_lock to prevent other code from messing with the tail
-	 * pointer since we might be called from irq context.
-	 */
-	spin_lock_irqsave(&ctx->completion_lock, flags);
-
-	tail = ctx->tail;
-	pos = tail + AIO_EVENTS_OFFSET;
+	unsigned pos = tail + AIO_EVENTS_OFFSET;
 
 	if (++tail >= ctx->nr_events)
 		tail = 0;
@@ -715,22 +672,30 @@ void aio_complete(struct kiocb *iocb, long res, long res2)
 	ev_page = kmap_atomic(ctx->ring_pages[pos / AIO_EVENTS_PER_PAGE]);
 	event = ev_page + pos % AIO_EVENTS_PER_PAGE;
 
-	event->obj = (u64)(unsigned long)iocb->ki_obj.user;
-	event->data = iocb->ki_user_data;
-	event->res = res;
-	event->res2 = res2;
+	event->obj	= (u64)(unsigned long)req->ki_obj.user;
+	event->data	= req->ki_user_data;
+	event->res	= req->ki_res;
+	event->res2	= req->ki_res2;
 
 	kunmap_atomic(ev_page);
 	flush_dcache_page(ctx->ring_pages[pos / AIO_EVENTS_PER_PAGE]);
 
 	pr_debug("%p[%u]: %p: %p %Lx %lx %lx\n",
-		 ctx, tail, iocb, iocb->ki_obj.user, iocb->ki_user_data,
-		 res, res2);
+		 ctx, tail, req, req->ki_obj.user, req->ki_user_data,
+		 req->ki_res, req->ki_res2);
 
-	/* after flagging the request as done, we
-	 * must never even look at it again
-	 */
-	smp_wmb();	/* make event visible before updating tail */
+	return tail;
+}
+
+static inline void kioctx_ring_unlock(struct kioctx *ctx, unsigned tail)
+{
+	struct aio_ring *ring;
+
+	if (!ctx)
+		return;
+
+	smp_wmb();
+	/* make event visible before updating tail */
 
 	ctx->tail = tail;
 
@@ -739,20 +704,7 @@ void aio_complete(struct kiocb *iocb, long res, long res2)
 	kunmap_atomic(ring);
 	flush_dcache_page(ctx->ring_pages[0]);
 
-	spin_unlock_irqrestore(&ctx->completion_lock, flags);
-
-	pr_debug("added to ring %p at [%u]\n", iocb, tail);
-
-	/*
-	 * Check if the user asked us to deliver the result through an
-	 * eventfd. The eventfd_signal() function is safe to be called
-	 * from IRQ context.
-	 */
-	if (iocb->ki_eventfd != NULL)
-		eventfd_signal(iocb->ki_eventfd, 1);
-
-	/* everything turned out well, dispose of the aiocb. */
-	kiocb_free(iocb);
+	spin_unlock(&ctx->completion_lock);
 
 	/*
 	 * We have to order our ring_info tail store above and test
@@ -762,12 +714,108 @@ void aio_complete(struct kiocb *iocb, long res, long res2)
 	 */
 	smp_mb();
 
-	if (waitqueue_active(&ctx->wait))
-		wake_up(&ctx->wait);
+	if (waitqueue_active(&ctx->wait)) {
+		/* Irqs are already disabled */
+		spin_lock(&ctx->wait.lock);
+		wake_up_locked(&ctx->wait);
+		spin_unlock(&ctx->wait.lock);
+	}
+}
+
+void batch_complete_aio(struct batch_complete *batch)
+{
+	struct kioctx *ctx = NULL;
+	struct kiocb *req, *next;
+	unsigned long flags;
+	unsigned tail = 0;
+
+	/*
+	 * Take rcu_read_lock() in case the kioctx is being destroyed, as we
+	 * need to issue a wakeup after incrementing reqs_available.
+	 */
+	rcu_read_lock();
+	local_irq_save(flags);
+
+	for (req = batch->kiocb; req; req = req->ki_next) {
+		if (req->ki_ctx != ctx) {
+			kioctx_ring_unlock(ctx, tail);
 
+			ctx = req->ki_ctx;
+			spin_lock(&ctx->completion_lock);
+			tail = ctx->tail;
+		}
+
+		tail = kioctx_ring_put(ctx, req, tail);
+	}
+
+	kioctx_ring_unlock(ctx, tail);
+	local_irq_restore(flags);
 	rcu_read_unlock();
+
+	for (req = batch->kiocb; req; req = next) {
+		next = req->ki_next;
+
+		if (req->ki_eventfd)
+			eventfd_signal(req->ki_eventfd, 1);
+
+		kiocb_free(req);
+	}
+}
+EXPORT_SYMBOL(batch_complete_aio);
+
+/* aio_complete_batch
+ *	Called when the io request on the given iocb is complete; @batch may be
+ *	NULL.
+ */
+void aio_complete_batch(struct kiocb *req, long res, long res2,
+			struct batch_complete *batch)
+{
+	req->ki_res = res;
+	req->ki_res2 = res2;
+
+	if (req->ki_list.next) {
+		struct kioctx *ctx = req->ki_ctx;
+		unsigned long flags;
+
+		spin_lock_irqsave(&ctx->ctx_lock, flags);
+		list_del(&req->ki_list);
+		spin_unlock_irqrestore(&ctx->ctx_lock, flags);
+	}
+
+	/*
+	 * Special case handling for sync iocbs:
+	 *  - events go directly into the iocb for fast handling
+	 *  - the sync task with the iocb in its stack holds the single iocb
+	 *    ref, no other paths have a way to get another ref
+	 *  - the sync task helpfully left a reference to itself in the iocb
+	 */
+	if (is_sync_kiocb(req)) {
+		req->ki_user_data = req->ki_res;
+		smp_wmb();
+		req->ki_ctx = ERR_PTR(-EXDEV);
+		wake_up_process(req->ki_obj.tsk);
+	} else if (batch) {
+		unsigned i = 0;
+		struct kiocb **p = &batch->kiocb;
+
+		while (*p && (*p)->ki_ctx > req->ki_ctx) {
+			p = &(*p)->ki_next;
+			if (++i == 16) {
+				batch_complete_aio(batch);
+				batch->kiocb = req;
+				return;
+			}
+		}
+
+		req->ki_next = *p;
+		*p = req;
+	} else {
+		struct batch_complete batch_stack = { .kiocb = req };
+
+		batch_complete_aio(&batch_stack);
+	}
 }
-EXPORT_SYMBOL(aio_complete);
+EXPORT_SYMBOL(aio_complete_batch);
 
 /* aio_read_events
  *	Pull an event off of the ioctx's event ring.  Returns the number of
diff --git a/fs/bio.c b/fs/bio.c
index e082907..8489d7a 100644
--- a/fs/bio.c
+++ b/fs/bio.c
@@ -28,6 +28,7 @@
 #include <linux/mempool.h>
 #include <linux/workqueue.h>
 #include <linux/cgroup.h>
+#include <linux/aio.h>
 #include <scsi/sg.h>		/* for struct sg_iovec */
 
 #include <trace/events/block.h>
@@ -1688,31 +1689,41 @@ void bio_flush_dcache_pages(struct bio *bi)
 EXPORT_SYMBOL(bio_flush_dcache_pages);
 #endif
 
-/**
- * bio_endio - end I/O on a bio
- * @bio:	bio
- * @error:	error, if any
- *
- * Description:
- *   bio_endio() will end I/O on the whole bio. bio_endio() is the
- *   preferred way to end I/O on a bio, it takes care of clearing
- *   BIO_UPTODATE on error. @error is 0 on success, and and one of the
- *   established -Exxxx (-EIO, for instance) error values in case
- *   something went wrong. No one should call bi_end_io() directly on a
- *   bio unless they own it and thus know that it has an end_io
- *   function.
- **/
-void bio_endio(struct bio *bio, int error)
+static inline void __bio_endio(struct bio *bio, struct batch_complete *batch)
 {
-	if (error)
+	if (bio->bi_error)
 		clear_bit(BIO_UPTODATE, &bio->bi_flags);
 	else if (!test_bit(BIO_UPTODATE, &bio->bi_flags))
-		error = -EIO;
+		bio->bi_error = -EIO;
 
 	if (bio->bi_end_io)
-		bio->bi_end_io(bio, error, NULL);
+		bio->bi_end_io(bio, bio->bi_error, batch);
+}
+
+void bio_endio_batch(struct bio *bio, int error, struct batch_complete *batch)
+{
+	if (error)
+		bio->bi_error = error;
+
+	if (batch)
+		bio_list_add(&batch->bio, bio);
+	else
+		__bio_endio(bio, batch);
+
+}
+EXPORT_SYMBOL(bio_endio_batch);
+
+void batch_complete(struct batch_complete *batch)
+{
+	struct bio *bio;
+
+	while ((bio = bio_list_pop(&batch->bio)))
+		__bio_endio(bio, batch);
+
+	if (batch->kiocb)
+		batch_complete_aio(batch);
 }
-EXPORT_SYMBOL(bio_endio);
+EXPORT_SYMBOL(batch_complete);
 
 void bio_pair_release(struct bio_pair *bp)
 {
diff --git a/fs/direct-io.c b/fs/direct-io.c
index 331fd5c..b4dd97c 100644
--- a/fs/direct-io.c
+++ b/fs/direct-io.c
@@ -230,7 +230,8 @@ static inline struct page *dio_get_page(struct dio *dio,
  * filesystems can use it to hold additional state between get_block calls and
  * dio_complete.
  */
-static ssize_t dio_complete(struct dio *dio, loff_t offset, ssize_t ret, bool is_async)
+static ssize_t dio_complete(struct dio *dio, loff_t offset, ssize_t ret,
+			    bool is_async, struct batch_complete *batch)
 {
 	ssize_t transferred = 0;
 
@@ -264,7 +265,7 @@ static ssize_t dio_complete(struct dio *dio, loff_t offset, ssize_t ret, bool is
 	} else {
 		inode_dio_done(dio->inode);
 		if (is_async)
-			aio_complete(dio->iocb, ret, 0);
+			aio_complete_batch(dio->iocb, ret, 0, batch);
 	}
 
 	return ret;
@@ -274,7 +275,8 @@ static int dio_bio_complete(struct dio *dio, struct bio *bio);
 /*
  * Asynchronous IO callback. 
  */
-static void dio_bio_end_aio(struct bio *bio, int error)
+static void dio_bio_end_aio(struct bio *bio, int error,
+			    struct batch_complete *batch)
 {
 	struct dio *dio = bio->bi_private;
 	unsigned long remaining;
@@ -290,7 +292,7 @@ static void dio_bio_end_aio(struct bio *bio, int error)
 	spin_unlock_irqrestore(&dio->bio_lock, flags);
 
 	if (remaining == 0) {
-		dio_complete(dio, dio->iocb->ki_pos, 0, true);
+		dio_complete(dio, dio->iocb->ki_pos, 0, true, batch);
 		kmem_cache_free(dio_cache, dio);
 	}
 }
@@ -1265,7 +1267,7 @@ do_blockdev_direct_IO(int rw, struct kiocb *iocb, struct inode *inode,
 		dio_await_completion(dio);
 
 	if (drop_refcount(dio) == 0) {
-		retval = dio_complete(dio, offset, retval, false);
+		retval = dio_complete(dio, offset, retval, false, NULL);
 		kmem_cache_free(dio_cache, dio);
 	} else
 		BUG_ON(retval != -EIOCBQUEUED);
diff --git a/include/linux/aio.h b/include/linux/aio.h
index d9c92da..a6fe048 100644
--- a/include/linux/aio.h
+++ b/include/linux/aio.h
@@ -6,11 +6,12 @@
 #include <linux/aio_abi.h>
 #include <linux/uio.h>
 #include <linux/rcupdate.h>
-
 #include <linux/atomic.h>
+#include <linux/batch_complete.h>
 
 struct kioctx;
 struct kiocb;
+struct batch_complete;
 
 #define KIOCB_KEY		0
 
@@ -30,6 +31,8 @@ struct kiocb;
 typedef int (kiocb_cancel_fn)(struct kiocb *);
 
 struct kiocb {
+	struct kiocb		*ki_next;	/* batch completion */
+
 	struct file		*ki_filp;
 	struct kioctx		*ki_ctx;	/* NULL for sync ops */
 	kiocb_cancel_fn		*ki_cancel;
@@ -41,6 +44,9 @@ struct kiocb {
 	} ki_obj;
 
 	__u64			ki_user_data;	/* user's data for completion */
+	long			ki_res;
+	long			ki_res2;
+
 	loff_t			ki_pos;
 	size_t			ki_nbytes;	/* copy of iocb->aio_nbytes */
 
@@ -71,7 +77,9 @@ static inline void init_sync_kiocb(struct kiocb *kiocb, struct file *filp)
 /* prototypes */
 #ifdef CONFIG_AIO
 extern ssize_t wait_on_sync_kiocb(struct kiocb *iocb);
-extern void aio_complete(struct kiocb *iocb, long res, long res2);
+extern void batch_complete_aio(struct batch_complete *batch);
+extern void aio_complete_batch(struct kiocb *iocb, long res, long res2,
+			       struct batch_complete *batch);
 struct mm_struct;
 extern void exit_aio(struct mm_struct *mm);
 extern long do_io_submit(aio_context_t ctx_id, long nr,
@@ -79,7 +87,12 @@ extern long do_io_submit(aio_context_t ctx_id, long nr,
 void kiocb_set_cancel_fn(struct kiocb *req, kiocb_cancel_fn *cancel);
 #else
 static inline ssize_t wait_on_sync_kiocb(struct kiocb *iocb) { return 0; }
-static inline void aio_complete(struct kiocb *iocb, long res, long res2) { }
+static inline void batch_complete_aio(struct batch_complete *batch) { }
+static inline void aio_complete_batch(struct kiocb *iocb, long res, long res2,
+				      struct batch_complete *batch)
+{
+	return;
+}
 struct mm_struct;
 static inline void exit_aio(struct mm_struct *mm) { }
 static inline long do_io_submit(aio_context_t ctx_id, long nr,
@@ -89,6 +102,11 @@ static inline void kiocb_set_cancel_fn(struct kiocb *req,
 				       kiocb_cancel_fn *cancel) { }
 #endif /* CONFIG_AIO */
 
+static inline void aio_complete(struct kiocb *iocb, long res, long res2)
+{
+	aio_complete_batch(iocb, res, res2, NULL);
+}
+
 static inline struct kiocb *list_kiocb(struct list_head *h)
 {
 	return list_entry(h, struct kiocb, ki_list);
diff --git a/include/linux/batch_complete.h b/include/linux/batch_complete.h
new file mode 100644
index 0000000..298baeb
--- /dev/null
+++ b/include/linux/batch_complete.h
@@ -0,0 +1,22 @@
+#ifndef _LINUX_BATCH_COMPLETE_H
+#define _LINUX_BATCH_COMPLETE_H
+
+/*
+ * Common stuff to the aio and block code for batch completion. Everything
+ * important is elsewhere:
+ */
+
+struct bio;
+struct kiocb;
+
+struct bio_list {
+	struct bio *head;
+	struct bio *tail;
+};
+
+struct batch_complete {
+	struct bio_list		bio;
+	struct kiocb		*kiocb;
+};
+
+#endif
diff --git a/include/linux/bio.h b/include/linux/bio.h
index 7f3089f..1c72bfa 100644
--- a/include/linux/bio.h
+++ b/include/linux/bio.h
@@ -24,6 +24,7 @@
 #include <linux/mempool.h>
 #include <linux/ioprio.h>
 #include <linux/bug.h>
+#include <linux/batch_complete.h>
 
 #ifdef CONFIG_BLOCK
 
@@ -69,6 +70,8 @@
 #define bio_sectors(bio)	((bio)->bi_size >> 9)
 #define bio_end_sector(bio)	((bio)->bi_sector + bio_sectors((bio)))
 
+void bio_endio_batch(struct bio *bio, int error, struct batch_complete *batch);
+
 static inline unsigned int bio_cur_bytes(struct bio *bio)
 {
 	if (bio->bi_vcnt)
@@ -252,7 +255,25 @@ static inline struct bio *bio_clone_kmalloc(struct bio *bio, gfp_t gfp_mask)
 
 }
 
-extern void bio_endio(struct bio *, int);
+/**
+ * bio_endio - end I/O on a bio
+ * @bio:	bio
+ * @error:	error, if any
+ *
+ * Description:
+ *   bio_endio() will end I/O on the whole bio. bio_endio() is the
+ *   preferred way to end I/O on a bio, it takes care of clearing
+ *   BIO_UPTODATE on error. @error is 0 on success, and and one of the
+ *   established -Exxxx (-EIO, for instance) error values in case
+ *   something went wrong. No one should call bi_end_io() directly on a
+ *   bio unless they own it and thus know that it has an end_io
+ *   function.
+ **/
+static inline void bio_endio(struct bio *bio, int error)
+{
+	bio_endio_batch(bio, error, NULL);
+}
+
 struct request_queue;
 extern int bio_phys_segments(struct request_queue *, struct bio *);
 
@@ -404,10 +425,6 @@ static inline bool bio_mergeable(struct bio *bio)
  * member of the bio.  The bio_list also caches the last list member to allow
  * fast access to the tail.
  */
-struct bio_list {
-	struct bio *head;
-	struct bio *tail;
-};
 
 static inline int bio_list_empty(const struct bio_list *bl)
 {
@@ -554,6 +571,15 @@ struct biovec_slab {
  */
 #define BIO_SPLIT_ENTRIES 2
 
+static inline void batch_complete_init(struct batch_complete *batch)
+{
+	bio_list_init(&batch->bio);
+	batch->kiocb = NULL;
+}
+
+void batch_complete(struct batch_complete *batch);
+
+
 #if defined(CONFIG_BLK_DEV_INTEGRITY)
 
 #define bip_vec_idx(bip, idx)	(&(bip->bip_vec[(idx)]))
diff --git a/include/linux/blk_types.h b/include/linux/blk_types.h
index b3195e3..9d3cafa 100644
--- a/include/linux/blk_types.h
+++ b/include/linux/blk_types.h
@@ -43,6 +43,7 @@ struct bio {
 						 * top bits priority
 						 */
 
+	short			bi_error;
 	unsigned short		bi_vcnt;	/* how many bio_vec's */
 	unsigned short		bi_idx;		/* current index into bvl_vec */
 
diff --git a/include/linux/blkdev.h b/include/linux/blkdev.h
index 2fdb4a4..ddc2f80 100644
--- a/include/linux/blkdev.h
+++ b/include/linux/blkdev.h
@@ -883,7 +883,8 @@ extern struct request *blk_fetch_request(struct request_queue *q);
  * This prevents code duplication in drivers.
  */
 extern bool blk_update_request(struct request *rq, int error,
-			       unsigned int nr_bytes);
+			       unsigned int nr_bytes,
+			       struct batch_complete *batch);
 extern bool blk_end_request(struct request *rq, int error,
 			    unsigned int nr_bytes);
 extern void blk_end_request_all(struct request *rq, int error);
@@ -891,10 +892,17 @@ extern bool blk_end_request_cur(struct request *rq, int error);
 extern bool blk_end_request_err(struct request *rq, int error);
 extern bool __blk_end_request(struct request *rq, int error,
 			      unsigned int nr_bytes);
-extern void __blk_end_request_all(struct request *rq, int error);
 extern bool __blk_end_request_cur(struct request *rq, int error);
 extern bool __blk_end_request_err(struct request *rq, int error);
 
+extern void blk_end_request_all_batch(struct request *rq, int error,
+				      struct batch_complete *batch);
+
+static inline void __blk_end_request_all(struct request *rq, int error)
+{
+	blk_end_request_all_batch(rq, error, NULL);
+}
+
 extern void blk_complete_request(struct request *);
 extern void __blk_complete_request(struct request *);
 extern void blk_abort_request(struct request *);
-- 
1.8.2.1

