Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966967AbaFTKvU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jun 2014 06:51:20 -0400
Received: from forward-corp1e.mail.yandex.net ([77.88.60.199]:39640 "EHLO
	forward-corp1e.mail.yandex.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S966685AbaFTKuU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jun 2014 06:50:20 -0400
X-Yandex-Uniq: 24f386a6-4848-48b5-9a8b-33a8bc26f2b1
Authentication-Results: smtpcorp4.mail.yandex.net; dkim=pass header.i=@yandex-team.ru
From: Stanislav Fomichev <stfomichev@yandex-team.ru>
To: a.p.zijlstra@chello.nl, paulus@samba.org, mingo@redhat.com,
        acme@kernel.org, dsahern@gmail.com, stfomichev@yandex-team.ru,
        jolsa@redhat.com, xiaoguangrong@linux.vnet.ibm.com,
        yangds.fnst@cn.fujitsu.com, adrian.hunter@intel.com,
        namhyung@kernel.org
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 7/7] perf trace: add events cache
Date: Fri, 20 Jun 2014 14:49:49 +0400
Message-Id: <1403261389-13423-8-git-send-email-stfomichev@yandex-team.ru>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1403261389-13423-1-git-send-email-stfomichev@yandex-team.ru>
References: <1403261389-13423-1-git-send-email-stfomichev@yandex-team.ru>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use session to cache and order events from all CPUs so we get
correct ordering of comms/mmaps and faults.

Signed-off-by: Stanislav Fomichev <stfomichev@yandex-team.ru>
---
 tools/perf/builtin-trace.c | 117 ++++++++++++++++++---------------------------
 1 file changed, 46 insertions(+), 71 deletions(-)

diff --git a/tools/perf/builtin-trace.c b/tools/perf/builtin-trace.c
index 3cce721f8b06..e163998547ef 100644
--- a/tools/perf/builtin-trace.c
+++ b/tools/perf/builtin-trace.c
@@ -20,6 +20,11 @@
 #include <sys/mman.h>
 #include <linux/futex.h>
 
+/* keeping the max events to a modest level to keep
+ * the processing of samples per mmap smooth.
+ */
+#define PERF_TRACE__MAX_EVENTS_PER_MMAP  25
+
 /* For older distros: */
 #ifndef MAP_STACK
 # define MAP_STACK		0x20000
@@ -2001,10 +2006,12 @@ static int perf_evlist__add_pgfault(struct perf_evlist *evlist,
 
 static int trace__run(struct trace *trace, int argc, const char **argv)
 {
+	struct perf_data_file file = {
+		.mode = PERF_DATA_MODE_WRITE,
+	};
+	struct perf_session *session;
 	struct perf_evlist *evlist = perf_evlist__new();
-	struct perf_evsel *evsel;
-	int err = -1, i;
-	unsigned long before;
+	int err = -1;
 	const bool forks = argc > 0;
 
 	trace->live = true;
@@ -2049,6 +2056,18 @@ static int trace__run(struct trace *trace, int argc, const char **argv)
 
 	perf_evlist__config(evlist, &trace->opts);
 
+	session = perf_session__new(&file, false, &trace->tool);
+	if (session == NULL) {
+		err = -ENOMEM;
+		goto out_delete_evlist;
+	}
+	session->evlist = evlist;
+	perf_session__set_id_hdr_size(session);
+	machine__synthesize_threads(&session->machines.host,
+				    &trace->opts.target,
+				    evlist->threads, false);
+	trace->host = &session->machines.host;
+
 	signal(SIGCHLD, sig_handler);
 	signal(SIGINT, sig_handler);
 
@@ -2068,7 +2087,7 @@ static int trace__run(struct trace *trace, int argc, const char **argv)
 	err = perf_evlist__mmap(evlist, trace->opts.mmap_pages, false);
 	if (err < 0) {
 		fprintf(trace->output, "Couldn't mmap the events: %s\n", strerror(errno));
-		goto out_delete_evlist;
+		goto out_delete_session;
 	}
 
 	perf_evlist__enable(evlist);
@@ -2077,67 +2096,19 @@ static int trace__run(struct trace *trace, int argc, const char **argv)
 		perf_evlist__start_workload(evlist);
 
 	trace->multiple_threads = evlist->threads->map[0] == -1 || evlist->threads->nr > 1;
-again:
-	before = trace->nr_events;
-
-	for (i = 0; i < evlist->nr_mmaps; i++) {
-		union perf_event *event;
-
-		while ((event = perf_evlist__mmap_read(evlist, i)) != NULL) {
-			const u32 type = event->header.type;
-			tracepoint_handler handler;
-			struct perf_sample sample;
-
-			++trace->nr_events;
 
-			err = perf_evlist__parse_sample(evlist, event, &sample);
-			if (err) {
-				fprintf(trace->output, "Can't parse sample, err = %d, skipping...\n", err);
-				goto next_event;
-			}
-
-			if (!trace->full_time && trace->base_time == 0)
-				trace->base_time = sample.time;
-
-			if (type != PERF_RECORD_SAMPLE) {
-				trace__process_event(trace, trace->host, event, &sample);
-				continue;
-			}
-
-			evsel = perf_evlist__id2evsel(evlist, sample.id);
-			if (evsel == NULL) {
-				fprintf(trace->output, "Unknown tp ID %" PRIu64 ", skipping...\n", sample.id);
-				goto next_event;
-			}
-
-			if (evsel->attr.type == PERF_TYPE_TRACEPOINT &&
-			    sample.raw_data == NULL) {
-				fprintf(trace->output, "%s sample with no payload for tid: %d, cpu %d, raw_size=%d, skipping...\n",
-				       perf_evsel__name(evsel), sample.tid,
-				       sample.cpu, sample.raw_size);
-				goto next_event;
-			}
-
-			handler = evsel->handler;
-			handler(trace, evsel, event, &sample);
-next_event:
-			perf_evlist__mmap_consume(evlist, i);
-
-			if (interrupted)
-				goto out_disable;
-		}
-	}
+	while (!done) {
+		int rc;
 
-	if (trace->nr_events == before) {
-		int timeout = done ? 100 : -1;
+		rc = perf_session__mmap_read(&trace->tool, session, evlist,
+					     PERF_TRACE__MAX_EVENTS_PER_MMAP);
+		if (rc < 0)
+			break;
 
-		if (poll(evlist->pollfd, evlist->nr_fds, timeout) > 0)
-			goto again;
-	} else {
-		goto again;
+		if (!rc && !done)
+			err = poll(evlist->pollfd, evlist->nr_fds, 100);
 	}
 
-out_disable:
 	perf_evlist__disable(evlist);
 
 	if (!err) {
@@ -2153,6 +2124,8 @@ out_disable:
 		}
 	}
 
+out_delete_session:
+	perf_session__delete(session);
 out_delete_evlist:
 	perf_evlist__delete(evlist);
 out:
@@ -2187,17 +2160,6 @@ static int trace__replay(struct trace *trace)
 	struct perf_evsel *evsel;
 	int err = -1;
 
-	trace->tool.sample	  = trace__process_sample;
-	trace->tool.mmap	  = perf_event__process_mmap;
-	trace->tool.mmap2	  = perf_event__process_mmap2;
-	trace->tool.comm	  = perf_event__process_comm;
-	trace->tool.exit	  = perf_event__process_exit;
-	trace->tool.fork	  = perf_event__process_fork;
-	trace->tool.attr	  = perf_event__process_attr;
-	trace->tool.tracing_data = perf_event__process_tracing_data;
-	trace->tool.build_id	  = perf_event__process_build_id;
-
-	trace->tool.ordered_samples = true;
 	trace->tool.ordering_requires_timestamps = true;
 
 	/* add tid to output */
@@ -2547,6 +2509,19 @@ int cmd_trace(int argc, const char **argv, const char *prefix __maybe_unused)
 	if (!argc && target__none(&trace.opts.target))
 		trace.opts.target.system_wide = true;
 
+	trace.tool.sample	  = trace__process_sample;
+	trace.tool.mmap	  = perf_event__process_mmap;
+	trace.tool.mmap2	  = perf_event__process_mmap2;
+	trace.tool.comm	  = perf_event__process_comm;
+	trace.tool.exit	  = perf_event__process_exit;
+	trace.tool.fork	  = perf_event__process_fork;
+	trace.tool.attr	  = perf_event__process_attr;
+	trace.tool.tracing_data = perf_event__process_tracing_data;
+	trace.tool.build_id	  = perf_event__process_build_id;
+
+	trace.tool.ordered_samples = true;
+	perf_tool__fill_defaults(&trace.tool);
+
 	if (input_name)
 		err = trace__replay(&trace);
 	else
-- 
1.8.3.2

