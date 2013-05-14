Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757229Ab3ENKRV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 May 2013 06:17:21 -0400
Received: from LGEMRELSE7Q.lge.com ([156.147.1.151]:46368 "EHLO
	LGEMRELSE7Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756416Ab3ENKOE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 May 2013 06:14:04 -0400
X-AuditID: 9c930197-b7b76ae000003523-2f-51920e692457
From: Namhyung Kim <namhyung@kernel.org>
To: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Paul Mackerras <paulus@samba.org>,
        Ingo Molnar <mingo@kernel.org>, Namhyung Kim <namhyung.kim@lge.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Frederic Weisbecker <fweisbec@gmail.com>, Jiri Olsa <jolsa@redhat.com>,
        David Ahern <dsahern@gmail.com>, Stephane Eranian <eranian@google.com>
Subject: [PATCH 03/15] perf util: Save pid-cmdline mapping into tracing header
Date: Tue, 14 May 2013 19:13:47 +0900
Message-Id: <1368526439-31966-4-git-send-email-namhyung@kernel.org>
X-Mailer: git-send-email 1.7.11.7
In-Reply-To: <1368526439-31966-1-git-send-email-namhyung@kernel.org>
References: <1368526439-31966-1-git-send-email-namhyung@kernel.org>
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Namhyung Kim <namhyung.kim@lge.com>

Current trace info data lacks the saved cmdline mapping which is
needed for pevent to find out the comm of a task.  Add this and bump
up the version number so that perf can determine its presence when
reading.

This is mostly corresponding to trace.dat file version 6, but still
lacks 4 byte of number of cpus, and 10 bytes of type string - and I
think we don't need those anyway.

Cc: Steven Rostedt <rostedt@goodmis.org>
Signed-off-by: Namhyung Kim <namhyung@kernel.org>
---
 tools/perf/util/trace-event-info.c  | 33 ++++++++++++++++++++++++++++++++-
 tools/perf/util/trace-event-parse.c | 17 +++++++++++++++++
 tools/perf/util/trace-event-read.c  | 36 ++++++++++++++++++++++++++++++++++--
 tools/perf/util/trace-event.h       |  1 +
 4 files changed, 84 insertions(+), 3 deletions(-)

diff --git a/tools/perf/util/trace-event-info.c b/tools/perf/util/trace-event-info.c
index bfcaeac7ef9d..c0f364273993 100644
--- a/tools/perf/util/trace-event-info.c
+++ b/tools/perf/util/trace-event-info.c
@@ -41,7 +41,7 @@
 #include <lk/debugfs.h>
 #include "evsel.h"
 
-#define VERSION "0.5"
+#define VERSION "0.6"
 
 static int output_fd;
 
@@ -390,6 +390,34 @@ out:
 	return err;
 }
 
+static int record_saved_cmdline(void)
+{
+	unsigned int size;
+	char *path;
+	struct stat st;
+	int ret, err = 0;
+
+	path = get_tracing_file("saved_cmdlines");
+	if (!path) {
+		pr_debug("can't get tracing/saved_cmdline");
+		return -ENOMEM;
+	}
+
+	ret = stat(path, &st);
+	if (ret < 0) {
+		/* not found */
+		size = 0;
+		if (write(output_fd, &size, 8) != 8)
+			err = -EIO;
+		goto out;
+	}
+	err = record_file(path, 8);
+
+out:
+	put_tracing_file(path);
+	return err;
+}
+
 static void
 put_tracepoints_path(struct tracepoint_path *tps)
 {
@@ -546,6 +574,9 @@ struct tracing_data *tracing_data_get(struct list_head *pattrs,
 	if (err)
 		goto out;
 	err = record_ftrace_printk();
+	if (err)
+		goto out;
+	err = record_saved_cmdline();
 
 out:
 	/*
diff --git a/tools/perf/util/trace-event-parse.c b/tools/perf/util/trace-event-parse.c
index fe7a27d67d2b..ef09e4720e04 100644
--- a/tools/perf/util/trace-event-parse.c
+++ b/tools/perf/util/trace-event-parse.c
@@ -232,6 +232,23 @@ void parse_ftrace_printk(struct pevent *pevent,
 	}
 }
 
+void parse_saved_cmdline(struct pevent *pevent,
+			 char *file, unsigned int size __maybe_unused)
+{
+	char *comm;
+	char *line;
+	char *next = NULL;
+	int pid;
+
+	line = strtok_r(file, "\n", &next);
+	while (line) {
+		sscanf(line, "%d %ms", &pid, &comm);
+		pevent_register_comm(pevent, comm, pid);
+		free(comm);
+		line = strtok_r(NULL, "\n", &next);
+	}
+}
+
 int parse_ftrace_file(struct pevent *pevent, char *buf, unsigned long size)
 {
 	return pevent_parse_event(pevent, buf, size, "ftrace");
diff --git a/tools/perf/util/trace-event-read.c b/tools/perf/util/trace-event-read.c
index f2112270c663..e084e5e654b6 100644
--- a/tools/perf/util/trace-event-read.c
+++ b/tools/perf/util/trace-event-read.c
@@ -343,6 +343,31 @@ static int read_event_files(struct pevent *pevent)
 	return 0;
 }
 
+static int read_saved_cmdline(struct pevent *pevent)
+{
+	unsigned long long size;
+	char *buf;
+
+	/* it can have 0 size */
+	size = read8(pevent);
+	if (!size)
+		return 0;
+
+	buf = malloc(size + 1);
+	if (buf == NULL)
+		return -1;
+
+	if (do_read(buf, size) < 0) {
+		free(buf);
+		return -1;
+	}
+
+	parse_saved_cmdline(pevent, buf, size);
+
+	free(buf);
+	return 0;
+}
+
 ssize_t trace_report(int fd, struct pevent **ppevent, bool __repipe)
 {
 	char buf[BUFSIZ];
@@ -383,10 +408,11 @@ ssize_t trace_report(int fd, struct pevent **ppevent, bool __repipe)
 		return -1;
 	if (show_version)
 		printf("version = %s\n", version);
-	free(version);
 
-	if (do_read(buf, 1) < 0)
+	if (do_read(buf, 1) < 0) {
+		free(version);
 		return -1;
+	}
 	file_bigendian = buf[0];
 	host_bigendian = bigendian();
 
@@ -422,6 +448,11 @@ ssize_t trace_report(int fd, struct pevent **ppevent, bool __repipe)
 	err = read_ftrace_printk(pevent);
 	if (err)
 		goto out;
+	if (!strcmp(version, "0.6")) {
+		err = read_saved_cmdline(pevent);
+		if (err)
+			goto out;
+	}
 
 	size = trace_data_size;
 	repipe = false;
@@ -438,5 +469,6 @@ ssize_t trace_report(int fd, struct pevent **ppevent, bool __repipe)
 out:
 	if (pevent)
 		pevent_free(pevent);
+	free(version);
 	return size;
 }
diff --git a/tools/perf/util/trace-event.h b/tools/perf/util/trace-event.h
index 929baae82f71..fbc8a19552b7 100644
--- a/tools/perf/util/trace-event.h
+++ b/tools/perf/util/trace-event.h
@@ -30,6 +30,7 @@ void *raw_field_ptr(struct event_format *event, const char *name, void *data);
 
 void parse_proc_kallsyms(struct pevent *pevent, char *file, unsigned int size);
 void parse_ftrace_printk(struct pevent *pevent, char *file, unsigned int size);
+void parse_saved_cmdline(struct pevent *pevent, char *file, unsigned int size);
 
 ssize_t trace_report(int fd, struct pevent **pevent, bool repipe);
 
-- 
1.7.11.7

