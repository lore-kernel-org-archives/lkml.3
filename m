Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762163AbbA1UuX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Jan 2015 15:50:23 -0500
Received: from terminus.zytor.com ([198.137.202.10]:40980 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754569AbbA1UuI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Jan 2015 15:50:08 -0500
Date: Wed, 28 Jan 2015 07:04:40 -0800
From: tip-bot for Namhyung Kim <tipbot@zytor.com>
Message-ID: <tip-590cd344e2099c7b040b29d3a711b4c26358def5@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, acme@redhat.com,
        a.p.zijlstra@chello.nl, namhyung@kernel.org, mingo@kernel.org,
        dsahern@gmail.com, adrian.hunter@intel.com, jolsa@redhat.com,
        eranian@google.com, tglx@linutronix.de
Reply-To: dsahern@gmail.com, mingo@kernel.org, eranian@google.com,
        tglx@linutronix.de, jolsa@redhat.com, adrian.hunter@intel.com,
        acme@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        a.p.zijlstra@chello.nl, namhyung@kernel.org
In-Reply-To: <1419223455-4362-2-git-send-email-namhyung@kernel.org>
References: <1419223455-4362-2-git-send-email-namhyung@kernel.org>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf report: Get rid of report__inc_stat()
Git-Commit-ID: 590cd344e2099c7b040b29d3a711b4c26358def5
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

Commit-ID:  590cd344e2099c7b040b29d3a711b4c26358def5
Gitweb:     http://git.kernel.org/tip/590cd344e2099c7b040b29d3a711b4c26358def5
Author:     Namhyung Kim <namhyung@kernel.org>
AuthorDate: Mon, 22 Dec 2014 13:44:09 +0900
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Wed, 21 Jan 2015 13:24:32 -0300

perf report: Get rid of report__inc_stat()

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
index 072ae8a..2f91094 100644
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
index 038483a..e17163f 100644
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
