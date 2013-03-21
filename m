Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932791Ab3CUHTJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Mar 2013 03:19:09 -0400
Received: from LGEMRELSE6Q.lge.com ([156.147.1.121]:45112 "EHLO
	LGEMRELSE6Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932549Ab3CUHS7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Mar 2013 03:18:59 -0400
X-AuditID: 9c930179-b7c78ae000000e4b-19-514ab460ba97
From: Namhyung Kim <namhyung@kernel.org>
To: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Paul Mackerras <paulus@samba.org>,
        Ingo Molnar <mingo@kernel.org>, Namhyung Kim <namhyung.kim@lge.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Frederic Weisbecker <fweisbec@gmail.com>
Subject: [PATCH 4/9] perf util: Get rid of die() calls from trace-event-info.c
Date: Thu, 21 Mar 2013 16:18:47 +0900
Message-Id: <1363850332-25297-5-git-send-email-namhyung@kernel.org>
X-Mailer: git-send-email 1.7.11.7
In-Reply-To: <1363850332-25297-1-git-send-email-namhyung@kernel.org>
References: <1363850332-25297-1-git-send-email-namhyung@kernel.org>
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Namhyung Kim <namhyung.kim@lge.com>

Now remove all remaining die() calls and convert them to check return
value and propagate it.

Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Signed-off-by: Namhyung Kim <namhyung@kernel.org>
---
 tools/perf/util/trace-event-info.c | 114 +++++++++++++++++++++++--------------
 1 file changed, 72 insertions(+), 42 deletions(-)

diff --git a/tools/perf/util/trace-event-info.c b/tools/perf/util/trace-event-info.c
index 090e80d743db..3917eb9a8479 100644
--- a/tools/perf/util/trace-event-info.c
+++ b/tools/perf/util/trace-event-info.c
@@ -43,7 +43,6 @@
 
 #define VERSION "0.5"
 
-static const char *output_file = "trace.info";
 static int output_fd;
 
 
@@ -125,8 +124,10 @@ static int record_file(const char *file, ssize_t hdr_sz)
 	int err = -EIO;
 
 	fd = open(file, O_RDONLY);
-	if (fd < 0)
-		die("Can't read '%s'", file);
+	if (fd < 0) {
+		pr_debug("Can't read '%s'", file);
+		return -errno;
+	}
 
 	/* put in zeros for file size, then fill true size later */
 	if (hdr_sz) {
@@ -148,8 +149,10 @@ static int record_file(const char *file, ssize_t hdr_sz)
 	if (bigendian())
 		sizep += sizeof(u64) - hdr_sz;
 
-	if (hdr_sz && pwrite(output_fd, sizep, hdr_sz, hdr_pos) < 0)
-		die("writing to %s", output_file);
+	if (hdr_sz && pwrite(output_fd, sizep, hdr_sz, hdr_pos) < 0) {
+		pr_debug("writing file size failed\n");
+		goto out;
+	}
 
 	err = 0;
 out:
@@ -164,11 +167,15 @@ static int read_header_files(void)
 	int err = -EIO;
 
 	path = get_tracing_file("events/header_page");
-	if (!path)
-		die("can't get tracing/events/header_page");
+	if (!path) {
+		pr_debug("can't get tracing/events/header_page");
+		return -ENOMEM;
+	}
 
-	if (stat(path, &st) < 0)
-		die("can't read '%s'", path);
+	if (stat(path, &st) < 0) {
+		pr_debug("can't read '%s'", path);
+		goto out;
+	}
 
 	if (write(output_fd, "header_page", 12) != 12) {
 		pr_debug("can't write header_page\n");
@@ -183,11 +190,16 @@ static int read_header_files(void)
 	put_tracing_file(path);
 
 	path = get_tracing_file("events/header_event");
-	if (!path)
-		die("can't get tracing/events/header_event");
+	if (!path) {
+		pr_debug("can't get tracing/events/header_event");
+		err = -ENOMEM;
+		goto out;
+	}
 
-	if (stat(path, &st) < 0)
-		die("can't read '%s'", path);
+	if (stat(path, &st) < 0) {
+		pr_debug("can't read '%s'", path);
+		goto out;
+	}
 
 	if (write(output_fd, "header_event", 13) != 13) {
 		pr_debug("can't write header_event\n");
@@ -227,8 +239,10 @@ static int copy_event_system(const char *sys, struct tracepoint_path *tps)
 	int err;
 
 	dir = opendir(sys);
-	if (!dir)
-		die("can't read directory '%s'", sys);
+	if (!dir) {
+		pr_debug("can't read directory '%s'", sys);
+		return -errno;
+	}
 
 	while ((dent = readdir(dir))) {
 		if (dent->d_type != DT_DIR ||
@@ -291,8 +305,10 @@ static int read_ftrace_files(struct tracepoint_path *tps)
 	int ret;
 
 	path = get_tracing_file("events/ftrace");
-	if (!path)
-		die("can't get tracing/events/ftrace");
+	if (!path) {
+		pr_debug("can't get tracing/events/ftrace");
+		return -ENOMEM;
+	}
 
 	ret = copy_event_system(path, tps);
 
@@ -324,12 +340,17 @@ static int read_event_files(struct tracepoint_path *tps)
 	int err;
 
 	path = get_tracing_file("events");
-	if (!path)
-		die("can't get tracing/events");
+	if (!path) {
+		pr_debug("can't get tracing/events");
+		return -ENOMEM;
+	}
 
 	dir = opendir(path);
-	if (!dir)
-		die("can't read directory '%s'", path);
+	if (!dir) {
+		err = -errno;
+		pr_debug("can't read directory '%s'", path);
+		goto out;
+	}
 
 	while ((dent = readdir(dir))) {
 		if (dent->d_type != DT_DIR ||
@@ -408,8 +429,10 @@ static int read_ftrace_printk(void)
 	int ret, err = 0;
 
 	path = get_tracing_file("printk_formats");
-	if (!path)
-		die("can't get tracing/printk_formats");
+	if (!path) {
+		pr_debug("can't get tracing/printk_formats");
+		return -ENOMEM;
+	}
 
 	ret = stat(path, &st);
 	if (ret < 0) {
@@ -426,6 +449,19 @@ out:
 	return err;
 }
 
+static void
+put_tracepoints_path(struct tracepoint_path *tps)
+{
+	while (tps) {
+		struct tracepoint_path *t = tps;
+
+		tps = tps->next;
+		free(t->name);
+		free(t->system);
+		free(t);
+	}
+}
+
 static struct tracepoint_path *
 get_tracepoints_path(struct list_head *pattrs)
 {
@@ -438,27 +474,17 @@ get_tracepoints_path(struct list_head *pattrs)
 			continue;
 		++nr_tracepoints;
 		ppath->next = tracepoint_id_to_path(pos->attr.config);
-		if (!ppath->next)
-			die("%s\n", "No memory to alloc tracepoints list");
+		if (!ppath->next) {
+			pr_debug("No memory to alloc tracepoints list\n");
+			put_tracepoints_path(&path);
+			return NULL;
+		}
 		ppath = ppath->next;
 	}
 
 	return nr_tracepoints > 0 ? path.next : NULL;
 }
 
-static void
-put_tracepoints_path(struct tracepoint_path *tps)
-{
-	while (tps) {
-		struct tracepoint_path *t = tps;
-
-		tps = tps->next;
-		free(t->name);
-		free(t->system);
-		free(t);
-	}
-}
-
 bool have_tracepoints(struct list_head *pattrs)
 {
 	struct perf_evsel *pos;
@@ -536,12 +562,16 @@ struct tracing_data *tracing_data_get(struct list_head *pattrs,
 
 		snprintf(tdata->temp_file, sizeof(tdata->temp_file),
 			 "/tmp/perf-XXXXXX");
-		if (!mkstemp(tdata->temp_file))
-			die("Can't make temp file");
+		if (!mkstemp(tdata->temp_file)) {
+			pr_debug("Can't make temp file");
+			return NULL;
+		}
 
 		temp_fd = open(tdata->temp_file, O_RDWR);
-		if (temp_fd < 0)
-			die("Can't read '%s'", tdata->temp_file);
+		if (temp_fd < 0) {
+			pr_debug("Can't read '%s'", tdata->temp_file);
+			return NULL;
+		}
 
 		/*
 		 * Set the temp file the default output, so all the
-- 
1.7.11.7

