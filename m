Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755902Ab3AaRZo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Jan 2013 12:25:44 -0500
Received: from merlin.infradead.org ([205.233.59.134]:48049 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754475Ab3AaRZj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Jan 2013 12:25:39 -0500
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org, Namhyung Kim <namhyung.kim@lge.com>,
        Namhyung Kim <namhyung@kernel.org>, Jiri Olsa <jolsa@redhat.com>,
        Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Stephane Eranian <eranian@google.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 07/25] perf hists: Resort hist entries using group members for output
Date: Thu, 31 Jan 2013 14:25:10 -0300
Message-Id: <1359653128-10433-8-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.8.1.1.361.gec3ae6e
In-Reply-To: <1359653128-10433-1-git-send-email-acme@infradead.org>
References: <1359653128-10433-1-git-send-email-acme@infradead.org>
Content-Type: text/plain; charset="utf-8"
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by merlin.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Namhyung Kim <namhyung.kim@lge.com>

When event group is enabled, sorting hist entries on periods for output
should consider groups members' period also.  To do that, build period
table using link/pair information and compare the table.

Signed-off-by: Namhyung Kim <namhyung@kernel.org>
Acked-by: Jiri Olsa <jolsa@redhat.com>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Stephane Eranian <eranian@google.com>
Link: http://lkml.kernel.org/r/1358845787-1350-6-git-send-email-namhyung@kernel.org
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/util/evsel.h |  2 ++
 tools/perf/util/hist.c  | 59 ++++++++++++++++++++++++++++++++++++++++++++++++-
 2 files changed, 60 insertions(+), 1 deletion(-)

diff --git a/tools/perf/util/evsel.h b/tools/perf/util/evsel.h
index c9031eb..3717139 100644
--- a/tools/perf/util/evsel.h
+++ b/tools/perf/util/evsel.h
@@ -79,6 +79,8 @@ struct perf_evsel {
 	char			*group_name;
 };
 
+#define hists_to_evsel(h) container_of(h, struct perf_evsel, hists)
+
 struct cpu_map;
 struct thread_map;
 struct perf_evlist;
diff --git a/tools/perf/util/hist.c b/tools/perf/util/hist.c
index 8170a3d..f855941 100644
--- a/tools/perf/util/hist.c
+++ b/tools/perf/util/hist.c
@@ -4,6 +4,7 @@
 #include "hist.h"
 #include "session.h"
 #include "sort.h"
+#include "evsel.h"
 #include <math.h>
 
 static bool hists__filter_entry_by_dso(struct hists *hists,
@@ -540,6 +541,62 @@ void hists__collapse_resort_threaded(struct hists *hists)
  * reverse the map, sort on period.
  */
 
+static int period_cmp(u64 period_a, u64 period_b)
+{
+	if (period_a > period_b)
+		return 1;
+	if (period_a < period_b)
+		return -1;
+	return 0;
+}
+
+static int hist_entry__sort_on_period(struct hist_entry *a,
+				      struct hist_entry *b)
+{
+	int ret;
+	int i, nr_members;
+	struct perf_evsel *evsel;
+	struct hist_entry *pair;
+	u64 *periods_a, *periods_b;
+
+	ret = period_cmp(a->stat.period, b->stat.period);
+	if (ret || !symbol_conf.event_group)
+		return ret;
+
+	evsel = hists_to_evsel(a->hists);
+	nr_members = evsel->nr_members;
+	if (nr_members <= 1)
+		return ret;
+
+	periods_a = zalloc(sizeof(periods_a) * nr_members);
+	periods_b = zalloc(sizeof(periods_b) * nr_members);
+
+	if (!periods_a || !periods_b)
+		goto out;
+
+	list_for_each_entry(pair, &a->pairs.head, pairs.node) {
+		evsel = hists_to_evsel(pair->hists);
+		periods_a[perf_evsel__group_idx(evsel)] = pair->stat.period;
+	}
+
+	list_for_each_entry(pair, &b->pairs.head, pairs.node) {
+		evsel = hists_to_evsel(pair->hists);
+		periods_b[perf_evsel__group_idx(evsel)] = pair->stat.period;
+	}
+
+	for (i = 1; i < nr_members; i++) {
+		ret = period_cmp(periods_a[i], periods_b[i]);
+		if (ret)
+			break;
+	}
+
+out:
+	free(periods_a);
+	free(periods_b);
+
+	return ret;
+}
+
 static void __hists__insert_output_entry(struct rb_root *entries,
 					 struct hist_entry *he,
 					 u64 min_callchain_hits)
@@ -556,7 +613,7 @@ static void __hists__insert_output_entry(struct rb_root *entries,
 		parent = *p;
 		iter = rb_entry(parent, struct hist_entry, rb_node);
 
-		if (he->stat.period > iter->stat.period)
+		if (hist_entry__sort_on_period(he, iter) > 0)
 			p = &(*p)->rb_left;
 		else
 			p = &(*p)->rb_right;
-- 
1.8.1.1.361.gec3ae6e

