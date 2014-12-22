Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754028AbaLVEn6 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Dec 2014 23:43:58 -0500
Received: from lgeamrelo02.lge.com ([156.147.1.126]:50453 "EHLO
	lgeamrelo02.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753794AbaLVEnk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Dec 2014 23:43:40 -0500
X-Original-SENDERIP: 10.177.222.235
X-Original-MAILFROM: namhyung@kernel.org
From: Namhyung Kim <namhyung@kernel.org>
To: Arnaldo Carvalho de Melo <acme@kernel.org>
Cc: Ingo Molnar <mingo@kernel.org>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Jiri Olsa <jolsa@redhat.com>, LKML <linux-kernel@vger.kernel.org>,
        David Ahern <dsahern@gmail.com>, Stephane Eranian <eranian@google.com>,
        Adrian Hunter <adrian.hunter@intel.com>
Subject: [PATCH 1/7] perf report: Get rid of report__inc_stat()
Date: Mon, 22 Dec 2014 13:44:09 +0900
Message-Id: <1419223455-4362-2-git-send-email-namhyung@kernel.org>
X-Mailer: git-send-email 2.1.3
In-Reply-To: <1419223455-4362-1-git-send-email-namhyung@kernel.org>
References: <1419223455-4362-1-git-send-email-namhyung@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The report__inc_stat() is to collect number of hist entries in the
session in order to calculate the max size of progess bar.  It'd be
better if it does during addition of hist entries so that it can be
used by other places too.

Signed-off-by: Namhyung Kim <namhyung@kernel.org>
---
 tools/perf/builtin-report.c | 16 +++-------------
 tools/perf/util/hist.c      |  2 ++
 2 files changed, 5 insertions(+), 13 deletions(-)

diff --git a/tools/perf/builtin-report.c b/tools/perf/builtin-report.c
index 39367609c707..e2a0c2bbb3bf 100644
--- a/tools/perf/builtin-report.c
+++ b/tools/perf/builtin-report.c
@@ -86,17 +86,6 @@ static int report__config(const char *var, const char *value, void *cb)
 	return perf_default_config(var, value, cb);
 }
 
-static void report__inc_stats(struct report *rep, struct hist_entry *he)
-{
-	/*
-	 * The @he is either of a newly created one or an existing one
-	 * merging current sample.  We only want to count a new one so
-	 * checking ->nr_events being 1.
-	 */
-	if (he->stat.nr_events == 1)
-		rep->nr_entries++;
-}
-
 static int hist_iter__report_callback(struct hist_entry_iter *iter,
 				      struct addr_location *al, bool single,
 				      void *arg)
@@ -108,8 +97,6 @@ static int hist_iter__report_callback(struct hist_entry_iter *iter,
 	struct mem_info *mi;
 	struct branch_info *bi;
 
-	report__inc_stats(rep, he);
-
 	if (!ui__has_annotation())
 		return 0;
 
@@ -486,6 +473,9 @@ static int __cmd_report(struct report *rep)
 
 	report__warn_kptr_restrict(rep);
 
+	evlist__for_each(session->evlist, pos)
+		rep->nr_entries += evsel__hists(pos)->nr_entries;
+
 	if (use_browser == 0) {
 		if (verbose > 3)
 			perf_session__fprintf(session, stdout);
diff --git a/tools/perf/util/hist.c b/tools/perf/util/hist.c
index f03854b5fb5f..30c49498495c 100644
--- a/tools/perf/util/hist.c
+++ b/tools/perf/util/hist.c
@@ -428,6 +428,8 @@ static struct hist_entry *add_hist_entry(struct hists *hists,
 	if (!he)
 		return NULL;
 
+	hists->nr_entries++;
+
 	rb_link_node(&he->rb_node_in, parent, p);
 	rb_insert_color(&he->rb_node_in, hists->entries_in);
 out:
-- 
2.1.3

