Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751909Ab3LKMip (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Dec 2013 07:38:45 -0500
Received: from mga09.intel.com ([134.134.136.24]:32257 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751527Ab3LKMil (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Dec 2013 07:38:41 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.93,871,1378882800"; 
   d="scan'208";a="442368176"
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
Subject: [PATCH v0 11/71] perf tools: Add perf_event_paranoid()
Date: Wed, 11 Dec 2013 14:36:23 +0200
Message-Id: <1386765443-26966-12-git-send-email-alexander.shishkin@linux.intel.com>
X-Mailer: git-send-email 1.8.4.rc2
In-Reply-To: <1386765443-26966-1-git-send-email-alexander.shishkin@linux.intel.com>
References: <1386765443-26966-1-git-send-email-alexander.shishkin@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Adrian Hunter <adrian.hunter@intel.com>

Add a function to return the value of
/proc/sys/kernel/perf_event_paranoid.

This will be used to determine default
values for mmap size because perf is not
subject to mmap limits when
perf_event_paranoid is less than zero.

Signed-off-by: Adrian Hunter <adrian.hunter@intel.com>
---
 tools/perf/util/evlist.c |  3 +--
 tools/perf/util/util.c   | 19 +++++++++++++++++++
 tools/perf/util/util.h   |  3 +++
 3 files changed, 23 insertions(+), 2 deletions(-)

diff --git a/tools/perf/util/evlist.c b/tools/perf/util/evlist.c
index 7bb6ee1..50fadde 100644
--- a/tools/perf/util/evlist.c
+++ b/tools/perf/util/evlist.c
@@ -1189,8 +1189,7 @@ int perf_evlist__strerror_open(struct perf_evlist *evlist __maybe_unused,
 				    "Error:\t%s.\n"
 				    "Hint:\tCheck /proc/sys/kernel/perf_event_paranoid setting.", emsg);
 
-		if (filename__read_int("/proc/sys/kernel/perf_event_paranoid", &value))
-			break;
+		value = perf_event_paranoid();
 
 		printed += scnprintf(buf + printed, size - printed, "\nHint:\t");
 
diff --git a/tools/perf/util/util.c b/tools/perf/util/util.c
index bae8756..3aed4af 100644
--- a/tools/perf/util/util.c
+++ b/tools/perf/util/util.c
@@ -1,5 +1,6 @@
 #include "../perf.h"
 #include "util.h"
+#include "fs.h"
 #include <sys/mman.h>
 #ifdef HAVE_BACKTRACE_SUPPORT
 #include <execinfo.h>
@@ -8,6 +9,7 @@
 #include <stdlib.h>
 #include <string.h>
 #include <errno.h>
+#include <limits.h>
 #include <linux/kernel.h>
 
 /*
@@ -482,3 +484,20 @@ int filename__read_str(const char *filename, char **buf, size_t *sizep)
 	close(fd);
 	return err;
 }
+
+int perf_event_paranoid(void)
+{
+	char path[PATH_MAX];
+	const char *procfs = procfs__mountpoint();
+	int value;
+
+	if (!procfs)
+		return INT_MAX;
+
+	scnprintf(path, PATH_MAX, "%s/sys/kernel/perf_event_paranoid", procfs);
+
+	if (filename__read_int(path, &value))
+		return INT_MAX;
+
+	return value;
+}
diff --git a/tools/perf/util/util.h b/tools/perf/util/util.h
index adb39f2..4b6b260 100644
--- a/tools/perf/util/util.h
+++ b/tools/perf/util/util.h
@@ -309,4 +309,7 @@ void free_srcline(char *srcline);
 
 int filename__read_int(const char *filename, int *value);
 int filename__read_str(const char *filename, char **buf, size_t *sizep);
+
+int perf_event_paranoid(void);
+
 #endif /* GIT_COMPAT_UTIL_H */
-- 
1.8.5.1

