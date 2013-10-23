Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753586Ab3JWU6k (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Oct 2013 16:58:40 -0400
Received: from merlin.infradead.org ([205.233.59.134]:55432 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752129Ab3JWU6b (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Oct 2013 16:58:31 -0400
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org, Adrian Hunter <adrian.hunter@intel.com>,
        David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@redhat.com>, Jiri Olsa <jolsa@redhat.com>,
        Mike Galbraith <efault@gmx.de>, Namhyung Kim <namhyung@gmail.com>,
        Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Stephane Eranian <eranian@google.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 09/16] perf script: Make perf_script a local variable
Date: Wed, 23 Oct 2013 17:58:08 -0300
Message-Id: <1382561895-8237-10-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.8.1.4
In-Reply-To: <1382561895-8237-1-git-send-email-acme@infradead.org>
References: <1382561895-8237-1-git-send-email-acme@infradead.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by merlin.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Adrian Hunter <adrian.hunter@intel.com>

Change perf_script from being global to being local.

Signed-off-by: Adrian Hunter <adrian.hunter@intel.com>
Acked-by: David Ahern <dsahern@gmail.com>
Cc: David Ahern <dsahern@gmail.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Namhyung Kim <namhyung@gmail.com>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Stephane Eranian <eranian@google.com>
Link: http://lkml.kernel.org/r/1382427258-17495-4-git-send-email-adrian.hunter@intel.com
[ Made the minor consistency changes suggested by David Ahern ]
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/builtin-script.c | 40 ++++++++++++++++++++++++----------------
 1 file changed, 24 insertions(+), 16 deletions(-)

diff --git a/tools/perf/builtin-script.c b/tools/perf/builtin-script.c
index 27de6068049d..0ae88c2538a1 100644
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
+static int __cmd_script(struct perf_script *script)
 {
 	int ret;
 
 	signal(SIGINT, sig_handler);
 
-	ret = perf_session__process_events(session, &perf_script);
+	ret = perf_session__process_events(script->session, &script->tool);
 
 	if (debug_mode)
 		pr_err("Misordered timestamps: %" PRIu64 "\n", nr_unordered);
@@ -1273,6 +1264,21 @@ int cmd_script(int argc, const char **argv, const char *prefix __maybe_unused)
 	char *script_path = NULL;
 	const char **__argv;
 	int i, j, err;
+	struct perf_script script = {
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
+	session = perf_session__new(&file, false, &script.tool);
 	if (session == NULL)
 		return -ENOMEM;
 
+	script.session = session;
+
 	if (cpu_list) {
 		if (perf_session__cpu_bitmap(session, cpu_list, cpu_bitmap))
 			return -1;
@@ -1565,7 +1573,7 @@ int cmd_script(int argc, const char **argv, const char *prefix __maybe_unused)
 	if (err < 0)
 		goto out;
 
-	err = __cmd_script(session);
+	err = __cmd_script(&script);
 
 	perf_session__delete(session);
 	cleanup_scripting();
-- 
1.8.1.4

