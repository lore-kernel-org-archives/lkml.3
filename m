Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753204Ab3JWH40 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Oct 2013 03:56:26 -0400
Received: from terminus.zytor.com ([198.137.202.10]:56079 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753102Ab3JWH4D (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Oct 2013 03:56:03 -0400
Date: Wed, 23 Oct 2013 00:55:44 -0700
From: tip-bot for Waiman Long <tipbot@zytor.com>
Message-ID: <tip-5dbb6e81d85e55ee2b4cf523c1738e16f63e5400@git.kernel.org>
Cc: acme@redhat.com, eranian@google.com, mingo@redhat.com, mingo@kernel.org,
        a.p.zijlstra@chello.nl, jolsa@redhat.com, Waiman.Long@hp.com,
        dsahern@gmail.com, tglx@linutronix.de, scott.norton@hp.com,
        davidlohr@hp.com, hpa@zytor.com, paulus@samba.org,
        linux-kernel@vger.kernel.org, namhyung@kernel.org,
        adrian.hunter@intel.com, aswin@hp.com
Reply-To: mingo@kernel.org, mingo@redhat.com, eranian@google.com,
        acme@redhat.com, a.p.zijlstra@chello.nl, jolsa@redhat.com,
        Waiman.Long@hp.com, dsahern@gmail.com, tglx@linutronix.de,
        davidlohr@hp.com, scott.norton@hp.com, hpa@zytor.com, paulus@samba.org,
        linux-kernel@vger.kernel.org, namhyung@kernel.org,
        adrian.hunter@intel.com, aswin@hp.com
In-Reply-To: <1382107129-2010-5-git-send-email-Waiman.Long@hp.com>
References: <1382107129-2010-5-git-send-email-Waiman.Long@hp.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf top:
  Add --max-stack option to limit callchain stack scan
Git-Commit-ID: 5dbb6e81d85e55ee2b4cf523c1738e16f63e5400
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.1 (terminus.zytor.com [127.0.0.1]); Wed, 23 Oct 2013 00:55:51 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  5dbb6e81d85e55ee2b4cf523c1738e16f63e5400
Gitweb:     http://git.kernel.org/tip/5dbb6e81d85e55ee2b4cf523c1738e16f63e5400
Author:     Waiman Long <Waiman.Long@hp.com>
AuthorDate: Fri, 18 Oct 2013 10:38:49 -0400
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Mon, 21 Oct 2013 17:36:25 -0300

perf top: Add --max-stack option to limit callchain stack scan

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
index f65777c..c16a09e 100644
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
index 112cb7d..386d833 100644
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
index b554ffc..88cfeaf 100644
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
