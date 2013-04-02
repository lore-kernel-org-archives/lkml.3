Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932359Ab3DBJ3A (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Apr 2013 05:29:00 -0400
Received: from terminus.zytor.com ([198.137.202.10]:50649 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932164Ab3DBJ27 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Apr 2013 05:28:59 -0400
Date: Tue, 2 Apr 2013 02:28:43 -0700
From: tip-bot for Namhyung Kim <tipbot@zytor.com>
Message-ID: <tip-a4c983670e0f4285fe115cb2ad697c978c7950b6@git.kernel.org>
Cc: acme@redhat.com, linux-kernel@vger.kernel.org, paulus@samba.org,
        hpa@zytor.com, mingo@kernel.org, a.p.zijlstra@chello.nl,
        namhyung.kim@lge.com, namhyung@kernel.org, fweisbec@gmail.com,
        rostedt@goodmis.org, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, paulus@samba.org,
        linux-kernel@vger.kernel.org, acme@redhat.com, a.p.zijlstra@chello.nl,
        namhyung.kim@lge.com, namhyung@kernel.org, fweisbec@gmail.com,
        rostedt@goodmis.org, tglx@linutronix.de
In-Reply-To: <1363850332-25297-7-git-send-email-namhyung@kernel.org>
References: <1363850332-25297-7-git-send-email-namhyung@kernel.org>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf tools: Get rid of malloc_or_die()
  in trace-event-read.c
Git-Commit-ID: a4c983670e0f4285fe115cb2ad697c978c7950b6
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.7 (terminus.zytor.com [127.0.0.1]); Tue, 02 Apr 2013 02:28:48 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  a4c983670e0f4285fe115cb2ad697c978c7950b6
Gitweb:     http://git.kernel.org/tip/a4c983670e0f4285fe115cb2ad697c978c7950b6
Author:     Namhyung Kim <namhyung.kim@lge.com>
AuthorDate: Thu, 21 Mar 2013 16:18:49 +0900
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Thu, 21 Mar 2013 13:32:46 -0300

perf tools: Get rid of malloc_or_die() in trace-event-read.c

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
 tools/perf/util/trace-event-read.c | 100 +++++++++++++++++++++++++------------
 1 file changed, 67 insertions(+), 33 deletions(-)

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
