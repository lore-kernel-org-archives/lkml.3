Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753987Ab3FFF6W (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Jun 2013 01:58:22 -0400
Received: from mga14.intel.com ([143.182.124.37]:28278 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753808Ab3FFF6S (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Jun 2013 01:58:18 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.87,812,1363158000"; 
   d="scan'208";a="313052939"
From: "Yan, Zheng" <zheng.z.yan@intel.com>
To: linux-kernel@vger.kernel.org
Cc: peterz@infradead.org, mingo@elte.hu, eranian@google.com,
        ak@linux.intel.com, "Yan, Zheng" <zheng.z.yan@intel.com>
Subject: [PATCH] perf: Update event buffer tail when overwriting old events
Date: Thu,  6 Jun 2013 13:58:06 +0800
Message-Id: <1370498286-12801-1-git-send-email-zheng.z.yan@intel.com>
X-Mailer: git-send-email 1.8.1.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Yan, Zheng" <zheng.z.yan@intel.com>

If perf event buffer is in overwrite mode, the kernel only updates
the data head when it overwrites old samples. The program that owns
the buffer need periodically check the buffer and update a variable
that tracks the date tail. If the program fails to do this in time,
the data tail can be overwritted by new samples. The program has to
rewind the buffer because it does not know where is the first vaild
sample.

This patch makes the kernel update the date tail when it overwrites
old events. So the program that owns the event buffer can always
read the latest samples. This is convenient for programs that use
perf to do branch tracing. One use case is GDB branch tracing:
(http://sourceware.org/ml/gdb-patches/2012-06/msg00172.html)
It uses perf interface to read BTS, but only cares the branches
before the ptrace event.

I added code to perf_output_{begin/end} to count how many cycles
are spent by sample output, then ran "perf record" to profile kernel
compilation 10 times on IvyBridge-EP. (perf record -a make -j 60)
The first number is scaled to 1000, the rest numbers are scaled by
the same factor.

        before   overwrite mode      after   overwrite mode
AVG      1000        999             1046        1044
STDEV    19.4        19.5            17.1        17.9

Signed-off-by: Yan, Zheng <zheng.z.yan@intel.com>
---
 kernel/events/internal.h    |  2 ++
 kernel/events/ring_buffer.c | 74 ++++++++++++++++++++++++---------------------
 2 files changed, 42 insertions(+), 34 deletions(-)

diff --git a/kernel/events/internal.h b/kernel/events/internal.h
index eb675c4..c6d7539 100644
--- a/kernel/events/internal.h
+++ b/kernel/events/internal.h
@@ -20,6 +20,8 @@ struct ring_buffer {
 
 	atomic_t			poll;		/* POLL_ for wakeups */
 
+	local_t				tail;		/* read position     */
+	local_t				next_tail;	/* next read position */
 	local_t				head;		/* write position    */
 	local_t				nest;		/* nested writers    */
 	local_t				events;		/* event limit       */
diff --git a/kernel/events/ring_buffer.c b/kernel/events/ring_buffer.c
index cd55144..2d5b15e 100644
--- a/kernel/events/ring_buffer.c
+++ b/kernel/events/ring_buffer.c
@@ -15,28 +15,9 @@
 
 #include "internal.h"
 
-static bool perf_output_space(struct ring_buffer *rb, unsigned long tail,
-			      unsigned long offset, unsigned long head)
+static bool perf_output_space(unsigned long tail, unsigned long offset,
+			      unsigned long head, unsigned long mask)
 {
-	unsigned long sz = perf_data_size(rb);
-	unsigned long mask = sz - 1;
-
-	/*
-	 * check if user-writable
-	 * overwrite : over-write its own tail
-	 * !overwrite: buffer possibly drops events.
-	 */
-	if (rb->overwrite)
-		return true;
-
-	/*
-	 * verify that payload is not bigger than buffer
-	 * otherwise masking logic may fail to detect
-	 * the "not enough space" condition
-	 */
-	if ((head - offset) > sz)
-		return false;
-
 	offset = (offset - tail) & mask;
 	head   = (head   - tail) & mask;
 
@@ -113,7 +94,7 @@ int perf_output_begin(struct perf_output_handle *handle,
 		      struct perf_event *event, unsigned int size)
 {
 	struct ring_buffer *rb;
-	unsigned long tail, offset, head;
+	unsigned long tail, offset, head, max_size;
 	int have_lost;
 	struct perf_sample_data sample_data;
 	struct {
@@ -136,7 +117,8 @@ int perf_output_begin(struct perf_output_handle *handle,
 	handle->rb	= rb;
 	handle->event	= event;
 
-	if (!rb->nr_pages)
+	max_size = perf_data_size(rb);
+	if (size > max_size)
 		goto out;
 
 	have_lost = local_read(&rb->lost);
@@ -149,19 +131,43 @@ int perf_output_begin(struct perf_output_handle *handle,
 
 	perf_output_get_handle(handle);
 
-	do {
+	if (rb->overwrite) {
+		do {
+			tail = local_read(&rb->tail);
+			offset = local_read(&rb->head);
+			head = offset + size;
+			if (unlikely(!perf_output_space(tail, offset, head,
+						        max_size - 1))) {
+				tail = local_read(&rb->next_tail);
+				local_set(&rb->tail, tail);
+				rb->user_page->data_tail = tail;
+			}
+		} while (local_cmpxchg(&rb->head, offset, head) != offset);
+
 		/*
-		 * Userspace could choose to issue a mb() before updating the
-		 * tail pointer. So that all reads will be completed before the
-		 * write is issued.
+		 * Save the start of next event when half of the buffer
+		 * has been filled. Later when the event buffer overflows,
+		 * update the tail pointer to point to it.
 		 */
-		tail = ACCESS_ONCE(rb->user_page->data_tail);
-		smp_rmb();
-		offset = head = local_read(&rb->head);
-		head += size;
-		if (unlikely(!perf_output_space(rb, tail, offset, head)))
-			goto fail;
-	} while (local_cmpxchg(&rb->head, offset, head) != offset);
+		if (tail == local_read(&rb->next_tail) &&
+		    head - tail >= (max_size >> 1))
+			local_cmpxchg(&rb->next_tail, tail, head);
+	} else {
+		do {
+			/*
+			 * Userspace could choose to issue a mb() before
+			 * updating the tail pointer. So that all reads will
+			 * be completed before the write is issued.
+			 */
+			tail = ACCESS_ONCE(rb->user_page->data_tail);
+			smp_rmb();
+			offset = local_read(&rb->head);
+			head = offset + size;
+			if (unlikely(!perf_output_space(tail, offset, head,
+							max_size - 1)))
+				goto fail;
+		} while (local_cmpxchg(&rb->head, offset, head) != offset);
+	}
 
 	if (head - local_read(&rb->wakeup) > rb->watermark)
 		local_add(rb->watermark, &rb->wakeup);
-- 
1.8.1.4

