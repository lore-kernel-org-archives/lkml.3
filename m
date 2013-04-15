Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934973Ab3DOGCu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Apr 2013 02:02:50 -0400
Received: from mga14.intel.com ([143.182.124.37]:49182 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932162Ab3DOGCt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Apr 2013 02:02:49 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.87,473,1363158000"; 
   d="scan'208";a="227182029"
From: "Yan, Zheng" <zheng.z.yan@intel.com>
To: linux-kernel@vger.kernel.org
Cc: peterz@infradead.org, mingo@elte.hu, eranian@google.com,
        ak@linux.intel.com, "Yan, Zheng" <zheng.z.yan@intel.com>
Subject: [RFC PATCH] perf: Update event buffer tail when overwriting old events
Date: Mon, 15 Apr 2013 14:02:41 +0800
Message-Id: <1366005761-3685-1-git-send-email-zheng.z.yan@intel.com>
X-Mailer: git-send-email 1.7.11.7
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
perf to do branch tracing. For example, debugger may want to know
the latest branches before the ptrace event, but it doesn't care
about old branchs samples.

Signed-off-by: Yan, Zheng <zheng.z.yan@intel.com>
---
 kernel/events/internal.h    |  1 +
 kernel/events/ring_buffer.c | 45 ++++++++++++++++++++++-----------------------
 2 files changed, 23 insertions(+), 23 deletions(-)

diff --git a/kernel/events/internal.h b/kernel/events/internal.h
index eb675c4..6f1ece2 100644
--- a/kernel/events/internal.h
+++ b/kernel/events/internal.h
@@ -21,6 +21,7 @@ struct ring_buffer {
 	atomic_t			poll;		/* POLL_ for wakeups */
 
 	local_t				head;		/* write position    */
+	local_t				tail;		/* read positon	     */
 	local_t				nest;		/* nested writers    */
 	local_t				events;		/* event limit       */
 	local_t				wakeup;		/* wakeup stamp      */
diff --git a/kernel/events/ring_buffer.c b/kernel/events/ring_buffer.c
index 97fddb0..fb164d7 100644
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
 
@@ -114,6 +95,7 @@ int perf_output_begin(struct perf_output_handle *handle,
 {
 	struct ring_buffer *rb;
 	unsigned long tail, offset, head;
+	unsigned long max_size;
 	int have_lost;
 	struct perf_sample_data sample_data;
 	struct {
@@ -133,6 +115,10 @@ int perf_output_begin(struct perf_output_handle *handle,
 	if (!rb)
 		goto out;
 
+	max_size = perf_data_size(rb);
+	if (size > max_size)
+		goto out;
+
 	handle->rb	= rb;
 	handle->event	= event;
 
@@ -159,10 +145,23 @@ int perf_output_begin(struct perf_output_handle *handle,
 		smp_rmb();
 		offset = head = local_read(&rb->head);
 		head += size;
-		if (unlikely(!perf_output_space(rb, tail, offset, head)))
-			goto fail;
+		if (!perf_output_space(tail, offset, head, max_size - 1)) {
+			if (!rb->overwrite)
+				goto fail;
+			tail = local_read(&rb->tail);
+			rb->user_page->data_tail = tail;
+		}
 	} while (local_cmpxchg(&rb->head, offset, head) != offset);
 
+	/*
+	 * Event buffer is half full, save the position of current event. Later
+	 * when the event buffer overflows, update the tail pointer to point to
+	 * this event.
+	 */
+	if (rb->overwrite && 
+	    tail == local_read(&rb->tail) && head - tail >= (max_size >> 1))
+		local_cmpxchg(&rb->tail, tail, head);
+
 	if (head - local_read(&rb->wakeup) > rb->watermark)
 		local_add(rb->watermark, &rb->wakeup);
 
-- 
1.7.11.7

