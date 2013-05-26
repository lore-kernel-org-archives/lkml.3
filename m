Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758526Ab3EZA0d (ORCPT <rfc822;w@1wt.eu>);
	Sat, 25 May 2013 20:26:33 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:38521 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758449Ab3EZA03 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 25 May 2013 20:26:29 -0400
From: David Ahern <dsahern@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: acme@ghostprotocols.net, mingo@kernel.org, fweisbec@gmail.com,
        peterz@infradead.org, jolsa@redhat.com, namhyung@kernel.org,
        xiaoguangrong@linux.vnet.ibm.com, runzhen@linux.vnet.ibm.com,
        David Ahern <dsahern@gmail.com>
Subject: [PATCH 02/16] perf evlist: move tracepoint processing code to evlist.c
Date: Sat, 25 May 2013 18:24:42 -0600
Message-Id: <1369527896-3650-3-git-send-email-dsahern@gmail.com>
X-Mailer: git-send-email 1.7.10.1
In-Reply-To: <1369527896-3650-1-git-send-email-dsahern@gmail.com>
References: <1369527896-3650-1-git-send-email-dsahern@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Per function names they are more aligned with the evlist code than
the header code. Export perf_evlist__prepare_tracepoint_events
in the process.

Code move only; no functional changes.

Signed-off-by: David Ahern <dsahern@gmail.com>
Cc: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
Cc: Runzhen Wang <runzhen@linux.vnet.ibm.com>
---
 tools/perf/util/evlist.c  |   39 +++++++++++++++++++++++++++++++++++++++
 tools/perf/util/evlist.h  |    4 ++++
 tools/perf/util/header.c  |   44 --------------------------------------------
 tools/perf/util/session.c |    1 -
 4 files changed, 43 insertions(+), 45 deletions(-)

diff --git a/tools/perf/util/evlist.c b/tools/perf/util/evlist.c
index 1cf14eb..72b9551 100644
--- a/tools/perf/util/evlist.c
+++ b/tools/perf/util/evlist.c
@@ -195,6 +195,45 @@ int __perf_evlist__add_default_attrs(struct perf_evlist *evlist,
 	return perf_evlist__add_attrs(evlist, attrs, nr_attrs);
 }
 
+static int perf_evsel__prepare_tracepoint_event(struct perf_evsel *evsel,
+						struct pevent *pevent)
+{
+	struct event_format *event;
+	char bf[128];
+
+	/* already prepared */
+	if (evsel->tp_format)
+		return 0;
+
+	event = pevent_find_event(pevent, evsel->attr.config);
+	if (event == NULL)
+		return -1;
+
+	if (!evsel->name) {
+		snprintf(bf, sizeof(bf), "%s:%s", event->system, event->name);
+		evsel->name = strdup(bf);
+		if (evsel->name == NULL)
+			return -1;
+	}
+
+	evsel->tp_format = event;
+	return 0;
+}
+
+int perf_evlist__prepare_tracepoint_events(struct perf_evlist *evlist,
+						  struct pevent *pevent)
+{
+	struct perf_evsel *pos;
+
+	list_for_each_entry(pos, &evlist->entries, node) {
+		if (pos->attr.type == PERF_TYPE_TRACEPOINT &&
+		    perf_evsel__prepare_tracepoint_event(pos, pevent))
+			return -1;
+	}
+
+	return 0;
+}
+
 static int trace_event__id(const char *evname)
 {
 	char *filename, *colon;
diff --git a/tools/perf/util/evlist.h b/tools/perf/util/evlist.h
index a5b1880..c2cf183 100644
--- a/tools/perf/util/evlist.h
+++ b/tools/perf/util/evlist.h
@@ -5,6 +5,7 @@
 #include <stdio.h>
 #include "../perf.h"
 #include "event.h"
+#include "event-parse.h"
 #include "evsel.h"
 #include "util.h"
 #include <unistd.h>
@@ -59,6 +60,9 @@ void perf_evlist__add(struct perf_evlist *evlist, struct perf_evsel *entry);
 int perf_evlist__add_default(struct perf_evlist *evlist);
 int __perf_evlist__add_default_attrs(struct perf_evlist *evlist,
 				     struct perf_event_attr *attrs, size_t nr_attrs);
+int perf_evlist__prepare_tracepoint_events(struct perf_evlist *evlist,
+					   struct pevent *pevent);
+
 int perf_evlist__add_tracepoints(struct perf_evlist *evlist,
 				 const char * const tracepoints[],
 				 size_t nr_tracepoints);
diff --git a/tools/perf/util/header.c b/tools/perf/util/header.c
index 326068a..0e04f7ae 100644
--- a/tools/perf/util/header.c
+++ b/tools/perf/util/header.c
@@ -2740,50 +2740,6 @@ static int read_attr(int fd, struct perf_header *ph,
 	return ret <= 0 ? -1 : 0;
 }
 
-static int perf_evsel__prepare_tracepoint_event(struct perf_evsel *evsel,
-						struct pevent *pevent)
-{
-	struct event_format *event;
-	char bf[128];
-
-	/* already prepared */
-	if (evsel->tp_format)
-		return 0;
-
-	if (pevent == NULL) {
-		pr_debug("broken or missing trace data\n");
-		return -1;
-	}
-
-	event = pevent_find_event(pevent, evsel->attr.config);
-	if (event == NULL)
-		return -1;
-
-	if (!evsel->name) {
-		snprintf(bf, sizeof(bf), "%s:%s", event->system, event->name);
-		evsel->name = strdup(bf);
-		if (evsel->name == NULL)
-			return -1;
-	}
-
-	evsel->tp_format = event;
-	return 0;
-}
-
-static int perf_evlist__prepare_tracepoint_events(struct perf_evlist *evlist,
-						  struct pevent *pevent)
-{
-	struct perf_evsel *pos;
-
-	list_for_each_entry(pos, &evlist->entries, node) {
-		if (pos->attr.type == PERF_TYPE_TRACEPOINT &&
-		    perf_evsel__prepare_tracepoint_event(pos, pevent))
-			return -1;
-	}
-
-	return 0;
-}
-
 int perf_session__read_header(struct perf_session *session, int fd)
 {
 	struct perf_header *header = &session->header;
diff --git a/tools/perf/util/session.c b/tools/perf/util/session.c
index cf1fe01..7e2c4c7 100644
--- a/tools/perf/util/session.c
+++ b/tools/perf/util/session.c
@@ -12,7 +12,6 @@
 #include "sort.h"
 #include "util.h"
 #include "cpumap.h"
-#include "event-parse.h"
 #include "perf_regs.h"
 #include "vdso.h"
 
-- 
1.7.10.1

