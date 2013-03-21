Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757777Ab3CUHT7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Mar 2013 03:19:59 -0400
Received: from LGEMRELSE6Q.lge.com ([156.147.1.121]:45112 "EHLO
	LGEMRELSE6Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932580Ab3CUHTB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Mar 2013 03:19:01 -0400
X-AuditID: 9c930179-b7c78ae000000e4b-45-514ab46182af
From: Namhyung Kim <namhyung@kernel.org>
To: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Paul Mackerras <paulus@samba.org>,
        Ingo Molnar <mingo@kernel.org>, Namhyung Kim <namhyung.kim@lge.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Frederic Weisbecker <fweisbec@gmail.com>
Subject: [PATCH 7/9] perf util: Get rid of read_or_die() in trace-event-read.c
Date: Thu, 21 Mar 2013 16:18:50 +0900
Message-Id: <1363850332-25297-8-git-send-email-namhyung@kernel.org>
X-Mailer: git-send-email 1.7.11.7
In-Reply-To: <1363850332-25297-1-git-send-email-namhyung@kernel.org>
References: <1363850332-25297-1-git-send-email-namhyung@kernel.org>
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Namhyung Kim <namhyung.kim@lge.com>

Rename it to do_read and original do_read to __do_read, and check
their return value.

Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Signed-off-by: Namhyung Kim <namhyung@kernel.org>
---
 tools/perf/util/trace-event-read.c | 80 +++++++++++++++++++++++++++-----------
 1 file changed, 57 insertions(+), 23 deletions(-)

diff --git a/tools/perf/util/trace-event-read.c b/tools/perf/util/trace-event-read.c
index dc599fd27c47..3626f9d6e06e 100644
--- a/tools/perf/util/trace-event-read.c
+++ b/tools/perf/util/trace-event-read.c
@@ -48,7 +48,7 @@ static int long_size;
 static ssize_t calc_data_size;
 static bool repipe;
 
-static int do_read(int fd, void *buf, int size)
+static int __do_read(int fd, void *buf, int size)
 {
 	int rsize = size;
 
@@ -61,8 +61,10 @@ static int do_read(int fd, void *buf, int size)
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
@@ -72,14 +74,16 @@ static int do_read(int fd, void *buf, int size)
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
@@ -95,7 +99,7 @@ static void skip(int size)
 
 	while (size) {
 		r = size > BUFSIZ ? BUFSIZ : size;
-		read_or_die(buf, r);
+		do_read(buf, r);
 		size -= r;
 	};
 }
@@ -104,7 +108,8 @@ static unsigned int read4(struct pevent *pevent)
 {
 	unsigned int data;
 
-	read_or_die(&data, 4);
+	if (do_read(&data, 4) < 0)
+		return 0;
 	return __data2host4(pevent, data);
 }
 
@@ -112,7 +117,8 @@ static unsigned long long read8(struct pevent *pevent)
 {
 	unsigned long long data;
 
-	read_or_die(&data, 8);
+	if (do_read(&data, 8) < 0)
+		return 0;
 	return __data2host8(pevent, data);
 }
 
@@ -168,7 +174,10 @@ static int read_proc_kallsyms(struct pevent *pevent)
 	if (buf == NULL)
 		return -1;
 
-	read_or_die(buf, size);
+	if (do_read(buf, size) < 0) {
+		free(buf);
+		return -1;
+	}
 	buf[size] = '\0';
 
 	parse_proc_kallsyms(pevent, buf, size);
@@ -182,6 +191,7 @@ static int read_ftrace_printk(struct pevent *pevent)
 	unsigned int size;
 	char *buf;
 
+	/* it can have 0 size */
 	size = read4(pevent);
 	if (!size)
 		return 0;
@@ -190,7 +200,10 @@ static int read_ftrace_printk(struct pevent *pevent)
 	if (buf == NULL)
 		return -1;
 
-	read_or_die(buf, size);
+	if (do_read(buf, size) < 0) {
+		free(buf);
+		return -1;
+	}
 
 	parse_ftrace_printk(pevent, buf, size);
 
@@ -203,8 +216,10 @@ static int read_header_files(struct pevent *pevent)
 	unsigned long long size;
 	char *header_event;
 	char buf[BUFSIZ];
+	int ret = 0;
 
-	read_or_die(buf, 12);
+	if (do_read(buf, 12) < 0)
+		return -1;
 
 	if (memcmp(buf, "header_page", 12) != 0)
 		die("did not read header page");
@@ -218,7 +233,9 @@ static int read_header_files(struct pevent *pevent)
 	 */
 	long_size = header_page_size_size;
 
-	read_or_die(buf, 13);
+	if (do_read(buf, 13) < 0)
+		return -1;
+
 	if (memcmp(buf, "header_event", 13) != 0)
 		die("did not read header event");
 
@@ -227,9 +244,11 @@ static int read_header_files(struct pevent *pevent)
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
@@ -240,7 +259,11 @@ static int read_ftrace_file(struct pevent *pevent, unsigned long long size)
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
@@ -255,7 +278,11 @@ static int read_event_file(struct pevent *pevent, char *sys,
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
@@ -296,6 +323,7 @@ static int read_event_files(struct pevent *pevent)
 			return -1;
 
 		count = read4(pevent);
+
 		for (x=0; x < count; x++) {
 			size = read8(pevent);
 			ret = read_event_file(pevent, sys, size);
@@ -325,11 +353,13 @@ ssize_t trace_report(int fd, struct pevent **ppevent, bool __repipe)
 
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
 
@@ -340,7 +370,8 @@ ssize_t trace_report(int fd, struct pevent **ppevent, bool __repipe)
 		printf("version = %s\n", version);
 	free(version);
 
-	read_or_die(buf, 1);
+	if (do_read(buf, 1) < 0)
+		return -1;
 	file_bigendian = buf[0];
 	host_bigendian = bigendian();
 
@@ -350,10 +381,13 @@ ssize_t trace_report(int fd, struct pevent **ppevent, bool __repipe)
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
1.7.11.7

