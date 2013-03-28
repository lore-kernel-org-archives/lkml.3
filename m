Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756891Ab3C1RCx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Mar 2013 13:02:53 -0400
Received: from 173-166-109-252-newengland.hfc.comcastbusiness.net ([173.166.109.252]:47741
	"EHLO bombadil.infradead.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756786Ab3C1RCu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Mar 2013 13:02:50 -0400
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org, Namhyung Kim <namhyung.kim@lge.com>,
        Namhyung Kim <namhyung@kernel.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Steven Rostedt <rostedt@goodmis.org>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 09/36] perf tools: Get rid of die() calls in trace-data-read.c
Date: Thu, 28 Mar 2013 14:02:09 -0300
Message-Id: <1364490156-32064-10-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.8.1.1.361.gec3ae6e
In-Reply-To: <1364490156-32064-1-git-send-email-acme@infradead.org>
References: <1364490156-32064-1-git-send-email-acme@infradead.org>
Content-Type: text/plain; charset="utf-8"
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Namhyung Kim <namhyung.kim@lge.com>

Convert them to pr_debug() and propagate error code.

Signed-off-by: Namhyung Kim <namhyung@kernel.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Steven Rostedt <rostedt@goodmis.org>
Link: http://lkml.kernel.org/r/1363850332-25297-9-git-send-email-namhyung@kernel.org
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/util/trace-event-read.c |   44 +++++++++++++++++++++++------------
 1 files changed, 29 insertions(+), 15 deletions(-)

diff --git a/tools/perf/util/trace-event-read.c b/tools/perf/util/trace-event-read.c
index 877706b..644ad3b 100644
--- a/tools/perf/util/trace-event-read.c
+++ b/tools/perf/util/trace-event-read.c
@@ -130,17 +130,23 @@ static char *read_string(void)
 
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
@@ -155,7 +161,7 @@ static char *read_string(void)
 	str = malloc(size);
 	if (str)
 		memcpy(str, buf, size);
-
+out:
 	return str;
 }
 
@@ -219,8 +225,10 @@ static int read_header_files(struct pevent *pevent)
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
@@ -234,8 +242,10 @@ static int read_header_files(struct pevent *pevent)
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
@@ -353,13 +363,17 @@ ssize_t trace_report(int fd, struct pevent **ppevent, bool __repipe)
 
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
1.7.1

