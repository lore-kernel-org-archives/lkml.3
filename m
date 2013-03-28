Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756804Ab3C1RCu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Mar 2013 13:02:50 -0400
Received: from merlin.infradead.org ([205.233.59.134]:36257 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755610Ab3C1RCs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Mar 2013 13:02:48 -0400
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org, Namhyung Kim <namhyung.kim@lge.com>,
        Namhyung Kim <namhyung@kernel.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Steven Rostedt <rostedt@goodmis.org>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 03/36] perf tools: Get rid of malloc_or_die() in trace-event-info.c
Date: Thu, 28 Mar 2013 14:02:03 -0300
Message-Id: <1364490156-32064-4-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.8.1.1.361.gec3ae6e
In-Reply-To: <1364490156-32064-1-git-send-email-acme@infradead.org>
References: <1364490156-32064-1-git-send-email-acme@infradead.org>
Content-Type: text/plain; charset="utf-8"
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by merlin.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Namhyung Kim <namhyung.kim@lge.com>

Check return value of malloc and fail if NULL.

Signed-off-by: Namhyung Kim <namhyung@kernel.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Steven Rostedt <rostedt@goodmis.org>
Link: http://lkml.kernel.org/r/1363850332-25297-3-git-send-email-namhyung@kernel.org
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/util/trace-event-info.c |   48 ++++++++++++++++++++++-------------
 1 files changed, 30 insertions(+), 18 deletions(-)

diff --git a/tools/perf/util/trace-event-info.c b/tools/perf/util/trace-event-info.c
index 81c6732..91db6e8 100644
--- a/tools/perf/util/trace-event-info.c
+++ b/tools/perf/util/trace-event-info.c
@@ -47,16 +47,6 @@ static const char *output_file = "trace.info";
 static int output_fd;
 
 
-static void *malloc_or_die(unsigned int size)
-{
-	void *data;
-
-	data = malloc(size);
-	if (!data)
-		die("malloc");
-	return data;
-}
-
 static const char *find_debugfs(void)
 {
 	const char *path = perf_debugfs_mount(NULL);
@@ -209,7 +199,7 @@ static bool name_in_tp_list(char *sys, struct tracepoint_path *tps)
 	return false;
 }
 
-static void copy_event_system(const char *sys, struct tracepoint_path *tps)
+static int copy_event_system(const char *sys, struct tracepoint_path *tps)
 {
 	struct dirent *dent;
 	struct stat st;
@@ -217,6 +207,7 @@ static void copy_event_system(const char *sys, struct tracepoint_path *tps)
 	DIR *dir;
 	int count = 0;
 	int ret;
+	int err;
 
 	dir = opendir(sys);
 	if (!dir)
@@ -228,7 +219,11 @@ static void copy_event_system(const char *sys, struct tracepoint_path *tps)
 		    strcmp(dent->d_name, "..") == 0 ||
 		    !name_in_tp_list(dent->d_name, tps))
 			continue;
-		format = malloc_or_die(strlen(sys) + strlen(dent->d_name) + 10);
+		format = malloc(strlen(sys) + strlen(dent->d_name) + 10);
+		if (!format) {
+			err = -ENOMEM;
+			goto out;
+		}
 		sprintf(format, "%s/%s/format", sys, dent->d_name);
 		ret = stat(format, &st);
 		free(format);
@@ -246,16 +241,22 @@ static void copy_event_system(const char *sys, struct tracepoint_path *tps)
 		    strcmp(dent->d_name, "..") == 0 ||
 		    !name_in_tp_list(dent->d_name, tps))
 			continue;
-		format = malloc_or_die(strlen(sys) + strlen(dent->d_name) + 10);
+		format = malloc(strlen(sys) + strlen(dent->d_name) + 10);
+		if (!format) {
+			err = -ENOMEM;
+			goto out;
+		}
 		sprintf(format, "%s/%s/format", sys, dent->d_name);
 		ret = stat(format, &st);
 
 		if (ret >= 0)
 			record_file(format, 8);
-
 		free(format);
 	}
+	err = 0;
+out:
 	closedir(dir);
+	return err;
 }
 
 static void read_ftrace_files(struct tracepoint_path *tps)
@@ -282,7 +283,7 @@ static bool system_in_tp_list(char *sys, struct tracepoint_path *tps)
 	return false;
 }
 
-static void read_event_files(struct tracepoint_path *tps)
+static int read_event_files(struct tracepoint_path *tps)
 {
 	struct dirent *dent;
 	struct stat st;
@@ -291,6 +292,7 @@ static void read_event_files(struct tracepoint_path *tps)
 	DIR *dir;
 	int count = 0;
 	int ret;
+	int err;
 
 	path = get_tracing_file("events");
 	if (!path)
@@ -320,7 +322,11 @@ static void read_event_files(struct tracepoint_path *tps)
 		    strcmp(dent->d_name, "ftrace") == 0 ||
 		    !system_in_tp_list(dent->d_name, tps))
 			continue;
-		sys = malloc_or_die(strlen(path) + strlen(dent->d_name) + 2);
+		sys = malloc(strlen(path) + strlen(dent->d_name) + 2);
+		if (!sys) {
+			err = -ENOMEM;
+			goto out;
+		}
 		sprintf(sys, "%s/%s", path, dent->d_name);
 		ret = stat(sys, &st);
 		if (ret >= 0) {
@@ -329,9 +335,12 @@ static void read_event_files(struct tracepoint_path *tps)
 		}
 		free(sys);
 	}
-
+	err = 0;
+out:
 	closedir(dir);
 	put_tracing_file(path);
+
+	return err;
 }
 
 static void read_proc_kallsyms(void)
@@ -463,7 +472,10 @@ struct tracing_data *tracing_data_get(struct list_head *pattrs,
 	if (!tps)
 		return NULL;
 
-	tdata = malloc_or_die(sizeof(*tdata));
+	tdata = malloc(sizeof(*tdata));
+	if (!tdata)
+		return NULL;
+
 	tdata->temp = temp;
 	tdata->size = 0;
 
-- 
1.7.1

