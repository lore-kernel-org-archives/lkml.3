Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757786Ab3CSIxx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Mar 2013 04:53:53 -0400
Received: from LGEMRELSE7Q.lge.com ([156.147.1.151]:61599 "EHLO
	LGEMRELSE7Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755984Ab3CSIxs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Mar 2013 04:53:48 -0400
X-AuditID: 9c930197-b7cc2ae000000eb7-7b-5148279baefe
From: Namhyung Kim <namhyung@kernel.org>
To: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Paul Mackerras <paulus@samba.org>,
        Ingo Molnar <mingo@kernel.org>, Namhyung Kim <namhyung.kim@lge.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Frederic Weisbecker <fweisbec@gmail.com>
Subject: [PATCH 1/9] perf util: Let get_tracing_file() can return NULL
Date: Tue, 19 Mar 2013 17:53:36 +0900
Message-Id: <1363683224-28804-2-git-send-email-namhyung@kernel.org>
X-Mailer: git-send-email 1.7.11.7
In-Reply-To: <1363683224-28804-1-git-send-email-namhyung@kernel.org>
References: <1363683224-28804-1-git-send-email-namhyung@kernel.org>
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Namhyung Kim <namhyung.kim@lge.com>

So that it can be used by other places.

Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Signed-off-by: Namhyung Kim <namhyung@kernel.org>
---
 tools/perf/util/trace-event-info.c | 25 ++++++++++++++++++++++---
 1 file changed, 22 insertions(+), 3 deletions(-)

diff --git a/tools/perf/util/trace-event-info.c b/tools/perf/util/trace-event-info.c
index 5729f434c5b1..f241343b7d48 100644
--- a/tools/perf/util/trace-event-info.c
+++ b/tools/perf/util/trace-event-info.c
@@ -62,7 +62,7 @@ static const char *find_debugfs(void)
 	const char *path = perf_debugfs_mount(NULL);
 
 	if (!path)
-		die("Your kernel not support debugfs filesystem");
+		pr_err("Your kernel not support debugfs filesystem");
 
 	return path;
 }
@@ -81,8 +81,12 @@ static const char *find_tracing_dir(void)
 		return tracing;
 
 	debugfs = find_debugfs();
+	if (!debugfs)
+		return NULL;
 
-	tracing = malloc_or_die(strlen(debugfs) + 9);
+	tracing = malloc(strlen(debugfs) + 9);
+	if (!tracing)
+		return NULL;
 
 	sprintf(tracing, "%s/tracing", debugfs);
 
@@ -99,7 +103,9 @@ static char *get_tracing_file(const char *name)
 	if (!tracing)
 		return NULL;
 
-	file = malloc_or_die(strlen(tracing) + strlen(name) + 2);
+	file = malloc(strlen(tracing) + strlen(name) + 2);
+	if (!file)
+		return NULL;
 
 	sprintf(file, "%s/%s", tracing, name);
 	return file;
@@ -170,6 +176,9 @@ static void read_header_files(void)
 	struct stat st;
 
 	path = get_tracing_file("events/header_page");
+	if (!path)
+		die("can't get tracing/events/header_page");
+
 	if (stat(path, &st) < 0)
 		die("can't read '%s'", path);
 
@@ -178,6 +187,9 @@ static void read_header_files(void)
 	put_tracing_file(path);
 
 	path = get_tracing_file("events/header_event");
+	if (!path)
+		die("can't get tracing/events/header_event");
+
 	if (stat(path, &st) < 0)
 		die("can't read '%s'", path);
 
@@ -251,6 +263,8 @@ static void read_ftrace_files(struct tracepoint_path *tps)
 	char *path;
 
 	path = get_tracing_file("events/ftrace");
+	if (!path)
+		die("can't get tracing/events/ftrace");
 
 	copy_event_system(path, tps);
 
@@ -279,6 +293,8 @@ static void read_event_files(struct tracepoint_path *tps)
 	int ret;
 
 	path = get_tracing_file("events");
+	if (!path)
+		die("can't get tracing/events");
 
 	dir = opendir(path);
 	if (!dir)
@@ -343,6 +359,9 @@ static void read_ftrace_printk(void)
 	int ret;
 
 	path = get_tracing_file("printk_formats");
+	if (!path)
+		die("can't get tracing/printk_formats");
+
 	ret = stat(path, &st);
 	if (ret < 0) {
 		/* not found */
-- 
1.7.11.7

