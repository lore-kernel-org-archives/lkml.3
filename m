Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S967034AbaFTKvX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jun 2014 06:51:23 -0400
Received: from forward-corp1e.mail.yandex.net ([77.88.60.199]:39630 "EHLO
	forward-corp1e.mail.yandex.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S966676AbaFTKuT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jun 2014 06:50:19 -0400
X-Yandex-Uniq: 8222d39b-1044-450b-bcb9-783c6459b7ad
Authentication-Results: smtpcorp4.mail.yandex.net; dkim=pass header.i=@yandex-team.ru
From: Stanislav Fomichev <stfomichev@yandex-team.ru>
To: a.p.zijlstra@chello.nl, paulus@samba.org, mingo@redhat.com,
        acme@kernel.org, dsahern@gmail.com, stfomichev@yandex-team.ru,
        jolsa@redhat.com, xiaoguangrong@linux.vnet.ibm.com,
        yangds.fnst@cn.fujitsu.com, adrian.hunter@intel.com,
        namhyung@kernel.org
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 5/7] perf trace: add possibility to switch off syscall events
Date: Fri, 20 Jun 2014 14:49:47 +0400
Message-Id: <1403261389-13423-6-git-send-email-stfomichev@yandex-team.ru>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1403261389-13423-1-git-send-email-stfomichev@yandex-team.ru>
References: <1403261389-13423-1-git-send-email-stfomichev@yandex-team.ru>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Currently, we may either trace syscalls or syscalls+pagefaults. We'd
like to be able to trace *only* pagefaults and this commit implements
this feature.

Signed-off-by: Stanislav Fomichev <stfomichev@yandex-team.ru>
---
 tools/perf/Documentation/perf-trace.txt |  7 ++++
 tools/perf/builtin-trace.c              | 58 ++++++++++++++++++---------------
 2 files changed, 39 insertions(+), 26 deletions(-)

diff --git a/tools/perf/Documentation/perf-trace.txt b/tools/perf/Documentation/perf-trace.txt
index 8e5f710aa45d..bfe204cac2aa 100644
--- a/tools/perf/Documentation/perf-trace.txt
+++ b/tools/perf/Documentation/perf-trace.txt
@@ -112,9 +112,16 @@ the thread executes on the designated CPUs. Default is to monitor all CPUs.
 	Trace pagefaults. Optionally, you can specify whether you want minor,
 	major or all pagefaults. Default value is maj.
 
+--syscalls::
+	Trace system calls. This options is enabled by default.
+
 EXAMPLES
 --------
 
+Trace only major pagefaults:
+
+ $ perf trace --no-syscalls -F
+
 Trace syscalls, major and minor pagefaults:
 
  $ perf trace -F all
diff --git a/tools/perf/builtin-trace.c b/tools/perf/builtin-trace.c
index 9dd21dd26ef2..3cce721f8b06 100644
--- a/tools/perf/builtin-trace.c
+++ b/tools/perf/builtin-trace.c
@@ -1215,6 +1215,7 @@ struct trace {
 	bool			summary_only;
 	bool			show_comm;
 	bool			show_tool_stats;
+	bool			trace_syscalls;
 	int			trace_pgfaults;
 };
 
@@ -1928,17 +1929,19 @@ static int trace__record(struct trace *trace, int argc, const char **argv)
 	for (i = 0; i < ARRAY_SIZE(record_args); i++)
 		rec_argv[j++] = record_args[i];
 
-	for (i = 0; i < sc_args_nr; i++)
-		rec_argv[j++] = sc_args[i];
-
-	/* event string may be different for older kernels - e.g., RHEL6 */
-	if (is_valid_tracepoint("raw_syscalls:sys_enter"))
-		rec_argv[j++] = "raw_syscalls:sys_enter,raw_syscalls:sys_exit";
-	else if (is_valid_tracepoint("syscalls:sys_enter"))
-		rec_argv[j++] = "syscalls:sys_enter,syscalls:sys_exit";
-	else {
-		pr_err("Neither raw_syscalls nor syscalls events exist.\n");
-		return -1;
+	if (trace->trace_syscalls) {
+		for (i = 0; i < sc_args_nr; i++)
+			rec_argv[j++] = sc_args[i];
+
+		/* event string may be different for older kernels - e.g., RHEL6 */
+		if (is_valid_tracepoint("raw_syscalls:sys_enter"))
+			rec_argv[j++] = "raw_syscalls:sys_enter,raw_syscalls:sys_exit";
+		else if (is_valid_tracepoint("syscalls:sys_enter"))
+			rec_argv[j++] = "syscalls:sys_enter,syscalls:sys_exit";
+		else {
+			pr_err("Neither raw_syscalls nor syscalls events exist.\n");
+			return -1;
+		}
 	}
 
 	if (trace->trace_pgfaults & TRACE_PFMAJ)
@@ -2011,10 +2014,13 @@ static int trace__run(struct trace *trace, int argc, const char **argv)
 		goto out;
 	}
 
-	if (perf_evlist__add_syscall_newtp(evlist, trace__sys_enter, trace__sys_exit))
+	if (trace->trace_syscalls &&
+	    perf_evlist__add_syscall_newtp(evlist, trace__sys_enter,
+					   trace__sys_exit))
 		goto out_error_tp;
 
-	perf_evlist__add_vfs_getname(evlist);
+	if (trace->trace_syscalls)
+		perf_evlist__add_vfs_getname(evlist);
 
 	if ((trace->trace_pgfaults & TRACE_PFMAJ) &&
 	    perf_evlist__add_pgfault(evlist, PERF_COUNT_SW_PAGE_FAULTS_MAJ))
@@ -2216,13 +2222,10 @@ static int trace__replay(struct trace *trace)
 	if (evsel == NULL)
 		evsel = perf_evlist__find_tracepoint_by_name(session->evlist,
 							     "syscalls:sys_enter");
-	if (evsel == NULL) {
-		pr_err("Data file does not have raw_syscalls:sys_enter event\n");
-		goto out;
-	}
 
-	if (perf_evsel__init_syscall_tp(evsel, trace__sys_enter) < 0 ||
-	    perf_evsel__init_sc_tp_ptr_field(evsel, args)) {
+	if (evsel &&
+	    (perf_evsel__init_syscall_tp(evsel, trace__sys_enter) < 0 ||
+	    perf_evsel__init_sc_tp_ptr_field(evsel, args))) {
 		pr_err("Error during initialize raw_syscalls:sys_enter event\n");
 		goto out;
 	}
@@ -2232,13 +2235,9 @@ static int trace__replay(struct trace *trace)
 	if (evsel == NULL)
 		evsel = perf_evlist__find_tracepoint_by_name(session->evlist,
 							     "syscalls:sys_exit");
-	if (evsel == NULL) {
-		pr_err("Data file does not have raw_syscalls:sys_exit event\n");
-		goto out;
-	}
-
-	if (perf_evsel__init_syscall_tp(evsel, trace__sys_exit) < 0 ||
-	    perf_evsel__init_sc_tp_uint_field(evsel, ret)) {
+	if (evsel &&
+	    (perf_evsel__init_syscall_tp(evsel, trace__sys_exit) < 0 ||
+	    perf_evsel__init_sc_tp_uint_field(evsel, ret))) {
 		pr_err("Error during initialize raw_syscalls:sys_exit event\n");
 		goto out;
 	}
@@ -2442,6 +2441,7 @@ int cmd_trace(int argc, const char **argv, const char *prefix __maybe_unused)
 		},
 		.output = stdout,
 		.show_comm = true,
+		.trace_syscalls = true,
 	};
 	const char *output_name = NULL;
 	const char *ev_qualifier_str = NULL;
@@ -2481,6 +2481,7 @@ int cmd_trace(int argc, const char **argv, const char *prefix __maybe_unused)
 		    "Show all syscalls and summary with statistics"),
 	OPT_CALLBACK_DEFAULT('F', "pf", &trace.trace_pgfaults, "all|maj|min",
 		     "Trace pagefaults", parse_pagefaults, "maj"),
+	OPT_BOOLEAN(0, "syscalls", &trace.trace_syscalls, "Trace syscalls"),
 	OPT_END()
 	};
 	int err;
@@ -2501,6 +2502,11 @@ int cmd_trace(int argc, const char **argv, const char *prefix __maybe_unused)
 	if (trace.summary_only)
 		trace.summary = trace.summary_only;
 
+	if (!trace.trace_syscalls && !trace.trace_pgfaults) {
+		pr_err("Please specify something to trace.\n");
+		return -1;
+	}
+
 	if (output_name != NULL) {
 		err = trace__open_output(&trace, output_name);
 		if (err < 0) {
-- 
1.8.3.2

