Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756676AbaAHIw5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Jan 2014 03:52:57 -0500
Received: from lgeamrelo01.lge.com ([156.147.1.125]:63883 "EHLO
	LGEAMRELO01.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755839AbaAHIql (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Jan 2014 03:46:41 -0500
X-AuditID: 9c93017d-b7b66ae000006a2a-f9-52cd106d82bd
From: Namhyung Kim <namhyung@kernel.org>
To: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Paul Mackerras <paulus@samba.org>,
        Ingo Molnar <mingo@kernel.org>, Namhyung Kim <namhyung.kim@lge.com>,
        LKML <linux-kernel@vger.kernel.org>, Arun Sharma <asharma@fb.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Jiri Olsa <jolsa@redhat.com>,
        Rodrigo Campos <rodrigo@sdfg.com.ar>
Subject: [PATCH 05/28] perf hists: Convert hist entry functions to use struct he_stat
Date: Wed,  8 Jan 2014 17:46:10 +0900
Message-Id: <1389170793-21926-6-git-send-email-namhyung@kernel.org>
X-Mailer: git-send-email 1.7.11.7
In-Reply-To: <1389170793-21926-1-git-send-email-namhyung@kernel.org>
References: <1389170793-21926-1-git-send-email-namhyung@kernel.org>
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

hist_entry__add_cpumode_period() and hist_entry__decay() are dealing
with hist_entry's stat fields only.  So make them use the struct
directly.

Acked-by: Jiri Olsa <jolsa@redhat.com>
Cc: Arun Sharma <asharma@fb.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Signed-off-by: Namhyung Kim <namhyung@kernel.org>
---
 tools/perf/util/hist.c | 22 +++++++++++-----------
 1 file changed, 11 insertions(+), 11 deletions(-)

diff --git a/tools/perf/util/hist.c b/tools/perf/util/hist.c
index 266d9b238856..ca3b3b707983 100644
--- a/tools/perf/util/hist.c
+++ b/tools/perf/util/hist.c
@@ -174,21 +174,21 @@ void hists__output_recalc_col_len(struct hists *hists, int max_rows)
 	}
 }
 
-static void hist_entry__add_cpumode_period(struct hist_entry *he,
-					   unsigned int cpumode, u64 period)
+static void he_stat__add_cpumode_period(struct he_stat *he_stat,
+					unsigned int cpumode, u64 period)
 {
 	switch (cpumode) {
 	case PERF_RECORD_MISC_KERNEL:
-		he->stat.period_sys += period;
+		he_stat->period_sys += period;
 		break;
 	case PERF_RECORD_MISC_USER:
-		he->stat.period_us += period;
+		he_stat->period_us += period;
 		break;
 	case PERF_RECORD_MISC_GUEST_KERNEL:
-		he->stat.period_guest_sys += period;
+		he_stat->period_guest_sys += period;
 		break;
 	case PERF_RECORD_MISC_GUEST_USER:
-		he->stat.period_guest_us += period;
+		he_stat->period_guest_us += period;
 		break;
 	default:
 		break;
@@ -215,10 +215,10 @@ static void he_stat__add_stat(struct he_stat *dest, struct he_stat *src)
 	dest->weight		+= src->weight;
 }
 
-static void hist_entry__decay(struct hist_entry *he)
+static void he_stat__decay(struct he_stat *he_stat)
 {
-	he->stat.period = (he->stat.period * 7) / 8;
-	he->stat.nr_events = (he->stat.nr_events * 7) / 8;
+	he_stat->period = (he_stat->period * 7) / 8;
+	he_stat->nr_events = (he_stat->nr_events * 7) / 8;
 	/* XXX need decay for weight too? */
 }
 
@@ -229,7 +229,7 @@ static bool hists__decay_entry(struct hists *hists, struct hist_entry *he)
 	if (prev_period == 0)
 		return true;
 
-	hist_entry__decay(he);
+	he_stat__decay(&he->stat);
 
 	if (!he->filtered)
 		hists->stats.total_period -= prev_period - he->stat.period;
@@ -395,7 +395,7 @@ static struct hist_entry *add_hist_entry(struct hists *hists,
 	rb_link_node(&he->rb_node_in, parent, p);
 	rb_insert_color(&he->rb_node_in, hists->entries_in);
 out:
-	hist_entry__add_cpumode_period(he, al->cpumode, period);
+	he_stat__add_cpumode_period(&he->stat, al->cpumode, period);
 	return he;
 }
 
-- 
1.7.11.7

