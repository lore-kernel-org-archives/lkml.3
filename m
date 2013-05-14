Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757243Ab3ENKR4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 May 2013 06:17:56 -0400
Received: from LGEMRELSE7Q.lge.com ([156.147.1.151]:53910 "EHLO
	LGEMRELSE7Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756362Ab3ENKOD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 May 2013 06:14:03 -0400
X-AuditID: 9c930197-b7b76ae000003523-30-51920e69e605
From: Namhyung Kim <namhyung@kernel.org>
To: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Paul Mackerras <paulus@samba.org>,
        Ingo Molnar <mingo@kernel.org>, Namhyung Kim <namhyung.kim@lge.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Frederic Weisbecker <fweisbec@gmail.com>, Jiri Olsa <jolsa@redhat.com>,
        David Ahern <dsahern@gmail.com>, Stephane Eranian <eranian@google.com>
Subject: [PATCH 04/15] perf util: Add more debug message on failure path
Date: Tue, 14 May 2013 19:13:48 +0900
Message-Id: <1368526439-31966-5-git-send-email-namhyung@kernel.org>
X-Mailer: git-send-email 1.7.11.7
In-Reply-To: <1368526439-31966-1-git-send-email-namhyung@kernel.org>
References: <1368526439-31966-1-git-send-email-namhyung@kernel.org>
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Namhyung Kim <namhyung.kim@lge.com>

It's helpful for debugging on tracing features.

Signed-off-by: Namhyung Kim <namhyung@kernel.org>
---
 tools/perf/util/header.c           |  4 ++-
 tools/perf/util/trace-event-read.c | 53 ++++++++++++++++++++++++++------------
 2 files changed, 39 insertions(+), 18 deletions(-)

diff --git a/tools/perf/util/header.c b/tools/perf/util/header.c
index 326068a593a5..31bd962801a1 100644
--- a/tools/perf/util/header.c
+++ b/tools/perf/util/header.c
@@ -2756,8 +2756,10 @@ static int perf_evsel__prepare_tracepoint_event(struct perf_evsel *evsel,
 	}
 
 	event = pevent_find_event(pevent, evsel->attr.config);
-	if (event == NULL)
+	if (event == NULL) {
+		pr_debug("cannot find event format for %d\n", (int)evsel->attr.config);
 		return -1;
+	}
 
 	if (!evsel->name) {
 		snprintf(bf, sizeof(bf), "%s:%s", event->system, event->name);
diff --git a/tools/perf/util/trace-event-read.c b/tools/perf/util/trace-event-read.c
index e084e5e654b6..0e3b3f527320 100644
--- a/tools/perf/util/trace-event-read.c
+++ b/tools/perf/util/trace-event-read.c
@@ -262,39 +262,53 @@ static int read_header_files(struct pevent *pevent)
 
 static int read_ftrace_file(struct pevent *pevent, unsigned long long size)
 {
+	int ret;
 	char *buf;
 
 	buf = malloc(size);
-	if (buf == NULL)
+	if (buf == NULL) {
+		pr_debug("memory allocation failure\n");
 		return -1;
+	}
 
-	if (do_read(buf, size) < 0) {
-		free(buf);
-		return -1;
+	ret = do_read(buf, size);
+	if (ret < 0) {
+		pr_debug("error reading ftrace file.\n");
+		goto out;
 	}
 
-	parse_ftrace_file(pevent, buf, size);
+	ret = parse_ftrace_file(pevent, buf, size);
+	if (ret < 0)
+		pr_debug("error parsing ftrace file.\n");
+out:
 	free(buf);
-	return 0;
+	return ret;
 }
 
 static int read_event_file(struct pevent *pevent, char *sys,
 			    unsigned long long size)
 {
+	int ret;
 	char *buf;
 
 	buf = malloc(size);
-	if (buf == NULL)
+	if (buf == NULL) {
+		pr_debug("memory allocation failure\n");
 		return -1;
+	}
 
-	if (do_read(buf, size) < 0) {
+	ret = do_read(buf, size);
+	if (ret < 0) {
 		free(buf);
-		return -1;
+		goto out;
 	}
 
-	parse_event_file(pevent, buf, size, sys);
+	ret = parse_event_file(pevent, buf, size, sys);
+	if (ret < 0)
+		pr_debug("error parsing event file.\n");
+out:
 	free(buf);
-	return 0;
+	return ret;
 }
 
 static int read_ftrace_files(struct pevent *pevent)
@@ -347,6 +361,7 @@ static int read_saved_cmdline(struct pevent *pevent)
 {
 	unsigned long long size;
 	char *buf;
+	int ret;
 
 	/* it can have 0 size */
 	size = read8(pevent);
@@ -354,18 +369,22 @@ static int read_saved_cmdline(struct pevent *pevent)
 		return 0;
 
 	buf = malloc(size + 1);
-	if (buf == NULL)
+	if (buf == NULL) {
+		pr_debug("memory allocation failure\n");
 		return -1;
+	}
 
-	if (do_read(buf, size) < 0) {
-		free(buf);
-		return -1;
+	ret = do_read(buf, size);
+	if (ret < 0) {
+		pr_debug("error reading saved cmdlines\n");
+		goto out;
 	}
 
 	parse_saved_cmdline(pevent, buf, size);
-
+	ret = 0;
+out:
 	free(buf);
-	return 0;
+	return ret;
 }
 
 ssize_t trace_report(int fd, struct pevent **ppevent, bool __repipe)
-- 
1.7.11.7

