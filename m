Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752833Ab3CRNdd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Mar 2013 09:33:33 -0400
Received: from mail-wg0-f42.google.com ([74.125.82.42]:62802 "EHLO
	mail-wg0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751190Ab3CRNdc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Mar 2013 09:33:32 -0400
Date: Mon, 18 Mar 2013 14:33:28 +0100
From: Stephane Eranian <eranian@google.com>
To: linux-kernel@vger.kernel.org
Cc: peterz@infradead.org, mingo@elte.hu, jolsa@redhat.com, fweisbec@gmail.com
Subject: [PATCH v2] perf: fix ring_buffer perf_output_space() boundary
 calculation
Message-ID: <20130318133327.GA3056@quad>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


This patch fixes a flaw in perf_output_space(). In case the size
of the space needed is bigger than the actual buffer size, there
may be situations where the function would return true (i.e., there
is space) when it should not. head > offset due to rounding of the
masking logic.

The problem can be tested by activating BTS on Intel processors.
A BTS record can be as big as 16 pages. The following command
fails:

$ perf record -m 4 -c 1 -e branches:u my_test_program

You will get a buffer corruption with this. Perf report won't be
able to parse the perf.data.

The fix is to first check that the requested space is smaller than the
buffer size. If so, then the masking logic will work fine. If not, then
there is no chance the record can be saved and it will be gracefully handled
by upper code layers.

In v2, we also make the logic for the writable more explicit by
renaming it to rb->overwrite because it tells whether or not the
buffer can overwrite its tail (suggested by PeterZ).

Signed-off-by: Stephane Eranian <eranian@google.com>
---

diff --git a/kernel/events/internal.h b/kernel/events/internal.h
index d56a64c..eb675c4 100644
--- a/kernel/events/internal.h
+++ b/kernel/events/internal.h
@@ -16,7 +16,7 @@ struct ring_buffer {
 	int				page_order;	/* allocation order  */
 #endif
 	int				nr_pages;	/* nr of data pages  */
-	int				writable;	/* are we writable   */
+	int				overwrite;	/* can overwrite itself */
 
 	atomic_t			poll;		/* POLL_ for wakeups */
 
diff --git a/kernel/events/ring_buffer.c b/kernel/events/ring_buffer.c
index 23cb34f..f52d1e7 100644
--- a/kernel/events/ring_buffer.c
+++ b/kernel/events/ring_buffer.c
@@ -18,12 +18,24 @@
 static bool perf_output_space(struct ring_buffer *rb, unsigned long tail,
 			      unsigned long offset, unsigned long head)
 {
-	unsigned long mask;
+	unsigned long sz = perf_data_size(rb);
+	unsigned long mask = sz - 1;
 
-	if (!rb->writable)
+	/*
+	 * check if user-writable
+	 * overwrite : over-write its own tail
+	 * !overwrite: buffer possibly drops events.
+	 */
+	if (rb->overwrite)
 		return true;
 
-	mask = perf_data_size(rb) - 1;
+	/*
+	 * verify that payload is not bigger than buffer
+	 * otherwise masking logic may fail to detect
+	 * the "not enough space" condition
+	 */
+	if ((head - offset) > sz)
+		return false;
 
 	offset = (offset - tail) & mask;
 	head   = (head   - tail) & mask;
@@ -212,7 +224,9 @@ ring_buffer_init(struct ring_buffer *rb, long watermark, int flags)
 		rb->watermark = max_size / 2;
 
 	if (flags & RING_BUFFER_WRITABLE)
-		rb->writable = 1;
+		rb->overwrite = 0;
+	else
+		rb->overwrite = 1;
 
 	atomic_set(&rb->refcount, 1);
 
