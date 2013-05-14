Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755692Ab3ENBTR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 May 2013 21:19:17 -0400
Received: from mail-da0-f54.google.com ([209.85.210.54]:62634 "EHLO
	mail-da0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755805Ab3ENBTO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 May 2013 21:19:14 -0400
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
        Benjamin LaHaise <bcrl@kvack.org>
Subject: [PATCH 07/21] aio: Don't use ctx->tail unnecessarily
Date: Mon, 13 May 2013 18:18:44 -0700
Message-Id: <1368494338-7069-8-git-send-email-koverstreet@google.com>
X-Mailer: git-send-email 1.8.2.1
In-Reply-To: <1368494338-7069-1-git-send-email-koverstreet@google.com>
References: <1368494338-7069-1-git-send-email-koverstreet@google.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

aio_complete() (arguably) needs to keep its own trusted copy of the tail
pointer, but io_getevents() doesn't have to use it - it's already using
the head pointer from the ring buffer.

So convert it to use the tail from the ring buffer so it touches fewer
cachelines and doesn't contend with the cacheline aio_complete() needs.

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
---
 fs/aio.c | 41 +++++++++++++++++++++++------------------
 1 file changed, 23 insertions(+), 18 deletions(-)

diff --git a/fs/aio.c b/fs/aio.c
index 5e1b801..2c9a5ac 100644
--- a/fs/aio.c
+++ b/fs/aio.c
@@ -306,7 +306,8 @@ static void free_ioctx(struct kioctx *ctx)
 {
 	struct aio_ring *ring;
 	struct kiocb *req;
-	unsigned cpu, head, avail;
+	unsigned cpu, avail;
+	DEFINE_WAIT(wait);
 
 	spin_lock_irq(&ctx->ctx_lock);
 
@@ -327,21 +328,24 @@ static void free_ioctx(struct kioctx *ctx)
 		kcpu->reqs_available = 0;
 	}
 
-	ring = kmap_atomic(ctx->ring_pages[0]);
-	head = ring->head;
-	kunmap_atomic(ring);
+	while (1) {
+		prepare_to_wait(&ctx->wait, &wait, TASK_UNINTERRUPTIBLE);
 
-	while (atomic_read(&ctx->reqs_available) < ctx->nr_events - 1) {
-		wait_event(ctx->wait,
-			   (head != ctx->tail) ||
-			   (atomic_read(&ctx->reqs_available) >= ctx->nr_events - 1));
-
-		avail = (head <= ctx->tail ? ctx->tail : ctx->nr_events) - head;
+		ring = kmap_atomic(ctx->ring_pages[0]);
+		avail = (ring->head <= ring->tail)
+			 ? ring->tail - ring->head
+			 : ctx->nr_events - ring->head + ring->tail;
 
 		atomic_add(avail, &ctx->reqs_available);
-		head += avail;
-		head %= ctx->nr_events;
+		ring->head = ring->tail;
+		kunmap_atomic(ring);
+
+		if (atomic_read(&ctx->reqs_available) >= ctx->nr_events - 1)
+			break;
+
+		schedule();
 	}
+	finish_wait(&ctx->wait, &wait);
 
 	WARN_ON(atomic_read(&ctx->reqs_available) > ctx->nr_events - 1);
 
@@ -782,7 +786,7 @@ static long aio_read_events_ring(struct kioctx *ctx,
 				 struct io_event __user *event, long nr)
 {
 	struct aio_ring *ring;
-	unsigned head, pos;
+	unsigned head, tail, pos;
 	long ret = 0;
 	int copy_ret;
 
@@ -790,11 +794,12 @@ static long aio_read_events_ring(struct kioctx *ctx,
 
 	ring = kmap_atomic(ctx->ring_pages[0]);
 	head = ring->head;
+	tail = ring->tail;
 	kunmap_atomic(ring);
 
-	pr_debug("h%u t%u m%u\n", head, ctx->tail, ctx->nr_events);
+	pr_debug("h%u t%u m%u\n", head, tail, ctx->nr_events);
 
-	if (head == ctx->tail)
+	if (head == tail)
 		goto out;
 
 	while (ret < nr) {
@@ -802,8 +807,8 @@ static long aio_read_events_ring(struct kioctx *ctx,
 		struct io_event *ev;
 		struct page *page;
 
-		avail = (head <= ctx->tail ? ctx->tail : ctx->nr_events) - head;
-		if (head == ctx->tail)
+		avail = (head <= tail ?  tail : ctx->nr_events) - head;
+		if (head == tail)
 			break;
 
 		avail = min(avail, nr - ret);
@@ -834,7 +839,7 @@ static long aio_read_events_ring(struct kioctx *ctx,
 	kunmap_atomic(ring);
 	flush_dcache_page(ctx->ring_pages[0]);
 
-	pr_debug("%li  h%u t%u\n", ret, head, ctx->tail);
+	pr_debug("%li  h%u t%u\n", ret, head, tail);
 
 	put_reqs_available(ctx, ret);
 out:
-- 
1.8.2.1

