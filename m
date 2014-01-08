Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756655AbaAHIwo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Jan 2014 03:52:44 -0500
Received: from lgeamrelo01.lge.com ([156.147.1.125]:48061 "EHLO
	LGEAMRELO01.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755841AbaAHIql (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Jan 2014 03:46:41 -0500
X-AuditID: 9c93017d-b7b66ae000006a2a-02-52cd106ea260
From: Namhyung Kim <namhyung@kernel.org>
To: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Paul Mackerras <paulus@samba.org>,
        Ingo Molnar <mingo@kernel.org>, Namhyung Kim <namhyung.kim@lge.com>,
        LKML <linux-kernel@vger.kernel.org>, Arun Sharma <asharma@fb.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Jiri Olsa <jolsa@redhat.com>,
        Rodrigo Campos <rodrigo@sdfg.com.ar>
Subject: [PATCH 06/28] perf hists: Add support for accumulated stat of hist entry
Date: Wed,  8 Jan 2014 17:46:11 +0900
Message-Id: <1389170793-21926-7-git-send-email-namhyung@kernel.org>
X-Mailer: git-send-email 1.7.11.7
In-Reply-To: <1389170793-21926-1-git-send-email-namhyung@kernel.org>
References: <1389170793-21926-1-git-send-email-namhyung@kernel.org>
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Maintain accumulated stat information in hist_entry->stat_acc if
symbol_conf.cumulate_callchain is set.  Fields in ->stat_acc have same
vaules initially, and will be updated as callchain is processed later.

Cc: Arun Sharma <asharma@fb.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Signed-off-by: Namhyung Kim <namhyung@kernel.org>
---
 tools/perf/util/hist.c   | 28 ++++++++++++++++++++++++++--
 tools/perf/util/sort.h   |  1 +
 tools/perf/util/symbol.h |  1 +
 3 files changed, 28 insertions(+), 2 deletions(-)

diff --git a/tools/perf/util/hist.c b/tools/perf/util/hist.c
index ca3b3b707983..50de02c478b4 100644
--- a/tools/perf/util/hist.c
+++ b/tools/perf/util/hist.c
@@ -230,6 +230,8 @@ static bool hists__decay_entry(struct hists *hists, struct hist_entry *he)
 		return true;
 
 	he_stat__decay(&he->stat);
+	if (symbol_conf.cumulate_callchain)
+		he_stat__decay(he->stat_acc);
 
 	if (!he->filtered)
 		hists->stats.total_period -= prev_period - he->stat.period;
@@ -271,12 +273,26 @@ void hists__decay_entries(struct hists *hists, bool zap_user, bool zap_kernel)
 
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
 
@@ -288,6 +304,7 @@ static struct hist_entry *hist_entry__new(struct hist_entry *template)
 			 */
 			he->branch_info = malloc(sizeof(*he->branch_info));
 			if (he->branch_info == NULL) {
+				free(he->stat_acc);
 				free(he);
 				return NULL;
 			}
@@ -360,6 +377,8 @@ static struct hist_entry *add_hist_entry(struct hists *hists,
 
 		if (!cmp) {
 			he_stat__add_period(&he->stat, period, weight);
+			if (symbol_conf.cumulate_callchain)
+				he_stat__add_period(he->stat_acc, period, weight);
 
 			/*
 			 * This mem info was allocated from machine__resolve_mem
@@ -396,6 +415,8 @@ static struct hist_entry *add_hist_entry(struct hists *hists,
 	rb_insert_color(&he->rb_node_in, hists->entries_in);
 out:
 	he_stat__add_cpumode_period(&he->stat, al->cpumode, period);
+	if (symbol_conf.cumulate_callchain)
+		he_stat__add_cpumode_period(he->stat_acc, al->cpumode, period);
 	return he;
 }
 
@@ -470,6 +491,7 @@ void hist_entry__free(struct hist_entry *he)
 {
 	zfree(&he->branch_info);
 	zfree(&he->mem_info);
+	zfree(&he->stat_acc);
 	free_srcline(he->srcline);
 	free(he);
 }
@@ -495,6 +517,8 @@ static bool hists__collapse_insert_entry(struct hists *hists __maybe_unused,
 
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
index e42b410c3f11..a384fba8e585 100644
--- a/tools/perf/util/symbol.h
+++ b/tools/perf/util/symbol.h
@@ -92,6 +92,7 @@ struct symbol_conf {
 			show_nr_samples,
 			show_total_period,
 			use_callchain,
+			cumulate_callchain,
 			exclude_other,
 			show_cpu_utilization,
 			initialized,
-- 
1.7.11.7

