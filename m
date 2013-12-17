Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754663Ab3LQUwc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Dec 2013 15:52:32 -0500
Received: from merlin.infradead.org ([205.233.59.134]:56145 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754429Ab3LQUwV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Dec 2013 15:52:21 -0500
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org,
        Stanislav Fomichev <stfomichev@yandex-team.ru>,
        Ingo Molnar <mingo@redhat.com>, Jiri Olsa <jolsa@redhat.com>,
        Namhyung Kim <namhyung@kernel.org>, Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Ramkumar Ramachandra <artagnon@gmail.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 04/10] perf timechart: Get number of CPUs from perf header
Date: Tue, 17 Dec 2013 17:52:05 -0300
Message-Id: <1387313531-14629-5-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.8.1.4
In-Reply-To: <1387313531-14629-1-git-send-email-acme@infradead.org>
References: <1387313531-14629-1-git-send-email-acme@infradead.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by merlin.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Stanislav Fomichev <stfomichev@yandex-team.ru>

Print all CPUs, even if there were no events (use perf header to get
number of CPUs).

This is required to support topology in the next patch.

Signed-off-by: Stanislav Fomichev <stfomichev@yandex-team.ru>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Ramkumar Ramachandra <artagnon@gmail.com>
Link: http://lkml.kernel.org/r/1385995056-20158-4-git-send-email-stfomichev@yandex-team.ru
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/builtin-timechart.c | 32 ++++++++++++++++++++++++++------
 1 file changed, 26 insertions(+), 6 deletions(-)

diff --git a/tools/perf/builtin-timechart.c b/tools/perf/builtin-timechart.c
index 99fe363f1de8..db9c4c172587 100644
--- a/tools/perf/builtin-timechart.c
+++ b/tools/perf/builtin-timechart.c
@@ -531,12 +531,10 @@ static int process_sample_event(struct perf_tool *tool,
 			tchart->last_time = sample->time;
 	}
 
-	if (sample->cpu > tchart->numcpus)
-		tchart->numcpus = sample->cpu;
-
 	if (evsel->handler != NULL) {
 		tracepoint_handler f = evsel->handler;
-		return f(tchart, evsel, sample, cat_backtrace(event, sample, machine));
+		return f(tchart, evsel, sample,
+			 cat_backtrace(event, sample, machine));
 	}
 
 	return 0;
@@ -1038,8 +1036,6 @@ static void write_svg_file(struct timechart *tchart, const char *filename)
 	int count;
 	int thresh = TIME_THRESH;
 
-	tchart->numcpus++;
-
 	if (tchart->power_only)
 		tchart->proc_num = 0;
 
@@ -1069,6 +1065,25 @@ static void write_svg_file(struct timechart *tchart, const char *filename)
 	svg_close();
 }
 
+static int process_header(struct perf_file_section *section __maybe_unused,
+			  struct perf_header *ph,
+			  int feat,
+			  int fd __maybe_unused,
+			  void *data)
+{
+	struct timechart *tchart = data;
+
+	switch (feat) {
+	case HEADER_NRCPUS:
+		tchart->numcpus = ph->env.nr_cpus_avail;
+		break;
+	default:
+		break;
+	}
+
+	return 0;
+}
+
 static int __cmd_timechart(struct timechart *tchart, const char *output_name)
 {
 	const struct perf_evsel_str_handler power_tracepoints[] = {
@@ -1094,6 +1109,11 @@ static int __cmd_timechart(struct timechart *tchart, const char *output_name)
 	if (session == NULL)
 		return -ENOMEM;
 
+	(void)perf_header__process_sections(&session->header,
+					    perf_data_file__fd(session->file),
+					    tchart,
+					    process_header);
+
 	if (!perf_session__has_traces(session, "timechart record"))
 		goto out_delete;
 
-- 
1.8.1.4

