Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757507Ab3C1RLs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Mar 2013 13:11:48 -0400
Received: from 173-166-109-252-newengland.hfc.comcastbusiness.net ([173.166.109.252]:47729
	"EHLO bombadil.infradead.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756592Ab3C1RCt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Mar 2013 13:02:49 -0400
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org, Namhyung Kim <namhyung.kim@lge.com>,
        Namhyung Kim <namhyung@kernel.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Steven Rostedt <rostedt@goodmis.org>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 08/36] perf tools: Get rid of read_or_die() in trace-event-read.c
Date: Thu, 28 Mar 2013 14:02:08 -0300
Message-Id: <1364490156-32064-9-git-send-email-acme@infradead.org>
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

Rename it to do_read and original do_read to __do_read, and check
their return value.

Signed-off-by: Namhyung Kim <namhyung@kernel.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Steven Rostedt <rostedt@goodmis.org>
Link: http://lkml.kernel.org/r/1363850332-25297-8-git-send-email-namhyung@kernel.org
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/util/trace-event-read.c |   80 +++++++++++++++++++++++++----------
 1 files changed, 57 insertions(+), 23 deletions(-)

diff --git a/tools/perf/util/trace-event-read.c b/tools/perf/util/trace-event-read.c
index 22ded80..877706b 100644
--- a/tools/perf/util/trace-event-read.c
+++ b/tools/perf/util/trace-event-read.c
@@ -46,7 +46,7 @@ static int long_size;
 static ssize_t calc_data_size;
 static bool repipe;
 
-static int do_read(int fd, void *buf, int size)
+static int __do_read(int fd, void *buf, int size)
 {
 	int rsize = size;
 
@@ -59,8 +59,10 @@ static int do_read(int fd, void *buf, int size)
 		if (repipe) {
 			int retw = write(STDOUT_FILENO, buf, ret);
 
-			if (retw <= 0 || retw != ret)
-				die("repiping input file");
+			if (retw <= 0 || retw != ret) {
+				pr_debug("repiping input file");
+				return -1;
+			}
 		}
 
 		size -= ret;
@@ -70,14 +72,16 @@ static int do_read(int fd, void *buf, int size)
 	return rsize;
 }
 
-static int read_or_die(void *data, int size)
+static int do_read(void *data, int size)
 {
 	int r;
 
-	r = do_read(input_fd, data, size);
-	if (r <= 0)
-		die("reading input file (size expected=%d received=%d)",
-		    size, r);
+	r = __do_read(input_fd, data, size);
+	if (r <= 0) {
+		pr_debug("reading input file (size expected=%d received=%d)",
+			 size, r);
+		return -1;
+	}
 
 	if (calc_data_size)
 		calc_data_size += r;
@@ -93,7 +97,7 @@ static void skip(int size)
 
 	while (size) {
 		r = size > BUFSIZ ? BUFSIZ : size;
-		read_or_die(buf, r);
+		do_read(buf, r);
 		size -= r;
 	};
 }
@@ -102,7 +106,8 @@ static unsigned int read4(struct pevent *pevent)
 {
 	unsigned int data;
 
-	read_or_die(&data, 4);
+	if (do_read(&data, 4) < 0)
+		return 0;
 	return __data2host4(pevent, data);
 }
 
@@ -110,7 +115,8 @@ static unsigned long long read8(struct pevent *pevent)
 {
 	unsigned long long data;
 
-	read_or_die(&data, 8);
+	if (do_read(&data, 8) < 0)
+		return 0;
 	return __data2host8(pevent, data);
 }
 
@@ -166,7 +172,10 @@ static int read_proc_kallsyms(struct pevent *pevent)
 	if (buf == NULL)
 		return -1;
 
-	read_or_die(buf, size);
+	if (do_read(buf, size) < 0) {
+		free(buf);
+		return -1;
+	}
 	buf[size] = '\0';
 
 	parse_proc_kallsyms(pevent, buf, size);
@@ -180,6 +189,7 @@ static int read_ftrace_printk(struct pevent *pevent)
 	unsigned int size;
 	char *buf;
 
+	/* it can have 0 size */
 	size = read4(pevent);
 	if (!size)
 		return 0;
@@ -188,7 +198,10 @@ static int read_ftrace_printk(struct pevent *pevent)
 	if (buf == NULL)
 		return -1;
 
-	read_or_die(buf, size);
+	if (do_read(buf, size) < 0) {
+		free(buf);
+		return -1;
+	}
 
 	parse_ftrace_printk(pevent, buf, size);
 
@@ -201,8 +214,10 @@ static int read_header_files(struct pevent *pevent)
 	unsigned long long size;
 	char *header_event;
 	char buf[BUFSIZ];
+	int ret = 0;
 
-	read_or_die(buf, 12);
+	if (do_read(buf, 12) < 0)
+		return -1;
 
 	if (memcmp(buf, "header_page", 12) != 0)
 		die("did not read header page");
@@ -216,7 +231,9 @@ static int read_header_files(struct pevent *pevent)
 	 */
 	long_size = header_page_size_size;
 
-	read_or_die(buf, 13);
+	if (do_read(buf, 13) < 0)
+		return -1;
+
 	if (memcmp(buf, "header_event", 13) != 0)
 		die("did not read header event");
 
@@ -225,9 +242,11 @@ static int read_header_files(struct pevent *pevent)
 	if (header_event == NULL)
 		return -1;
 
-	read_or_die(header_event, size);
+	if (do_read(header_event, size) < 0)
+		ret = -1;
+
 	free(header_event);
-	return 0;
+	return ret;
 }
 
 static int read_ftrace_file(struct pevent *pevent, unsigned long long size)
@@ -238,7 +257,11 @@ static int read_ftrace_file(struct pevent *pevent, unsigned long long size)
 	if (buf == NULL)
 		return -1;
 
-	read_or_die(buf, size);
+	if (do_read(buf, size) < 0) {
+		free(buf);
+		return -1;
+	}
+
 	parse_ftrace_file(pevent, buf, size);
 	free(buf);
 	return 0;
@@ -253,7 +276,11 @@ static int read_event_file(struct pevent *pevent, char *sys,
 	if (buf == NULL)
 		return -1;
 
-	read_or_die(buf, size);
+	if (do_read(buf, size) < 0) {
+		free(buf);
+		return -1;
+	}
+
 	parse_event_file(pevent, buf, size, sys);
 	free(buf);
 	return 0;
@@ -294,6 +321,7 @@ static int read_event_files(struct pevent *pevent)
 			return -1;
 
 		count = read4(pevent);
+
 		for (x=0; x < count; x++) {
 			size = read8(pevent);
 			ret = read_event_file(pevent, sys, size);
@@ -323,11 +351,13 @@ ssize_t trace_report(int fd, struct pevent **ppevent, bool __repipe)
 
 	input_fd = fd;
 
-	read_or_die(buf, 3);
+	if (do_read(buf, 3) < 0)
+		return -1;
 	if (memcmp(buf, test, 3) != 0)
 		die("no trace data in the file");
 
-	read_or_die(buf, 7);
+	if (do_read(buf, 7) < 0)
+		return -1;
 	if (memcmp(buf, "tracing", 7) != 0)
 		die("not a trace file (missing 'tracing' tag)");
 
@@ -338,7 +368,8 @@ ssize_t trace_report(int fd, struct pevent **ppevent, bool __repipe)
 		printf("version = %s\n", version);
 	free(version);
 
-	read_or_die(buf, 1);
+	if (do_read(buf, 1) < 0)
+		return -1;
 	file_bigendian = buf[0];
 	host_bigendian = bigendian();
 
@@ -348,10 +379,13 @@ ssize_t trace_report(int fd, struct pevent **ppevent, bool __repipe)
 		goto out;
 	}
 
-	read_or_die(buf, 1);
+	if (do_read(buf, 1) < 0)
+		goto out;
 	long_size = buf[0];
 
 	page_size = read4(pevent);
+	if (!page_size)
+		goto out;
 
 	err = read_header_files(pevent);
 	if (err)
-- 
1.7.1

