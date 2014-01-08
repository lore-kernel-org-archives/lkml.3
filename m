Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755172AbaAHIq4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Jan 2014 03:46:56 -0500
Received: from lgeamrelo01.lge.com ([156.147.1.125]:63883 "EHLO
	LGEAMRELO01.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755347AbaAHIqi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Jan 2014 03:46:38 -0500
X-AuditID: 9c93017d-b7b66ae000006a2a-ed-52cd106c9d15
From: Namhyung Kim <namhyung@kernel.org>
To: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Paul Mackerras <paulus@samba.org>,
        Ingo Molnar <mingo@kernel.org>, Namhyung Kim <namhyung.kim@lge.com>,
        LKML <linux-kernel@vger.kernel.org>, Arun Sharma <asharma@fb.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Jiri Olsa <jolsa@redhat.com>,
        Rodrigo Campos <rodrigo@sdfg.com.ar>
Subject: [PATCH 01/28] perf tools: Insert filtered entries to hists also
Date: Wed,  8 Jan 2014 17:46:06 +0900
Message-Id: <1389170793-21926-2-git-send-email-namhyung@kernel.org>
X-Mailer: git-send-email 1.7.11.7
In-Reply-To: <1389170793-21926-1-git-send-email-namhyung@kernel.org>
References: <1389170793-21926-1-git-send-email-namhyung@kernel.org>
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Currently if a sample was filtered by command line option, it just
dropped.  But this affects final output in that the percentage can be
different since the filtered entries were not included to the total.

For example, if an original output looked like below:

  $ perf report --stdio -s comm

  # Overhead  Command
  # ........  .......
  #
      74.19%      cc1
       7.61%      gcc
       6.11%       as
       4.35%       sh
       4.14%     make
       1.13%   fixdep

If we gave a filter, the output changed like below:

  $ perf report --stdio -s comm -c gcc,as

  # Overhead  Command
  # ........  .......
  #
      55.49%      gcc
      44.51%       as

But user might want to see this:

  $ perf report --stdio -s comm -c gcc,as

  # Overhead  Command
  # ........  .......
  #
       7.61%      gcc
       6.11%       as

Signed-off-by: Namhyung Kim <namhyung@kernel.org>
---
 tools/perf/builtin-report.c |  2 +-
 tools/perf/util/event.c     | 18 ++++++++----------
 tools/perf/util/hist.c      | 11 ++---------
 tools/perf/util/hist.h      |  7 +++++++
 tools/perf/util/symbol.h    |  2 +-
 5 files changed, 19 insertions(+), 21 deletions(-)

diff --git a/tools/perf/builtin-report.c b/tools/perf/builtin-report.c
index bf8dd2e893e4..6bfcb83db8ff 100644
--- a/tools/perf/builtin-report.c
+++ b/tools/perf/builtin-report.c
@@ -247,7 +247,7 @@ static int process_sample_event(struct perf_tool *tool,
 		return -1;
 	}
 
-	if (al.filtered || (rep->hide_unresolved && al.sym == NULL))
+	if (rep->hide_unresolved && al.sym == NULL)
 		return 0;
 
 	if (rep->cpu_list && !test_bit(sample->cpu, rep->cpu_bitmap))
diff --git a/tools/perf/util/event.c b/tools/perf/util/event.c
index 45a76c69a9ed..2c6a583bc2e9 100644
--- a/tools/perf/util/event.c
+++ b/tools/perf/util/event.c
@@ -3,6 +3,7 @@
 #include "debug.h"
 #include "machine.h"
 #include "sort.h"
+#include "hist.h"
 #include "string.h"
 #include "strlist.h"
 #include "thread.h"
@@ -663,7 +664,7 @@ void thread__find_addr_map(struct thread *thread,
 	al->thread = thread;
 	al->addr = addr;
 	al->cpumode = cpumode;
-	al->filtered = false;
+	al->filtered = 0;
 
 	if (machine == NULL) {
 		al->map = NULL;
@@ -750,9 +751,6 @@ int perf_event__preprocess_sample(const union perf_event *event,
 	if (thread == NULL)
 		return -1;
 
-	if (thread__is_filtered(thread))
-		goto out_filtered;
-
 	dump_printf(" ... thread: %s:%d\n", thread__comm_str(thread), thread->tid);
 	/*
 	 * Have we already created the kernel maps for this machine?
@@ -767,6 +765,10 @@ int perf_event__preprocess_sample(const union perf_event *event,
 
 	thread__find_addr_map(thread, machine, cpumode, MAP__FUNCTION,
 			      sample->ip, al);
+
+	if (thread__is_filtered(thread))
+		al->filtered |= (1 << HIST_FILTER__THREAD);
+
 	dump_printf(" ...... dso: %s\n",
 		    al->map ? al->map->dso->long_name :
 			al->level == 'H' ? "[hypervisor]" : "<not found>");
@@ -782,7 +784,7 @@ int perf_event__preprocess_sample(const union perf_event *event,
 			       (dso->short_name != dso->long_name &&
 				strlist__has_entry(symbol_conf.dso_list,
 						   dso->long_name)))))
-			goto out_filtered;
+			al->filtered |= (1 << HIST_FILTER__DSO);
 
 		al->sym = map__find_symbol(al->map, al->addr,
 					   machine->symbol_filter);
@@ -791,11 +793,7 @@ int perf_event__preprocess_sample(const union perf_event *event,
 	if (symbol_conf.sym_list &&
 		(!al->sym || !strlist__has_entry(symbol_conf.sym_list,
 						al->sym->name)))
-		goto out_filtered;
-
-	return 0;
+		al->filtered |= (1 << HIST_FILTER__SYMBOL);
 
-out_filtered:
-	al->filtered = true;
 	return 0;
 }
diff --git a/tools/perf/util/hist.c b/tools/perf/util/hist.c
index 4ed3e883240d..64df6b96e7ea 100644
--- a/tools/perf/util/hist.c
+++ b/tools/perf/util/hist.c
@@ -13,13 +13,6 @@ static bool hists__filter_entry_by_thread(struct hists *hists,
 static bool hists__filter_entry_by_symbol(struct hists *hists,
 					  struct hist_entry *he);
 
-enum hist_filter {
-	HIST_FILTER__DSO,
-	HIST_FILTER__THREAD,
-	HIST_FILTER__PARENT,
-	HIST_FILTER__SYMBOL,
-};
-
 struct callchain_param	callchain_param = {
 	.mode	= CHAIN_GRAPH_REL,
 	.min_percent = 0.5,
@@ -329,8 +322,8 @@ void hists__inc_nr_entries(struct hists *hists, struct hist_entry *h)
 	if (!h->filtered) {
 		hists__calc_col_len(hists, h);
 		++hists->nr_entries;
-		hists->stats.total_period += h->stat.period;
 	}
+	hists->stats.total_period += h->stat.period;
 }
 
 static u8 symbol__parent_filter(const struct symbol *parent)
@@ -429,7 +422,7 @@ struct hist_entry *__hists__add_entry(struct hists *hists,
 			.weight = weight,
 		},
 		.parent = sym_parent,
-		.filtered = symbol__parent_filter(sym_parent),
+		.filtered = symbol__parent_filter(sym_parent) | al->filtered,
 		.hists	= hists,
 		.branch_info = bi,
 		.mem_info = mi,
diff --git a/tools/perf/util/hist.h b/tools/perf/util/hist.h
index a59743fa3ef7..7d1d973d9a39 100644
--- a/tools/perf/util/hist.h
+++ b/tools/perf/util/hist.h
@@ -14,6 +14,13 @@ struct hist_entry;
 struct addr_location;
 struct symbol;
 
+enum hist_filter {
+	HIST_FILTER__DSO,
+	HIST_FILTER__THREAD,
+	HIST_FILTER__PARENT,
+	HIST_FILTER__SYMBOL,
+};
+
 /*
  * The kernel collects the number of events it couldn't send in a stretch and
  * when possible sends this number in a PERF_RECORD_LOST event. The number of
diff --git a/tools/perf/util/symbol.h b/tools/perf/util/symbol.h
index cbd680361806..e42b410c3f11 100644
--- a/tools/perf/util/symbol.h
+++ b/tools/perf/util/symbol.h
@@ -170,7 +170,7 @@ struct addr_location {
 	struct symbol *sym;
 	u64	      addr;
 	char	      level;
-	bool	      filtered;
+	u8	      filtered;
 	u8	      cpumode;
 	s32	      cpu;
 };
-- 
1.7.11.7

