Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754979Ab3BDMdi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Feb 2013 07:33:38 -0500
Received: from mx1.redhat.com ([209.132.183.28]:38877 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753814Ab3BDMdg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Feb 2013 07:33:36 -0500
From: Jiri Olsa <jolsa@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: Jiri Olsa <jolsa@redhat.com>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>, Ingo Molnar <mingo@elte.hu>,
        Paul Mackerras <paulus@samba.org>,
        Corey Ashford <cjashfor@linux.vnet.ibm.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Namhyung Kim <namhyung@kernel.org>
Subject: [PATCH 07/11] perf tools: Add perf_evlist__id2sid function to get event ID related data
Date: Mon,  4 Feb 2013 13:33:01 +0100
Message-Id: <1359981185-16819-8-git-send-email-jolsa@redhat.com>
In-Reply-To: <1359981185-16819-1-git-send-email-jolsa@redhat.com>
References: <1359981185-16819-1-git-send-email-jolsa@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Adding perf_evlist__id2sid function to be able to get ID related
data. This will be helpful for PERF_FORMAT_GROUP samples where
we need to store ID related period value for each event.

Signed-off-by: Jiri Olsa <jolsa@redhat.com>
Cc: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Corey Ashford <cjashfor@linux.vnet.ibm.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Namhyung Kim <namhyung@kernel.org>
---
 tools/perf/util/evlist.c | 21 ++++++++++++++++-----
 tools/perf/util/evlist.h |  2 ++
 2 files changed, 18 insertions(+), 5 deletions(-)

diff --git a/tools/perf/util/evlist.c b/tools/perf/util/evlist.c
index 8789adf..b7565ad 100644
--- a/tools/perf/util/evlist.c
+++ b/tools/perf/util/evlist.c
@@ -335,22 +335,33 @@ static int perf_evlist__id_add_fd(struct perf_evlist *evlist,
 	return 0;
 }
 
-struct perf_evsel *perf_evlist__id2evsel(struct perf_evlist *evlist, u64 id)
+struct perf_sample_id *perf_evlist__id2sid(struct perf_evlist *evlist, u64 id)
 {
 	struct hlist_head *head;
 	struct hlist_node *pos;
 	struct perf_sample_id *sid;
 	int hash;
 
-	if (evlist->nr_entries == 1)
-		return perf_evlist__first(evlist);
-
 	hash = hash_64(id, PERF_EVLIST__HLIST_BITS);
 	head = &evlist->heads[hash];
 
 	hlist_for_each_entry(sid, pos, head, node)
 		if (sid->id == id)
-			return sid->evsel;
+			return sid;
+
+	return NULL;
+}
+
+struct perf_evsel *perf_evlist__id2evsel(struct perf_evlist *evlist, u64 id)
+{
+	struct perf_sample_id *sid;
+
+	if (evlist->nr_entries == 1)
+		return perf_evlist__first(evlist);
+
+	sid = perf_evlist__id2sid(evlist, id);
+	if (sid)
+		return sid->evsel;
 
 	if (!perf_evlist__sample_id_all(evlist))
 		return perf_evlist__first(evlist);
diff --git a/tools/perf/util/evlist.h b/tools/perf/util/evlist.h
index 0b7297c..565f114 100644
--- a/tools/perf/util/evlist.h
+++ b/tools/perf/util/evlist.h
@@ -73,6 +73,8 @@ void perf_evlist__add_pollfd(struct perf_evlist *evlist, int fd);
 
 struct perf_evsel *perf_evlist__id2evsel(struct perf_evlist *evlist, u64 id);
 
+struct perf_sample_id *perf_evlist__id2sid(struct perf_evlist *evlist, u64 id);
+
 union perf_event *perf_evlist__mmap_read(struct perf_evlist *self, int idx);
 
 int perf_evlist__open(struct perf_evlist *evlist);
-- 
1.7.11.7

