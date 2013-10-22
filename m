Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752630Ab3JVOcx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Oct 2013 10:32:53 -0400
Received: from merlin.infradead.org ([205.233.59.134]:53915 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753694Ab3JVO2y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Oct 2013 10:28:54 -0400
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
Subject: [PATCH 25/26] perf report: Add --max-stack option to limit callchain stack scan
Date: Tue, 22 Oct 2013 11:28:33 -0300
Message-Id: <1382452114-1243-26-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.8.1.4
In-Reply-To: <1382452114-1243-1-git-send-email-acme@infradead.org>
References: <1382452114-1243-1-git-send-email-acme@infradead.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by merlin.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Waiman Long <Waiman.Long@hp.com>

When callgraph data was included in the perf data file, it may take a
long time to scan all those data and merge them together especially if
the stored callchains are long and the perf data file itself is large,
like a Gbyte or so.

The callchain stack is currently limited to PERF_MAX_STACK_DEPTH (127).
This is a large value. Usually the callgraph data that developers are
most interested in are the first few levels, the rests are usually not
looked at.

This patch adds a new --max-stack option to perf-report to limit the
depth of callchain stack data to look at to reduce the time it takes for
perf-report to finish its processing. It trades the presence of trailing
stack information with faster speed.

The following table shows the elapsed time of doing perf-report on a
perf.data file of size 985,531,828 bytes.

  --max_stack   Elapsed Time    Output data size
  -----------   ------------    ----------------
  not set        88.0s          124,422,651
  64             87.5s          116,303,213
  32             87.2s          112,023,804
  16             86.6s           94,326,380
  8              59.9s           33,697,248
  4              40.7s           10,116,637
  -g none        27.1s            2,555,810

Signed-off-by: Waiman Long <Waiman.Long@hp.com>
Acked-by: David Ahern <dsahern@gmail.com>
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
Link: http://lkml.kernel.org/r/1382107129-2010-4-git-send-email-Waiman.Long@hp.com
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/Documentation/perf-report.txt |  8 ++++++++
 tools/perf/builtin-report.c              | 22 +++++++++++++++++-----
 tools/perf/builtin-top.c                 |  3 ++-
 tools/perf/util/machine.c                | 14 +++++++++-----
 tools/perf/util/machine.h                |  3 ++-
 tools/perf/util/session.c                |  3 ++-
 6 files changed, 40 insertions(+), 13 deletions(-)

diff --git a/tools/perf/Documentation/perf-report.txt b/tools/perf/Documentation/perf-report.txt
index be5ad87b6c3d..10a279871251 100644
--- a/tools/perf/Documentation/perf-report.txt
+++ b/tools/perf/Documentation/perf-report.txt
@@ -141,6 +141,14 @@ OPTIONS
 
 	Default: fractal,0.5,callee,function.
 
+--max-stack::
+	Set the stack depth limit when parsing the callchain, anything
+	beyond the specified depth will be ignored. This is a trade-off
+	between information loss and faster processing especially for
+	workloads that can have a very long callchain stack.
+
+	Default: 127
+
 -G::
 --inverted::
         alias for inverted caller based call graph.
diff --git a/tools/perf/builtin-report.c b/tools/perf/builtin-report.c
index fa68a36bc461..81addcabb356 100644
--- a/tools/perf/builtin-report.c
+++ b/tools/perf/builtin-report.c
@@ -49,6 +49,7 @@ struct perf_report {
 	bool			show_threads;
 	bool			inverted_callchain;
 	bool			mem_mode;
+	int			max_stack;
 	struct perf_read_values	show_threads_values;
 	const char		*pretty_printing_style;
 	const char		*cpu_list;
@@ -90,7 +91,8 @@ static int perf_report__add_mem_hist_entry(struct perf_tool *tool,
 	if ((sort__has_parent || symbol_conf.use_callchain) &&
 	    sample->callchain) {
 		err = machine__resolve_callchain(machine, evsel, al->thread,
-						 sample, &parent, al);
+						 sample, &parent, al,
+						 rep->max_stack);
 		if (err)
 			return err;
 	}
@@ -181,7 +183,8 @@ static int perf_report__add_branch_hist_entry(struct perf_tool *tool,
 	if ((sort__has_parent || symbol_conf.use_callchain)
 	    && sample->callchain) {
 		err = machine__resolve_callchain(machine, evsel, al->thread,
-						 sample, &parent, al);
+						 sample, &parent, al,
+						 rep->max_stack);
 		if (err)
 			return err;
 	}
@@ -244,18 +247,21 @@ out:
 	return err;
 }
 
-static int perf_evsel__add_hist_entry(struct perf_evsel *evsel,
+static int perf_evsel__add_hist_entry(struct perf_tool *tool,
+				      struct perf_evsel *evsel,
 				      struct addr_location *al,
 				      struct perf_sample *sample,
 				      struct machine *machine)
 {
+	struct perf_report *rep = container_of(tool, struct perf_report, tool);
 	struct symbol *parent = NULL;
 	int err = 0;
 	struct hist_entry *he;
 
 	if ((sort__has_parent || symbol_conf.use_callchain) && sample->callchain) {
 		err = machine__resolve_callchain(machine, evsel, al->thread,
-						 sample, &parent, al);
+						 sample, &parent, al,
+						 rep->max_stack);
 		if (err)
 			return err;
 	}
@@ -332,7 +338,8 @@ static int process_sample_event(struct perf_tool *tool,
 		if (al.map != NULL)
 			al.map->dso->hit = 1;
 
-		ret = perf_evsel__add_hist_entry(evsel, &al, sample, machine);
+		ret = perf_evsel__add_hist_entry(tool, evsel, &al, sample,
+						 machine);
 		if (ret < 0)
 			pr_debug("problem incrementing symbol period, skipping event\n");
 	}
@@ -772,6 +779,7 @@ int cmd_report(int argc, const char **argv, const char *prefix __maybe_unused)
 			.ordered_samples = true,
 			.ordering_requires_timestamps = true,
 		},
+		.max_stack		 = PERF_MAX_STACK_DEPTH,
 		.pretty_printing_style	 = "normal",
 	};
 	const struct option options[] = {
@@ -812,6 +820,10 @@ int cmd_report(int argc, const char **argv, const char *prefix __maybe_unused)
 	OPT_CALLBACK_DEFAULT('g', "call-graph", &report, "output_type,min_percent[,print_limit],call_order",
 		     "Display callchains using output_type (graph, flat, fractal, or none) , min percent threshold, optional print limit, callchain order, key (function or address). "
 		     "Default: fractal,0.5,callee,function", &parse_callchain_opt, callchain_default_opt),
+	OPT_INTEGER(0, "max-stack", &report.max_stack,
+		    "Set the maximum stack depth when parsing the callchain, "
+		    "anything beyond the specified depth will be ignored. "
+		    "Default: " __stringify(PERF_MAX_STACK_DEPTH)),
 	OPT_BOOLEAN('G', "inverted", &report.inverted_callchain,
 		    "alias for inverted call graph"),
 	OPT_CALLBACK(0, "ignore-callees", NULL, "regex",
diff --git a/tools/perf/builtin-top.c b/tools/perf/builtin-top.c
index d934f707ee74..112cb7d68e64 100644
--- a/tools/perf/builtin-top.c
+++ b/tools/perf/builtin-top.c
@@ -770,7 +770,8 @@ static void perf_event__process_sample(struct perf_tool *tool,
 		    sample->callchain) {
 			err = machine__resolve_callchain(machine, evsel,
 							 al.thread, sample,
-							 &parent, &al);
+							 &parent, &al,
+							 PERF_MAX_STACK_DEPTH);
 			if (err)
 				return;
 		}
diff --git a/tools/perf/util/machine.c b/tools/perf/util/machine.c
index 6b861aefd99a..ea93425cce95 100644
--- a/tools/perf/util/machine.c
+++ b/tools/perf/util/machine.c
@@ -1253,10 +1253,12 @@ static int machine__resolve_callchain_sample(struct machine *machine,
 					     struct thread *thread,
 					     struct ip_callchain *chain,
 					     struct symbol **parent,
-					     struct addr_location *root_al)
+					     struct addr_location *root_al,
+					     int max_stack)
 {
 	u8 cpumode = PERF_RECORD_MISC_USER;
-	unsigned int i;
+	int chain_nr = min(max_stack, (int)chain->nr);
+	int i;
 	int err;
 
 	callchain_cursor_reset(&callchain_cursor);
@@ -1266,7 +1268,7 @@ static int machine__resolve_callchain_sample(struct machine *machine,
 		return 0;
 	}
 
-	for (i = 0; i < chain->nr; i++) {
+	for (i = 0; i < chain_nr; i++) {
 		u64 ip;
 		struct addr_location al;
 
@@ -1338,12 +1340,14 @@ int machine__resolve_callchain(struct machine *machine,
 			       struct thread *thread,
 			       struct perf_sample *sample,
 			       struct symbol **parent,
-			       struct addr_location *root_al)
+			       struct addr_location *root_al,
+			       int max_stack)
 {
 	int ret;
 
 	ret = machine__resolve_callchain_sample(machine, thread,
-						sample->callchain, parent, root_al);
+						sample->callchain, parent,
+						root_al, max_stack);
 	if (ret)
 		return ret;
 
diff --git a/tools/perf/util/machine.h b/tools/perf/util/machine.h
index d44c09bdc45e..4c1f5d567f54 100644
--- a/tools/perf/util/machine.h
+++ b/tools/perf/util/machine.h
@@ -92,7 +92,8 @@ int machine__resolve_callchain(struct machine *machine,
 			       struct thread *thread,
 			       struct perf_sample *sample,
 			       struct symbol **parent,
-			       struct addr_location *root_al);
+			       struct addr_location *root_al,
+			       int max_stack);
 
 /*
  * Default guest kernel is defined by parameter --guestkallsyms
diff --git a/tools/perf/util/session.c b/tools/perf/util/session.c
index 19fc71678c8e..854c5aa4db0d 100644
--- a/tools/perf/util/session.c
+++ b/tools/perf/util/session.c
@@ -1512,7 +1512,8 @@ void perf_evsel__print_ip(struct perf_evsel *evsel, union perf_event *event,
 	if (symbol_conf.use_callchain && sample->callchain) {
 
 		if (machine__resolve_callchain(machine, evsel, al.thread,
-					       sample, NULL, NULL) != 0) {
+					       sample, NULL, NULL,
+					       PERF_MAX_STACK_DEPTH) != 0) {
 			if (verbose)
 				error("Failed to resolve callchain. Skipping\n");
 			return;
-- 
1.8.1.4

