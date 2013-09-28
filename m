Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754856Ab3I1TNj (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Sep 2013 15:13:39 -0400
Received: from mail-pd0-f171.google.com ([209.85.192.171]:62839 "EHLO
	mail-pd0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753722Ab3I1TNQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Sep 2013 15:13:16 -0400
From: David Ahern <dsahern@gmail.com>
To: acme@ghostprotocols.net, linux-kernel@vger.kernel.org
Cc: David Ahern <dsahern@gmail.com>,
        Arnaldo Carvalho de Melo <acme@infradead.org>,
        Ingo Molnar <mingo@kernel.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>, Jiri Olsa <jolsa@redhat.com>,
        Namhyung Kim <namhyung.kim@lge.com>,
        Stephane Eranian <eranian@google.com>
Subject: [PATCH 2/7] perf trace: Use new machine method to loop over threads
Date: Sat, 28 Sep 2013 13:12:59 -0600
Message-Id: <1380395584-9025-3-git-send-email-dsahern@gmail.com>
X-Mailer: git-send-email 1.7.10.1
In-Reply-To: <1380395584-9025-1-git-send-email-dsahern@gmail.com>
References: <1380395584-9025-1-git-send-email-dsahern@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use the new machine method that loops over threads to dump summary
data.

Signed-off-by: David Ahern <dsahern@gmail.com>
Cc: Arnaldo Carvalho de Melo <acme@infradead.org>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Namhyung Kim <namhyung.kim@lge.com>
Cc: Stephane Eranian <eranian@google.com>
---
 tools/perf/builtin-trace.c |   76 ++++++++++++++++++++++++++++----------------
 1 file changed, 48 insertions(+), 28 deletions(-)

diff --git a/tools/perf/builtin-trace.c b/tools/perf/builtin-trace.c
index 7290b69..0c93928 100644
--- a/tools/perf/builtin-trace.c
+++ b/tools/perf/builtin-trace.c
@@ -1764,37 +1764,57 @@ static size_t trace__fprintf_threads_header(FILE *fp)
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
-	for (nd = rb_first(&trace->host.threads); nd; nd = rb_next(nd)) {
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
+	machine__for_each_thread(&trace->host, trace__fprintf_one_thread, &data);
+
+	return data.printed;
 }
 
 static int trace__set_duration(const struct option *opt, const char *str,
-- 
1.7.10.1

