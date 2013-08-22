Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753859Ab3HVOSQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Aug 2013 10:18:16 -0400
Received: from mail-bk0-f45.google.com ([209.85.214.45]:44212 "EHLO
	mail-bk0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752416Ab3HVOOh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Aug 2013 10:14:37 -0400
From: Robert Richter <rric@kernel.org>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Ingo Molnar <mingo@kernel.org>,
        Arnaldo Carvalho de Melo <acme@infradead.org>,
        Borislav Petkov <bp@alien8.de>, Jiri Olsa <jolsa@redhat.com>,
        linux-kernel@vger.kernel.org,
        Robert Richter <robert.richter@linaro.org>,
        Robert Richter <rric@kernel.org>
Subject: [PATCH v3 01/12] perf, mmap: Factor out ring_buffer_detach_all()
Date: Thu, 22 Aug 2013 16:13:16 +0200
Message-Id: <1377180807-12758-2-git-send-email-rric@kernel.org>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1377180807-12758-1-git-send-email-rric@kernel.org>
References: <1377180807-12758-1-git-send-email-rric@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Robert Richter <robert.richter@linaro.org>

Factor out a function to detach all events from a ringbuffer. No
functional changes.

Signed-off-by: Robert Richter <robert.richter@linaro.org>
Signed-off-by: Robert Richter <rric@kernel.org>
---
 kernel/events/core.c | 82 ++++++++++++++++++++++++++++------------------------
 1 file changed, 44 insertions(+), 38 deletions(-)

diff --git a/kernel/events/core.c b/kernel/events/core.c
index 928fae7c..5dcc5fe 100644
--- a/kernel/events/core.c
+++ b/kernel/events/core.c
@@ -3775,6 +3775,49 @@ static void ring_buffer_detach(struct perf_event *event, struct ring_buffer *rb)
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
@@ -3867,44 +3910,7 @@ static void perf_mmap_close(struct vm_area_struct *vma)
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
1.8.3.2

