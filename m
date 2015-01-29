Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754472AbbA2ILD (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Jan 2015 03:11:03 -0500
Received: from LGEMRELSE6Q.lge.com ([156.147.1.121]:51628 "EHLO
	lgemrelse6q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753548AbbA2IKV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Jan 2015 03:10:21 -0500
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
Subject: [PATCH 38/42] perf session: Handle index files generally
Date: Thu, 29 Jan 2015 17:07:19 +0900
Message-Id: <1422518843-25818-39-git-send-email-namhyung@kernel.org>
X-Mailer: git-send-email 2.2.2
In-Reply-To: <1422518843-25818-1-git-send-email-namhyung@kernel.org>
References: <1422518843-25818-1-git-send-email-namhyung@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The current code assumes that the number of index item and cpu are
matched so it creates that number of threads.  But it's not the case
of non-system-wide session or data came from different machine.

Just creates threads at most number of online cpus and process data.

Signed-off-by: Namhyung Kim <namhyung@kernel.org>
---
 tools/perf/util/session.c | 68 ++++++++++++++++++++++++++++++++++-------------
 tools/perf/util/tool.h    |  1 -
 2 files changed, 50 insertions(+), 19 deletions(-)

diff --git a/tools/perf/util/session.c b/tools/perf/util/session.c
index 6d34c880010f..ccf9371ef292 100644
--- a/tools/perf/util/session.c
+++ b/tools/perf/util/session.c
@@ -1431,26 +1431,51 @@ static struct ui_progress_ops mt_progress__ops = {
 	.update = mt_progress__update,
 };
 
+static int perf_session__get_index(struct perf_session *session)
+{
+	int ret;
+	static unsigned index;
+	static pthread_mutex_t idx_lock = PTHREAD_MUTEX_INITIALIZER;
+
+	pthread_mutex_lock(&idx_lock);
+	if (index < session->header.nr_index)
+		ret = index++;
+	else
+		ret = -1;
+	pthread_mutex_unlock(&idx_lock);
+
+	return ret;
+}
+
 static void *processing_thread_idx(void *arg)
 {
 	struct perf_tool_mt *mt_tool = arg;
 	struct perf_session *session = mt_tool->session;
 	int fd = perf_data_file__fd(session->file);
-	u64 offset = session->header.index[mt_tool->idx].offset;
-	u64 size = session->header.index[mt_tool->idx].size;
 	u64 file_size = perf_data_file__size(session->file);
+	int idx;
 
-	ui_progress__init(&mt_tool->prog, size, "");
+	while ((idx = perf_session__get_index(session)) >= 0) {
+		u64 offset = session->header.index[idx].offset;
+		u64 size = session->header.index[idx].size;
+		struct perf_tool_mt *mtt = &mt_tool[idx];
 
-	pr_debug("processing samples using thread [%d]\n", mt_tool->idx);
-	if (__perf_session__process_events(session, &mt_tool->stats,
-					   fd, offset, size, file_size,
-					   &mt_tool->tool, &mt_tool->prog) < 0) {
-		pr_err("processing samples failed (thread [%d)\n", mt_tool->idx);
-		return NULL;
+		if (size == 0)
+			continue;
+
+		pr_debug("processing samples [index %d]\n", idx);
+
+		ui_progress__init(&mtt->prog, size, "");
+
+		if (__perf_session__process_events(session, &mtt->stats,
+						   fd, offset, size, file_size,
+						   &mtt->tool, &mtt->prog) < 0) {
+			pr_err("processing samples failed [index %d]\n", idx);
+			return NULL;
+		}
+		pr_debug("processing samples done [index %d]\n", idx);
 	}
 
-	pr_debug("processing samples done for thread [%d]\n", mt_tool->idx);
 	return arg;
 }
 
@@ -1468,6 +1493,7 @@ int perf_session__process_events_mt(struct perf_session *session,
 	int err, i, k;
 	int nr_index = session->header.nr_index;
 	u64 size = perf_data_file__size(file);
+	int nr_thread = sysconf(_SC_NPROCESSORS_ONLN);
 
 	if (perf_session__register_idle_thread(session) == NULL)
 		return -ENOMEM;
@@ -1491,10 +1517,6 @@ int perf_session__process_events_mt(struct perf_session *session,
 	ui_progress__ops = &mt_progress__ops;
 	ui_progress__ops->finish = orig_progress__ops->finish;
 
-	th_id = calloc(nr_index, sizeof(*th_id));
-	if (th_id == NULL)
-		goto out;
-
 	mt_tools = calloc(nr_index, sizeof(*mt_tools));
 	if (mt_tools == NULL)
 		goto out;
@@ -1513,20 +1535,30 @@ int perf_session__process_events_mt(struct perf_session *session,
 
 		mt->session = session;
 		mt->tool.ordered_events = false;
-		mt->idx = i;
 		mt->priv = arg;
 		mt->global_prog = &prog;
-
-		pthread_create(&th_id[i], NULL, processing_thread_idx, mt);
 	}
 
-	for (i = 0; i < nr_index; i++) {
+	if (nr_thread > nr_index)
+		nr_thread = nr_index;
+
+	th_id = calloc(nr_thread, sizeof(*th_id));
+	if (th_id == NULL)
+		goto out;
+
+	for (i = 0; i < nr_thread; i++)
+		pthread_create(&th_id[i], NULL, processing_thread_idx, mt_tools);
+
+	for (i = 0; i < nr_thread; i++) {
 		pthread_join(th_id[i], (void **)&mt);
 		if (mt == NULL) {
 			err = -EINVAL;
 			continue;
 		}
+	}
 
+	for (i = 0; i < nr_index; i++) {
+		mt = &mt_tools[i];
 		events_stats__add(&session->stats, &mt->stats);
 
 		evlist__for_each(evlist, evsel) {
diff --git a/tools/perf/util/tool.h b/tools/perf/util/tool.h
index aa7f110b9425..e52c936d1b9e 100644
--- a/tools/perf/util/tool.h
+++ b/tools/perf/util/tool.h
@@ -55,7 +55,6 @@ struct perf_tool_mt {
 	struct perf_session	*session;
 	struct ui_progress	prog;
 	struct ui_progress	*global_prog;
-	int			idx;
 
 	void			*priv;
 };
-- 
2.2.2

