Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756556Ab3AYKuV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jan 2013 05:50:21 -0500
Received: from terminus.zytor.com ([198.137.202.10]:40990 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755130Ab3AYKuT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jan 2013 05:50:19 -0500
Date: Fri, 25 Jan 2013 02:49:42 -0800
From: tip-bot for Namhyung Kim <namhyung.kim@lge.com>
Message-ID: <tip-66f97ed3ac44c24958171bbc5cc04896147752b7@git.kernel.org>
Cc: acme@redhat.com, linux-kernel@vger.kernel.org, eranian@google.com,
        paulus@samba.org, hpa@zytor.com, mingo@kernel.org,
        a.p.zijlstra@chello.nl, namhyung.kim@lge.com, namhyung@kernel.org,
        jolsa@redhat.com, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, paulus@samba.org,
        eranian@google.com, linux-kernel@vger.kernel.org, acme@redhat.com,
        a.p.zijlstra@chello.nl, namhyung.kim@lge.com, tglx@linutronix.de,
        namhyung@kernel.org, jolsa@redhat.com
In-Reply-To: <1355128197-18193-4-git-send-email-namhyung@kernel.org>
References: <1355128197-18193-4-git-send-email-namhyung@kernel.org>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf diff:
  Use internal rb tree for compute resort
Git-Commit-ID: 66f97ed3ac44c24958171bbc5cc04896147752b7
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.7 (terminus.zytor.com [127.0.0.1]); Fri, 25 Jan 2013 02:49:48 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  66f97ed3ac44c24958171bbc5cc04896147752b7
Gitweb:     http://git.kernel.org/tip/66f97ed3ac44c24958171bbc5cc04896147752b7
Author:     Namhyung Kim <namhyung.kim@lge.com>
AuthorDate: Mon, 10 Dec 2012 17:29:56 +0900
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Thu, 24 Jan 2013 16:40:06 -0300

perf diff: Use internal rb tree for compute resort

There's no reason to run hists_compute_resort() using output tree.
Convert it to use internal tree so that it can remove unnecessary
_output_resort.

Signed-off-by: Namhyung Kim <namhyung@kernel.org>
Acked-by: Jiri Olsa <jolsa@redhat.com>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Stephane Eranian <eranian@google.com>
Link: http://lkml.kernel.org/r/1355128197-18193-4-git-send-email-namhyung@kernel.org
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/builtin-diff.c | 31 +++++++++++++++++++++----------
 tools/perf/util/hist.c    |  2 +-
 tools/perf/util/hist.h    |  1 +
 3 files changed, 23 insertions(+), 11 deletions(-)

diff --git a/tools/perf/builtin-diff.c b/tools/perf/builtin-diff.c
index 8b896f5..4af0b58 100644
--- a/tools/perf/builtin-diff.c
+++ b/tools/perf/builtin-diff.c
@@ -414,19 +414,30 @@ static void insert_hist_entry_by_compute(struct rb_root *root,
 
 static void hists__compute_resort(struct hists *hists)
 {
-	struct rb_root tmp = RB_ROOT;
-	struct rb_node *next = rb_first(&hists->entries);
+	struct rb_root *root;
+	struct rb_node *next;
+
+	if (sort__need_collapse)
+		root = &hists->entries_collapsed;
+	else
+		root = hists->entries_in;
+
+	hists->entries = RB_ROOT;
+	next = rb_first(root);
+
+	hists->nr_entries = 0;
+	hists->stats.total_period = 0;
+	hists__reset_col_len(hists);
 
 	while (next != NULL) {
-		struct hist_entry *he = rb_entry(next, struct hist_entry, rb_node);
+		struct hist_entry *he;
 
-		next = rb_next(&he->rb_node);
+		he = rb_entry(next, struct hist_entry, rb_node_in);
+		next = rb_next(&he->rb_node_in);
 
-		rb_erase(&he->rb_node, &hists->entries);
-		insert_hist_entry_by_compute(&tmp, he, compute);
+		insert_hist_entry_by_compute(&hists->entries, he, compute);
+		hists__inc_nr_entries(hists, he);
 	}
-
-	hists->entries = tmp;
 }
 
 static void hists__process(struct hists *old, struct hists *new)
@@ -438,11 +449,11 @@ static void hists__process(struct hists *old, struct hists *new)
 	else
 		hists__link(new, old);
 
-	hists__output_resort(new);
-
 	if (sort_compute) {
 		hists__precompute(new);
 		hists__compute_resort(new);
+	} else {
+		hists__output_resort(new);
 	}
 
 	hists__fprintf(new, true, 0, 0, stdout);
diff --git a/tools/perf/util/hist.c b/tools/perf/util/hist.c
index 8ff3c2f..37179af 100644
--- a/tools/perf/util/hist.c
+++ b/tools/perf/util/hist.c
@@ -251,7 +251,7 @@ static struct hist_entry *hist_entry__new(struct hist_entry *template)
 	return he;
 }
 
-static void hists__inc_nr_entries(struct hists *hists, struct hist_entry *h)
+void hists__inc_nr_entries(struct hists *hists, struct hist_entry *h)
 {
 	if (!h->filtered) {
 		hists__calc_col_len(hists, h);
diff --git a/tools/perf/util/hist.h b/tools/perf/util/hist.h
index 5b3b007..d3664ab 100644
--- a/tools/perf/util/hist.h
+++ b/tools/perf/util/hist.h
@@ -96,6 +96,7 @@ void hists__decay_entries_threaded(struct hists *hists, bool zap_user,
 				   bool zap_kernel);
 void hists__output_recalc_col_len(struct hists *hists, int max_rows);
 
+void hists__inc_nr_entries(struct hists *hists, struct hist_entry *h);
 void hists__inc_nr_events(struct hists *self, u32 type);
 size_t hists__fprintf_nr_events(struct hists *self, FILE *fp);
 
