Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754426Ab3JVOeB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Oct 2013 10:34:01 -0400
Received: from merlin.infradead.org ([205.233.59.134]:53906 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753743Ab3JVO2w (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Oct 2013 10:28:52 -0400
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org, Waiman Long <Waiman.Long@hp.com>,
        Adrian Hunter <adrian.hunter@intel.com>,
        Aswin Chandramouleeswaran <aswin@hp.com>,
        David Ahern <dsahern@gmail.com>, Ingo Molnar <mingo@redhat.com>,
        Jiri Olsa <jolsa@redhat.com>, Namhyung Kim <namhyung@kernel.org>,
        Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Scott J Norton <scott.norton@hp.com>,
        Stephane Eranian <eranian@google.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 26/26] perf top: Add --max-stack option to limit callchain stack scan
Date: Tue, 22 Oct 2013 11:28:34 -0300
Message-Id: <1382452114-1243-27-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.8.1.4
In-Reply-To: <1382452114-1243-1-git-send-email-acme@infradead.org>
References: <1382452114-1243-1-git-send-email-acme@infradead.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by merlin.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Waiman Long <Waiman.Long@hp.com>

When the callgraph function is enabled (-G), it may take a long time to
scan all the stack data and merge them accordingly.

This patch adds a new --max-stack option to perf-top to limit the depth
of callchain stack data to look at to reduce the time it takes for
perf-top to finish its processing. It reduces the amount of information
provided to the user in exchange for faster speed.

Signed-off-by: Waiman Long <Waiman.Long@hp.com>
Acked-by: David Ahern <dsahern@gmail.com>
Tested-by: Davidlohr Bueso <davidlohr@hp.com>
Cc: Adrian Hunter <adrian.hunter@intel.com>
Cc: Aswin Chandramouleeswaran <aswin@hp.com>
Cc: David Ahern <dsahern@gmail.com>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Scott J Norton <scott.norton@hp.com>
Cc: Stephane Eranian <eranian@google.com>
Link: http://lkml.kernel.org/r/1382107129-2010-5-git-send-email-Waiman.Long@hp.com
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/Documentation/perf-top.txt | 8 ++++++++
 tools/perf/builtin-top.c              | 8 ++++++--
 tools/perf/util/top.h                 | 1 +
 3 files changed, 15 insertions(+), 2 deletions(-)

diff --git a/tools/perf/Documentation/perf-top.txt b/tools/perf/Documentation/perf-top.txt
index f65777c1f723..c16a09e2f182 100644
--- a/tools/perf/Documentation/perf-top.txt
+++ b/tools/perf/Documentation/perf-top.txt
@@ -158,6 +158,14 @@ Default is to monitor all CPUS.
 
 	Default: fractal,0.5,callee.
 
+--max-stack::
+	Set the stack depth limit when parsing the callchain, anything
+	beyond the specified depth will be ignored. This is a trade-off
+	between information loss and faster processing especially for
+	workloads that can have a very long callchain stack.
+
+	Default: 127
+
 --ignore-callees=<regex>::
         Ignore callees of the function(s) matching the given regex.
         This has the effect of collecting the callers of each such
diff --git a/tools/perf/builtin-top.c b/tools/perf/builtin-top.c
index 112cb7d68e64..386d83324a8d 100644
--- a/tools/perf/builtin-top.c
+++ b/tools/perf/builtin-top.c
@@ -771,7 +771,7 @@ static void perf_event__process_sample(struct perf_tool *tool,
 			err = machine__resolve_callchain(machine, evsel,
 							 al.thread, sample,
 							 &parent, &al,
-							 PERF_MAX_STACK_DEPTH);
+							 top->max_stack);
 			if (err)
 				return;
 		}
@@ -1048,10 +1048,11 @@ int cmd_top(int argc, const char **argv, const char *prefix __maybe_unused)
 			.user_freq	= UINT_MAX,
 			.user_interval	= ULLONG_MAX,
 			.freq		= 4000, /* 4 KHz */
-			.target		     = {
+			.target		= {
 				.uses_mmap   = true,
 			},
 		},
+		.max_stack	     = PERF_MAX_STACK_DEPTH,
 		.sym_pcnt_filter     = 5,
 	};
 	struct perf_record_opts *opts = &top.record_opts;
@@ -1110,6 +1111,9 @@ int cmd_top(int argc, const char **argv, const char *prefix __maybe_unused)
 	OPT_CALLBACK_DEFAULT('G', "call-graph", &top.record_opts,
 			     "mode[,dump_size]", record_callchain_help,
 			     &parse_callchain_opt, "fp"),
+	OPT_INTEGER(0, "max-stack", &top.max_stack,
+		    "Set the maximum stack depth when parsing the callchain. "
+		    "Default: " __stringify(PERF_MAX_STACK_DEPTH)),
 	OPT_CALLBACK(0, "ignore-callees", NULL, "regex",
 		   "ignore callees of these functions in call graphs",
 		   report_parse_ignore_callees_opt),
diff --git a/tools/perf/util/top.h b/tools/perf/util/top.h
index b554ffc462b6..88cfeaff600b 100644
--- a/tools/perf/util/top.h
+++ b/tools/perf/util/top.h
@@ -24,6 +24,7 @@ struct perf_top {
 	u64		   exact_samples;
 	u64		   guest_us_samples, guest_kernel_samples;
 	int		   print_entries, count_filter, delay_secs;
+	int		   max_stack;
 	bool		   hide_kernel_symbols, hide_user_symbols, zero;
 	bool		   use_tui, use_stdio;
 	bool		   kptr_restrict_warned;
-- 
1.8.1.4

