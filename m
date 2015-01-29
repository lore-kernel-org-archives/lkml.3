Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754601AbbA2IMt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Jan 2015 03:12:49 -0500
Received: from LGEMRELSE6Q.lge.com ([156.147.1.121]:51607 "EHLO
	lgemrelse6q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753489AbbA2IKU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Jan 2015 03:10:20 -0500
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
Subject: [PATCH 36/42] perf tools: Fix progress ui to support multi thread
Date: Thu, 29 Jan 2015 17:07:17 +0900
Message-Id: <1422518843-25818-37-git-send-email-namhyung@kernel.org>
X-Mailer: git-send-email 2.2.2
In-Reply-To: <1422518843-25818-1-git-send-email-namhyung@kernel.org>
References: <1422518843-25818-1-git-send-email-namhyung@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Split ui_progress struct into global and local one.  Each thread
updates local struct without lock and only updates global one if
meaningful progress is done (with lock).

To do that, pass struct ui_progress to __perf_session__process_event()
and set it for the total size of multi-file storage.

Signed-off-by: Namhyung Kim <namhyung@kernel.org>
---
 tools/perf/util/hist.c    |  5 ++--
 tools/perf/util/hist.h    |  3 ++-
 tools/perf/util/session.c | 63 +++++++++++++++++++++++++++++++++++++----------
 tools/perf/util/tool.h    |  3 +++
 4 files changed, 58 insertions(+), 16 deletions(-)

diff --git a/tools/perf/util/hist.c b/tools/perf/util/hist.c
index 14d4b9358ac6..dab3b8b3a06a 100644
--- a/tools/perf/util/hist.c
+++ b/tools/perf/util/hist.c
@@ -1062,12 +1062,13 @@ void hists__collapse_resort(struct hists *hists, struct ui_progress *prog)
 	__hists__collapse_resort(hists, root, prog);
 }
 
-void hists__mt_resort(struct hists *dst, struct hists *src)
+void hists__mt_resort(struct hists *dst, struct hists *src,
+		      struct ui_progress *prog)
 {
 	struct rb_root *root = src->entries_in;
 
 	sort__need_collapse = 1;
-	__hists__collapse_resort(dst, root, NULL);
+	__hists__collapse_resort(dst, root, prog);
 }
 
 static int hist_entry__sort(struct hist_entry *a, struct hist_entry *b)
diff --git a/tools/perf/util/hist.h b/tools/perf/util/hist.h
index 2c29d70b2cfe..94179107906a 100644
--- a/tools/perf/util/hist.h
+++ b/tools/perf/util/hist.h
@@ -124,7 +124,8 @@ int hist_entry__sort_snprintf(struct hist_entry *he, char *bf, size_t size,
 void hist_entry__delete(struct hist_entry *he);
 
 void hists__output_resort(struct hists *hists, struct ui_progress *prog);
-void hists__mt_resort(struct hists *dst, struct hists *src);
+void hists__mt_resort(struct hists *dst, struct hists *src,
+		      struct ui_progress *prog);
 void hists__collapse_resort(struct hists *hists, struct ui_progress *prog);
 
 void hists__decay_entries(struct hists *hists, bool zap_user, bool zap_kernel);
diff --git a/tools/perf/util/session.c b/tools/perf/util/session.c
index 507db51ccfea..3596bb608f3c 100644
--- a/tools/perf/util/session.c
+++ b/tools/perf/util/session.c
@@ -1260,14 +1260,14 @@ fetch_mmaped_event(struct perf_session *session,
 static int __perf_session__process_events(struct perf_session *session,
 					  struct events_stats *stats, int fd,
 					  u64 data_offset, u64 data_size,
-					  u64 file_size, struct perf_tool *tool)
+					  u64 file_size, struct perf_tool *tool,
+					  struct ui_progress *prog)
 {
 	u64 head, page_offset, file_offset, file_pos, size;
 	int err, mmap_prot, mmap_flags, map_idx = 0;
 	size_t	mmap_size;
 	char *buf, *mmaps[NUM_MMAPS];
 	union perf_event *event;
-	struct ui_progress prog;
 	s64 skip;
 
 	perf_tool__fill_defaults(tool);
@@ -1279,8 +1279,6 @@ static int __perf_session__process_events(struct perf_session *session,
 	if (data_size && (data_offset + data_size < file_size))
 		file_size = data_offset + data_size;
 
-	ui_progress__init(&prog, file_size, "Processing events...");
-
 	mmap_size = MMAP_SIZE;
 	if (mmap_size > file_size) {
 		mmap_size = file_size;
@@ -1346,7 +1344,7 @@ static int __perf_session__process_events(struct perf_session *session,
 	head += size;
 	file_pos += size;
 
-	ui_progress__update(&prog, size);
+	ui_progress__update(prog, size);
 
 	if (session_done())
 		goto out;
@@ -1358,7 +1356,6 @@ static int __perf_session__process_events(struct perf_session *session,
 	/* do the final flush for ordered samples */
 	err = ordered_events__flush(session, tool, OE_FLUSH__FINAL);
 out_err:
-	ui_progress__finish();
 	ordered_events__free(&session->ordered_events);
 	session->one_mmap = false;
 	return err;
@@ -1367,6 +1364,7 @@ static int __perf_session__process_events(struct perf_session *session,
 int perf_session__process_events(struct perf_session *session,
 				 struct perf_tool *tool)
 {
+	struct ui_progress prog;
 	struct perf_data_file *file = session->file;
 	u64 size = perf_data_file__size(file);
 	int err, i;
@@ -1377,11 +1375,13 @@ int perf_session__process_events(struct perf_session *session,
 	if (perf_data_file__is_pipe(file))
 		return __perf_session__process_pipe_events(session, tool);
 
+	ui_progress__init(&prog, size, "Processing events...");
+
 	err = __perf_session__process_events(session, &session->stats,
 					     perf_data_file__fd(file),
 					     session->header.data_offset,
 					     session->header.data_size,
-					     size, tool);
+					     size, tool, &prog);
 
 	if (err < 0 || !perf_session__has_index(session))
 		return err;
@@ -1400,7 +1400,7 @@ int perf_session__process_events(struct perf_session *session,
 						perf_data_file__fd(file),
 						session->header.index[i].offset,
 						session->header.index[i].size,
-						size, tool);
+						size, tool, &prog);
 		if (err < 0)
 			break;
 	}
@@ -1408,6 +1408,29 @@ int perf_session__process_events(struct perf_session *session,
 	return err;
 }
 
+struct ui_progress_ops *orig_progress__ops;
+
+static void mt_progress__update(struct ui_progress *p)
+{
+	struct perf_tool_mt *mt_tool = container_of(p, struct perf_tool_mt, prog);
+	struct ui_progress *gprog = mt_tool->global_prog;
+	static pthread_mutex_t prog_lock = PTHREAD_MUTEX_INITIALIZER;
+
+	pthread_mutex_lock(&prog_lock);
+
+	gprog->curr += p->step;
+	if (gprog->curr >= gprog->next) {
+		gprog->next += gprog->step;
+		orig_progress__ops->update(gprog);
+	}
+
+	pthread_mutex_unlock(&prog_lock);
+}
+
+static struct ui_progress_ops mt_progress__ops = {
+	.update = mt_progress__update,
+};
+
 static void *processing_thread_idx(void *arg)
 {
 	struct perf_tool_mt *mt_tool = arg;
@@ -1417,10 +1440,12 @@ static void *processing_thread_idx(void *arg)
 	u64 size = session->header.index[mt_tool->idx].size;
 	u64 file_size = perf_data_file__size(session->file);
 
+	ui_progress__init(&mt_tool->prog, size, "");
+
 	pr_debug("processing samples using thread [%d]\n", mt_tool->idx);
 	if (__perf_session__process_events(session, &mt_tool->stats,
 					   fd, offset, size, file_size,
-					   &mt_tool->tool) < 0) {
+					   &mt_tool->tool, &mt_tool->prog) < 0) {
 		pr_err("processing samples failed (thread [%d)\n", mt_tool->idx);
 		return NULL;
 	}
@@ -1438,7 +1463,8 @@ int perf_session__process_events_mt(struct perf_session *session,
 	u64 nr_entries = 0;
 	struct perf_tool_mt *mt_tools = NULL;
 	struct perf_tool_mt *mt;
-	pthread_t *th_id;
+	struct ui_progress prog;
+	pthread_t *th_id = NULL;
 	int err, i, k;
 	int nr_index = session->header.nr_index;
 	u64 size = perf_data_file__size(file);
@@ -1451,13 +1477,19 @@ int perf_session__process_events_mt(struct perf_session *session,
 		return -EINVAL;
 	}
 
+	ui_progress__init(&prog, size, "Processing events...");
+
 	err = __perf_session__process_events(session, &session->stats,
 					     perf_data_file__fd(file),
 					     session->header.data_offset,
 					     session->header.data_size,
-					     size, tool);
+					     size, tool, &prog);
 	if (err)
-		return err;
+		goto out;
+
+	orig_progress__ops = ui_progress__ops;
+	ui_progress__ops = &mt_progress__ops;
+	ui_progress__ops->finish = orig_progress__ops->finish;
 
 	th_id = calloc(nr_index, sizeof(*th_id));
 	if (th_id == NULL)
@@ -1483,6 +1515,7 @@ int perf_session__process_events_mt(struct perf_session *session,
 		mt->tool.ordered_events = false;
 		mt->idx = i;
 		mt->priv = arg;
+		mt->global_prog = &prog;
 
 		pthread_create(&th_id[i], NULL, processing_thread_idx, mt);
 	}
@@ -1506,6 +1539,9 @@ int perf_session__process_events_mt(struct perf_session *session,
 		}
 	}
 
+	ui_progress__ops = orig_progress__ops;
+	ui_progress__init(&prog, nr_entries, "Merging related events...");
+
 	for (i = 0; i < nr_index; i++) {
 		mt = &mt_tools[i];
 
@@ -1515,7 +1551,7 @@ int perf_session__process_events_mt(struct perf_session *session,
 			if (perf_evsel__is_dummy_tracking(evsel))
 				continue;
 
-			hists__mt_resort(hists, &mt->hists[evsel->idx]);
+			hists__mt_resort(hists, &mt->hists[evsel->idx], &prog);
 
 			/* Non-group events are considered as leader */
 			if (symbol_conf.event_group &&
@@ -1530,6 +1566,7 @@ int perf_session__process_events_mt(struct perf_session *session,
 	}
 
 out:
+	ui_progress__finish();
 	events_stats__warn_about_errors(&session->stats, tool);
 
 	if (mt_tools) {
diff --git a/tools/perf/util/tool.h b/tools/perf/util/tool.h
index a04826bbe991..aa7f110b9425 100644
--- a/tools/perf/util/tool.h
+++ b/tools/perf/util/tool.h
@@ -3,6 +3,7 @@
 
 #include <stdbool.h>
 #include "util/event.h"
+#include "ui/progress.h"
 
 struct perf_session;
 union perf_event;
@@ -52,6 +53,8 @@ struct perf_tool_mt {
 	struct events_stats	stats;
 	struct hists		*hists;
 	struct perf_session	*session;
+	struct ui_progress	prog;
+	struct ui_progress	*global_prog;
 	int			idx;
 
 	void			*priv;
-- 
2.2.2

