Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753376Ab3LMPO3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Dec 2013 10:14:29 -0500
Received: from merlin.infradead.org ([205.233.59.134]:45282 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753197Ab3LMPMV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Dec 2013 10:12:21 -0500
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org, Adrian Hunter <adrian.hunter@intel.com>,
        Andi Kleen <ak@linux.intel.com>, David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@redhat.com>, Jiri Olsa <jolsa@redhat.com>,
        Mike Galbraith <efault@gmx.de>, Namhyung Kim <namhyung@gmail.com>,
        Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Stephane Eranian <eranian@google.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 02/20] perf tools: Add perf_event_paranoid()
Date: Fri, 13 Dec 2013 12:11:48 -0300
Message-Id: <1386947526-7118-3-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.8.1.4
In-Reply-To: <1386947526-7118-1-git-send-email-acme@infradead.org>
References: <1386947526-7118-1-git-send-email-acme@infradead.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by merlin.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Adrian Hunter <adrian.hunter@intel.com>

Add a function to return the value of
/proc/sys/kernel/perf_event_paranoid.

This will be used to determine default values for mmap size because perf
is not subject to mmap limits when perf_event_paranoid is less than
zero.

Signed-off-by: Adrian Hunter <adrian.hunter@intel.com>
Cc: Andi Kleen <ak@linux.intel.com>
Cc: David Ahern <dsahern@gmail.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Namhyung Kim <namhyung@gmail.com>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Stephane Eranian <eranian@google.com>
Link: http://lkml.kernel.org/r/1386765443-26966-12-git-send-email-alexander.shishkin@linux.intel.com
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/util/evlist.c |  3 +--
 tools/perf/util/util.c   | 19 +++++++++++++++++++
 tools/perf/util/util.h   |  1 +
 3 files changed, 21 insertions(+), 2 deletions(-)

diff --git a/tools/perf/util/evlist.c b/tools/perf/util/evlist.c
index af250556b33f..2eb7378e4c40 100644
--- a/tools/perf/util/evlist.c
+++ b/tools/perf/util/evlist.c
@@ -1191,8 +1191,7 @@ int perf_evlist__strerror_open(struct perf_evlist *evlist __maybe_unused,
 				    "Error:\t%s.\n"
 				    "Hint:\tCheck /proc/sys/kernel/perf_event_paranoid setting.", emsg);
 
-		if (filename__read_int("/proc/sys/kernel/perf_event_paranoid", &value))
-			break;
+		value = perf_event_paranoid();
 
 		printed += scnprintf(buf + printed, size - printed, "\nHint:\t");
 
diff --git a/tools/perf/util/util.c b/tools/perf/util/util.c
index 4a57609c0b43..8f63dba212d7 100644
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
@@ -496,3 +498,20 @@ const char *get_filename_for_perf_kvm(void)
 
 	return filename;
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
index 0171213d1d4d..1e7d4136cc82 100644
--- a/tools/perf/util/util.h
+++ b/tools/perf/util/util.h
@@ -321,6 +321,7 @@ void free_srcline(char *srcline);
 
 int filename__read_int(const char *filename, int *value);
 int filename__read_str(const char *filename, char **buf, size_t *sizep);
+int perf_event_paranoid(void);
 
 const char *get_filename_for_perf_kvm(void);
 #endif /* GIT_COMPAT_UTIL_H */
-- 
1.8.1.4

