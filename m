Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965860AbaGPTRT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jul 2014 15:17:19 -0400
Received: from terminus.zytor.com ([198.137.202.10]:44148 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965804AbaGPTRQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jul 2014 15:17:16 -0400
Date: Wed, 16 Jul 2014 12:17:01 -0700
From: tip-bot for Andy Shevchenko <tipbot@zytor.com>
Message-ID: <tip-d400a68d1f1e7a1fc7c5caf9024d4e67b218558d@git.kernel.org>
Cc: acme@redhat.com, linux-kernel@vger.kernel.org, hpa@zytor.com,
        mingo@kernel.org, adrian.hunter@intel.com, tglx@linutronix.de,
        andriy.shevchenko@linux.intel.com
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        acme@redhat.com, adrian.hunter@intel.com, tglx@linutronix.de,
        andriy.shevchenko@linux.intel.com
In-Reply-To: <1404474229-15272-1-git-send-email-andriy.shevchenko@linux.intel.com>
References: <1404474229-15272-1-git-send-email-andriy.shevchenko@linux.intel.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf tools:
  Convert open coded equivalents to asprintf()
Git-Commit-ID: d400a68d1f1e7a1fc7c5caf9024d4e67b218558d
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  d400a68d1f1e7a1fc7c5caf9024d4e67b218558d
Gitweb:     http://git.kernel.org/tip/d400a68d1f1e7a1fc7c5caf9024d4e67b218558d
Author:     Andy Shevchenko <andriy.shevchenko@linux.intel.com>
AuthorDate: Fri, 4 Jul 2014 14:43:48 +0300
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Mon, 7 Jul 2014 16:55:24 -0300

perf tools: Convert open coded equivalents to asprintf()

The following snippet
	V = malloc(S);
	if (!V) { }
	sprintf(V, ...)

Can be easily changed to a one line:

	if (asprintf(&V, ...) < 0) { }

Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Cc: Adrian Hunter <adrian.hunter@intel.com>
Link: http://lkml.kernel.org/r/1404474229-15272-1-git-send-email-andriy.shevchenko@linux.intel.com
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/util/trace-event-info.c | 12 +++---------
 tools/perf/util/util.c             |  9 ++-------
 2 files changed, 5 insertions(+), 16 deletions(-)

diff --git a/tools/perf/util/trace-event-info.c b/tools/perf/util/trace-event-info.c
index 7e6fcfe..c3bba88 100644
--- a/tools/perf/util/trace-event-info.c
+++ b/tools/perf/util/trace-event-info.c
@@ -191,12 +191,10 @@ static int copy_event_system(const char *sys, struct tracepoint_path *tps)
 		    strcmp(dent->d_name, "..") == 0 ||
 		    !name_in_tp_list(dent->d_name, tps))
 			continue;
-		format = malloc(strlen(sys) + strlen(dent->d_name) + 10);
-		if (!format) {
+		if (asprintf(&format, "%s/%s/format", sys, dent->d_name) < 0) {
 			err = -ENOMEM;
 			goto out;
 		}
-		sprintf(format, "%s/%s/format", sys, dent->d_name);
 		ret = stat(format, &st);
 		free(format);
 		if (ret < 0)
@@ -217,12 +215,10 @@ static int copy_event_system(const char *sys, struct tracepoint_path *tps)
 		    strcmp(dent->d_name, "..") == 0 ||
 		    !name_in_tp_list(dent->d_name, tps))
 			continue;
-		format = malloc(strlen(sys) + strlen(dent->d_name) + 10);
-		if (!format) {
+		if (asprintf(&format, "%s/%s/format", sys, dent->d_name) < 0) {
 			err = -ENOMEM;
 			goto out;
 		}
-		sprintf(format, "%s/%s/format", sys, dent->d_name);
 		ret = stat(format, &st);
 
 		if (ret >= 0) {
@@ -317,12 +313,10 @@ static int record_event_files(struct tracepoint_path *tps)
 		    strcmp(dent->d_name, "ftrace") == 0 ||
 		    !system_in_tp_list(dent->d_name, tps))
 			continue;
-		sys = malloc(strlen(path) + strlen(dent->d_name) + 2);
-		if (!sys) {
+		if (asprintf(&sys, "%s/%s", path, dent->d_name) < 0) {
 			err = -ENOMEM;
 			goto out;
 		}
-		sprintf(sys, "%s/%s", path, dent->d_name);
 		ret = stat(sys, &st);
 		if (ret >= 0) {
 			ssize_t size = strlen(dent->d_name) + 1;
diff --git a/tools/perf/util/util.c b/tools/perf/util/util.c
index 95aefa7..e4132ae 100644
--- a/tools/perf/util/util.c
+++ b/tools/perf/util/util.c
@@ -333,12 +333,9 @@ const char *find_tracing_dir(void)
 	if (!debugfs)
 		return NULL;
 
-	tracing = malloc(strlen(debugfs) + 9);
-	if (!tracing)
+	if (asprintf(&tracing, "%s/tracing", debugfs) < 0)
 		return NULL;
 
-	sprintf(tracing, "%s/tracing", debugfs);
-
 	tracing_found = 1;
 	return tracing;
 }
@@ -352,11 +349,9 @@ char *get_tracing_file(const char *name)
 	if (!tracing)
 		return NULL;
 
-	file = malloc(strlen(tracing) + strlen(name) + 2);
-	if (!file)
+	if (asprintf(&file, "%s/%s", tracing, name) < 0)
 		return NULL;
 
-	sprintf(file, "%s/%s", tracing, name);
 	return file;
 }
 
