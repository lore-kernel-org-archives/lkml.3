Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932744Ab3CUHTH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Mar 2013 03:19:07 -0400
Received: from LGEMRELSE6Q.lge.com ([156.147.1.121]:57775 "EHLO
	LGEMRELSE6Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932559Ab3CUHS7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Mar 2013 03:18:59 -0400
X-AuditID: 9c930179-b7c78ae000000e4b-12-514ab4602f35
From: Namhyung Kim <namhyung@kernel.org>
To: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Paul Mackerras <paulus@samba.org>,
        Ingo Molnar <mingo@kernel.org>, Namhyung Kim <namhyung.kim@lge.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Frederic Weisbecker <fweisbec@gmail.com>
Subject: [PATCH 3/9] perf util: Get rid of write_or_die() from trace-event-info.c
Date: Thu, 21 Mar 2013 16:18:46 +0900
Message-Id: <1363850332-25297-4-git-send-email-namhyung@kernel.org>
X-Mailer: git-send-email 1.7.11.7
In-Reply-To: <1363850332-25297-1-git-send-email-namhyung@kernel.org>
References: <1363850332-25297-1-git-send-email-namhyung@kernel.org>
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Namhyung Kim <namhyung.kim@lge.com>

Check return value of write and fail if error.

Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Signed-off-by: Namhyung Kim <namhyung@kernel.org>
---
 tools/perf/util/trace-event-info.c | 180 ++++++++++++++++++++++++++-----------
 tools/perf/util/trace-event.h      |   2 +-
 2 files changed, 127 insertions(+), 55 deletions(-)

diff --git a/tools/perf/util/trace-event-info.c b/tools/perf/util/trace-event-info.c
index 91db6e8e4493..090e80d743db 100644
--- a/tools/perf/util/trace-event-info.c
+++ b/tools/perf/util/trace-event-info.c
@@ -106,17 +106,6 @@ static void put_tracing_file(char *file)
 	free(file);
 }
 
-static ssize_t write_or_die(const void *buf, size_t len)
-{
-	int ret;
-
-	ret = write(output_fd, buf, len);
-	if (ret < 0)
-		die("writing to '%s'", output_file);
-
-	return ret;
-}
-
 int bigendian(void)
 {
 	unsigned char str[] = { 0x1, 0x2, 0x3, 0x4, 0x0, 0x0, 0x0, 0x0};
@@ -127,29 +116,32 @@ int bigendian(void)
 }
 
 /* unfortunately, you can not stat debugfs or proc files for size */
-static void record_file(const char *file, size_t hdr_sz)
+static int record_file(const char *file, ssize_t hdr_sz)
 {
 	unsigned long long size = 0;
 	char buf[BUFSIZ], *sizep;
 	off_t hdr_pos = lseek(output_fd, 0, SEEK_CUR);
 	int r, fd;
+	int err = -EIO;
 
 	fd = open(file, O_RDONLY);
 	if (fd < 0)
 		die("Can't read '%s'", file);
 
 	/* put in zeros for file size, then fill true size later */
-	if (hdr_sz)
-		write_or_die(&size, hdr_sz);
+	if (hdr_sz) {
+		if (write(output_fd, &size, hdr_sz) != hdr_sz)
+			goto out;
+	}
 
 	do {
 		r = read(fd, buf, BUFSIZ);
 		if (r > 0) {
 			size += r;
-			write_or_die(buf, r);
+			if (write(output_fd, buf, r) != r)
+				goto out;
 		}
 	} while (r > 0);
-	close(fd);
 
 	/* ugh, handle big-endian hdr_size == 4 */
 	sizep = (char*)&size;
@@ -158,12 +150,18 @@ static void record_file(const char *file, size_t hdr_sz)
 
 	if (hdr_sz && pwrite(output_fd, sizep, hdr_sz, hdr_pos) < 0)
 		die("writing to %s", output_file);
+
+	err = 0;
+out:
+	close(fd);
+	return err;
 }
 
-static void read_header_files(void)
+static int read_header_files(void)
 {
 	char *path;
 	struct stat st;
+	int err = -EIO;
 
 	path = get_tracing_file("events/header_page");
 	if (!path)
@@ -172,8 +170,16 @@ static void read_header_files(void)
 	if (stat(path, &st) < 0)
 		die("can't read '%s'", path);
 
-	write_or_die("header_page", 12);
-	record_file(path, 8);
+	if (write(output_fd, "header_page", 12) != 12) {
+		pr_debug("can't write header_page\n");
+		goto out;
+	}
+
+	if (record_file(path, 8) < 0) {
+		pr_debug("can't record header_page file\n");
+		goto out;
+	}
+
 	put_tracing_file(path);
 
 	path = get_tracing_file("events/header_event");
@@ -183,9 +189,20 @@ static void read_header_files(void)
 	if (stat(path, &st) < 0)
 		die("can't read '%s'", path);
 
-	write_or_die("header_event", 13);
-	record_file(path, 8);
+	if (write(output_fd, "header_event", 13) != 13) {
+		pr_debug("can't write header_event\n");
+		goto out;
+	}
+
+	if (record_file(path, 8) < 0) {
+		pr_debug("can't record header_event file\n");
+		goto out;
+	}
+
+	err = 0;
+out:
 	put_tracing_file(path);
+	return err;
 }
 
 static bool name_in_tp_list(char *sys, struct tracepoint_path *tps)
@@ -232,7 +249,11 @@ static int copy_event_system(const char *sys, struct tracepoint_path *tps)
 		count++;
 	}
 
-	write_or_die(&count, 4);
+	if (write(output_fd, &count, 4) != 4) {
+		err = -EIO;
+		pr_debug("can't write count\n");
+		goto out;
+	}
 
 	rewinddir(dir);
 	while ((dent = readdir(dir))) {
@@ -249,8 +270,13 @@ static int copy_event_system(const char *sys, struct tracepoint_path *tps)
 		sprintf(format, "%s/%s/format", sys, dent->d_name);
 		ret = stat(format, &st);
 
-		if (ret >= 0)
-			record_file(format, 8);
+		if (ret >= 0) {
+			err = record_file(format, 8);
+			if (err) {
+				free(format);
+				goto out;
+			}
+		}
 		free(format);
 	}
 	err = 0;
@@ -259,17 +285,20 @@ out:
 	return err;
 }
 
-static void read_ftrace_files(struct tracepoint_path *tps)
+static int read_ftrace_files(struct tracepoint_path *tps)
 {
 	char *path;
+	int ret;
 
 	path = get_tracing_file("events/ftrace");
 	if (!path)
 		die("can't get tracing/events/ftrace");
 
-	copy_event_system(path, tps);
+	ret = copy_event_system(path, tps);
 
 	put_tracing_file(path);
+
+	return ret;
 }
 
 static bool system_in_tp_list(char *sys, struct tracepoint_path *tps)
@@ -312,7 +341,11 @@ static int read_event_files(struct tracepoint_path *tps)
 		count++;
 	}
 
-	write_or_die(&count, 4);
+	if (write(output_fd, &count, 4) != 4) {
+		err = -EIO;
+		pr_debug("can't write count\n");
+		goto out;
+	}
 
 	rewinddir(dir);
 	while ((dent = readdir(dir))) {
@@ -330,8 +363,14 @@ static int read_event_files(struct tracepoint_path *tps)
 		sprintf(sys, "%s/%s", path, dent->d_name);
 		ret = stat(sys, &st);
 		if (ret >= 0) {
-			write_or_die(dent->d_name, strlen(dent->d_name) + 1);
-			copy_event_system(sys, tps);
+			ssize_t size = strlen(dent->d_name) + 1;
+
+			if (write(output_fd, dent->d_name, size) != size ||
+			    copy_event_system(sys, tps) < 0) {
+				err = -EIO;
+				free(sys);
+				goto out;
+			}
 		}
 		free(sys);
 	}
@@ -343,29 +382,30 @@ out:
 	return err;
 }
 
-static void read_proc_kallsyms(void)
+static int read_proc_kallsyms(void)
 {
 	unsigned int size;
 	const char *path = "/proc/kallsyms";
 	struct stat st;
-	int ret;
+	int ret, err = 0;
 
 	ret = stat(path, &st);
 	if (ret < 0) {
 		/* not found */
 		size = 0;
-		write_or_die(&size, 4);
-		return;
+		if (write(output_fd, &size, 4) != 4)
+			err = -EIO;
+		return err;
 	}
-	record_file(path, 4);
+	return record_file(path, 4);
 }
 
-static void read_ftrace_printk(void)
+static int read_ftrace_printk(void)
 {
 	unsigned int size;
 	char *path;
 	struct stat st;
-	int ret;
+	int ret, err = 0;
 
 	path = get_tracing_file("printk_formats");
 	if (!path)
@@ -375,13 +415,15 @@ static void read_ftrace_printk(void)
 	if (ret < 0) {
 		/* not found */
 		size = 0;
-		write_or_die(&size, 4);
+		if (write(output_fd, &size, 4) != 4)
+			err = -EIO;
 		goto out;
 	}
-	record_file(path, 4);
+	err = record_file(path, 4);
 
 out:
 	put_tracing_file(path);
+	return err;
 }
 
 static struct tracepoint_path *
@@ -428,9 +470,10 @@ bool have_tracepoints(struct list_head *pattrs)
 	return false;
 }
 
-static void tracing_data_header(void)
+static int tracing_data_header(void)
 {
 	char buf[20];
+	ssize_t size;
 
 	/* just guessing this is someone's birthday.. ;) */
 	buf[0] = 23;
@@ -438,9 +481,12 @@ static void tracing_data_header(void)
 	buf[2] = 68;
 	memcpy(buf + 3, "tracing", 7);
 
-	write_or_die(buf, 10);
+	if (write(output_fd, buf, 10) != 10)
+		return -1;
 
-	write_or_die(VERSION, strlen(VERSION) + 1);
+	size = strlen(VERSION) + 1;
+	if (write(output_fd, VERSION, size) != size)
+		return -1;
 
 	/* save endian */
 	if (bigendian())
@@ -450,14 +496,19 @@ static void tracing_data_header(void)
 
 	read_trace_init(buf[0], buf[0]);
 
-	write_or_die(buf, 1);
+	if (write(output_fd, buf, 1) != 1)
+		return -1;
 
 	/* save size of long */
 	buf[0] = sizeof(long);
-	write_or_die(buf, 1);
+	if (write(output_fd, buf, 1) != 1)
+		return -1;
 
 	/* save page_size */
-	write_or_die(&page_size, 4);
+	if (write(output_fd, &page_size, 4) != 4)
+		return -1;
+
+	return 0;
 }
 
 struct tracing_data *tracing_data_get(struct list_head *pattrs,
@@ -465,6 +516,7 @@ struct tracing_data *tracing_data_get(struct list_head *pattrs,
 {
 	struct tracepoint_path *tps;
 	struct tracing_data *tdata;
+	int err;
 
 	output_fd = fd;
 
@@ -498,13 +550,24 @@ struct tracing_data *tracing_data_get(struct list_head *pattrs,
 		output_fd = temp_fd;
 	}
 
-	tracing_data_header();
-	read_header_files();
-	read_ftrace_files(tps);
-	read_event_files(tps);
-	read_proc_kallsyms();
-	read_ftrace_printk();
+	err = tracing_data_header();
+	if (err)
+		goto out;
+	err = read_header_files();
+	if (err)
+		goto out;
+	err = read_ftrace_files(tps);
+	if (err)
+		goto out;
+	err = read_event_files(tps);
+	if (err)
+		goto out;
+	err = read_proc_kallsyms();
+	if (err)
+		goto out;
+	err = read_ftrace_printk();
 
+out:
 	/*
 	 * All tracing data are stored by now, we can restore
 	 * the default output file in case we used temp file.
@@ -515,22 +578,31 @@ struct tracing_data *tracing_data_get(struct list_head *pattrs,
 		output_fd = fd;
 	}
 
+	if (err) {
+		free(tdata);
+		tdata = NULL;
+	}
+
 	put_tracepoints_path(tps);
 	return tdata;
 }
 
-void tracing_data_put(struct tracing_data *tdata)
+int tracing_data_put(struct tracing_data *tdata)
 {
+	int err = 0;
+
 	if (tdata->temp) {
-		record_file(tdata->temp_file, 0);
+		err = record_file(tdata->temp_file, 0);
 		unlink(tdata->temp_file);
 	}
 
 	free(tdata);
+	return err;
 }
 
 int read_tracing_data(int fd, struct list_head *pattrs)
 {
+	int err;
 	struct tracing_data *tdata;
 
 	/*
@@ -541,6 +613,6 @@ int read_tracing_data(int fd, struct list_head *pattrs)
 	if (!tdata)
 		return -ENOMEM;
 
-	tracing_data_put(tdata);
-	return 0;
+	err = tracing_data_put(tdata);
+	return err;
 }
diff --git a/tools/perf/util/trace-event.h b/tools/perf/util/trace-event.h
index 28ccde8ba20f..1978c398ad87 100644
--- a/tools/perf/util/trace-event.h
+++ b/tools/perf/util/trace-event.h
@@ -68,7 +68,7 @@ struct tracing_data {
 
 struct tracing_data *tracing_data_get(struct list_head *pattrs,
 				      int fd, bool temp);
-void tracing_data_put(struct tracing_data *tdata);
+int tracing_data_put(struct tracing_data *tdata);
 
 
 struct addr_location;
-- 
1.7.11.7

