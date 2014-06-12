Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752401AbaFLWJk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jun 2014 18:09:40 -0400
Received: from mx1.redhat.com ([209.132.183.28]:48828 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752285AbaFLWJg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jun 2014 18:09:36 -0400
From: Jiri Olsa <jolsa@kernel.org>
To: linux-kernel@vger.kernel.org
Cc: Jiri Olsa <jolsa@kernel.org>, Arnaldo Carvalho de Melo <acme@kernel.org>,
        Corey Ashford <cjashfor@linux.vnet.ibm.com>,
        David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@kernel.org>, Jean Pihet <jean.pihet@linaro.org>,
        Namhyung Kim <namhyung@kernel.org>, Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: [PATCH 10/17] perf tools: Create ordered-events object
Date: Fri, 13 Jun 2014 00:08:26 +0200
Message-Id: <1402610913-19059-11-git-send-email-jolsa@kernel.org>
In-Reply-To: <1402610913-19059-1-git-send-email-jolsa@kernel.org>
References: <1402610913-19059-1-git-send-email-jolsa@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Move ordered events code into separated object ordered-events.[ch].

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
 tools/perf/Makefile.perf         |   2 +
 tools/perf/util/ordered-events.c | 193 +++++++++++++++++++++++++++++++++++++
 tools/perf/util/ordered-events.h |  43 +++++++++
 tools/perf/util/session.c        | 203 ---------------------------------------
 tools/perf/util/session.h        |  17 +---
 5 files changed, 239 insertions(+), 219 deletions(-)
 create mode 100644 tools/perf/util/ordered-events.c
 create mode 100644 tools/perf/util/ordered-events.h

diff --git a/tools/perf/Makefile.perf b/tools/perf/Makefile.perf
index 9670a16..1351cfe 100644
--- a/tools/perf/Makefile.perf
+++ b/tools/perf/Makefile.perf
@@ -263,6 +263,7 @@ LIB_H += util/xyarray.h
 LIB_H += util/header.h
 LIB_H += util/help.h
 LIB_H += util/session.h
+LIB_H += util/ordered-events.h
 LIB_H += util/strbuf.h
 LIB_H += util/strlist.h
 LIB_H += util/strfilter.h
@@ -345,6 +346,7 @@ LIB_OBJS += $(OUTPUT)util/machine.o
 LIB_OBJS += $(OUTPUT)util/map.o
 LIB_OBJS += $(OUTPUT)util/pstack.o
 LIB_OBJS += $(OUTPUT)util/session.o
+LIB_OBJS += $(OUTPUT)util/ordered-events.o
 LIB_OBJS += $(OUTPUT)util/comm.o
 LIB_OBJS += $(OUTPUT)util/thread.o
 LIB_OBJS += $(OUTPUT)util/thread_map.o
diff --git a/tools/perf/util/ordered-events.c b/tools/perf/util/ordered-events.c
new file mode 100644
index 0000000..2d943eb
--- /dev/null
+++ b/tools/perf/util/ordered-events.c
@@ -0,0 +1,193 @@
+#include <linux/list.h>
+#include "ordered-events.h"
+#include "evlist.h"
+#include "session.h"
+#include "asm/bug.h"
+
+static void queue_event(struct ordered_events_queue *q, struct ordered_event *new)
+{
+	struct ordered_event *last = q->last;
+	u64 timestamp = new->timestamp;
+	struct list_head *p;
+
+	++q->nr_events;
+	q->last = new;
+
+	if (!last) {
+		list_add(&new->list, &q->events);
+		q->max_timestamp = timestamp;
+		return;
+	}
+
+	/*
+	 * last event might point to some random place in the list as it's
+	 * the last queued event. We expect that the new event is clqe to
+	 * this.
+	 */
+	if (last->timestamp <= timestamp) {
+		while (last->timestamp <= timestamp) {
+			p = last->list.next;
+			if (p == &q->events) {
+				list_add_tail(&new->list, &q->events);
+				q->max_timestamp = timestamp;
+				return;
+			}
+			last = list_entry(p, struct ordered_event, list);
+		}
+		list_add_tail(&new->list, &last->list);
+	} else {
+		while (last->timestamp > timestamp) {
+			p = last->list.prev;
+			if (p == &q->events) {
+				list_add(&new->list, &q->events);
+				return;
+			}
+			last = list_entry(p, struct ordered_event, list);
+		}
+		list_add(&new->list, &last->list);
+	}
+}
+
+#define MAX_SAMPLE_BUFFER	(64 * 1024 / sizeof(struct ordered_event))
+static struct ordered_event *alloc_event(struct ordered_events_queue *q)
+{
+	struct list_head *cache = &q->cache;
+	struct ordered_event *new = NULL;
+
+	if (!list_empty(cache)) {
+		new = list_entry(cache->next, struct ordered_event, list);
+		list_del(&new->list);
+	} else if (q->buffer) {
+		new = q->buffer + q->buffer_idx;
+		if (++q->buffer_idx == MAX_SAMPLE_BUFFER)
+			q->buffer = NULL;
+	} else if (q->cur_alloc_size < q->max_alloc_size) {
+		size_t size = MAX_SAMPLE_BUFFER * sizeof(*new);
+
+		q->buffer = malloc(size);
+		if (!q->buffer)
+			return NULL;
+
+		q->cur_alloc_size += size;
+		list_add(&q->buffer->list, &q->to_free);
+		q->buffer_idx = 2;
+		new = q->buffer + 1;
+	}
+
+	return new;
+}
+
+struct ordered_event*
+ordered_events_get(struct ordered_events_queue *q, u64 timestamp)
+{
+	struct ordered_event *new;
+
+	new = alloc_event(q);
+	if (new) {
+		new->timestamp = timestamp;
+		queue_event(q, new);
+	}
+
+	return new;
+}
+
+void
+ordered_event_put(struct ordered_events_queue *q, struct ordered_event *iter)
+{
+	list_del(&iter->list);
+	list_add(&iter->list, &q->cache);
+	q->nr_events--;
+}
+
+static int __ordered_events_flush(struct perf_session *s,
+				  struct perf_tool *tool)
+{
+	struct ordered_events_queue *q = &s->ordered_events;
+	struct list_head *head = &q->events;
+	struct ordered_event *tmp, *iter;
+	struct perf_sample sample;
+	u64 limit = q->next_flush;
+	u64 last_ts = q->last ? q->last->timestamp : 0ULL;
+	bool show_progress = limit == ULLONG_MAX;
+	struct ui_progress prog;
+	int ret;
+
+	if (!tool->ordered_events || !limit)
+		return 0;
+
+	if (show_progress)
+		ui_progress__init(&prog, q->nr_events, "Processing time ordered events...");
+
+	list_for_each_entry_safe(iter, tmp, head, list) {
+		if (session_done())
+			return 0;
+
+		if (iter->timestamp > limit)
+			break;
+
+		ret = perf_evlist__parse_sample(s->evlist, iter->event, &sample);
+		if (ret)
+			pr_err("Can't parse sample, err = %d\n", ret);
+		else {
+			ret = perf_session_deliver_event(s, iter->event, &sample, tool,
+							 iter->file_offset);
+			if (ret)
+				return ret;
+		}
+
+		ordered_event_put(q, iter);
+		q->last_flush = iter->timestamp;
+
+		if (show_progress)
+			ui_progress__update(&prog, 1);
+	}
+
+	if (list_empty(head))
+		q->last = NULL;
+	else if (last_ts <= limit)
+		q->last = list_entry(head->prev, struct ordered_event, list);
+
+	return 0;
+}
+
+int ordered_events_flush(struct perf_session *s, struct perf_tool *tool,
+			 enum oeq_flush how)
+{
+	struct ordered_events_queue *q = &s->ordered_events;
+	int err;
+
+	switch (how) {
+	case OEQ_FLUSH__FINAL:
+		q->next_flush = ULLONG_MAX;
+		break;
+
+	case OEQ_FLUSH__HALF:
+	{
+		struct ordered_event *first, *last;
+		struct list_head *head = &q->events;
+
+		first = list_entry(head->next, struct ordered_event, list);
+		last = q->last;
+
+		if (WARN_ONCE(!last || list_empty(head), "empty queue"))
+			return 0;
+
+		q->next_flush  = first->timestamp;
+		q->next_flush += (last->timestamp - first->timestamp) / 2;
+		break;
+	}
+
+	case OEQ_FLUSH__ROUND:
+	default:
+		break;
+	};
+
+	err = __ordered_events_flush(s, tool);
+
+	if (!err) {
+		if (how == OEQ_FLUSH__ROUND)
+			q->next_flush = q->max_timestamp;
+	}
+
+	return err;
+}
diff --git a/tools/perf/util/ordered-events.h b/tools/perf/util/ordered-events.h
new file mode 100644
index 0000000..c0dc00e
--- /dev/null
+++ b/tools/perf/util/ordered-events.h
@@ -0,0 +1,43 @@
+#ifndef __ORDERED_EVENTS_H
+#define __ORDERED_EVENTS_H
+
+#include <linux/types.h>
+#include "tool.h"
+
+struct perf_session;
+
+struct ordered_event {
+	u64			timestamp;
+	u64			file_offset;
+	union perf_event	*event;
+	struct list_head	list;
+};
+
+enum oeq_flush {
+	OEQ_FLUSH__FINAL,
+	OEQ_FLUSH__ROUND,
+	OEQ_FLUSH__HALF,
+};
+
+struct ordered_events_queue {
+	u64			last_flush;
+	u64			next_flush;
+	u64			max_timestamp;
+	u64			max_alloc_size;
+	u64			cur_alloc_size;
+	struct list_head	events;
+	struct list_head	cache;
+	struct list_head	to_free;
+	struct ordered_event	*buffer;
+	struct ordered_event	*last;
+	int			buffer_idx;
+	unsigned int		nr_events;
+};
+
+struct ordered_event *ordered_events_get(struct ordered_events_queue *q,
+					 u64 timestamp);
+void ordered_event_put(struct ordered_events_queue *q,
+		       struct ordered_event *iter);
+int ordered_events_flush(struct perf_session *s, struct perf_tool *tool,
+			 enum oeq_flush how);
+#endif /* __ORDERED_EVENTS_H */
diff --git a/tools/perf/util/session.c b/tools/perf/util/session.c
index 08aa245..0548d72 100644
--- a/tools/perf/util/session.c
+++ b/tools/perf/util/session.c
@@ -15,7 +15,6 @@
 #include "cpumap.h"
 #include "perf_regs.h"
 #include "vdso.h"
-#include "asm/bug.h"
 
 static int perf_session__open(struct perf_session *session)
 {
@@ -449,19 +448,6 @@ static perf_event__swap_op perf_event__swap_ops[] = {
 	[PERF_RECORD_HEADER_MAX]	  = NULL,
 };
 
-struct ordered_event {
-	u64			timestamp;
-	u64			file_offset;
-	union perf_event	*event;
-	struct list_head	list;
-};
-
-enum oeq_flush {
-	OEQ_FLUSH__FINAL,
-	OEQ_FLUSH__ROUND,
-	OEQ_FLUSH__HALF,
-};
-
 static void perf_session_free_sample_buffers(struct perf_session *session)
 {
 	struct ordered_events_queue *q = &session->ordered_events;
@@ -475,195 +461,6 @@ static void perf_session_free_sample_buffers(struct perf_session *session)
 	}
 }
 
-/* The queue is ordered by time */
-static void queue_event(struct ordered_events_queue *q, struct ordered_event *new)
-{
-	struct ordered_event *last = q->last;
-	u64 timestamp = new->timestamp;
-	struct list_head *p;
-
-	++q->nr_events;
-	q->last = new;
-
-	if (!last) {
-		list_add(&new->list, &q->events);
-		q->max_timestamp = timestamp;
-		return;
-	}
-
-	/*
-	 * last event might point to some random place in the list as it's
-	 * the last queued event. We expect that the new event is clqe to
-	 * this.
-	 */
-	if (last->timestamp <= timestamp) {
-		while (last->timestamp <= timestamp) {
-			p = last->list.next;
-			if (p == &q->events) {
-				list_add_tail(&new->list, &q->events);
-				q->max_timestamp = timestamp;
-				return;
-			}
-			last = list_entry(p, struct ordered_event, list);
-		}
-		list_add_tail(&new->list, &last->list);
-	} else {
-		while (last->timestamp > timestamp) {
-			p = last->list.prev;
-			if (p == &q->events) {
-				list_add(&new->list, &q->events);
-				return;
-			}
-			last = list_entry(p, struct ordered_event, list);
-		}
-		list_add(&new->list, &last->list);
-	}
-}
-
-#define MAX_SAMPLE_BUFFER	(64 * 1024 / sizeof(struct ordered_event))
-static struct ordered_event *alloc_event(struct ordered_events_queue *q)
-{
-	struct list_head *cache = &q->cache;
-	struct ordered_event *new = NULL;
-
-	if (!list_empty(cache)) {
-		new = list_entry(cache->next, struct ordered_event, list);
-		list_del(&new->list);
-	} else if (q->buffer) {
-		new = q->buffer + q->buffer_idx;
-		if (++q->buffer_idx == MAX_SAMPLE_BUFFER)
-			q->buffer = NULL;
-	} else if (q->cur_alloc_size < q->max_alloc_size) {
-		size_t size = MAX_SAMPLE_BUFFER * sizeof(*new);
-
-		q->buffer = malloc(size);
-		if (!q->buffer)
-			return NULL;
-
-		q->cur_alloc_size += size;
-		list_add(&q->buffer->list, &q->to_free);
-		q->buffer_idx = 2;
-		new = q->buffer + 1;
-	}
-
-	return new;
-}
-
-static struct ordered_event*
-ordered_events_get(struct ordered_events_queue *q, u64 timestamp)
-{
-	struct ordered_event *new;
-
-	new = alloc_event(q);
-	if (new) {
-		new->timestamp = timestamp;
-		queue_event(q, new);
-	}
-
-	return new;
-}
-
-static void
-ordered_event_put(struct ordered_events_queue *q, struct ordered_event *iter)
-{
-	list_del(&iter->list);
-	list_add(&iter->list, &q->cache);
-	q->nr_events--;
-}
-
-static int __ordered_events_flush(struct perf_session *s,
-				  struct perf_tool *tool)
-{
-	struct ordered_events_queue *q = &s->ordered_events;
-	struct list_head *head = &q->events;
-	struct ordered_event *tmp, *iter;
-	struct perf_sample sample;
-	u64 limit = q->next_flush;
-	u64 last_ts = q->last ? q->last->timestamp : 0ULL;
-	bool show_progress = limit == ULLONG_MAX;
-	struct ui_progress prog;
-	int ret;
-
-	if (!tool->ordered_events || !limit)
-		return 0;
-
-	if (show_progress)
-		ui_progress__init(&prog, q->nr_events, "Processing time ordered events...");
-
-	list_for_each_entry_safe(iter, tmp, head, list) {
-		if (session_done())
-			return 0;
-
-		if (iter->timestamp > limit)
-			break;
-
-		ret = perf_evlist__parse_sample(s->evlist, iter->event, &sample);
-		if (ret)
-			pr_err("Can't parse sample, err = %d\n", ret);
-		else {
-			ret = perf_session_deliver_event(s, iter->event, &sample, tool,
-							 iter->file_offset);
-			if (ret)
-				return ret;
-		}
-
-		ordered_event_put(q, iter);
-		q->last_flush = iter->timestamp;
-
-		if (show_progress)
-			ui_progress__update(&prog, 1);
-	}
-
-	if (list_empty(head))
-		q->last = NULL;
-	else if (last_ts <= limit)
-		q->last = list_entry(head->prev, struct ordered_event, list);
-
-	return 0;
-}
-
-static int ordered_events_flush(struct perf_session *s, struct perf_tool *tool,
-				enum oeq_flush how)
-{
-	struct ordered_events_queue *q = &s->ordered_events;
-	int err;
-
-	switch (how) {
-	case OEQ_FLUSH__FINAL:
-		q->next_flush = ULLONG_MAX;
-		break;
-
-	case OEQ_FLUSH__HALF:
-	{
-		struct ordered_event *first, *last;
-		struct list_head *head = &q->events;
-
-		first = list_entry(head->next, struct ordered_event, list);
-		last = q->last;
-
-		if (WARN_ONCE(!last || list_empty(head), "empty queue"))
-			return 0;
-
-		q->next_flush  = first->timestamp;
-		q->next_flush += (last->timestamp - first->timestamp) / 2;
-		break;
-	}
-
-	case OEQ_FLUSH__ROUND:
-	default:
-		break;
-	};
-
-	err = __ordered_events_flush(s, tool);
-
-	if (!err) {
-		if (how == OEQ_FLUSH__ROUND)
-			q->next_flush = q->max_timestamp;
-	}
-
-	return err;
-}
-
 /*
  * When perf record finishes a pass on every buffers, it records this pseudo
  * event.
diff --git a/tools/perf/util/session.h b/tools/perf/util/session.h
index 58acad4..f8dcbf9 100644
--- a/tools/perf/util/session.h
+++ b/tools/perf/util/session.h
@@ -9,28 +9,13 @@
 #include "symbol.h"
 #include "thread.h"
 #include "data.h"
+#include "ordered-events.h"
 #include <linux/rbtree.h>
 #include <linux/perf_event.h>
 
-struct ordered_event;
 struct ip_callchain;
 struct thread;
 
-struct ordered_events_queue {
-	u64			last_flush;
-	u64			next_flush;
-	u64			max_timestamp;
-	u64			max_alloc_size;
-	u64			cur_alloc_size;
-	struct list_head	events;
-	struct list_head	cache;
-	struct list_head	to_free;
-	struct ordered_event	*buffer;
-	struct ordered_event	*last;
-	int			buffer_idx;
-	unsigned int		nr_events;
-};
-
 struct perf_session {
 	struct perf_header		header;
 	struct machines			machines;
-- 
1.8.3.1

