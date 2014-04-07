Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755572AbaDGPMu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Apr 2014 11:12:50 -0400
Received: from mail-ee0-f43.google.com ([74.125.83.43]:41387 "EHLO
	mail-ee0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754713AbaDGPE5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Apr 2014 11:04:57 -0400
From: Jean Pihet <jean.pihet@linaro.org>
To: Borislav Petkov <bp@alien8.de>, Peter Zijlstra <peterz@infradead.org>,
        Ingo Molnar <mingo@kernel.org>,
        Arnaldo Carvalho de Melo <acme@infradead.org>,
        Jiri Olsa <jolsa@redhat.com>, linux-kernel@vger.kernel.org,
        Robert Richter <rric@kernel.org>
Cc: Robert Richter <robert.richter@linaro.org>,
        Jean Pihet <jean.pihet@linaro.org>
Subject: [PATCH 01/16] perf, mmap: Factor out ring_buffer_detach_all()
Date: Mon,  7 Apr 2014 17:04:23 +0200
Message-Id: <1396883078-25320-2-git-send-email-jean.pihet@linaro.org>
X-Mailer: git-send-email 1.7.11.7
In-Reply-To: <1396883078-25320-1-git-send-email-jean.pihet@linaro.org>
References: <1396883078-25320-1-git-send-email-jean.pihet@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Robert Richter <robert.richter@linaro.org>

Factor out a function to detach all events from a ringbuffer. No
functional changes.

Signed-off-by: Robert Richter <robert.richter@linaro.org>
Signed-off-by: Robert Richter <rric@kernel.org>
Signed-off-by: Jean Pihet <jean.pihet@linaro.org>
---
 kernel/events/core.c | 82 ++++++++++++++++++++++++++++------------------------
 1 file changed, 44 insertions(+), 38 deletions(-)

diff --git a/kernel/events/core.c b/kernel/events/core.c
index 661951a..8867236 100644
--- a/kernel/events/core.c
+++ b/kernel/events/core.c
@@ -3878,6 +3878,49 @@ static void ring_buffer_detach(struct perf_event *event, struct ring_buffer *rb)
 	spin_unlock_irqrestore(&rb->event_lock, flags);
 }
 
+static void ring_buffer_detach_all(struct ring_buffer *rb)
+{
+	struct perf_event *event;
+again:
+	rcu_read_lock();
+	list_for_each_entry_rcu(event, &rb->event_list, rb_entry) {
+		if (!atomic_long_inc_not_zero(&event->refcount)) {
+			/*
+			 * This event is en-route to free_event() which will
+			 * detach it and remove it from the list.
+			 */
+			continue;
+		}
+		rcu_read_unlock();
+
+		mutex_lock(&event->mmap_mutex);
+		/*
+		 * Check we didn't race with perf_event_set_output() which can
+		 * swizzle the rb from under us while we were waiting to
+		 * acquire mmap_mutex.
+		 *
+		 * If we find a different rb; ignore this event, a next
+		 * iteration will no longer find it on the list. We have to
+		 * still restart the iteration to make sure we're not now
+		 * iterating the wrong list.
+		 */
+		if (event->rb == rb) {
+			rcu_assign_pointer(event->rb, NULL);
+			ring_buffer_detach(event, rb);
+			ring_buffer_put(rb); /* can't be last, we still have one */
+		}
+		mutex_unlock(&event->mmap_mutex);
+		put_event(event);
+
+		/*
+		 * Restart the iteration; either we're on the wrong list or
+		 * destroyed its integrity by doing a deletion.
+		 */
+		goto again;
+	}
+	rcu_read_unlock();
+}
+
 static void ring_buffer_wakeup(struct perf_event *event)
 {
 	struct ring_buffer *rb;
@@ -3970,44 +4013,7 @@ static void perf_mmap_close(struct vm_area_struct *vma)
 	 * into the now unreachable buffer. Somewhat complicated by the
 	 * fact that rb::event_lock otherwise nests inside mmap_mutex.
 	 */
-again:
-	rcu_read_lock();
-	list_for_each_entry_rcu(event, &rb->event_list, rb_entry) {
-		if (!atomic_long_inc_not_zero(&event->refcount)) {
-			/*
-			 * This event is en-route to free_event() which will
-			 * detach it and remove it from the list.
-			 */
-			continue;
-		}
-		rcu_read_unlock();
-
-		mutex_lock(&event->mmap_mutex);
-		/*
-		 * Check we didn't race with perf_event_set_output() which can
-		 * swizzle the rb from under us while we were waiting to
-		 * acquire mmap_mutex.
-		 *
-		 * If we find a different rb; ignore this event, a next
-		 * iteration will no longer find it on the list. We have to
-		 * still restart the iteration to make sure we're not now
-		 * iterating the wrong list.
-		 */
-		if (event->rb == rb) {
-			rcu_assign_pointer(event->rb, NULL);
-			ring_buffer_detach(event, rb);
-			ring_buffer_put(rb); /* can't be last, we still have one */
-		}
-		mutex_unlock(&event->mmap_mutex);
-		put_event(event);
-
-		/*
-		 * Restart the iteration; either we're on the wrong list or
-		 * destroyed its integrity by doing a deletion.
-		 */
-		goto again;
-	}
-	rcu_read_unlock();
+	ring_buffer_detach_all(rb);
 
 	/*
 	 * It could be there's still a few 0-ref events on the list; they'll
-- 
1.7.11.7

