Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754178Ab3JVOf5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Oct 2013 10:35:57 -0400
Received: from merlin.infradead.org ([205.233.59.134]:53854 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751950Ab3JVO2t (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Oct 2013 10:28:49 -0400
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org, Arnaldo Carvalho de Melo <acme@redhat.com>,
        Adrian Hunter <adrian.hunter@intel.com>,
        David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Jiri Olsa <jolsa@redhat.com>,
        Mike Galbraith <efault@gmx.de>, Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Ramkumar Ramachandra <artagnon@gmail.com>,
        Stephane Eranian <eranian@google.com>
Subject: [PATCH 05/26] perf evlist: Introduce perf_evlist__strerror_tp method
Date: Tue, 22 Oct 2013 11:28:13 -0300
Message-Id: <1382452114-1243-6-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.8.1.4
In-Reply-To: <1382452114-1243-1-git-send-email-acme@infradead.org>
References: <1382452114-1243-1-git-send-email-acme@infradead.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by merlin.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Arnaldo Carvalho de Melo <acme@redhat.com>

Out of 'perf trace', should be used by other tools that uses
tracepoints.

Cc: Adrian Hunter <adrian.hunter@intel.com>
Cc: David Ahern <dsahern@gmail.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Ramkumar Ramachandra <artagnon@gmail.com>
Cc: Stephane Eranian <eranian@google.com>
Link: http://lkml.kernel.org/n/tip-lyvtxhchz4ga8fwht15x8wou@git.kernel.org
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/builtin-trace.c | 26 +++++---------------------
 tools/perf/util/evlist.c   | 27 +++++++++++++++++++++++++++
 tools/perf/util/evlist.h   |  2 ++
 3 files changed, 34 insertions(+), 21 deletions(-)

diff --git a/tools/perf/builtin-trace.c b/tools/perf/builtin-trace.c
index ec8289570f4f..78b0d6a5fdff 100644
--- a/tools/perf/builtin-trace.c
+++ b/tools/perf/builtin-trace.c
@@ -1814,27 +1814,11 @@ out:
 	trace->live = false;
 	return err;
 out_error_tp:
-	switch(errno) {
-	case ENOENT:
-		fputs("Error:\tUnable to find debugfs\n"
-		      "Hint:\tWas your kernel was compiled with debugfs support?\n"
-		      "Hint:\tIs the debugfs filesystem mounted?\n"
-		      "Hint:\tTry 'sudo mount -t debugfs nodev /sys/kernel/debug'\n",
-		      trace->output);
-		break;
-	case EACCES:
-		fprintf(trace->output,
-			"Error:\tNo permissions to read %s/tracing/events/raw_syscalls\n"
-			"Hint:\tTry 'sudo mount -o remount,mode=755 %s'\n",
-			debugfs_mountpoint, debugfs_mountpoint);
-		break;
-	default: {
-		char bf[256];
-		fprintf(trace->output, "Can't trace: %s\n",
-			strerror_r(errno, bf, sizeof(bf)));
-	}
-		break;
-	}
+{
+	char errbuf[BUFSIZ];
+	perf_evlist__strerror_tp(evlist, errno, errbuf, sizeof(errbuf));
+	fprintf(trace->output, "%s\n", errbuf);
+}
 	goto out_delete_evlist;
 }
 
diff --git a/tools/perf/util/evlist.c b/tools/perf/util/evlist.c
index cb9523f50a37..6737420891cd 100644
--- a/tools/perf/util/evlist.c
+++ b/tools/perf/util/evlist.c
@@ -1126,3 +1126,30 @@ size_t perf_evlist__fprintf(struct perf_evlist *evlist, FILE *fp)
 
 	return printed + fprintf(fp, "\n");;
 }
+
+int perf_evlist__strerror_tp(struct perf_evlist *evlist __maybe_unused,
+			     int err, char *buf, size_t size)
+{
+	char sbuf[128];
+
+	switch (err) {
+	case ENOENT:
+		scnprintf(buf, size, "%s",
+			  "Error:\tUnable to find debugfs\n"
+			  "Hint:\tWas your kernel was compiled with debugfs support?\n"
+			  "Hint:\tIs the debugfs filesystem mounted?\n"
+			  "Hint:\tTry 'sudo mount -t debugfs nodev /sys/kernel/debug'");
+		break;
+	case EACCES:
+		scnprintf(buf, size,
+			  "Error:\tNo permissions to read %s/tracing/events/raw_syscalls\n"
+			  "Hint:\tTry 'sudo mount -o remount,mode=755 %s'\n",
+			  debugfs_mountpoint, debugfs_mountpoint);
+		break;
+	default:
+		scnprintf(buf, size, "%s", strerror_r(err, sbuf, sizeof(sbuf)));
+		break;
+	}
+
+	return 0;
+}
diff --git a/tools/perf/util/evlist.h b/tools/perf/util/evlist.h
index 722618f84c53..386de1036442 100644
--- a/tools/perf/util/evlist.h
+++ b/tools/perf/util/evlist.h
@@ -168,6 +168,8 @@ static inline struct perf_evsel *perf_evlist__last(struct perf_evlist *evlist)
 
 size_t perf_evlist__fprintf(struct perf_evlist *evlist, FILE *fp);
 
+int perf_evlist__strerror_tp(struct perf_evlist *evlist, int err, char *buf, size_t size);
+
 static inline unsigned int perf_mmap__read_head(struct perf_mmap *mm)
 {
 	struct perf_event_mmap_page *pc = mm->base;
-- 
1.8.1.4

