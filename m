Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934103Ab3GQRu7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Jul 2013 13:50:59 -0400
Received: from mx1.redhat.com ([209.132.183.28]:32825 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934044Ab3GQRu4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Jul 2013 13:50:56 -0400
From: Jiri Olsa <jolsa@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: Jiri Olsa <jolsa@redhat.com>, Corey Ashford <cjashfor@linux.vnet.ibm.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@elte.hu>,
        Namhyung Kim <namhyung@kernel.org>, Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Andi Kleen <ak@linux.intel.com>, David Ahern <dsahern@gmail.com>
Subject: [PATCH 12/23] perf tools: Using evlist as a holder for event_desc feature
Date: Wed, 17 Jul 2013 19:49:52 +0200
Message-Id: <1374083403-14591-13-git-send-email-jolsa@redhat.com>
In-Reply-To: <1374083403-14591-1-git-send-email-jolsa@redhat.com>
References: <1374083403-14591-1-git-send-email-jolsa@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Using evlist as a holder for events stored via event_desc
feature. The event_desc events data is same as the one
stored via main header. We will use event_desc data to
replace the main header data source in next patches.

Signed-off-by: Jiri Olsa <jolsa@redhat.com>
Cc: Corey Ashford <cjashfor@linux.vnet.ibm.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: Andi Kleen <ak@linux.intel.com>
Cc: David Ahern <dsahern@gmail.com>
---
 tools/perf/util/header.c | 84 ++++++++++++++++++++++--------------------------
 1 file changed, 38 insertions(+), 46 deletions(-)

diff --git a/tools/perf/util/header.c b/tools/perf/util/header.c
index 17084a1..65e44cc 100644
--- a/tools/perf/util/header.c
+++ b/tools/perf/util/header.c
@@ -1205,28 +1205,11 @@ static void print_cpu_topology(struct perf_header *ph, int fd __maybe_unused,
 	}
 }
 
-static void free_event_desc(struct perf_evsel *events)
-{
-	struct perf_evsel *evsel;
-
-	if (!events)
-		return;
-
-	for (evsel = events; evsel->attr.size; evsel++) {
-		if (evsel->name)
-			free(evsel->name);
-		if (evsel->id)
-			free(evsel->id);
-	}
-
-	free(events);
-}
-
-static struct perf_evsel *
+static struct perf_evlist *
 read_event_desc(struct perf_header *ph, int fd)
 {
-	struct perf_evsel *evsel, *events = NULL;
-	u64 *id;
+	struct perf_evlist *evlist = NULL;
+	struct perf_evsel *evsel;
 	void *buf = NULL;
 	u32 nre, sz, nr, i, j;
 	ssize_t ret;
@@ -1252,18 +1235,15 @@ read_event_desc(struct perf_header *ph, int fd)
 	if (!buf)
 		goto error;
 
-	/* the last event terminates with evsel->attr.size == 0: */
-	events = calloc(nre + 1, sizeof(*events));
-	if (!events)
+	evlist = perf_evlist__new();
+	if (!evlist)
 		goto error;
 
 	msz = sizeof(evsel->attr);
 	if (sz < msz)
 		msz = sz;
 
-	for (i = 0, evsel = events; i < nre; evsel++, i++) {
-		evsel->idx = i;
-
+	for (i = 0; i < nre; i++) {
 		/*
 		 * must read entire on-file attr struct to
 		 * sync up with layout.
@@ -1272,6 +1252,10 @@ read_event_desc(struct perf_header *ph, int fd)
 		if (ret != (ssize_t)sz)
 			goto error;
 
+		evsel = perf_evsel__new(buf, i);
+		if (!evsel)
+			goto error;
+
 		if (ph->needs_swap)
 			perf_event__attr_swap(buf);
 
@@ -1286,49 +1270,55 @@ read_event_desc(struct perf_header *ph, int fd)
 			evsel->needs_swap = true;
 		}
 
+		perf_evlist__add(evlist, evsel);
+
 		evsel->name = do_read_string(fd, ph);
 
 		if (!nr)
 			continue;
 
-		id = calloc(nr, sizeof(*id));
-		if (!id)
+		if (perf_evsel__alloc_id(evsel, 1, nr))
 			goto error;
+
 		evsel->ids = nr;
-		evsel->id = id;
 
 		for (j = 0 ; j < nr; j++) {
-			ret = readn(fd, id, sizeof(*id));
-			if (ret != (ssize_t)sizeof(*id))
+			u64 id;
+
+			ret = readn(fd, &id, sizeof(id));
+			if (ret != (ssize_t)sizeof(id))
 				goto error;
 			if (ph->needs_swap)
-				*id = bswap_64(*id);
-			id++;
+				id = bswap_64(id);
+
+			perf_evlist__id_add(evlist, evsel, 0, j, id);
 		}
 	}
 out:
 	if (buf)
 		free(buf);
-	return events;
+	return evlist;
 error:
-	if (events)
-		free_event_desc(events);
-	events = NULL;
+	if (evlist)
+		perf_evlist__delete(evlist);
+	evlist = NULL;
 	goto out;
 }
 
 static void print_event_desc(struct perf_header *ph, int fd, FILE *fp)
 {
-	struct perf_evsel *evsel, *events = read_event_desc(ph, fd);
+	struct perf_evlist *evlist;
+	struct perf_evsel *evsel;
 	u32 j;
 	u64 *id;
 
-	if (!events) {
+	evlist = read_event_desc(ph, fd);
+	if (!evlist) {
 		fprintf(fp, "# event desc: not available or unable to read\n");
 		return;
 	}
 
-	for (evsel = events; evsel->attr.size; evsel++) {
+	list_for_each_entry(evsel, &evlist->entries, node) {
 		fprintf(fp, "# event : name = %s, ", evsel->name);
 
 		fprintf(fp, "type = %d, config = 0x%"PRIx64
@@ -1361,7 +1351,7 @@ static void print_event_desc(struct perf_header *ph, int fd, FILE *fp)
 		fputc('\n', fp);
 	}
 
-	free_event_desc(events);
+	perf_evlist__delete(evlist);
 }
 
 static void print_total_mem(struct perf_header *ph, int fd __maybe_unused,
@@ -1782,17 +1772,19 @@ process_event_desc(struct perf_file_section *section __maybe_unused,
 		   void *data __maybe_unused)
 {
 	struct perf_session *session;
-	struct perf_evsel *evsel, *events = read_event_desc(header, fd);
+	struct perf_evlist *evlist;
+	struct perf_evsel *evsel;
 
-	if (!events)
+	evlist = read_event_desc(header, fd);
+	if (!evlist)
 		return 0;
 
 	session = container_of(header, struct perf_session, header);
-	for (evsel = events; evsel->attr.size; evsel++)
-		perf_evlist__set_event_name(session->evlist, evsel);
 
-	free_event_desc(events);
+	list_for_each_entry(evsel, &evlist->entries, node)
+		perf_evlist__set_event_name(session->evlist, evsel);
 
+	perf_evlist__delete(evlist);
 	return 0;
 }
 
-- 
1.7.11.7

