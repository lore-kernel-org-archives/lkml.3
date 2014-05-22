Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755182AbaEVMYM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 May 2014 08:24:12 -0400
Received: from terminus.zytor.com ([198.137.202.10]:51049 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754626AbaEVMYK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 May 2014 08:24:10 -0400
Date: Thu, 22 May 2014 05:23:58 -0700
From: tip-bot for Namhyung Kim <tipbot@zytor.com>
Message-ID: <tip-4e754e1c7fe02e6b104e61f7e06e9895527e8ad3@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        jolsa@kernel.org, tglx@linutronix.de, namhyung@kernel.org
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        jolsa@kernel.org, tglx@linutronix.de, namhyung@kernel.org
In-Reply-To: <1400480762-22852-20-git-send-email-namhyung@kernel.org>
References: <1400480762-22852-20-git-send-email-namhyung@kernel.org>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf tests: Factor out print_hists_*()
Git-Commit-ID: 4e754e1c7fe02e6b104e61f7e06e9895527e8ad3
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

Commit-ID:  4e754e1c7fe02e6b104e61f7e06e9895527e8ad3
Gitweb:     http://git.kernel.org/tip/4e754e1c7fe02e6b104e61f7e06e9895527e8ad3
Author:     Namhyung Kim <namhyung@kernel.org>
AuthorDate: Mon, 12 May 2014 10:06:18 +0900
Committer:  Jiri Olsa <jolsa@kernel.org>
CommitDate: Wed, 21 May 2014 11:45:37 +0200

perf tests: Factor out print_hists_*()

Those print helper functions can be reused by later hist test cases so
factor them out to a common location.

Signed-off-by: Namhyung Kim <namhyung@kernel.org>
Link: http://lkml.kernel.org/r/1400480762-22852-20-git-send-email-namhyung@kernel.org
Signed-off-by: Jiri Olsa <jolsa@kernel.org>
---
 tools/perf/tests/hists_common.c | 57 +++++++++++++++++++++++++++++++++++++++++
 tools/perf/tests/hists_common.h |  3 +++
 tools/perf/tests/hists_filter.c | 37 ++++----------------------
 tools/perf/tests/hists_link.c   | 29 +--------------------
 4 files changed, 66 insertions(+), 60 deletions(-)

diff --git a/tools/perf/tests/hists_common.c b/tools/perf/tests/hists_common.c
index 44655b3..040a85b 100644
--- a/tools/perf/tests/hists_common.c
+++ b/tools/perf/tests/hists_common.c
@@ -146,3 +146,60 @@ out:
 	machine__delete(machine);
 	return NULL;
 }
+
+void print_hists_in(struct hists *hists)
+{
+	int i = 0;
+	struct rb_root *root;
+	struct rb_node *node;
+
+	if (sort__need_collapse)
+		root = &hists->entries_collapsed;
+	else
+		root = hists->entries_in;
+
+	pr_info("----- %s --------\n", __func__);
+	node = rb_first(root);
+	while (node) {
+		struct hist_entry *he;
+
+		he = rb_entry(node, struct hist_entry, rb_node_in);
+
+		if (!he->filtered) {
+			pr_info("%2d: entry: %-8s [%-8s] %20s: period = %"PRIu64"\n",
+				i, thread__comm_str(he->thread),
+				he->ms.map->dso->short_name,
+				he->ms.sym->name, he->stat.period);
+		}
+
+		i++;
+		node = rb_next(node);
+	}
+}
+
+void print_hists_out(struct hists *hists)
+{
+	int i = 0;
+	struct rb_root *root;
+	struct rb_node *node;
+
+	root = &hists->entries;
+
+	pr_info("----- %s --------\n", __func__);
+	node = rb_first(root);
+	while (node) {
+		struct hist_entry *he;
+
+		he = rb_entry(node, struct hist_entry, rb_node);
+
+		if (!he->filtered) {
+			pr_info("%2d: entry: %-8s [%-8s] %20s: period = %"PRIu64"\n",
+				i, thread__comm_str(he->thread),
+				he->ms.map->dso->short_name,
+				he->ms.sym->name, he->stat.period);
+		}
+
+		i++;
+		node = rb_next(node);
+	}
+}
diff --git a/tools/perf/tests/hists_common.h b/tools/perf/tests/hists_common.h
index 2528b8f..1415ae6 100644
--- a/tools/perf/tests/hists_common.h
+++ b/tools/perf/tests/hists_common.h
@@ -41,4 +41,7 @@ struct machines;
  */
 struct machine *setup_fake_machine(struct machines *machines);
 
+void print_hists_in(struct hists *hists);
+void print_hists_out(struct hists *hists);
+
 #endif /* __PERF_TESTS__HISTS_COMMON_H__ */
diff --git a/tools/perf/tests/hists_filter.c b/tools/perf/tests/hists_filter.c
index 4617a8b..13c8cf4 100644
--- a/tools/perf/tests/hists_filter.c
+++ b/tools/perf/tests/hists_filter.c
@@ -98,33 +98,6 @@ out:
 	return TEST_FAIL;
 }
 
-static void print_hists(struct hists *hists)
-{
-	int i = 0;
-	struct rb_root *root;
-	struct rb_node *node;
-
-	root = &hists->entries;
-
-	pr_info("----- %s --------\n", __func__);
-	node = rb_first(root);
-	while (node) {
-		struct hist_entry *he;
-
-		he = rb_entry(node, struct hist_entry, rb_node);
-
-		if (!he->filtered) {
-			pr_info("%2d: entry: %-8s [%-8s] %20s: period = %"PRIu64"\n",
-				i, thread__comm_str(he->thread),
-				he->ms.map->dso->short_name,
-				he->ms.sym->name, he->stat.period);
-		}
-
-		i++;
-		node = rb_next(node);
-	}
-}
-
 int test__hists_filter(void)
 {
 	int err = TEST_FAIL;
@@ -169,7 +142,7 @@ int test__hists_filter(void)
 
 		if (verbose > 2) {
 			pr_info("Normal histogram\n");
-			print_hists(hists);
+			print_hists_out(hists);
 		}
 
 		TEST_ASSERT_VAL("Invalid nr samples",
@@ -193,7 +166,7 @@ int test__hists_filter(void)
 
 		if (verbose > 2) {
 			pr_info("Histogram for thread filter\n");
-			print_hists(hists);
+			print_hists_out(hists);
 		}
 
 		/* normal stats should be invariant */
@@ -222,7 +195,7 @@ int test__hists_filter(void)
 
 		if (verbose > 2) {
 			pr_info("Histogram for dso filter\n");
-			print_hists(hists);
+			print_hists_out(hists);
 		}
 
 		/* normal stats should be invariant */
@@ -257,7 +230,7 @@ int test__hists_filter(void)
 
 		if (verbose > 2) {
 			pr_info("Histogram for symbol filter\n");
-			print_hists(hists);
+			print_hists_out(hists);
 		}
 
 		/* normal stats should be invariant */
@@ -284,7 +257,7 @@ int test__hists_filter(void)
 
 		if (verbose > 2) {
 			pr_info("Histogram for all filters\n");
-			print_hists(hists);
+			print_hists_out(hists);
 		}
 
 		/* normal stats should be invariant */
diff --git a/tools/perf/tests/hists_link.c b/tools/perf/tests/hists_link.c
index b009bbf..4e783db 100644
--- a/tools/perf/tests/hists_link.c
+++ b/tools/perf/tests/hists_link.c
@@ -268,33 +268,6 @@ static int validate_link(struct hists *leader, struct hists *other)
 	return __validate_link(leader, 0) || __validate_link(other, 1);
 }
 
-static void print_hists(struct hists *hists)
-{
-	int i = 0;
-	struct rb_root *root;
-	struct rb_node *node;
-
-	if (sort__need_collapse)
-		root = &hists->entries_collapsed;
-	else
-		root = hists->entries_in;
-
-	pr_info("----- %s --------\n", __func__);
-	node = rb_first(root);
-	while (node) {
-		struct hist_entry *he;
-
-		he = rb_entry(node, struct hist_entry, rb_node_in);
-
-		pr_info("%2d: entry: %-8s [%-8s] %20s: period = %"PRIu64"\n",
-			i, thread__comm_str(he->thread), he->ms.map->dso->short_name,
-			he->ms.sym->name, he->stat.period);
-
-		i++;
-		node = rb_next(node);
-	}
-}
-
 int test__hists_link(void)
 {
 	int err = -1;
@@ -336,7 +309,7 @@ int test__hists_link(void)
 		hists__collapse_resort(&evsel->hists, NULL);
 
 		if (verbose > 2)
-			print_hists(&evsel->hists);
+			print_hists_in(&evsel->hists);
 	}
 
 	first = perf_evlist__first(evlist);
