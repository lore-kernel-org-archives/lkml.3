Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758312AbaGDLn4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Jul 2014 07:43:56 -0400
Received: from mga03.intel.com ([143.182.124.21]:24353 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752932AbaGDLnz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Jul 2014 07:43:55 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.01,600,1400050800"; 
   d="scan'208";a="453310473"
From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
To: linux-kernel@vger.kernel.org, Arnaldo Carvalho de Melo <acme@kernel.org>,
        Adrian Hunter <adrian.hunter@intel.com>
Cc: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Subject: [PATCH 1/2] perf tools: convert to asprintf()
Date: Fri,  4 Jul 2014 14:43:48 +0300
Message-Id: <1404474229-15272-1-git-send-email-andriy.shevchenko@linux.intel.com>
X-Mailer: git-send-email 2.0.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The following snippet
	V = malloc(S);
	if (!V) { }
	sprintf(V, ...)
conuld be easily changed to a one line:
	if (asprintf(&V, ...) < 0) { }

Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
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
 
-- 
2.0.1

