Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752195AbaFZVCW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jun 2014 17:02:22 -0400
Received: from mail.kernel.org ([198.145.19.201]:44818 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752159AbaFZVCR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jun 2014 17:02:17 -0400
From: Arnaldo Carvalho de Melo <acme@kernel.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org,
        Stanislav Fomichev <stfomichev@yandex-team.ru>,
        David Ahern <dsahern@gmail.com>, Ingo Molnar <mingo@redhat.com>,
        Jiri Olsa <jolsa@redhat.com>, Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 5/5] perf trace: Add possibility to switch off syscall events
Date: Thu, 26 Jun 2014 18:01:47 -0300
Message-Id: <1403816507-12943-6-git-send-email-acme@kernel.org>
X-Mailer: git-send-email 1.9.3
In-Reply-To: <1403816507-12943-1-git-send-email-acme@kernel.org>
References: <1403816507-12943-1-git-send-email-acme@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Stanislav Fomichev <stfomichev@yandex-team.ru>

Currently, we may either trace syscalls or syscalls+pagefaults.

We'd like to be able to trace *only* pagefaults and this commit
implements this feature.

Example:

  [root@zoo /]# echo 1 > /proc/sys/vm/drop_caches ; trace --no-syscalls -F -p `pidof xchat`
       0.000 ( 0.000 ms): xchat/4574 majfault [g_unichar_get_script+0x11] => /usr/lib64/libglib-2.0.so.0.3800.2@0xc403b (x.)
       0.202 ( 0.000 ms): xchat/4574 majfault [_cairo_hash_table_lookup+0x53] => 0x2280ff0 (?.)
      20.854 ( 0.000 ms): xchat/4574 majfault [gdk_cairo_set_source_pixbuf+0x110] => /usr/bin/xchat@0x6da1f (x.)
    1022.000 ( 0.000 ms): xchat/4574 majfault [__memcpy_sse2_unaligned+0x29] => 0x7ff5a8ca0400 (?.)
  ^C[root@zoo /]#

Below we can see malloc calls, 'trace' reading symbol tables in libraries to
resolve symbols, etc.

  [root@zoo /]# echo 1 > /proc/sys/vm/drop_caches ; trace --no-syscalls -F all --cpu 1 sleep 10
       0.000 ( 0.000 ms): chrome/26589 minfault [0x1b53129] => /tmp/perf-26589.map@0x33cbcbf7f000 (x.)
      96.477 ( 0.000 ms): libvirtd/947 minfault [copy_user_enhanced_fast_string+0x5] => 0x7f7685bba000 (?k)
     113.164 ( 0.000 ms): Xorg/1063 minfault [0x786da] => 0x7fce52882a3c (?.)
    7162.801 ( 0.000 ms): chrome/3747 minfault [0x8e1a89] => 0xfcaefed0008 (?.)
<SNIP>
    7773.138 ( 0.000 ms): chrome/3886 minfault [0x8e1a89] => 0xfcb0ce28008 (?.)
    7992.022 ( 0.000 ms): chrome/26574 minfault [0x1b5a708] => 0x3de7b5fc5000 (?.)
    8108.949 ( 0.000 ms): qemu-system-x8/4537 majfault [_int_malloc+0xee] => 0x7faffc466d60 (?.)
    8108.975 ( 0.000 ms): qemu-system-x8/4537 minfault [_int_malloc+0x102] => 0x7faffc466d60 (?.)
<SNIP>
    8148.174 ( 0.000 ms): qemu-system-x8/4537 minfault [_int_malloc+0x102] => 0x7faffc4eb500 (?.)
    8270.855 ( 0.000 ms): chrome/26245 minfault [do_bo_emit_reloc+0xdb] => 0x45d092bc004 (?.)
    8270.869 ( 0.000 ms): chrome/26245 minfault [do_bo_emit_reloc+0x108] => 0x45d09150000 (?.)
no symbols found in /usr/lib64/libspice-server.so.1.9.0, maybe install a debug package?
    8273.831 ( 0.000 ms): trace/20198 majfault [__memcmp_sse4_1+0xbc6] => /usr/lib64/libspice-server.so.1.9.0@0xdf000 (d.)
<SNIP>
    8275.121 ( 0.000 ms): trace/20198 minfault [dso__load+0x38] => 0x14fe756 (?.)
no symbols found in /usr/lib64/libelf-0.158.so, maybe install a debug package?
    8275.142 ( 0.000 ms): trace/20198 minfault [__memcmp_sse4_1+0xbc6] => /usr/lib64/libelf-0.158.so@0x0 (d.)
<SNIP>
  [root@zoo /]#

Signed-off-by: Stanislav Fomichev <stfomichev@yandex-team.ru>
Cc: David Ahern <dsahern@gmail.com>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Link: http://lkml.kernel.org/r/1403799268-1367-6-git-send-email-stfomichev@yandex-team.ru
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/Documentation/perf-trace.txt |  7 ++++
 tools/perf/builtin-trace.c              | 58 ++++++++++++++++++---------------
 2 files changed, 39 insertions(+), 26 deletions(-)

diff --git a/tools/perf/Documentation/perf-trace.txt b/tools/perf/Documentation/perf-trace.txt
index 72397d9aa2ec..02aac831bdd9 100644
--- a/tools/perf/Documentation/perf-trace.txt
+++ b/tools/perf/Documentation/perf-trace.txt
@@ -112,6 +112,9 @@ the thread executes on the designated CPUs. Default is to monitor all CPUs.
 	Trace pagefaults. Optionally, you can specify whether you want minor,
 	major or all pagefaults. Default value is maj.
 
+--syscalls::
+	Trace system calls. This options is enabled by default.
+
 PAGEFAULTS
 ----------
 
@@ -137,6 +140,10 @@ for both IP and fault address in the form of dso@symbol+offset.
 EXAMPLES
 --------
 
+Trace only major pagefaults:
+
+ $ perf trace --no-syscalls -F
+
 Trace syscalls, major and minor pagefaults:
 
  $ perf trace -F all
diff --git a/tools/perf/builtin-trace.c b/tools/perf/builtin-trace.c
index 0b58e24c7ccb..dc7a694b61fe 100644
--- a/tools/perf/builtin-trace.c
+++ b/tools/perf/builtin-trace.c
@@ -1215,6 +1215,7 @@ struct trace {
 	bool			summary_only;
 	bool			show_comm;
 	bool			show_tool_stats;
+	bool			trace_syscalls;
 	int			trace_pgfaults;
 };
 
@@ -1927,17 +1928,19 @@ static int trace__record(struct trace *trace, int argc, const char **argv)
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
@@ -2010,10 +2013,13 @@ static int trace__run(struct trace *trace, int argc, const char **argv)
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
@@ -2215,13 +2221,10 @@ static int trace__replay(struct trace *trace)
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
@@ -2231,13 +2234,9 @@ static int trace__replay(struct trace *trace)
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
@@ -2440,6 +2439,7 @@ int cmd_trace(int argc, const char **argv, const char *prefix __maybe_unused)
 		},
 		.output = stdout,
 		.show_comm = true,
+		.trace_syscalls = true,
 	};
 	const char *output_name = NULL;
 	const char *ev_qualifier_str = NULL;
@@ -2479,6 +2479,7 @@ int cmd_trace(int argc, const char **argv, const char *prefix __maybe_unused)
 		    "Show all syscalls and summary with statistics"),
 	OPT_CALLBACK_DEFAULT('F', "pf", &trace.trace_pgfaults, "all|maj|min",
 		     "Trace pagefaults", parse_pagefaults, "maj"),
+	OPT_BOOLEAN(0, "syscalls", &trace.trace_syscalls, "Trace syscalls"),
 	OPT_END()
 	};
 	int err;
@@ -2499,6 +2500,11 @@ int cmd_trace(int argc, const char **argv, const char *prefix __maybe_unused)
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
1.9.3

