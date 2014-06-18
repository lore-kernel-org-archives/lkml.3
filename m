Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752817AbaFRPBH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jun 2014 11:01:07 -0400
Received: from forward-corp1g.mail.yandex.net ([95.108.253.251]:42976 "EHLO
	forward-corp1g.mail.yandex.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751106AbaFRPBD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jun 2014 11:01:03 -0400
X-Yandex-Uniq: 78a35862-b5cc-4a76-93b4-d93f5edb43a2
Authentication-Results: smtpcorp4.mail.yandex.net; dkim=pass header.i=@yandex-team.ru
From: Stanislav Fomichev <stfomichev@yandex-team.ru>
To: a.p.zijlstra@chello.nl, paulus@samba.org, mingo@redhat.com,
        acme@kernel.org, dsahern@gmail.com, stfomichev@yandex-team.ru,
        jolsa@redhat.com, xiaoguangrong@linux.vnet.ibm.com,
        yangds.fnst@cn.fujitsu.com, adrian.hunter@intel.com,
        namhyung@kernel.org
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 3/5] perf trace: add possibility to switch off syscall events
Date: Wed, 18 Jun 2014 18:59:23 +0400
Message-Id: <1403103565-6388-4-git-send-email-stfomichev@yandex-team.ru>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1403103565-6388-1-git-send-email-stfomichev@yandex-team.ru>
References: <1403103565-6388-1-git-send-email-stfomichev@yandex-team.ru>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Stanislav Fomichev <stfomichev@yandex-team.ru>
---
 tools/perf/Documentation/perf-trace.txt |  7 ++++++
 tools/perf/builtin-trace.c              | 39 ++++++++++++++++++++++-----------
 2 files changed, 33 insertions(+), 13 deletions(-)

diff --git a/tools/perf/Documentation/perf-trace.txt b/tools/perf/Documentation/perf-trace.txt
index 7da5f75a45f1..301fc9384d93 100644
--- a/tools/perf/Documentation/perf-trace.txt
+++ b/tools/perf/Documentation/perf-trace.txt
@@ -112,9 +112,16 @@ the thread executes on the designated CPUs. Default is to monitor all CPUs.
 	Trace major pagefaults. To also trace minor pagefaults, specify this
 	option twice.
 
+--syscalls::
+	Trace system calls. This options is enabled by default.
+
 EXAMPLES
 --------
 
+Trace only major pagefaults:
+
+ $ perf trace --no-syscalls -f
+
 Trace syscalls, major and minor pagefaults:
 
  $ perf trace -f -f
diff --git a/tools/perf/builtin-trace.c b/tools/perf/builtin-trace.c
index 535f0b504950..90ae4036e5ee 100644
--- a/tools/perf/builtin-trace.c
+++ b/tools/perf/builtin-trace.c
@@ -1212,6 +1212,7 @@ struct trace {
 	bool			summary_only;
 	bool			show_comm;
 	bool			show_tool_stats;
+	bool			trace_syscalls;
 	int			trace_pgfaults;
 };
 
@@ -1940,17 +1941,19 @@ static int trace__record(struct trace *trace, int argc, const char **argv)
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
 
 	if (trace->trace_pgfaults)
@@ -2023,10 +2026,13 @@ static int trace__run(struct trace *trace, int argc, const char **argv)
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
 
 	if (trace->trace_pgfaults &&
 	    perf_evlist__add_pgfault(evlist, PERF_COUNT_SW_PAGE_FAULTS_MAJ))
@@ -2432,6 +2438,7 @@ int cmd_trace(int argc, const char **argv, const char *prefix __maybe_unused)
 		},
 		.output = stdout,
 		.show_comm = true,
+		.trace_syscalls = true,
 	};
 	const char *output_name = NULL;
 	const char *ev_qualifier_str = NULL;
@@ -2469,6 +2476,7 @@ int cmd_trace(int argc, const char **argv, const char *prefix __maybe_unused)
 		    "Show only syscall summary with statistics"),
 	OPT_BOOLEAN('S', "with-summary", &trace.summary,
 		    "Show all syscalls and summary with statistics"),
+	OPT_BOOLEAN(0, "syscalls", &trace.trace_syscalls, "Trace syscalls"),
 	OPT_INCR('f', "pgfaults", &trace.trace_pgfaults, "Trace pagefaults"),
 	OPT_END()
 	};
@@ -2485,6 +2493,11 @@ int cmd_trace(int argc, const char **argv, const char *prefix __maybe_unused)
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

