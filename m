Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752319AbaLXHQQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Dec 2014 02:16:16 -0500
Received: from LGEMRELSE6Q.lge.com ([156.147.1.121]:40256 "EHLO
	lgemrelse6q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752180AbaLXHPp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Dec 2014 02:15:45 -0500
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
Subject: [PATCH 30/37] perf tools: Fix progress ui to support multi thread
Date: Wed, 24 Dec 2014 16:15:26 +0900
Message-Id: <1419405333-27952-31-git-send-email-namhyung@kernel.org>
X-Mailer: git-send-email 2.1.3
In-Reply-To: <1419405333-27952-1-git-send-email-namhyung@kernel.org>
References: <1419405333-27952-1-git-send-email-namhyung@kernel.org>
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
 tools/perf/util/data.c    |  22 +++++++++
 tools/perf/util/data.h    |   3 ++
 tools/perf/util/hist.c    |   5 +-
 tools/perf/util/hist.h    |   3 +-
 tools/perf/util/session.c | 117 ++++++++++++++++++++++++++++++++++------------
 tools/perf/util/tool.h    |   3 ++
 6 files changed, 121 insertions(+), 32 deletions(-)

diff --git a/tools/perf/util/data.c b/tools/perf/util/data.c
index b6f7cdc4a39f..37f75f231c4d 100644
--- a/tools/perf/util/data.c
+++ b/tools/perf/util/data.c
@@ -290,3 +290,25 @@ ssize_t perf_data_file__write_multi(struct perf_data_file *file,
 
 	return writen(file->multi_fd[idx], buf, size);
 }
+
+s64 perf_data_file__multi_size(struct perf_data_file *file)
+{
+	int i;
+	s64 total_size = perf_data_file__size(file);
+
+	if (!file->is_multi)
+		return total_size;
+
+	for (i = 0; i < file->nr_multi; i++) {
+		int fd = perf_data_file__multi_fd(file, i);
+		long size;
+
+		size = lseek(fd, 0, SEEK_END);
+		if (size < 0)
+			return (s64) -1;
+
+		total_size += size;
+	}
+
+	return total_size;
+}
diff --git a/tools/perf/util/data.h b/tools/perf/util/data.h
index f5c229166614..0f0013ac9e30 100644
--- a/tools/perf/util/data.h
+++ b/tools/perf/util/data.h
@@ -2,6 +2,7 @@
 #define __PERF_DATA_H
 
 #include <stdbool.h>
+#include "perf.h"
 
 enum perf_data_mode {
 	PERF_DATA_MODE_WRITE,
@@ -61,4 +62,6 @@ int perf_data_file__prepare_write(struct perf_data_file *file, int nr);
 ssize_t perf_data_file__write_multi(struct perf_data_file *file,
 				    void *buf, size_t size, int idx);
 
+s64 perf_data_file__multi_size(struct perf_data_file *file);
+
 #endif /* __PERF_DATA_H */
diff --git a/tools/perf/util/hist.c b/tools/perf/util/hist.c
index f3b39b45f2ec..60b55a92f23e 100644
--- a/tools/perf/util/hist.c
+++ b/tools/perf/util/hist.c
@@ -1065,12 +1065,13 @@ void hists__collapse_resort(struct hists *hists, struct ui_progress *prog)
 	__hists__collapse_resort(hists, root, prog);
 }
 
-void hists__multi_resort(struct hists *dst, struct hists *src)
+void hists__multi_resort(struct hists *dst, struct hists *src,
+			 struct ui_progress *prog)
 {
 	struct rb_root *root = src->entries_in;
 
 	sort__need_collapse = 1;
-	__hists__collapse_resort(dst, root, NULL);
+	__hists__collapse_resort(dst, root, prog);
 }
 
 static int hist_entry__sort(struct hist_entry *a, struct hist_entry *b)
diff --git a/tools/perf/util/hist.h b/tools/perf/util/hist.h
index 4d975f5501ed..e2abc4c75158 100644
--- a/tools/perf/util/hist.h
+++ b/tools/perf/util/hist.h
@@ -124,7 +124,8 @@ int hist_entry__sort_snprintf(struct hist_entry *he, char *bf, size_t size,
 void hist_entry__free(struct hist_entry *);
 
 void hists__output_resort(struct hists *hists, struct ui_progress *prog);
-void hists__multi_resort(struct hists *dst, struct hists *src);
+void hists__multi_resort(struct hists *dst, struct hists *src,
+			 struct ui_progress *prog);
 void hists__collapse_resort(struct hists *hists, struct ui_progress *prog);
 
 void hists__decay_entries(struct hists *hists, bool zap_user, bool zap_kernel);
diff --git a/tools/perf/util/session.c b/tools/perf/util/session.c
index 34956983ae8e..6d1dfbc650ba 100644
--- a/tools/perf/util/session.c
+++ b/tools/perf/util/session.c
@@ -1258,14 +1258,14 @@ fetch_mmaped_event(struct perf_session *session,
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
@@ -1277,8 +1277,6 @@ static int __perf_session__process_events(struct perf_session *session,
 	if (data_size && (data_offset + data_size < file_size))
 		file_size = data_offset + data_size;
 
-	ui_progress__init(&prog, file_size, "Processing events...");
-
 	mmap_size = MMAP_SIZE;
 	if (mmap_size > file_size) {
 		mmap_size = file_size;
@@ -1344,7 +1342,7 @@ static int __perf_session__process_events(struct perf_session *session,
 	head += size;
 	file_pos += size;
 
-	ui_progress__update(&prog, size);
+	ui_progress__update(prog, size);
 
 	if (session_done())
 		goto out;
@@ -1356,7 +1354,6 @@ static int __perf_session__process_events(struct perf_session *session,
 	/* do the final flush for ordered samples */
 	err = ordered_events__flush(session, tool, OE_FLUSH__FINAL);
 out_err:
-	ui_progress__finish();
 	ordered_events__free(&session->ordered_events);
 	session->one_mmap = false;
 	return err;
@@ -1365,25 +1362,32 @@ static int __perf_session__process_events(struct perf_session *session,
 int perf_session__process_events(struct perf_session *session,
 				 struct perf_tool *tool)
 {
-	u64 size = perf_data_file__size(session->file);
+	u64 size;
+	struct ui_progress prog;
+	struct perf_data_file *file = session->file;
 	int err, i;
 
 	if (perf_session__register_idle_thread(session) == NULL)
 		return -ENOMEM;
 
-	if (perf_data_file__is_pipe(session->file))
+	if (perf_data_file__is_pipe(file))
 		return __perf_session__process_pipe_events(session, tool);
 
+	size = perf_data_file__multi_size(file);
+	if ((s64)size < 0)
+		return -EINVAL;
+
+	ui_progress__init(&prog, size, "Processing events...");
+
 	err = __perf_session__process_events(session, &session->stats,
-					     perf_data_file__fd(session->file),
+					     perf_data_file__fd(file),
 					     session->header.data_offset,
 					     session->header.data_size,
-					     size, tool);
+					     perf_data_file__size(file),
+					     tool, &prog);
 
-	if (!session->file->is_multi || err) {
-		events_stats__warn_about_errors(&session->stats, tool);
-		return err;
-	}
+	if (!file->is_multi || err)
+		goto out;
 
 	/*
 	 * For multi-file data storage, events are processed for each
@@ -1391,23 +1395,49 @@ int perf_session__process_events(struct perf_session *session,
 	 */
 	tool->ordered_events = false;
 
-	for (i = 0; i < session->file->nr_multi; i++) {
-		int fd = perf_data_file__multi_fd(session->file, i);
+	for (i = 0; i < file->nr_multi; i++) {
+		int fd = perf_data_file__multi_fd(file, i);
 
 		size = lseek(fd, 0, SEEK_END);
 		if (size == 0)
 			continue;
 
 		err = __perf_session__process_events(session, &session->stats,
-						     fd, 0, size, size, tool);
+						     fd, 0, size, size, tool,
+						     &prog);
 		if (err < 0)
 			break;
 	}
 
+out:
+	ui_progress__finish();
 	events_stats__warn_about_errors(&session->stats, tool);
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
 static void *processing_thread(void *arg)
 {
 	struct perf_tool_mt *mt_tool = arg;
@@ -1418,9 +1448,12 @@ static void *processing_thread(void *arg)
 	if (size == 0)
 		return arg;
 
+	ui_progress__init(&mt_tool->prog, size, "");
+
 	pr_debug("processing samples using thread [%d]\n", mt_tool->idx);
 	if (__perf_session__process_events(mt_tool->session, &mt_tool->stats,
-					   fd, 0, size, size, &mt_tool->tool) < 0) {
+					   fd, 0, size, size, &mt_tool->tool,
+					   &mt_tool->prog) < 0) {
 		pr_err("processing samples failed (thread [%d)\n", mt_tool->idx);
 		free(mt_tool->hists);
 		free(mt_tool);
@@ -1438,9 +1471,11 @@ int perf_session__process_events_mt(struct perf_session *session,
 {
 	struct perf_data_file *file = session->file;
 	struct perf_evlist *evlist = session->evlist;
-	u64 size = perf_data_file__size(file);
+	struct perf_evsel *evsel;
+	u64 size, nr_entries = 0;
 	struct perf_tool_mt *mt_tools = NULL;
 	struct perf_tool_mt *mt;
+	struct ui_progress prog;
 	pthread_t *mt_id;
 	int err, i, k;
 
@@ -1452,14 +1487,25 @@ int perf_session__process_events_mt(struct perf_session *session,
 		return -EINVAL;
 	}
 
+	size = perf_data_file__multi_size(file);
+	if ((s64)size < 0)
+		return -EINVAL;
+
+	ui_progress__init(&prog, size, "Processing events...");
+
 	err = __perf_session__process_events(session, &session->stats,
 					     perf_data_file__fd(file),
 					     session->header.data_offset,
 					     session->header.data_size,
-					     size, tool);
+					     perf_data_file__size(file),
+					     tool, &prog);
 	if (err)
 		return err;
 
+	orig_progress__ops = ui_progress__ops;
+	ui_progress__ops = &mt_progress__ops;
+	ui_progress__ops->finish = orig_progress__ops->finish;
+
 	mt_id = calloc(file->nr_multi, sizeof(*mt_id));
 	if (mt_id == NULL)
 		goto out;
@@ -1485,6 +1531,7 @@ int perf_session__process_events_mt(struct perf_session *session,
 		mt->session = session;
 		mt->tool.ordered_events = false;
 		mt->idx = i;
+		mt->global_prog = &prog;
 
 		err = init_cb(mt, arg);
 		if (err < 0)
@@ -1494,9 +1541,6 @@ int perf_session__process_events_mt(struct perf_session *session,
 	}
 
 	for (i = 0; i < file->nr_multi; i++) {
-		struct perf_evsel *evsel;
-		int err2;
-
 		pthread_join(mt_id[i], (void **)&mt);
 		if (mt == NULL) {
 			err = -EINVAL;
@@ -1506,16 +1550,30 @@ int perf_session__process_events_mt(struct perf_session *session,
 		events_stats__add(&session->stats, &mt->stats);
 
 		evlist__for_each(evlist, evsel) {
-			struct hists *hists;
+			struct hists *hists = evsel__hists(evsel);
 
-			if (perf_evsel__is_dummy_tracking(evsel))
-				continue;
-
-			hists = evsel__hists(evsel);
 			events_stats__add(&hists->stats,
 					  &mt->hists[evsel->idx].stats);
 
-			hists__multi_resort(hists, &mt->hists[evsel->idx]);
+			nr_entries += mt->hists[evsel->idx].nr_entries;
+		}
+	}
+
+	ui_progress__ops = orig_progress__ops;
+	ui_progress__init(&prog, nr_entries, "Merging related events...");
+
+	for (i = 0; i < file->nr_multi; i++) {
+		int err2;
+
+		mt = &mt_tools[i];
+
+		evlist__for_each(evlist, evsel) {
+			struct hists *hists = evsel__hists(evsel);
+
+			if (perf_evsel__is_dummy_tracking(evsel))
+				continue;
+
+			hists__multi_resort(hists, &mt->hists[evsel->idx], &prog);
 
 			/* Non-group events are considered as leader */
 			if (symbol_conf.event_group &&
@@ -1534,6 +1592,7 @@ int perf_session__process_events_mt(struct perf_session *session,
 	}
 
 out:
+	ui_progress__finish();
 	events_stats__warn_about_errors(&session->stats, tool);
 
 	if (mt_tools) {
diff --git a/tools/perf/util/tool.h b/tools/perf/util/tool.h
index 222ebd4df6c1..bd273c85e3cb 100644
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
2.1.3

