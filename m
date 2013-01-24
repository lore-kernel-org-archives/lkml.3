Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755327Ab3AXSwx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jan 2013 13:52:53 -0500
Received: from terminus.zytor.com ([198.137.202.10]:32927 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754744Ab3AXSwr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jan 2013 13:52:47 -0500
Date: Thu, 24 Jan 2013 10:52:26 -0800
From: tip-bot for Jiri Olsa <jolsa@redhat.com>
Message-ID: <tip-f4c8bae1920c459b7b9c12363d11e8a588862e42@git.kernel.org>
Cc: acme@redhat.com, linux-kernel@vger.kernel.org, paulus@samba.org,
        hpa@zytor.com, mingo@kernel.org, a.p.zijlstra@chello.nl,
        namhyung@kernel.org, jolsa@redhat.com, fweisbec@gmail.com,
        tglx@linutronix.de, cjashfor@linux.vnet.ibm.com, mingo@elte.hu
Reply-To: mingo@kernel.org, hpa@zytor.com, paulus@samba.org,
        linux-kernel@vger.kernel.org, acme@redhat.com, a.p.zijlstra@chello.nl,
        namhyung@kernel.org, jolsa@redhat.com, fweisbec@gmail.com,
        tglx@linutronix.de, cjashfor@linux.vnet.ibm.com, mingo@elte.hu
In-Reply-To: <1354110769-2998-7-git-send-email-jolsa@redhat.com>
References: <1354110769-2998-7-git-send-email-jolsa@redhat.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf diff:
  Change formula methods to work with pair directly
Git-Commit-ID: f4c8bae1920c459b7b9c12363d11e8a588862e42
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.7 (terminus.zytor.com [127.0.0.1]); Thu, 24 Jan 2013 10:52:31 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  f4c8bae1920c459b7b9c12363d11e8a588862e42
Gitweb:     http://git.kernel.org/tip/f4c8bae1920c459b7b9c12363d11e8a588862e42
Author:     Jiri Olsa <jolsa@redhat.com>
AuthorDate: Wed, 28 Nov 2012 14:52:41 +0100
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Sun, 9 Dec 2012 08:46:07 -0300

perf diff: Change formula methods to work with pair directly

Changing formula methods to operate over hist entry and its pair
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
Link: http://lkml.kernel.org/r/1354110769-2998-7-git-send-email-jolsa@redhat.com
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/builtin-diff.c | 35 +++++++++++++----------------------
 tools/perf/ui/hist.c      |  5 ++++-
 tools/perf/util/hist.h    |  3 ++-
 3 files changed, 19 insertions(+), 24 deletions(-)

diff --git a/tools/perf/builtin-diff.c b/tools/perf/builtin-diff.c
index 342085a..d869029 100644
--- a/tools/perf/builtin-diff.c
+++ b/tools/perf/builtin-diff.c
@@ -184,13 +184,9 @@ s64 perf_diff__compute_wdiff(struct hist_entry *he, struct hist_entry *pair)
 	return he->diff.wdiff;
 }
 
-static int formula_delta(struct hist_entry *he, char *buf, size_t size)
+static int formula_delta(struct hist_entry *he, struct hist_entry *pair,
+			 char *buf, size_t size)
 {
-	struct hist_entry *pair = hist_entry__next_pair(he);
-
-	if (!pair)
-		return -1;
-
 	return scnprintf(buf, size,
 			 "(%" PRIu64 " * 100 / %" PRIu64 ") - "
 			 "(%" PRIu64 " * 100 / %" PRIu64 ")",
@@ -198,41 +194,36 @@ static int formula_delta(struct hist_entry *he, char *buf, size_t size)
 			  pair->stat.period, pair->hists->stats.total_period);
 }
 
-static int formula_ratio(struct hist_entry *he, char *buf, size_t size)
+static int formula_ratio(struct hist_entry *he, struct hist_entry *pair,
+			 char *buf, size_t size)
 {
-	struct hist_entry *pair = hist_entry__next_pair(he);
 	double new_period = he->stat.period;
-	double old_period = pair ? pair->stat.period : 0;
-
-	if (!pair)
-		return -1;
+	double old_period = pair->stat.period;
 
 	return scnprintf(buf, size, "%.0F / %.0F", new_period, old_period);
 }
 
-static int formula_wdiff(struct hist_entry *he, char *buf, size_t size)
+static int formula_wdiff(struct hist_entry *he, struct hist_entry *pair,
+			 char *buf, size_t size)
 {
-	struct hist_entry *pair = hist_entry__next_pair(he);
 	u64 new_period = he->stat.period;
-	u64 old_period = pair ? pair->stat.period : 0;
-
-	if (!pair)
-		return -1;
+	u64 old_period = pair->stat.period;
 
 	return scnprintf(buf, size,
 		  "(%" PRIu64 " * " "%" PRId64 ") - (%" PRIu64 " * " "%" PRId64 ")",
 		  new_period, compute_wdiff_w2, old_period, compute_wdiff_w1);
 }
 
-int perf_diff__formula(char *buf, size_t size, struct hist_entry *he)
+int perf_diff__formula(struct hist_entry *he, struct hist_entry *pair,
+		       char *buf, size_t size)
 {
 	switch (compute) {
 	case COMPUTE_DELTA:
-		return formula_delta(he, buf, size);
+		return formula_delta(he, pair, buf, size);
 	case COMPUTE_RATIO:
-		return formula_ratio(he, buf, size);
+		return formula_ratio(he, pair, buf, size);
 	case COMPUTE_WEIGHTED_DIFF:
-		return formula_wdiff(he, buf, size);
+		return formula_wdiff(he, pair, buf, size);
 	default:
 		BUG_ON(1);
 	}
diff --git a/tools/perf/ui/hist.c b/tools/perf/ui/hist.c
index 108e5ed..1785bab 100644
--- a/tools/perf/ui/hist.c
+++ b/tools/perf/ui/hist.c
@@ -389,10 +389,13 @@ static int hpp__width_formula(struct perf_hpp *hpp __maybe_unused)
 
 static int hpp__entry_formula(struct perf_hpp *hpp, struct hist_entry *he)
 {
+	struct hist_entry *pair = hist_entry__next_pair(he);
 	const char *fmt = symbol_conf.field_sep ? "%s" : "%-70s";
 	char buf[96] = " ";
 
-	perf_diff__formula(buf, sizeof(buf), he);
+	if (pair)
+		perf_diff__formula(he, pair, buf, sizeof(buf));
+
 	return scnprintf(hpp->buf, hpp->size, fmt, buf);
 }
 
diff --git a/tools/perf/util/hist.h b/tools/perf/util/hist.h
index 235503a..c1b2fad 100644
--- a/tools/perf/util/hist.h
+++ b/tools/perf/util/hist.h
@@ -229,6 +229,7 @@ unsigned int hists__sort_list_width(struct hists *self);
 double perf_diff__compute_delta(struct hist_entry *he, struct hist_entry *pair);
 double perf_diff__compute_ratio(struct hist_entry *he, struct hist_entry *pair);
 s64 perf_diff__compute_wdiff(struct hist_entry *he, struct hist_entry *pair);
-int perf_diff__formula(char *buf, size_t size, struct hist_entry *he);
+int perf_diff__formula(struct hist_entry *he, struct hist_entry *pair,
+		       char *buf, size_t size);
 double perf_diff__period_percent(struct hist_entry *he, u64 period);
 #endif	/* __PERF_HIST_H */
