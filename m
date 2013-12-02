Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752672Ab3LBOiJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Dec 2013 09:38:09 -0500
Received: from forward-corp1g.mail.yandex.net ([95.108.253.251]:41250 "EHLO
	forward-corp1g.mail.yandex.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752636Ab3LBOiF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Dec 2013 09:38:05 -0500
Authentication-Results: smtpcorp4.mail.yandex.net; dkim=pass header.i=@yandex-team.ru
From: Stanislav Fomichev <stfomichev@yandex-team.ru>
To: linux-kernel@vger.kernel.org
Cc: a.p.zijlstra@chello.nl, paulus@samba.org, mingo@redhat.com,
        acme@ghostprotocols.net, stfomichev@yandex-team.ru,
        namhyung@kernel.org, artagnon@gmail.com, jolsa@redhat.com
Subject: [PATCH 3/5] perf timechart: get number of CPUs from perf header
Date: Mon,  2 Dec 2013 18:37:35 +0400
Message-Id: <1385995056-20158-4-git-send-email-stfomichev@yandex-team.ru>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1385995056-20158-1-git-send-email-stfomichev@yandex-team.ru>
References: <1385995056-20158-1-git-send-email-stfomichev@yandex-team.ru>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Print all CPUs, even if there were no events (use perf header to get number
of CPUs).
This is required to support topology in the next patch.

Signed-off-by: Stanislav Fomichev <stfomichev@yandex-team.ru>
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
1.8.3.2

