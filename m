Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753301AbaAMUyU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Jan 2014 15:54:20 -0500
Received: from merlin.infradead.org ([205.233.59.134]:40406 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751971AbaAMUsJ (ORCPT
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
Subject: [PATCH 07/38] perf evlist: Auto unmap on destructor
Date: Mon, 13 Jan 2014 17:47:08 -0300
Message-Id: <1389646059-24881-8-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.8.1.4
In-Reply-To: <1389646059-24881-1-git-send-email-acme@infradead.org>
References: <1389646059-24881-1-git-send-email-acme@infradead.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by merlin.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Arnaldo Carvalho de Melo <acme@redhat.com>

Removing further boilerplate after making sure perf_evlist__munmap can
be called multiple times for the same evlist.

Cc: Adrian Hunter <adrian.hunter@intel.com>
Cc: David Ahern <dsahern@gmail.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Stephane Eranian <eranian@google.com>
Link: http://lkml.kernel.org/n/tip-o0luenuld4abupm4nmrgzm6f@git.kernel.org
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/builtin-record.c               |  2 --
 tools/perf/builtin-trace.c                |  1 -
 tools/perf/tests/code-reading.c           |  1 -
 tools/perf/tests/keep-tracking.c          |  1 -
 tools/perf/tests/mmap-basic.c             | 10 ++++------
 tools/perf/tests/open-syscall-tp-fields.c |  8 +++-----
 tools/perf/tests/perf-record.c            |  4 +---
 tools/perf/tests/perf-time-to-tsc.c       |  1 -
 tools/perf/tests/sw-clock.c               |  4 +---
 tools/perf/tests/task-exit.c              |  1 -
 tools/perf/util/evlist.c                  |  4 ++++
 11 files changed, 13 insertions(+), 24 deletions(-)

diff --git a/tools/perf/builtin-record.c b/tools/perf/builtin-record.c
index b7f5e438276b..cb00b53c200f 100644
--- a/tools/perf/builtin-record.c
+++ b/tools/perf/builtin-record.c
@@ -968,8 +968,6 @@ int cmd_record(int argc, const char **argv, const char *prefix __maybe_unused)
 	}
 
 	err = __cmd_record(&record, argc, argv);
-
-	perf_evlist__munmap(rec->evlist);
 out_symbol_exit:
 	symbol__exit();
 	return err;
diff --git a/tools/perf/builtin-trace.c b/tools/perf/builtin-trace.c
index aa8a5f46c361..399b4b91b456 100644
--- a/tools/perf/builtin-trace.c
+++ b/tools/perf/builtin-trace.c
@@ -1993,7 +1993,6 @@ out_disable:
 		}
 	}
 
-	perf_evlist__munmap(evlist);
 out_delete_evlist:
 	perf_evlist__delete(evlist);
 out:
diff --git a/tools/perf/tests/code-reading.c b/tools/perf/tests/code-reading.c
index 2c0ce723749f..653a8fe2db95 100644
--- a/tools/perf/tests/code-reading.c
+++ b/tools/perf/tests/code-reading.c
@@ -540,7 +540,6 @@ static int do_test_code_reading(bool try_kcore)
 		err = TEST_CODE_READING_OK;
 out_err:
 	if (evlist) {
-		perf_evlist__munmap(evlist);
 		perf_evlist__delete(evlist);
 	} else {
 		cpu_map__delete(cpus);
diff --git a/tools/perf/tests/keep-tracking.c b/tools/perf/tests/keep-tracking.c
index dd1c677510bd..497957f269d8 100644
--- a/tools/perf/tests/keep-tracking.c
+++ b/tools/perf/tests/keep-tracking.c
@@ -142,7 +142,6 @@ int test__keep_tracking(void)
 out_err:
 	if (evlist) {
 		perf_evlist__disable(evlist);
-		perf_evlist__munmap(evlist);
 		perf_evlist__delete(evlist);
 	} else {
 		cpu_map__delete(cpus);
diff --git a/tools/perf/tests/mmap-basic.c b/tools/perf/tests/mmap-basic.c
index 111dd4a917ad..aef25f0ff9cc 100644
--- a/tools/perf/tests/mmap-basic.c
+++ b/tools/perf/tests/mmap-basic.c
@@ -105,13 +105,13 @@ int test__basic_mmap(void)
 		if (event->header.type != PERF_RECORD_SAMPLE) {
 			pr_debug("unexpected %s event\n",
 				 perf_event__name(event->header.type));
-			goto out_munmap;
+			goto out_delete_evlist;
 		}
 
 		err = perf_evlist__parse_sample(evlist, event, &sample);
 		if (err) {
 			pr_err("Can't parse sample, err = %d\n", err);
-			goto out_munmap;
+			goto out_delete_evlist;
 		}
 
 		err = -1;
@@ -119,7 +119,7 @@ int test__basic_mmap(void)
 		if (evsel == NULL) {
 			pr_debug("event with id %" PRIu64
 				 " doesn't map to an evsel\n", sample.id);
-			goto out_munmap;
+			goto out_delete_evlist;
 		}
 		nr_events[evsel->idx]++;
 		perf_evlist__mmap_consume(evlist, 0);
@@ -132,12 +132,10 @@ int test__basic_mmap(void)
 				 expected_nr_events[evsel->idx],
 				 perf_evsel__name(evsel), nr_events[evsel->idx]);
 			err = -1;
-			goto out_munmap;
+			goto out_delete_evlist;
 		}
 	}
 
-out_munmap:
-	perf_evlist__munmap(evlist);
 out_delete_evlist:
 	perf_evlist__delete(evlist);
 	cpus	= NULL;
diff --git a/tools/perf/tests/open-syscall-tp-fields.c b/tools/perf/tests/open-syscall-tp-fields.c
index 0a00638a9ebb..5a016f66f5d2 100644
--- a/tools/perf/tests/open-syscall-tp-fields.c
+++ b/tools/perf/tests/open-syscall-tp-fields.c
@@ -85,7 +85,7 @@ int test__syscall_open_tp_fields(void)
 				err = perf_evsel__parse_sample(evsel, event, &sample);
 				if (err) {
 					pr_err("Can't parse sample, err = %d\n", err);
-					goto out_munmap;
+					goto out_delete_evlist;
 				}
 
 				tp_flags = perf_evsel__intval(evsel, &sample, "flags");
@@ -93,7 +93,7 @@ int test__syscall_open_tp_fields(void)
 				if (flags != tp_flags) {
 					pr_debug("%s: Expected flags=%#x, got %#x\n",
 						 __func__, flags, tp_flags);
-					goto out_munmap;
+					goto out_delete_evlist;
 				}
 
 				goto out_ok;
@@ -105,13 +105,11 @@ int test__syscall_open_tp_fields(void)
 
 		if (++nr_polls > 5) {
 			pr_debug("%s: no events!\n", __func__);
-			goto out_munmap;
+			goto out_delete_evlist;
 		}
 	}
 out_ok:
 	err = 0;
-out_munmap:
-	perf_evlist__munmap(evlist);
 out_delete_evlist:
 	perf_evlist__delete(evlist);
 out:
diff --git a/tools/perf/tests/perf-record.c b/tools/perf/tests/perf-record.c
index 682978e66efe..39cc7c3c0d0c 100644
--- a/tools/perf/tests/perf-record.c
+++ b/tools/perf/tests/perf-record.c
@@ -165,7 +165,7 @@ int test__PERF_RECORD(void)
 					if (verbose)
 						perf_event__fprintf(event, stderr);
 					pr_debug("Couldn't parse sample\n");
-					goto out_err;
+					goto out_delete_evlist;
 				}
 
 				if (verbose) {
@@ -302,8 +302,6 @@ found_exit:
 		pr_debug("PERF_RECORD_MMAP for %s missing!\n", "[vdso]");
 		++errs;
 	}
-out_err:
-	perf_evlist__munmap(evlist);
 out_delete_evlist:
 	perf_evlist__delete(evlist);
 out:
diff --git a/tools/perf/tests/perf-time-to-tsc.c b/tools/perf/tests/perf-time-to-tsc.c
index 3d50f2d2a4d5..47146d388dbf 100644
--- a/tools/perf/tests/perf-time-to-tsc.c
+++ b/tools/perf/tests/perf-time-to-tsc.c
@@ -166,7 +166,6 @@ next_event:
 out_err:
 	if (evlist) {
 		perf_evlist__disable(evlist);
-		perf_evlist__munmap(evlist);
 		perf_evlist__delete(evlist);
 	}
 
diff --git a/tools/perf/tests/sw-clock.c b/tools/perf/tests/sw-clock.c
index b366f0edca79..983d6b8562a8 100644
--- a/tools/perf/tests/sw-clock.c
+++ b/tools/perf/tests/sw-clock.c
@@ -90,7 +90,7 @@ static int __test__sw_clock_freq(enum perf_sw_ids clock_id)
 		err = perf_evlist__parse_sample(evlist, event, &sample);
 		if (err < 0) {
 			pr_debug("Error during parse sample\n");
-			goto out_unmap_evlist;
+			goto out_delete_evlist;
 		}
 
 		total_periods += sample.period;
@@ -105,8 +105,6 @@ next_event:
 		err = -1;
 	}
 
-out_unmap_evlist:
-	perf_evlist__munmap(evlist);
 out_delete_evlist:
 	perf_evlist__delete(evlist);
 	return err;
diff --git a/tools/perf/tests/task-exit.c b/tools/perf/tests/task-exit.c
index 5511a0a929cd..5ff3db318f12 100644
--- a/tools/perf/tests/task-exit.c
+++ b/tools/perf/tests/task-exit.c
@@ -112,7 +112,6 @@ retry:
 		err = -1;
 	}
 
-	perf_evlist__munmap(evlist);
 out_delete_evlist:
 	perf_evlist__delete(evlist);
 	return err;
diff --git a/tools/perf/util/evlist.c b/tools/perf/util/evlist.c
index a083bdc4680e..0810f5ca77d7 100644
--- a/tools/perf/util/evlist.c
+++ b/tools/perf/util/evlist.c
@@ -107,6 +107,7 @@ void perf_evlist__exit(struct perf_evlist *evlist)
 
 void perf_evlist__delete(struct perf_evlist *evlist)
 {
+	perf_evlist__munmap(evlist);
 	perf_evlist__close(evlist);
 	cpu_map__delete(evlist->cpus);
 	thread_map__delete(evlist->threads);
@@ -587,6 +588,9 @@ void perf_evlist__munmap(struct perf_evlist *evlist)
 {
 	int i;
 
+	if (evlist->mmap == NULL)
+		return;
+
 	for (i = 0; i < evlist->nr_mmaps; i++)
 		__perf_evlist__munmap(evlist, i);
 
-- 
1.8.1.4

