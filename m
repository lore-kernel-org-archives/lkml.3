Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753277Ab3JWH4v (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Oct 2013 03:56:51 -0400
Received: from terminus.zytor.com ([198.137.202.10]:56073 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753107Ab3JWHz7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Oct 2013 03:55:59 -0400
Date: Wed, 23 Oct 2013 00:55:35 -0700
From: tip-bot for Waiman Long <tipbot@zytor.com>
Message-ID: <tip-91e95617429cb272fd908b1928a1915b37b9655f@git.kernel.org>
Cc: acme@redhat.com, eranian@google.com, mingo@redhat.com, mingo@kernel.org,
        a.p.zijlstra@chello.nl, jolsa@redhat.com, Waiman.Long@hp.com,
        dsahern@gmail.com, tglx@linutronix.de, scott.norton@hp.com,
        hpa@zytor.com, paulus@samba.org, linux-kernel@vger.kernel.org,
        namhyung@kernel.org, adrian.hunter@intel.com, aswin@hp.com
Reply-To: mingo@kernel.org, mingo@redhat.com, eranian@google.com,
        acme@redhat.com, a.p.zijlstra@chello.nl, jolsa@redhat.com,
        Waiman.Long@hp.com, dsahern@gmail.com, tglx@linutronix.de,
        scott.norton@hp.com, hpa@zytor.com, paulus@samba.org,
        linux-kernel@vger.kernel.org, namhyung@kernel.org,
        adrian.hunter@intel.com, aswin@hp.com
In-Reply-To: <1382107129-2010-4-git-send-email-Waiman.Long@hp.com>
References: <1382107129-2010-4-git-send-email-Waiman.Long@hp.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf report:
  Add --max-stack option to limit callchain stack scan
Git-Commit-ID: 91e95617429cb272fd908b1928a1915b37b9655f
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.1 (terminus.zytor.com [127.0.0.1]); Wed, 23 Oct 2013 00:55:42 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  91e95617429cb272fd908b1928a1915b37b9655f
Gitweb:     http://git.kernel.org/tip/91e95617429cb272fd908b1928a1915b37b9655f
Author:     Waiman Long <Waiman.Long@hp.com>
AuthorDate: Fri, 18 Oct 2013 10:38:48 -0400
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Mon, 21 Oct 2013 17:36:25 -0300

perf report: Add --max-stack option to limit callchain stack scan

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
index be5ad87..10a2798 100644
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
index fa68a36..81addca 100644
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
index d934f70..112cb7d 100644
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
index 6b861ae..ea93425 100644
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
index d44c09b..4c1f5d5 100644
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
index 19fc716..854c5aa 100644
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
