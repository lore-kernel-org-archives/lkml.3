Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933305Ab3JOFbL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Oct 2013 01:31:11 -0400
Received: from terminus.zytor.com ([198.137.202.10]:33558 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750904Ab3JOFbI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Oct 2013 01:31:08 -0400
Date: Mon, 14 Oct 2013 22:30:52 -0700
From: tip-bot for David Ahern <tipbot@zytor.com>
Message-ID: <tip-896cbb56bfee6ad99e0ee1b8209dc678f1a49f5a@git.kernel.org>
Cc: acme@redhat.com, linux-kernel@vger.kernel.org, eranian@google.com,
        hpa@zytor.com, mingo@kernel.org, a.p.zijlstra@chello.nl,
        namhyung.kim@lge.com, jolsa@redhat.com, fweisbec@gmail.com,
        dsahern@gmail.com, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, eranian@google.com,
        linux-kernel@vger.kernel.org, acme@redhat.com, a.p.zijlstra@chello.nl,
        namhyung.kim@lge.com, jolsa@redhat.com, fweisbec@gmail.com,
        dsahern@gmail.com, tglx@linutronix.de
In-Reply-To: <1380395584-9025-3-git-send-email-dsahern@gmail.com>
References: <1380395584-9025-3-git-send-email-dsahern@gmail.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf trace:
  Use new machine method to loop over threads
Git-Commit-ID: 896cbb56bfee6ad99e0ee1b8209dc678f1a49f5a
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.1 (terminus.zytor.com [127.0.0.1]); Mon, 14 Oct 2013 22:30:57 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  896cbb56bfee6ad99e0ee1b8209dc678f1a49f5a
Gitweb:     http://git.kernel.org/tip/896cbb56bfee6ad99e0ee1b8209dc678f1a49f5a
Author:     David Ahern <dsahern@gmail.com>
AuthorDate: Sat, 28 Sep 2013 13:12:59 -0600
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Fri, 11 Oct 2013 12:17:53 -0300

perf trace: Use new machine method to loop over threads

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
index 1e2368f..addc3e1 100644
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
