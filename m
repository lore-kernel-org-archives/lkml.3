Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934331Ab3CUQgb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Mar 2013 12:36:31 -0400
Received: from mail-pb0-f45.google.com ([209.85.160.45]:35355 "EHLO
	mail-pb0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934288Ab3CUQgZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Mar 2013 12:36:25 -0400
From: Kent Overstreet <koverstreet@google.com>
To: linux-kernel@vger.kernel.org, linux-aio@kvack.org,
        akpm@linux-foundation.org
Cc: Kent Overstreet <koverstreet@google.com>, Zach Brown <zab@redhat.com>,
        Felipe Balbi <balbi@ti.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Mark Fasheh <mfasheh@suse.com>, Joel Becker <jlbec@evilplan.org>,
        Rusty Russell <rusty@rustcorp.com.au>, Jens Axboe <axboe@kernel.dk>,
        Asai Thambi S P <asamymuthupa@micron.com>,
        Selvan Mani <smani@micron.com>, Sam Bradshaw <sbradshaw@micron.com>,
        Jeff Moyer <jmoyer@redhat.com>, Al Viro <viro@zeniv.linux.org.uk>,
        Benjamin LaHaise <bcrl@kvack.org>
Subject: [PATCH 15/33] aio: use flush_dcache_page()
Date: Thu, 21 Mar 2013 09:35:36 -0700
Message-Id: <1363883754-27966-16-git-send-email-koverstreet@google.com>
X-Mailer: git-send-email 1.8.1.3
In-Reply-To: <1363883754-27966-1-git-send-email-koverstreet@google.com>
References: <1363883754-27966-1-git-send-email-koverstreet@google.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

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
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---
 fs/aio.c | 45 +++++++++++++++++----------------------------
 1 file changed, 17 insertions(+), 28 deletions(-)

diff --git a/fs/aio.c b/fs/aio.c
index e9511d4..ed9d3a3 100644
--- a/fs/aio.c
+++ b/fs/aio.c
@@ -211,33 +211,15 @@ static int aio_setup_ring(struct kioctx *ctx)
 	ring->incompat_features = AIO_RING_INCOMPAT_FEATURES;
 	ring->header_length = sizeof(struct aio_ring);
 	kunmap_atomic(ring);
+	flush_dcache_page(info->ring_pages[0]);
 
 	return 0;
 }
 
-
-/* aio_ring_event: returns a pointer to the event at the given index from
- * kmap_atomic().  Release the pointer with put_aio_ring_event();
- */
 #define AIO_EVENTS_PER_PAGE	(PAGE_SIZE / sizeof(struct io_event))
 #define AIO_EVENTS_FIRST_PAGE	((PAGE_SIZE - sizeof(struct aio_ring)) / sizeof(struct io_event))
 #define AIO_EVENTS_OFFSET	(AIO_EVENTS_PER_PAGE - AIO_EVENTS_FIRST_PAGE)
 
-#define aio_ring_event(info, nr) ({					\
-	unsigned pos = (nr) + AIO_EVENTS_OFFSET;			\
-	struct io_event *__event;					\
-	__event = kmap_atomic(						\
-			(info)->ring_pages[pos / AIO_EVENTS_PER_PAGE]); \
-	__event += pos % AIO_EVENTS_PER_PAGE;				\
-	__event;							\
-})
-
-#define put_aio_ring_event(event) do {		\
-	struct io_event *__event = (event);	\
-	(void)__event;				\
-	kunmap_atomic((void *)((unsigned long)__event & PAGE_MASK)); \
-} while(0)
-
 static int kiocb_cancel(struct kioctx *ctx, struct kiocb *kiocb,
 			struct io_event *res)
 {
@@ -648,9 +630,9 @@ void aio_complete(struct kiocb *iocb, long res, long res2)
 	struct kioctx	*ctx = iocb->ki_ctx;
 	struct aio_ring_info	*info;
 	struct aio_ring	*ring;
-	struct io_event	*event;
+	struct io_event	*ev_page, *event;
 	unsigned long	flags;
-	unsigned long	tail;
+	unsigned tail, pos;
 
 	/*
 	 * Special case handling for sync iocbs:
@@ -689,19 +671,24 @@ void aio_complete(struct kiocb *iocb, long res, long res2)
 	if (kiocbIsCancelled(iocb))
 		goto put_rq;
 
-	ring = kmap_atomic(info->ring_pages[0]);
-
 	tail = info->tail;
-	event = aio_ring_event(info, tail);
+	pos = tail + AIO_EVENTS_OFFSET;
+
 	if (++tail >= info->nr)
 		tail = 0;
 
+	ev_page = kmap_atomic(info->ring_pages[pos / AIO_EVENTS_PER_PAGE]);
+	event = ev_page + pos % AIO_EVENTS_PER_PAGE;
+
 	event->obj = (u64)(unsigned long)iocb->ki_obj.user;
 	event->data = iocb->ki_user_data;
 	event->res = res;
 	event->res2 = res2;
 
-	pr_debug("%p[%lu]: %p: %p %Lx %lx %lx\n",
+	kunmap_atomic(ev_page);
+	flush_dcache_page(info->ring_pages[pos / AIO_EVENTS_PER_PAGE]);
+
+	pr_debug("%p[%u]: %p: %p %Lx %lx %lx\n",
 		 ctx, tail, iocb, iocb->ki_obj.user, iocb->ki_user_data,
 		 res, res2);
 
@@ -711,12 +698,13 @@ void aio_complete(struct kiocb *iocb, long res, long res2)
 	smp_wmb();	/* make event visible before updating tail */
 
 	info->tail = tail;
-	ring->tail = tail;
 
-	put_aio_ring_event(event);
+	ring = kmap_atomic(info->ring_pages[0]);
+	ring->tail = tail;
 	kunmap_atomic(ring);
+	flush_dcache_page(info->ring_pages[0]);
 
-	pr_debug("added to ring %p at [%lu]\n", iocb, tail);
+	pr_debug("added to ring %p at [%u]\n", iocb, tail);
 
 	/*
 	 * Check if the user asked us to deliver the result through an
@@ -804,6 +792,7 @@ static long aio_read_events_ring(struct kioctx *ctx,
 	ring = kmap_atomic(info->ring_pages[0]);
 	ring->head = head;
 	kunmap_atomic(ring);
+	flush_dcache_page(info->ring_pages[0]);
 
 	pr_debug("%li  h%u t%u\n", ret, head, info->tail);
 out:
-- 
1.8.1.3

