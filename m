Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756019AbaJNVJh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Oct 2014 17:09:37 -0400
Received: from mail.kernel.org ([198.145.19.201]:44748 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755865AbaJNVFp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Oct 2014 17:05:45 -0400
From: Arnaldo Carvalho de Melo <acme@kernel.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org, Arnaldo Carvalho de Melo <acme@redhat.com>,
        Adrian Hunter <adrian.hunter@intel.com>, Borislav Petkov <bp@suse.de>,
        David Ahern <dsahern@gmail.com>, Don Zickus <dzickus@redhat.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Jean Pihet <jean.pihet@linaro.org>, Jiri Olsa <jolsa@redhat.com>,
        Mike Galbraith <efault@gmx.de>, Namhyung Kim <namhyung@kernel.org>,
        Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Stephane Eranian <eranian@google.com>
Subject: [PATCH 11/24] perf session: Remove last reference to hists struct
Date: Tue, 14 Oct 2014 18:04:20 -0300
Message-Id: <1413320673-5784-12-git-send-email-acme@kernel.org>
X-Mailer: git-send-email 1.9.3
In-Reply-To: <1413320673-5784-1-git-send-email-acme@kernel.org>
References: <1413320673-5784-1-git-send-email-acme@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Arnaldo Carvalho de Melo <acme@redhat.com>

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
index c9a119e2113d..a5969fa64503 100644
--- a/tools/perf/builtin-annotate.c
+++ b/tools/perf/builtin-annotate.c
@@ -214,6 +214,7 @@ static int __cmd_annotate(struct perf_annotate *ann)
 
 	if (dump_trace) {
 		perf_session__fprintf_nr_events(session, stdout);
+		perf_evlist__fprintf_nr_events(session->evlist, stdout);
 		goto out;
 	}
 
diff --git a/tools/perf/builtin-report.c b/tools/perf/builtin-report.c
index 3750d635f0f7..8043b5a7240a 100644
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
index f72ad9c36e39..b143e404e5b1 100644
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
index 04a46e32f42f..a039cd22b23c 100644
--- a/tools/perf/util/hist.h
+++ b/tools/perf/util/hist.h
@@ -139,6 +139,7 @@ size_t events_stats__fprintf(struct events_stats *stats, FILE *fp);
 
 size_t hists__fprintf(struct hists *hists, bool show_header, int max_rows,
 		      int max_cols, float min_pcnt, FILE *fp);
+size_t perf_evlist__fprintf_nr_events(struct perf_evlist *evlist, FILE *fp);
 
 void hists__filter_by_dso(struct hists *hists);
 void hists__filter_by_thread(struct hists *hists);
diff --git a/tools/perf/util/session.c b/tools/perf/util/session.c
index 66cae50b5c4c..896bac73ea08 100644
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
index ffb440462008..a4be851f1a90 100644
--- a/tools/perf/util/session.h
+++ b/tools/perf/util/session.h
@@ -2,7 +2,6 @@
 #define __PERF_SESSION_H
 
 #include "trace-event.h"
-#include "hist.h"
 #include "event.h"
 #include "header.h"
 #include "machine.h"
-- 
1.9.3

