Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934046AbaCSNHp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Mar 2014 09:07:45 -0400
Received: from terminus.zytor.com ([198.137.202.10]:34199 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933804AbaCSNHj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Mar 2014 09:07:39 -0400
Date: Wed, 19 Mar 2014 06:06:50 -0700
From: tip-bot for Namhyung Kim <tipbot@zytor.com>
Message-ID: <tip-89hmfgtr9t22sky1lyg7nw7l@git.kernel.org>
Cc: acme@redhat.com, linux-kernel@vger.kernel.org, paulus@samba.org,
        hpa@zytor.com, mingo@kernel.org, andi@firstfloor.org,
        a.p.zijlstra@chello.nl, namhyung.kim@lge.com, namhyung@kernel.org,
        jolsa@redhat.com, dsahern@gmail.com, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, paulus@samba.org,
        linux-kernel@vger.kernel.org, acme@redhat.com, andi@firstfloor.org,
        a.p.zijlstra@chello.nl, namhyung.kim@lge.com, namhyung@kernel.org,
        jolsa@redhat.com, dsahern@gmail.com, tglx@linutronix.de
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf symbols:
  Record the reason for filtering an address_location
Git-Commit-ID: b3cef7f60f17d953545f7069f6407fc24202a64d
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  b3cef7f60f17d953545f7069f6407fc24202a64d
Gitweb:     http://git.kernel.org/tip/b3cef7f60f17d953545f7069f6407fc24202a64d
Author:     Namhyung Kim <namhyung@kernel.org>
AuthorDate: Mon, 17 Mar 2014 16:59:21 -0300
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Tue, 18 Mar 2014 18:16:57 -0300

perf symbols: Record the reason for filtering an address_location

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
index d4991a2..74db256 100644
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
index 3e580be..0da09db 100644
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
index 0466efa..9507f33 100644
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
index 0c76bf9..1f1f513 100644
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
index 5cecd98..d280bf2 100644
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
index 2553ae0..501e4e7 100644
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
