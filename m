Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753349Ab3JYKcw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Oct 2013 06:32:52 -0400
Received: from terminus.zytor.com ([198.137.202.10]:52415 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753318Ab3JYKcs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Oct 2013 06:32:48 -0400
Date: Fri, 25 Oct 2013 03:32:23 -0700
From: tip-bot for Adrian Hunter <tipbot@zytor.com>
Message-ID: <tip-6f3e5eda9d6cc74538430d8f9e8e4baa01249160@git.kernel.org>
Cc: acme@redhat.com, linux-kernel@vger.kernel.org, eranian@google.com,
        paulus@samba.org, mingo@redhat.com, hpa@zytor.com, mingo@kernel.org,
        a.p.zijlstra@chello.nl, efault@gmx.de, namhyung@gmail.com,
        jolsa@redhat.com, fweisbec@gmail.com, adrian.hunter@intel.com,
        dsahern@gmail.com, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, mingo@redhat.com, paulus@samba.org,
        eranian@google.com, linux-kernel@vger.kernel.org, acme@redhat.com,
        a.p.zijlstra@chello.nl, efault@gmx.de, namhyung@gmail.com,
        jolsa@redhat.com, fweisbec@gmail.com, dsahern@gmail.com,
        adrian.hunter@intel.com, tglx@linutronix.de
In-Reply-To: <1382427258-17495-4-git-send-email-adrian.hunter@intel.com>
References: <1382427258-17495-4-git-send-email-adrian.hunter@intel.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf script: Make perf_script a local variable
Git-Commit-ID: 6f3e5eda9d6cc74538430d8f9e8e4baa01249160
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.1 (terminus.zytor.com [127.0.0.1]); Fri, 25 Oct 2013 03:32:29 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  6f3e5eda9d6cc74538430d8f9e8e4baa01249160
Gitweb:     http://git.kernel.org/tip/6f3e5eda9d6cc74538430d8f9e8e4baa01249160
Author:     Adrian Hunter <adrian.hunter@intel.com>
AuthorDate: Tue, 22 Oct 2013 10:34:07 +0300
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Wed, 23 Oct 2013 10:27:03 -0300

perf script: Make perf_script a local variable

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
index 27de606..0ae88c2 100644
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
