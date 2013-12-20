Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755932Ab3LTTKD (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Dec 2013 14:10:03 -0500
Received: from merlin.infradead.org ([205.233.59.134]:38523 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752799Ab3LTTJb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Dec 2013 14:09:31 -0500
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org, Arnaldo Carvalho de Melo <acme@redhat.com>,
        Adrian Hunter <adrian.hunter@intel.com>,
        David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Jiri Olsa <jolsa@redhat.com>,
        Mike Galbraith <efault@gmx.de>, Namhyung Kim <namhyung@kernel.org>,
        Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Stephane Eranian <eranian@google.com>
Subject: [PATCH 11/35] perf report: Introduce helpers for processing callchains
Date: Fri, 20 Dec 2013 16:08:46 -0300
Message-Id: <1387566550-3524-12-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.8.1.4
In-Reply-To: <1387566550-3524-1-git-send-email-acme@infradead.org>
References: <1387566550-3524-1-git-send-email-acme@infradead.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by merlin.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Arnaldo Carvalho de Melo <acme@redhat.com>

Continuing to try to remove the code duplication introduced with mem and
branch hist entry code, this time providing prologue and epilogues to
deal with callchains when processing samples.

Acked-by: Namhyung Kim <namhyung@kernel.org>
Cc: Adrian Hunter <adrian.hunter@intel.com>
Cc: David Ahern <dsahern@gmail.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Stephane Eranian <eranian@google.com>
Link: http://lkml.kernel.org/n/tip-js3pour59yk2aibqzb1tpumh@git.kernel.org
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/builtin-report.c | 72 ++++++++++++++++++++-------------------------
 1 file changed, 32 insertions(+), 40 deletions(-)

diff --git a/tools/perf/builtin-report.c b/tools/perf/builtin-report.c
index 9a20c9efb84b..8424053b399a 100644
--- a/tools/perf/builtin-report.c
+++ b/tools/perf/builtin-report.c
@@ -75,6 +75,24 @@ static int perf_report_config(const char *var, const char *value, void *cb)
 	return perf_default_config(var, value, cb);
 }
 
+static int report__resolve_callchain(struct perf_report *rep, struct symbol **parent,
+				     struct perf_evsel *evsel, struct addr_location *al,
+				     struct perf_sample *sample, struct machine *machine)
+{
+	if ((sort__has_parent || symbol_conf.use_callchain) && sample->callchain) {
+		return machine__resolve_callchain(machine, evsel, al->thread, sample,
+						  parent, al, rep->max_stack);
+	}
+	return 0;
+}
+
+static int hist_entry__append_callchain(struct hist_entry *he, struct perf_sample *sample)
+{
+	if (!symbol_conf.use_callchain)
+		return 0;
+	return callchain_append(he->callchain, &callchain_cursor, sample->period);
+}
+
 static int perf_report__add_mem_hist_entry(struct perf_tool *tool,
 					   struct addr_location *al,
 					   struct perf_sample *sample,
@@ -85,19 +103,13 @@ static int perf_report__add_mem_hist_entry(struct perf_tool *tool,
 	struct perf_report *rep = container_of(tool, struct perf_report, tool);
 	struct symbol *parent = NULL;
 	u8 cpumode = event->header.misc & PERF_RECORD_MISC_CPUMODE_MASK;
-	int err = 0;
 	struct hist_entry *he;
 	struct mem_info *mi, *mx;
 	uint64_t cost;
+	int err = report__resolve_callchain(rep, &parent, evsel, al, sample, machine);
 
-	if ((sort__has_parent || symbol_conf.use_callchain) &&
-	    sample->callchain) {
-		err = machine__resolve_callchain(machine, evsel, al->thread,
-						 sample, &parent, al,
-						 rep->max_stack);
-		if (err)
-			return err;
-	}
+	if (err)
+		return err;
 
 	mi = machine__resolve_mem(machine, al->thread, sample, cpumode);
 	if (!mi)
@@ -133,13 +145,7 @@ static int perf_report__add_mem_hist_entry(struct perf_tool *tool,
 
 	evsel->hists.stats.total_period += cost;
 	hists__inc_nr_events(&evsel->hists, PERF_RECORD_SAMPLE);
-	err = 0;
-
-	if (symbol_conf.use_callchain) {
-		err = callchain_append(he->callchain,
-				       &callchain_cursor,
-				       sample->period);
-	}
+	err = hist_entry__append_callchain(he, sample);
 out:
 	return err;
 }
@@ -152,19 +158,13 @@ static int perf_report__add_branch_hist_entry(struct perf_tool *tool,
 {
 	struct perf_report *rep = container_of(tool, struct perf_report, tool);
 	struct symbol *parent = NULL;
-	int err = 0;
 	unsigned i;
 	struct hist_entry *he;
 	struct branch_info *bi, *bx;
+	int err = report__resolve_callchain(rep, &parent, evsel, al, sample, machine);
 
-	if ((sort__has_parent || symbol_conf.use_callchain)
-	    && sample->callchain) {
-		err = machine__resolve_callchain(machine, evsel, al->thread,
-						 sample, &parent, al,
-						 rep->max_stack);
-		if (err)
-			return err;
-	}
+	if (err)
+		return err;
 
 	bi = machine__resolve_bstack(machine, al->thread,
 				     sample->branch_stack);
@@ -216,16 +216,11 @@ static int perf_evsel__add_hist_entry(struct perf_tool *tool,
 {
 	struct perf_report *rep = container_of(tool, struct perf_report, tool);
 	struct symbol *parent = NULL;
-	int err = 0;
 	struct hist_entry *he;
+	int err = report__resolve_callchain(rep, &parent, evsel, al, sample, machine);
 
-	if ((sort__has_parent || symbol_conf.use_callchain) && sample->callchain) {
-		err = machine__resolve_callchain(machine, evsel, al->thread,
-						 sample, &parent, al,
-						 rep->max_stack);
-		if (err)
-			return err;
-	}
+	if (err)
+		return err;
 
 	he = __hists__add_entry(&evsel->hists, al, parent, NULL, NULL,
 				sample->period, sample->weight,
@@ -233,17 +228,14 @@ static int perf_evsel__add_hist_entry(struct perf_tool *tool,
 	if (he == NULL)
 		return -ENOMEM;
 
-	if (symbol_conf.use_callchain) {
-		err = callchain_append(he->callchain,
-				       &callchain_cursor,
-				       sample->period);
-		if (err)
-			return err;
-	}
+	err = hist_entry__append_callchain(he, sample);
+	if (err)
+		goto out;
 
 	err = hist_entry__inc_addr_samples(he, evsel->idx, al->addr);
 	evsel->hists.stats.total_period += sample->period;
 	hists__inc_nr_events(&evsel->hists, PERF_RECORD_SAMPLE);
+out:
 	return err;
 }
 
-- 
1.8.1.4

