Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760668AbaGYO4q (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jul 2014 10:56:46 -0400
Received: from mx1.redhat.com ([209.132.183.28]:30508 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753225AbaGYO4o (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jul 2014 10:56:44 -0400
From: Jiri Olsa <jolsa@kernel.org>
To: linux-kernel@vger.kernel.org
Cc: Jiri Olsa <jolsa@kernel.org>, Arnaldo Carvalho de Melo <acme@kernel.org>,
        Corey Ashford <cjashfor@linux.vnet.ibm.com>,
        David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@kernel.org>, Jean Pihet <jean.pihet@linaro.org>,
        Namhyung Kim <namhyung@kernel.org>, Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: [PATCH 05/19] perf tools: Add ordered_events_(new|delete) interface
Date: Fri, 25 Jul 2014 16:56:03 +0200
Message-Id: <1406300177-31805-6-git-send-email-jolsa@kernel.org>
In-Reply-To: <1406300177-31805-1-git-send-email-jolsa@kernel.org>
References: <1406300177-31805-1-git-send-email-jolsa@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Adding new ordered events interface to new|delete event buffer:
  ordered_events_new    - allocate event buffer from the cache
  ordered_events_delete - return event buffer to the cache

Cc: Arnaldo Carvalho de Melo <acme@kernel.org>
Cc: Corey Ashford <cjashfor@linux.vnet.ibm.com>
Cc: David Ahern <dsahern@gmail.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Jean Pihet <jean.pihet@linaro.org>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Signed-off-by: Jiri Olsa <jolsa@kernel.org>
---
 tools/perf/util/session.c | 169 +++++++++++++++++++++++++++-------------------
 1 file changed, 98 insertions(+), 71 deletions(-)

diff --git a/tools/perf/util/session.c b/tools/perf/util/session.c
index ab7a2084d0bf..12b72bc90125 100644
--- a/tools/perf/util/session.c
+++ b/tools/perf/util/session.c
@@ -466,6 +466,100 @@ static void perf_session_free_sample_buffers(struct perf_session *session)
 	}
 }
 
+/* The queue is ordered by time */
+static void queue_event(struct ordered_events *oe, struct ordered_event *new)
+{
+	struct ordered_event *last = oe->last;
+	u64 timestamp = new->timestamp;
+	struct list_head *p;
+
+	++oe->nr_events;
+	oe->last = new;
+
+	if (!last) {
+		list_add(&new->list, &oe->events);
+		oe->max_timestamp = timestamp;
+		return;
+	}
+
+	/*
+	 * last event might point to some random place in the list as it's
+	 * the last queued event. We expect that the new event is close to
+	 * this.
+	 */
+	if (last->timestamp <= timestamp) {
+		while (last->timestamp <= timestamp) {
+			p = last->list.next;
+			if (p == &oe->events) {
+				list_add_tail(&new->list, &oe->events);
+				oe->max_timestamp = timestamp;
+				return;
+			}
+			last = list_entry(p, struct ordered_event, list);
+		}
+		list_add_tail(&new->list, &last->list);
+	} else {
+		while (last->timestamp > timestamp) {
+			p = last->list.prev;
+			if (p == &oe->events) {
+				list_add(&new->list, &oe->events);
+				return;
+			}
+			last = list_entry(p, struct ordered_event, list);
+		}
+		list_add(&new->list, &last->list);
+	}
+}
+
+#define MAX_SAMPLE_BUFFER	(64 * 1024 / sizeof(struct ordered_event))
+static struct ordered_event *alloc_event(struct ordered_events *oe)
+{
+	struct list_head *cache = &oe->cache;
+	struct ordered_event *new;
+
+	if (!list_empty(cache)) {
+		new = list_entry(cache->next, struct ordered_event, list);
+		list_del(&new->list);
+	} else if (oe->buffer) {
+		new = oe->buffer + oe->buffer_idx;
+		if (++oe->buffer_idx == MAX_SAMPLE_BUFFER)
+			oe->buffer = NULL;
+	} else {
+		oe->buffer = malloc(MAX_SAMPLE_BUFFER * sizeof(*new));
+		if (!oe->buffer)
+			return NULL;
+		list_add(&oe->buffer->list, &oe->to_free);
+
+		/* First entry is abused to maintain the to_free list. */
+		oe->buffer_idx = 2;
+		new = oe->buffer + 1;
+	}
+
+	return new;
+}
+
+static struct ordered_event*
+ordered_events_new(struct ordered_events *oe, u64 timestamp)
+{
+	struct ordered_event *new;
+
+	new = alloc_event(oe);
+	if (new) {
+		new->timestamp = timestamp;
+		queue_event(oe, new);
+	}
+
+	return new;
+}
+
+static void
+ordered_events_delete(struct ordered_events *oe, struct ordered_event *event)
+{
+	list_del(&event->list);
+	list_add(&event->list, &oe->cache);
+	oe->nr_events--;
+}
+
 static int perf_session_deliver_event(struct perf_session *session,
 				      union perf_event *event,
 				      struct perf_sample *sample,
@@ -508,10 +602,8 @@ static int ordered_events_flush(struct perf_session *s,
 				return ret;
 		}
 
+		ordered_events_delete(oe, iter);
 		oe->last_flush = iter->timestamp;
-		list_del(&iter->list);
-		list_add(&iter->list, &oe->cache);
-		oe->nr_events--;
 
 		if (show_progress)
 			ui_progress__update(&prog, 1);
@@ -575,59 +667,10 @@ static int process_finished_round(struct perf_tool *tool,
 	return ret;
 }
 
-/* The queue is ordered by time */
-static void __queue_event(struct ordered_event *new, struct perf_session *s)
-{
-	struct ordered_events *oe = &s->ordered_events;
-	struct ordered_event *last = oe->last;
-	u64 timestamp = new->timestamp;
-	struct list_head *p;
-
-	++oe->nr_events;
-	oe->last = new;
-
-	if (!last) {
-		list_add(&new->list, &oe->events);
-		oe->max_timestamp = timestamp;
-		return;
-	}
-
-	/*
-	 * last event might point to some random place in the list as it's
-	 * the last queued event. We expect that the new event is close to
-	 * this.
-	 */
-	if (last->timestamp <= timestamp) {
-		while (last->timestamp <= timestamp) {
-			p = last->list.next;
-			if (p == &oe->events) {
-				list_add_tail(&new->list, &oe->events);
-				oe->max_timestamp = timestamp;
-				return;
-			}
-			last = list_entry(p, struct ordered_event, list);
-		}
-		list_add_tail(&new->list, &last->list);
-	} else {
-		while (last->timestamp > timestamp) {
-			p = last->list.prev;
-			if (p == &oe->events) {
-				list_add(&new->list, &oe->events);
-				return;
-			}
-			last = list_entry(p, struct ordered_event, list);
-		}
-		list_add(&new->list, &last->list);
-	}
-}
-
-#define MAX_SAMPLE_BUFFER	(64 * 1024 / sizeof(struct ordered_event))
-
 int perf_session_queue_event(struct perf_session *s, union perf_event *event,
 				    struct perf_sample *sample, u64 file_offset)
 {
 	struct ordered_events *oe = &s->ordered_events;
-	struct list_head *cache = &oe->cache;
 	u64 timestamp = sample->time;
 	struct ordered_event *new;
 
@@ -639,28 +682,12 @@ int perf_session_queue_event(struct perf_session *s, union perf_event *event,
 		return -EINVAL;
 	}
 
-	if (!list_empty(cache)) {
-		new = list_entry(cache->next, struct ordered_event, list);
-		list_del(&new->list);
-	} else if (oe->buffer) {
-		new = oe->buffer + oe->buffer_idx;
-		if (++oe->buffer_idx == MAX_SAMPLE_BUFFER)
-			oe->buffer = NULL;
-	} else {
-		oe->buffer = malloc(MAX_SAMPLE_BUFFER * sizeof(*new));
-		if (!oe->buffer)
-			return -ENOMEM;
-		list_add(&oe->buffer->list, &oe->to_free);
-		oe->buffer_idx = 2;
-		new = oe->buffer + 1;
-	}
+	new = ordered_events_new(oe, timestamp);
+	if (!new)
+		return -ENOMEM;
 
-	new->timestamp = timestamp;
 	new->file_offset = file_offset;
 	new->event = event;
-
-	__queue_event(new, s);
-
 	return 0;
 }
 
-- 
1.8.3.1

