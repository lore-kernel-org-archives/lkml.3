Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751918AbaHMFQB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Aug 2014 01:16:01 -0400
Received: from terminus.zytor.com ([198.137.202.10]:44897 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751442AbaHMFP7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Aug 2014 01:15:59 -0400
Date: Tue, 12 Aug 2014 22:15:28 -0700
From: tip-bot for Jiri Olsa <tipbot@zytor.com>
Message-ID: <tip-1ge3rilgudszbl87cejm1tfg@git.kernel.org>
Cc: acme@redhat.com, linux-kernel@vger.kernel.org, paulus@samba.org,
        hpa@zytor.com, mingo@kernel.org, jolsa@kernel.org,
        a.p.zijlstra@chello.nl, jean.pihet@linaro.org, namhyung@kernel.org,
        fweisbec@gmail.com, dsahern@gmail.com, tglx@linutronix.de,
        cjashfor@linux.vnet.ibm.com
Reply-To: mingo@kernel.org, hpa@zytor.com, paulus@samba.org,
        linux-kernel@vger.kernel.org, acme@redhat.com, jolsa@kernel.org,
        a.p.zijlstra@chello.nl, jean.pihet@linaro.org, namhyung@kernel.org,
        fweisbec@gmail.com, dsahern@gmail.com, tglx@linutronix.de,
        cjashfor@linux.vnet.ibm.com
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf tools: Create ordered-events object
Git-Commit-ID: 5f86b80b85f0dcd05fd1471eac6984181a707c4f
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  5f86b80b85f0dcd05fd1471eac6984181a707c4f
Gitweb:     http://git.kernel.org/tip/5f86b80b85f0dcd05fd1471eac6984181a707c4f
Author:     Jiri Olsa <jolsa@kernel.org>
AuthorDate: Fri, 1 Aug 2014 13:02:58 -0300
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Tue, 12 Aug 2014 12:02:58 -0300

perf tools: Create ordered-events object

Move ordered events code into separated object ordered-events.[ch].

No functional change was intended.

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
Link: http://lkml.kernel.org/n/tip-1ge3rilgudszbl87cejm1tfg@git.kernel.org
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/Makefile.perf         |   2 +
 tools/perf/util/ordered-events.c | 196 +++++++++++++++++++++++++++++++++++++
 tools/perf/util/ordered-events.h |  41 ++++++++
 tools/perf/util/session.c        | 206 ---------------------------------------
 tools/perf/util/session.h        |  17 +---
 5 files changed, 240 insertions(+), 222 deletions(-)

diff --git a/tools/perf/Makefile.perf b/tools/perf/Makefile.perf
index 2240974..1ea31e2 100644
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
@@ -347,6 +348,7 @@ LIB_OBJS += $(OUTPUT)util/machine.o
 LIB_OBJS += $(OUTPUT)util/map.o
 LIB_OBJS += $(OUTPUT)util/pstack.o
 LIB_OBJS += $(OUTPUT)util/session.o
+LIB_OBJS += $(OUTPUT)util/ordered-events.o
 LIB_OBJS += $(OUTPUT)util/comm.o
 LIB_OBJS += $(OUTPUT)util/thread.o
 LIB_OBJS += $(OUTPUT)util/thread_map.o
diff --git a/tools/perf/util/ordered-events.c b/tools/perf/util/ordered-events.c
new file mode 100644
index 0000000..95f8211
--- /dev/null
+++ b/tools/perf/util/ordered-events.c
@@ -0,0 +1,196 @@
+#include <linux/list.h>
+#include "ordered-events.h"
+#include "evlist.h"
+#include "session.h"
+#include "asm/bug.h"
+#include "debug.h"
+
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
+	struct ordered_event *new = NULL;
+
+	if (!list_empty(cache)) {
+		new = list_entry(cache->next, struct ordered_event, list);
+		list_del(&new->list);
+	} else if (oe->buffer) {
+		new = oe->buffer + oe->buffer_idx;
+		if (++oe->buffer_idx == MAX_SAMPLE_BUFFER)
+			oe->buffer = NULL;
+	} else if (oe->cur_alloc_size < oe->max_alloc_size) {
+		size_t size = MAX_SAMPLE_BUFFER * sizeof(*new);
+
+		oe->buffer = malloc(size);
+		if (!oe->buffer)
+			return NULL;
+
+		oe->cur_alloc_size += size;
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
+struct ordered_event *
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
+void ordered_events__delete(struct ordered_events *oe, struct ordered_event *event)
+{
+	list_del(&event->list);
+	list_add(&event->list, &oe->cache);
+	oe->nr_events--;
+}
+
+static int __ordered_events__flush(struct perf_session *s,
+				   struct perf_tool *tool)
+{
+	struct ordered_events *oe = &s->ordered_events;
+	struct list_head *head = &oe->events;
+	struct ordered_event *tmp, *iter;
+	struct perf_sample sample;
+	u64 limit = oe->next_flush;
+	u64 last_ts = oe->last ? oe->last->timestamp : 0ULL;
+	bool show_progress = limit == ULLONG_MAX;
+	struct ui_progress prog;
+	int ret;
+
+	if (!tool->ordered_events || !limit)
+		return 0;
+
+	if (show_progress)
+		ui_progress__init(&prog, oe->nr_events, "Processing time ordered events...");
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
+			ret = perf_session__deliver_event(s, iter->event, &sample, tool,
+							  iter->file_offset);
+			if (ret)
+				return ret;
+		}
+
+		ordered_events__delete(oe, iter);
+		oe->last_flush = iter->timestamp;
+
+		if (show_progress)
+			ui_progress__update(&prog, 1);
+	}
+
+	if (list_empty(head))
+		oe->last = NULL;
+	else if (last_ts <= limit)
+		oe->last = list_entry(head->prev, struct ordered_event, list);
+
+	return 0;
+}
+
+int ordered_events__flush(struct perf_session *s, struct perf_tool *tool,
+			  enum oe_flush how)
+{
+	struct ordered_events *oe = &s->ordered_events;
+	int err;
+
+	switch (how) {
+	case OE_FLUSH__FINAL:
+		oe->next_flush = ULLONG_MAX;
+		break;
+
+	case OE_FLUSH__HALF:
+	{
+		struct ordered_event *first, *last;
+		struct list_head *head = &oe->events;
+
+		first = list_entry(head->next, struct ordered_event, list);
+		last = oe->last;
+
+		/* Warn if we are called before any event got allocated. */
+		if (WARN_ONCE(!last || list_empty(head), "empty queue"))
+			return 0;
+
+		oe->next_flush  = first->timestamp;
+		oe->next_flush += (last->timestamp - first->timestamp) / 2;
+		break;
+	}
+
+	case OE_FLUSH__ROUND:
+	default:
+		break;
+	};
+
+	err = __ordered_events__flush(s, tool);
+
+	if (!err) {
+		if (how == OE_FLUSH__ROUND)
+			oe->next_flush = oe->max_timestamp;
+	}
+
+	return err;
+}
diff --git a/tools/perf/util/ordered-events.h b/tools/perf/util/ordered-events.h
new file mode 100644
index 0000000..8309983
--- /dev/null
+++ b/tools/perf/util/ordered-events.h
@@ -0,0 +1,41 @@
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
+enum oe_flush {
+	OE_FLUSH__FINAL,
+	OE_FLUSH__ROUND,
+	OE_FLUSH__HALF,
+};
+
+struct ordered_events {
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
+struct ordered_event *ordered_events__new(struct ordered_events *oe, u64 timestamp);
+void ordered_events__delete(struct ordered_events *oe, struct ordered_event *event);
+int ordered_events__flush(struct perf_session *s, struct perf_tool *tool,
+			  enum oe_flush how);
+#endif /* __ORDERED_EVENTS_H */
diff --git a/tools/perf/util/session.c b/tools/perf/util/session.c
index ed6b7f1..0ccf051 100644
--- a/tools/perf/util/session.c
+++ b/tools/perf/util/session.c
@@ -14,7 +14,6 @@
 #include "util.h"
 #include "cpumap.h"
 #include "perf_regs.h"
-#include "asm/bug.h"
 
 static int perf_session__open(struct perf_session *session)
 {
@@ -447,19 +446,6 @@ static perf_event__swap_op perf_event__swap_ops[] = {
 	[PERF_RECORD_HEADER_MAX]	  = NULL,
 };
 
-struct ordered_event {
-	u64			timestamp;
-	u64			file_offset;
-	union perf_event	*event;
-	struct list_head	list;
-};
-
-enum oe_flush {
-	OE_FLUSH__FINAL,
-	OE_FLUSH__ROUND,
-	OE_FLUSH__HALF,
-};
-
 static void perf_session_free_sample_buffers(struct perf_session *session)
 {
 	struct ordered_events *oe = &session->ordered_events;
@@ -473,198 +459,6 @@ static void perf_session_free_sample_buffers(struct perf_session *session)
 	}
 }
 
-/* The queue is ordered by time */
-static void queue_event(struct ordered_events *oe, struct ordered_event *new)
-{
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
-static struct ordered_event *alloc_event(struct ordered_events *oe)
-{
-	struct list_head *cache = &oe->cache;
-	struct ordered_event *new = NULL;
-
-	if (!list_empty(cache)) {
-		new = list_entry(cache->next, struct ordered_event, list);
-		list_del(&new->list);
-	} else if (oe->buffer) {
-		new = oe->buffer + oe->buffer_idx;
-		if (++oe->buffer_idx == MAX_SAMPLE_BUFFER)
-			oe->buffer = NULL;
-	} else if (oe->cur_alloc_size < oe->max_alloc_size) {
-		size_t size = MAX_SAMPLE_BUFFER * sizeof(*new);
-
-		oe->buffer = malloc(size);
-		if (!oe->buffer)
-			return NULL;
-
-		oe->cur_alloc_size += size;
-		list_add(&oe->buffer->list, &oe->to_free);
-
-		/* First entry is abused to maintain the to_free list. */
-		oe->buffer_idx = 2;
-		new = oe->buffer + 1;
-	}
-
-	return new;
-}
-
-static struct ordered_event *
-ordered_events__new(struct ordered_events *oe, u64 timestamp)
-{
-	struct ordered_event *new;
-
-	new = alloc_event(oe);
-	if (new) {
-		new->timestamp = timestamp;
-		queue_event(oe, new);
-	}
-
-	return new;
-}
-
-static void
-ordered_events__delete(struct ordered_events *oe, struct ordered_event *event)
-{
-	list_del(&event->list);
-	list_add(&event->list, &oe->cache);
-	oe->nr_events--;
-}
-
-static int __ordered_events__flush(struct perf_session *s,
-				   struct perf_tool *tool)
-{
-	struct ordered_events *oe = &s->ordered_events;
-	struct list_head *head = &oe->events;
-	struct ordered_event *tmp, *iter;
-	struct perf_sample sample;
-	u64 limit = oe->next_flush;
-	u64 last_ts = oe->last ? oe->last->timestamp : 0ULL;
-	bool show_progress = limit == ULLONG_MAX;
-	struct ui_progress prog;
-	int ret;
-
-	if (!tool->ordered_events || !limit)
-		return 0;
-
-	if (show_progress)
-		ui_progress__init(&prog, oe->nr_events, "Processing time ordered events...");
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
-			ret = perf_session__deliver_event(s, iter->event, &sample, tool,
-							  iter->file_offset);
-			if (ret)
-				return ret;
-		}
-
-		ordered_events__delete(oe, iter);
-		oe->last_flush = iter->timestamp;
-
-		if (show_progress)
-			ui_progress__update(&prog, 1);
-	}
-
-	if (list_empty(head))
-		oe->last = NULL;
-	else if (last_ts <= limit)
-		oe->last = list_entry(head->prev, struct ordered_event, list);
-
-	return 0;
-}
-
-static int ordered_events__flush(struct perf_session *s, struct perf_tool *tool,
-				 enum oe_flush how)
-{
-	struct ordered_events *oe = &s->ordered_events;
-	int err;
-
-	switch (how) {
-	case OE_FLUSH__FINAL:
-		oe->next_flush = ULLONG_MAX;
-		break;
-
-	case OE_FLUSH__HALF:
-	{
-		struct ordered_event *first, *last;
-		struct list_head *head = &oe->events;
-
-		first = list_entry(head->next, struct ordered_event, list);
-		last = oe->last;
-
-		/* Warn if we are called before any event got allocated. */
-		if (WARN_ONCE(!last || list_empty(head), "empty queue"))
-			return 0;
-
-		oe->next_flush  = first->timestamp;
-		oe->next_flush += (last->timestamp - first->timestamp) / 2;
-		break;
-	}
-
-	case OE_FLUSH__ROUND:
-	default:
-		break;
-	};
-
-	err = __ordered_events__flush(s, tool);
-
-	if (!err) {
-		if (how == OE_FLUSH__ROUND)
-			oe->next_flush = oe->max_timestamp;
-	}
-
-	return err;
-}
-
 /*
  * When perf record finishes a pass on every buffers, it records this pseudo
  * event.
diff --git a/tools/perf/util/session.h b/tools/perf/util/session.h
index 03da1cb..0630e65 100644
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
 
-struct ordered_events {
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
 	struct perf_header	header;
 	struct machines		machines;
