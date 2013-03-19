Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965069Ab3CSI4t (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Mar 2013 04:56:49 -0400
Received: from LGEMRELSE7Q.lge.com ([156.147.1.151]:59042 "EHLO
	LGEMRELSE7Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755984Ab3CSIxx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Mar 2013 04:53:53 -0400
X-AuditID: 9c930197-b7cc2ae000000eb7-9a-5148279dcada
From: Namhyung Kim <namhyung@kernel.org>
To: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Paul Mackerras <paulus@samba.org>,
        Ingo Molnar <mingo@kernel.org>, Namhyung Kim <namhyung.kim@lge.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Frederic Weisbecker <fweisbec@gmail.com>
Subject: [PATCH 6/9] perf util: Get rid of malloc_or_die() in trace-event-read.c
Date: Tue, 19 Mar 2013 17:53:41 +0900
Message-Id: <1363683224-28804-7-git-send-email-namhyung@kernel.org>
X-Mailer: git-send-email 1.7.11.7
In-Reply-To: <1363683224-28804-1-git-send-email-namhyung@kernel.org>
References: <1363683224-28804-1-git-send-email-namhyung@kernel.org>
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Namhyung Kim <namhyung.kim@lge.com>

Check return value of malloc() and fail if error.  Now read_string()
can return NULL also check its return value and bail out.

Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Signed-off-by: Namhyung Kim <namhyung@kernel.org>
---
 tools/perf/util/trace-event-read.c | 90 ++++++++++++++++++++++++--------------
 1 file changed, 57 insertions(+), 33 deletions(-)

diff --git a/tools/perf/util/trace-event-read.c b/tools/perf/util/trace-event-read.c
index 129362b97ca5..62dd2168f4f5 100644
--- a/tools/perf/util/trace-event-read.c
+++ b/tools/perf/util/trace-event-read.c
@@ -48,16 +48,6 @@ static int long_size;
 static ssize_t calc_data_size;
 static bool repipe;
 
-static void *malloc_or_die(int size)
-{
-	void *ret;
-
-	ret = malloc(size);
-	if (!ret)
-		die("malloc");
-	return ret;
-}
-
 static int do_read(int fd, void *buf, int size)
 {
 	int rsize = size;
@@ -158,48 +148,57 @@ static char *read_string(void)
 	if (calc_data_size)
 		calc_data_size += size;
 
-	str = malloc_or_die(size);
-	memcpy(str, buf, size);
+	str = malloc(size);
+	if (str)
+		memcpy(str, buf, size);
 
 	return str;
 }
 
-static void read_proc_kallsyms(struct pevent *pevent)
+static int read_proc_kallsyms(struct pevent *pevent)
 {
 	unsigned int size;
 	char *buf;
 
 	size = read4(pevent);
 	if (!size)
-		return;
+		return 0;
+
+	buf = malloc(size + 1);
+	if (buf == NULL)
+		return -1;
 
-	buf = malloc_or_die(size + 1);
 	read_or_die(buf, size);
 	buf[size] = '\0';
 
 	parse_proc_kallsyms(pevent, buf, size);
 
 	free(buf);
+	return 0;
 }
 
-static void read_ftrace_printk(struct pevent *pevent)
+static int read_ftrace_printk(struct pevent *pevent)
 {
 	unsigned int size;
 	char *buf;
 
 	size = read4(pevent);
 	if (!size)
-		return;
+		return 0;
+
+	buf = malloc(size);
+	if (buf == NULL)
+		return -1;
 
-	buf = malloc_or_die(size);
 	read_or_die(buf, size);
 
 	parse_ftrace_printk(pevent, buf, size);
 
 	free(buf);
+	return 0;
 }
 
-static void read_header_files(struct pevent *pevent)
+static int read_header_files(struct pevent *pevent)
 {
 	unsigned long long size;
 	char *header_event;
@@ -224,65 +223,87 @@ static void read_header_files(struct pevent *pevent)
 		die("did not read header event");
 
 	size = read8(pevent);
-	header_event = malloc_or_die(size);
+	header_event = malloc(size);
+	if (header_event == NULL)
+		return -1;
+
 	read_or_die(header_event, size);
 	free(header_event);
+	return 0;
 }
 
-static void read_ftrace_file(struct pevent *pevent, unsigned long long size)
+static int read_ftrace_file(struct pevent *pevent, unsigned long long size)
 {
 	char *buf;
 
-	buf = malloc_or_die(size);
+	buf = malloc(size);
+	if (buf == NULL)
+		return -1;
+
 	read_or_die(buf, size);
 	parse_ftrace_file(pevent, buf, size);
 	free(buf);
+	return 0;
 }
 
-static void read_event_file(struct pevent *pevent, char *sys,
+static int read_event_file(struct pevent *pevent, char *sys,
 			    unsigned long long size)
 {
 	char *buf;
 
-	buf = malloc_or_die(size);
+	buf = malloc(size);
+	if (buf == NULL)
+		return -1;
+
 	read_or_die(buf, size);
 	parse_event_file(pevent, buf, size, sys);
 	free(buf);
+	return 0;
 }
 
-static void read_ftrace_files(struct pevent *pevent)
+static int read_ftrace_files(struct pevent *pevent)
 {
 	unsigned long long size;
 	int count;
 	int i;
+	int ret;
 
 	count = read4(pevent);
 
 	for (i = 0; i < count; i++) {
 		size = read8(pevent);
-		read_ftrace_file(pevent, size);
+		ret = read_ftrace_file(pevent, size);
+		if (ret)
+			return ret;
 	}
+	return 0;
 }
 
-static void read_event_files(struct pevent *pevent)
+static int read_event_files(struct pevent *pevent)
 {
 	unsigned long long size;
 	char *sys;
 	int systems;
 	int count;
 	int i,x;
+	int ret;
 
 	systems = read4(pevent);
 
 	for (i = 0; i < systems; i++) {
 		sys = read_string();
+		if (sys == NULL)
+			return -1;
 
 		count = read4(pevent);
 		for (x=0; x < count; x++) {
 			size = read8(pevent);
-			read_event_file(pevent, sys, size);
+			ret = read_event_file(pevent, sys, size);
+			if (ret)
+				return ret;
 		}
 	}
+	return 0;
 }
 
 ssize_t trace_report(int fd, struct pevent **ppevent, bool __repipe)
@@ -312,6 +333,8 @@ ssize_t trace_report(int fd, struct pevent **ppevent, bool __repipe)
 		die("not a trace file (missing 'tracing' tag)");
 
 	version = read_string();
+	if (version == NULL)
+		return -1;
 	if (show_version)
 		printf("version = %s\n", version);
 	free(version);
@@ -331,11 +354,12 @@ ssize_t trace_report(int fd, struct pevent **ppevent, bool __repipe)
 
 	page_size = read4(pevent);
 
-	read_header_files(pevent);
-	read_ftrace_files(pevent);
-	read_event_files(pevent);
-	read_proc_kallsyms(pevent);
-	read_ftrace_printk(pevent);
+	if (read_header_files(pevent) ||
+	    read_ftrace_files(pevent) ||
+	    read_event_files(pevent) ||
+	    read_proc_kallsyms(pevent) ||
+	    read_ftrace_printk(pevent))
+		goto out;
 
 	size = calc_data_size - 1;
 	calc_data_size = 0;
-- 
1.7.11.7

