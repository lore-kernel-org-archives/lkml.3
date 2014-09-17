Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932210AbaIQVZX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Sep 2014 17:25:23 -0400
Received: from mail.kernel.org ([198.145.19.201]:58108 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932183AbaIQVZS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Sep 2014 17:25:18 -0400
From: Arnaldo Carvalho de Melo <acme@kernel.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org, Adrian Hunter <adrian.hunter@intel.com>,
        David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Jiri Olsa <jolsa@redhat.com>,
        Namhyung Kim <namhyung@gmail.com>, Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Stephane Eranian <eranian@google.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 10/20] perf tools: Add perf_pmu__scan_file()
Date: Wed, 17 Sep 2014 18:24:13 -0300
Message-Id: <1410989063-14207-11-git-send-email-acme@kernel.org>
X-Mailer: git-send-email 1.9.3
In-Reply-To: <1410989063-14207-1-git-send-email-acme@kernel.org>
References: <1410989063-14207-1-git-send-email-acme@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Adrian Hunter <adrian.hunter@intel.com>

Add a function to scan a sysfs file within the pmu device directory.

This will be used to read capability values from the PMU 'caps'
subdirectory.

Signed-off-by: Adrian Hunter <adrian.hunter@intel.com>
Cc: David Ahern <dsahern@gmail.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Namhyung Kim <namhyung@gmail.com>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Stephane Eranian <eranian@google.com>
Link: http://lkml.kernel.org/r/1406786474-9306-8-git-send-email-adrian.hunter@intel.com
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/util/pmu.c | 37 +++++++++++++++++++++++++++++++++++++
 tools/perf/util/pmu.h |  3 +++
 2 files changed, 40 insertions(+)

diff --git a/tools/perf/util/pmu.c b/tools/perf/util/pmu.c
index 438bb261f391..22a4ad5a927a 100644
--- a/tools/perf/util/pmu.c
+++ b/tools/perf/util/pmu.c
@@ -3,6 +3,7 @@
 #include <unistd.h>
 #include <stdio.h>
 #include <stdbool.h>
+#include <stdarg.h>
 #include <dirent.h>
 #include <api/fs/fs.h>
 #include <locale.h>
@@ -804,3 +805,39 @@ bool pmu_have_event(const char *pname, const char *name)
 	}
 	return false;
 }
+
+static FILE *perf_pmu__open_file(struct perf_pmu *pmu, const char *name)
+{
+	struct stat st;
+	char path[PATH_MAX];
+	const char *sysfs;
+
+	sysfs = sysfs__mountpoint();
+	if (!sysfs)
+		return NULL;
+
+	snprintf(path, PATH_MAX,
+		 "%s" EVENT_SOURCE_DEVICE_PATH "%s/%s", sysfs, pmu->name, name);
+
+	if (stat(path, &st) < 0)
+		return NULL;
+
+	return fopen(path, "r");
+}
+
+int perf_pmu__scan_file(struct perf_pmu *pmu, const char *name, const char *fmt,
+			...)
+{
+	va_list args;
+	FILE *file;
+	int ret = EOF;
+
+	va_start(args, fmt);
+	file = perf_pmu__open_file(pmu, name);
+	if (file) {
+		ret = vfscanf(file, fmt, args);
+		fclose(file);
+	}
+	va_end(args);
+	return ret;
+}
diff --git a/tools/perf/util/pmu.h b/tools/perf/util/pmu.h
index 413b9a63c38d..0f5c0a88fdc8 100644
--- a/tools/perf/util/pmu.h
+++ b/tools/perf/util/pmu.h
@@ -49,6 +49,9 @@ struct perf_pmu *perf_pmu__scan(struct perf_pmu *pmu);
 void print_pmu_events(const char *event_glob, bool name_only);
 bool pmu_have_event(const char *pname, const char *name);
 
+int perf_pmu__scan_file(struct perf_pmu *pmu, const char *name, const char *fmt,
+			...) __attribute__((format(scanf, 3, 4)));
+
 int perf_pmu__test(void);
 
 struct perf_event_attr *perf_pmu__get_default_config(struct perf_pmu *pmu);
-- 
1.9.3

