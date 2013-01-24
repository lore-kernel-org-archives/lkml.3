Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756663Ab3AXUdd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jan 2013 15:33:33 -0500
Received: from merlin.infradead.org ([205.233.59.134]:50150 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755587Ab3AXUIk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jan 2013 15:08:40 -0500
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org, Arnaldo Carvalho de Melo <acme@redhat.com>,
        David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Jiri Olsa <jolsa@redhat.com>,
        Mike Galbraith <efault@gmx.de>, Namhyung Kim <namhyung@gmail.com>,
        Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Stephane Eranian <eranian@google.com>
Subject: [PATCH 18/74] perf hists: Rename hists__fprintf_nr_events to events_stats__fprintf
Date: Thu, 24 Jan 2013 17:07:27 -0300
Message-Id: <1359058103-31645-19-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.8.1.1.361.gec3ae6e
In-Reply-To: <1359058103-31645-1-git-send-email-acme@infradead.org>
References: <1359058103-31645-1-git-send-email-acme@infradead.org>
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Arnaldo Carvalho de Melo <acme@redhat.com>

As this function deals exclusively with hists->stats.

Preparatory patch for removing the by now needless session->hists, that
should be just session->stats.

Cc: David Ahern <dsahern@gmail.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Namhyung Kim <namhyung@gmail.com>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Stephane Eranian <eranian@google.com>
Link: http://lkml.kernel.org/n/tip-be0o8si9f1z40cwoa534f7me@git.kernel.org
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/ui/stdio/hist.c | 6 +++---
 tools/perf/util/hist.h     | 2 +-
 tools/perf/util/session.c  | 4 ++--
 3 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/tools/perf/ui/stdio/hist.c b/tools/perf/ui/stdio/hist.c
index 0eae3b2..f979829 100644
--- a/tools/perf/ui/stdio/hist.c
+++ b/tools/perf/ui/stdio/hist.c
@@ -459,7 +459,7 @@ out:
 	return ret;
 }
 
-size_t hists__fprintf_nr_events(struct hists *hists, FILE *fp)
+size_t events_stats__fprintf(struct events_stats *stats, FILE *fp)
 {
 	int i;
 	size_t ret = 0;
@@ -467,7 +467,7 @@ size_t hists__fprintf_nr_events(struct hists *hists, FILE *fp)
 	for (i = 0; i < PERF_RECORD_HEADER_MAX; ++i) {
 		const char *name;
 
-		if (hists->stats.nr_events[i] == 0)
+		if (stats->nr_events[i] == 0)
 			continue;
 
 		name = perf_event__name(i);
@@ -475,7 +475,7 @@ size_t hists__fprintf_nr_events(struct hists *hists, FILE *fp)
 			continue;
 
 		ret += fprintf(fp, "%16s events: %10d\n", name,
-			       hists->stats.nr_events[i]);
+			       stats->nr_events[i]);
 	}
 
 	return ret;
diff --git a/tools/perf/util/hist.h b/tools/perf/util/hist.h
index d3664ab..cb6533b 100644
--- a/tools/perf/util/hist.h
+++ b/tools/perf/util/hist.h
@@ -98,7 +98,7 @@ void hists__output_recalc_col_len(struct hists *hists, int max_rows);
 
 void hists__inc_nr_entries(struct hists *hists, struct hist_entry *h);
 void hists__inc_nr_events(struct hists *self, u32 type);
-size_t hists__fprintf_nr_events(struct hists *self, FILE *fp);
+size_t events_stats__fprintf(struct events_stats *stats, FILE *fp);
 
 size_t hists__fprintf(struct hists *self, bool show_header, int max_rows,
 		      int max_cols, FILE *fp);
diff --git a/tools/perf/util/session.c b/tools/perf/util/session.c
index 76d6e25..6e8dd2a 100644
--- a/tools/perf/util/session.c
+++ b/tools/perf/util/session.c
@@ -1353,11 +1353,11 @@ size_t perf_session__fprintf_nr_events(struct perf_session *session, FILE *fp)
 	struct perf_evsel *pos;
 	size_t ret = fprintf(fp, "Aggregated stats:\n");
 
-	ret += hists__fprintf_nr_events(&session->hists, fp);
+	ret += events_stats__fprintf(&session->hists.stats, fp);
 
 	list_for_each_entry(pos, &session->evlist->entries, node) {
 		ret += fprintf(fp, "%s stats:\n", perf_evsel__name(pos));
-		ret += hists__fprintf_nr_events(&pos->hists, fp);
+		ret += events_stats__fprintf(&pos->hists.stats, fp);
 	}
 
 	return ret;
-- 
1.8.1.1.361.gec3ae6e

