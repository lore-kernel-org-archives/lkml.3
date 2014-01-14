Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753134AbaANEoS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Jan 2014 23:44:18 -0500
Received: from LGEMRELSE1Q.lge.com ([156.147.1.111]:54417 "EHLO
	LGEMRELSE1Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752591AbaANEnW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Jan 2014 23:43:22 -0500
X-AuditID: 9c93016f-b7b1aae000000f15-6d-52d4c068a530
From: Namhyung Kim <namhyung@kernel.org>
To: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Paul Mackerras <paulus@samba.org>,
        Ingo Molnar <mingo@kernel.org>, Namhyung Kim <namhyung.kim@lge.com>,
        LKML <linux-kernel@vger.kernel.org>, Jiri Olsa <jolsa@redhat.com>,
        David Ahern <dsahern@gmail.com>
Subject: [PATCH 2/5] perf ui/tui: Add support for showing relative percentage
Date: Tue, 14 Jan 2014 13:43:16 +0900
Message-Id: <1389674599-28227-3-git-send-email-namhyung@kernel.org>
X-Mailer: git-send-email 1.7.11.7
In-Reply-To: <1389674599-28227-1-git-send-email-namhyung@kernel.org>
References: <1389674599-28227-1-git-send-email-namhyung@kernel.org>
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When filtering by thread, dso or symbol on TUI it also update total
period so that the output shows different result than no filter - the
percentage changed to relative to filtered entries only.  Sometimes
(always?)  this is not desired since users might expect same results
with filter.

So change this behavior depends on symbol_conf.filter_relative value.

Signed-off-by: Namhyung Kim <namhyung@kernel.org>
---
 tools/perf/util/hist.c | 15 +++++++++++----
 1 file changed, 11 insertions(+), 4 deletions(-)

diff --git a/tools/perf/util/hist.c b/tools/perf/util/hist.c
index 2d81f3aefad0..58c799d9b689 100644
--- a/tools/perf/util/hist.c
+++ b/tools/perf/util/hist.c
@@ -696,10 +696,11 @@ static void hists__remove_entry_filter(struct hists *hists, struct hist_entry *h
 		return;
 
 	++hists->nr_entries;
+	if (symbol_conf.filter_relative)
+		hists->stats.total_period += h->stat.period;
 	if (h->ms.unfolded)
 		hists->nr_entries += h->nr_rows;
 	h->row_offset = 0;
-	hists->stats.total_period += h->stat.period;
 	hists->stats.nr_events[PERF_RECORD_SAMPLE] += h->stat.nr_events;
 
 	hists__calc_col_len(hists, h);
@@ -722,7 +723,9 @@ void hists__filter_by_dso(struct hists *hists)
 {
 	struct rb_node *nd;
 
-	hists->nr_entries = hists->stats.total_period = 0;
+	hists->nr_entries = 0;
+	if (symbol_conf.filter_relative)
+		hists->stats.total_period = 0;
 	hists->stats.nr_events[PERF_RECORD_SAMPLE] = 0;
 	hists__reset_col_len(hists);
 
@@ -755,7 +758,9 @@ void hists__filter_by_thread(struct hists *hists)
 {
 	struct rb_node *nd;
 
-	hists->nr_entries = hists->stats.total_period = 0;
+	hists->nr_entries = 0;
+	if (symbol_conf.filter_relative)
+		hists->stats.total_period = 0;
 	hists->stats.nr_events[PERF_RECORD_SAMPLE] = 0;
 	hists__reset_col_len(hists);
 
@@ -786,7 +791,9 @@ void hists__filter_by_symbol(struct hists *hists)
 {
 	struct rb_node *nd;
 
-	hists->nr_entries = hists->stats.total_period = 0;
+	hists->nr_entries = 0;
+	if (symbol_conf.filter_relative)
+		hists->stats.total_period = 0;
 	hists->stats.nr_events[PERF_RECORD_SAMPLE] = 0;
 	hists__reset_col_len(hists);
 
-- 
1.7.11.7

