Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753013AbaHDQS6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Aug 2014 12:18:58 -0400
Received: from mail.kernel.org ([198.145.19.201]:38860 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752522AbaHDQSz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Aug 2014 12:18:55 -0400
From: Arnaldo Carvalho de Melo <acme@kernel.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org, Jiri Olsa <jolsa@kernel.org>,
        Corey Ashford <cjashfor@linux.vnet.ibm.com>,
        David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Jean Pihet <jean.pihet@linaro.org>, Namhyung Kim <namhyung@kernel.org>,
        Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 09/33] perf tools: Add ordered_events__(new|delete) interface
Date: Mon,  4 Aug 2014 13:17:20 -0300
Message-Id: <1407169064-25625-10-git-send-email-acme@kernel.org>
X-Mailer: git-send-email 1.9.3
In-Reply-To: <1407169064-25625-1-git-send-email-acme@kernel.org>
References: <1407169064-25625-1-git-send-email-acme@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jiri Olsa <jolsa@kernel.org>

Adding new ordered events interface to new|delete event buffer:

  ordered_events__new    - allocate event buffer from the cache
  ordered_events__delete - return event buffer to the cache

Signed-off-by: Jiri Olsa <jolsa@kernel.org>
Acked-by: David Ahern <dsahern@gmail.com>
Cc: Corey Ashford <cjashfor@linux.vnet.ibm.com>
Cc: David Ahern <dsahern@gmail.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Jean Pihet <jean.pihet@linaro.org>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Link: http://lkml.kernel.org/n/tip-srwunsy7o5wl17vpt4a10oxp@git.kernel.org
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/util/session.c | 169 +++++++++++++++++++++++++++-------------------
 1 file changed, 98 insertions(+), 71 deletions(-)

diff --git a/tools/perf/util/session.c b/tools/perf/util/session.c
index 619778ef5b58..ff0188c65783 100644
--- a/tools/perf/util/session.c
+++ b/tools/perf/util/session.c
@@ -464,6 +464,100 @@ static void perf_session_free_sample_buffers(struct perf_session *session)
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
+static struct ordered_event *
+ordered_events__new(struct ordered_events *oe, u64 timestamp)
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
+ordered_events__delete(struct ordered_events *oe, struct ordered_event *event)
+{
+	list_del(&event->list);
+	list_add(&event->list, &oe->cache);
+	oe->nr_events--;
+}
+
 static int perf_session_deliver_event(struct perf_session *session,
 				      union perf_event *event,
 				      struct perf_sample *sample,
@@ -506,10 +600,8 @@ static int ordered_events__flush(struct perf_session *s,
 				return ret;
 		}
 
+		ordered_events__delete(oe, iter);
 		oe->last_flush = iter->timestamp;
-		list_del(&iter->list);
-		list_add(&iter->list, &oe->cache);
-		oe->nr_events--;
 
 		if (show_progress)
 			ui_progress__update(&prog, 1);
@@ -573,59 +665,10 @@ static int process_finished_round(struct perf_tool *tool,
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
 
@@ -637,28 +680,12 @@ int perf_session_queue_event(struct perf_session *s, union perf_event *event,
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
+	new = ordered_events__new(oe, timestamp);
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
1.9.3

