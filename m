Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752286AbaEWKEk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 May 2014 06:04:40 -0400
Received: from lgeamrelo02.lge.com ([156.147.1.126]:49027 "EHLO
	lgeamrelo02.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751506AbaEWKEf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 May 2014 06:04:35 -0400
X-Original-SENDERIP: 10.177.220.181
X-Original-MAILFROM: namhyung@kernel.org
From: Namhyung Kim <namhyung@kernel.org>
To: Arnaldo Carvalho de Melo <acme@kernel.org>, Jiri Olsa <jolsa@redhat.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Ingo Molnar <mingo@kernel.org>,
        Paul Mackerras <paulus@samba.org>, Namhyung Kim <namhyung.kim@lge.com>,
        Namhyung Kim <namhyung@kernel.org>,
        LKML <linux-kernel@vger.kernel.org>, David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Andi Kleen <andi@firstfloor.org>, Arun Sharma <asharma@fb.com>,
        Rodrigo Campos <rodrigo@sdfg.com.ar>
Subject: [PATCH 02/26] perf hists: Add support for accumulated stat of hist entry
Date: Fri, 23 May 2014 19:03:59 +0900
Message-Id: <1400839463-21933-3-git-send-email-namhyung@kernel.org>
X-Mailer: git-send-email 1.9.2
In-Reply-To: <1400839463-21933-1-git-send-email-namhyung@kernel.org>
References: <1400839463-21933-1-git-send-email-namhyung@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Maintain accumulated stat information in hist_entry->stat_acc if
symbol_conf.cumulate_callchain is set.  Fields in ->stat_acc have same
vaules initially, and will be updated as callchain is processed later.

Tested-by: Arun Sharma <asharma@fb.com>
Tested-by: Rodrigo Campos <rodrigo@sdfg.com.ar>
Acked-by: Jiri Olsa <jolsa@redhat.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Signed-off-by: Namhyung Kim <namhyung@kernel.org>
---
 tools/perf/util/hist.c   | 28 ++++++++++++++++++++++++++--
 tools/perf/util/sort.h   |  1 +
 tools/perf/util/symbol.h |  1 +
 3 files changed, 28 insertions(+), 2 deletions(-)

diff --git a/tools/perf/util/hist.c b/tools/perf/util/hist.c
index 61cd2569dc2a..f231255116b0 100644
--- a/tools/perf/util/hist.c
+++ b/tools/perf/util/hist.c
@@ -232,6 +232,8 @@ static bool hists__decay_entry(struct hists *hists, struct hist_entry *he)
 		return true;
 
 	he_stat__decay(&he->stat);
+	if (symbol_conf.cumulate_callchain)
+		he_stat__decay(he->stat_acc);
 
 	diff = prev_period - he->stat.period;
 
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
@@ -359,6 +376,8 @@ static struct hist_entry *add_hist_entry(struct hists *hists,
 
 		if (!cmp) {
 			he_stat__add_period(&he->stat, period, weight);
+			if (symbol_conf.cumulate_callchain)
+				he_stat__add_period(he->stat_acc, period, weight);
 
 			/*
 			 * This mem info was allocated from sample__resolve_mem
@@ -394,6 +413,8 @@ static struct hist_entry *add_hist_entry(struct hists *hists,
 	rb_insert_color(&he->rb_node_in, hists->entries_in);
 out:
 	he_stat__add_cpumode_period(&he->stat, al->cpumode, period);
+	if (symbol_conf.cumulate_callchain)
+		he_stat__add_cpumode_period(he->stat_acc, al->cpumode, period);
 	return he;
 }
 
@@ -772,6 +793,7 @@ void hist_entry__free(struct hist_entry *he)
 {
 	zfree(&he->branch_info);
 	zfree(&he->mem_info);
+	zfree(&he->stat_acc);
 	free_srcline(he->srcline);
 	free(he);
 }
@@ -797,6 +819,8 @@ static bool hists__collapse_insert_entry(struct hists *hists __maybe_unused,
 
 		if (!cmp) {
 			he_stat__add_stat(&iter->stat, &he->stat);
+			if (symbol_conf.cumulate_callchain)
+				he_stat__add_stat(iter->stat_acc, he->stat_acc);
 
 			if (symbol_conf.use_callchain) {
 				callchain_cursor_reset(&callchain_cursor);
diff --git a/tools/perf/util/sort.h b/tools/perf/util/sort.h
index 5f38d925e92f..c9ffa031becd 100644
--- a/tools/perf/util/sort.h
+++ b/tools/perf/util/sort.h
@@ -82,6 +82,7 @@ struct hist_entry {
 		struct list_head head;
 	} pairs;
 	struct he_stat		stat;
+	struct he_stat		*stat_acc;
 	struct map_symbol	ms;
 	struct thread		*thread;
 	struct comm		*comm;
diff --git a/tools/perf/util/symbol.h b/tools/perf/util/symbol.h
index 33ede53fa6b9..615c752dd767 100644
--- a/tools/perf/util/symbol.h
+++ b/tools/perf/util/symbol.h
@@ -109,6 +109,7 @@ struct symbol_conf {
 			show_nr_samples,
 			show_total_period,
 			use_callchain,
+			cumulate_callchain,
 			exclude_other,
 			show_cpu_utilization,
 			initialized,
-- 
1.9.2

