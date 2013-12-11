Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751872Ab3LKMif (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Dec 2013 07:38:35 -0500
Received: from mga09.intel.com ([134.134.136.24]:60093 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751808Ab3LKMia (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Dec 2013 07:38:30 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.93,871,1378882800"; 
   d="scan'208";a="422885184"
From: Alexander Shishkin <alexander.shishkin@linux.intel.com>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: Ingo Molnar <mingo@redhat.com>, linux-kernel@vger.kernel.org,
        David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Jiri Olsa <jolsa@redhat.com>,
        Mike Galbraith <efault@gmx.de>, Namhyung Kim <namhyung@gmail.com>,
        Paul Mackerras <paulus@samba.org>,
        Stephane Eranian <eranian@google.com>, Andi Kleen <ak@linux.intel.com>,
        Adrian Hunter <adrian.hunter@intel.com>
Subject: [PATCH v0 10/71] perf tools: Add perf_pmu__scan_file()
Date: Wed, 11 Dec 2013 14:36:22 +0200
Message-Id: <1386765443-26966-11-git-send-email-alexander.shishkin@linux.intel.com>
X-Mailer: git-send-email 1.8.4.rc2
In-Reply-To: <1386765443-26966-1-git-send-email-alexander.shishkin@linux.intel.com>
References: <1386765443-26966-1-git-send-email-alexander.shishkin@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Adrian Hunter <adrian.hunter@intel.com>

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
index a53b8ac..a742eeb 100644
--- a/tools/perf/util/pmu.c
+++ b/tools/perf/util/pmu.c
@@ -3,6 +3,7 @@
 #include <unistd.h>
 #include <stdio.h>
 #include <stdbool.h>
+#include <stdarg.h>
 #include <dirent.h>
 #include "fs.h"
 #include <locale.h>
@@ -788,3 +789,39 @@ bool pmu_have_event(const char *pname, const char *name)
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
index df762fd..437fdb2 100644
--- a/tools/perf/util/pmu.h
+++ b/tools/perf/util/pmu.h
@@ -49,6 +49,9 @@ struct perf_pmu *perf_pmu__scan(struct perf_pmu *pmu);
 void print_pmu_events(const char *event_glob, bool name_only);
 bool pmu_have_event(const char *pname, const char *name);
 
+int perf_pmu__scan_file(struct perf_pmu *pmu, const char *name,
+		const char *fmt, ...) __attribute__((format(scanf, 3, 4)));
+
 int perf_pmu__test(void);
 
 struct perf_event_attr *perf_pmu__get_default_config(struct perf_pmu *pmu);
-- 
1.8.5.1

