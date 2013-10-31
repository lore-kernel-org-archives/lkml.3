Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754228Ab3JaG65 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Oct 2013 02:58:57 -0400
Received: from LGEMRELSE7Q.lge.com ([156.147.1.151]:43539 "EHLO
	LGEMRELSE7Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753136Ab3JaG4X (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Oct 2013 02:56:23 -0400
X-AuditID: 9c930197-b7b3eae00000122e-cc-5271ff138f1e
From: Namhyung Kim <namhyung@kernel.org>
To: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Paul Mackerras <paulus@samba.org>,
        Ingo Molnar <mingo@kernel.org>, Namhyung Kim <namhyung.kim@lge.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Stephane Eranian <eranian@google.com>, Jiri Olsa <jolsa@redhat.com>,
        Rodrigo Campos <rodrigo@sdfg.com.ar>, Arun Sharma <asharma@fb.com>
Subject: [PATCH 04/14] perf hists: Add support for accumulated stat of hist entry
Date: Thu, 31 Oct 2013 15:56:06 +0900
Message-Id: <1383202576-28141-5-git-send-email-namhyung@kernel.org>
X-Mailer: git-send-email 1.7.11.7
In-Reply-To: <1383202576-28141-1-git-send-email-namhyung@kernel.org>
References: <1383202576-28141-1-git-send-email-namhyung@kernel.org>
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Namhyung Kim <namhyung.kim@lge.com>

Maintain accumulated stat information in hist_entry->stat_acc if
symbol_conf.cumulate_callchain is set.  Fields in ->stat_acc have same
vaules initially, and will be updated as callchain is processed later.

Cc: Arun Sharma <asharma@fb.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Signed-off-by: Namhyung Kim <namhyung@kernel.org>
---
 tools/perf/ui/stdio/hist.c  |  1 +
 tools/perf/util/callchain.c |  2 ++
 tools/perf/util/callchain.h |  3 ++-
 tools/perf/util/hist.c      | 18 ++++++++++++++++++
 tools/perf/util/sort.h      |  1 +
 5 files changed, 24 insertions(+), 1 deletion(-)

diff --git a/tools/perf/ui/stdio/hist.c b/tools/perf/ui/stdio/hist.c
index 6c152686e837..302f08afd6a2 100644
--- a/tools/perf/ui/stdio/hist.c
+++ b/tools/perf/ui/stdio/hist.c
@@ -283,6 +283,7 @@ static size_t hist_entry_callchain__fprintf(struct hist_entry *he,
 		return callchain__fprintf_flat(fp, &he->sorted_chain, total_samples);
 		break;
 	case CHAIN_NONE:
+	case CHAIN_CUMULATIVE:
 		break;
 	default:
 		pr_err("Bad callchain mode\n");
diff --git a/tools/perf/util/callchain.c b/tools/perf/util/callchain.c
index e3970e3eaacf..c10052c6e73c 100644
--- a/tools/perf/util/callchain.c
+++ b/tools/perf/util/callchain.c
@@ -52,6 +52,7 @@ rb_insert_callchain(struct rb_root *root, struct callchain_node *chain,
 				p = &(*p)->rb_right;
 			break;
 		case CHAIN_NONE:
+		case CHAIN_CUMULATIVE:
 		default:
 			break;
 		}
@@ -162,6 +163,7 @@ int callchain_register_param(struct callchain_param *param)
 		param->sort = sort_chain_flat;
 		break;
 	case CHAIN_NONE:
+	case CHAIN_CUMULATIVE:
 	default:
 		return -1;
 	}
diff --git a/tools/perf/util/callchain.h b/tools/perf/util/callchain.h
index 7bb36022377f..08cf367c2357 100644
--- a/tools/perf/util/callchain.h
+++ b/tools/perf/util/callchain.h
@@ -11,7 +11,8 @@ enum chain_mode {
 	CHAIN_NONE,
 	CHAIN_FLAT,
 	CHAIN_GRAPH_ABS,
-	CHAIN_GRAPH_REL
+	CHAIN_GRAPH_REL,
+	CHAIN_CUMULATIVE,
 };
 
 enum chain_order {
diff --git a/tools/perf/util/hist.c b/tools/perf/util/hist.c
index 3a06b3326f12..c38655dedad3 100644
--- a/tools/perf/util/hist.c
+++ b/tools/perf/util/hist.c
@@ -238,6 +238,8 @@ static bool hists__decay_entry(struct hists *hists, struct hist_entry *he)
 		return true;
 
 	hist_entry__decay(&he->stat);
+	if (callchain_param.mode == CHAIN_CUMULATIVE)
+		hist_entry__decay(he->stat_acc);
 
 	if (!he->filtered)
 		hists->stats.total_period -= prev_period - he->stat.period;
@@ -285,6 +287,15 @@ static struct hist_entry *hist_entry__new(struct hist_entry *template)
 	if (he != NULL) {
 		*he = *template;
 
+		if (callchain_param.mode == CHAIN_CUMULATIVE) {
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
 
@@ -296,6 +307,7 @@ static struct hist_entry *hist_entry__new(struct hist_entry *template)
 			 */
 			he->branch_info = malloc(sizeof(*he->branch_info));
 			if (he->branch_info == NULL) {
+				free(he->stat_acc);
 				free(he);
 				return NULL;
 			}
@@ -368,6 +380,8 @@ static struct hist_entry *add_hist_entry(struct hists *hists,
 
 		if (!cmp) {
 			he_stat__add_period(&he->stat, period, weight);
+			if (callchain_param.mode == CHAIN_CUMULATIVE)
+				he_stat__add_period(he->stat_acc, period, weight);
 
 			/*
 			 * This mem info was allocated from machine__resolve_mem
@@ -404,6 +418,8 @@ static struct hist_entry *add_hist_entry(struct hists *hists,
 	rb_insert_color(&he->rb_node_in, hists->entries_in);
 out:
 	hist_entry__add_cpumode_period(&he->stat, al->cpumode, period);
+	if (callchain_param.mode == CHAIN_CUMULATIVE)
+		hist_entry__add_cpumode_period(he->stat_acc, al->cpumode, period);
 	return he;
 }
 
@@ -502,6 +518,8 @@ static bool hists__collapse_insert_entry(struct hists *hists __maybe_unused,
 
 		if (!cmp) {
 			he_stat__add_stat(&iter->stat, &he->stat);
+			if (callchain_param.mode == CHAIN_CUMULATIVE)
+				he_stat__add_stat(iter->stat_acc, he->stat_acc);
 
 			if (symbol_conf.use_callchain) {
 				callchain_cursor_reset(&callchain_cursor);
diff --git a/tools/perf/util/sort.h b/tools/perf/util/sort.h
index bf4333694d3a..2e2f0f5a1502 100644
--- a/tools/perf/util/sort.h
+++ b/tools/perf/util/sort.h
@@ -82,6 +82,7 @@ struct hist_entry {
 		struct list_head head;
 	} pairs;
 	struct he_stat		stat;
+	struct he_stat		*stat_acc;
 	struct map_symbol	ms;
 	struct thread		*thread;
 	u64			ip;
-- 
1.7.11.7

