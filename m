Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751535AbaALSdV (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Jan 2014 13:33:21 -0500
Received: from terminus.zytor.com ([198.137.202.10]:45443 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751453AbaALSdP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Jan 2014 13:33:15 -0500
Date: Sun, 12 Jan 2014 10:32:36 -0800
From: tip-bot for Arnaldo Carvalho de Melo <tipbot@zytor.com>
Message-ID: <tip-js3pour59yk2aibqzb1tpumh@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, eranian@google.com, paulus@samba.org,
        acme@redhat.com, hpa@zytor.com, mingo@kernel.org, peterz@infradead.org,
        efault@gmx.de, namhyung@kernel.org, jolsa@redhat.com,
        fweisbec@gmail.com, adrian.hunter@intel.com, dsahern@gmail.com,
        tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, acme@redhat.com, paulus@samba.org,
        eranian@google.com, linux-kernel@vger.kernel.org, efault@gmx.de,
        peterz@infradead.org, namhyung@kernel.org, jolsa@redhat.com,
        fweisbec@gmail.com, dsahern@gmail.com, adrian.hunter@intel.com,
        tglx@linutronix.de
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf report:
  Introduce helpers for processing callchains
Git-Commit-ID: 6dbc8ca97b7737fa9254083df29d06c556b0653c
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.1 (terminus.zytor.com [127.0.0.1]); Sun, 12 Jan 2014 10:32:42 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  6dbc8ca97b7737fa9254083df29d06c556b0653c
Gitweb:     http://git.kernel.org/tip/6dbc8ca97b7737fa9254083df29d06c556b0653c
Author:     Arnaldo Carvalho de Melo <acme@redhat.com>
AuthorDate: Wed, 18 Dec 2013 18:16:18 -0300
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Thu, 19 Dec 2013 11:34:37 -0300

perf report: Introduce helpers for processing callchains

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
index 9a20c9e..8424053 100644
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
 
