Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752911AbaBBVkh (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Feb 2014 16:40:37 -0500
Received: from mx1.redhat.com ([209.132.183.28]:18851 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752619AbaBBVkc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Feb 2014 16:40:32 -0500
From: Jiri Olsa <jolsa@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: Jiri Olsa <jolsa@redhat.com>, Corey Ashford <cjashfor@linux.vnet.ibm.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@elte.hu>,
        Namhyung Kim <namhyung@kernel.org>, Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        David Ahern <dsahern@gmail.com>
Subject: [PATCH 20/22] perf tools: Make hists col_len dynamicaly alocated
Date: Sun,  2 Feb 2014 22:39:08 +0100
Message-Id: <1391377150-23920-21-git-send-email-jolsa@redhat.com>
In-Reply-To: <1391377150-23920-1-git-send-email-jolsa@redhat.com>
References: <1391377150-23920-1-git-send-email-jolsa@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Making hists col_len dynamicaly allocated as a support
for dynamic sort entries.

Signed-off-by: Jiri Olsa <jolsa@redhat.com>
Cc: Corey Ashford <cjashfor@linux.vnet.ibm.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: David Ahern <dsahern@gmail.com>
---
 tools/perf/util/evsel.c  | 23 ++++++++++++++++-------
 tools/perf/util/evsel.h  |  6 +++---
 tools/perf/util/hist.c   | 15 +++++++++++++++
 tools/perf/util/hist.h   |  4 +++-
 tools/perf/util/python.c |  3 +--
 5 files changed, 38 insertions(+), 13 deletions(-)

diff --git a/tools/perf/util/evsel.c b/tools/perf/util/evsel.c
index 5baf13b..2661870 100644
--- a/tools/perf/util/evsel.c
+++ b/tools/perf/util/evsel.c
@@ -115,7 +115,7 @@ void perf_evsel__calc_id_pos(struct perf_evsel *evsel)
 	evsel->is_pos = __perf_evsel__calc_is_pos(evsel->attr.sample_type);
 }
 
-void hists__init(struct hists *hists)
+int hists__init(struct hists *hists)
 {
 	memset(hists, 0, sizeof(*hists));
 	hists->entries_in_array[0] = hists->entries_in_array[1] = RB_ROOT;
@@ -124,6 +124,12 @@ void hists__init(struct hists *hists)
 	hists->entries = RB_ROOT;
 	INIT_LIST_HEAD(&hists->sort_list);
 	pthread_mutex_init(&hists->lock, NULL);
+	return hists__alloc_col_len(hists, HISTC_NR_COLS);
+}
+
+static void hists__exit(struct hists *hists)
+{
+	free(hists->col_len);
 }
 
 void __perf_evsel__set_sample_bit(struct perf_evsel *evsel,
@@ -158,8 +164,8 @@ void perf_evsel__set_sample_id(struct perf_evsel *evsel,
 	evsel->attr.read_format |= PERF_FORMAT_ID;
 }
 
-void perf_evsel__init(struct perf_evsel *evsel,
-		      struct perf_event_attr *attr, int idx)
+int perf_evsel__init(struct perf_evsel *evsel,
+		     struct perf_event_attr *attr, int idx)
 {
 	evsel->idx	   = idx;
 	evsel->attr	   = *attr;
@@ -167,19 +173,20 @@ void perf_evsel__init(struct perf_evsel *evsel,
 	evsel->unit	   = "";
 	evsel->scale	   = 1.0;
 	INIT_LIST_HEAD(&evsel->node);
-	hists__init(&evsel->hists);
 	evsel->sample_size = __perf_evsel__sample_size(attr->sample_type);
 	perf_evsel__calc_id_pos(evsel);
+	return hists__init(&evsel->hists);
 }
 
 struct perf_evsel *perf_evsel__new_idx(struct perf_event_attr *attr, int idx)
 {
 	struct perf_evsel *evsel = zalloc(sizeof(*evsel));
+	int err = -ENOMEM;
 
 	if (evsel != NULL)
-		perf_evsel__init(evsel, attr, idx);
+		err = perf_evsel__init(evsel, attr, idx);
 
-	return evsel;
+	return err ? NULL : evsel;
 }
 
 struct perf_evsel *perf_evsel__newtp_idx(const char *sys, const char *name, int idx)
@@ -203,7 +210,8 @@ struct perf_evsel *perf_evsel__newtp_idx(const char *sys, const char *name, int
 		event_attr_init(&attr);
 		attr.config = evsel->tp_format->id;
 		attr.sample_period = 1;
-		perf_evsel__init(evsel, &attr, idx);
+		if (perf_evsel__init(evsel, &attr, idx))
+			goto out_free;
 	}
 
 	return evsel;
@@ -776,6 +784,7 @@ void perf_evsel__exit(struct perf_evsel *evsel)
 	assert(list_empty(&evsel->node));
 	perf_evsel__free_fd(evsel);
 	perf_evsel__free_id(evsel);
+	hists__exit(&evsel->hists);
 }
 
 void perf_evsel__delete(struct perf_evsel *evsel)
diff --git a/tools/perf/util/evsel.h b/tools/perf/util/evsel.h
index f1b3256..cdc2681 100644
--- a/tools/perf/util/evsel.h
+++ b/tools/perf/util/evsel.h
@@ -114,8 +114,8 @@ static inline struct perf_evsel *perf_evsel__newtp(const char *sys, const char *
 
 struct event_format *event_format__new(const char *sys, const char *name);
 
-void perf_evsel__init(struct perf_evsel *evsel,
-		      struct perf_event_attr *attr, int idx);
+int perf_evsel__init(struct perf_evsel *evsel,
+		     struct perf_event_attr *attr, int idx);
 void perf_evsel__exit(struct perf_evsel *evsel);
 void perf_evsel__delete(struct perf_evsel *evsel);
 
@@ -272,7 +272,7 @@ static inline int perf_evsel__read_scaled(struct perf_evsel *evsel,
 	return __perf_evsel__read(evsel, ncpus, nthreads, true);
 }
 
-void hists__init(struct hists *hists);
+int hists__init(struct hists *hists);
 
 int perf_evsel__parse_sample(struct perf_evsel *evsel, union perf_event *event,
 			     struct perf_sample *sample);
diff --git a/tools/perf/util/hist.c b/tools/perf/util/hist.c
index 92c3d76..794d0cb 100644
--- a/tools/perf/util/hist.c
+++ b/tools/perf/util/hist.c
@@ -21,6 +21,21 @@ struct callchain_param	callchain_param = {
 	.key	= CCKEY_FUNCTION
 };
 
+int hists__alloc_col_len(struct hists *hists, int n)
+{
+	u16 *col_len = hists->col_len;
+	int old_n = hists->col_n;
+
+	col_len = realloc(col_len, n * sizeof(u16));
+	if (col_len) {
+		memset(col_len + old_n, 0, n - old_n);
+		hists->col_len = col_len;
+		hists->col_n   = n;
+	}
+
+	return col_len ? 0 : -ENOMEM;
+}
+
 u16 hists__col_len(struct hists *hists, enum hist_column col)
 {
 	return hists->col_len[col];
diff --git a/tools/perf/util/hist.h b/tools/perf/util/hist.h
index ff52c3bf..c2f4bd1 100644
--- a/tools/perf/util/hist.h
+++ b/tools/perf/util/hist.h
@@ -91,7 +91,8 @@ struct hists {
 	struct events_stats	stats;
 	u64			time_base;
 	u64			event_stream;
-	u16			col_len[HISTC_NR_COLS];
+	u16			*col_len;
+	int			col_n;
 	struct list_head	sort_list;
 };
 
@@ -168,6 +169,7 @@ void hists__filter_by_dso(struct hists *hists);
 void hists__filter_by_thread(struct hists *hists);
 void hists__filter_by_symbol(struct hists *hists);
 
+int hists__alloc_col_len(struct hists *hists, int n);
 u16 hists__col_len(struct hists *hists, enum hist_column col);
 void hists__set_col_len(struct hists *hists, enum hist_column col, u16 len);
 bool hists__new_col_len(struct hists *hists, enum hist_column col, u16 len);
diff --git a/tools/perf/util/python.c b/tools/perf/util/python.c
index 122669c..b5824d2 100644
--- a/tools/perf/util/python.c
+++ b/tools/perf/util/python.c
@@ -605,8 +605,7 @@ static int pyrf_evsel__init(struct pyrf_evsel *pevsel,
 	attr.mmap_data	    = mmap_data;
 	attr.sample_id_all  = sample_id_all;
 
-	perf_evsel__init(&pevsel->evsel, &attr, idx);
-	return 0;
+	return perf_evsel__init(&pevsel->evsel, &attr, idx);
 }
 
 static void pyrf_evsel__delete(struct pyrf_evsel *pevsel)
-- 
1.8.3.1

