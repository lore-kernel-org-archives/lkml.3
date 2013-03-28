Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757359Ab3C1RGs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Mar 2013 13:06:48 -0400
Received: from merlin.infradead.org ([205.233.59.134]:36344 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756915Ab3C1RCy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Mar 2013 13:02:54 -0400
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org, Stephane Eranian <eranian@google.com>,
        Andi Kleen <ak@linux.intel.com>, Ingo Molnar <mingo@elte.hu>,
        Jiri Olsa <jolsa@redhat.com>, Namhyung Kim <namhyung.kim@lge.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 27/36] perf report: Add support for mem access profiling
Date: Thu, 28 Mar 2013 14:02:27 -0300
Message-Id: <1364490156-32064-28-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.8.1.1.361.gec3ae6e
In-Reply-To: <1364490156-32064-1-git-send-email-acme@infradead.org>
References: <1364490156-32064-1-git-send-email-acme@infradead.org>
Content-Type: text/plain; charset="utf-8"
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by merlin.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Stephane Eranian <eranian@google.com>

This patch adds the --mem-mode option to perf report.

This mode requires a perf.data file created with memory access samples.

Signed-off-by: Stephane Eranian <eranian@google.com>
Cc: Andi Kleen <ak@linux.intel.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Namhyung Kim <namhyung.kim@lge.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Link: http://lkml.kernel.org/r/1359040242-8269-13-git-send-email-eranian@google.com
[ Removed duplicates in the --sort help, man page needs updating,
  Fixed minor conflict with 328ccda "perf report: Add --no-demangle option" ]
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/builtin-report.c |  135 +++++++++++++++++++++++++++++++++++++++++-
 1 files changed, 131 insertions(+), 4 deletions(-)

diff --git a/tools/perf/builtin-report.c b/tools/perf/builtin-report.c
index e31f070..a20550c 100644
--- a/tools/perf/builtin-report.c
+++ b/tools/perf/builtin-report.c
@@ -46,6 +46,7 @@ struct perf_report {
 	bool			show_full_info;
 	bool			show_threads;
 	bool			inverted_callchain;
+	bool			mem_mode;
 	struct perf_read_values	show_threads_values;
 	const char		*pretty_printing_style;
 	symbol_filter_t		annotate_init;
@@ -64,6 +65,99 @@ static int perf_report_config(const char *var, const char *value, void *cb)
 	return perf_default_config(var, value, cb);
 }
 
+static int perf_report__add_mem_hist_entry(struct perf_tool *tool,
+					   struct addr_location *al,
+					   struct perf_sample *sample,
+					   struct perf_evsel *evsel,
+					   struct machine *machine,
+					   union perf_event *event)
+{
+	struct perf_report *rep = container_of(tool, struct perf_report, tool);
+	struct symbol *parent = NULL;
+	u8 cpumode = event->header.misc & PERF_RECORD_MISC_CPUMODE_MASK;
+	int err = 0;
+	struct hist_entry *he;
+	struct mem_info *mi, *mx;
+	uint64_t cost;
+
+	if ((sort__has_parent || symbol_conf.use_callchain) &&
+	    sample->callchain) {
+		err = machine__resolve_callchain(machine, evsel, al->thread,
+						 sample, &parent);
+		if (err)
+			return err;
+	}
+
+	mi = machine__resolve_mem(machine, al->thread, sample, cpumode);
+	if (!mi)
+		return -ENOMEM;
+
+	if (rep->hide_unresolved && !al->sym)
+		return 0;
+
+	cost = sample->weight;
+	if (!cost)
+		cost = 1;
+
+	/*
+	 * must pass period=weight in order to get the correct
+	 * sorting from hists__collapse_resort() which is solely
+	 * based on periods. We want sorting be done on nr_events * weight
+	 * and this is indirectly achieved by passing period=weight here
+	 * and the he_stat__add_period() function.
+	 */
+	he = __hists__add_mem_entry(&evsel->hists, al, parent, mi, cost, cost);
+	if (!he)
+		return -ENOMEM;
+
+	/*
+	 * In the newt browser, we are doing integrated annotation,
+	 * so we don't allocate the extra space needed because the stdio
+	 * code will not use it.
+	 */
+	if (sort__has_sym && he->ms.sym && use_browser > 0) {
+		struct annotation *notes = symbol__annotation(he->ms.sym);
+
+		assert(evsel != NULL);
+
+		if (notes->src == NULL && symbol__alloc_hist(he->ms.sym) < 0)
+			goto out;
+
+		err = hist_entry__inc_addr_samples(he, evsel->idx, al->addr);
+		if (err)
+			goto out;
+	}
+
+	if (sort__has_sym && he->mem_info->daddr.sym && use_browser > 0) {
+		struct annotation *notes;
+
+		mx = he->mem_info;
+
+		notes = symbol__annotation(mx->daddr.sym);
+		if (notes->src == NULL && symbol__alloc_hist(mx->daddr.sym) < 0)
+			goto out;
+
+		err = symbol__inc_addr_samples(mx->daddr.sym,
+					       mx->daddr.map,
+					       evsel->idx,
+					       mx->daddr.al_addr);
+		if (err)
+			goto out;
+	}
+
+	evsel->hists.stats.total_period += cost;
+	hists__inc_nr_events(&evsel->hists, PERF_RECORD_SAMPLE);
+	err = 0;
+
+	if (symbol_conf.use_callchain) {
+		err = callchain_append(he->callchain,
+				       &callchain_cursor,
+				       sample->period);
+	}
+out:
+	return err;
+}
+
 static int perf_report__add_branch_hist_entry(struct perf_tool *tool,
 					struct addr_location *al,
 					struct perf_sample *sample,
@@ -220,6 +314,12 @@ static int process_sample_event(struct perf_tool *tool,
 			pr_debug("problem adding lbr entry, skipping event\n");
 			return -1;
 		}
+	} else if (rep->mem_mode == 1) {
+		if (perf_report__add_mem_hist_entry(tool, &al, sample,
+						    evsel, machine, event)) {
+			pr_debug("problem adding mem entry, skipping event\n");
+			return -1;
+		}
 	} else {
 		if (al.map != NULL)
 			al.map->dso->hit = 1;
@@ -303,7 +403,8 @@ static void sig_handler(int sig __maybe_unused)
 	session_done = 1;
 }
 
-static size_t hists__fprintf_nr_sample_events(struct hists *self,
+static size_t hists__fprintf_nr_sample_events(struct perf_report *rep,
+					      struct hists *self,
 					      const char *evname, FILE *fp)
 {
 	size_t ret;
@@ -331,7 +432,11 @@ static size_t hists__fprintf_nr_sample_events(struct hists *self,
 	if (evname != NULL)
 		ret += fprintf(fp, " of event '%s'", evname);
 
-	ret += fprintf(fp, "\n# Event count (approx.): %" PRIu64, nr_events);
+	if (rep->mem_mode) {
+		ret += fprintf(fp, "\n# Total weight : %" PRIu64, nr_events);
+		ret += fprintf(fp, "\n# Sort order   : %s", sort_order);
+	} else
+		ret += fprintf(fp, "\n# Event count (approx.): %" PRIu64, nr_events);
 	return ret + fprintf(fp, "\n#\n");
 }
 
@@ -349,7 +454,7 @@ static int perf_evlist__tty_browse_hists(struct perf_evlist *evlist,
 		    !perf_evsel__is_group_leader(pos))
 			continue;
 
-		hists__fprintf_nr_sample_events(hists, evname, stdout);
+		hists__fprintf_nr_sample_events(rep, hists, evname, stdout);
 		hists__fprintf(hists, true, 0, 0, stdout);
 		fprintf(stdout, "\n\n");
 	}
@@ -646,7 +751,8 @@ int cmd_report(int argc, const char **argv, const char *prefix __maybe_unused)
 	OPT_STRING('s', "sort", &sort_order, "key[,key2...]",
 		   "sort by key(s): pid, comm, dso, symbol, parent, cpu, srcline,"
 		   " dso_to, dso_from, symbol_to, symbol_from, mispredict,"
-		   " weight, local_weight"),
+		   " weight, local_weight, mem, symbol_daddr, dso_daddr, tlb, "
+		   "snoop, locked"),
 	OPT_BOOLEAN(0, "showcpuutilization", &symbol_conf.show_cpu_utilization,
 		    "Show sample percentage for different cpu modes"),
 	OPT_STRING('p', "parent", &parent_pattern, "regex",
@@ -696,6 +802,7 @@ int cmd_report(int argc, const char **argv, const char *prefix __maybe_unused)
 		   "objdump binary to use for disassembly and annotations"),
 	OPT_BOOLEAN(0, "demangle", &symbol_conf.demangle,
 		    "Disable symbol demangling"),
+	OPT_BOOLEAN(0, "mem-mode", &report.mem_mode, "mem access profile"),
 	OPT_END()
 	};
 
@@ -753,6 +860,18 @@ repeat:
 				     "dso_to,symbol_to";
 
 	}
+	if (report.mem_mode) {
+		if (sort__branch_mode == 1) {
+			fprintf(stderr, "branch and mem mode incompatible\n");
+			goto error;
+		}
+		/*
+		 * if no sort_order is provided, then specify
+		 * branch-mode specific order
+		 */
+		if (sort_order == default_sort_order)
+			sort_order = "local_weight,mem,sym,dso,symbol_daddr,dso_daddr,snoop,tlb,locked";
+	}
 
 	if (setup_sorting() < 0)
 		usage_with_options(report_usage, options);
@@ -818,6 +937,14 @@ repeat:
 		sort_entry__setup_elide(&sort_sym_from, symbol_conf.sym_from_list, "sym_from", stdout);
 		sort_entry__setup_elide(&sort_sym_to, symbol_conf.sym_to_list, "sym_to", stdout);
 	} else {
+		if (report.mem_mode) {
+			sort_entry__setup_elide(&sort_dso, symbol_conf.dso_list, "symbol_daddr", stdout);
+			sort_entry__setup_elide(&sort_dso, symbol_conf.dso_list, "dso_daddr", stdout);
+			sort_entry__setup_elide(&sort_dso, symbol_conf.dso_list, "mem", stdout);
+			sort_entry__setup_elide(&sort_dso, symbol_conf.dso_list, "local_weight", stdout);
+			sort_entry__setup_elide(&sort_dso, symbol_conf.dso_list, "tlb", stdout);
+			sort_entry__setup_elide(&sort_dso, symbol_conf.dso_list, "snoop", stdout);
+		}
 		sort_entry__setup_elide(&sort_dso, symbol_conf.dso_list, "dso", stdout);
 		sort_entry__setup_elide(&sort_sym, symbol_conf.sym_list, "symbol", stdout);
 	}
-- 
1.7.1

