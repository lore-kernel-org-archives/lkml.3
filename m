Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752173Ab3COFs6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Mar 2013 01:48:58 -0400
Received: from LGEMRELSE7Q.lge.com ([156.147.1.151]:64519 "EHLO
	LGEMRELSE7Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750872Ab3COFs4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Mar 2013 01:48:56 -0400
X-AuditID: 9c930197-b7cc2ae000000eb7-d5-5142b6469fcd
From: Namhyung Kim <namhyung@kernel.org>
To: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Paul Mackerras <paulus@samba.org>,
        Ingo Molnar <mingo@kernel.org>, Namhyung Kim <namhyung.kim@lge.com>,
        LKML <linux-kernel@vger.kernel.org>, Jiri Olsa <jolsa@redhat.com>,
        David Ahern <dsahern@gmail.com>
Subject: [PATCH 1/6] perf evlist: Introduce perf_evlist__close()
Date: Fri, 15 Mar 2013 14:48:48 +0900
Message-Id: <1363326533-3310-1-git-send-email-namhyung@kernel.org>
X-Mailer: git-send-email 1.7.11.7
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Namhyung Kim <namhyung.kim@lge.com>

It's a pair of perf_evlist__open().

Signed-off-by: Namhyung Kim <namhyung@kernel.org>
---
 tools/perf/util/evlist.c | 19 ++++++++++++-------
 tools/perf/util/evlist.h |  1 +
 2 files changed, 13 insertions(+), 7 deletions(-)

diff --git a/tools/perf/util/evlist.c b/tools/perf/util/evlist.c
index 5b012b8d7a14..1344fbd2472e 100644
--- a/tools/perf/util/evlist.c
+++ b/tools/perf/util/evlist.c
@@ -721,10 +721,20 @@ void perf_evlist__set_selected(struct perf_evlist *evlist,
 	evlist->selected = evsel;
 }
 
+void perf_evlist__close(struct perf_evlist *evlist)
+{
+	struct perf_evsel *evsel;
+	int ncpus = cpu_map__nr(evlist->cpus);
+	int nthreads = thread_map__nr(evlist->threads);
+
+	list_for_each_entry_reverse(evsel, &evlist->entries, node)
+		perf_evsel__close(evsel, ncpus, nthreads);
+}
+
 int perf_evlist__open(struct perf_evlist *evlist)
 {
 	struct perf_evsel *evsel;
-	int err, ncpus, nthreads;
+	int err;
 
 	list_for_each_entry(evsel, &evlist->entries, node) {
 		err = perf_evsel__open(evsel, evlist->cpus, evlist->threads);
@@ -734,12 +744,7 @@ int perf_evlist__open(struct perf_evlist *evlist)
 
 	return 0;
 out_err:
-	ncpus = cpu_map__nr(evlist->cpus);
-	nthreads = thread_map__nr(evlist->threads);
-
-	list_for_each_entry_reverse(evsel, &evlist->entries, node)
-		perf_evsel__close(evsel, ncpus, nthreads);
-
+	perf_evlist__close(evlist);
 	errno = -err;
 	return err;
 }
diff --git a/tools/perf/util/evlist.h b/tools/perf/util/evlist.h
index c096da7d6d58..0583d36252be 100644
--- a/tools/perf/util/evlist.h
+++ b/tools/perf/util/evlist.h
@@ -81,6 +81,7 @@ struct perf_evsel *perf_evlist__id2evsel(struct perf_evlist *evlist, u64 id);
 union perf_event *perf_evlist__mmap_read(struct perf_evlist *self, int idx);
 
 int perf_evlist__open(struct perf_evlist *evlist);
+void perf_evlist__close(struct perf_evlist *evlist);
 
 void perf_evlist__config(struct perf_evlist *evlist,
 			 struct perf_record_opts *opts);
-- 
1.7.11.7

