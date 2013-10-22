Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753869Ab3JVHf3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Oct 2013 03:35:29 -0400
Received: from mga03.intel.com ([143.182.124.21]:51731 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753768Ab3JVHfV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Oct 2013 03:35:21 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.93,535,1378882800"; 
   d="scan'208";a="310958316"
From: Adrian Hunter <adrian.hunter@intel.com>
To: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Ingo Molnar <mingo@redhat.com>,
        linux-kernel@vger.kernel.org, David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Jiri Olsa <jolsa@redhat.com>,
        Mike Galbraith <efault@gmx.de>, Namhyung Kim <namhyung@gmail.com>,
        Paul Mackerras <paulus@samba.org>,
        Stephane Eranian <eranian@google.com>
Subject: [PATCH V2 03/14] perf script: Make perf_script a local variable
Date: Tue, 22 Oct 2013 10:34:07 +0300
Message-Id: <1382427258-17495-4-git-send-email-adrian.hunter@intel.com>
X-Mailer: git-send-email 1.7.11.7
In-Reply-To: <1382427258-17495-1-git-send-email-adrian.hunter@intel.com>
References: <1382427258-17495-1-git-send-email-adrian.hunter@intel.com>
Organization: Intel Finland Oy, Registered Address: PL 281, 00181 Helsinki, Business Identity Code: 0357606 - 4, Domiciled in Helsinki
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Change perf_script from being global to being local.

Signed-off-by: Adrian Hunter <adrian.hunter@intel.com>
---
 tools/perf/builtin-script.c | 40 ++++++++++++++++++++++++----------------
 1 file changed, 24 insertions(+), 16 deletions(-)

diff --git a/tools/perf/builtin-script.c b/tools/perf/builtin-script.c
index 27de606..0c50e4ae 100644
--- a/tools/perf/builtin-script.c
+++ b/tools/perf/builtin-script.c
@@ -542,18 +542,9 @@ static int process_sample_event(struct perf_tool *tool __maybe_unused,
 	return 0;
 }
 
-static struct perf_tool perf_script = {
-	.sample		 = process_sample_event,
-	.mmap		 = perf_event__process_mmap,
-	.mmap2		 = perf_event__process_mmap2,
-	.comm		 = perf_event__process_comm,
-	.exit		 = perf_event__process_exit,
-	.fork		 = perf_event__process_fork,
-	.attr		 = perf_event__process_attr,
-	.tracing_data	 = perf_event__process_tracing_data,
-	.build_id	 = perf_event__process_build_id,
-	.ordered_samples = true,
-	.ordering_requires_timestamps = true,
+struct perf_script {
+	struct perf_tool	tool;
+	struct perf_session	*session;
 };
 
 static void sig_handler(int sig __maybe_unused)
@@ -561,13 +552,13 @@ static void sig_handler(int sig __maybe_unused)
 	session_done = 1;
 }
 
-static int __cmd_script(struct perf_session *session)
+static int __cmd_script(struct perf_script *scr)
 {
 	int ret;
 
 	signal(SIGINT, sig_handler);
 
-	ret = perf_session__process_events(session, &perf_script);
+	ret = perf_session__process_events(scr->session, &scr->tool);
 
 	if (debug_mode)
 		pr_err("Misordered timestamps: %" PRIu64 "\n", nr_unordered);
@@ -1273,6 +1264,21 @@ int cmd_script(int argc, const char **argv, const char *prefix __maybe_unused)
 	char *script_path = NULL;
 	const char **__argv;
 	int i, j, err;
+	struct perf_script perf_script = {
+		.tool = {
+			.sample		 = process_sample_event,
+			.mmap		 = perf_event__process_mmap,
+			.mmap2		 = perf_event__process_mmap2,
+			.comm		 = perf_event__process_comm,
+			.exit		 = perf_event__process_exit,
+			.fork		 = perf_event__process_fork,
+			.attr		 = perf_event__process_attr,
+			.tracing_data	 = perf_event__process_tracing_data,
+			.build_id	 = perf_event__process_build_id,
+			.ordered_samples = true,
+			.ordering_requires_timestamps = true,
+		},
+	};
 	const struct option options[] = {
 	OPT_BOOLEAN('D', "dump-raw-trace", &dump_trace,
 		    "dump raw trace in ASCII"),
@@ -1498,10 +1504,12 @@ int cmd_script(int argc, const char **argv, const char *prefix __maybe_unused)
 	if (!script_name)
 		setup_pager();
 
-	session = perf_session__new(&file, false, &perf_script);
+	session = perf_session__new(&file, false, &perf_script.tool);
 	if (session == NULL)
 		return -ENOMEM;
 
+	perf_script.session = session;
+
 	if (cpu_list) {
 		if (perf_session__cpu_bitmap(session, cpu_list, cpu_bitmap))
 			return -1;
@@ -1565,7 +1573,7 @@ int cmd_script(int argc, const char **argv, const char *prefix __maybe_unused)
 	if (err < 0)
 		goto out;
 
-	err = __cmd_script(session);
+	err = __cmd_script(&perf_script);
 
 	perf_session__delete(session);
 	cleanup_scripting();
-- 
1.7.11.7

