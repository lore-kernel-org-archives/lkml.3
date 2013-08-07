Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933674Ab3HGVW3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Aug 2013 17:22:29 -0400
Received: from merlin.infradead.org ([205.233.59.134]:47014 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933371Ab3HGVL1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Aug 2013 17:11:27 -0400
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org, Jiri Olsa <jolsa@redhat.com>,
        Corey Ashford <cjashfor@linux.vnet.ibm.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Namhyung Kim <namhyung@kernel.org>, Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 06/47] perf evlist: Add perf_evlist__id2sid method to get event ID related data
Date: Wed,  7 Aug 2013 18:10:33 -0300
Message-Id: <1375909874-22073-7-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.8.1.4
In-Reply-To: <1375909874-22073-1-git-send-email-acme@infradead.org>
References: <1375909874-22073-1-git-send-email-acme@infradead.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by merlin.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jiri Olsa <jolsa@redhat.com>

This will be helpful for PERF_FORMAT_GROUP samples where we need to
store ID related period value for each event.

Signed-off-by: Jiri Olsa <jolsa@redhat.com>
Acked-by: Namhyung Kim <namhyung@kernel.org>
Cc: Corey Ashford <cjashfor@linux.vnet.ibm.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Link: http://lkml.kernel.org/n/tip-twmlgsbyim97p7cyohjwb1df@git.kernel.org
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/util/evlist.c | 21 ++++++++++++++++-----
 tools/perf/util/evlist.h |  2 ++
 2 files changed, 18 insertions(+), 5 deletions(-)

diff --git a/tools/perf/util/evlist.c b/tools/perf/util/evlist.c
index 10fcc03..da2dd92 100644
--- a/tools/perf/util/evlist.c
+++ b/tools/perf/util/evlist.c
@@ -337,21 +337,32 @@ static int perf_evlist__id_add_fd(struct perf_evlist *evlist,
 	return 0;
 }
 
-struct perf_evsel *perf_evlist__id2evsel(struct perf_evlist *evlist, u64 id)
+struct perf_sample_id *perf_evlist__id2sid(struct perf_evlist *evlist, u64 id)
 {
 	struct hlist_head *head;
 	struct perf_sample_id *sid;
 	int hash;
 
-	if (evlist->nr_entries == 1)
-		return perf_evlist__first(evlist);
-
 	hash = hash_64(id, PERF_EVLIST__HLIST_BITS);
 	head = &evlist->heads[hash];
 
 	hlist_for_each_entry(sid, head, node)
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
index c7178b7..327abab 100644
--- a/tools/perf/util/evlist.h
+++ b/tools/perf/util/evlist.h
@@ -78,6 +78,8 @@ void perf_evlist__add_pollfd(struct perf_evlist *evlist, int fd);
 
 struct perf_evsel *perf_evlist__id2evsel(struct perf_evlist *evlist, u64 id);
 
+struct perf_sample_id *perf_evlist__id2sid(struct perf_evlist *evlist, u64 id);
+
 union perf_event *perf_evlist__mmap_read(struct perf_evlist *self, int idx);
 
 int perf_evlist__open(struct perf_evlist *evlist);
-- 
1.8.1.4

