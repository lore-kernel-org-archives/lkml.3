Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755972AbaAHIrR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Jan 2014 03:47:17 -0500
Received: from lgeamrelo01.lge.com ([156.147.1.125]:47900 "EHLO
	LGEAMRELO01.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755781AbaAHIqj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Jan 2014 03:46:39 -0500
X-AuditID: 9c93017d-b7b66ae000006a2a-f3-52cd106ccfaf
From: Namhyung Kim <namhyung@kernel.org>
To: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Paul Mackerras <paulus@samba.org>,
        Ingo Molnar <mingo@kernel.org>, Namhyung Kim <namhyung.kim@lge.com>,
        LKML <linux-kernel@vger.kernel.org>, Arun Sharma <asharma@fb.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Jiri Olsa <jolsa@redhat.com>,
        Rodrigo Campos <rodrigo@sdfg.com.ar>
Subject: [PATCH 02/28] perf tools: Do not update total period of a hists when filtering
Date: Wed,  8 Jan 2014 17:46:07 +0900
Message-Id: <1389170793-21926-3-git-send-email-namhyung@kernel.org>
X-Mailer: git-send-email 1.7.11.7
In-Reply-To: <1389170793-21926-1-git-send-email-namhyung@kernel.org>
References: <1389170793-21926-1-git-send-email-namhyung@kernel.org>
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When filtering by thread, dso or symbol on TUI it also update total
period so that the output shows different result than no filter - the
percentage changed to relative to filtered entries only.  Sometimes
(always?)  this is not desired since users might expect same results
with filter.

Signed-off-by: Namhyung Kim <namhyung@kernel.org>
---
 tools/perf/util/hist.c | 7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

diff --git a/tools/perf/util/hist.c b/tools/perf/util/hist.c
index 64df6b96e7ea..266d9b238856 100644
--- a/tools/perf/util/hist.c
+++ b/tools/perf/util/hist.c
@@ -698,7 +698,6 @@ static void hists__remove_entry_filter(struct hists *hists, struct hist_entry *h
 	if (h->ms.unfolded)
 		hists->nr_entries += h->nr_rows;
 	h->row_offset = 0;
-	hists->stats.total_period += h->stat.period;
 	hists->stats.nr_events[PERF_RECORD_SAMPLE] += h->stat.nr_events;
 
 	hists__calc_col_len(hists, h);
@@ -721,7 +720,7 @@ void hists__filter_by_dso(struct hists *hists)
 {
 	struct rb_node *nd;
 
-	hists->nr_entries = hists->stats.total_period = 0;
+	hists->nr_entries = 0;
 	hists->stats.nr_events[PERF_RECORD_SAMPLE] = 0;
 	hists__reset_col_len(hists);
 
@@ -754,7 +753,7 @@ void hists__filter_by_thread(struct hists *hists)
 {
 	struct rb_node *nd;
 
-	hists->nr_entries = hists->stats.total_period = 0;
+	hists->nr_entries = 0;
 	hists->stats.nr_events[PERF_RECORD_SAMPLE] = 0;
 	hists__reset_col_len(hists);
 
@@ -785,7 +784,7 @@ void hists__filter_by_symbol(struct hists *hists)
 {
 	struct rb_node *nd;
 
-	hists->nr_entries = hists->stats.total_period = 0;
+	hists->nr_entries = 0;
 	hists->stats.nr_events[PERF_RECORD_SAMPLE] = 0;
 	hists__reset_col_len(hists);
 
-- 
1.7.11.7

