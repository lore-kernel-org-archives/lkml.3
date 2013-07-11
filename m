Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752989Ab3GKQ0z (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Jul 2013 12:26:55 -0400
Received: from mail-pa0-f41.google.com ([209.85.220.41]:38728 "EHLO
	mail-pa0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752193Ab3GKQ0x (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Jul 2013 12:26:53 -0400
From: David Ahern <dsahern@gmail.com>
To: acme@ghostprotocols.net, linux-kernel@vger.kernel.org
Cc: David Ahern <dsahern@gmail.com>, Ingo Molnar <mingo@kernel.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Peter Zijlstra <peterz@infradead.org>, Jiri Olsa <jolsa@redhat.com>,
        Namhyung Kim <namhyung@kernel.org>,
        Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>,
        Runzhen Wang <runzhen@linux.vnet.ibm.com>
Subject: [PATCH 02/11] perf evlist: move tracepoint processing code to evlist.c
Date: Thu, 11 Jul 2013 10:26:33 -0600
Message-Id: <1373560002-14618-3-git-send-email-dsahern@gmail.com>
X-Mailer: git-send-email 1.7.10.1
In-Reply-To: <1373560002-14618-1-git-send-email-dsahern@gmail.com>
References: <1373560002-14618-1-git-send-email-dsahern@gmail.com>
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
 tools/perf/util/evlist.c |   39 +++++++++++++++++++++++++++++++++++++++
 tools/perf/util/evlist.h |    4 ++++
 tools/perf/util/header.c |   44 --------------------------------------------
 3 files changed, 43 insertions(+), 44 deletions(-)

diff --git a/tools/perf/util/evlist.c b/tools/perf/util/evlist.c
index e666846..c4d371c 100644
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
index a5b1880..8438100 100644
--- a/tools/perf/util/evlist.h
+++ b/tools/perf/util/evlist.h
@@ -5,6 +5,7 @@
 #include <stdio.h>
 #include "../perf.h"
 #include "event.h"
+#include "trace-event.h"
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
index d12d79c..cd563ca 100644
--- a/tools/perf/util/header.c
+++ b/tools/perf/util/header.c
@@ -2728,50 +2728,6 @@ static int read_attr(int fd, struct perf_header *ph,
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
-- 
1.7.10.1

