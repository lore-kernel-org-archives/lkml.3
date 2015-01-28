Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759314AbbA1VUA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Jan 2015 16:20:00 -0500
Received: from terminus.zytor.com ([198.137.202.10]:40980 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760830AbbA1UuU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Jan 2015 15:50:20 -0500
Date: Wed, 28 Jan 2015 07:08:47 -0800
From: tip-bot for Arnaldo Carvalho de Melo <tipbot@zytor.com>
Message-ID: <tip-a9up9mivx1pzdf5tqrqsx62d@git.kernel.org>
Cc: dzickus@redhat.com, namhyung@kernel.org, linux-kernel@vger.kernel.org,
        bp@suse.de, fweisbec@gmail.com, mingo@kernel.org, jolsa@redhat.com,
        tglx@linutronix.de, dsahern@gmail.com, eranian@google.com,
        hpa@zytor.com, adrian.hunter@intel.com, acme@redhat.com
Reply-To: acme@redhat.com, adrian.hunter@intel.com, hpa@zytor.com,
        eranian@google.com, dsahern@gmail.com, tglx@linutronix.de,
        jolsa@redhat.com, mingo@kernel.org, bp@suse.de, fweisbec@gmail.com,
        linux-kernel@vger.kernel.org, namhyung@kernel.org, dzickus@redhat.com
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] tools lib fs: Adopt debugfs open strerrno method
Git-Commit-ID: e2726d99645c5fa1fd9abd6353270fde624696f8
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

Commit-ID:  e2726d99645c5fa1fd9abd6353270fde624696f8
Gitweb:     http://git.kernel.org/tip/e2726d99645c5fa1fd9abd6353270fde624696f8
Author:     Arnaldo Carvalho de Melo <acme@redhat.com>
AuthorDate: Thu, 22 Jan 2015 10:34:22 -0300
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Thu, 22 Jan 2015 10:34:22 -0300

tools lib fs: Adopt debugfs open strerrno method

As this is not specific to an evlist and may be used with other tools.

Cc: Adrian Hunter <adrian.hunter@intel.com>
Cc: Borislav Petkov <bp@suse.de>
Cc: David Ahern <dsahern@gmail.com>
Cc: Don Zickus <dzickus@redhat.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Stephane Eranian <eranian@google.com>
Link: http://lkml.kernel.org/n/tip-a9up9mivx1pzdf5tqrqsx62d@git.kernel.org
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>

 	tools/perf/util/include/asm/hash.h
---
 tools/lib/api/fs/debugfs.c | 27 +++++++++++++++++++++++++++
 tools/lib/api/fs/debugfs.h |  2 ++
 tools/perf/builtin-trace.c | 11 +++++++++--
 tools/perf/util/evlist.c   | 27 ---------------------------
 tools/perf/util/evlist.h   |  1 -
 5 files changed, 38 insertions(+), 30 deletions(-)

diff --git a/tools/lib/api/fs/debugfs.c b/tools/lib/api/fs/debugfs.c
index 86ea2d7..fb700ee 100644
--- a/tools/lib/api/fs/debugfs.c
+++ b/tools/lib/api/fs/debugfs.c
@@ -1,3 +1,4 @@
+#define _GNU_SOURCE
 #include <errno.h>
 #include <stdio.h>
 #include <stdlib.h>
@@ -98,3 +99,29 @@ char *debugfs_mount(const char *mountpoint)
 out:
 	return debugfs_mountpoint;
 }
+
+int debugfs__strerror_open(int err, char *buf, size_t size)
+{
+	char sbuf[128];
+
+	switch (err) {
+	case ENOENT:
+		snprintf(buf, size, "%s",
+			 "Error:\tUnable to find debugfs\n"
+			 "Hint:\tWas your kernel compiled with debugfs support?\n"
+			 "Hint:\tIs the debugfs filesystem mounted?\n"
+			 "Hint:\tTry 'sudo mount -t debugfs nodev /sys/kernel/debug'");
+		break;
+	case EACCES:
+		snprintf(buf, size,
+			 "Error:\tNo permissions to read %s/tracing/events/raw_syscalls\n"
+			 "Hint:\tTry 'sudo mount -o remount,mode=755 %s'\n",
+			 debugfs_mountpoint, debugfs_mountpoint);
+		break;
+	default:
+		snprintf(buf, size, "%s", strerror_r(err, sbuf, sizeof(sbuf)));
+		break;
+	}
+
+	return 0;
+}
diff --git a/tools/lib/api/fs/debugfs.h b/tools/lib/api/fs/debugfs.h
index f19d3df..afa5043 100644
--- a/tools/lib/api/fs/debugfs.h
+++ b/tools/lib/api/fs/debugfs.h
@@ -26,4 +26,6 @@ char *debugfs_mount(const char *mountpoint);
 
 extern char debugfs_mountpoint[];
 
+int debugfs__strerror_open(int err, char *buf, size_t size);
+
 #endif /* __API_DEBUGFS_H__ */
diff --git a/tools/perf/builtin-trace.c b/tools/perf/builtin-trace.c
index 258f655..2f82dd7 100644
--- a/tools/perf/builtin-trace.c
+++ b/tools/perf/builtin-trace.c
@@ -2062,8 +2062,15 @@ static int trace__run(struct trace *trace, int argc, const char **argv)
 		perf_evlist__add_vfs_getname(evlist);
 
 	if ((trace->trace_pgfaults & TRACE_PFMAJ) &&
-	    perf_evlist__add_pgfault(evlist, PERF_COUNT_SW_PAGE_FAULTS_MAJ))
+	    perf_evlist__add_pgfault(evlist, PERF_COUNT_SW_PAGE_FAULTS_MAJ)) {
+		/*
+		 * FIXME: This one needs better error handling, as by now we
+		 * already checked that debugfs is mounted and that we have access to it,
+		 * so probably the case is that something is busted wrt this specific
+		 * software event, ditto for the next gotos to out_error_tp...
+		 */
 		goto out_error_tp;
+	}
 
 	if ((trace->trace_pgfaults & TRACE_PFMIN) &&
 	    perf_evlist__add_pgfault(evlist, PERF_COUNT_SW_PAGE_FAULTS_MIN))
@@ -2203,7 +2210,7 @@ out:
 	char errbuf[BUFSIZ];
 
 out_error_tp:
-	perf_evlist__strerror_tp(evlist, errno, errbuf, sizeof(errbuf));
+	debugfs__strerror_open(errno, errbuf, sizeof(errbuf));
 	goto out_error;
 
 out_error_mmap:
diff --git a/tools/perf/util/evlist.c b/tools/perf/util/evlist.c
index 2e507b5..28b8ce8 100644
--- a/tools/perf/util/evlist.c
+++ b/tools/perf/util/evlist.c
@@ -1436,33 +1436,6 @@ size_t perf_evlist__fprintf(struct perf_evlist *evlist, FILE *fp)
 	return printed + fprintf(fp, "\n");
 }
 
-int perf_evlist__strerror_tp(struct perf_evlist *evlist __maybe_unused,
-			     int err, char *buf, size_t size)
-{
-	char sbuf[128];
-
-	switch (err) {
-	case ENOENT:
-		scnprintf(buf, size, "%s",
-			  "Error:\tUnable to find debugfs\n"
-			  "Hint:\tWas your kernel compiled with debugfs support?\n"
-			  "Hint:\tIs the debugfs filesystem mounted?\n"
-			  "Hint:\tTry 'sudo mount -t debugfs nodev /sys/kernel/debug'");
-		break;
-	case EACCES:
-		scnprintf(buf, size,
-			  "Error:\tNo permissions to read %s/tracing/events/raw_syscalls\n"
-			  "Hint:\tTry 'sudo mount -o remount,mode=755 %s'\n",
-			  debugfs_mountpoint, debugfs_mountpoint);
-		break;
-	default:
-		scnprintf(buf, size, "%s", strerror_r(err, sbuf, sizeof(sbuf)));
-		break;
-	}
-
-	return 0;
-}
-
 int perf_evlist__strerror_open(struct perf_evlist *evlist __maybe_unused,
 			       int err, char *buf, size_t size)
 {
diff --git a/tools/perf/util/evlist.h b/tools/perf/util/evlist.h
index 0ba93f6..c94a9e0 100644
--- a/tools/perf/util/evlist.h
+++ b/tools/perf/util/evlist.h
@@ -183,7 +183,6 @@ static inline struct perf_evsel *perf_evlist__last(struct perf_evlist *evlist)
 
 size_t perf_evlist__fprintf(struct perf_evlist *evlist, FILE *fp);
 
-int perf_evlist__strerror_tp(struct perf_evlist *evlist, int err, char *buf, size_t size);
 int perf_evlist__strerror_open(struct perf_evlist *evlist, int err, char *buf, size_t size);
 int perf_evlist__strerror_mmap(struct perf_evlist *evlist, int err, char *buf, size_t size);
 
