Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752182AbaFRO71 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jun 2014 10:59:27 -0400
Received: from mx1.redhat.com ([209.132.183.28]:49347 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751482AbaFRO7Y (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jun 2014 10:59:24 -0400
From: Jiri Olsa <jolsa@kernel.org>
To: linux-kernel@vger.kernel.org
Cc: Jiri Olsa <jolsa@kernel.org>, Arnaldo Carvalho de Melo <acme@kernel.org>,
        Corey Ashford <cjashfor@linux.vnet.ibm.com>,
        David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@kernel.org>, Jean Pihet <jean.pihet@linaro.org>,
        Namhyung Kim <namhyung@kernel.org>, Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: [PATCH 04/18] perf tools: Rename ordered_events_queue members
Date: Wed, 18 Jun 2014 16:58:45 +0200
Message-Id: <1403103539-16807-5-git-send-email-jolsa@kernel.org>
In-Reply-To: <1403103539-16807-1-git-send-email-jolsa@kernel.org>
References: <1403103539-16807-1-git-send-email-jolsa@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Rename 'struct ordered_events_queue' members to better
fit the ordered events pattern.

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
 tools/perf/util/session.c | 108 +++++++++++++++++++++++-----------------------
 tools/perf/util/session.h |  12 +++---
 2 files changed, 59 insertions(+), 61 deletions(-)

diff --git a/tools/perf/util/session.c b/tools/perf/util/session.c
index 315d522..fc4da58 100644
--- a/tools/perf/util/session.c
+++ b/tools/perf/util/session.c
@@ -76,8 +76,8 @@ struct perf_session *perf_session__new(struct perf_data_file *file,
 		goto out;
 
 	session->repipe = repipe;
-	INIT_LIST_HEAD(&session->ordered_events.samples);
-	INIT_LIST_HEAD(&session->ordered_events.sample_cache);
+	INIT_LIST_HEAD(&session->ordered_events.events);
+	INIT_LIST_HEAD(&session->ordered_events.cache);
 	INIT_LIST_HEAD(&session->ordered_events.to_free);
 	machines__init(&session->machines);
 
@@ -455,12 +455,12 @@ struct ordered_event {
 
 static void perf_session_free_sample_buffers(struct perf_session *session)
 {
-	struct ordered_events_queue *os = &session->ordered_events;
+	struct ordered_events_queue *q = &session->ordered_events;
 
-	while (!list_empty(&os->to_free)) {
+	while (!list_empty(&q->to_free)) {
 		struct ordered_event *sq;
 
-		sq = list_entry(os->to_free.next, struct ordered_event, list);
+		sq = list_entry(q->to_free.next, struct ordered_event, list);
 		list_del(&sq->list);
 		free(sq);
 	}
@@ -475,12 +475,12 @@ static int perf_session_deliver_event(struct perf_session *session,
 static int ordered_events_flush(struct perf_session *s,
 		       struct perf_tool *tool)
 {
-	struct ordered_events_queue *os = &s->ordered_events;
-	struct list_head *head = &os->samples;
+	struct ordered_events_queue *q = &s->ordered_events;
+	struct list_head *head = &q->events;
 	struct ordered_event *tmp, *iter;
 	struct perf_sample sample;
-	u64 limit = os->next_flush;
-	u64 last_ts = os->last_sample ? os->last_sample->timestamp : 0ULL;
+	u64 limit = q->next_flush;
+	u64 last_ts = q->last ? q->last->timestamp : 0ULL;
 	bool show_progress = limit == ULLONG_MAX;
 	struct ui_progress prog;
 	int ret;
@@ -489,7 +489,7 @@ static int ordered_events_flush(struct perf_session *s,
 		return 0;
 
 	if (show_progress)
-		ui_progress__init(&prog, os->nr_samples, "Processing time ordered events...");
+		ui_progress__init(&prog, q->nr_events, "Processing time ordered events...");
 
 	list_for_each_entry_safe(iter, tmp, head, list) {
 		if (session_done())
@@ -508,21 +508,19 @@ static int ordered_events_flush(struct perf_session *s,
 				return ret;
 		}
 
-		os->last_flush = iter->timestamp;
+		q->last_flush = iter->timestamp;
 		list_del(&iter->list);
-		list_add(&iter->list, &os->sample_cache);
-		os->nr_samples--;
+		list_add(&iter->list, &q->cache);
+		q->nr_events--;
 
 		if (show_progress)
 			ui_progress__update(&prog, 1);
 	}
 
-	if (list_empty(head)) {
-		os->last_sample = NULL;
-	} else if (last_ts <= limit) {
-		os->last_sample =
-			list_entry(head->prev, struct ordered_event, list);
-	}
+	if (list_empty(head))
+		q->last = NULL;
+	else if (last_ts <= limit)
+		q->last = list_entry(head->prev, struct ordered_event, list);
 
 	return 0;
 }
@@ -580,46 +578,46 @@ static int process_finished_round(struct perf_tool *tool,
 /* The queue is ordered by time */
 static void __queue_event(struct ordered_event *new, struct perf_session *s)
 {
-	struct ordered_events_queue *os = &s->ordered_events;
-	struct ordered_event *sample = os->last_sample;
+	struct ordered_events_queue *q = &s->ordered_events;
+	struct ordered_event *last = q->last;
 	u64 timestamp = new->timestamp;
 	struct list_head *p;
 
-	++os->nr_samples;
-	os->last_sample = new;
+	++q->nr_events;
+	q->last = new;
 
-	if (!sample) {
-		list_add(&new->list, &os->samples);
-		os->max_timestamp = timestamp;
+	if (!last) {
+		list_add(&new->list, &q->events);
+		q->max_timestamp = timestamp;
 		return;
 	}
 
 	/*
-	 * last_sample might point to some random place in the list as it's
-	 * the last queued event. We expect that the new event is close to
+	 * last event might point to some random place in the list as it's
+	 * the last queued event. We expect that the new event is clqe to
 	 * this.
 	 */
-	if (sample->timestamp <= timestamp) {
-		while (sample->timestamp <= timestamp) {
-			p = sample->list.next;
-			if (p == &os->samples) {
-				list_add_tail(&new->list, &os->samples);
-				os->max_timestamp = timestamp;
+	if (last->timestamp <= timestamp) {
+		while (last->timestamp <= timestamp) {
+			p = last->list.next;
+			if (p == &q->events) {
+				list_add_tail(&new->list, &q->events);
+				q->max_timestamp = timestamp;
 				return;
 			}
-			sample = list_entry(p, struct ordered_event, list);
+			last = list_entry(p, struct ordered_event, list);
 		}
-		list_add_tail(&new->list, &sample->list);
+		list_add_tail(&new->list, &last->list);
 	} else {
-		while (sample->timestamp > timestamp) {
-			p = sample->list.prev;
-			if (p == &os->samples) {
-				list_add(&new->list, &os->samples);
+		while (last->timestamp > timestamp) {
+			p = last->list.prev;
+			if (p == &q->events) {
+				list_add(&new->list, &q->events);
 				return;
 			}
-			sample = list_entry(p, struct ordered_event, list);
+			last = list_entry(p, struct ordered_event, list);
 		}
-		list_add(&new->list, &sample->list);
+		list_add(&new->list, &last->list);
 	}
 }
 
@@ -628,8 +626,8 @@ static void __queue_event(struct ordered_event *new, struct perf_session *s)
 int perf_session_queue_event(struct perf_session *s, union perf_event *event,
 				    struct perf_sample *sample, u64 file_offset)
 {
-	struct ordered_events_queue *os = &s->ordered_events;
-	struct list_head *sc = &os->sample_cache;
+	struct ordered_events_queue *q = &s->ordered_events;
+	struct list_head *cache = &q->cache;
 	u64 timestamp = sample->time;
 	struct ordered_event *new;
 
@@ -641,20 +639,20 @@ int perf_session_queue_event(struct perf_session *s, union perf_event *event,
 		return -EINVAL;
 	}
 
-	if (!list_empty(sc)) {
-		new = list_entry(sc->next, struct ordered_event, list);
+	if (!list_empty(cache)) {
+		new = list_entry(cache->next, struct ordered_event, list);
 		list_del(&new->list);
-	} else if (os->sample_buffer) {
-		new = os->sample_buffer + os->sample_buffer_idx;
-		if (++os->sample_buffer_idx == MAX_SAMPLE_BUFFER)
-			os->sample_buffer = NULL;
+	} else if (q->buffer) {
+		new = q->buffer + q->buffer_idx;
+		if (++q->buffer_idx == MAX_SAMPLE_BUFFER)
+			q->buffer = NULL;
 	} else {
-		os->sample_buffer = malloc(MAX_SAMPLE_BUFFER * sizeof(*new));
-		if (!os->sample_buffer)
+		q->buffer = malloc(MAX_SAMPLE_BUFFER * sizeof(*new));
+		if (!q->buffer)
 			return -ENOMEM;
-		list_add(&os->sample_buffer->list, &os->to_free);
-		os->sample_buffer_idx = 2;
-		new = os->sample_buffer + 1;
+		list_add(&q->buffer->list, &q->to_free);
+		q->buffer_idx = 2;
+		new = q->buffer + 1;
 	}
 
 	new->timestamp = timestamp;
diff --git a/tools/perf/util/session.h b/tools/perf/util/session.h
index 91902ea..76b897f 100644
--- a/tools/perf/util/session.h
+++ b/tools/perf/util/session.h
@@ -20,13 +20,13 @@ struct ordered_events_queue {
 	u64			last_flush;
 	u64			next_flush;
 	u64			max_timestamp;
-	struct list_head	samples;
-	struct list_head	sample_cache;
+	struct list_head	events;
+	struct list_head	cache;
 	struct list_head	to_free;
-	struct ordered_event	*sample_buffer;
-	struct ordered_event	*last_sample;
-	int			sample_buffer_idx;
-	unsigned int		nr_samples;
+	struct ordered_event	*buffer;
+	struct ordered_event	*last;
+	int			buffer_idx;
+	unsigned int		nr_events;
 };
 
 struct perf_session {
-- 
1.8.3.1

