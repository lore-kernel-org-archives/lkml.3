Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754575Ab3K2Lqd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Nov 2013 06:46:33 -0500
Received: from mx1.redhat.com ([209.132.183.28]:51650 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752837Ab3K2Lp5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Nov 2013 06:45:57 -0500
From: Jiri Olsa <jolsa@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: Jiri Olsa <jolsa@redhat.com>, Corey Ashford <cjashfor@linux.vnet.ibm.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@elte.hu>,
        Namhyung Kim <namhyung@kernel.org>, Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        David Ahern <dsahern@gmail.com>, Andi Kleen <andi@firstfloor.org>
Subject: [PATCH 3/6] perf tools: Add PERF_EVLIST__ERRNO_OPEN internal error
Date: Fri, 29 Nov 2013 12:45:07 +0100
Message-Id: <1385725510-20118-4-git-send-email-jolsa@redhat.com>
In-Reply-To: <1385725510-20118-1-git-send-email-jolsa@redhat.com>
References: <1385725510-20118-1-git-send-email-jolsa@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Adding internal error (PERF_EVLIST__ERRNO_OPEN) for
cases when perf_evlist__open fails.

Signed-off-by: Jiri Olsa <jolsa@redhat.com>
Cc: Corey Ashford <cjashfor@linux.vnet.ibm.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: David Ahern <dsahern@gmail.com>
Cc: Andi Kleen <andi@firstfloor.org>
---
 tools/perf/builtin-trace.c | 11 ++++---
 tools/perf/util/evlist.c   | 75 ++++++++++++++++++++++++----------------------
 tools/perf/util/evlist.h   |  2 +-
 3 files changed, 45 insertions(+), 43 deletions(-)

diff --git a/tools/perf/builtin-trace.c b/tools/perf/builtin-trace.c
index 9f2a242..cba33e8 100644
--- a/tools/perf/builtin-trace.c
+++ b/tools/perf/builtin-trace.c
@@ -1987,17 +1987,16 @@ out_delete_evlist:
 out:
 	trace->live = false;
 	return err;
+
+out_error_open:
+	fprintf(trace->output, "%s\n", perf_evlist__strerror(evlist));
+	goto out_delete_evlist;
+
 {
 	char errbuf[BUFSIZ];
 
 out_error_tp:
 	perf_evlist__strerror_tp(evlist, errno, errbuf, sizeof(errbuf));
-	goto out_error;
-
-out_error_open:
-	perf_evlist__strerror_open(evlist, errno, errbuf, sizeof(errbuf));
-
-out_error:
 	fprintf(trace->output, "%s\n", errbuf);
 	goto out_delete_evlist;
 }
diff --git a/tools/perf/util/evlist.c b/tools/perf/util/evlist.c
index d156f0a..4af0cca 100644
--- a/tools/perf/util/evlist.c
+++ b/tools/perf/util/evlist.c
@@ -627,6 +627,40 @@ static void strerror_mmap(struct perf_evlist *evlist,
 	}
 }
 
+static void strerror_open(struct perf_evlist *evlist,
+			  char *buf, size_t size)
+{
+	int printed, value, err_libc = evlist->err_libc;
+	char sbuf[128], *emsg = strerror_r(err_libc, sbuf, sizeof(sbuf));
+
+	switch (err_libc) {
+	case EACCES:
+	case EPERM:
+		printed = scnprintf(buf, size,
+				    "Error:\t%s.\n"
+				    "Hint:\tCheck /proc/sys/kernel/perf_event_paranoid setting.", emsg);
+
+		if (filename__read_int("/proc/sys/kernel/perf_event_paranoid", &value))
+			break;
+
+		printed += scnprintf(buf + printed, size - printed, "\nHint:\t");
+
+		if (value >= 2) {
+			printed += scnprintf(buf + printed, size - printed,
+					     "For your workloads it needs to be <= 1\nHint:\t");
+		}
+		printed += scnprintf(buf + printed, size - printed,
+				     "For system wide tracing it needs to be set to -1");
+
+		printed += scnprintf(buf + printed, size - printed,
+				    ".\nHint:\tThe current value is %d.", value);
+		break;
+	default:
+		scnprintf(buf, size, "%s", emsg);
+		break;
+	}
+}
+
 static void __perf_evlist__strerror(struct perf_evlist *evlist,
 				    char *buf, size_t size)
 {
@@ -639,6 +673,9 @@ static void __perf_evlist__strerror(struct perf_evlist *evlist,
 	case PERF_EVLIST__ERRNO_MMAP:
 		strerror_mmap(evlist, buf, size);
 		return;
+	case PERF_EVLIST__ERRNO_OPEN:
+		strerror_open(evlist, buf, size);
+		return;
 	default:
 		scnprintf(buf, size, "Unknown error\n");
 		return;
@@ -1089,8 +1126,10 @@ int perf_evlist__open(struct perf_evlist *evlist)
 			goto out_err;
 	}
 
+	SET_ERR(SUCCESS);
 	return 0;
 out_err:
+	SET_ERR(OPEN);
 	perf_evlist__close(evlist);
 	errno = -err;
 	return err;
@@ -1243,39 +1282,3 @@ int perf_evlist__strerror_tp(struct perf_evlist *evlist __maybe_unused,
 
 	return 0;
 }
-
-int perf_evlist__strerror_open(struct perf_evlist *evlist __maybe_unused,
-			       int err, char *buf, size_t size)
-{
-	int printed, value;
-	char sbuf[128], *emsg = strerror_r(err, sbuf, sizeof(sbuf));
-
-	switch (err) {
-	case EACCES:
-	case EPERM:
-		printed = scnprintf(buf, size,
-				    "Error:\t%s.\n"
-				    "Hint:\tCheck /proc/sys/kernel/perf_event_paranoid setting.", emsg);
-
-		if (filename__read_int("/proc/sys/kernel/perf_event_paranoid", &value))
-			break;
-
-		printed += scnprintf(buf + printed, size - printed, "\nHint:\t");
-
-		if (value >= 2) {
-			printed += scnprintf(buf + printed, size - printed,
-					     "For your workloads it needs to be <= 1\nHint:\t");
-		}
-		printed += scnprintf(buf + printed, size - printed,
-				     "For system wide tracing it needs to be set to -1");
-
-		printed += scnprintf(buf + printed, size - printed,
-				    ".\nHint:\tThe current value is %d.", value);
-		break;
-	default:
-		scnprintf(buf, size, "%s", emsg);
-		break;
-	}
-
-	return 0;
-}
diff --git a/tools/perf/util/evlist.h b/tools/perf/util/evlist.h
index 02df99a..48ac4c5 100644
--- a/tools/perf/util/evlist.h
+++ b/tools/perf/util/evlist.h
@@ -20,6 +20,7 @@ struct perf_record_opts;
 enum {
 	PERF_EVLIST__ERRNO_SUCCESS		= 0,
 	PERF_EVLIST__ERRNO_MMAP			= 1,
+	PERF_EVLIST__ERRNO_OPEN			= 2,
 };
 
 struct perf_mmap {
@@ -184,7 +185,6 @@ static inline struct perf_evsel *perf_evlist__last(struct perf_evlist *evlist)
 size_t perf_evlist__fprintf(struct perf_evlist *evlist, FILE *fp);
 
 int perf_evlist__strerror_tp(struct perf_evlist *evlist, int err, char *buf, size_t size);
-int perf_evlist__strerror_open(struct perf_evlist *evlist, int err, char *buf, size_t size);
 char *perf_evlist__strerror(struct perf_evlist *evlist);
 
 static inline unsigned int perf_mmap__read_head(struct perf_mmap *mm)
-- 
1.8.3.1

