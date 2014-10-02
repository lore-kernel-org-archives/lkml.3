Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752073AbaJBKca (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Oct 2014 06:32:30 -0400
Received: from e06smtp13.uk.ibm.com ([195.75.94.109]:44598 "EHLO
	e06smtp13.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751798AbaJBKc0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Oct 2014 06:32:26 -0400
From: Alexander Yarygin <yarygin@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: Alexander Yarygin <yarygin@linux.vnet.ibm.com>,
        Arnaldo Carvalho de Melo <acme@kernel.org>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@kernel.org>, Jiri Olsa <jolsa@redhat.com>,
        Mike Galbraith <efault@gmx.de>, Namhyung Kim <namhyung.kim@lge.com>,
        Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Stephane Eranian <eranian@google.com>
Subject: [PATCH 1/2] perf tools: Add option to copy events when queueing
Date: Thu,  2 Oct 2014 14:32:08 +0400
Message-Id: <1412245929-27579-2-git-send-email-yarygin@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1412245929-27579-1-git-send-email-yarygin@linux.vnet.ibm.com>
References: <1412245929-27579-1-git-send-email-yarygin@linux.vnet.ibm.com>
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14100210-2966-0000-0000-00000153E37F
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: David Ahern <dsahern@gmail.com>

When processing events the session code has an ordered samples queue which is
used to time-sort events coming in across multiple mmaps. At a later point in
time samples on the queue are flushed up to some timestamp at which point the
event is actually processed.

When analyzing events live (ie., record/analysis path in the same command)
there is a race that leads to corrupted events and parse errors which cause
perf to terminate. The problem is that when the event is placed in the ordered
samples queue it is only a reference to the event which is really sitting in
the mmap buffer. Even though the event is queued for later processing the mmap
tail pointer is updated which indicates to the kernel that the event has been
processed. The race is flushing the event from the queue before it gets
overwritten by some other event. For commands trying to process events live
(versus just writing to a file) and processing a high rate of events this leads
to parse failures and perf terminates.

Examples hitting this problem are 'perf kvm stat live', especially with nested
VMs which generate 100,000+ traces per second, and a command processing
scheduling events with a high rate of context switching -- e.g., running
'perf bench sched pipe'.

This patch offers live commands an option to copy the event when it is placed in
the ordered samples queue.

Signed-off-by: David Ahern <dsahern@gmail.com>
Cc: Arnaldo Carvalho de Melo <acme@kernel.org>
Cc: Christian Borntraeger <borntraeger@de.ibm.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Namhyung Kim <namhyung.kim@lge.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Stephane Eranian <eranian@google.com>
Signed-off-by: Alexander Yarygin <yarygin@linux.vnet.ibm.com>
---
 tools/perf/util/ordered-events.c | 41 ++++++++++++++++++++++++++++++++++++----
 tools/perf/util/ordered-events.h | 10 +++++++++-
 tools/perf/util/session.c        |  5 ++---
 3 files changed, 48 insertions(+), 8 deletions(-)

diff --git a/tools/perf/util/ordered-events.c b/tools/perf/util/ordered-events.c
index 706ce1a..f7383cc 100644
--- a/tools/perf/util/ordered-events.c
+++ b/tools/perf/util/ordered-events.c
@@ -1,5 +1,6 @@
 #include <linux/list.h>
 #include <linux/compiler.h>
+#include <linux/string.h>
 #include "ordered-events.h"
 #include "evlist.h"
 #include "session.h"
@@ -58,10 +59,24 @@ static void queue_event(struct ordered_events *oe, struct ordered_event *new)
 }
 
 #define MAX_SAMPLE_BUFFER	(64 * 1024 / sizeof(struct ordered_event))
-static struct ordered_event *alloc_event(struct ordered_events *oe)
+static struct ordered_event *alloc_event(struct ordered_events *oe,
+					 union perf_event *event)
 {
 	struct list_head *cache = &oe->cache;
 	struct ordered_event *new = NULL;
+	union perf_event *new_event = NULL;
+
+	if (oe->copy_on_queue) {
+		if (oe->cur_alloc_size < oe->max_alloc_size) {
+			new_event = memdup(event, event->header.size);
+			if (new_event)
+				oe->cur_alloc_size += event->header.size;
+		}
+	} else
+		new_event = event;
+
+	if (!new_event)
+		return NULL;
 
 	if (!list_empty(cache)) {
 		new = list_entry(cache->next, struct ordered_event, list);
@@ -74,8 +89,13 @@ static struct ordered_event *alloc_event(struct ordered_events *oe)
 		size_t size = MAX_SAMPLE_BUFFER * sizeof(*new);
 
 		oe->buffer = malloc(size);
-		if (!oe->buffer)
+		if (!oe->buffer) {
+			if (oe->copy_on_queue) {
+				oe->cur_alloc_size -= new_event->header.size;
+				free(new_event);
+			}
 			return NULL;
+		}
 
 		pr("alloc size %" PRIu64 "B (+%zu), max %" PRIu64 "B\n",
 		   oe->cur_alloc_size, size, oe->max_alloc_size);
@@ -90,15 +110,19 @@ static struct ordered_event *alloc_event(struct ordered_events *oe)
 		pr("allocation limit reached %" PRIu64 "B\n", oe->max_alloc_size);
 	}
 
+	new->event = new_event;
+
 	return new;
 }
 
 struct ordered_event *
-ordered_events__new(struct ordered_events *oe, u64 timestamp)
+ordered_events__new(struct ordered_events *oe, u64 timestamp,
+		    union perf_event *event)
 {
 	struct ordered_event *new;
 
-	new = alloc_event(oe);
+	new = alloc_event(oe, event);
+
 	if (new) {
 		new->timestamp = timestamp;
 		queue_event(oe, new);
@@ -111,6 +135,10 @@ void ordered_events__delete(struct ordered_events *oe, struct ordered_event *eve
 {
 	list_move(&event->list, &oe->cache);
 	oe->nr_events--;
+	if (oe->copy_on_queue) {
+		oe->cur_alloc_size -= event->event->header.size;
+		free(event->event);
+	}
 }
 
 static int __ordered_events__flush(struct perf_session *s,
@@ -240,6 +268,11 @@ void ordered_events__free(struct ordered_events *oe)
 
 		event = list_entry(oe->to_free.next, struct ordered_event, list);
 		list_del(&event->list);
+		if (oe->copy_on_queue) {
+			oe->cur_alloc_size -= event->event->header.size;
+			free(event->event);
+		}
+
 		free(event);
 	}
 }
diff --git a/tools/perf/util/ordered-events.h b/tools/perf/util/ordered-events.h
index 3b2f205..7b8f9b0 100644
--- a/tools/perf/util/ordered-events.h
+++ b/tools/perf/util/ordered-events.h
@@ -34,9 +34,11 @@ struct ordered_events {
 	int			buffer_idx;
 	unsigned int		nr_events;
 	enum oe_flush		last_flush_type;
+	bool                    copy_on_queue;
 };
 
-struct ordered_event *ordered_events__new(struct ordered_events *oe, u64 timestamp);
+struct ordered_event *ordered_events__new(struct ordered_events *oe, u64 timestamp,
+					  union perf_event *event);
 void ordered_events__delete(struct ordered_events *oe, struct ordered_event *event);
 int ordered_events__flush(struct perf_session *s, struct perf_tool *tool,
 			  enum oe_flush how);
@@ -48,4 +50,10 @@ void ordered_events__set_alloc_size(struct ordered_events *oe, u64 size)
 {
 	oe->max_alloc_size = size;
 }
+
+static inline
+void ordered_events__set_copy_on_queue(struct ordered_events *oe, bool copy)
+{
+	oe->copy_on_queue = copy;
+}
 #endif /* __ORDERED_EVENTS_H */
diff --git a/tools/perf/util/session.c b/tools/perf/util/session.c
index 6d2d50d..976064d 100644
--- a/tools/perf/util/session.c
+++ b/tools/perf/util/session.c
@@ -532,17 +532,16 @@ int perf_session_queue_event(struct perf_session *s, union perf_event *event,
 			return -EINVAL;
 	}
 
-	new = ordered_events__new(oe, timestamp);
+	new = ordered_events__new(oe, timestamp, event);
 	if (!new) {
 		ordered_events__flush(s, tool, OE_FLUSH__HALF);
-		new = ordered_events__new(oe, timestamp);
+		new = ordered_events__new(oe, timestamp, event);
 	}
 
 	if (!new)
 		return -ENOMEM;
 
 	new->file_offset = file_offset;
-	new->event = event;
 	return 0;
 }
 
-- 
1.9.1

