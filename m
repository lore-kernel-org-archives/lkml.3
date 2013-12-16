Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754646Ab3LPP11 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Dec 2013 10:27:27 -0500
Received: from terminus.zytor.com ([198.137.202.10]:47585 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754092Ab3LPP1X (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Dec 2013 10:27:23 -0500
Date: Mon, 16 Dec 2013 07:26:46 -0800
From: tip-bot for Adrian Hunter <tipbot@zytor.com>
Message-ID: <tip-1a47245d2f3bf6276c95cd37901b562962d6ae47@git.kernel.org>
Cc: acme@redhat.com, eranian@google.com, mingo@redhat.com, mingo@kernel.org,
        a.p.zijlstra@chello.nl, efault@gmx.de, jolsa@redhat.com,
        fweisbec@gmail.com, ak@linux.intel.com, dsahern@gmail.com,
        tglx@linutronix.de, hpa@zytor.com, paulus@samba.org,
        linux-kernel@vger.kernel.org, namhyung@gmail.com,
        adrian.hunter@intel.com
Reply-To: mingo@kernel.org, mingo@redhat.com, eranian@google.com,
        acme@redhat.com, a.p.zijlstra@chello.nl, efault@gmx.de,
        jolsa@redhat.com, fweisbec@gmail.com, dsahern@gmail.com,
        ak@linux.intel.com, tglx@linutronix.de, hpa@zytor.com,
        paulus@samba.org, linux-kernel@vger.kernel.org, namhyung@gmail.com,
        adrian.hunter@intel.com
In-Reply-To: <1386765443-26966-12-git-send-email-alexander.shishkin@linux.intel.com>
References: <1386765443-26966-12-git-send-email-alexander.shishkin@linux.intel.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf tools: Add perf_event_paranoid()
Git-Commit-ID: 1a47245d2f3bf6276c95cd37901b562962d6ae47
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.1 (terminus.zytor.com [127.0.0.1]); Mon, 16 Dec 2013 07:26:53 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  1a47245d2f3bf6276c95cd37901b562962d6ae47
Gitweb:     http://git.kernel.org/tip/1a47245d2f3bf6276c95cd37901b562962d6ae47
Author:     Adrian Hunter <adrian.hunter@intel.com>
AuthorDate: Wed, 11 Dec 2013 14:36:23 +0200
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Fri, 13 Dec 2013 10:30:20 -0300

perf tools: Add perf_event_paranoid()

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
index af25055..2eb7378 100644
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
index 4a57609..8f63dba 100644
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
index 0171213..1e7d413 100644
--- a/tools/perf/util/util.h
+++ b/tools/perf/util/util.h
@@ -321,6 +321,7 @@ void free_srcline(char *srcline);
 
 int filename__read_int(const char *filename, int *value);
 int filename__read_str(const char *filename, char **buf, size_t *sizep);
+int perf_event_paranoid(void);
 
 const char *get_filename_for_perf_kvm(void);
 #endif /* GIT_COMPAT_UTIL_H */
