Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753384AbaELG3w (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 May 2014 02:29:52 -0400
Received: from LGEMRELSE6Q.lge.com ([156.147.1.121]:57648 "EHLO
	lgemrelse6q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753011AbaELG3H (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 May 2014 02:29:07 -0400
X-Original-SENDERIP: 10.177.220.181
X-Original-MAILFROM: namhyung@kernel.org
From: Namhyung Kim <namhyung@kernel.org>
To: Arnaldo Carvalho de Melo <acme@kernel.org>, Jiri Olsa <jolsa@redhat.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Ingo Molnar <mingo@kernel.org>,
        Paul Mackerras <paulus@samba.org>, Namhyung Kim <namhyung.kim@lge.com>,
        Namhyung Kim <namhyung@kernel.org>,
        LKML <linux-kernel@vger.kernel.org>, David Ahern <dsahern@gmail.com>,
        Andi Kleen <andi@firstfloor.org>, Don Zickus <dzickus@redhat.com>
Subject: [PATCH 19/20] perf tests: Factor out print_hists_*()
Date: Mon, 12 May 2014 15:28:52 +0900
Message-Id: <1399876133-17963-20-git-send-email-namhyung@kernel.org>
X-Mailer: git-send-email 1.9.2
In-Reply-To: <1399876133-17963-1-git-send-email-namhyung@kernel.org>
References: <1399876133-17963-1-git-send-email-namhyung@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Those print helper functions can be reused by later hist test cases so
factor them out to a common location.

Signed-off-by: Namhyung Kim <namhyung@kernel.org>
---
 tools/perf/tests/hists_common.c | 57 +++++++++++++++++++++++++++++++++++++++++
 tools/perf/tests/hists_common.h |  3 +++
 tools/perf/tests/hists_filter.c | 37 ++++----------------------
 tools/perf/tests/hists_link.c   | 29 +--------------------
 4 files changed, 66 insertions(+), 60 deletions(-)

diff --git a/tools/perf/tests/hists_common.c b/tools/perf/tests/hists_common.c
index 44655b395bb9..040a85b17aee 100644
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
index 2528b8fc105a..1415ae69d7b6 100644
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
index 4617a8bee29b..13c8cf49225e 100644
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
index b009bbf440d9..4e783db60bba 100644
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
-- 
1.9.2

