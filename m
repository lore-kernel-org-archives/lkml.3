Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754513Ab3K2Lqc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Nov 2013 06:46:32 -0500
Received: from mx1.redhat.com ([209.132.183.28]:40009 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753789Ab3K2Lp5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Nov 2013 06:45:57 -0500
From: Jiri Olsa <jolsa@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: Jiri Olsa <jolsa@redhat.com>, Corey Ashford <cjashfor@linux.vnet.ibm.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@elte.hu>,
        Namhyung Kim <namhyung@kernel.org>, Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        David Ahern <dsahern@gmail.com>, Andi Kleen <andi@firstfloor.org>
Subject: [PATCH 5/6] perf tools: Add PERF_EVLIST__ERRNO_NEWTP internal error
Date: Fri, 29 Nov 2013 12:45:09 +0100
Message-Id: <1385725510-20118-6-git-send-email-jolsa@redhat.com>
In-Reply-To: <1385725510-20118-1-git-send-email-jolsa@redhat.com>
References: <1385725510-20118-1-git-send-email-jolsa@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Adding internal error (PERF_EVLIST__ERRNO_NEWTP) for case
when perf_evlist__add_newtp call fails.

Moving perf_evlist__strerror_tp function to the error
string handling framework.

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
 tools/perf/builtin-trace.c | 31 ++++++++++-----------
 tools/perf/util/evlist.c   | 67 ++++++++++++++++++++++++----------------------
 tools/perf/util/evlist.h   |  6 +++++
 3 files changed, 55 insertions(+), 49 deletions(-)

diff --git a/tools/perf/builtin-trace.c b/tools/perf/builtin-trace.c
index cba33e8..f2886c7 100644
--- a/tools/perf/builtin-trace.c
+++ b/tools/perf/builtin-trace.c
@@ -199,23 +199,29 @@ static int perf_evlist__add_syscall_newtp(struct perf_evlist *evlist,
 	int ret = -1;
 	struct perf_evsel *sys_enter, *sys_exit;
 
+#define GOTO_ERR(label) ({			\
+	PERF_EVLIST__SET_ERR(evlist, OPEN);	\
+	goto label;				\
+})
+
 	sys_enter = perf_evsel__syscall_newtp("sys_enter", sys_enter_handler);
 	if (sys_enter == NULL)
-		goto out;
+		GOTO_ERR(out);
 
 	if (perf_evsel__init_sc_tp_ptr_field(sys_enter, args))
-		goto out_delete_sys_enter;
+		GOTO_ERR(out_delete_sys_enter);
 
 	sys_exit = perf_evsel__syscall_newtp("sys_exit", sys_exit_handler);
 	if (sys_exit == NULL)
-		goto out_delete_sys_enter;
+		GOTO_ERR(out_delete_sys_enter);
 
 	if (perf_evsel__init_sc_tp_uint_field(sys_exit, ret))
-		goto out_delete_sys_exit;
+		GOTO_ERR(out_delete_sys_exit);
 
 	perf_evlist__add(evlist, sys_enter);
 	perf_evlist__add(evlist, sys_exit);
 
+	PERF_EVLIST__SET_ERR(evlist, SUCCESS);
 	ret = 0;
 out:
 	return ret;
@@ -1851,14 +1857,14 @@ static int trace__run(struct trace *trace, int argc, const char **argv)
 	}
 
 	if (perf_evlist__add_syscall_newtp(evlist, trace__sys_enter, trace__sys_exit))
-		goto out_error_tp;
+		goto out_error;
 
 	perf_evlist__add_vfs_getname(evlist);
 
 	if (trace->sched &&
 		perf_evlist__add_newtp(evlist, "sched", "sched_stat_runtime",
 				trace__sched_stat_runtime))
-		goto out_error_tp;
+		goto out_error;
 
 	err = perf_evlist__create_maps(evlist, &trace->opts.target);
 	if (err < 0) {
@@ -1888,7 +1894,7 @@ static int trace__run(struct trace *trace, int argc, const char **argv)
 
 	err = perf_evlist__open(evlist);
 	if (err < 0)
-		goto out_error_open;
+		goto out_error;
 
 	err = perf_evlist__mmap(evlist, trace->opts.mmap_pages, false);
 	if (err < 0) {
@@ -1988,18 +1994,9 @@ out:
 	trace->live = false;
 	return err;
 
-out_error_open:
+out_error:
 	fprintf(trace->output, "%s\n", perf_evlist__strerror(evlist));
 	goto out_delete_evlist;
-
-{
-	char errbuf[BUFSIZ];
-
-out_error_tp:
-	perf_evlist__strerror_tp(evlist, errno, errbuf, sizeof(errbuf));
-	fprintf(trace->output, "%s\n", errbuf);
-	goto out_delete_evlist;
-}
 }
 
 static int trace__replay(struct trace *trace)
diff --git a/tools/perf/util/evlist.c b/tools/perf/util/evlist.c
index f9c5abd..edb933c 100644
--- a/tools/perf/util/evlist.c
+++ b/tools/perf/util/evlist.c
@@ -28,10 +28,7 @@
 #define FD(e, x, y) (*(int *)xyarray__entry(e->fd, x, y))
 #define SID(e, x, y) xyarray__entry(e->sample_id, x, y)
 
-#define SET_ERR(_err) ({				\
-	evlist->err      = PERF_EVLIST__ERRNO_##_err;	\
-	evlist->err_libc = errno;			\
-})
+#define SET_ERR(_err) PERF_EVLIST__SET_ERR(evlist, _err)
 
 void perf_evlist__init(struct perf_evlist *evlist, struct cpu_map *cpus,
 		       struct thread_map *threads)
@@ -258,9 +255,12 @@ int perf_evlist__add_newtp(struct perf_evlist *evlist,
 {
 	struct perf_evsel *evsel = perf_evsel__newtp(sys, name);
 
-	if (evsel == NULL)
+	if (evsel == NULL) {
+		SET_ERR(NEWTP);
 		return -1;
+	}
 
+	SET_ERR(SUCCESS);
 	evsel->handler = handler;
 	perf_evlist__add(evlist, evsel);
 	return 0;
@@ -663,6 +663,33 @@ static void strerror_open(struct perf_evlist *evlist,
 	}
 }
 
+static void strerror_newtp(struct perf_evlist *evlist,
+			char *buf, size_t size)
+{
+	int err_libc = evlist->err_libc;
+	char sbuf[128];
+
+	switch (err_libc) {
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
+		scnprintf(buf, size, "%s",
+			  strerror_r(err_libc, sbuf, sizeof(sbuf)));
+		break;
+	}
+}
+
 static void __perf_evlist__strerror(struct perf_evlist *evlist,
 				    char *buf, size_t size)
 {
@@ -683,6 +710,9 @@ static void __perf_evlist__strerror(struct perf_evlist *evlist,
 			"Cannot read event group on this kernel.\n"
 			"Please consider kernel update (v3.12+).\n");
 		return;
+	case PERF_EVLIST__ERRNO_NEWTP:
+		strerror_newtp(evlist, buf, size);
+		return;
 	default:
 		scnprintf(buf, size, "Unknown error\n");
 		return;
@@ -1262,30 +1292,3 @@ size_t perf_evlist__fprintf(struct perf_evlist *evlist, FILE *fp)
 
 	return printed + fprintf(fp, "\n");
 }
-
-int perf_evlist__strerror_tp(struct perf_evlist *evlist __maybe_unused,
-			     int err, char *buf, size_t size)
-{
-	char sbuf[128];
-
-	switch (err) {
-	case ENOENT:
-		scnprintf(buf, size, "%s",
-			  "Error:\tUnable to find debugfs\n"
-			  "Hint:\tWas your kernel was compiled with debugfs support?\n"
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
diff --git a/tools/perf/util/evlist.h b/tools/perf/util/evlist.h
index e5ce8c7..46036e3 100644
--- a/tools/perf/util/evlist.h
+++ b/tools/perf/util/evlist.h
@@ -17,11 +17,17 @@ struct perf_record_opts;
 #define PERF_EVLIST__HLIST_BITS 8
 #define PERF_EVLIST__HLIST_SIZE (1 << PERF_EVLIST__HLIST_BITS)
 
+#define PERF_EVLIST__SET_ERR(evlist, _err) ({		\
+	evlist->err      = PERF_EVLIST__ERRNO_##_err;	\
+	evlist->err_libc = errno;			\
+})
+
 enum {
 	PERF_EVLIST__ERRNO_SUCCESS		= 0,
 	PERF_EVLIST__ERRNO_MMAP			= 1,
 	PERF_EVLIST__ERRNO_OPEN			= 2,
 	PERF_EVLIST__ERRNO_IOCTL_ID_GROUP	= 3,
+	PERF_EVLIST__ERRNO_NEWTP		= 4,
 };
 
 struct perf_mmap {
-- 
1.8.3.1

