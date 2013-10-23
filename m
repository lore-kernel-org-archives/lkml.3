Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751838Ab3JWHxR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Oct 2013 03:53:17 -0400
Received: from terminus.zytor.com ([198.137.202.10]:55790 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751375Ab3JWHxN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Oct 2013 03:53:13 -0400
Date: Wed, 23 Oct 2013 00:52:35 -0700
From: tip-bot for Arnaldo Carvalho de Melo <tipbot@zytor.com>
Message-ID: <tip-lyvtxhchz4ga8fwht15x8wou@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, eranian@google.com, paulus@samba.org,
        acme@redhat.com, hpa@zytor.com, mingo@kernel.org, peterz@infradead.org,
        efault@gmx.de, jolsa@redhat.com, fweisbec@gmail.com,
        adrian.hunter@intel.com, dsahern@gmail.com, artagnon@gmail.com,
        tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, acme@redhat.com, paulus@samba.org,
        eranian@google.com, linux-kernel@vger.kernel.org, efault@gmx.de,
        peterz@infradead.org, jolsa@redhat.com, fweisbec@gmail.com,
        dsahern@gmail.com, adrian.hunter@intel.com, tglx@linutronix.de,
        artagnon@gmail.com
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf evlist:
  Introduce perf_evlist__strerror_tp method
Git-Commit-ID: 6ef068cb8e77784431b6c80adc49d0b0a6a5df66
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.1 (terminus.zytor.com [127.0.0.1]); Wed, 23 Oct 2013 00:52:41 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  6ef068cb8e77784431b6c80adc49d0b0a6a5df66
Gitweb:     http://git.kernel.org/tip/6ef068cb8e77784431b6c80adc49d0b0a6a5df66
Author:     Arnaldo Carvalho de Melo <acme@redhat.com>
AuthorDate: Thu, 17 Oct 2013 12:07:58 -0300
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Thu, 17 Oct 2013 14:35:20 -0300

perf evlist: Introduce perf_evlist__strerror_tp method

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
index ec82895..78b0d6a 100644
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
index cb9523f..6737420 100644
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
index 722618f..386de10 100644
--- a/tools/perf/util/evlist.h
+++ b/tools/perf/util/evlist.h
@@ -168,6 +168,8 @@ static inline struct perf_evsel *perf_evlist__last(struct perf_evlist *evlist)
 
 size_t perf_evlist__fprintf(struct perf_evlist *evlist, FILE *fp);
 
+int perf_evlist__strerror_tp(struct perf_evlist *evlist, int err, char *buf, size_t size);
+
 static inline unsigned int perf_mmap__read_head(struct perf_mmap *mm)
 {
 	struct perf_event_mmap_page *pc = mm->base;
