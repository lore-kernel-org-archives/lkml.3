Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756652Ab3BAKnO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Feb 2013 05:43:14 -0500
Received: from terminus.zytor.com ([198.137.202.10]:51826 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755530Ab3BAKnM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Feb 2013 05:43:12 -0500
Date: Fri, 1 Feb 2013 02:42:48 -0800
From: tip-bot for Namhyung Kim <namhyung.kim@lge.com>
Message-ID: <tip-29d720ed5f897d7e26f6b36c12c7704dc200d107@git.kernel.org>
Cc: acme@redhat.com, linux-kernel@vger.kernel.org, eranian@google.com,
        paulus@samba.org, hpa@zytor.com, mingo@kernel.org,
        a.p.zijlstra@chello.nl, namhyung.kim@lge.com, namhyung@kernel.org,
        jolsa@redhat.com, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, paulus@samba.org,
        eranian@google.com, linux-kernel@vger.kernel.org, acme@redhat.com,
        a.p.zijlstra@chello.nl, namhyung.kim@lge.com, tglx@linutronix.de,
        namhyung@kernel.org, jolsa@redhat.com
In-Reply-To: <1358845787-1350-6-git-send-email-namhyung@kernel.org>
References: <1358845787-1350-6-git-send-email-namhyung@kernel.org>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf hists:
  Resort hist entries using group members for output
Git-Commit-ID: 29d720ed5f897d7e26f6b36c12c7704dc200d107
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.7 (terminus.zytor.com [127.0.0.1]); Fri, 01 Feb 2013 02:42:55 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  29d720ed5f897d7e26f6b36c12c7704dc200d107
Gitweb:     http://git.kernel.org/tip/29d720ed5f897d7e26f6b36c12c7704dc200d107
Author:     Namhyung Kim <namhyung.kim@lge.com>
AuthorDate: Tue, 22 Jan 2013 18:09:33 +0900
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Thu, 31 Jan 2013 13:07:45 -0300

perf hists: Resort hist entries using group members for output

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
