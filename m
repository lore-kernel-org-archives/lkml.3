Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752718AbaBGBkg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Feb 2014 20:40:36 -0500
Received: from lgeamrelo01.lge.com ([156.147.1.125]:63046 "EHLO
	LGEAMRELO01.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750774AbaBGBfm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Feb 2014 20:35:42 -0500
X-AuditID: 9c93017d-b7b1fae00000636d-a6-52f4386d2085
From: Namhyung Kim <namhyung@kernel.org>
To: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Ingo Molnar <mingo@kernel.org>,
        Paul Mackerras <paulus@samba.org>, Namhyung Kim <namhyung.kim@lge.com>,
        LKML <linux-kernel@vger.kernel.org>, Arun Sharma <asharma@fb.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Rodrigo Campos <rodrigo@sdfg.com.ar>, Andi Kleen <andi@firstfloor.org>,
        David Ahern <dsahern@gmail.com>
Subject: [PATCH 02/21] perf hists: Add support for accumulated stat of hist entry
Date: Fri,  7 Feb 2014 10:35:04 +0900
Message-Id: <1391736923-30765-3-git-send-email-namhyung@kernel.org>
X-Mailer: git-send-email 1.7.11.7
In-Reply-To: <1391736923-30765-1-git-send-email-namhyung@kernel.org>
References: <1391736923-30765-1-git-send-email-namhyung@kernel.org>
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Maintain accumulated stat information in hist_entry->stat_acc if
symbol_conf.cumulate_callchain is set.  Fields in ->stat_acc have same
vaules initially, and will be updated as callchain is processed later.

Tested-by: Arun Sharma <asharma@fb.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Signed-off-by: Namhyung Kim <namhyung@kernel.org>
---
 tools/perf/util/hist.c   | 28 ++++++++++++++++++++++++++--
 tools/perf/util/sort.h   |  1 +
 tools/perf/util/symbol.h |  1 +
 3 files changed, 28 insertions(+), 2 deletions(-)

diff --git a/tools/perf/util/hist.c b/tools/perf/util/hist.c
index e7a6d9091455..4119a9dd665f 100644
--- a/tools/perf/util/hist.c
+++ b/tools/perf/util/hist.c
@@ -238,6 +238,8 @@ static bool hists__decay_entry(struct hists *hists, struct hist_entry *he)
 		return true;
 
 	he_stat__decay(&he->stat);
+	if (symbol_conf.cumulate_callchain)
+		he_stat__decay(he->stat_acc);
 
 	if (!he->filtered)
 		hists->stats.total_period -= prev_period - he->stat.period;
@@ -279,12 +281,26 @@ void hists__decay_entries(struct hists *hists, bool zap_user, bool zap_kernel)
 
 static struct hist_entry *hist_entry__new(struct hist_entry *template)
 {
-	size_t callchain_size = symbol_conf.use_callchain ? sizeof(struct callchain_root) : 0;
-	struct hist_entry *he = zalloc(sizeof(*he) + callchain_size);
+	size_t callchain_size = 0;
+	struct hist_entry *he;
+
+	if (symbol_conf.use_callchain || symbol_conf.cumulate_callchain)
+		callchain_size = sizeof(struct callchain_root);
+
+	he = zalloc(sizeof(*he) + callchain_size);
 
 	if (he != NULL) {
 		*he = *template;
 
+		if (symbol_conf.cumulate_callchain) {
+			he->stat_acc = malloc(sizeof(he->stat));
+			if (he->stat_acc == NULL) {
+				free(he);
+				return NULL;
+			}
+			memcpy(he->stat_acc, &he->stat, sizeof(he->stat));
+		}
+
 		if (he->ms.map)
 			he->ms.map->referenced = true;
 
@@ -296,6 +312,7 @@ static struct hist_entry *hist_entry__new(struct hist_entry *template)
 			 */
 			he->branch_info = malloc(sizeof(*he->branch_info));
 			if (he->branch_info == NULL) {
+				free(he->stat_acc);
 				free(he);
 				return NULL;
 			}
@@ -368,6 +385,8 @@ static struct hist_entry *add_hist_entry(struct hists *hists,
 
 		if (!cmp) {
 			he_stat__add_period(&he->stat, period, weight);
+			if (symbol_conf.cumulate_callchain)
+				he_stat__add_period(he->stat_acc, period, weight);
 
 			/*
 			 * This mem info was allocated from sample__resolve_mem
@@ -404,6 +423,8 @@ static struct hist_entry *add_hist_entry(struct hists *hists,
 	rb_insert_color(&he->rb_node_in, hists->entries_in);
 out:
 	he_stat__add_cpumode_period(&he->stat, al->cpumode, period);
+	if (symbol_conf.cumulate_callchain)
+		he_stat__add_cpumode_period(he->stat_acc, al->cpumode, period);
 	return he;
 }
 
@@ -775,6 +796,7 @@ void hist_entry__free(struct hist_entry *he)
 {
 	zfree(&he->branch_info);
 	zfree(&he->mem_info);
+	zfree(&he->stat_acc);
 	free_srcline(he->srcline);
 	free(he);
 }
@@ -800,6 +822,8 @@ static bool hists__collapse_insert_entry(struct hists *hists __maybe_unused,
 
 		if (!cmp) {
 			he_stat__add_stat(&iter->stat, &he->stat);
+			if (symbol_conf.cumulate_callchain)
+				he_stat__add_stat(iter->stat_acc, he->stat_acc);
 
 			if (symbol_conf.use_callchain) {
 				callchain_cursor_reset(&callchain_cursor);
diff --git a/tools/perf/util/sort.h b/tools/perf/util/sort.h
index 43e5ff42a609..309f2838a1b4 100644
--- a/tools/perf/util/sort.h
+++ b/tools/perf/util/sort.h
@@ -81,6 +81,7 @@ struct hist_entry {
 		struct list_head head;
 	} pairs;
 	struct he_stat		stat;
+	struct he_stat		*stat_acc;
 	struct map_symbol	ms;
 	struct thread		*thread;
 	struct comm		*comm;
diff --git a/tools/perf/util/symbol.h b/tools/perf/util/symbol.h
index fffe2888a1c7..410d01da1546 100644
--- a/tools/perf/util/symbol.h
+++ b/tools/perf/util/symbol.h
@@ -97,6 +97,7 @@ struct symbol_conf {
 			show_nr_samples,
 			show_total_period,
 			use_callchain,
+			cumulate_callchain,
 			exclude_other,
 			show_cpu_utilization,
 			initialized,
-- 
1.7.11.7

