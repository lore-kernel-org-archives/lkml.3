Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932303AbaGHTFQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jul 2014 15:05:16 -0400
Received: from mail.kernel.org ([198.145.19.201]:58255 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932198AbaGHTEP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jul 2014 15:04:15 -0400
From: Arnaldo Carvalho de Melo <acme@kernel.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Adrian Hunter <adrian.hunter@intel.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 13/16] perf tools: Convert open coded equivalents to asprintf()
Date: Tue,  8 Jul 2014 16:03:01 -0300
Message-Id: <1404846184-20075-14-git-send-email-acme@kernel.org>
X-Mailer: git-send-email 1.9.3
In-Reply-To: <1404846184-20075-1-git-send-email-acme@kernel.org>
References: <1404846184-20075-1-git-send-email-acme@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>

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
index 7e6fcfe8b438..c3bba883f5c3 100644
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
index 95aefa78bb07..e4132aeeb780 100644
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
1.9.3

