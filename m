Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754409AbaCXThx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Mar 2014 15:37:53 -0400
Received: from mx1.redhat.com ([209.132.183.28]:28834 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754393AbaCXTht (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Mar 2014 15:37:49 -0400
From: Don Zickus <dzickus@redhat.com>
To: acme@ghostprotocols.net
Cc: LKML <linux-kernel@vger.kernel.org>, jolsa@redhat.com, jmario@redhat.com,
        fowles@inreach.com, peterz@infradead.org, eranian@google.com,
        andi.kleen@intel.com, Don Zickus <dzickus@redhat.com>
Subject: [PATCH 06/15 V3] perf, c2c: Add in new options to configure latency and stores
Date: Mon, 24 Mar 2014 15:36:57 -0400
Message-Id: <1395689826-215033-7-git-send-email-dzickus@redhat.com>
In-Reply-To: <1395689826-215033-1-git-send-email-dzickus@redhat.com>
References: <1395689826-215033-1-git-send-email-dzickus@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Modified the code to allow latency settings to be tweaked on the command line
and also the ability to dynamically profile stores (or disable using stores).

This allows the tool to be used on older Intel platforms like Westmere.

Signed-off-by: Don Zickus <dzickus@redhat.com>
---
 tools/perf/builtin-c2c.c | 73 +++++++++++++++++++++++++++++++++++++++++++-----
 1 file changed, 66 insertions(+), 7 deletions(-)

diff --git a/tools/perf/builtin-c2c.c b/tools/perf/builtin-c2c.c
index 72dd9d5..d7eaf81 100644
--- a/tools/perf/builtin-c2c.c
+++ b/tools/perf/builtin-c2c.c
@@ -6,6 +6,7 @@
 #include "util/session.h"
 #include "util/tool.h"
 #include "util/debug.h"
+#include <api/fs/fs.h>
 
 #include <linux/compiler.h>
 #include <linux/kernel.h>
@@ -17,6 +18,12 @@ struct perf_c2c {
 
 enum { OP, LVL, SNP, LCK, TLB };
 
+#define DEFAULT_LATENCY_THRES	30
+#define DEFAULT_PRECISION	1
+static int lat_level = DEFAULT_LATENCY_THRES;
+static int prec_level = DEFAULT_PRECISION;
+static bool no_stores = false;
+
 static int perf_c2c__scnprintf_data_src(char *bf, size_t size, uint64_t val)
 {
 #define PREFIX       "["
@@ -159,9 +166,10 @@ static int perf_c2c__process_load_store(struct perf_c2c *c2c,
 	return 0;
 }
 
+/* setup the basic events for most coverage, options added later */
 static const struct perf_evsel_str_handler handlers[] = {
-	{ "cpu/mem-loads,ldlat=30/pp", perf_c2c__process_load_store, },
-	{ "cpu/mem-stores/pp",	       perf_c2c__process_load_store, },
+	{ "cpu/mem-loads", 		perf_c2c__process_load_store, },
+	{ "cpu/mem-stores",		perf_c2c__process_load_store, },
 };
 
 typedef int (*sample_handler)(struct perf_c2c *c2c,
@@ -246,7 +254,8 @@ static int perf_c2c__read_events(struct perf_c2c *c2c)
 		unsigned int i;
 
 		for (i = 0; i < ARRAY_SIZE(handlers); i++) {
-			if (!strcmp(name, handlers[i].name))
+			if (!strncmp(name, handlers[i].name,
+				     sizeof(handlers[i].name)))
 				evsel->handler = handlers[i].handler;
 		}
 	}
@@ -269,7 +278,7 @@ static int perf_c2c__report(struct perf_c2c *c2c)
 
 static int perf_c2c__record(int argc, const char **argv)
 {
-	unsigned int rec_argc, i, j;
+	unsigned int rec_argc, i, j, n;
 	const char **rec_argv;
 	const char * const record_args[] = {
 		"record",
@@ -277,8 +286,21 @@ static int perf_c2c__record(int argc, const char **argv)
 		"-d",
 		"-a",
 	};
+	char lat[16], prec[4] = "/";
+	char buf[256];
+
+	snprintf(lat, sizeof(lat), "ldlat=%d", lat_level);
+
+	if (prec_level > 3)
+		prec_level = 3;
+
+	for (i = 0; i < (unsigned int)prec_level; i++)
+		prec[i+1] = 'p';
+
+	/* how many events to pass in */
+	n = (no_stores) ? 1 : 2;
 
-	rec_argc = ARRAY_SIZE(record_args) + 2 * ARRAY_SIZE(handlers) + argc - 1;
+	rec_argc = ARRAY_SIZE(record_args) + 2 * n + argc - 1;
 	rec_argv = calloc(rec_argc + 1, sizeof(char *));
 
 	if (rec_argv == NULL)
@@ -287,9 +309,16 @@ static int perf_c2c__record(int argc, const char **argv)
 	for (i = 0; i < ARRAY_SIZE(record_args); i++)
 		rec_argv[i] = strdup(record_args[i]);
 
-	for (j = 0; j < ARRAY_SIZE(handlers); j++) {
+	/* mem-loads is first index */
+	snprintf(buf, sizeof(buf), "%s,%s%s", handlers[0].name, lat, prec);
+	rec_argv[i++] = strdup("-e");
+	rec_argv[i++] = strdup(buf);
+
+	if (!no_stores) {
+		/* mem-stores is second index */
 		rec_argv[i++] = strdup("-e");
-		rec_argv[i++] = strdup(handlers[j].name);
+		snprintf(buf, sizeof(buf), "%s%s", handlers[1].name, prec);
+		rec_argv[i++] = strdup(buf);
 	}
 
 	for (j = 1; j < (unsigned int)argc; j++, i++)
@@ -300,6 +329,30 @@ static int perf_c2c__record(int argc, const char **argv)
 	return cmd_record(i, rec_argv, NULL);
 }
 
+static int
+opt_no_stores_cb(const struct option *opt __maybe_unused, const char *arg __maybe_unused, int unset)
+{
+	int ret;
+
+	if (unset) {
+		struct stat st;
+		char path[PATH_MAX];
+
+		snprintf(path, PATH_MAX, "%s/bus/event_source/devices/cpu/events/mem-stores",
+			 sysfs__mountpoint());
+
+		ret = stat(path, &st);
+		if (ret) {
+			pr_debug("Omitting mem-stores event");
+			no_stores = true;
+		}
+		return 0;
+	}
+
+	no_stores = true;
+	return 0;
+}
+
 int cmd_c2c(int argc, const char **argv, const char *prefix __maybe_unused)
 {
 	struct perf_c2c c2c = {
@@ -316,6 +369,12 @@ int cmd_c2c(int argc, const char **argv, const char *prefix __maybe_unused)
 	};
 	const struct option c2c_options[] = {
 	OPT_BOOLEAN('r', "raw_records", &c2c.raw_records, "dump raw events"),
+	OPT_INTEGER('l', "latency-level", &lat_level,
+		 "specify the latency threshold for loads [default=30]"),
+	OPT_INTEGER('p', "precision-level", &prec_level,
+		 "specify the precision level of events (0,1,2,3) [default=1]"),
+	OPT_CALLBACK_NOOPT(0, "no-stores", &no_stores, "",
+			   "do not record stores", &opt_no_stores_cb),
 	OPT_INCR('v', "verbose", &verbose,
 		 "be more verbose (show counter open errors, etc)"),
 	OPT_STRING('i', "input", &input_name, "file",
-- 
1.7.11.7

