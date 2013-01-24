Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755410Ab3AXSvq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jan 2013 13:51:46 -0500
Received: from terminus.zytor.com ([198.137.202.10]:32911 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750975Ab3AXSvn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jan 2013 13:51:43 -0500
Date: Thu, 24 Jan 2013 10:51:22 -0800
From: tip-bot for Jiri Olsa <jolsa@redhat.com>
Message-ID: <tip-05472daa4d8ab88a071bfcaa3bb47473e4071848@git.kernel.org>
Cc: acme@redhat.com, linux-kernel@vger.kernel.org, paulus@samba.org,
        hpa@zytor.com, mingo@kernel.org, a.p.zijlstra@chello.nl,
        namhyung@kernel.org, jolsa@redhat.com, fweisbec@gmail.com,
        tglx@linutronix.de, cjashfor@linux.vnet.ibm.com, mingo@elte.hu
Reply-To: mingo@kernel.org, hpa@zytor.com, paulus@samba.org,
        linux-kernel@vger.kernel.org, acme@redhat.com, a.p.zijlstra@chello.nl,
        namhyung@kernel.org, jolsa@redhat.com, fweisbec@gmail.com,
        tglx@linutronix.de, cjashfor@linux.vnet.ibm.com, mingo@elte.hu
In-Reply-To: <1354110769-2998-6-git-send-email-jolsa@redhat.com>
References: <1354110769-2998-6-git-send-email-jolsa@redhat.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf diff:
  Change compute methods to work with pair directly
Git-Commit-ID: 05472daa4d8ab88a071bfcaa3bb47473e4071848
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.7 (terminus.zytor.com [127.0.0.1]); Thu, 24 Jan 2013 10:51:28 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  05472daa4d8ab88a071bfcaa3bb47473e4071848
Gitweb:     http://git.kernel.org/tip/05472daa4d8ab88a071bfcaa3bb47473e4071848
Author:     Jiri Olsa <jolsa@redhat.com>
AuthorDate: Wed, 28 Nov 2012 14:52:40 +0100
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Sun, 9 Dec 2012 08:46:06 -0300

perf diff: Change compute methods to work with pair directly

Changing compute methods to operate over hist entry and its pair
directly. This makes the code more obvious and readable, instead of all
time checking for pair being != NULL.

Signed-off-by: Jiri Olsa <jolsa@redhat.com>
Acked-by: Namhyung Kim <namhyung@kernel.org>
Cc: Corey Ashford <cjashfor@linux.vnet.ibm.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Link: http://lkml.kernel.org/r/1354110769-2998-6-git-send-email-jolsa@redhat.com
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/builtin-diff.c | 38 +++++++++++++++++---------------------
 tools/perf/ui/hist.c      | 40 +++++++++++++++++++++++++---------------
 tools/perf/util/hist.h    |  7 ++++---
 3 files changed, 46 insertions(+), 39 deletions(-)

diff --git a/tools/perf/builtin-diff.c b/tools/perf/builtin-diff.c
index 9fbbc01..342085a 100644
--- a/tools/perf/builtin-diff.c
+++ b/tools/perf/builtin-diff.c
@@ -146,47 +146,40 @@ static int setup_compute(const struct option *opt, const char *str,
 	return -EINVAL;
 }
 
-static double get_period_percent(struct hist_entry *he, u64 period)
+double perf_diff__period_percent(struct hist_entry *he, u64 period)
 {
 	u64 total = he->hists->stats.total_period;
 	return (period * 100.0) / total;
 }
 
-double perf_diff__compute_delta(struct hist_entry *he)
+double perf_diff__compute_delta(struct hist_entry *he, struct hist_entry *pair)
 {
-	struct hist_entry *pair = hist_entry__next_pair(he);
-	double new_percent = get_period_percent(he, he->stat.period);
-	double old_percent = pair ? get_period_percent(pair, pair->stat.period) : 0.0;
+	double new_percent = perf_diff__period_percent(he, he->stat.period);
+	double old_percent = perf_diff__period_percent(pair, pair->stat.period);
 
 	he->diff.period_ratio_delta = new_percent - old_percent;
 	he->diff.computed = true;
 	return he->diff.period_ratio_delta;
 }
 
-double perf_diff__compute_ratio(struct hist_entry *he)
+double perf_diff__compute_ratio(struct hist_entry *he, struct hist_entry *pair)
 {
-	struct hist_entry *pair = hist_entry__next_pair(he);
 	double new_period = he->stat.period;
-	double old_period = pair ? pair->stat.period : 0;
+	double old_period = pair->stat.period;
 
 	he->diff.computed = true;
-	he->diff.period_ratio = pair ? (new_period / old_period) : 0;
+	he->diff.period_ratio = new_period / old_period;
 	return he->diff.period_ratio;
 }
 
-s64 perf_diff__compute_wdiff(struct hist_entry *he)
+s64 perf_diff__compute_wdiff(struct hist_entry *he, struct hist_entry *pair)
 {
-	struct hist_entry *pair = hist_entry__next_pair(he);
 	u64 new_period = he->stat.period;
-	u64 old_period = pair ? pair->stat.period : 0;
+	u64 old_period = pair->stat.period;
 
 	he->diff.computed = true;
-
-	if (!pair)
-		he->diff.wdiff = 0;
-	else
-		he->diff.wdiff = new_period * compute_wdiff_w2 -
-				 old_period * compute_wdiff_w1;
+	he->diff.wdiff = new_period * compute_wdiff_w2 -
+			 old_period * compute_wdiff_w1;
 
 	return he->diff.wdiff;
 }
@@ -385,18 +378,21 @@ static void hists__precompute(struct hists *hists)
 
 	while (next != NULL) {
 		struct hist_entry *he = rb_entry(next, struct hist_entry, rb_node);
+		struct hist_entry *pair = hist_entry__next_pair(he);
 
 		next = rb_next(&he->rb_node);
+		if (!pair)
+			continue;
 
 		switch (compute) {
 		case COMPUTE_DELTA:
-			perf_diff__compute_delta(he);
+			perf_diff__compute_delta(he, pair);
 			break;
 		case COMPUTE_RATIO:
-			perf_diff__compute_ratio(he);
+			perf_diff__compute_ratio(he, pair);
 			break;
 		case COMPUTE_WEIGHTED_DIFF:
-			perf_diff__compute_wdiff(he);
+			perf_diff__compute_wdiff(he, pair);
 			break;
 		default:
 			BUG_ON(1);
diff --git a/tools/perf/ui/hist.c b/tools/perf/ui/hist.c
index 6e639b5..108e5ed 100644
--- a/tools/perf/ui/hist.c
+++ b/tools/perf/ui/hist.c
@@ -268,14 +268,18 @@ static int hpp__width_delta(struct perf_hpp *hpp __maybe_unused)
 
 static int hpp__entry_delta(struct perf_hpp *hpp, struct hist_entry *he)
 {
+	struct hist_entry *pair = hist_entry__next_pair(he);
 	const char *fmt = symbol_conf.field_sep ? "%s" : "%7.7s";
 	char buf[32] = " ";
-	double diff;
+	double diff = 0.0;
 
-	if (he->diff.computed)
-		diff = he->diff.period_ratio_delta;
-	else
-		diff = perf_diff__compute_delta(he);
+	if (pair) {
+		if (he->diff.computed)
+			diff = he->diff.period_ratio_delta;
+		else
+			diff = perf_diff__compute_delta(he, pair);
+	} else
+		diff = perf_diff__period_percent(he, he->stat.period);
 
 	if (fabs(diff) >= 0.01)
 		scnprintf(buf, sizeof(buf), "%+4.2F%%", diff);
@@ -297,14 +301,17 @@ static int hpp__width_ratio(struct perf_hpp *hpp __maybe_unused)
 
 static int hpp__entry_ratio(struct perf_hpp *hpp, struct hist_entry *he)
 {
+	struct hist_entry *pair = hist_entry__next_pair(he);
 	const char *fmt = symbol_conf.field_sep ? "%s" : "%14s";
 	char buf[32] = " ";
-	double ratio;
+	double ratio = 0.0;
 
-	if (he->diff.computed)
-		ratio = he->diff.period_ratio;
-	else
-		ratio = perf_diff__compute_ratio(he);
+	if (pair) {
+		if (he->diff.computed)
+			ratio = he->diff.period_ratio;
+		else
+			ratio = perf_diff__compute_ratio(he, pair);
+	}
 
 	if (ratio > 0.0)
 		scnprintf(buf, sizeof(buf), "%+14.6F", ratio);
@@ -326,14 +333,17 @@ static int hpp__width_wdiff(struct perf_hpp *hpp __maybe_unused)
 
 static int hpp__entry_wdiff(struct perf_hpp *hpp, struct hist_entry *he)
 {
+	struct hist_entry *pair = hist_entry__next_pair(he);
 	const char *fmt = symbol_conf.field_sep ? "%s" : "%14s";
 	char buf[32] = " ";
-	s64 wdiff;
+	s64 wdiff = 0;
 
-	if (he->diff.computed)
-		wdiff = he->diff.wdiff;
-	else
-		wdiff = perf_diff__compute_wdiff(he);
+	if (pair) {
+		if (he->diff.computed)
+			wdiff = he->diff.wdiff;
+		else
+			wdiff = perf_diff__compute_wdiff(he, pair);
+	}
 
 	if (wdiff != 0)
 		scnprintf(buf, sizeof(buf), "%14ld", wdiff);
diff --git a/tools/perf/util/hist.h b/tools/perf/util/hist.h
index a935a60..235503a 100644
--- a/tools/perf/util/hist.h
+++ b/tools/perf/util/hist.h
@@ -226,8 +226,9 @@ int perf_evlist__gtk_browse_hists(struct perf_evlist *evlist __maybe_unused,
 
 unsigned int hists__sort_list_width(struct hists *self);
 
-double perf_diff__compute_delta(struct hist_entry *he);
-double perf_diff__compute_ratio(struct hist_entry *he);
-s64 perf_diff__compute_wdiff(struct hist_entry *he);
+double perf_diff__compute_delta(struct hist_entry *he, struct hist_entry *pair);
+double perf_diff__compute_ratio(struct hist_entry *he, struct hist_entry *pair);
+s64 perf_diff__compute_wdiff(struct hist_entry *he, struct hist_entry *pair);
 int perf_diff__formula(char *buf, size_t size, struct hist_entry *he);
+double perf_diff__period_percent(struct hist_entry *he, u64 period);
 #endif	/* __PERF_HIST_H */
