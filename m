Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753051AbaDXIY0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Apr 2014 04:24:26 -0400
Received: from lgeamrelo01.lge.com ([156.147.1.125]:38609 "EHLO
	lgeamrelo01.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752710AbaDXIYK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Apr 2014 04:24:10 -0400
X-Original-SENDERIP: 10.177.220.181
X-Original-MAILFROM: namhyung@kernel.org
From: Namhyung Kim <namhyung@kernel.org>
To: Arnaldo Carvalho de Melo <acme@kernel.org>, Jiri Olsa <jolsa@redhat.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Ingo Molnar <mingo@kernel.org>,
        Paul Mackerras <paulus@samba.org>, Namhyung Kim <namhyung.kim@lge.com>,
        Namhyung Kim <namhyung@kernel.org>,
        LKML <linux-kernel@vger.kernel.org>, David Ahern <dsahern@gmail.com>,
        Andi Kleen <andi@firstfloor.org>
Subject: [PATCH 03/11] perf hists: Move column length calculation out of hists__inc_stats()
Date: Thu, 24 Apr 2014 17:23:55 +0900
Message-Id: <1398327843-31845-4-git-send-email-namhyung@kernel.org>
X-Mailer: git-send-email 1.9.2
In-Reply-To: <1398327843-31845-1-git-send-email-namhyung@kernel.org>
References: <1398327843-31845-1-git-send-email-namhyung@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

It's not the part of logic of hists__inc_stats() so it'd be better to
move it out of the function.

Signed-off-by: Namhyung Kim <namhyung@kernel.org>
---
 tools/perf/builtin-diff.c | 3 +++
 tools/perf/util/hist.c    | 4 +++-
 2 files changed, 6 insertions(+), 1 deletion(-)

diff --git a/tools/perf/builtin-diff.c b/tools/perf/builtin-diff.c
index 0e46fa1b5ca0..c9cc771f182a 100644
--- a/tools/perf/builtin-diff.c
+++ b/tools/perf/builtin-diff.c
@@ -587,6 +587,9 @@ static void hists__compute_resort(struct hists *hists)
 
 		insert_hist_entry_by_compute(&hists->entries, he, compute);
 		hists__inc_stats(hists, he);
+
+		if (!he->filtered)
+			hists__calc_col_len(hists, he);
 	}
 }
 
diff --git a/tools/perf/util/hist.c b/tools/perf/util/hist.c
index 12d6c1bd761d..f5b388e50265 100644
--- a/tools/perf/util/hist.c
+++ b/tools/perf/util/hist.c
@@ -320,7 +320,6 @@ static struct hist_entry *hist_entry__new(struct hist_entry *template)
 void hists__inc_stats(struct hists *hists, struct hist_entry *h)
 {
 	if (!h->filtered) {
-		hists__calc_col_len(hists, h);
 		hists->nr_non_filtered_entries++;
 		hists->stats.total_non_filtered_period += h->stat.period;
 	}
@@ -687,6 +686,9 @@ void hists__output_resort(struct hists *hists)
 
 		__hists__insert_output_entry(&hists->entries, n, min_callchain_hits);
 		hists__inc_stats(hists, n);
+
+		if (!n->filtered)
+			hists__calc_col_len(hists, n);
 	}
 }
 
-- 
1.9.2

