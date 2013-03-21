Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932811Ab3CUHUl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Mar 2013 03:20:41 -0400
Received: from LGEMRELSE6Q.lge.com ([156.147.1.121]:57775 "EHLO
	LGEMRELSE6Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932584Ab3CUHTB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Mar 2013 03:19:01 -0400
X-AuditID: 9c930179-b7c78ae000000e4b-5a-514ab4621bbe
From: Namhyung Kim <namhyung@kernel.org>
To: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Paul Mackerras <paulus@samba.org>,
        Ingo Molnar <mingo@kernel.org>, Namhyung Kim <namhyung.kim@lge.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Frederic Weisbecker <fweisbec@gmail.com>
Subject: [PATCH 8/9] perf util: Get rid of die() calls in trace-data-read.c
Date: Thu, 21 Mar 2013 16:18:51 +0900
Message-Id: <1363850332-25297-9-git-send-email-namhyung@kernel.org>
X-Mailer: git-send-email 1.7.11.7
In-Reply-To: <1363850332-25297-1-git-send-email-namhyung@kernel.org>
References: <1363850332-25297-1-git-send-email-namhyung@kernel.org>
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Namhyung Kim <namhyung.kim@lge.com>

Convert them to pr_debug() and propagate error code.

Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Signed-off-by: Namhyung Kim <namhyung@kernel.org>
---
 tools/perf/util/trace-event-read.c | 44 +++++++++++++++++++++++++-------------
 1 file changed, 29 insertions(+), 15 deletions(-)

diff --git a/tools/perf/util/trace-event-read.c b/tools/perf/util/trace-event-read.c
index 3626f9d6e06e..5ca6c2cc4216 100644
--- a/tools/perf/util/trace-event-read.c
+++ b/tools/perf/util/trace-event-read.c
@@ -132,17 +132,23 @@ static char *read_string(void)
 
 	for (;;) {
 		r = read(input_fd, &c, 1);
-		if (r < 0)
-			die("reading input file");
+		if (r < 0) {
+			pr_debug("reading input file");
+			goto out;
+		}
 
-		if (!r)
-			die("no data");
+		if (!r) {
+			pr_debug("no data");
+			goto out;
+		}
 
 		if (repipe) {
 			int retw = write(STDOUT_FILENO, &c, 1);
 
-			if (retw <= 0 || retw != r)
-				die("repiping input file string");
+			if (retw <= 0 || retw != r) {
+				pr_debug("repiping input file string");
+				goto out;
+			}
 		}
 
 		buf[size++] = c;
@@ -157,7 +163,7 @@ static char *read_string(void)
 	str = malloc(size);
 	if (str)
 		memcpy(str, buf, size);
-
+out:
 	return str;
 }
 
@@ -221,8 +227,10 @@ static int read_header_files(struct pevent *pevent)
 	if (do_read(buf, 12) < 0)
 		return -1;
 
-	if (memcmp(buf, "header_page", 12) != 0)
-		die("did not read header page");
+	if (memcmp(buf, "header_page", 12) != 0) {
+		pr_debug("did not read header page");
+		return -1;
+	}
 
 	size = read8(pevent);
 	skip(size);
@@ -236,8 +244,10 @@ static int read_header_files(struct pevent *pevent)
 	if (do_read(buf, 13) < 0)
 		return -1;
 
-	if (memcmp(buf, "header_event", 13) != 0)
-		die("did not read header event");
+	if (memcmp(buf, "header_event", 13) != 0) {
+		pr_debug("did not read header event");
+		return -1;
+	}
 
 	size = read8(pevent);
 	header_event = malloc(size);
@@ -355,13 +365,17 @@ ssize_t trace_report(int fd, struct pevent **ppevent, bool __repipe)
 
 	if (do_read(buf, 3) < 0)
 		return -1;
-	if (memcmp(buf, test, 3) != 0)
-		die("no trace data in the file");
+	if (memcmp(buf, test, 3) != 0) {
+		pr_debug("no trace data in the file");
+		return -1;
+	}
 
 	if (do_read(buf, 7) < 0)
 		return -1;
-	if (memcmp(buf, "tracing", 7) != 0)
-		die("not a trace file (missing 'tracing' tag)");
+	if (memcmp(buf, "tracing", 7) != 0) {
+		pr_debug("not a trace file (missing 'tracing' tag)");
+		return -1;
+	}
 
 	version = read_string();
 	if (version == NULL)
-- 
1.7.11.7

