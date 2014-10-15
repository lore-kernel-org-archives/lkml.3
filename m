Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752408AbaJOKEX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Oct 2014 06:04:23 -0400
Received: from terminus.zytor.com ([198.137.202.10]:54311 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751823AbaJOKEV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Oct 2014 06:04:21 -0400
Date: Wed, 15 Oct 2014 03:03:36 -0700
From: tip-bot for Arnaldo Carvalho de Melo <tipbot@zytor.com>
Message-ID: <tip-cli1bgwpo82mdikuhy3djsuy@git.kernel.org>
Cc: jolsa@redhat.com, jean.pihet@linaro.org, peterz@infradead.org,
        mingo@kernel.org, dzickus@redhat.com, efault@gmx.de, dsahern@gmail.com,
        eranian@google.com, adrian.hunter@intel.com, namhyung@kernel.org,
        tglx@linutronix.de, fweisbec@gmail.com, paulus@samba.org,
        acme@redhat.com, linux-kernel@vger.kernel.org, hpa@zytor.com,
        bp@suse.de
Reply-To: jean.pihet@linaro.org, peterz@infradead.org, mingo@kernel.org,
        jolsa@redhat.com, adrian.hunter@intel.com, namhyung@kernel.org,
        tglx@linutronix.de, dzickus@redhat.com, efault@gmx.de,
        eranian@google.com, dsahern@gmail.com, fweisbec@gmail.com,
        hpa@zytor.com, bp@suse.de, acme@redhat.com, paulus@samba.org,
        linux-kernel@vger.kernel.org
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/urgent] perf session:
  Remove last reference to hists struct
Git-Commit-ID: 2a1731fb85ec96a1f6a326fb2d52cd93494dafa2
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

Commit-ID:  2a1731fb85ec96a1f6a326fb2d52cd93494dafa2
Gitweb:     http://git.kernel.org/tip/2a1731fb85ec96a1f6a326fb2d52cd93494dafa2
Author:     Arnaldo Carvalho de Melo <acme@redhat.com>
AuthorDate: Fri, 10 Oct 2014 15:49:21 -0300
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Tue, 14 Oct 2014 11:41:25 -0300

perf session: Remove last reference to hists struct

Now perf_session doesn't require that the evsels in its evlist are hists
containing ones.

Tools that are hists based and want to do per evsel events_stats
updates, if at some point this turns into a necessity, should do it in
the tool specific code, keeping the session class hists agnostic.

Cc: Adrian Hunter <adrian.hunter@intel.com>
Cc: Borislav Petkov <bp@suse.de>
Cc: David Ahern <dsahern@gmail.com>
Cc: Don Zickus <dzickus@redhat.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Jean Pihet <jean.pihet@linaro.org>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Stephane Eranian <eranian@google.com>
Link: http://lkml.kernel.org/n/tip-cli1bgwpo82mdikuhy3djsuy@git.kernel.org
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/builtin-annotate.c |  1 +
 tools/perf/builtin-report.c   |  1 +
 tools/perf/util/hist.c        | 16 ++++++++++++++++
 tools/perf/util/hist.h        |  1 +
 tools/perf/util/session.c     |  7 -------
 tools/perf/util/session.h     |  1 -
 6 files changed, 19 insertions(+), 8 deletions(-)

diff --git a/tools/perf/builtin-annotate.c b/tools/perf/builtin-annotate.c
index c9a119e2..a5969fa 100644
--- a/tools/perf/builtin-annotate.c
+++ b/tools/perf/builtin-annotate.c
@@ -214,6 +214,7 @@ static int __cmd_annotate(struct perf_annotate *ann)
 
 	if (dump_trace) {
 		perf_session__fprintf_nr_events(session, stdout);
+		perf_evlist__fprintf_nr_events(session->evlist, stdout);
 		goto out;
 	}
 
diff --git a/tools/perf/builtin-report.c b/tools/perf/builtin-report.c
index 3750d63..8043b5a 100644
--- a/tools/perf/builtin-report.c
+++ b/tools/perf/builtin-report.c
@@ -487,6 +487,7 @@ static int __cmd_report(struct report *rep)
 
 		if (dump_trace) {
 			perf_session__fprintf_nr_events(session, stdout);
+			perf_evlist__fprintf_nr_events(session->evlist, stdout);
 			return 0;
 		}
 	}
diff --git a/tools/perf/util/hist.c b/tools/perf/util/hist.c
index f72ad9c..b143e40 100644
--- a/tools/perf/util/hist.c
+++ b/tools/perf/util/hist.c
@@ -3,6 +3,7 @@
 #include "hist.h"
 #include "session.h"
 #include "sort.h"
+#include "evlist.h"
 #include "evsel.h"
 #include "annotate.h"
 #include <math.h>
@@ -1405,6 +1406,21 @@ int hists__link(struct hists *leader, struct hists *other)
 	return 0;
 }
 
+
+size_t perf_evlist__fprintf_nr_events(struct perf_evlist *evlist, FILE *fp)
+{
+	struct perf_evsel *pos;
+	size_t ret = 0;
+
+	evlist__for_each(evlist, pos) {
+		ret += fprintf(fp, "%s stats:\n", perf_evsel__name(pos));
+		ret += events_stats__fprintf(&evsel__hists(pos)->stats, fp);
+	}
+
+	return ret;
+}
+
+
 u64 hists__total_period(struct hists *hists)
 {
 	return symbol_conf.filter_relative ? hists->stats.total_non_filtered_period :
diff --git a/tools/perf/util/hist.h b/tools/perf/util/hist.h
index 04a46e3..a039cd2 100644
--- a/tools/perf/util/hist.h
+++ b/tools/perf/util/hist.h
@@ -139,6 +139,7 @@ size_t events_stats__fprintf(struct events_stats *stats, FILE *fp);
 
 size_t hists__fprintf(struct hists *hists, bool show_header, int max_rows,
 		      int max_cols, float min_pcnt, FILE *fp);
+size_t perf_evlist__fprintf_nr_events(struct perf_evlist *evlist, FILE *fp);
 
 void hists__filter_by_dso(struct hists *hists);
 void hists__filter_by_thread(struct hists *hists);
diff --git a/tools/perf/util/session.c b/tools/perf/util/session.c
index 66cae50..896bac7 100644
--- a/tools/perf/util/session.c
+++ b/tools/perf/util/session.c
@@ -1375,16 +1375,9 @@ size_t perf_session__fprintf_dsos_buildid(struct perf_session *session, FILE *fp
 
 size_t perf_session__fprintf_nr_events(struct perf_session *session, FILE *fp)
 {
-	struct perf_evsel *pos;
 	size_t ret = fprintf(fp, "Aggregated stats:\n");
 
 	ret += events_stats__fprintf(&session->stats, fp);
-
-	evlist__for_each(session->evlist, pos) {
-		ret += fprintf(fp, "%s stats:\n", perf_evsel__name(pos));
-		ret += events_stats__fprintf(&evsel__hists(pos)->stats, fp);
-	}
-
 	return ret;
 }
 
diff --git a/tools/perf/util/session.h b/tools/perf/util/session.h
index ffb4404..a4be851 100644
--- a/tools/perf/util/session.h
+++ b/tools/perf/util/session.h
@@ -2,7 +2,6 @@
 #define __PERF_SESSION_H
 
 #include "trace-event.h"
-#include "hist.h"
 #include "event.h"
 #include "header.h"
 #include "machine.h"
