Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757763AbaFANc3 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Jun 2014 09:32:29 -0400
Received: from mx1.redhat.com ([209.132.183.28]:23665 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757718AbaFANc0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Jun 2014 09:32:26 -0400
From: Jiri Olsa <jolsa@kernel.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org, Namhyung Kim <namhyung@kernel.org>,
        Arun Sharma <asharma@fb.com>, Frederic Weisbecker <fweisbec@gmail.com>,
        Jiri Olsa <jolsa@kernel.org>
Subject: [PATCH 24/27] perf ui/gtk: Fix callchain display
Date: Sun,  1 Jun 2014 15:31:35 +0200
Message-Id: <1401629498-8726-25-git-send-email-jolsa@kernel.org>
In-Reply-To: <1401629498-8726-1-git-send-email-jolsa@kernel.org>
References: <1401629498-8726-1-git-send-email-jolsa@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Namhyung Kim <namhyung@kernel.org>

With current output field change, GTK browser cannot display callchain
information correctly since it couldn't determine where the symbol
column is.  This is a problem - just for now I changed to use the last
column since it'll work for most cases.

Also it has a same problem of the percentage as stdio code.

Signed-off-by: Namhyung Kim <namhyung@kernel.org>
Cc: Arun Sharma <asharma@fb.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Link: http://lkml.kernel.org/r/1401335910-16832-25-git-send-email-namhyung@kernel.org
Signed-off-by: Jiri Olsa <jolsa@kernel.org>
---
 tools/perf/ui/gtk/hists.c | 10 +++++++++-
 1 file changed, 9 insertions(+), 1 deletion(-)

diff --git a/tools/perf/ui/gtk/hists.c b/tools/perf/ui/gtk/hists.c
index 03d6812..6ca60e4 100644
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
1.8.3.1

