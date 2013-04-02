Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761379Ab3DBJXL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Apr 2013 05:23:11 -0400
Received: from terminus.zytor.com ([198.137.202.10]:50508 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760952Ab3DBJXI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Apr 2013 05:23:08 -0400
Date: Tue, 2 Apr 2013 02:22:37 -0700
From: tip-bot for Namhyung Kim <tipbot@zytor.com>
Message-ID: <tip-454f8c7d26fa7e1545df4efca5d9ba929ccef1e8@git.kernel.org>
Cc: acme@redhat.com, linux-kernel@vger.kernel.org, paulus@samba.org,
        hpa@zytor.com, mingo@kernel.org, a.p.zijlstra@chello.nl,
        namhyung.kim@lge.com, namhyung@kernel.org, fweisbec@gmail.com,
        rostedt@goodmis.org, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, paulus@samba.org,
        linux-kernel@vger.kernel.org, acme@redhat.com, a.p.zijlstra@chello.nl,
        namhyung.kim@lge.com, namhyung@kernel.org, fweisbec@gmail.com,
        rostedt@goodmis.org, tglx@linutronix.de
In-Reply-To: <1363850332-25297-2-git-send-email-namhyung@kernel.org>
References: <1363850332-25297-2-git-send-email-namhyung@kernel.org>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf tools: Let get_tracing_file()
  return NULL to indicate failure.
Git-Commit-ID: 454f8c7d26fa7e1545df4efca5d9ba929ccef1e8
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.7 (terminus.zytor.com [127.0.0.1]); Tue, 02 Apr 2013 02:22:43 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  454f8c7d26fa7e1545df4efca5d9ba929ccef1e8
Gitweb:     http://git.kernel.org/tip/454f8c7d26fa7e1545df4efca5d9ba929ccef1e8
Author:     Namhyung Kim <namhyung.kim@lge.com>
AuthorDate: Thu, 21 Mar 2013 16:18:44 +0900
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Thu, 21 Mar 2013 13:09:42 -0300

perf tools: Let get_tracing_file() return NULL to indicate failure.

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
 tools/perf/util/trace-event-info.c | 25 ++++++++++++++++++++++---
 1 file changed, 22 insertions(+), 3 deletions(-)

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
