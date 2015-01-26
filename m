Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757182AbbAZRxv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Jan 2015 12:53:51 -0500
Received: from mail.kernel.org ([198.145.29.136]:52792 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756654AbbAZRsC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Jan 2015 12:48:02 -0500
From: Arnaldo Carvalho de Melo <acme@kernel.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org, Namhyung Kim <namhyung@kernel.org>,
        Adrian Hunter <adrian.hunter@intel.com>,
        David Ahern <dsahern@gmail.com>, Jiri Olsa <jolsa@redhat.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Stephane Eranian <eranian@google.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 06/26] perf report: Get rid of report__inc_stat()
Date: Mon, 26 Jan 2015 14:47:09 -0300
Message-Id: <1422294449-12735-7-git-send-email-acme@kernel.org>
X-Mailer: git-send-email 1.9.3
In-Reply-To: <1422294449-12735-1-git-send-email-acme@kernel.org>
References: <1422294449-12735-1-git-send-email-acme@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Namhyung Kim <namhyung@kernel.org>

The report__inc_stat() function collects the number of hist entries in
the session in order to calculate the max size of the progess bar.

It'd be better if it does it during the addition of hist entries so that
it can be used by other places too.

Signed-off-by: Namhyung Kim <namhyung@kernel.org>
Cc: Adrian Hunter <adrian.hunter@intel.com>
Cc: David Ahern <dsahern@gmail.com>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Stephane Eranian <eranian@google.com>
Link: http://lkml.kernel.org/r/1419223455-4362-2-git-send-email-namhyung@kernel.org
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/builtin-report.c | 16 +++-------------
 tools/perf/util/hist.c      |  2 ++
 2 files changed, 5 insertions(+), 13 deletions(-)

diff --git a/tools/perf/builtin-report.c b/tools/perf/builtin-report.c
index 072ae8ad67fc..2f91094e228b 100644
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
 
@@ -499,6 +486,9 @@ static int __cmd_report(struct report *rep)
 
 	report__warn_kptr_restrict(rep);
 
+	evlist__for_each(session->evlist, pos)
+		rep->nr_entries += evsel__hists(pos)->nr_entries;
+
 	if (use_browser == 0) {
 		if (verbose > 3)
 			perf_session__fprintf(session, stdout);
diff --git a/tools/perf/util/hist.c b/tools/perf/util/hist.c
index 038483a24a54..e17163fcb702 100644
--- a/tools/perf/util/hist.c
+++ b/tools/perf/util/hist.c
@@ -429,6 +429,8 @@ static struct hist_entry *add_hist_entry(struct hists *hists,
 	if (!he)
 		return NULL;
 
+	hists->nr_entries++;
+
 	rb_link_node(&he->rb_node_in, parent, p);
 	rb_insert_color(&he->rb_node_in, hists->entries_in);
 out:
-- 
1.9.3

