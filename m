Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758662Ab3EZA3e (ORCPT <rfc822;w@1wt.eu>);
	Sat, 25 May 2013 20:29:34 -0400
Received: from mail-pb0-f51.google.com ([209.85.160.51]:57771 "EHLO
	mail-pb0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758507Ab3EZA0c (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 25 May 2013 20:26:32 -0400
From: David Ahern <dsahern@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: acme@ghostprotocols.net, mingo@kernel.org, fweisbec@gmail.com,
        peterz@infradead.org, jolsa@redhat.com, namhyung@kernel.org,
        xiaoguangrong@linux.vnet.ibm.com, runzhen@linux.vnet.ibm.com,
        David Ahern <dsahern@gmail.com>
Subject: [PATCH 03/16 v2] perf evlist: add initialzation function for tracepoints
Date: Sat, 25 May 2013 18:24:43 -0600
Message-Id: <1369527896-3650-4-git-send-email-dsahern@gmail.com>
X-Mailer: git-send-email 1.7.10.1
In-Reply-To: <1369527896-3650-1-git-send-email-dsahern@gmail.com>
References: <1369527896-3650-1-git-send-email-dsahern@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Handles initializations typically done as part of processing the file
header and HEADER_TRACING_DATA event.

v2: close fd as noticed by Namhyung.

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
 tools/perf/util/evlist.c |   35 +++++++++++++++++++++++++++++++++++
 tools/perf/util/evlist.h |    3 +++
 2 files changed, 38 insertions(+)

diff --git a/tools/perf/util/evlist.c b/tools/perf/util/evlist.c
index 72b9551..b686411 100644
--- a/tools/perf/util/evlist.c
+++ b/tools/perf/util/evlist.c
@@ -14,6 +14,7 @@
 #include "target.h"
 #include "evlist.h"
 #include "evsel.h"
+#include "trace-event.h"
 #include <unistd.h>
 
 #include "parse-events.h"
@@ -234,6 +235,40 @@ int perf_evlist__prepare_tracepoint_events(struct perf_evlist *evlist,
 	return 0;
 }
 
+int perf_evlist__trace_init(struct perf_evlist *evlist,
+			    struct perf_session *session)
+{
+	struct tracing_data *tdata;
+	char temp_file[] = "/tmp/perf-XXXXXXXX";
+	int fd;
+	int rc = 0;
+
+	fd = mkstemp(temp_file);
+	if (fd < 0) {
+		pr_err("mkstemp failed\n");
+		return -1;
+	}
+	unlink(temp_file);
+
+	tdata = tracing_data_get(&evlist->entries, fd, false);
+	if (!tdata) {
+		rc = -1;
+		goto out;
+	}
+
+	lseek(fd, 0, SEEK_SET);
+	(void) trace_report(fd, &session->pevent, false);
+	tracing_data_put(tdata);
+
+	rc = perf_evlist__prepare_tracepoint_events(evlist, session->pevent);
+
+out:
+	close(fd);
+
+	return rc;
+}
+
+
 static int trace_event__id(const char *evname)
 {
 	char *filename, *colon;
diff --git a/tools/perf/util/evlist.h b/tools/perf/util/evlist.h
index c2cf183..c579f3d 100644
--- a/tools/perf/util/evlist.h
+++ b/tools/perf/util/evlist.h
@@ -8,6 +8,7 @@
 #include "event-parse.h"
 #include "evsel.h"
 #include "util.h"
+#include "session.h"
 #include <unistd.h>
 
 struct pollfd;
@@ -66,6 +67,8 @@ int perf_evlist__prepare_tracepoint_events(struct perf_evlist *evlist,
 int perf_evlist__add_tracepoints(struct perf_evlist *evlist,
 				 const char * const tracepoints[],
 				 size_t nr_tracepoints);
+int perf_evlist__trace_init(struct perf_evlist *evlist,
+			    struct perf_session *session);
 
 #define perf_evlist__add_default_attrs(evlist, array) \
 	__perf_evlist__add_default_attrs(evlist, array, ARRAY_SIZE(array))
-- 
1.7.10.1

