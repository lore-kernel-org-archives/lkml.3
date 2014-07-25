Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760621AbaGYPBj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jul 2014 11:01:39 -0400
Received: from mx1.redhat.com ([209.132.183.28]:26654 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760545AbaGYO4m (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jul 2014 10:56:42 -0400
From: Jiri Olsa <jolsa@kernel.org>
To: linux-kernel@vger.kernel.org
Cc: Jiri Olsa <jolsa@kernel.org>, Arnaldo Carvalho de Melo <acme@kernel.org>,
        Corey Ashford <cjashfor@linux.vnet.ibm.com>,
        David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@kernel.org>, Jean Pihet <jean.pihet@linaro.org>,
        Namhyung Kim <namhyung@kernel.org>, Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: [PATCH 04/19] perf tools: Rename ordered_events members
Date: Fri, 25 Jul 2014 16:56:02 +0200
Message-Id: <1406300177-31805-5-git-send-email-jolsa@kernel.org>
In-Reply-To: <1406300177-31805-1-git-send-email-jolsa@kernel.org>
References: <1406300177-31805-1-git-send-email-jolsa@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Rename 'struct ordered_events_queue' members to fit
better the ordered events style.

No functional change was intended.

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
 tools/perf/util/session.c | 86 +++++++++++++++++++++++------------------------
 tools/perf/util/session.h | 12 +++----
 2 files changed, 48 insertions(+), 50 deletions(-)

diff --git a/tools/perf/util/session.c b/tools/perf/util/session.c
index 1bfd2a04143b..ab7a2084d0bf 100644
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
 
@@ -476,11 +476,11 @@ static int ordered_events_flush(struct perf_session *s,
 		       struct perf_tool *tool)
 {
 	struct ordered_events *oe = &s->ordered_events;
-	struct list_head *head = &oe->samples;
+	struct list_head *head = &oe->events;
 	struct ordered_event *tmp, *iter;
 	struct perf_sample sample;
 	u64 limit = oe->next_flush;
-	u64 last_ts = oe->last_sample ? oe->last_sample->timestamp : 0ULL;
+	u64 last_ts = oe->last ? oe->last->timestamp : 0ULL;
 	bool show_progress = limit == ULLONG_MAX;
 	struct ui_progress prog;
 	int ret;
@@ -489,7 +489,7 @@ static int ordered_events_flush(struct perf_session *s,
 		return 0;
 
 	if (show_progress)
-		ui_progress__init(&prog, oe->nr_samples, "Processing time ordered events...");
+		ui_progress__init(&prog, oe->nr_events, "Processing time ordered events...");
 
 	list_for_each_entry_safe(iter, tmp, head, list) {
 		if (session_done())
@@ -510,19 +510,17 @@ static int ordered_events_flush(struct perf_session *s,
 
 		oe->last_flush = iter->timestamp;
 		list_del(&iter->list);
-		list_add(&iter->list, &oe->sample_cache);
-		oe->nr_samples--;
+		list_add(&iter->list, &oe->cache);
+		oe->nr_events--;
 
 		if (show_progress)
 			ui_progress__update(&prog, 1);
 	}
 
-	if (list_empty(head)) {
-		oe->last_sample = NULL;
-	} else if (last_ts <= limit) {
-		oe->last_sample =
-			list_entry(head->prev, struct ordered_event, list);
-	}
+	if (list_empty(head))
+		oe->last = NULL;
+	else if (last_ts <= limit)
+		oe->last = list_entry(head->prev, struct ordered_event, list);
 
 	return 0;
 }
@@ -581,45 +579,45 @@ static int process_finished_round(struct perf_tool *tool,
 static void __queue_event(struct ordered_event *new, struct perf_session *s)
 {
 	struct ordered_events *oe = &s->ordered_events;
-	struct ordered_event *sample = oe->last_sample;
+	struct ordered_event *last = oe->last;
 	u64 timestamp = new->timestamp;
 	struct list_head *p;
 
-	++oe->nr_samples;
-	oe->last_sample = new;
+	++oe->nr_events;
+	oe->last = new;
 
-	if (!sample) {
-		list_add(&new->list, &oe->samples);
+	if (!last) {
+		list_add(&new->list, &oe->events);
 		oe->max_timestamp = timestamp;
 		return;
 	}
 
 	/*
-	 * last_sample might point to some random place in the list as it's
+	 * last event might point to some random place in the list as it's
 	 * the last queued event. We expect that the new event is close to
 	 * this.
 	 */
-	if (sample->timestamp <= timestamp) {
-		while (sample->timestamp <= timestamp) {
-			p = sample->list.next;
-			if (p == &oe->samples) {
-				list_add_tail(&new->list, &oe->samples);
+	if (last->timestamp <= timestamp) {
+		while (last->timestamp <= timestamp) {
+			p = last->list.next;
+			if (p == &oe->events) {
+				list_add_tail(&new->list, &oe->events);
 				oe->max_timestamp = timestamp;
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
-			if (p == &oe->samples) {
-				list_add(&new->list, &oe->samples);
+		while (last->timestamp > timestamp) {
+			p = last->list.prev;
+			if (p == &oe->events) {
+				list_add(&new->list, &oe->events);
 				return;
 			}
-			sample = list_entry(p, struct ordered_event, list);
+			last = list_entry(p, struct ordered_event, list);
 		}
-		list_add(&new->list, &sample->list);
+		list_add(&new->list, &last->list);
 	}
 }
 
@@ -629,7 +627,7 @@ int perf_session_queue_event(struct perf_session *s, union perf_event *event,
 				    struct perf_sample *sample, u64 file_offset)
 {
 	struct ordered_events *oe = &s->ordered_events;
-	struct list_head *sc = &oe->sample_cache;
+	struct list_head *cache = &oe->cache;
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
-	} else if (oe->sample_buffer) {
-		new = oe->sample_buffer + oe->sample_buffer_idx;
-		if (++oe->sample_buffer_idx == MAX_SAMPLE_BUFFER)
-			oe->sample_buffer = NULL;
+	} else if (oe->buffer) {
+		new = oe->buffer + oe->buffer_idx;
+		if (++oe->buffer_idx == MAX_SAMPLE_BUFFER)
+			oe->buffer = NULL;
 	} else {
-		oe->sample_buffer = malloc(MAX_SAMPLE_BUFFER * sizeof(*new));
-		if (!oe->sample_buffer)
+		oe->buffer = malloc(MAX_SAMPLE_BUFFER * sizeof(*new));
+		if (!oe->buffer)
 			return -ENOMEM;
-		list_add(&oe->sample_buffer->list, &oe->to_free);
-		oe->sample_buffer_idx = 2;
-		new = oe->sample_buffer + 1;
+		list_add(&oe->buffer->list, &oe->to_free);
+		oe->buffer_idx = 2;
+		new = oe->buffer + 1;
 	}
 
 	new->timestamp = timestamp;
diff --git a/tools/perf/util/session.h b/tools/perf/util/session.h
index f6baf935917a..419eb50e1cd3 100644
--- a/tools/perf/util/session.h
+++ b/tools/perf/util/session.h
@@ -20,13 +20,13 @@ struct ordered_events {
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

