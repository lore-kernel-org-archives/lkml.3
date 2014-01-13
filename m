Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752763AbaAMUuU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Jan 2014 15:50:20 -0500
Received: from merlin.infradead.org ([205.233.59.134]:40467 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752286AbaAMUsM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Jan 2014 15:48:12 -0500
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
Subject: [PATCH 05/38] perf evlist: Move destruction of maps to evlist destructor
Date: Mon, 13 Jan 2014 17:47:06 -0300
Message-Id: <1389646059-24881-6-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.8.1.4
In-Reply-To: <1389646059-24881-1-git-send-email-acme@infradead.org>
References: <1389646059-24881-1-git-send-email-acme@infradead.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by merlin.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Arnaldo Carvalho de Melo <acme@redhat.com>

Instead of requiring tools to do an extra destructor call just before
calling perf_evlist__delete.

Cc: Adrian Hunter <adrian.hunter@intel.com>
Cc: David Ahern <dsahern@gmail.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Stephane Eranian <eranian@google.com>
Link: http://lkml.kernel.org/n/tip-0jd2ptzyikxb5wp7inzz2ah2@git.kernel.org
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/builtin-kvm.c                  |  4 +---
 tools/perf/builtin-record.c               |  4 +---
 tools/perf/builtin-stat.c                 |  8 +++-----
 tools/perf/builtin-top.c                  |  6 ++----
 tools/perf/builtin-trace.c                |  6 ++----
 tools/perf/tests/code-reading.c           |  5 ++---
 tools/perf/tests/keep-tracking.c          |  5 ++---
 tools/perf/tests/mmap-basic.c             |  2 ++
 tools/perf/tests/open-syscall-tp-fields.c |  4 +---
 tools/perf/tests/perf-record.c            | 10 ++++------
 tools/perf/tests/perf-time-to-tsc.c       |  4 ----
 tools/perf/tests/sw-clock.c               | 10 ++++------
 tools/perf/tests/task-exit.c              |  9 ++++-----
 tools/perf/util/evlist.c                  | 12 ++++--------
 tools/perf/util/evlist.h                  |  1 -
 15 files changed, 32 insertions(+), 58 deletions(-)

diff --git a/tools/perf/builtin-kvm.c b/tools/perf/builtin-kvm.c
index a6ec1052c291..858b11bf6711 100644
--- a/tools/perf/builtin-kvm.c
+++ b/tools/perf/builtin-kvm.c
@@ -1556,10 +1556,8 @@ out:
 	if (kvm->session)
 		perf_session__delete(kvm->session);
 	kvm->session = NULL;
-	if (kvm->evlist) {
-		perf_evlist__delete_maps(kvm->evlist);
+	if (kvm->evlist)
 		perf_evlist__delete(kvm->evlist);
-	}
 
 	return err;
 }
diff --git a/tools/perf/builtin-record.c b/tools/perf/builtin-record.c
index 6dcb8aae908c..5149b41e63d1 100644
--- a/tools/perf/builtin-record.c
+++ b/tools/perf/builtin-record.c
@@ -964,15 +964,13 @@ int cmd_record(int argc, const char **argv, const char *prefix __maybe_unused)
 
 	if (record_opts__config(&rec->opts)) {
 		err = -EINVAL;
-		goto out_free_fd;
+		goto out_symbol_exit;
 	}
 
 	err = __cmd_record(&record, argc, argv);
 
 	perf_evlist__munmap(rec->evlist);
 	perf_evlist__close(rec->evlist);
-out_free_fd:
-	perf_evlist__delete_maps(rec->evlist);
 out_symbol_exit:
 	symbol__exit();
 	return err;
diff --git a/tools/perf/builtin-stat.c b/tools/perf/builtin-stat.c
index f8456cad656d..6ca076660de5 100644
--- a/tools/perf/builtin-stat.c
+++ b/tools/perf/builtin-stat.c
@@ -1782,14 +1782,14 @@ int cmd_stat(int argc, const char **argv, const char *prefix __maybe_unused)
 	if (interval && interval < 100) {
 		pr_err("print interval must be >= 100ms\n");
 		parse_options_usage(stat_usage, options, "I", 1);
-		goto out_free_maps;
+		goto out;
 	}
 
 	if (perf_evlist__alloc_stats(evsel_list, interval))
-		goto out_free_maps;
+		goto out;
 
 	if (perf_stat_init_aggr_mode())
-		goto out_free_maps;
+		goto out;
 
 	/*
 	 * We dont want to block the signals - that would cause
@@ -1821,8 +1821,6 @@ int cmd_stat(int argc, const char **argv, const char *prefix __maybe_unused)
 		print_stat(argc, argv);
 
 	perf_evlist__free_stats(evsel_list);
-out_free_maps:
-	perf_evlist__delete_maps(evsel_list);
 out:
 	perf_evlist__delete(evsel_list);
 	return status;
diff --git a/tools/perf/builtin-top.c b/tools/perf/builtin-top.c
index 172e91a9ce62..e0fd0aa57f06 100644
--- a/tools/perf/builtin-top.c
+++ b/tools/perf/builtin-top.c
@@ -1171,7 +1171,7 @@ int cmd_top(int argc, const char **argv, const char *prefix __maybe_unused)
 	if (!top.evlist->nr_entries &&
 	    perf_evlist__add_default(top.evlist) < 0) {
 		ui__error("Not enough memory for event selector list\n");
-		goto out_delete_maps;
+		goto out_delete_evlist;
 	}
 
 	symbol_conf.nr_events = top.evlist->nr_entries;
@@ -1181,7 +1181,7 @@ int cmd_top(int argc, const char **argv, const char *prefix __maybe_unused)
 
 	if (record_opts__config(opts)) {
 		status = -EINVAL;
-		goto out_delete_maps;
+		goto out_delete_evlist;
 	}
 
 	top.sym_evsel = perf_evlist__first(top.evlist);
@@ -1206,8 +1206,6 @@ int cmd_top(int argc, const char **argv, const char *prefix __maybe_unused)
 
 	status = __cmd_top(&top);
 
-out_delete_maps:
-	perf_evlist__delete_maps(top.evlist);
 out_delete_evlist:
 	perf_evlist__delete(top.evlist);
 
diff --git a/tools/perf/builtin-trace.c b/tools/perf/builtin-trace.c
index 5498eacf8fc6..f4ddd14b8a9b 100644
--- a/tools/perf/builtin-trace.c
+++ b/tools/perf/builtin-trace.c
@@ -1885,7 +1885,7 @@ static int trace__run(struct trace *trace, int argc, const char **argv)
 	err = trace__symbols_init(trace, evlist);
 	if (err < 0) {
 		fprintf(trace->output, "Problems initializing symbol libraries!\n");
-		goto out_delete_maps;
+		goto out_delete_evlist;
 	}
 
 	perf_evlist__config(evlist, &trace->opts);
@@ -1898,7 +1898,7 @@ static int trace__run(struct trace *trace, int argc, const char **argv)
 						    argv, false, NULL);
 		if (err < 0) {
 			fprintf(trace->output, "Couldn't run the workload!\n");
-			goto out_delete_maps;
+			goto out_delete_evlist;
 		}
 	}
 
@@ -1996,8 +1996,6 @@ out_disable:
 	perf_evlist__munmap(evlist);
 out_close_evlist:
 	perf_evlist__close(evlist);
-out_delete_maps:
-	perf_evlist__delete_maps(evlist);
 out_delete_evlist:
 	perf_evlist__delete(evlist);
 out:
diff --git a/tools/perf/tests/code-reading.c b/tools/perf/tests/code-reading.c
index 4248d1e96848..ddbc7756620c 100644
--- a/tools/perf/tests/code-reading.c
+++ b/tools/perf/tests/code-reading.c
@@ -543,11 +543,10 @@ out_err:
 		perf_evlist__munmap(evlist);
 		perf_evlist__close(evlist);
 		perf_evlist__delete(evlist);
-	}
-	if (cpus)
+	} else {
 		cpu_map__delete(cpus);
-	if (threads)
 		thread_map__delete(threads);
+	}
 	machines__destroy_kernel_maps(&machines);
 	machine__delete_threads(machine);
 	machines__exit(&machines);
diff --git a/tools/perf/tests/keep-tracking.c b/tools/perf/tests/keep-tracking.c
index 27eb75142b88..f9bc1fcd17cd 100644
--- a/tools/perf/tests/keep-tracking.c
+++ b/tools/perf/tests/keep-tracking.c
@@ -145,11 +145,10 @@ out_err:
 		perf_evlist__munmap(evlist);
 		perf_evlist__close(evlist);
 		perf_evlist__delete(evlist);
-	}
-	if (cpus)
+	} else {
 		cpu_map__delete(cpus);
-	if (threads)
 		thread_map__delete(threads);
+	}
 
 	return err;
 }
diff --git a/tools/perf/tests/mmap-basic.c b/tools/perf/tests/mmap-basic.c
index d64ab79c6d35..bbb334d2a864 100644
--- a/tools/perf/tests/mmap-basic.c
+++ b/tools/perf/tests/mmap-basic.c
@@ -143,6 +143,8 @@ out_close_fd:
 		perf_evsel__close_fd(evsels[i], 1, threads->nr);
 out_free_evlist:
 	perf_evlist__delete(evlist);
+	cpus	= NULL;
+	threads = NULL;
 out_free_cpus:
 	cpu_map__delete(cpus);
 out_free_threads:
diff --git a/tools/perf/tests/open-syscall-tp-fields.c b/tools/perf/tests/open-syscall-tp-fields.c
index 774620a5aecb..595b577172a6 100644
--- a/tools/perf/tests/open-syscall-tp-fields.c
+++ b/tools/perf/tests/open-syscall-tp-fields.c
@@ -48,7 +48,7 @@ int test__syscall_open_tp_fields(void)
 	err = perf_evlist__open(evlist);
 	if (err < 0) {
 		pr_debug("perf_evlist__open: %s\n", strerror(errno));
-		goto out_delete_maps;
+		goto out_delete_evlist;
 	}
 
 	err = perf_evlist__mmap(evlist, UINT_MAX, false);
@@ -114,8 +114,6 @@ out_munmap:
 	perf_evlist__munmap(evlist);
 out_close_evlist:
 	perf_evlist__close(evlist);
-out_delete_maps:
-	perf_evlist__delete_maps(evlist);
 out_delete_evlist:
 	perf_evlist__delete(evlist);
 out:
diff --git a/tools/perf/tests/perf-record.c b/tools/perf/tests/perf-record.c
index fa0ed35afb9a..266da9d41300 100644
--- a/tools/perf/tests/perf-record.c
+++ b/tools/perf/tests/perf-record.c
@@ -86,7 +86,7 @@ int test__PERF_RECORD(void)
 	err = perf_evlist__prepare_workload(evlist, &opts.target, argv, false, NULL);
 	if (err < 0) {
 		pr_debug("Couldn't run the workload!\n");
-		goto out_delete_maps;
+		goto out_delete_evlist;
 	}
 
 	/*
@@ -101,7 +101,7 @@ int test__PERF_RECORD(void)
 	err = sched__get_first_possible_cpu(evlist->workload.pid, &cpu_mask);
 	if (err < 0) {
 		pr_debug("sched__get_first_possible_cpu: %s\n", strerror(errno));
-		goto out_delete_maps;
+		goto out_delete_evlist;
 	}
 
 	cpu = err;
@@ -111,7 +111,7 @@ int test__PERF_RECORD(void)
 	 */
 	if (sched_setaffinity(evlist->workload.pid, cpu_mask_size, &cpu_mask) < 0) {
 		pr_debug("sched_setaffinity: %s\n", strerror(errno));
-		goto out_delete_maps;
+		goto out_delete_evlist;
 	}
 
 	/*
@@ -121,7 +121,7 @@ int test__PERF_RECORD(void)
 	err = perf_evlist__open(evlist);
 	if (err < 0) {
 		pr_debug("perf_evlist__open: %s\n", strerror(errno));
-		goto out_delete_maps;
+		goto out_delete_evlist;
 	}
 
 	/*
@@ -306,8 +306,6 @@ out_err:
 	perf_evlist__munmap(evlist);
 out_close_evlist:
 	perf_evlist__close(evlist);
-out_delete_maps:
-	perf_evlist__delete_maps(evlist);
 out_delete_evlist:
 	perf_evlist__delete(evlist);
 out:
diff --git a/tools/perf/tests/perf-time-to-tsc.c b/tools/perf/tests/perf-time-to-tsc.c
index c6398b90e897..97d08fff1f8d 100644
--- a/tools/perf/tests/perf-time-to-tsc.c
+++ b/tools/perf/tests/perf-time-to-tsc.c
@@ -170,10 +170,6 @@ out_err:
 		perf_evlist__close(evlist);
 		perf_evlist__delete(evlist);
 	}
-	if (cpus)
-		cpu_map__delete(cpus);
-	if (threads)
-		thread_map__delete(threads);
 
 	return err;
 }
diff --git a/tools/perf/tests/sw-clock.c b/tools/perf/tests/sw-clock.c
index 6664a7cd828c..266d38127ba6 100644
--- a/tools/perf/tests/sw-clock.c
+++ b/tools/perf/tests/sw-clock.c
@@ -45,7 +45,7 @@ static int __test__sw_clock_freq(enum perf_sw_ids clock_id)
 	evsel = perf_evsel__new(&attr);
 	if (evsel == NULL) {
 		pr_debug("perf_evsel__new\n");
-		goto out_free_evlist;
+		goto out_delete_evlist;
 	}
 	perf_evlist__add(evlist, evsel);
 
@@ -54,7 +54,7 @@ static int __test__sw_clock_freq(enum perf_sw_ids clock_id)
 	if (!evlist->cpus || !evlist->threads) {
 		err = -ENOMEM;
 		pr_debug("Not enough memory to create thread/cpu maps\n");
-		goto out_delete_maps;
+		goto out_delete_evlist;
 	}
 
 	if (perf_evlist__open(evlist)) {
@@ -63,7 +63,7 @@ static int __test__sw_clock_freq(enum perf_sw_ids clock_id)
 		err = -errno;
 		pr_debug("Couldn't open evlist: %s\nHint: check %s, using %" PRIu64 " in this test.\n",
 			 strerror(errno), knob, (u64)attr.sample_freq);
-		goto out_delete_maps;
+		goto out_delete_evlist;
 	}
 
 	err = perf_evlist__mmap(evlist, 128, true);
@@ -109,9 +109,7 @@ out_unmap_evlist:
 	perf_evlist__munmap(evlist);
 out_close_evlist:
 	perf_evlist__close(evlist);
-out_delete_maps:
-	perf_evlist__delete_maps(evlist);
-out_free_evlist:
+out_delete_evlist:
 	perf_evlist__delete(evlist);
 	return err;
 }
diff --git a/tools/perf/tests/task-exit.c b/tools/perf/tests/task-exit.c
index 44e339d4e297..fdeb2aa46a50 100644
--- a/tools/perf/tests/task-exit.c
+++ b/tools/perf/tests/task-exit.c
@@ -62,14 +62,14 @@ int test__task_exit(void)
 	if (!evlist->cpus || !evlist->threads) {
 		err = -ENOMEM;
 		pr_debug("Not enough memory to create thread/cpu maps\n");
-		goto out_delete_maps;
+		goto out_delete_evlist;
 	}
 
 	err = perf_evlist__prepare_workload(evlist, &target, argv, false,
 					    workload_exec_failed_signal);
 	if (err < 0) {
 		pr_debug("Couldn't run the workload!\n");
-		goto out_delete_maps;
+		goto out_delete_evlist;
 	}
 
 	evsel = perf_evlist__first(evlist);
@@ -83,7 +83,7 @@ int test__task_exit(void)
 	err = perf_evlist__open(evlist);
 	if (err < 0) {
 		pr_debug("Couldn't open the evlist: %s\n", strerror(-err));
-		goto out_delete_maps;
+		goto out_delete_evlist;
 	}
 
 	if (perf_evlist__mmap(evlist, 128, true) < 0) {
@@ -115,8 +115,7 @@ retry:
 	perf_evlist__munmap(evlist);
 out_close_evlist:
 	perf_evlist__close(evlist);
-out_delete_maps:
-	perf_evlist__delete_maps(evlist);
+out_delete_evlist:
 	perf_evlist__delete(evlist);
 	return err;
 }
diff --git a/tools/perf/util/evlist.c b/tools/perf/util/evlist.c
index 96b3ef547db4..143eaf05178f 100644
--- a/tools/perf/util/evlist.c
+++ b/tools/perf/util/evlist.c
@@ -107,6 +107,10 @@ void perf_evlist__exit(struct perf_evlist *evlist)
 
 void perf_evlist__delete(struct perf_evlist *evlist)
 {
+	cpu_map__delete(evlist->cpus);
+	thread_map__delete(evlist->threads);
+	evlist->cpus = NULL;
+	evlist->threads = NULL;
 	perf_evlist__purge(evlist);
 	perf_evlist__exit(evlist);
 	free(evlist);
@@ -833,14 +837,6 @@ out_delete_threads:
 	return -1;
 }
 
-void perf_evlist__delete_maps(struct perf_evlist *evlist)
-{
-	cpu_map__delete(evlist->cpus);
-	thread_map__delete(evlist->threads);
-	evlist->cpus	= NULL;
-	evlist->threads = NULL;
-}
-
 int perf_evlist__apply_filters(struct perf_evlist *evlist)
 {
 	struct perf_evsel *evsel;
diff --git a/tools/perf/util/evlist.h b/tools/perf/util/evlist.h
index 18d1222c0762..518e521c801d 100644
--- a/tools/perf/util/evlist.h
+++ b/tools/perf/util/evlist.h
@@ -135,7 +135,6 @@ static inline void perf_evlist__set_maps(struct perf_evlist *evlist,
 }
 
 int perf_evlist__create_maps(struct perf_evlist *evlist, struct target *target);
-void perf_evlist__delete_maps(struct perf_evlist *evlist);
 int perf_evlist__apply_filters(struct perf_evlist *evlist);
 
 void __perf_evlist__set_leader(struct list_head *list);
-- 
1.8.1.4

