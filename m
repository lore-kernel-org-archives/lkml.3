Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752890AbaBBVkb (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Feb 2014 16:40:31 -0500
Received: from mx1.redhat.com ([209.132.183.28]:5115 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752619AbaBBVk3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Feb 2014 16:40:29 -0500
From: Jiri Olsa <jolsa@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: Jiri Olsa <jolsa@redhat.com>, Corey Ashford <cjashfor@linux.vnet.ibm.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@elte.hu>,
        Namhyung Kim <namhyung@kernel.org>, Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        David Ahern <dsahern@gmail.com>
Subject: [PATCH 19/22] perf tools: Add local hists sort entry list
Date: Sun,  2 Feb 2014 22:39:07 +0100
Message-Id: <1391377150-23920-20-git-send-email-jolsa@redhat.com>
In-Reply-To: <1391377150-23920-1-git-send-email-jolsa@redhat.com>
References: <1391377150-23920-1-git-send-email-jolsa@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Adding sort_entry list local to 'struct hists'.
This way we could setup specific sort entries
for separate hists.

This is going to be used for tracepoints fields
view in following patch.

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
 tools/perf/util/evsel.c |  1 +
 tools/perf/util/hist.h  |  1 +
 tools/perf/util/sort.c  | 14 ++++++++++++--
 tools/perf/util/sort.h  |  2 ++
 4 files changed, 16 insertions(+), 2 deletions(-)

diff --git a/tools/perf/util/evsel.c b/tools/perf/util/evsel.c
index 55407c5..5baf13b 100644
--- a/tools/perf/util/evsel.c
+++ b/tools/perf/util/evsel.c
@@ -122,6 +122,7 @@ void hists__init(struct hists *hists)
 	hists->entries_in = &hists->entries_in_array[0];
 	hists->entries_collapsed = RB_ROOT;
 	hists->entries = RB_ROOT;
+	INIT_LIST_HEAD(&hists->sort_list);
 	pthread_mutex_init(&hists->lock, NULL);
 }
 
diff --git a/tools/perf/util/hist.h b/tools/perf/util/hist.h
index 9c0bd20..ff52c3bf 100644
--- a/tools/perf/util/hist.h
+++ b/tools/perf/util/hist.h
@@ -92,6 +92,7 @@ struct hists {
 	u64			time_base;
 	u64			event_stream;
 	u16			col_len[HISTC_NR_COLS];
+	struct list_head	sort_list;
 };
 
 struct hist_entry_iter;
diff --git a/tools/perf/util/sort.c b/tools/perf/util/sort.c
index 42e6038..d2c52a6 100644
--- a/tools/perf/util/sort.c
+++ b/tools/perf/util/sort.c
@@ -1382,15 +1382,20 @@ void sort__setup_list(void)
 	sd_idx->entry->elide = true;
 }
 
-bool hists__next_se(struct hists *hists __maybe_unused, struct sort_entry **sep)
+bool hists__next_se(struct hists *hists, struct sort_entry **sep)
 {
 	struct list_head *head_global = &hist_entry__sort_list;
+	struct list_head *head_local  = &hists->sort_list;
 	struct sort_entry *se = *sep;
 
 	if (!se) {
 		se = list_first_entry(head_global, struct sort_entry, list);
 	} else {
-		if (list_is_last(&se->list, head_global))
+		if (list_is_last(&se->list, head_global)) {
+			se = list_empty(head_local) ? NULL :
+			     list_first_entry(head_local, struct sort_entry,
+					      list);
+		} else if (list_is_last(&se->list, head_local))
 			se = NULL;
 		else
 			se = list_next_entry(se, list);
@@ -1398,3 +1403,8 @@ bool hists__next_se(struct hists *hists __maybe_unused, struct sort_entry **sep)
 
 	return se ? (*sep = se) : false;
 }
+
+void hists__sort_entry_add(struct hists *hists, struct sort_entry *se)
+{
+	list_add_tail(&se->list, &hists->sort_list);
+}
diff --git a/tools/perf/util/sort.h b/tools/perf/util/sort.h
index f0d501e..77454ee 100644
--- a/tools/perf/util/sort.h
+++ b/tools/perf/util/sort.h
@@ -223,4 +223,6 @@ bool hists__next_se(struct hists *hists, struct sort_entry **sep);
 #define hists__for_each_se(hists, se) \
 	for (se = NULL; hists__next_se(hists, &se);)
 
+void hists__sort_entry_add(struct hists *hists, struct sort_entry *se);
+
 #endif	/* __PERF_SORT_H */
-- 
1.8.3.1

