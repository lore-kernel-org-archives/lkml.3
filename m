Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754712AbbA2INh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Jan 2015 03:13:37 -0500
Received: from LGEMRELSE6Q.lge.com ([156.147.1.121]:51554 "EHLO
	lgemrelse6q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753435AbbA2IKT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Jan 2015 03:10:19 -0500
X-Original-SENDERIP: 10.177.220.203
X-Original-MAILFROM: namhyung@kernel.org
From: Namhyung Kim <namhyung@kernel.org>
To: Arnaldo Carvalho de Melo <acme@kernel.org>
Cc: Ingo Molnar <mingo@kernel.org>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Jiri Olsa <jolsa@redhat.com>, LKML <linux-kernel@vger.kernel.org>,
        David Ahern <dsahern@gmail.com>,
        Adrian Hunter <adrian.hunter@intel.com>,
        Andi Kleen <andi@firstfloor.org>,
        Stephane Eranian <eranian@google.com>,
        Frederic Weisbecker <fweisbec@gmail.com>
Subject: [PATCH 33/42] perf report: Parallelize perf report using multi-thread
Date: Thu, 29 Jan 2015 17:07:14 +0900
Message-Id: <1422518843-25818-34-git-send-email-namhyung@kernel.org>
X-Mailer: git-send-email 2.2.2
In-Reply-To: <1422518843-25818-1-git-send-email-namhyung@kernel.org>
References: <1422518843-25818-1-git-send-email-namhyung@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Introduce perf_session__process_events_mt() to enable multi-thread
sample processing.  It allocates a struct perf_tool_mt and fills
needed info in it.

The session and hists event stats are counted for each thread and
summed after finishing the processing.  Similarly hist entries are
added to per-thread hists first and then move to the original hists
using hists__mt_resort().  This function reuses hists__collapse_
resort() code so makes sort__need_collapse force to true and skips
the collapsing function.

Note that most of preprocessing stage is already done by processing
meta events in dummy tracking evsel first.  We can find corresponding
thread and map based on the sample time and symbol loading and dso
cache access is protected by pthread mutex.

Signed-off-by: Namhyung Kim <namhyung@kernel.org>
---
 tools/perf/util/hist.c    |  75 +++++++++++++++++++-----
 tools/perf/util/hist.h    |   3 +
 tools/perf/util/session.c | 141 ++++++++++++++++++++++++++++++++++++++++++++++
 tools/perf/util/session.h |   2 +
 tools/perf/util/tool.h    |  12 ++++
 5 files changed, 220 insertions(+), 13 deletions(-)

diff --git a/tools/perf/util/hist.c b/tools/perf/util/hist.c
index c44565b382c5..14d4b9358ac6 100644
--- a/tools/perf/util/hist.c
+++ b/tools/perf/util/hist.c
@@ -950,7 +950,7 @@ void hist_entry__delete(struct hist_entry *he)
  * collapse the histogram
  */
 
-static bool hists__collapse_insert_entry(struct hists *hists __maybe_unused,
+static bool hists__collapse_insert_entry(struct hists *hists,
 					 struct rb_root *root,
 					 struct hist_entry *he)
 {
@@ -987,6 +987,13 @@ static bool hists__collapse_insert_entry(struct hists *hists __maybe_unused,
 	}
 	hists->nr_entries++;
 
+	/*
+	 * For multi-threaded report, he->hists points to a dummy
+	 * hists in the struct perf_tool_mt.  Please see
+	 * perf_session__process_events_mt().
+	 */
+	he->hists = hists;
+
 	rb_link_node(&he->rb_node_in, parent, p);
 	rb_insert_color(&he->rb_node_in, root);
 	return true;
@@ -1014,19 +1021,12 @@ static void hists__apply_filters(struct hists *hists, struct hist_entry *he)
 	hists__filter_entry_by_symbol(hists, he);
 }
 
-void hists__collapse_resort(struct hists *hists, struct ui_progress *prog)
+static void __hists__collapse_resort(struct hists *hists, struct rb_root *root,
+				     struct ui_progress *prog)
 {
-	struct rb_root *root;
 	struct rb_node *next;
 	struct hist_entry *n;
 
-	if (!sort__need_collapse)
-		return;
-
-	hists->nr_entries = 0;
-
-	root = hists__get_rotate_entries_in(hists);
-
 	next = rb_first(root);
 
 	while (next) {
@@ -1049,6 +1049,27 @@ void hists__collapse_resort(struct hists *hists, struct ui_progress *prog)
 	}
 }
 
+void hists__collapse_resort(struct hists *hists, struct ui_progress *prog)
+{
+	struct rb_root *root;
+
+	if (!sort__need_collapse)
+		return;
+
+	hists->nr_entries = 0;
+
+	root = hists__get_rotate_entries_in(hists);
+	__hists__collapse_resort(hists, root, prog);
+}
+
+void hists__mt_resort(struct hists *dst, struct hists *src)
+{
+	struct rb_root *root = src->entries_in;
+
+	sort__need_collapse = 1;
+	__hists__collapse_resort(dst, root, NULL);
+}
+
 static int hist_entry__sort(struct hist_entry *a, struct hist_entry *b)
 {
 	struct perf_hpp_fmt *fmt;
@@ -1277,6 +1298,29 @@ void events_stats__inc(struct events_stats *stats, u32 type)
 	++stats->nr_events[type];
 }
 
+void events_stats__add(struct events_stats *dst, struct events_stats *src)
+{
+	int i;
+
+#define ADD(_field)  dst->_field += src->_field
+
+	ADD(total_period);
+	ADD(total_non_filtered_period);
+	ADD(total_lost);
+	ADD(total_invalid_chains);
+	ADD(nr_non_filtered_samples);
+	ADD(nr_lost_warned);
+	ADD(nr_unknown_events);
+	ADD(nr_invalid_chains);
+	ADD(nr_unknown_id);
+	ADD(nr_unprocessable_samples);
+
+	for (i = 0; i < PERF_RECORD_HEADER_MAX; i++)
+		ADD(nr_events[i]);
+
+#undef ADD
+}
+
 void hists__inc_nr_events(struct hists *hists, u32 type)
 {
 	events_stats__inc(&hists->stats, type);
@@ -1453,16 +1497,21 @@ int perf_hist_config(const char *var, const char *value)
 	return 0;
 }
 
-static int hists_evsel__init(struct perf_evsel *evsel)
+void __hists__init(struct hists *hists)
 {
-	struct hists *hists = evsel__hists(evsel);
-
 	memset(hists, 0, sizeof(*hists));
 	hists->entries_in_array[0] = hists->entries_in_array[1] = RB_ROOT;
 	hists->entries_in = &hists->entries_in_array[0];
 	hists->entries_collapsed = RB_ROOT;
 	hists->entries = RB_ROOT;
 	pthread_mutex_init(&hists->lock, NULL);
+}
+
+static int hists_evsel__init(struct perf_evsel *evsel)
+{
+	struct hists *hists = evsel__hists(evsel);
+
+	__hists__init(hists);
 	return 0;
 }
 
diff --git a/tools/perf/util/hist.h b/tools/perf/util/hist.h
index 991ca5504cbd..2c29d70b2cfe 100644
--- a/tools/perf/util/hist.h
+++ b/tools/perf/util/hist.h
@@ -124,6 +124,7 @@ int hist_entry__sort_snprintf(struct hist_entry *he, char *bf, size_t size,
 void hist_entry__delete(struct hist_entry *he);
 
 void hists__output_resort(struct hists *hists, struct ui_progress *prog);
+void hists__mt_resort(struct hists *dst, struct hists *src);
 void hists__collapse_resort(struct hists *hists, struct ui_progress *prog);
 
 void hists__decay_entries(struct hists *hists, bool zap_user, bool zap_kernel);
@@ -136,6 +137,7 @@ void hists__inc_stats(struct hists *hists, struct hist_entry *h);
 void hists__inc_nr_events(struct hists *hists, u32 type);
 void hists__inc_nr_samples(struct hists *hists, bool filtered);
 void events_stats__inc(struct events_stats *stats, u32 type);
+void events_stats__add(struct events_stats *dst, struct events_stats *src);
 size_t events_stats__fprintf(struct events_stats *stats, FILE *fp);
 
 size_t hists__fprintf(struct hists *hists, bool show_header, int max_rows,
@@ -179,6 +181,7 @@ static inline struct hists *evsel__hists(struct perf_evsel *evsel)
 }
 
 int hists__init(void);
+void __hists__init(struct hists *hists);
 
 struct perf_hpp {
 	char *buf;
diff --git a/tools/perf/util/session.c b/tools/perf/util/session.c
index 7114427f3d0f..d1d5e0b3a26e 100644
--- a/tools/perf/util/session.c
+++ b/tools/perf/util/session.c
@@ -1412,6 +1412,147 @@ int perf_session__process_events(struct perf_session *session,
 	return err;
 }
 
+static void *processing_thread_idx(void *arg)
+{
+	struct perf_tool_mt *mt_tool = arg;
+	struct perf_session *session = mt_tool->session;
+	int fd = perf_data_file__fd(session->file);
+	u64 offset = session->header.index[mt_tool->idx].offset;
+	u64 size = session->header.index[mt_tool->idx].size;
+	u64 file_size = perf_data_file__size(session->file);
+
+	pr_debug("processing samples using thread [%d]\n", mt_tool->idx);
+	if (__perf_session__process_events(session, &mt_tool->stats,
+					   fd, offset, size, file_size,
+					   &mt_tool->tool) < 0) {
+		pr_err("processing samples failed (thread [%d)\n", mt_tool->idx);
+		return NULL;
+	}
+
+	pr_debug("processing samples done for thread [%d]\n", mt_tool->idx);
+	return arg;
+}
+
+int perf_session__process_events_mt(struct perf_session *session,
+				    struct perf_tool *tool, void *arg)
+{
+	struct perf_data_file *file = session->file;
+	struct perf_evlist *evlist = session->evlist;
+	struct perf_evsel *evsel;
+	u64 nr_entries = 0;
+	struct perf_tool_mt *mt_tools = NULL;
+	struct perf_tool_mt *mt;
+	pthread_t *th_id;
+	int err, i, k;
+	int nr_index = session->header.nr_index;
+	u64 size = perf_data_file__size(file);
+
+	if (perf_session__register_idle_thread(session) == NULL)
+		return -ENOMEM;
+
+	if (perf_data_file__is_pipe(file) || !session->header.index) {
+		pr_err("data file doesn't contain the index table\n");
+		return -EINVAL;
+	}
+
+	err = __perf_session__process_events(session, &session->stats,
+					     perf_data_file__fd(file),
+					     session->header.data_offset,
+					     session->header.data_size,
+					     size, tool);
+	if (err)
+		return err;
+
+	th_id = calloc(nr_index, sizeof(*th_id));
+	if (th_id == NULL)
+		goto out;
+
+	mt_tools = calloc(nr_index, sizeof(*mt_tools));
+	if (mt_tools == NULL)
+		goto out;
+
+	for (i = 0; i < nr_index; i++) {
+		mt = &mt_tools[i];
+
+		memcpy(&mt->tool, tool, sizeof(*tool));
+
+		mt->hists = calloc(evlist->nr_entries, sizeof(*mt->hists));
+		if (mt->hists == NULL)
+			goto err;
+
+		for (k = 0; k < evlist->nr_entries; k++)
+			__hists__init(&mt->hists[k]);
+
+		mt->session = session;
+		mt->tool.ordered_events = false;
+		mt->idx = i;
+		mt->priv = arg;
+
+		pthread_create(&th_id[i], NULL, processing_thread_idx, mt);
+	}
+
+	for (i = 0; i < nr_index; i++) {
+		pthread_join(th_id[i], (void **)&mt);
+		if (mt == NULL) {
+			err = -EINVAL;
+			continue;
+		}
+
+		events_stats__add(&session->stats, &mt->stats);
+
+		evlist__for_each(evlist, evsel) {
+			struct hists *hists = evsel__hists(evsel);
+
+			events_stats__add(&hists->stats,
+					  &mt->hists[evsel->idx].stats);
+
+			nr_entries += mt->hists[evsel->idx].nr_entries;
+		}
+	}
+
+	for (i = 0; i < nr_index; i++) {
+		mt = &mt_tools[i];
+
+		evlist__for_each(evlist, evsel) {
+			struct hists *hists = evsel__hists(evsel);
+
+			if (perf_evsel__is_dummy_tracking(evsel))
+				continue;
+
+			hists__mt_resort(hists, &mt->hists[evsel->idx]);
+
+			/* Non-group events are considered as leader */
+			if (symbol_conf.event_group &&
+			    !perf_evsel__is_group_leader(evsel)) {
+				struct hists *leader_hists;
+
+				leader_hists = evsel__hists(evsel->leader);
+				hists__match(leader_hists, hists);
+				hists__link(leader_hists, hists);
+			}
+		}
+	}
+
+out:
+	events_stats__warn_about_errors(&session->stats, tool);
+
+	if (mt_tools) {
+		for (i = 0; i < nr_index; i++)
+			free(mt_tools[i].hists);
+		free(mt_tools);
+	}
+
+	free(th_id);
+	return err;
+
+err:
+	while (i-- > 0) {
+		pthread_cancel(th_id[i]);
+		pthread_join(th_id[i], NULL);
+	}
+
+	goto out;
+}
 bool perf_session__has_traces(struct perf_session *session, const char *msg)
 {
 	struct perf_evsel *evsel;
diff --git a/tools/perf/util/session.h b/tools/perf/util/session.h
index 33af571f9d08..8027d6aa5fe4 100644
--- a/tools/perf/util/session.h
+++ b/tools/perf/util/session.h
@@ -51,6 +51,8 @@ int perf_session__peek_event(struct perf_session *session, off_t file_offset,
 
 int perf_session__process_events(struct perf_session *session,
 				 struct perf_tool *tool);
+int perf_session__process_events_mt(struct perf_session *session,
+				    struct perf_tool *tool, void *arg);
 
 int perf_session_queue_event(struct perf_session *s, union perf_event *event,
 			     struct perf_tool *tool, struct perf_sample *sample,
diff --git a/tools/perf/util/tool.h b/tools/perf/util/tool.h
index bb2708bbfaca..a04826bbe991 100644
--- a/tools/perf/util/tool.h
+++ b/tools/perf/util/tool.h
@@ -2,6 +2,7 @@
 #define __PERF_TOOL_H
 
 #include <stdbool.h>
+#include "util/event.h"
 
 struct perf_session;
 union perf_event;
@@ -10,6 +11,7 @@ struct perf_evsel;
 struct perf_sample;
 struct perf_tool;
 struct machine;
+struct hists;
 
 typedef int (*event_sample)(struct perf_tool *tool, union perf_event *event,
 			    struct perf_sample *sample,
@@ -45,4 +47,14 @@ struct perf_tool {
 	bool		ordering_requires_timestamps;
 };
 
+struct perf_tool_mt {
+	struct perf_tool	tool;
+	struct events_stats	stats;
+	struct hists		*hists;
+	struct perf_session	*session;
+	int			idx;
+
+	void			*priv;
+};
+
 #endif /* __PERF_TOOL_H */
-- 
2.2.2

