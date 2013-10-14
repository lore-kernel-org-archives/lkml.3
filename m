Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932490Ab3JNUUl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Oct 2013 16:20:41 -0400
Received: from merlin.infradead.org ([205.233.59.134]:39015 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757708Ab3JNUDG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Oct 2013 16:03:06 -0400
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org, David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Jiri Olsa <jolsa@redhat.com>,
        Namhyung Kim <namhyung.kim@lge.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Stephane Eranian <eranian@google.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 126/161] perf trace: Use new machine method to loop over threads
Date: Mon, 14 Oct 2013 17:01:55 -0300
Message-Id: <1381780950-25642-127-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.8.1.4
In-Reply-To: <1381780950-25642-1-git-send-email-acme@infradead.org>
References: <1381780950-25642-1-git-send-email-acme@infradead.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by merlin.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: David Ahern <dsahern@gmail.com>

Use the new machine method that loops over threads to dump summary data.

Signed-off-by: David Ahern <dsahern@gmail.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Namhyung Kim <namhyung.kim@lge.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Stephane Eranian <eranian@google.com>
Link: http://lkml.kernel.org/r/1380395584-9025-3-git-send-email-dsahern@gmail.com
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/builtin-trace.c | 76 +++++++++++++++++++++++++++++-----------------
 1 file changed, 48 insertions(+), 28 deletions(-)

diff --git a/tools/perf/builtin-trace.c b/tools/perf/builtin-trace.c
index 1e2368f56a74..addc3e11f999 100644
--- a/tools/perf/builtin-trace.c
+++ b/tools/perf/builtin-trace.c
@@ -1751,37 +1751,57 @@ static size_t trace__fprintf_threads_header(FILE *fp)
 	return printed;
 }
 
+/* struct used to pass data to per-thread function */
+struct summary_data {
+	FILE *fp;
+	struct trace *trace;
+	size_t printed;
+};
+
+static int trace__fprintf_one_thread(struct thread *thread, void *priv)
+{
+	struct summary_data *data = priv;
+	FILE *fp = data->fp;
+	size_t printed = data->printed;
+	struct trace *trace = data->trace;
+	struct thread_trace *ttrace = thread->priv;
+	const char *color;
+	double ratio;
+
+	if (ttrace == NULL)
+		return 0;
+
+	ratio = (double)ttrace->nr_events / trace->nr_events * 100.0;
+
+	color = PERF_COLOR_NORMAL;
+	if (ratio > 50.0)
+		color = PERF_COLOR_RED;
+	else if (ratio > 25.0)
+		color = PERF_COLOR_GREEN;
+	else if (ratio > 5.0)
+		color = PERF_COLOR_YELLOW;
+
+	printed += color_fprintf(fp, color, "%20s", thread->comm);
+	printed += fprintf(fp, " - %-5d :%11lu   [", thread->tid, ttrace->nr_events);
+	printed += color_fprintf(fp, color, "%5.1f%%", ratio);
+	printed += fprintf(fp, " ] %10.3f ms\n", ttrace->runtime_ms);
+
+	data->printed += printed;
+
+	return 0;
+}
+
 static size_t trace__fprintf_thread_summary(struct trace *trace, FILE *fp)
 {
-	size_t printed = trace__fprintf_threads_header(fp);
-	struct rb_node *nd;
-
-	for (nd = rb_first(&trace->host->threads); nd; nd = rb_next(nd)) {
-		struct thread *thread = rb_entry(nd, struct thread, rb_node);
-		struct thread_trace *ttrace = thread->priv;
-		const char *color;
-		double ratio;
-
-		if (ttrace == NULL)
-			continue;
-
-		ratio = (double)ttrace->nr_events / trace->nr_events * 100.0;
-
-		color = PERF_COLOR_NORMAL;
-		if (ratio > 50.0)
-			color = PERF_COLOR_RED;
-		else if (ratio > 25.0)
-			color = PERF_COLOR_GREEN;
-		else if (ratio > 5.0)
-			color = PERF_COLOR_YELLOW;
-
-		printed += color_fprintf(fp, color, "%20s", thread->comm);
-		printed += fprintf(fp, " - %-5d :%11lu   [", thread->tid, ttrace->nr_events);
-		printed += color_fprintf(fp, color, "%5.1f%%", ratio);
-		printed += fprintf(fp, " ] %10.3f ms\n", ttrace->runtime_ms);
-	}
+	struct summary_data data = {
+		.fp = fp,
+		.trace = trace
+	};
+	data.printed = trace__fprintf_threads_header(fp);
 
-	return printed;
+	machine__for_each_thread(trace->host, trace__fprintf_one_thread, &data);
+
+	return data.printed;
 }
 
 static int trace__set_duration(const struct option *opt, const char *str,
-- 
1.8.1.4

