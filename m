Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761314Ab3DBJbg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Apr 2013 05:31:36 -0400
Received: from terminus.zytor.com ([198.137.202.10]:50707 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751983Ab3DBJbc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Apr 2013 05:31:32 -0400
Date: Tue, 2 Apr 2013 02:31:10 -0700
From: tip-bot for Namhyung Kim <tipbot@zytor.com>
Message-ID: <tip-452958fdd05b43b6c91cfd1341f4fac2f3ce661f@git.kernel.org>
Cc: acme@redhat.com, linux-kernel@vger.kernel.org, paulus@samba.org,
        hpa@zytor.com, mingo@kernel.org, a.p.zijlstra@chello.nl,
        namhyung.kim@lge.com, namhyung@kernel.org, fweisbec@gmail.com,
        rostedt@goodmis.org, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, paulus@samba.org,
        linux-kernel@vger.kernel.org, acme@redhat.com, a.p.zijlstra@chello.nl,
        namhyung.kim@lge.com, namhyung@kernel.org, fweisbec@gmail.com,
        rostedt@goodmis.org, tglx@linutronix.de
In-Reply-To: <1363850332-25297-9-git-send-email-namhyung@kernel.org>
References: <1363850332-25297-9-git-send-email-namhyung@kernel.org>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf tools: Get rid of die()
  calls in trace-data-read.c
Git-Commit-ID: 452958fdd05b43b6c91cfd1341f4fac2f3ce661f
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.7 (terminus.zytor.com [127.0.0.1]); Tue, 02 Apr 2013 02:31:16 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  452958fdd05b43b6c91cfd1341f4fac2f3ce661f
Gitweb:     http://git.kernel.org/tip/452958fdd05b43b6c91cfd1341f4fac2f3ce661f
Author:     Namhyung Kim <namhyung.kim@lge.com>
AuthorDate: Thu, 21 Mar 2013 16:18:51 +0900
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Thu, 21 Mar 2013 13:37:13 -0300

perf tools: Get rid of die() calls in trace-data-read.c

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
 tools/perf/util/trace-event-read.c | 44 +++++++++++++++++++++++++-------------
 1 file changed, 29 insertions(+), 15 deletions(-)

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
