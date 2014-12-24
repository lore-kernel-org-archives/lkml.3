Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752511AbaLXHSo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Dec 2014 02:18:44 -0500
Received: from LGEMRELSE6Q.lge.com ([156.147.1.121]:40221 "EHLO
	lgemrelse6q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752172AbaLXHPl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Dec 2014 02:15:41 -0500
X-Original-SENDERIP: 10.177.222.235
X-Original-MAILFROM: namhyung@kernel.org
From: Namhyung Kim <namhyung@kernel.org>
To: Arnaldo Carvalho de Melo <acme@kernel.org>
Cc: Ingo Molnar <mingo@kernel.org>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Jiri Olsa <jolsa@redhat.com>, LKML <linux-kernel@vger.kernel.org>,
        David Ahern <dsahern@gmail.com>, Stephane Eranian <eranian@google.com>,
        Adrian Hunter <adrian.hunter@intel.com>,
        Andi Kleen <andi@firstfloor.org>,
        Frederic Weisbecker <fweisbec@gmail.com>
Subject: [PATCH 27/37] perf report: Parallelize perf report using multi-thread
Date: Wed, 24 Dec 2014 16:15:23 +0900
Message-Id: <1419405333-27952-28-git-send-email-namhyung@kernel.org>
X-Mailer: git-send-email 2.1.3
In-Reply-To: <1419405333-27952-1-git-send-email-namhyung@kernel.org>
References: <1419405333-27952-1-git-send-email-namhyung@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Introduce perf_session__process_events_mt() to enable multi-thread
sample processing.  It allocates a struct perf_tool_mt and fills
needed info in it.  The init and fini callbacks are provided so that
we can pass additional data structure if needed.

The session and hists event stats are counted for each thread and
summed after finishing the processing.  Similarly hist entries are
added to per-thread hists first and then move to the original hists
using hists__multi_resort().  This function reuses hists__collapse_
resort() code so makes sort__need_collapse force to true and skips
the collapsing function.

Note that most of preprocessing stage is already done by processing
meta events in dummy tracking evsel first.  We can find corresponding
thread and map based on the sample time and symbol loading and dso
cache access is protected by pthread mutex.

Signed-off-by: Namhyung Kim <namhyung@kernel.org>
---
 tools/perf/builtin-report.c |  90 +++++++++++++++++++++------
 tools/perf/util/hist.c      |  75 +++++++++++++++++++----
 tools/perf/util/hist.h      |   3 +
 tools/perf/util/session.c   | 146 ++++++++++++++++++++++++++++++++++++++++++++
 tools/perf/util/session.h   |   4 ++
 tools/perf/util/tool.h      |  14 +++++
 6 files changed, 302 insertions(+), 30 deletions(-)

diff --git a/tools/perf/builtin-report.c b/tools/perf/builtin-report.c
index aabcfc24afd1..796db514db31 100644
--- a/tools/perf/builtin-report.c
+++ b/tools/perf/builtin-report.c
@@ -128,18 +128,16 @@ static int hist_iter__report_callback(struct hist_entry_iter *iter,
 	return err;
 }
 
-static int process_sample_event(struct perf_tool *tool,
-				union perf_event *event,
-				struct perf_sample *sample,
-				struct perf_evsel *evsel,
-				struct machine *machine)
+static int __process_sample_event(struct perf_tool *tool __maybe_unused,
+				  union perf_event *event,
+				  struct perf_sample *sample,
+				  struct perf_evsel *evsel,
+				  struct machine *machine,
+				  struct hist_entry_iter *iter,
+				  struct hists *hists,
+				  struct report *rep)
 {
-	struct report *rep = container_of(tool, struct report, tool);
 	struct addr_location al;
-	struct hist_entry_iter iter = {
-		.hide_unresolved = rep->hide_unresolved,
-		.add_entry_cb = hist_iter__report_callback,
-	};
 	int ret;
 
 	if (perf_event__preprocess_sample(event, machine, &al, sample) < 0) {
@@ -155,18 +153,18 @@ static int process_sample_event(struct perf_tool *tool,
 		return 0;
 
 	if (sort__mode == SORT_MODE__BRANCH)
-		iter.ops = &hist_iter_branch;
+		iter->ops = &hist_iter_branch;
 	else if (rep->mem_mode)
-		iter.ops = &hist_iter_mem;
+		iter->ops = &hist_iter_mem;
 	else if (symbol_conf.cumulate_callchain)
-		iter.ops = &hist_iter_cumulative;
+		iter->ops = &hist_iter_cumulative;
 	else
-		iter.ops = &hist_iter_normal;
+		iter->ops = &hist_iter_normal;
 
 	if (al.map != NULL)
 		al.map->dso->hit = 1;
 
-	ret = hist_entry_iter__add(&iter, evsel__hists(evsel), evsel, &al,
+	ret = hist_entry_iter__add(iter, hists, evsel, &al,
 				   sample, rep->max_stack, rep);
 	if (ret < 0)
 		pr_debug("problem adding hist entry, skipping event\n");
@@ -174,6 +172,52 @@ static int process_sample_event(struct perf_tool *tool,
 	return ret;
 }
 
+static int process_sample_event(struct perf_tool *tool,
+				union perf_event *event,
+				struct perf_sample *sample,
+				struct perf_evsel *evsel,
+				struct machine *machine)
+{
+	struct report *rep = container_of(tool, struct report, tool);
+	struct hist_entry_iter iter = {
+		.hide_unresolved = rep->hide_unresolved,
+		.add_entry_cb = hist_iter__report_callback,
+	};
+
+	return __process_sample_event(tool, event, sample, evsel, machine,
+				      &iter, evsel__hists(evsel), rep);
+}
+
+static int process_sample_event_multi(struct perf_tool *tool,
+				      union perf_event *event,
+				      struct perf_sample *sample,
+				      struct perf_evsel *evsel,
+				      struct machine *machine)
+{
+	struct perf_tool_mt *mt = container_of(tool, struct perf_tool_mt, tool);
+	struct report *rep = mt->priv;
+	struct hist_entry_iter iter = {
+		.hide_unresolved = rep->hide_unresolved,
+	};
+
+	return __process_sample_event(tool, event, sample, evsel, machine,
+				      &iter, &mt->hists[evsel->idx], rep);
+}
+
+static int multi_report_init(struct perf_tool_mt *mt, void *arg)
+{
+	struct report *rep = arg;
+
+	mt->priv = rep;
+	return 0;
+}
+
+static int multi_report_fini(struct perf_tool_mt *mt, void *arg __maybe_unused)
+{
+	mt->priv = NULL;
+	return 0;
+}
+
 static int process_read_event(struct perf_tool *tool,
 			      union perf_event *event,
 			      struct perf_sample *sample __maybe_unused,
@@ -483,7 +527,14 @@ static int __cmd_report(struct report *rep)
 	if (ret)
 		return ret;
 
-	ret = perf_session__process_events(session, &rep->tool);
+	if (file->is_multi) {
+		rep->tool.sample = process_sample_event_multi;
+		ret = perf_session__process_events_mt(session, &rep->tool,
+						      multi_report_init,
+						      multi_report_fini, rep);
+	} else {
+		ret = perf_session__process_events(session, &rep->tool);
+	}
 	if (ret)
 		return ret;
 
@@ -506,7 +557,12 @@ static int __cmd_report(struct report *rep)
 		}
 	}
 
-	report__collapse_hists(rep);
+	/*
+	 * For multi-file report, it already calls hists__multi_resort()
+	 * so no need to collapse here.
+	 */
+	if (!file->is_multi)
+		report__collapse_hists(rep);
 
 	if (session_done())
 		return 0;
diff --git a/tools/perf/util/hist.c b/tools/perf/util/hist.c
index d7cee7165bcd..f3b39b45f2ec 100644
--- a/tools/perf/util/hist.c
+++ b/tools/perf/util/hist.c
@@ -953,7 +953,7 @@ void hist_entry__free(struct hist_entry *he)
  * collapse the histogram
  */
 
-static bool hists__collapse_insert_entry(struct hists *hists __maybe_unused,
+static bool hists__collapse_insert_entry(struct hists *hists,
 					 struct rb_root *root,
 					 struct hist_entry *he)
 {
@@ -990,6 +990,13 @@ static bool hists__collapse_insert_entry(struct hists *hists __maybe_unused,
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
@@ -1017,19 +1024,12 @@ static void hists__apply_filters(struct hists *hists, struct hist_entry *he)
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
@@ -1052,6 +1052,27 @@ void hists__collapse_resort(struct hists *hists, struct ui_progress *prog)
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
+void hists__multi_resort(struct hists *dst, struct hists *src)
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
@@ -1280,6 +1301,29 @@ void events_stats__inc(struct events_stats *stats, u32 type)
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
@@ -1456,16 +1500,21 @@ int perf_hist_config(const char *var, const char *value)
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
index 2ee0e40cf44c..4d975f5501ed 100644
--- a/tools/perf/util/hist.h
+++ b/tools/perf/util/hist.h
@@ -124,6 +124,7 @@ int hist_entry__sort_snprintf(struct hist_entry *he, char *bf, size_t size,
 void hist_entry__free(struct hist_entry *);
 
 void hists__output_resort(struct hists *hists, struct ui_progress *prog);
+void hists__multi_resort(struct hists *dst, struct hists *src);
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
index af2608e782ae..c1a17110ec6a 100644
--- a/tools/perf/util/session.c
+++ b/tools/perf/util/session.c
@@ -1412,6 +1412,152 @@ int perf_session__process_events(struct perf_session *session,
 	return err;
 }
 
+static void *processing_thread(void *arg)
+{
+	struct perf_tool_mt *mt_tool = arg;
+	int fd = perf_data_file__multi_fd(mt_tool->session->file, mt_tool->idx);
+	u64 size;
+
+	size = lseek(fd, 0, SEEK_END);
+	if (size == 0)
+		return arg;
+
+	pr_debug("processing samples using thread [%d]\n", mt_tool->idx);
+	if (__perf_session__process_events(mt_tool->session, &mt_tool->stats,
+					   fd, 0, size, size, &mt_tool->tool) < 0) {
+		pr_err("processing samples failed (thread [%d)\n", mt_tool->idx);
+		free(mt_tool->hists);
+		free(mt_tool);
+		return NULL;
+	}
+
+	pr_debug("processing samples done for thread [%d]\n", mt_tool->idx);
+	return arg;
+}
+
+int perf_session__process_events_mt(struct perf_session *session,
+				    struct perf_tool *tool,
+				    mt_tool_callback_t init_cb,
+				    mt_tool_callback_t fini_cb, void *arg)
+{
+	struct perf_data_file *file = session->file;
+	struct perf_evlist *evlist = session->evlist;
+	u64 size = perf_data_file__size(file);
+	struct perf_tool_mt *mt_tools = NULL;
+	struct perf_tool_mt *mt;
+	pthread_t *mt_id;
+	int err, i, k;
+
+	if (perf_session__register_idle_thread(session) == NULL)
+		return -ENOMEM;
+
+	if (perf_data_file__is_pipe(file) || !file->is_multi) {
+		pr_err("multi thread processing should be called with multi-file\n");
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
+	mt_id = calloc(file->nr_multi, sizeof(*mt_id));
+	if (mt_id == NULL)
+		goto out;
+
+	mt_tools = calloc(file->nr_multi, sizeof(*mt_tools));
+	if (mt_tools == NULL)
+		goto out;
+
+	for (i = 0; i < file->nr_multi; i++) {
+		mt = &mt_tools[i];
+
+		memcpy(&mt->tool, tool, sizeof(*tool));
+		memset(&mt->stats, 0, sizeof(mt->stats));
+
+		mt->hists = calloc(evlist->nr_entries,
+					sizeof(*mt->hists));
+		if (mt->hists == NULL)
+			goto err;
+
+		for (k = 0; k < evlist->nr_entries; k++)
+			__hists__init(&mt->hists[k]);
+
+		mt->session = session;
+		mt->tool.ordered_events = false;
+		mt->idx = i;
+
+		err = init_cb(mt, arg);
+		if (err < 0)
+			goto err;
+
+		pthread_create(&mt_id[i], NULL, processing_thread, mt);
+	}
+
+	for (i = 0; i < file->nr_multi; i++) {
+		struct perf_evsel *evsel;
+		int err2;
+
+		pthread_join(mt_id[i], (void **)&mt);
+		if (mt == NULL) {
+			err = -EINVAL;
+			continue;
+		}
+
+		events_stats__add(&session->stats, &mt->stats);
+
+		evlist__for_each(evlist, evsel) {
+			struct hists *hists;
+
+			if (perf_evsel__is_dummy_tracking(evsel))
+				continue;
+
+			hists = evsel__hists(evsel);
+			events_stats__add(&hists->stats,
+					  &mt->hists[evsel->idx].stats);
+
+			hists__multi_resort(hists, &mt->hists[evsel->idx]);
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
+
+		err2 = fini_cb(mt, arg);
+		if (!err)
+			err = err2;
+	}
+
+out:
+	events_stats__warn_about_errors(&session->stats, tool);
+
+	if (mt_tools) {
+		for (i = 0; i < file->nr_multi; i++)
+			free(mt_tools[i].hists);
+		free(mt_tools);
+	}
+
+	free(mt_id);
+	return err;
+
+err:
+	while (i-- > 0) {
+		pthread_cancel(mt_id[i]);
+		pthread_join(mt_id[i], NULL);
+	}
+
+	goto out;
+}
+
 bool perf_session__has_traces(struct perf_session *session, const char *msg)
 {
 	struct perf_evsel *evsel;
diff --git a/tools/perf/util/session.h b/tools/perf/util/session.h
index 8fc067d931cd..1d0750d891ba 100644
--- a/tools/perf/util/session.h
+++ b/tools/perf/util/session.h
@@ -51,6 +51,10 @@ int perf_session__peek_event(struct perf_session *session, off_t file_offset,
 
 int perf_session__process_events(struct perf_session *session,
 				 struct perf_tool *tool);
+int perf_session__process_events_mt(struct perf_session *session,
+				    struct perf_tool *tool,
+				    mt_tool_callback_t init_cb,
+				    mt_tool_callback_t fini_cb, void *arg);
 
 int perf_session_queue_event(struct perf_session *s, union perf_event *event,
 			     struct perf_tool *tool, struct perf_sample *sample,
diff --git a/tools/perf/util/tool.h b/tools/perf/util/tool.h
index bb2708bbfaca..222ebd4df6c1 100644
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
@@ -45,4 +47,16 @@ struct perf_tool {
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
+typedef int (*mt_tool_callback_t)(struct perf_tool_mt *, void *);
+
 #endif /* __PERF_TOOL_H */
-- 
2.1.3

