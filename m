Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757859AbaISFWF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Sep 2014 01:22:05 -0400
Received: from terminus.zytor.com ([198.137.202.10]:53003 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757080AbaISFWB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Sep 2014 01:22:01 -0400
Date: Thu, 18 Sep 2014 22:21:06 -0700
From: tip-bot for Adrian Hunter <tipbot@zytor.com>
Message-ID: <tip-7d4bdab5a441772bfc757d7f9eea9465ec5de0ec@git.kernel.org>
Cc: acme@redhat.com, linux-kernel@vger.kernel.org, eranian@google.com,
        paulus@samba.org, hpa@zytor.com, mingo@kernel.org,
        peterz@infradead.org, namhyung@gmail.com, jolsa@redhat.com,
        fweisbec@gmail.com, adrian.hunter@intel.com, dsahern@gmail.com,
        tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, paulus@samba.org,
        eranian@google.com, linux-kernel@vger.kernel.org, acme@redhat.com,
        peterz@infradead.org, namhyung@gmail.com, jolsa@redhat.com,
        fweisbec@gmail.com, dsahern@gmail.com, adrian.hunter@intel.com,
        tglx@linutronix.de
In-Reply-To: <1406786474-9306-8-git-send-email-adrian.hunter@intel.com>
References: <1406786474-9306-8-git-send-email-adrian.hunter@intel.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf tools: Add perf_pmu__scan_file()
Git-Commit-ID: 7d4bdab5a441772bfc757d7f9eea9465ec5de0ec
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

Commit-ID:  7d4bdab5a441772bfc757d7f9eea9465ec5de0ec
Gitweb:     http://git.kernel.org/tip/7d4bdab5a441772bfc757d7f9eea9465ec5de0ec
Author:     Adrian Hunter <adrian.hunter@intel.com>
AuthorDate: Thu, 31 Jul 2014 09:00:50 +0300
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Wed, 17 Sep 2014 17:08:09 -0300

perf tools: Add perf_pmu__scan_file()

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
index 438bb26..22a4ad5 100644
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
index 413b9a6..0f5c0a8 100644
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
