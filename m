Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757045Ab3AYK6R (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jan 2013 05:58:17 -0500
Received: from terminus.zytor.com ([198.137.202.10]:41124 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756597Ab3AYK6O (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jan 2013 05:58:14 -0500
Date: Fri, 25 Jan 2013 02:57:47 -0800
From: tip-bot for Arnaldo Carvalho de Melo <acme@redhat.com>
Message-ID: <tip-1cudb7wl996kz7ilz83ctvhr@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, eranian@google.com, paulus@samba.org,
        acme@redhat.com, hpa@zytor.com, mingo@kernel.org, peterz@infradead.org,
        efault@gmx.de, namhyung@gmail.com, jolsa@redhat.com,
        fweisbec@gmail.com, dsahern@gmail.com, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, acme@redhat.com, paulus@samba.org,
        eranian@google.com, linux-kernel@vger.kernel.org, efault@gmx.de,
        peterz@infradead.org, namhyung@gmail.com, jolsa@redhat.com,
        fweisbec@gmail.com, dsahern@gmail.com, tglx@linutronix.de
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf evsel:
  Introduce perf_evsel__open_strerror method
Git-Commit-ID: 56e52e85366717481cde16b3480f015c7eb32ba3
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.7 (terminus.zytor.com [127.0.0.1]); Fri, 25 Jan 2013 02:57:53 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  56e52e85366717481cde16b3480f015c7eb32ba3
Gitweb:     http://git.kernel.org/tip/56e52e85366717481cde16b3480f015c7eb32ba3
Author:     Arnaldo Carvalho de Melo <acme@redhat.com>
AuthorDate: Thu, 13 Dec 2012 15:10:58 -0300
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Thu, 24 Jan 2013 16:40:09 -0300

perf evsel: Introduce perf_evsel__open_strerror method

That consolidates the error messages in 'record', 'stat' and 'top', that
now get a consistent set of messages and allow other tools to use the
new method to report problems using whatever UI toolkit.

Cc: David Ahern <dsahern@gmail.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Namhyung Kim <namhyung@gmail.com>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Stephane Eranian <eranian@google.com>
Link: http://lkml.kernel.org/n/tip-1cudb7wl996kz7ilz83ctvhr@git.kernel.org
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/builtin-record.c | 54 +++++----------------------------------------
 tools/perf/builtin-stat.c   | 16 +++++---------
 tools/perf/builtin-top.c    | 34 +++++-----------------------
 tools/perf/ui/util.c        | 11 ---------
 tools/perf/util/debug.h     |  1 -
 tools/perf/util/evsel.c     | 49 ++++++++++++++++++++++++++++++++++++++++
 tools/perf/util/evsel.h     |  3 +++
 7 files changed, 68 insertions(+), 100 deletions(-)

diff --git a/tools/perf/builtin-record.c b/tools/perf/builtin-record.c
index b8d0a39..de60dd4 100644
--- a/tools/perf/builtin-record.c
+++ b/tools/perf/builtin-record.c
@@ -224,7 +224,7 @@ static bool perf_evlist__equal(struct perf_evlist *evlist,
 
 static int perf_record__open(struct perf_record *rec)
 {
-	char msg[128];
+	char msg[512];
 	struct perf_evsel *pos;
 	struct perf_evlist *evlist = rec->evlist;
 	struct perf_session *session = rec->session;
@@ -234,60 +234,18 @@ static int perf_record__open(struct perf_record *rec)
 	perf_evlist__config(evlist, opts);
 
 	list_for_each_entry(pos, &evlist->entries, node) {
-		struct perf_event_attr *attr = &pos->attr;
 try_again:
 		if (perf_evsel__open(pos, evlist->cpus, evlist->threads) < 0) {
-			int err = errno;
-
-			if (err == EPERM || err == EACCES) {
-				ui__error_paranoid();
-				rc = -err;
-				goto out;
-			} else if (err ==  ENODEV && opts->target.cpu_list) {
-				pr_err("No such device - did you specify"
-				       " an out-of-range profile CPU?\n");
-				rc = -err;
-				goto out;
-			}
-
-			if (perf_evsel__fallback(pos, err, msg, sizeof(msg))) {
+			if (perf_evsel__fallback(pos, errno, msg, sizeof(msg))) {
 				if (verbose)
 					ui__warning("%s\n", msg);
 				goto try_again;
 			}
 
-			if (err == ENOENT) {
-				ui__error("The %s event is not supported.\n",
-					  perf_evsel__name(pos));
-				rc = -err;
-				goto out;
-			} else if ((err == EOPNOTSUPP) && (attr->precise_ip)) {
-				ui__error("\'precise\' request may not be supported. "
-					  "Try removing 'p' modifier\n");
-				rc = -err;
-				goto out;
-			}
-
-			printf("\n");
-			error("sys_perf_event_open() syscall returned with %d "
-			      "(%s) for event %s. /bin/dmesg may provide "
-			      "additional information.\n",
-			      err, strerror(err), perf_evsel__name(pos));
-
-#if defined(__i386__) || defined(__x86_64__)
-			if (attr->type == PERF_TYPE_HARDWARE &&
-			    err == EOPNOTSUPP) {
-				pr_err("No hardware sampling interrupt available."
-				       " No APIC? If so then you can boot the kernel"
-				       " with the \"lapic\" boot parameter to"
-				       " force-enable it.\n");
-				rc = -err;
-				goto out;
-			}
-#endif
-
-			pr_err("No CONFIG_PERF_EVENTS=y kernel support configured?\n");
-			rc = -err;
+			rc = -errno;
+			perf_evsel__open_strerror(pos, &opts->target,
+						  errno, msg, sizeof(msg));
+			ui__error("%s\n", msg);
 			goto out;
 		}
 	}
diff --git a/tools/perf/builtin-stat.c b/tools/perf/builtin-stat.c
index ef067c1..1c2ac14 100644
--- a/tools/perf/builtin-stat.c
+++ b/tools/perf/builtin-stat.c
@@ -247,6 +247,7 @@ static int read_counter(struct perf_evsel *counter)
 
 static int __run_perf_stat(int argc __maybe_unused, const char **argv)
 {
+	char msg[512];
 	unsigned long long t0, t1;
 	struct perf_evsel *counter;
 	int status = 0;
@@ -324,20 +325,13 @@ static int __run_perf_stat(int argc __maybe_unused, const char **argv)
 				continue;
 			}
 
-			if (errno == EPERM || errno == EACCES) {
-				error("You may not have permission to collect %sstats.\n"
-				      "\t Consider tweaking"
-				      " /proc/sys/kernel/perf_event_paranoid or running as root.",
-				      target.system_wide ? "system-wide " : "");
-			} else {
-				error("open_counter returned with %d (%s). "
-				      "/bin/dmesg may provide additional information.\n",
-				       errno, strerror(errno));
-			}
+			perf_evsel__open_strerror(counter, &target,
+						  errno, msg, sizeof(msg));
+			ui__error("%s\n", msg);
+
 			if (child_pid != -1)
 				kill(child_pid, SIGTERM);
 
-			pr_err("Not all events could be opened.\n");
 			return -1;
 		}
 		counter->supported = true;
diff --git a/tools/perf/builtin-top.c b/tools/perf/builtin-top.c
index 8d41d0b..f5fd260 100644
--- a/tools/perf/builtin-top.c
+++ b/tools/perf/builtin-top.c
@@ -892,7 +892,7 @@ static void perf_top__mmap_read(struct perf_top *top)
 
 static void perf_top__start_counters(struct perf_top *top)
 {
-	char msg[128];
+	char msg[512];
 	struct perf_evsel *counter;
 	struct perf_evlist *evlist = top->evlist;
 	struct perf_record_opts *opts = &top->record_opts;
@@ -900,42 +900,18 @@ static void perf_top__start_counters(struct perf_top *top)
 	perf_evlist__config(evlist, opts);
 
 	list_for_each_entry(counter, &evlist->entries, node) {
-		struct perf_event_attr *attr = &counter->attr;
 try_again:
 		if (perf_evsel__open(counter, top->evlist->cpus,
 				     top->evlist->threads) < 0) {
-			int err = errno;
-
-			if (err == EPERM || err == EACCES) {
-				ui__error_paranoid();
-				goto out_err;
-			}
-
-			if (perf_evsel__fallback(counter, err, msg, sizeof(msg))) {
+			if (perf_evsel__fallback(counter, errno, msg, sizeof(msg))) {
 				if (verbose)
 					ui__warning("%s\n", msg);
 				goto try_again;
 			}
 
-			if (err == ENOENT) {
-				ui__error("The %s event is not supported.\n",
-					  perf_evsel__name(counter));
-				goto out_err;
-			} else if (err == EMFILE) {
-				ui__error("Too many events are opened.\n"
-					    "Try again after reducing the number of events\n");
-				goto out_err;
-			} else if ((err == EOPNOTSUPP) && (attr->precise_ip)) {
-				ui__error("\'precise\' request may not be supported. "
-					  "Try removing 'p' modifier\n");
-				goto out_err;
-			}
-
-			ui__error("The sys_perf_event_open() syscall "
-				    "returned with %d (%s).  /bin/dmesg "
-				    "may provide additional information.\n"
-				    "No CONFIG_PERF_EVENTS=y kernel support "
-				    "configured?\n", err, strerror(err));
+			perf_evsel__open_strerror(counter, &opts->target,
+						  errno, msg, sizeof(msg));
+			ui__error("%s\n", msg);
 			goto out_err;
 		}
 	}
diff --git a/tools/perf/ui/util.c b/tools/perf/ui/util.c
index 3014a7c..e3e0a96 100644
--- a/tools/perf/ui/util.c
+++ b/tools/perf/ui/util.c
@@ -52,17 +52,6 @@ int ui__warning(const char *format, ...)
 	return ret;
 }
 
-int ui__error_paranoid(void)
-{
-	return ui__error("Permission error - are you root?\n"
-		    "Consider tweaking /proc/sys/kernel/perf_event_paranoid:\n"
-		    " -1 - Not paranoid at all\n"
-		    "  0 - Disallow raw tracepoint access for unpriv\n"
-		    "  1 - Disallow cpu events for unpriv\n"
-		    "  2 - Disallow kernel profiling for unpriv\n");
-}
-
-
 /**
  * perf_error__register - Register error logging functions
  * @eops: The pointer to error logging function struct
diff --git a/tools/perf/util/debug.h b/tools/perf/util/debug.h
index 6e2667f..efbd988 100644
--- a/tools/perf/util/debug.h
+++ b/tools/perf/util/debug.h
@@ -16,6 +16,5 @@ void trace_event(union perf_event *event);
 
 int ui__error(const char *format, ...) __attribute__((format(printf, 1, 2)));
 int ui__warning(const char *format, ...) __attribute__((format(printf, 1, 2)));
-int ui__error_paranoid(void);
 
 #endif	/* __PERF_DEBUG_H */
diff --git a/tools/perf/util/evsel.c b/tools/perf/util/evsel.c
index 0c88e5c..e45332d 100644
--- a/tools/perf/util/evsel.c
+++ b/tools/perf/util/evsel.c
@@ -1406,3 +1406,52 @@ bool perf_evsel__fallback(struct perf_evsel *evsel, int err,
 
 	return false;
 }
+
+int perf_evsel__open_strerror(struct perf_evsel *evsel,
+			      struct perf_target *target,
+			      int err, char *msg, size_t size)
+{
+	switch (err) {
+	case EPERM:
+	case EACCES:
+		return scnprintf(msg, size, "%s",
+		 "You may not have permission to collect %sstats.\n"
+		 "Consider tweaking /proc/sys/kernel/perf_event_paranoid:\n"
+		 " -1 - Not paranoid at all\n"
+		 "  0 - Disallow raw tracepoint access for unpriv\n"
+		 "  1 - Disallow cpu events for unpriv\n"
+		 "  2 - Disallow kernel profiling for unpriv",
+				 target->system_wide ? "system-wide " : "");
+	case ENOENT:
+		return scnprintf(msg, size, "The %s event is not supported.",
+				 perf_evsel__name(evsel));
+	case EMFILE:
+		return scnprintf(msg, size, "%s",
+			 "Too many events are opened.\n"
+			 "Try again after reducing the number of events.");
+	case ENODEV:
+		if (target->cpu_list)
+			return scnprintf(msg, size, "%s",
+	 "No such device - did you specify an out-of-range profile CPU?\n");
+		break;
+	case EOPNOTSUPP:
+		if (evsel->attr.precise_ip)
+			return scnprintf(msg, size, "%s",
+	"\'precise\' request may not be supported. Try removing 'p' modifier.");
+#if defined(__i386__) || defined(__x86_64__)
+		if (evsel->attr.type == PERF_TYPE_HARDWARE)
+			return scnprintf(msg, size, "%s",
+	"No hardware sampling interrupt available.\n"
+	"No APIC? If so then you can boot the kernel with the \"lapic\" boot parameter to force-enable it.");
+#endif
+		break;
+	default:
+		break;
+	}
+
+	return scnprintf(msg, size,
+	"The sys_perf_event_open() syscall returned with %d (%s) for event (%s).  \n"
+	"/bin/dmesg may provide additional information.\n"
+	"No CONFIG_PERF_EVENTS=y kernel support configured?\n",
+			 err, strerror(err), perf_evsel__name(evsel));
+}
diff --git a/tools/perf/util/evsel.h b/tools/perf/util/evsel.h
index 26d8cfd..c68d1b8 100644
--- a/tools/perf/util/evsel.h
+++ b/tools/perf/util/evsel.h
@@ -254,4 +254,7 @@ int perf_evsel__fprintf(struct perf_evsel *evsel,
 
 bool perf_evsel__fallback(struct perf_evsel *evsel, int err,
 			  char *msg, size_t msgsize);
+int perf_evsel__open_strerror(struct perf_evsel *evsel,
+			      struct perf_target *target,
+			      int err, char *msg, size_t size);
 #endif /* __PERF_EVSEL_H */
