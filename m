Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752794AbaGVNUW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jul 2014 09:20:22 -0400
Received: from mga02.intel.com ([134.134.136.20]:45360 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752228AbaGVNUT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jul 2014 09:20:19 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.01,710,1400050800"; 
   d="scan'208";a="576985501"
From: Adrian Hunter <adrian.hunter@intel.com>
To: Arnaldo Carvalho de Melo <acme@kernel.org>
Cc: Peter Zijlstra <peterz@infradead.org>, linux-kernel@vger.kernel.org,
        David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Jiri Olsa <jolsa@redhat.com>,
        Namhyung Kim <namhyung@gmail.com>, Paul Mackerras <paulus@samba.org>,
        Stephane Eranian <eranian@google.com>
Subject: [PATCH 13/52] perf tools: Add perf_pmu__scan_file()
Date: Tue, 22 Jul 2014 16:17:22 +0300
Message-Id: <1406035081-14301-14-git-send-email-adrian.hunter@intel.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1406035081-14301-1-git-send-email-adrian.hunter@intel.com>
References: <1406035081-14301-1-git-send-email-adrian.hunter@intel.com>
Organization: Intel Finland Oy, Registered Address: PL 281, 00181 Helsinki, Business Identity Code: 0357606 - 4, Domiciled in Helsinki
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add a function to scan a sysfs file within the pmu device
directory.

This will be used to read capability values from the PMU
'caps' subdirectory.

Signed-off-by: Adrian Hunter <adrian.hunter@intel.com>
---
 tools/perf/util/pmu.c | 37 +++++++++++++++++++++++++++++++++++++
 tools/perf/util/pmu.h |  3 +++
 2 files changed, 40 insertions(+)

diff --git a/tools/perf/util/pmu.c b/tools/perf/util/pmu.c
index 11ec977..348d1d2 100644
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
index 281d5b1..c35f578 100644
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
1.8.3.2

