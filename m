Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753227AbaBXIJj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Feb 2014 03:09:39 -0500
Received: from LGEMRELSE6Q.lge.com ([156.147.1.121]:45661 "EHLO
	lgemrelse6q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752312AbaBXIJc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Feb 2014 03:09:32 -0500
X-Original-SENDERIP: 10.177.220.181
X-Original-MAILFROM: namhyung@kernel.org
From: Namhyung Kim <namhyung@kernel.org>
To: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Ingo Molnar <mingo@kernel.org>,
        Paul Mackerras <paulus@samba.org>, Namhyung Kim <namhyung.kim@lge.com>,
        Namhyung Kim <namhyung@kernel.org>,
        LKML <linux-kernel@vger.kernel.org>, Jiri Olsa <jolsa@redhat.com>,
        David Ahern <dsahern@gmail.com>, Andi Kleen <andi@firstfloor.org>
Subject: [PATCH 1/8] perf tools: Count periods of filtered entries separately
Date: Mon, 24 Feb 2014 17:09:21 +0900
Message-Id: <1393229368-31412-2-git-send-email-namhyung@kernel.org>
X-Mailer: git-send-email 1.7.11.7
In-Reply-To: <1393229368-31412-1-git-send-email-namhyung@kernel.org>
References: <1393229368-31412-1-git-send-email-namhyung@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Currently if a sample was filtered by command line option, it just
dropped.  But this affects final output in that the percentage can be
different since the filtered entries were not included to the total.

But user might want to see the original percentages when filter
applied so add new total_filtered_period filed to hists->stats in
order to be controlled by user later.  It doesn't change the current
behavior yet.

Signed-off-by: Namhyung Kim <namhyung@kernel.org>
---
 tools/perf/builtin-report.c |  2 +-
 tools/perf/util/event.c     | 22 ++++++++++------------
 tools/perf/util/hist.c      | 10 ++--------
 tools/perf/util/hist.h      | 10 ++++++++++
 tools/perf/util/symbol.h    |  2 +-
 5 files changed, 24 insertions(+), 22 deletions(-)

diff --git a/tools/perf/builtin-report.c b/tools/perf/builtin-report.c
index d882b6f96411..5f7f1a332186 100644
--- a/tools/perf/builtin-report.c
+++ b/tools/perf/builtin-report.c
@@ -223,7 +223,7 @@ static int process_sample_event(struct perf_tool *tool,
 		return -1;
 	}
 
-	if (al.filtered || (rep->hide_unresolved && al.sym == NULL))
+	if (rep->hide_unresolved && al.sym == NULL)
 		return 0;
 
 	if (rep->cpu_list && !test_bit(sample->cpu, rep->cpu_bitmap))
diff --git a/tools/perf/util/event.c b/tools/perf/util/event.c
index b0f3ca850e9e..21aa8c6248ee 100644
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
@@ -661,7 +662,7 @@ void thread__find_addr_map(struct thread *thread,
 	al->thread = thread;
 	al->addr = addr;
 	al->cpumode = cpumode;
-	al->filtered = false;
+	al->filtered = 0;
 
 	if (machine == NULL) {
 		al->map = NULL;
@@ -687,11 +688,11 @@ void thread__find_addr_map(struct thread *thread,
 		if ((cpumode == PERF_RECORD_MISC_GUEST_USER ||
 			cpumode == PERF_RECORD_MISC_GUEST_KERNEL) &&
 			!perf_guest)
-			al->filtered = true;
+			al->filtered |= (1 << HIST_FILTER__GUEST);
 		if ((cpumode == PERF_RECORD_MISC_USER ||
 			cpumode == PERF_RECORD_MISC_KERNEL) &&
 			!perf_host)
-			al->filtered = true;
+			al->filtered |= (1 << HIST_FILTER__HOST);
 
 		return;
 	}
@@ -748,9 +749,6 @@ int perf_event__preprocess_sample(const union perf_event *event,
 	if (thread == NULL)
 		return -1;
 
-	if (thread__is_filtered(thread))
-		goto out_filtered;
-
 	dump_printf(" ... thread: %s:%d\n", thread__comm_str(thread), thread->tid);
 	/*
 	 * Have we already created the kernel maps for this machine?
@@ -765,6 +763,10 @@ int perf_event__preprocess_sample(const union perf_event *event,
 
 	thread__find_addr_map(thread, machine, cpumode, MAP__FUNCTION,
 			      sample->ip, al);
+
+	if (thread__is_filtered(thread))
+		al->filtered |= (1 << HIST_FILTER__THREAD);
+
 	dump_printf(" ...... dso: %s\n",
 		    al->map ? al->map->dso->long_name :
 			al->level == 'H' ? "[hypervisor]" : "<not found>");
@@ -780,7 +782,7 @@ int perf_event__preprocess_sample(const union perf_event *event,
 			       (dso->short_name != dso->long_name &&
 				strlist__has_entry(symbol_conf.dso_list,
 						   dso->long_name)))))
-			goto out_filtered;
+			al->filtered |= (1 << HIST_FILTER__DSO);
 
 		al->sym = map__find_symbol(al->map, al->addr,
 					   machine->symbol_filter);
@@ -789,11 +791,7 @@ int perf_event__preprocess_sample(const union perf_event *event,
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
index 0466efa71140..d0c40897c955 100644
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
@@ -330,6 +323,7 @@ void hists__inc_nr_entries(struct hists *hists, struct hist_entry *h)
 		hists__calc_col_len(hists, h);
 		++hists->nr_entries;
 		hists->stats.total_period += h->stat.period;
+		hists->stats.total_filtered_period += h->stat.period;
 	}
 }
 
@@ -429,7 +423,7 @@ struct hist_entry *__hists__add_entry(struct hists *hists,
 			.weight = weight,
 		},
 		.parent = sym_parent,
-		.filtered = symbol__parent_filter(sym_parent),
+		.filtered = symbol__parent_filter(sym_parent) | al->filtered,
 		.hists	= hists,
 		.branch_info = bi,
 		.mem_info = mi,
diff --git a/tools/perf/util/hist.h b/tools/perf/util/hist.h
index a59743fa3ef7..bdfd821e2435 100644
--- a/tools/perf/util/hist.h
+++ b/tools/perf/util/hist.h
@@ -14,6 +14,15 @@ struct hist_entry;
 struct addr_location;
 struct symbol;
 
+enum hist_filter {
+	HIST_FILTER__DSO,
+	HIST_FILTER__THREAD,
+	HIST_FILTER__PARENT,
+	HIST_FILTER__SYMBOL,
+	HIST_FILTER__GUEST,
+	HIST_FILTER__HOST,
+};
+
 /*
  * The kernel collects the number of events it couldn't send in a stretch and
  * when possible sends this number in a PERF_RECORD_LOST event. The number of
@@ -28,6 +37,7 @@ struct symbol;
  */
 struct events_stats {
 	u64 total_period;
+	u64 total_filtered_period;
 	u64 total_lost;
 	u64 total_invalid_chains;
 	u32 nr_events[PERF_RECORD_HEADER_MAX];
diff --git a/tools/perf/util/symbol.h b/tools/perf/util/symbol.h
index 2553ae04b788..501e4e722e8e 100644
--- a/tools/perf/util/symbol.h
+++ b/tools/perf/util/symbol.h
@@ -186,7 +186,7 @@ struct addr_location {
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

