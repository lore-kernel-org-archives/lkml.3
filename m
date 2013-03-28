Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757028Ab3C1RNL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Mar 2013 13:13:11 -0400
Received: from 173-166-109-252-newengland.hfc.comcastbusiness.net ([173.166.109.252]:47727
	"EHLO bombadil.infradead.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756617Ab3C1RCt (ORCPT
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
Subject: [PATCH 02/36] perf tools: Let get_tracing_file() return NULL to indicate failure.
Date: Thu, 28 Mar 2013 14:02:02 -0300
Message-Id: <1364490156-32064-3-git-send-email-acme@infradead.org>
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

So that it can be used by other places.

Signed-off-by: Namhyung Kim <namhyung@kernel.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Steven Rostedt <rostedt@goodmis.org>
Link: http://lkml.kernel.org/r/1363850332-25297-2-git-send-email-namhyung@kernel.org
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/util/trace-event-info.c |   25 ++++++++++++++++++++++---
 1 files changed, 22 insertions(+), 3 deletions(-)

diff --git a/tools/perf/util/trace-event-info.c b/tools/perf/util/trace-event-info.c
index 5729f43..81c6732 100644
--- a/tools/perf/util/trace-event-info.c
+++ b/tools/perf/util/trace-event-info.c
@@ -62,7 +62,7 @@ static const char *find_debugfs(void)
 	const char *path = perf_debugfs_mount(NULL);
 
 	if (!path)
-		die("Your kernel not support debugfs filesystem");
+		pr_debug("Your kernel does not support the debugfs filesystem");
 
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
1.7.1

