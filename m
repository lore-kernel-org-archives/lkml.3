Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758332AbaDXPpk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Apr 2014 11:45:40 -0400
Received: from mx1.redhat.com ([209.132.183.28]:44241 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758137AbaDXPk4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Apr 2014 11:40:56 -0400
From: Jiri Olsa <jolsa@kernel.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org, Namhyung Kim <namhyung@kernel.org>,
        Jiri Olsa <jolsa@kernel.org>
Subject: [PATCH 03/11] perf hists: Move column length calculation out of hists__inc_stats()
Date: Thu, 24 Apr 2014 17:40:37 +0200
Message-Id: <1398354045-16505-4-git-send-email-jolsa@kernel.org>
In-Reply-To: <1398354045-16505-1-git-send-email-jolsa@kernel.org>
References: <1398354045-16505-1-git-send-email-jolsa@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Namhyung Kim <namhyung@kernel.org>

It's not the part of logic of hists__inc_stats() so it'd be better to
move it out of the function.

Signed-off-by: Namhyung Kim <namhyung@kernel.org>
Link: http://lkml.kernel.org/r/1398327843-31845-4-git-send-email-namhyung@kernel.org
Signed-off-by: Jiri Olsa <jolsa@kernel.org>
---
 tools/perf/builtin-diff.c | 3 +++
 tools/perf/util/hist.c    | 4 +++-
 2 files changed, 6 insertions(+), 1 deletion(-)

diff --git a/tools/perf/builtin-diff.c b/tools/perf/builtin-diff.c
index 0e46fa1..c9cc771 100644
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
index 12d6c1b..f5b388e 100644
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
1.8.3.1

