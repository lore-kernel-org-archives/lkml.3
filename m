Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753348AbaAMUy2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Jan 2014 15:54:28 -0500
Received: from merlin.infradead.org ([205.233.59.134]:40411 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751936AbaAMUsJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Jan 2014 15:48:09 -0500
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org, Arnaldo Carvalho de Melo <acme@redhat.com>,
        Adrian Hunter <adrian.hunter@intel.com>,
        David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Jiri Olsa <jolsa@redhat.com>,
        Mike Galbraith <efault@gmx.de>, Namhyung Kim <namhyung@kernel.org>,
        Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Stephane Eranian <eranian@google.com>
Subject: [PATCH 06/38] perf evlist: Close fds on destructor
Date: Mon, 13 Jan 2014 17:47:07 -0300
Message-Id: <1389646059-24881-7-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.8.1.4
In-Reply-To: <1389646059-24881-1-git-send-email-acme@infradead.org>
References: <1389646059-24881-1-git-send-email-acme@infradead.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by merlin.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Arnaldo Carvalho de Melo <acme@redhat.com>

Since it is safe to call perf_evlist__close() multiple times, autoclose
it and remove the calls to the close from existing tools, reducing the
tooling boilerplate.

Cc: Adrian Hunter <adrian.hunter@intel.com>
Cc: David Ahern <dsahern@gmail.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Stephane Eranian <eranian@google.com>
Link: http://lkml.kernel.org/n/tip-2kq9v7p1rude1tqxa0aue2tk@git.kernel.org
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/builtin-record.c               |  1 -
 tools/perf/builtin-trace.c                |  4 +---
 tools/perf/tests/code-reading.c           |  1 -
 tools/perf/tests/keep-tracking.c          |  1 -
 tools/perf/tests/mmap-basic.c             | 11 ++++-------
 tools/perf/tests/open-syscall-tp-fields.c |  4 +---
 tools/perf/tests/perf-record.c            |  4 +---
 tools/perf/tests/perf-time-to-tsc.c       |  1 -
 tools/perf/tests/sw-clock.c               |  4 +---
 tools/perf/tests/task-exit.c              |  4 +---
 tools/perf/util/evlist.c                  |  1 +
 11 files changed, 10 insertions(+), 26 deletions(-)

diff --git a/tools/perf/builtin-record.c b/tools/perf/builtin-record.c
index 5149b41e63d1..b7f5e438276b 100644
--- a/tools/perf/builtin-record.c
+++ b/tools/perf/builtin-record.c
@@ -970,7 +970,6 @@ int cmd_record(int argc, const char **argv, const char *prefix __maybe_unused)
 	err = __cmd_record(&record, argc, argv);
 
 	perf_evlist__munmap(rec->evlist);
-	perf_evlist__close(rec->evlist);
 out_symbol_exit:
 	symbol__exit();
 	return err;
diff --git a/tools/perf/builtin-trace.c b/tools/perf/builtin-trace.c
index f4ddd14b8a9b..aa8a5f46c361 100644
--- a/tools/perf/builtin-trace.c
+++ b/tools/perf/builtin-trace.c
@@ -1909,7 +1909,7 @@ static int trace__run(struct trace *trace, int argc, const char **argv)
 	err = perf_evlist__mmap(evlist, trace->opts.mmap_pages, false);
 	if (err < 0) {
 		fprintf(trace->output, "Couldn't mmap the events: %s\n", strerror(errno));
-		goto out_close_evlist;
+		goto out_delete_evlist;
 	}
 
 	perf_evlist__enable(evlist);
@@ -1994,8 +1994,6 @@ out_disable:
 	}
 
 	perf_evlist__munmap(evlist);
-out_close_evlist:
-	perf_evlist__close(evlist);
 out_delete_evlist:
 	perf_evlist__delete(evlist);
 out:
diff --git a/tools/perf/tests/code-reading.c b/tools/perf/tests/code-reading.c
index ddbc7756620c..2c0ce723749f 100644
--- a/tools/perf/tests/code-reading.c
+++ b/tools/perf/tests/code-reading.c
@@ -541,7 +541,6 @@ static int do_test_code_reading(bool try_kcore)
 out_err:
 	if (evlist) {
 		perf_evlist__munmap(evlist);
-		perf_evlist__close(evlist);
 		perf_evlist__delete(evlist);
 	} else {
 		cpu_map__delete(cpus);
diff --git a/tools/perf/tests/keep-tracking.c b/tools/perf/tests/keep-tracking.c
index f9bc1fcd17cd..dd1c677510bd 100644
--- a/tools/perf/tests/keep-tracking.c
+++ b/tools/perf/tests/keep-tracking.c
@@ -143,7 +143,6 @@ out_err:
 	if (evlist) {
 		perf_evlist__disable(evlist);
 		perf_evlist__munmap(evlist);
-		perf_evlist__close(evlist);
 		perf_evlist__delete(evlist);
 	} else {
 		cpu_map__delete(cpus);
diff --git a/tools/perf/tests/mmap-basic.c b/tools/perf/tests/mmap-basic.c
index bbb334d2a864..111dd4a917ad 100644
--- a/tools/perf/tests/mmap-basic.c
+++ b/tools/perf/tests/mmap-basic.c
@@ -68,7 +68,7 @@ int test__basic_mmap(void)
 		evsels[i] = perf_evsel__newtp("syscalls", name);
 		if (evsels[i] == NULL) {
 			pr_debug("perf_evsel__new\n");
-			goto out_free_evlist;
+			goto out_delete_evlist;
 		}
 
 		evsels[i]->attr.wakeup_events = 1;
@@ -80,7 +80,7 @@ int test__basic_mmap(void)
 			pr_debug("failed to open counter: %s, "
 				 "tweak /proc/sys/kernel/perf_event_paranoid?\n",
 				 strerror(errno));
-			goto out_close_fd;
+			goto out_delete_evlist;
 		}
 
 		nr_events[i] = 0;
@@ -90,7 +90,7 @@ int test__basic_mmap(void)
 	if (perf_evlist__mmap(evlist, 128, true) < 0) {
 		pr_debug("failed to mmap events: %d (%s)\n", errno,
 			 strerror(errno));
-		goto out_close_fd;
+		goto out_delete_evlist;
 	}
 
 	for (i = 0; i < nsyscalls; ++i)
@@ -138,10 +138,7 @@ int test__basic_mmap(void)
 
 out_munmap:
 	perf_evlist__munmap(evlist);
-out_close_fd:
-	for (i = 0; i < nsyscalls; ++i)
-		perf_evsel__close_fd(evsels[i], 1, threads->nr);
-out_free_evlist:
+out_delete_evlist:
 	perf_evlist__delete(evlist);
 	cpus	= NULL;
 	threads = NULL;
diff --git a/tools/perf/tests/open-syscall-tp-fields.c b/tools/perf/tests/open-syscall-tp-fields.c
index 595b577172a6..0a00638a9ebb 100644
--- a/tools/perf/tests/open-syscall-tp-fields.c
+++ b/tools/perf/tests/open-syscall-tp-fields.c
@@ -54,7 +54,7 @@ int test__syscall_open_tp_fields(void)
 	err = perf_evlist__mmap(evlist, UINT_MAX, false);
 	if (err < 0) {
 		pr_debug("perf_evlist__mmap: %s\n", strerror(errno));
-		goto out_close_evlist;
+		goto out_delete_evlist;
 	}
 
 	perf_evlist__enable(evlist);
@@ -112,8 +112,6 @@ out_ok:
 	err = 0;
 out_munmap:
 	perf_evlist__munmap(evlist);
-out_close_evlist:
-	perf_evlist__close(evlist);
 out_delete_evlist:
 	perf_evlist__delete(evlist);
 out:
diff --git a/tools/perf/tests/perf-record.c b/tools/perf/tests/perf-record.c
index 266da9d41300..682978e66efe 100644
--- a/tools/perf/tests/perf-record.c
+++ b/tools/perf/tests/perf-record.c
@@ -132,7 +132,7 @@ int test__PERF_RECORD(void)
 	err = perf_evlist__mmap(evlist, opts.mmap_pages, false);
 	if (err < 0) {
 		pr_debug("perf_evlist__mmap: %s\n", strerror(errno));
-		goto out_close_evlist;
+		goto out_delete_evlist;
 	}
 
 	/*
@@ -304,8 +304,6 @@ found_exit:
 	}
 out_err:
 	perf_evlist__munmap(evlist);
-out_close_evlist:
-	perf_evlist__close(evlist);
 out_delete_evlist:
 	perf_evlist__delete(evlist);
 out:
diff --git a/tools/perf/tests/perf-time-to-tsc.c b/tools/perf/tests/perf-time-to-tsc.c
index 97d08fff1f8d..3d50f2d2a4d5 100644
--- a/tools/perf/tests/perf-time-to-tsc.c
+++ b/tools/perf/tests/perf-time-to-tsc.c
@@ -167,7 +167,6 @@ out_err:
 	if (evlist) {
 		perf_evlist__disable(evlist);
 		perf_evlist__munmap(evlist);
-		perf_evlist__close(evlist);
 		perf_evlist__delete(evlist);
 	}
 
diff --git a/tools/perf/tests/sw-clock.c b/tools/perf/tests/sw-clock.c
index 266d38127ba6..b366f0edca79 100644
--- a/tools/perf/tests/sw-clock.c
+++ b/tools/perf/tests/sw-clock.c
@@ -70,7 +70,7 @@ static int __test__sw_clock_freq(enum perf_sw_ids clock_id)
 	if (err < 0) {
 		pr_debug("failed to mmap event: %d (%s)\n", errno,
 			 strerror(errno));
-		goto out_close_evlist;
+		goto out_delete_evlist;
 	}
 
 	perf_evlist__enable(evlist);
@@ -107,8 +107,6 @@ next_event:
 
 out_unmap_evlist:
 	perf_evlist__munmap(evlist);
-out_close_evlist:
-	perf_evlist__close(evlist);
 out_delete_evlist:
 	perf_evlist__delete(evlist);
 	return err;
diff --git a/tools/perf/tests/task-exit.c b/tools/perf/tests/task-exit.c
index fdeb2aa46a50..5511a0a929cd 100644
--- a/tools/perf/tests/task-exit.c
+++ b/tools/perf/tests/task-exit.c
@@ -89,7 +89,7 @@ int test__task_exit(void)
 	if (perf_evlist__mmap(evlist, 128, true) < 0) {
 		pr_debug("failed to mmap events: %d (%s)\n", errno,
 			 strerror(errno));
-		goto out_close_evlist;
+		goto out_delete_evlist;
 	}
 
 	perf_evlist__start_workload(evlist);
@@ -113,8 +113,6 @@ retry:
 	}
 
 	perf_evlist__munmap(evlist);
-out_close_evlist:
-	perf_evlist__close(evlist);
 out_delete_evlist:
 	perf_evlist__delete(evlist);
 	return err;
diff --git a/tools/perf/util/evlist.c b/tools/perf/util/evlist.c
index 143eaf05178f..a083bdc4680e 100644
--- a/tools/perf/util/evlist.c
+++ b/tools/perf/util/evlist.c
@@ -107,6 +107,7 @@ void perf_evlist__exit(struct perf_evlist *evlist)
 
 void perf_evlist__delete(struct perf_evlist *evlist)
 {
+	perf_evlist__close(evlist);
 	cpu_map__delete(evlist->cpus);
 	thread_map__delete(evlist->threads);
 	evlist->cpus = NULL;
-- 
1.8.1.4

