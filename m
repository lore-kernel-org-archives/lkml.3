Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752161AbaANQqB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Jan 2014 11:46:01 -0500
Received: from terminus.zytor.com ([198.137.202.10]:52799 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751912AbaANQku (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Jan 2014 11:40:50 -0500
Date: Tue, 14 Jan 2014 08:40:05 -0800
From: tip-bot for Arnaldo Carvalho de Melo <tipbot@zytor.com>
Message-ID: <tip-b594zsbwke8khir13kudwqmj@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, eranian@google.com, paulus@samba.org,
        acme@redhat.com, hpa@zytor.com, mingo@kernel.org, peterz@infradead.org,
        efault@gmx.de, namhyung@kernel.org, jolsa@redhat.com,
        fweisbec@gmail.com, adrian.hunter@intel.com, dsahern@gmail.com,
        tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, acme@redhat.com, paulus@samba.org,
        eranian@google.com, linux-kernel@vger.kernel.org, efault@gmx.de,
        peterz@infradead.org, namhyung@kernel.org, jolsa@redhat.com,
        fweisbec@gmail.com, dsahern@gmail.com, adrian.hunter@intel.com,
        tglx@linutronix.de
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf report:
  Move histogram entries collapsing to separate function
Git-Commit-ID: f6d8b0571c9ac8f273d18c112c2fc3c9533c9f0a
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.1 (terminus.zytor.com [127.0.0.1]); Tue, 14 Jan 2014 08:40:13 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  f6d8b0571c9ac8f273d18c112c2fc3c9533c9f0a
Gitweb:     http://git.kernel.org/tip/f6d8b0571c9ac8f273d18c112c2fc3c9533c9f0a
Author:     Arnaldo Carvalho de Melo <acme@redhat.com>
AuthorDate: Wed, 8 Jan 2014 14:45:24 -0300
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Mon, 13 Jan 2014 10:06:25 -0300

perf report: Move histogram entries collapsing to separate function

Further uncluttering the main 'report' function by group related code in
separate function.

Cc: Adrian Hunter <adrian.hunter@intel.com>
Cc: David Ahern <dsahern@gmail.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Stephane Eranian <eranian@google.com>
Link: http://lkml.kernel.org/n/tip-b594zsbwke8khir13kudwqmj@git.kernel.org
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/builtin-report.c | 73 ++++++++++++++++++++++++++++-----------------
 1 file changed, 45 insertions(+), 28 deletions(-)

diff --git a/tools/perf/builtin-report.c b/tools/perf/builtin-report.c
index 03941ad..cff9465 100644
--- a/tools/perf/builtin-report.c
+++ b/tools/perf/builtin-report.c
@@ -486,13 +486,55 @@ static int report__browse_hists(struct report *rep)
 	return ret;
 }
 
+static u64 report__collapse_hists(struct report *rep)
+{
+	struct ui_progress prog;
+	struct perf_evsel *pos;
+	u64 nr_samples = 0;
+	/*
+ 	 * Count number of histogram entries to use when showing progress,
+ 	 * reusing nr_samples variable.
+ 	 */
+	list_for_each_entry(pos, &rep->session->evlist->entries, node)
+		nr_samples += pos->hists.nr_entries;
+
+	ui_progress__init(&prog, nr_samples, "Merging related events...");
+	/*
+	 * Count total number of samples, will be used to check if this
+ 	 * session had any.
+ 	 */
+	nr_samples = 0;
+
+	list_for_each_entry(pos, &rep->session->evlist->entries, node) {
+		struct hists *hists = &pos->hists;
+
+		if (pos->idx == 0)
+			hists->symbol_filter_str = rep->symbol_filter_str;
+
+		hists__collapse_resort(hists, &prog);
+		nr_samples += hists->stats.nr_events[PERF_RECORD_SAMPLE];
+
+		/* Non-group events are considered as leader */
+		if (symbol_conf.event_group &&
+		    !perf_evsel__is_group_leader(pos)) {
+			struct hists *leader_hists = &pos->leader->hists;
+
+			hists__match(leader_hists, hists);
+			hists__link(leader_hists, hists);
+		}
+	}
+
+	ui_progress__finish();
+
+	return nr_samples;
+}
+
 static int __cmd_report(struct report *rep)
 {
-	int ret = -EINVAL;
+	int ret;
 	u64 nr_samples;
 	struct perf_session *session = rep->session;
 	struct perf_evsel *pos;
-	struct ui_progress prog;
 	struct perf_data_file *file = session->file;
 
 	signal(SIGINT, sig_handler);
@@ -530,32 +572,7 @@ static int __cmd_report(struct report *rep)
 		}
 	}
 
-	nr_samples = 0;
-	list_for_each_entry(pos, &session->evlist->entries, node)
-		nr_samples += pos->hists.nr_entries;
-
-	ui_progress__init(&prog, nr_samples, "Merging related events...");
-
-	nr_samples = 0;
-	list_for_each_entry(pos, &session->evlist->entries, node) {
-		struct hists *hists = &pos->hists;
-
-		if (pos->idx == 0)
-			hists->symbol_filter_str = rep->symbol_filter_str;
-
-		hists__collapse_resort(hists, &prog);
-		nr_samples += hists->stats.nr_events[PERF_RECORD_SAMPLE];
-
-		/* Non-group events are considered as leader */
-		if (symbol_conf.event_group &&
-		    !perf_evsel__is_group_leader(pos)) {
-			struct hists *leader_hists = &pos->leader->hists;
-
-			hists__match(leader_hists, hists);
-			hists__link(leader_hists, hists);
-		}
-	}
-	ui_progress__finish();
+	nr_samples = report__collapse_hists(rep);
 
 	if (session_done())
 		return 0;
