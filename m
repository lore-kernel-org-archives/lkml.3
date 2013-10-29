Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753396Ab3J2IXa (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Oct 2013 04:23:30 -0400
Received: from terminus.zytor.com ([198.137.202.10]:42256 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753298Ab3J2IXD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Oct 2013 04:23:03 -0400
Date: Tue, 29 Oct 2013 01:22:24 -0700
From: tip-bot for Jiri Olsa <tipbot@zytor.com>
Message-ID: <tip-ae779a630977d93fbebfa06216ea47df5b5c62c8@git.kernel.org>
Cc: acme@redhat.com, linux-kernel@vger.kernel.org, paulus@samba.org,
        hpa@zytor.com, mingo@kernel.org, andi@firstfloor.org,
        a.p.zijlstra@chello.nl, namhyung@kernel.org, jolsa@redhat.com,
        dsahern@gmail.com, adrian.hunter@intel.com, tglx@linutronix.de,
        cjashfor@linux.vnet.ibm.com, mingo@elte.hu
Reply-To: mingo@kernel.org, hpa@zytor.com, paulus@samba.org,
        linux-kernel@vger.kernel.org, acme@redhat.com, andi@firstfloor.org,
        a.p.zijlstra@chello.nl, namhyung@kernel.org, jolsa@redhat.com,
        adrian.hunter@intel.com, dsahern@gmail.com, tglx@linutronix.de,
        cjashfor@linux.vnet.ibm.com, mingo@elte.hu
In-Reply-To: <1382797536-32303-3-git-send-email-jolsa@redhat.com>
References: <1382797536-32303-3-git-send-email-jolsa@redhat.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/urgent] perf top: Split -G and --call-graph
Git-Commit-ID: ae779a630977d93fbebfa06216ea47df5b5c62c8
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.1 (terminus.zytor.com [127.0.0.1]); Tue, 29 Oct 2013 01:22:30 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  ae779a630977d93fbebfa06216ea47df5b5c62c8
Gitweb:     http://git.kernel.org/tip/ae779a630977d93fbebfa06216ea47df5b5c62c8
Author:     Jiri Olsa <jolsa@redhat.com>
AuthorDate: Sat, 26 Oct 2013 16:25:34 +0200
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Mon, 28 Oct 2013 16:06:00 -0300

perf top: Split -G and --call-graph

Splitting -G and --call-graph for record command, so we could use '-G'
with no option.

The '-G' option now takes NO argument and enables the configured unwind
method, which is currently the frame pointers method.

It will be possible to configure unwind method via config file in
upcoming patches.

All current '-G' arguments is overtaken by --call-graph option.

NOTE: The documentation for top --call-graph option
      was wrongly copied from report command.

Signed-off-by: Jiri Olsa <jolsa@redhat.com>
Tested-by: David Ahern <dsahern@gmail.com>
Tested-by: Ingo Molnar <mingo@kernel.org>
Reviewed-by: David Ahern <dsahern@gmail.com>
Acked-by: Ingo Molnar <mingo@kernel.org>
Cc: Adrian Hunter <adrian.hunter@intel.com>
Cc: Andi Kleen <andi@firstfloor.org>
Cc: Corey Ashford <cjashfor@linux.vnet.ibm.com>
Cc: David Ahern <dsahern@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Link: http://lkml.kernel.org/r/1382797536-32303-3-git-send-email-jolsa@redhat.com
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/Documentation/perf-top.txt | 18 +++++-------------
 tools/perf/builtin-top.c              | 23 +++++++++++++----------
 2 files changed, 18 insertions(+), 23 deletions(-)

diff --git a/tools/perf/Documentation/perf-top.txt b/tools/perf/Documentation/perf-top.txt
index 58d6598..6a118e7 100644
--- a/tools/perf/Documentation/perf-top.txt
+++ b/tools/perf/Documentation/perf-top.txt
@@ -140,20 +140,12 @@ Default is to monitor all CPUS.
 --asm-raw::
 	Show raw instruction encoding of assembly instructions.
 
--G [type,min,order]::
+-G::
+	Enables call-graph (stack chain/backtrace) recording.
+
 --call-graph::
-        Display call chains using type, min percent threshold and order.
-	type can be either:
-	- flat: single column, linear exposure of call chains.
-	- graph: use a graph tree, displaying absolute overhead rates.
-	- fractal: like graph, but displays relative rates. Each branch of
-		 the tree is considered as a new profiled object.
-
-	order can be either:
-	- callee: callee based call graph.
-	- caller: inverted caller based call graph.
-
-	Default: fractal,0.5,callee.
+	Setup and enable call-graph (stack chain/backtrace) recording,
+	implies -G.
 
 --ignore-callees=<regex>::
         Ignore callees of the function(s) matching the given regex.
diff --git a/tools/perf/builtin-top.c b/tools/perf/builtin-top.c
index 2122141..0df298a 100644
--- a/tools/perf/builtin-top.c
+++ b/tools/perf/builtin-top.c
@@ -1016,16 +1016,16 @@ out_delete:
 }
 
 static int
-parse_callchain_opt(const struct option *opt, const char *arg, int unset)
+callchain_opt(const struct option *opt, const char *arg, int unset)
 {
-	/*
-	 * --no-call-graph
-	 */
-	if (unset)
-		return 0;
-
 	symbol_conf.use_callchain = true;
+	return record_callchain_opt(opt, arg, unset);
+}
 
+static int
+parse_callchain_opt(const struct option *opt, const char *arg, int unset)
+{
+	symbol_conf.use_callchain = true;
 	return record_parse_callchain_opt(opt, arg, unset);
 }
 
@@ -1106,9 +1106,12 @@ int cmd_top(int argc, const char **argv, const char *prefix __maybe_unused)
 		   "sort by key(s): pid, comm, dso, symbol, parent, weight, local_weight"),
 	OPT_BOOLEAN('n', "show-nr-samples", &symbol_conf.show_nr_samples,
 		    "Show a column with the number of samples"),
-	OPT_CALLBACK_DEFAULT('G', "call-graph", &top.record_opts,
-			     "mode[,dump_size]", record_callchain_help,
-			     &parse_callchain_opt, "fp"),
+	OPT_CALLBACK_NOOPT('G', NULL, &top.record_opts,
+			   NULL, "enables call-graph recording",
+			   &callchain_opt),
+	OPT_CALLBACK(0, "call-graph", &top.record_opts,
+		     "mode[,dump_size]", record_callchain_help,
+		     &parse_callchain_opt),
 	OPT_CALLBACK(0, "ignore-callees", NULL, "regex",
 		   "ignore callees of these functions in call graphs",
 		   report_parse_ignore_callees_opt),
