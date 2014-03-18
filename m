Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933327AbaCRV0a (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Mar 2014 17:26:30 -0400
Received: from merlin.infradead.org ([205.233.59.134]:44461 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933232AbaCRV0Z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Mar 2014 17:26:25 -0400
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org, Namhyung Kim <namhyung@kernel.org>,
        Namhyung Kim <namhyung.kim@lge.com>, Andi Kleen <andi@firstfloor.org>,
        David Ahern <dsahern@gmail.com>, Jiri Olsa <jolsa@redhat.com>,
        Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 03/13] perf symbols: Record the reason for filtering an address_location
Date: Tue, 18 Mar 2014 18:25:55 -0300
Message-Id: <1395177965-8879-4-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.8.1.4
In-Reply-To: <1395177965-8879-1-git-send-email-acme@infradead.org>
References: <1395177965-8879-1-git-send-email-acme@infradead.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by merlin.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Namhyung Kim <namhyung@kernel.org>

By turning the addr_location->filtered member from a boolean to a u8
bitmap, reusing (and extending) the hist_filter enum for that.

This patch doesn't change the logic at all, as it keeps the meaning of
al->filtered !0 to mean that the entry _was_ filtered, so no change in
how this value is interpreted needs to be done at this point.

This will be soon used in upcoming patches.

Signed-off-by: Namhyung Kim <namhyung.kim@lge.com>
Acked-by: Jiri Olsa <jolsa@redhat.com>
Cc: Andi Kleen <andi@firstfloor.org>
Cc: David Ahern <dsahern@gmail.com>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Namhyung Kim <namhyung.kim@lge.com>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Link: http://lkml.kernel.org/n/tip-89hmfgtr9t22sky1lyg7nw7l@git.kernel.org
[ yanked this out of a previous patch ]
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/builtin-timechart.c |  2 +-
 tools/perf/util/event.c        | 20 +++++++++++++-------
 tools/perf/util/hist.c         |  7 -------
 tools/perf/util/hist.h         |  9 +++++++++
 tools/perf/util/machine.c      |  2 +-
 tools/perf/util/symbol.h       |  2 +-
 6 files changed, 25 insertions(+), 17 deletions(-)

diff --git a/tools/perf/builtin-timechart.c b/tools/perf/builtin-timechart.c
index d4991a235155..74db2568b867 100644
--- a/tools/perf/builtin-timechart.c
+++ b/tools/perf/builtin-timechart.c
@@ -494,7 +494,7 @@ static const char *cat_backtrace(union perf_event *event,
 			continue;
 		}
 
-		tal.filtered = false;
+		tal.filtered = 0;
 		thread__find_addr_location(al.thread, machine, cpumode,
 					   MAP__FUNCTION, ip, &tal);
 
diff --git a/tools/perf/util/event.c b/tools/perf/util/event.c
index 3e580be0f6fb..0da09db5f9f6 100644
--- a/tools/perf/util/event.c
+++ b/tools/perf/util/event.c
@@ -1,6 +1,7 @@
 #include <linux/types.h>
 #include "event.h"
 #include "debug.h"
+#include "hist.h"
 #include "machine.h"
 #include "sort.h"
 #include "string.h"
@@ -705,7 +706,7 @@ void thread__find_addr_map(struct thread *thread,
 	al->thread = thread;
 	al->addr = addr;
 	al->cpumode = cpumode;
-	al->filtered = false;
+	al->filtered = 0;
 
 	if (machine == NULL) {
 		al->map = NULL;
@@ -731,11 +732,11 @@ void thread__find_addr_map(struct thread *thread,
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
@@ -792,8 +793,10 @@ int perf_event__preprocess_sample(const union perf_event *event,
 	if (thread == NULL)
 		return -1;
 
-	if (thread__is_filtered(thread))
+	if (thread__is_filtered(thread)) {
+		al->filtered |= (1 << HIST_FILTER__THREAD);
 		goto out_filtered;
+	}
 
 	dump_printf(" ... thread: %s:%d\n", thread__comm_str(thread), thread->tid);
 	/*
@@ -823,8 +826,10 @@ int perf_event__preprocess_sample(const union perf_event *event,
 						  dso->short_name) ||
 			       (dso->short_name != dso->long_name &&
 				strlist__has_entry(symbol_conf.dso_list,
-						   dso->long_name)))))
+						   dso->long_name))))) {
+			al->filtered |= (1 << HIST_FILTER__DSO);
 			goto out_filtered;
+		}
 
 		al->sym = map__find_symbol(al->map, al->addr,
 					   machine->symbol_filter);
@@ -832,12 +837,13 @@ int perf_event__preprocess_sample(const union perf_event *event,
 
 	if (symbol_conf.sym_list &&
 		(!al->sym || !strlist__has_entry(symbol_conf.sym_list,
-						al->sym->name)))
+						al->sym->name))) {
+		al->filtered |= (1 << HIST_FILTER__SYMBOL);
 		goto out_filtered;
+	}
 
 	return 0;
 
 out_filtered:
-	al->filtered = true;
 	return 0;
 }
diff --git a/tools/perf/util/hist.c b/tools/perf/util/hist.c
index 0466efa71140..9507f33b02ff 100644
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
diff --git a/tools/perf/util/hist.h b/tools/perf/util/hist.h
index 0c76bf972736..1f1f513dfe7f 100644
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
diff --git a/tools/perf/util/machine.c b/tools/perf/util/machine.c
index 5cecd98c1bc0..d280bf210183 100644
--- a/tools/perf/util/machine.c
+++ b/tools/perf/util/machine.c
@@ -1312,7 +1312,7 @@ static int machine__resolve_callchain_sample(struct machine *machine,
 			continue;
 		}
 
-		al.filtered = false;
+		al.filtered = 0;
 		thread__find_addr_location(thread, machine, cpumode,
 					   MAP__FUNCTION, ip, &al);
 		if (al.sym != NULL) {
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
1.8.1.4

