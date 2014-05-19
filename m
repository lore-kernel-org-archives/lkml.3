Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753373AbaESGaT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 May 2014 02:30:19 -0400
Received: from LGEMRELSE6Q.lge.com ([156.147.1.121]:59532 "EHLO
	lgemrelse6q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752521AbaESG0H (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 May 2014 02:26:07 -0400
X-Original-SENDERIP: 10.177.220.181
X-Original-MAILFROM: namhyung@kernel.org
From: Namhyung Kim <namhyung@kernel.org>
To: Arnaldo Carvalho de Melo <acme@kernel.org>, Jiri Olsa <jolsa@redhat.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Ingo Molnar <mingo@kernel.org>,
        Paul Mackerras <paulus@samba.org>, Namhyung Kim <namhyung.kim@lge.com>,
        Namhyung Kim <namhyung@kernel.org>,
        LKML <linux-kernel@vger.kernel.org>, David Ahern <dsahern@gmail.com>,
        Andi Kleen <andi@firstfloor.org>, Don Zickus <dzickus@rehdat.com>
Subject: [PATCH 08/20] perf tools: Allow hpp fields to be sort keys
Date: Mon, 19 May 2014 15:25:50 +0900
Message-Id: <1400480762-22852-9-git-send-email-namhyung@kernel.org>
X-Mailer: git-send-email 1.9.2
In-Reply-To: <1400480762-22852-1-git-send-email-namhyung@kernel.org>
References: <1400480762-22852-1-git-send-email-namhyung@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add overhead{,_sys,_us,_guest_sys,_guest_us}, sample and period sort
keys so that they can be selected with --sort/-s option.

  $ perf report -s period,comm --stdio
  ...
  # Overhead        Period          Command
  # ........  ............  ...............
  #
      47.06%           152          swapper
      13.93%            45  qemu-system-arm
      12.38%            40         synergys
       3.72%            12          firefox
       2.48%             8            xchat

Acked-by: Ingo Molnar <mingo@kernel.org>
Signed-off-by: Namhyung Kim <namhyung@kernel.org>
---
 tools/perf/Documentation/perf-diff.txt   |  5 ++--
 tools/perf/Documentation/perf-report.txt |  9 ++++++++
 tools/perf/Documentation/perf-top.txt    |  5 ++--
 tools/perf/builtin-diff.c                |  3 ++-
 tools/perf/builtin-report.c              |  6 ++---
 tools/perf/builtin-top.c                 |  4 ++--
 tools/perf/ui/hist.c                     |  9 ++++++--
 tools/perf/util/sort.c                   | 39 ++++++++++++++++++++++++++++++++
 8 files changed, 67 insertions(+), 13 deletions(-)

diff --git a/tools/perf/Documentation/perf-diff.txt b/tools/perf/Documentation/perf-diff.txt
index fbfa1192923c..b3b8abae62b8 100644
--- a/tools/perf/Documentation/perf-diff.txt
+++ b/tools/perf/Documentation/perf-diff.txt
@@ -50,7 +50,8 @@ OPTIONS
 
 -s::
 --sort=::
-	Sort by key(s): pid, comm, dso, symbol.
+	Sort by key(s): pid, comm, dso, symbol, cpu, parent, srcline.
+	Please see description of --sort in the perf-report man page.
 
 -t::
 --field-separator=::
@@ -202,4 +203,4 @@ If specified the 'Weighted diff' column is displayed with value 'd' computed as:
 
 SEE ALSO
 --------
-linkperf:perf-record[1]
+linkperf:perf-record[1], linkperf:perf-report[1]
diff --git a/tools/perf/Documentation/perf-report.txt b/tools/perf/Documentation/perf-report.txt
index 09af66298564..9babe915b6c4 100644
--- a/tools/perf/Documentation/perf-report.txt
+++ b/tools/perf/Documentation/perf-report.txt
@@ -79,6 +79,15 @@ OPTIONS
 	abort cost. This is the global weight.
 	- local_weight: Local weight version of the weight above.
 	- transaction: Transaction abort flags.
+	- overhead: Overhead percentage of sample
+	- overhead_sys: Overhead percentage of sample running in system mode
+	- overhead_us: Overhead percentage of sample running in user mode
+	- overhead_guest_sys: Overhead percentage of sample running in system mode
+	on guest machine
+	- overhead_guest_us: Overhead percentage of sample running in user mode on
+	guest machine
+	- sample: Number of sample
+	- period: Raw number of event count of sample
 
 	By default, comm, dso and symbol keys are used.
 	(i.e. --sort comm,dso,symbol)
diff --git a/tools/perf/Documentation/perf-top.txt b/tools/perf/Documentation/perf-top.txt
index 64ed79c43639..df863288752a 100644
--- a/tools/perf/Documentation/perf-top.txt
+++ b/tools/perf/Documentation/perf-top.txt
@@ -113,7 +113,8 @@ Default is to monitor all CPUS.
 -s::
 --sort::
 	Sort by key(s): pid, comm, dso, symbol, parent, srcline, weight,
-	local_weight, abort, in_tx, transaction
+	local_weight, abort, in_tx, transaction, overhead, sample, period.
+	Please see description of --sort in the perf-report man page.
 
 -n::
 --show-nr-samples::
@@ -212,4 +213,4 @@ Pressing any unmapped key displays a menu, and prompts for input.
 
 SEE ALSO
 --------
-linkperf:perf-stat[1], linkperf:perf-list[1]
+linkperf:perf-stat[1], linkperf:perf-list[1], linkperf:perf-report[1]
diff --git a/tools/perf/builtin-diff.c b/tools/perf/builtin-diff.c
index f3b10dcf6838..b60c711d4e72 100644
--- a/tools/perf/builtin-diff.c
+++ b/tools/perf/builtin-diff.c
@@ -741,7 +741,8 @@ static const struct option options[] = {
 	OPT_STRING('S', "symbols", &symbol_conf.sym_list_str, "symbol[,symbol...]",
 		   "only consider these symbols"),
 	OPT_STRING('s', "sort", &sort_order, "key[,key2...]",
-		   "sort by key(s): pid, comm, dso, symbol, parent"),
+		   "sort by key(s): pid, comm, dso, symbol, parent, cpu, srcline, ..."
+		   " Please refer the man page for the complete list."),
 	OPT_STRING('t', "field-separator", &symbol_conf.field_sep, "separator",
 		   "separator for columns, no spaces will be added between "
 		   "columns '.' is reserved."),
diff --git a/tools/perf/builtin-report.c b/tools/perf/builtin-report.c
index 89c95289fd51..d0180d5de781 100644
--- a/tools/perf/builtin-report.c
+++ b/tools/perf/builtin-report.c
@@ -699,10 +699,8 @@ int cmd_report(int argc, const char **argv, const char *prefix __maybe_unused)
 	OPT_BOOLEAN(0, "header-only", &report.header_only,
 		    "Show only data header."),
 	OPT_STRING('s', "sort", &sort_order, "key[,key2...]",
-		   "sort by key(s): pid, comm, dso, symbol, parent, cpu, srcline,"
-		   " dso_to, dso_from, symbol_to, symbol_from, mispredict,"
-		   " weight, local_weight, mem, symbol_daddr, dso_daddr, tlb, "
-		   "snoop, locked, abort, in_tx, transaction"),
+		   "sort by key(s): pid, comm, dso, symbol, parent, cpu, srcline, ..."
+		   " Please refer the man page for the complete list."),
 	OPT_BOOLEAN(0, "showcpuutilization", &symbol_conf.show_cpu_utilization,
 		    "Show sample percentage for different cpu modes"),
 	OPT_STRING('p', "parent", &parent_pattern, "regex",
diff --git a/tools/perf/builtin-top.c b/tools/perf/builtin-top.c
index 37d30460bada..4fef1e415129 100644
--- a/tools/perf/builtin-top.c
+++ b/tools/perf/builtin-top.c
@@ -1083,8 +1083,8 @@ int cmd_top(int argc, const char **argv, const char *prefix __maybe_unused)
 	OPT_INCR('v', "verbose", &verbose,
 		    "be more verbose (show counter open errors, etc)"),
 	OPT_STRING('s', "sort", &sort_order, "key[,key2...]",
-		   "sort by key(s): pid, comm, dso, symbol, parent, weight, local_weight,"
-		   " abort, in_tx, transaction"),
+		   "sort by key(s): pid, comm, dso, symbol, parent, cpu, srcline, ..."
+		   " Please refer the man page for the complete list."),
 	OPT_BOOLEAN('n', "show-nr-samples", &symbol_conf.show_nr_samples,
 		    "Show a column with the number of samples"),
 	OPT_CALLBACK_NOOPT('g', NULL, &top.record_opts,
diff --git a/tools/perf/ui/hist.c b/tools/perf/ui/hist.c
index e7ac794382c1..24116a48298f 100644
--- a/tools/perf/ui/hist.c
+++ b/tools/perf/ui/hist.c
@@ -346,8 +346,13 @@ void perf_hpp__init(void)
 	int i;
 
 	for (i = 0; i < PERF_HPP__MAX_INDEX; i++) {
-		INIT_LIST_HEAD(&perf_hpp__format[i].list);
-		INIT_LIST_HEAD(&perf_hpp__format[i].sort_list);
+		struct perf_hpp_fmt *fmt = &perf_hpp__format[i];
+
+		INIT_LIST_HEAD(&fmt->list);
+
+		/* sort_list may be linked by setup_sorting() */
+		if (fmt->sort_list.next == NULL)
+			INIT_LIST_HEAD(&fmt->sort_list);
 	}
 
 	perf_hpp__column_enable(PERF_HPP__OVERHEAD);
diff --git a/tools/perf/util/sort.c b/tools/perf/util/sort.c
index b2829f947053..916652af8304 100644
--- a/tools/perf/util/sort.c
+++ b/tools/perf/util/sort.c
@@ -1028,6 +1028,26 @@ static struct sort_dimension memory_sort_dimensions[] = {
 
 #undef DIM
 
+struct hpp_dimension {
+	const char		*name;
+	struct perf_hpp_fmt	*fmt;
+	int			taken;
+};
+
+#define DIM(d, n) { .name = n, .fmt = &perf_hpp__format[d], }
+
+static struct hpp_dimension hpp_sort_dimensions[] = {
+	DIM(PERF_HPP__OVERHEAD, "overhead"),
+	DIM(PERF_HPP__OVERHEAD_SYS, "overhead_sys"),
+	DIM(PERF_HPP__OVERHEAD_US, "overhead_us"),
+	DIM(PERF_HPP__OVERHEAD_GUEST_SYS, "overhead_guest_sys"),
+	DIM(PERF_HPP__OVERHEAD_GUEST_US, "overhead_guest_us"),
+	DIM(PERF_HPP__SAMPLES, "sample"),
+	DIM(PERF_HPP__PERIOD, "period"),
+};
+
+#undef DIM
+
 struct hpp_sort_entry {
 	struct perf_hpp_fmt hpp;
 	struct sort_entry *se;
@@ -1115,6 +1135,16 @@ static int __sort_dimension__add(struct sort_dimension *sd, enum sort_type idx)
 	return 0;
 }
 
+static int __hpp_dimension__add(struct hpp_dimension *hd)
+{
+	if (!hd->taken) {
+		hd->taken = 1;
+
+		perf_hpp__register_sort_field(hd->fmt);
+	}
+	return 0;
+}
+
 int sort_dimension__add(const char *tok)
 {
 	unsigned int i;
@@ -1144,6 +1174,15 @@ int sort_dimension__add(const char *tok)
 		return __sort_dimension__add(sd, i);
 	}
 
+	for (i = 0; i < ARRAY_SIZE(hpp_sort_dimensions); i++) {
+		struct hpp_dimension *hd = &hpp_sort_dimensions[i];
+
+		if (strncasecmp(tok, hd->name, strlen(tok)))
+			continue;
+
+		return __hpp_dimension__add(hd);
+	}
+
 	for (i = 0; i < ARRAY_SIZE(bstack_sort_dimensions); i++) {
 		struct sort_dimension *sd = &bstack_sort_dimensions[i];
 
-- 
1.9.2

