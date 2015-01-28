Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755782AbbA1VYd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Jan 2015 16:24:33 -0500
Received: from terminus.zytor.com ([198.137.202.10]:40980 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933466AbbA1Utx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Jan 2015 15:49:53 -0500
Date: Wed, 28 Jan 2015 07:06:51 -0800
From: tip-bot for Namhyung Kim <tipbot@zytor.com>
Message-ID: <tip-38259a170dfab4865968b592ae90b373e9f7d5b5@git.kernel.org>
Cc: jolsa@redhat.com, jolsa@kernel.org, tglx@linutronix.de, acme@redhat.com,
        mingo@kernel.org, namhyung@kernel.org, linux-kernel@vger.kernel.org,
        a.p.zijlstra@chello.nl, hpa@zytor.com
Reply-To: linux-kernel@vger.kernel.org, a.p.zijlstra@chello.nl,
        namhyung@kernel.org, hpa@zytor.com, jolsa@kernel.org,
        tglx@linutronix.de, jolsa@redhat.com, mingo@kernel.org,
        acme@redhat.com
In-Reply-To: <1419656793-32756-2-git-send-email-namhyung@kernel.org>
References: <1419656793-32756-2-git-send-email-namhyung@kernel.org>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf diff: Get rid of hists__compute_resort()
Git-Commit-ID: 38259a170dfab4865968b592ae90b373e9f7d5b5
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

Commit-ID:  38259a170dfab4865968b592ae90b373e9f7d5b5
Gitweb:     http://git.kernel.org/tip/38259a170dfab4865968b592ae90b373e9f7d5b5
Author:     Namhyung Kim <namhyung@kernel.org>
AuthorDate: Sat, 27 Dec 2014 14:06:30 +0900
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Wed, 21 Jan 2015 13:24:33 -0300

perf diff: Get rid of hists__compute_resort()

The hists__compute_resort() is to sort output fields based on the
given field/criteria.  This was done without the sort list but as we
added the field to the sort list, we can do it with normal
hists__output_resort() using the ->sort callback.

Signed-off-by: Namhyung Kim <namhyung@kernel.org>
Acked-by: Jiri Olsa <jolsa@kernel.org>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Link: http://lkml.kernel.org/r/1419656793-32756-2-git-send-email-namhyung@kernel.org
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/builtin-diff.c | 59 +++--------------------------------------------
 1 file changed, 3 insertions(+), 56 deletions(-)

diff --git a/tools/perf/builtin-diff.c b/tools/perf/builtin-diff.c
index 318ab9c..72c718e 100644
--- a/tools/perf/builtin-diff.c
+++ b/tools/perf/builtin-diff.c
@@ -581,68 +581,15 @@ hist_entry__cmp_wdiff(struct hist_entry *left, struct hist_entry *right)
 	return hist_entry__cmp_compute(right, left, COMPUTE_WEIGHTED_DIFF);
 }
 
-static void insert_hist_entry_by_compute(struct rb_root *root,
-					 struct hist_entry *he,
-					 int c)
-{
-	struct rb_node **p = &root->rb_node;
-	struct rb_node *parent = NULL;
-	struct hist_entry *iter;
-
-	while (*p != NULL) {
-		parent = *p;
-		iter = rb_entry(parent, struct hist_entry, rb_node);
-		if (hist_entry__cmp_compute(he, iter, c) < 0)
-			p = &(*p)->rb_left;
-		else
-			p = &(*p)->rb_right;
-	}
-
-	rb_link_node(&he->rb_node, parent, p);
-	rb_insert_color(&he->rb_node, root);
-}
-
-static void hists__compute_resort(struct hists *hists)
-{
-	struct rb_root *root;
-	struct rb_node *next;
-
-	if (sort__need_collapse)
-		root = &hists->entries_collapsed;
-	else
-		root = hists->entries_in;
-
-	hists->entries = RB_ROOT;
-	next = rb_first(root);
-
-	hists__reset_stats(hists);
-	hists__reset_col_len(hists);
-
-	while (next != NULL) {
-		struct hist_entry *he;
-
-		he = rb_entry(next, struct hist_entry, rb_node_in);
-		next = rb_next(&he->rb_node_in);
-
-		insert_hist_entry_by_compute(&hists->entries, he, compute);
-		hists__inc_stats(hists, he);
-
-		if (!he->filtered)
-			hists__calc_col_len(hists, he);
-	}
-}
-
 static void hists__process(struct hists *hists)
 {
 	if (show_baseline_only)
 		hists__baseline_only(hists);
 
-	if (sort_compute) {
+	if (sort_compute)
 		hists__precompute(hists);
-		hists__compute_resort(hists);
-	} else {
-		hists__output_resort(hists, NULL);
-	}
+
+	hists__output_resort(hists, NULL);
 
 	hists__fprintf(hists, true, 0, 0, 0, stdout);
 }
