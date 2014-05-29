Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756029AbaE2D7t (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 May 2014 23:59:49 -0400
Received: from LGEMRELSE6Q.lge.com ([156.147.1.121]:53573 "EHLO
	lgemrelse6q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755920AbaE2D6i (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 May 2014 23:58:38 -0400
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
        Rodrigo Campos <rodrigo@sdfg.com.ar>, Don Zickus <dzickus@redhat.com>
Subject: [PATCH 24/27] perf ui/gtk: Fix callchain display
Date: Thu, 29 May 2014 12:58:27 +0900
Message-Id: <1401335910-16832-25-git-send-email-namhyung@kernel.org>
X-Mailer: git-send-email 1.9.2
In-Reply-To: <1401335910-16832-1-git-send-email-namhyung@kernel.org>
References: <1401335910-16832-1-git-send-email-namhyung@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

With current output field change, GTK browser cannot display callchain
information correctly since it couldn't determine where the symbol
column is.  This is a problem - just for now I changed to use the last
column since it'll work for most cases.

Also it has a same problem of the percentage as stdio code.

Cc: Arun Sharma <asharma@fb.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Signed-off-by: Namhyung Kim <namhyung@kernel.org>
---
 tools/perf/ui/gtk/hists.c | 10 +++++++++-
 1 file changed, 9 insertions(+), 1 deletion(-)

diff --git a/tools/perf/ui/gtk/hists.c b/tools/perf/ui/gtk/hists.c
index 03d6812d25dd..6ca60e482cdc 100644
--- a/tools/perf/ui/gtk/hists.c
+++ b/tools/perf/ui/gtk/hists.c
@@ -198,6 +198,13 @@ static void perf_gtk__show_hists(GtkWidget *window, struct hists *hists,
 		if (perf_hpp__should_skip(fmt))
 			continue;
 
+		/*
+		 * XXX no way to determine where symcol column is..
+		 *     Just use last column for now.
+		 */
+		if (perf_hpp__is_sort_entry(fmt))
+			sym_col = col_idx;
+
 		fmt->header(fmt, &hpp, hists_to_evsel(hists));
 
 		gtk_tree_view_insert_column_with_attributes(GTK_TREE_VIEW(view),
@@ -253,7 +260,8 @@ static void perf_gtk__show_hists(GtkWidget *window, struct hists *hists,
 
 		if (symbol_conf.use_callchain && sort__has_sym) {
 			if (callchain_param.mode == CHAIN_GRAPH_REL)
-				total = h->stat.period;
+				total = symbol_conf.cumulate_callchain ?
+					h->stat_acc->period : h->stat.period;
 
 			perf_gtk__add_callchain(&h->sorted_chain, store, &iter,
 						sym_col, total);
-- 
1.9.2

