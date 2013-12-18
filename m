Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753719Ab3LRKb3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Dec 2013 05:31:29 -0500
Received: from terminus.zytor.com ([198.137.202.10]:44574 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753587Ab3LRKbZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Dec 2013 05:31:25 -0500
Date: Wed, 18 Dec 2013 02:31:03 -0800
From: tip-bot for Stanislav Fomichev <tipbot@zytor.com>
Message-ID: <tip-58b9a18ecd251cbd6e666ad792023ab77c7d100e@git.kernel.org>
Cc: acme@redhat.com, linux-kernel@vger.kernel.org, paulus@samba.org,
        mingo@redhat.com, hpa@zytor.com, mingo@kernel.org,
        a.p.zijlstra@chello.nl, namhyung@kernel.org, jolsa@redhat.com,
        stfomichev@yandex-team.ru, artagnon@gmail.com, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, mingo@redhat.com, paulus@samba.org,
        linux-kernel@vger.kernel.org, acme@redhat.com, a.p.zijlstra@chello.nl,
        namhyung@kernel.org, jolsa@redhat.com, stfomichev@yandex-team.ru,
        tglx@linutronix.de, artagnon@gmail.com
In-Reply-To: <1385995056-20158-4-git-send-email-stfomichev@yandex-team.ru>
References: <1385995056-20158-4-git-send-email-stfomichev@yandex-team.ru>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf timechart:
  Get number of CPUs from perf header
Git-Commit-ID: 58b9a18ecd251cbd6e666ad792023ab77c7d100e
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.1 (terminus.zytor.com [127.0.0.1]); Wed, 18 Dec 2013 02:31:09 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  58b9a18ecd251cbd6e666ad792023ab77c7d100e
Gitweb:     http://git.kernel.org/tip/58b9a18ecd251cbd6e666ad792023ab77c7d100e
Author:     Stanislav Fomichev <stfomichev@yandex-team.ru>
AuthorDate: Mon, 2 Dec 2013 18:37:35 +0400
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Mon, 16 Dec 2013 16:34:27 -0300

perf timechart: Get number of CPUs from perf header

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
index 99fe363..db9c4c1 100644
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
 
