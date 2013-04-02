Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761607Ab3DBJ0l (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Apr 2013 05:26:41 -0400
Received: from terminus.zytor.com ([198.137.202.10]:50602 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760797Ab3DBJ0h (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Apr 2013 05:26:37 -0400
Date: Tue, 2 Apr 2013 02:26:17 -0700
From: tip-bot for Namhyung Kim <tipbot@zytor.com>
Message-ID: <tip-7f42b9505aee3fa9cb465a670989e3d426a1f3f2@git.kernel.org>
Cc: acme@redhat.com, linux-kernel@vger.kernel.org, paulus@samba.org,
        hpa@zytor.com, mingo@kernel.org, a.p.zijlstra@chello.nl,
        namhyung.kim@lge.com, namhyung@kernel.org, fweisbec@gmail.com,
        rostedt@goodmis.org, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, paulus@samba.org,
        linux-kernel@vger.kernel.org, acme@redhat.com, a.p.zijlstra@chello.nl,
        namhyung.kim@lge.com, namhyung@kernel.org, fweisbec@gmail.com,
        rostedt@goodmis.org, tglx@linutronix.de
In-Reply-To: <1363850332-25297-5-git-send-email-namhyung@kernel.org>
References: <1363850332-25297-5-git-send-email-namhyung@kernel.org>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf tools: Get rid of die()
  calls from trace-event-info.c
Git-Commit-ID: 7f42b9505aee3fa9cb465a670989e3d426a1f3f2
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.7 (terminus.zytor.com [127.0.0.1]); Tue, 02 Apr 2013 02:26:22 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  7f42b9505aee3fa9cb465a670989e3d426a1f3f2
Gitweb:     http://git.kernel.org/tip/7f42b9505aee3fa9cb465a670989e3d426a1f3f2
Author:     Namhyung Kim <namhyung.kim@lge.com>
AuthorDate: Thu, 21 Mar 2013 16:18:47 +0900
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Thu, 21 Mar 2013 13:30:10 -0300

perf tools: Get rid of die() calls from trace-event-info.c

Now remove all remaining die() calls and convert them to check return
value and propagate it.

Signed-off-by: Namhyung Kim <namhyung@kernel.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Steven Rostedt <rostedt@goodmis.org>
Link: http://lkml.kernel.org/r/1363850332-25297-5-git-send-email-namhyung@kernel.org
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/util/trace-event-info.c | 114 +++++++++++++++++++++++--------------
 1 file changed, 72 insertions(+), 42 deletions(-)

diff --git a/tools/perf/util/trace-event-info.c b/tools/perf/util/trace-event-info.c
index 090e80d..3917eb9 100644
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
