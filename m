Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751633AbaHMFOi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Aug 2014 01:14:38 -0400
Received: from terminus.zytor.com ([198.137.202.10]:44787 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751579AbaHMFOg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Aug 2014 01:14:36 -0400
Date: Tue, 12 Aug 2014 22:14:17 -0700
From: tip-bot for Jiri Olsa <tipbot@zytor.com>
Message-ID: <tip-srwunsy7o5wl17vpt4a10oxp@git.kernel.org>
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
Subject: [tip:perf/core] perf tools: Add ordered_events__(new|delete)
  interface
Git-Commit-ID: c64c7e1a5addf93b7dec98a27b8c48457506aa06
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

Commit-ID:  c64c7e1a5addf93b7dec98a27b8c48457506aa06
Gitweb:     http://git.kernel.org/tip/c64c7e1a5addf93b7dec98a27b8c48457506aa06
Author:     Jiri Olsa <jolsa@kernel.org>
AuthorDate: Tue, 10 Jun 2014 21:58:02 +0200
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Tue, 12 Aug 2014 12:02:56 -0300

perf tools: Add ordered_events__(new|delete) interface

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
index 619778e..ff0188c 100644
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
 
