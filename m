Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965185AbaFCSgY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jun 2014 14:36:24 -0400
Received: from terminus.zytor.com ([198.137.202.10]:44988 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933373AbaFCSgV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jun 2014 14:36:21 -0400
Date: Tue, 3 Jun 2014 11:36:07 -0700
From: tip-bot for Namhyung Kim <tipbot@zytor.com>
Message-ID: <tip-e4cf6f886f3158061fb589df9ed452f9b30f67f1@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        jolsa@kernel.org, namhyung@kernel.org, fweisbec@gmail.com,
        tglx@linutronix.de, asharma@fb.com
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        jolsa@kernel.org, namhyung@kernel.org, fweisbec@gmail.com,
        tglx@linutronix.de, asharma@fb.com
In-Reply-To: <1401335910-16832-25-git-send-email-namhyung@kernel.org>
References: <1401335910-16832-25-git-send-email-namhyung@kernel.org>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf ui/gtk: Fix callchain display
Git-Commit-ID: e4cf6f886f3158061fb589df9ed452f9b30f67f1
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

Commit-ID:  e4cf6f886f3158061fb589df9ed452f9b30f67f1
Gitweb:     http://git.kernel.org/tip/e4cf6f886f3158061fb589df9ed452f9b30f67f1
Author:     Namhyung Kim <namhyung@kernel.org>
AuthorDate: Fri, 23 May 2014 18:49:33 +0900
Committer:  Jiri Olsa <jolsa@kernel.org>
CommitDate: Sun, 1 Jun 2014 14:35:09 +0200

perf ui/gtk: Fix callchain display

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
