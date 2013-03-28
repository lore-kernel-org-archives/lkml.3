Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757492Ab3C1RLr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Mar 2013 13:11:47 -0400
Received: from 173-166-109-252-newengland.hfc.comcastbusiness.net ([173.166.109.252]:47730
	"EHLO bombadil.infradead.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756618Ab3C1RCt (ORCPT
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
Subject: [PATCH 07/36] perf tools: Get rid of malloc_or_die() in trace-event-read.c
Date: Thu, 28 Mar 2013 14:02:07 -0300
Message-Id: <1364490156-32064-8-git-send-email-acme@infradead.org>
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

Check return value of malloc() and fail if error.  Now read_string()
can return NULL also check its return value and bail out.

Signed-off-by: Namhyung Kim <namhyung@kernel.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Steven Rostedt <rostedt@goodmis.org>
Link: http://lkml.kernel.org/r/1363850332-25297-7-git-send-email-namhyung@kernel.org
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/util/trace-event-read.c |  100 ++++++++++++++++++++++++------------
 1 files changed, 67 insertions(+), 33 deletions(-)

diff --git a/tools/perf/util/trace-event-read.c b/tools/perf/util/trace-event-read.c
index ba752d7..22ded80 100644
--- a/tools/perf/util/trace-event-read.c
+++ b/tools/perf/util/trace-event-read.c
@@ -46,16 +46,6 @@ static int long_size;
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
@@ -156,48 +146,57 @@ static char *read_string(void)
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
@@ -222,65 +221,87 @@ static void read_header_files(struct pevent *pevent)
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
@@ -293,6 +314,7 @@ ssize_t trace_report(int fd, struct pevent **ppevent, bool __repipe)
 	int show_printk = 0;
 	ssize_t size = -1;
 	struct pevent *pevent;
+	int err;
 
 	*ppevent = NULL;
 
@@ -310,6 +332,8 @@ ssize_t trace_report(int fd, struct pevent **ppevent, bool __repipe)
 		die("not a trace file (missing 'tracing' tag)");
 
 	version = read_string();
+	if (version == NULL)
+		return -1;
 	if (show_version)
 		printf("version = %s\n", version);
 	free(version);
@@ -329,11 +353,21 @@ ssize_t trace_report(int fd, struct pevent **ppevent, bool __repipe)
 
 	page_size = read4(pevent);
 
-	read_header_files(pevent);
-	read_ftrace_files(pevent);
-	read_event_files(pevent);
-	read_proc_kallsyms(pevent);
-	read_ftrace_printk(pevent);
+	err = read_header_files(pevent);
+	if (err)
+		goto out;
+	err = read_ftrace_files(pevent);
+	if (err)
+		goto out;
+	err = read_event_files(pevent);
+	if (err)
+		goto out;
+	err = read_proc_kallsyms(pevent);
+	if (err)
+		goto out;
+	err = read_ftrace_printk(pevent);
+	if (err)
+		goto out;
 
 	size = calc_data_size - 1;
 	calc_data_size = 0;
-- 
1.7.1

