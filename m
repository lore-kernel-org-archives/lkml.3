Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757772AbaFZQPR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jun 2014 12:15:17 -0400
Received: from forward-corp1e.mail.yandex.net ([77.88.60.199]:49703 "EHLO
	forward-corp1e.mail.yandex.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757268AbaFZQPO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jun 2014 12:15:14 -0400
X-Yandex-Uniq: 15d4fc76-3857-4a53-88a5-18db8f5b9501
Authentication-Results: smtpcorp4.mail.yandex.net; dkim=pass header.i=@yandex-team.ru
From: Stanislav Fomichev <stfomichev@yandex-team.ru>
To: a.p.zijlstra@chello.nl, paulus@samba.org, mingo@redhat.com,
        acme@kernel.org, dsahern@gmail.com, stfomichev@yandex-team.ru,
        jolsa@redhat.com
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 3/5] perf trace: add pagefaults record and replay support
Date: Thu, 26 Jun 2014 20:14:26 +0400
Message-Id: <1403799268-1367-4-git-send-email-stfomichev@yandex-team.ru>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1403799268-1367-1-git-send-email-stfomichev@yandex-team.ru>
References: <1403799268-1367-1-git-send-email-stfomichev@yandex-team.ru>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Previous commit added live pagefault trace support, this one adds
record and replay support.

Signed-off-by: Stanislav Fomichev <stfomichev@yandex-team.ru>
---
 tools/perf/builtin-trace.c | 63 +++++++++++++++++++++++++++++++++-------------
 1 file changed, 45 insertions(+), 18 deletions(-)

diff --git a/tools/perf/builtin-trace.c b/tools/perf/builtin-trace.c
index 9e6f0eb4063f..38f3dedcbb4a 100644
--- a/tools/perf/builtin-trace.c
+++ b/tools/perf/builtin-trace.c
@@ -1897,7 +1897,7 @@ static int parse_target_str(struct trace *trace)
 	return 0;
 }
 
-static int trace__record(int argc, const char **argv)
+static int trace__record(struct trace *trace, int argc, const char **argv)
 {
 	unsigned int rec_argc, i, j;
 	const char **rec_argv;
@@ -1906,34 +1906,52 @@ static int trace__record(int argc, const char **argv)
 		"-R",
 		"-m", "1024",
 		"-c", "1",
-		"-e",
 	};
 
+	const char * const sc_args[] = { "-e", };
+	unsigned int sc_args_nr = ARRAY_SIZE(sc_args);
+	const char * const majpf_args[] = { "-e", "major-faults" };
+	unsigned int majpf_args_nr = ARRAY_SIZE(majpf_args);
+	const char * const minpf_args[] = { "-e", "minor-faults" };
+	unsigned int minpf_args_nr = ARRAY_SIZE(minpf_args);
+
 	/* +1 is for the event string below */
-	rec_argc = ARRAY_SIZE(record_args) + 1 + argc;
+	rec_argc = ARRAY_SIZE(record_args) + sc_args_nr + 1 +
+		majpf_args_nr + minpf_args_nr + argc;
 	rec_argv = calloc(rec_argc + 1, sizeof(char *));
 
 	if (rec_argv == NULL)
 		return -ENOMEM;
 
+	j = 0;
 	for (i = 0; i < ARRAY_SIZE(record_args); i++)
-		rec_argv[i] = record_args[i];
+		rec_argv[j++] = record_args[i];
+
+	for (i = 0; i < sc_args_nr; i++)
+		rec_argv[j++] = sc_args[i];
 
 	/* event string may be different for older kernels - e.g., RHEL6 */
 	if (is_valid_tracepoint("raw_syscalls:sys_enter"))
-		rec_argv[i] = "raw_syscalls:sys_enter,raw_syscalls:sys_exit";
+		rec_argv[j++] = "raw_syscalls:sys_enter,raw_syscalls:sys_exit";
 	else if (is_valid_tracepoint("syscalls:sys_enter"))
-		rec_argv[i] = "syscalls:sys_enter,syscalls:sys_exit";
+		rec_argv[j++] = "syscalls:sys_enter,syscalls:sys_exit";
 	else {
 		pr_err("Neither raw_syscalls nor syscalls events exist.\n");
 		return -1;
 	}
-	i++;
 
-	for (j = 0; j < (unsigned int)argc; j++, i++)
-		rec_argv[i] = argv[j];
+	if (trace->trace_pgfaults & TRACE_PFMAJ)
+		for (i = 0; i < majpf_args_nr; i++)
+			rec_argv[j++] = majpf_args[i];
+
+	if (trace->trace_pgfaults & TRACE_PFMIN)
+		for (i = 0; i < minpf_args_nr; i++)
+			rec_argv[j++] = minpf_args[i];
+
+	for (i = 0; i < (unsigned int)argc; i++)
+		rec_argv[j++] = argv[i];
 
-	return cmd_record(i, rec_argv, NULL);
+	return cmd_record(j, rec_argv, NULL);
 }
 
 static size_t trace__fprintf_thread_summary(struct trace *trace, FILE *fp);
@@ -2224,6 +2242,14 @@ static int trace__replay(struct trace *trace)
 		goto out;
 	}
 
+	evlist__for_each(session->evlist, evsel) {
+		if (evsel->attr.type == PERF_TYPE_SOFTWARE &&
+		    (evsel->attr.config == PERF_COUNT_SW_PAGE_FAULTS_MAJ ||
+		     evsel->attr.config == PERF_COUNT_SW_PAGE_FAULTS_MIN ||
+		     evsel->attr.config == PERF_COUNT_SW_PAGE_FAULTS))
+			evsel->handler = trace__pgfault;
+	}
+
 	err = parse_target_str(trace);
 	if (err != 0)
 		goto out;
@@ -2458,20 +2484,21 @@ int cmd_trace(int argc, const char **argv, const char *prefix __maybe_unused)
 	int err;
 	char bf[BUFSIZ];
 
-	if ((argc > 1) && (strcmp(argv[1], "record") == 0))
-		return trace__record(argc-2, &argv[2]);
-
-	argc = parse_options(argc, argv, trace_options, trace_usage, 0);
-
-	/* summary_only implies summary option, but don't overwrite summary if set */
-	if (trace.summary_only)
-		trace.summary = trace.summary_only;
+	argc = parse_options(argc, argv, trace_options, trace_usage,
+			     PARSE_OPT_STOP_AT_NON_OPTION);
 
 	if (trace.trace_pgfaults) {
 		trace.opts.sample_address = true;
 		trace.opts.sample_time = true;
 	}
 
+	if ((argc >= 1) && (strcmp(argv[0], "record") == 0))
+		return trace__record(&trace, argc-1, &argv[1]);
+
+	/* summary_only implies summary option, but don't overwrite summary if set */
+	if (trace.summary_only)
+		trace.summary = trace.summary_only;
+
 	if (output_name != NULL) {
 		err = trace__open_output(&trace, output_name);
 		if (err < 0) {
-- 
1.9.1

