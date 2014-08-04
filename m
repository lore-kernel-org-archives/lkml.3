Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752927AbaHDQSp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Aug 2014 12:18:45 -0400
Received: from mail.kernel.org ([198.145.19.201]:38815 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752890AbaHDQSl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Aug 2014 12:18:41 -0400
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
Subject: [PATCH 07/33] perf tools: Rename ordered_samples struct to ordered_events
Date: Mon,  4 Aug 2014 13:17:18 -0300
Message-Id: <1407169064-25625-8-git-send-email-acme@kernel.org>
X-Mailer: git-send-email 1.9.3
In-Reply-To: <1407169064-25625-1-git-send-email-acme@kernel.org>
References: <1407169064-25625-1-git-send-email-acme@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jiri Olsa <jolsa@kernel.org>

Following up with ordered_samples rename for ordered_samples and
sample_queue structs to ordered_events and ordered_event structs
respectively.

Also changing flush_sample_queue function name to ordered_events_flush.

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
Link: http://lkml.kernel.org/n/tip-2dkrdvh0bbmzxdse437fcgls@git.kernel.org
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/builtin-kvm.c  |   2 +-
 tools/perf/util/session.c | 118 +++++++++++++++++++++++-----------------------
 tools/perf/util/session.h |  10 ++--
 3 files changed, 65 insertions(+), 65 deletions(-)

diff --git a/tools/perf/builtin-kvm.c b/tools/perf/builtin-kvm.c
index a05f43592e0a..258a5274099d 100644
--- a/tools/perf/builtin-kvm.c
+++ b/tools/perf/builtin-kvm.c
@@ -785,7 +785,7 @@ static int perf_kvm__mmap_read(struct perf_kvm_stat *kvm)
 
 	/* flush queue after each round in which we processed events */
 	if (ntotal) {
-		kvm->session->ordered_samples.next_flush = flush_time;
+		kvm->session->ordered_events.next_flush = flush_time;
 		err = kvm->tool.finished_round(&kvm->tool, NULL, kvm->session);
 		if (err) {
 			if (kvm->lost_events)
diff --git a/tools/perf/util/session.c b/tools/perf/util/session.c
index a2c97ff1aa6a..6570282a7625 100644
--- a/tools/perf/util/session.c
+++ b/tools/perf/util/session.c
@@ -75,9 +75,9 @@ struct perf_session *perf_session__new(struct perf_data_file *file,
 		goto out;
 
 	session->repipe = repipe;
-	INIT_LIST_HEAD(&session->ordered_samples.samples);
-	INIT_LIST_HEAD(&session->ordered_samples.sample_cache);
-	INIT_LIST_HEAD(&session->ordered_samples.to_free);
+	INIT_LIST_HEAD(&session->ordered_events.samples);
+	INIT_LIST_HEAD(&session->ordered_events.sample_cache);
+	INIT_LIST_HEAD(&session->ordered_events.to_free);
 	machines__init(&session->machines);
 
 	if (file) {
@@ -444,7 +444,7 @@ static perf_event__swap_op perf_event__swap_ops[] = {
 	[PERF_RECORD_HEADER_MAX]	  = NULL,
 };
 
-struct sample_queue {
+struct ordered_event {
 	u64			timestamp;
 	u64			file_offset;
 	union perf_event	*event;
@@ -453,14 +453,14 @@ struct sample_queue {
 
 static void perf_session_free_sample_buffers(struct perf_session *session)
 {
-	struct ordered_samples *os = &session->ordered_samples;
+	struct ordered_events *oe = &session->ordered_events;
 
-	while (!list_empty(&os->to_free)) {
-		struct sample_queue *sq;
+	while (!list_empty(&oe->to_free)) {
+		struct ordered_event *event;
 
-		sq = list_entry(os->to_free.next, struct sample_queue, list);
-		list_del(&sq->list);
-		free(sq);
+		event = list_entry(oe->to_free.next, struct ordered_event, list);
+		list_del(&event->list);
+		free(event);
 	}
 }
 
@@ -470,15 +470,15 @@ static int perf_session_deliver_event(struct perf_session *session,
 				      struct perf_tool *tool,
 				      u64 file_offset);
 
-static int flush_sample_queue(struct perf_session *s,
-		       struct perf_tool *tool)
+static int ordered_events__flush(struct perf_session *s,
+				 struct perf_tool *tool)
 {
-	struct ordered_samples *os = &s->ordered_samples;
-	struct list_head *head = &os->samples;
-	struct sample_queue *tmp, *iter;
+	struct ordered_events *oe = &s->ordered_events;
+	struct list_head *head = &oe->samples;
+	struct ordered_event *tmp, *iter;
 	struct perf_sample sample;
-	u64 limit = os->next_flush;
-	u64 last_ts = os->last_sample ? os->last_sample->timestamp : 0ULL;
+	u64 limit = oe->next_flush;
+	u64 last_ts = oe->last_sample ? oe->last_sample->timestamp : 0ULL;
 	bool show_progress = limit == ULLONG_MAX;
 	struct ui_progress prog;
 	int ret;
@@ -487,7 +487,7 @@ static int flush_sample_queue(struct perf_session *s,
 		return 0;
 
 	if (show_progress)
-		ui_progress__init(&prog, os->nr_samples, "Processing time ordered events...");
+		ui_progress__init(&prog, oe->nr_samples, "Processing time ordered events...");
 
 	list_for_each_entry_safe(iter, tmp, head, list) {
 		if (session_done())
@@ -506,20 +506,20 @@ static int flush_sample_queue(struct perf_session *s,
 				return ret;
 		}
 
-		os->last_flush = iter->timestamp;
+		oe->last_flush = iter->timestamp;
 		list_del(&iter->list);
-		list_add(&iter->list, &os->sample_cache);
-		os->nr_samples--;
+		list_add(&iter->list, &oe->sample_cache);
+		oe->nr_samples--;
 
 		if (show_progress)
 			ui_progress__update(&prog, 1);
 	}
 
 	if (list_empty(head)) {
-		os->last_sample = NULL;
+		oe->last_sample = NULL;
 	} else if (last_ts <= limit) {
-		os->last_sample =
-			list_entry(head->prev, struct sample_queue, list);
+		oe->last_sample =
+			list_entry(head->prev, struct ordered_event, list);
 	}
 
 	return 0;
@@ -568,27 +568,27 @@ static int process_finished_round(struct perf_tool *tool,
 				  union perf_event *event __maybe_unused,
 				  struct perf_session *session)
 {
-	int ret = flush_sample_queue(session, tool);
+	int ret = ordered_events__flush(session, tool);
 	if (!ret)
-		session->ordered_samples.next_flush = session->ordered_samples.max_timestamp;
+		session->ordered_events.next_flush = session->ordered_events.max_timestamp;
 
 	return ret;
 }
 
 /* The queue is ordered by time */
-static void __queue_event(struct sample_queue *new, struct perf_session *s)
+static void __queue_event(struct ordered_event *new, struct perf_session *s)
 {
-	struct ordered_samples *os = &s->ordered_samples;
-	struct sample_queue *sample = os->last_sample;
+	struct ordered_events *oe = &s->ordered_events;
+	struct ordered_event *sample = oe->last_sample;
 	u64 timestamp = new->timestamp;
 	struct list_head *p;
 
-	++os->nr_samples;
-	os->last_sample = new;
+	++oe->nr_samples;
+	oe->last_sample = new;
 
 	if (!sample) {
-		list_add(&new->list, &os->samples);
-		os->max_timestamp = timestamp;
+		list_add(&new->list, &oe->samples);
+		oe->max_timestamp = timestamp;
 		return;
 	}
 
@@ -600,59 +600,59 @@ static void __queue_event(struct sample_queue *new, struct perf_session *s)
 	if (sample->timestamp <= timestamp) {
 		while (sample->timestamp <= timestamp) {
 			p = sample->list.next;
-			if (p == &os->samples) {
-				list_add_tail(&new->list, &os->samples);
-				os->max_timestamp = timestamp;
+			if (p == &oe->samples) {
+				list_add_tail(&new->list, &oe->samples);
+				oe->max_timestamp = timestamp;
 				return;
 			}
-			sample = list_entry(p, struct sample_queue, list);
+			sample = list_entry(p, struct ordered_event, list);
 		}
 		list_add_tail(&new->list, &sample->list);
 	} else {
 		while (sample->timestamp > timestamp) {
 			p = sample->list.prev;
-			if (p == &os->samples) {
-				list_add(&new->list, &os->samples);
+			if (p == &oe->samples) {
+				list_add(&new->list, &oe->samples);
 				return;
 			}
-			sample = list_entry(p, struct sample_queue, list);
+			sample = list_entry(p, struct ordered_event, list);
 		}
 		list_add(&new->list, &sample->list);
 	}
 }
 
-#define MAX_SAMPLE_BUFFER	(64 * 1024 / sizeof(struct sample_queue))
+#define MAX_SAMPLE_BUFFER	(64 * 1024 / sizeof(struct ordered_event))
 
 int perf_session_queue_event(struct perf_session *s, union perf_event *event,
 				    struct perf_sample *sample, u64 file_offset)
 {
-	struct ordered_samples *os = &s->ordered_samples;
-	struct list_head *sc = &os->sample_cache;
+	struct ordered_events *oe = &s->ordered_events;
+	struct list_head *sc = &oe->sample_cache;
 	u64 timestamp = sample->time;
-	struct sample_queue *new;
+	struct ordered_event *new;
 
 	if (!timestamp || timestamp == ~0ULL)
 		return -ETIME;
 
-	if (timestamp < s->ordered_samples.last_flush) {
+	if (timestamp < s->ordered_events.last_flush) {
 		printf("Warning: Timestamp below last timeslice flush\n");
 		return -EINVAL;
 	}
 
 	if (!list_empty(sc)) {
-		new = list_entry(sc->next, struct sample_queue, list);
+		new = list_entry(sc->next, struct ordered_event, list);
 		list_del(&new->list);
-	} else if (os->sample_buffer) {
-		new = os->sample_buffer + os->sample_buffer_idx;
-		if (++os->sample_buffer_idx == MAX_SAMPLE_BUFFER)
-			os->sample_buffer = NULL;
+	} else if (oe->sample_buffer) {
+		new = oe->sample_buffer + oe->sample_buffer_idx;
+		if (++oe->sample_buffer_idx == MAX_SAMPLE_BUFFER)
+			oe->sample_buffer = NULL;
 	} else {
-		os->sample_buffer = malloc(MAX_SAMPLE_BUFFER * sizeof(*new));
-		if (!os->sample_buffer)
+		oe->sample_buffer = malloc(MAX_SAMPLE_BUFFER * sizeof(*new));
+		if (!oe->sample_buffer)
 			return -ENOMEM;
-		list_add(&os->sample_buffer->list, &os->to_free);
-		os->sample_buffer_idx = 2;
-		new = os->sample_buffer + 1;
+		list_add(&oe->sample_buffer->list, &oe->to_free);
+		oe->sample_buffer_idx = 2;
+		new = oe->sample_buffer + 1;
 	}
 
 	new->timestamp = timestamp;
@@ -1222,8 +1222,8 @@ more:
 		goto more;
 done:
 	/* do the final flush for ordered samples */
-	session->ordered_samples.next_flush = ULLONG_MAX;
-	err = flush_sample_queue(session, tool);
+	session->ordered_events.next_flush = ULLONG_MAX;
+	err = ordered_events__flush(session, tool);
 out_err:
 	free(buf);
 	perf_session__warn_about_errors(session, tool);
@@ -1368,8 +1368,8 @@ more:
 
 out:
 	/* do the final flush for ordered samples */
-	session->ordered_samples.next_flush = ULLONG_MAX;
-	err = flush_sample_queue(session, tool);
+	session->ordered_events.next_flush = ULLONG_MAX;
+	err = ordered_events__flush(session, tool);
 out_err:
 	ui_progress__finish();
 	perf_session__warn_about_errors(session, tool);
diff --git a/tools/perf/util/session.h b/tools/perf/util/session.h
index 0321013bd9fd..f6baf935917a 100644
--- a/tools/perf/util/session.h
+++ b/tools/perf/util/session.h
@@ -12,19 +12,19 @@
 #include <linux/rbtree.h>
 #include <linux/perf_event.h>
 
-struct sample_queue;
+struct ordered_event;
 struct ip_callchain;
 struct thread;
 
-struct ordered_samples {
+struct ordered_events {
 	u64			last_flush;
 	u64			next_flush;
 	u64			max_timestamp;
 	struct list_head	samples;
 	struct list_head	sample_cache;
 	struct list_head	to_free;
-	struct sample_queue	*sample_buffer;
-	struct sample_queue	*last_sample;
+	struct ordered_event	*sample_buffer;
+	struct ordered_event	*last_sample;
 	int			sample_buffer_idx;
 	unsigned int		nr_samples;
 };
@@ -39,7 +39,7 @@ struct perf_session {
 	bool			one_mmap;
 	void			*one_mmap_addr;
 	u64			one_mmap_offset;
-	struct ordered_samples	ordered_samples;
+	struct ordered_events	ordered_events;
 	struct perf_data_file	*file;
 };
 
-- 
1.9.3

