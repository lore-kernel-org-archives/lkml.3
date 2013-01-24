Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755504Ab3AXTDp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jan 2013 14:03:45 -0500
Received: from terminus.zytor.com ([198.137.202.10]:33136 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752319Ab3AXTDl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jan 2013 14:03:41 -0500
Date: Thu, 24 Jan 2013 11:03:06 -0800
From: tip-bot for Arnaldo Carvalho de Melo <acme@redhat.com>
Message-ID: <tip-13p2ov2rg166y73j9uazukma@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, eranian@google.com, paulus@samba.org,
        acme@redhat.com, hpa@zytor.com, mingo@kernel.org, peterz@infradead.org,
        efault@gmx.de, namhyung@gmail.com, jolsa@redhat.com,
        fweisbec@gmail.com, dsahern@gmail.com, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, acme@redhat.com, paulus@samba.org,
        eranian@google.com, linux-kernel@vger.kernel.org, efault@gmx.de,
        peterz@infradead.org, namhyung@gmail.com, jolsa@redhat.com,
        fweisbec@gmail.com, dsahern@gmail.com, tglx@linutronix.de
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf test:
  Use perf_evsel__newtp constructor in the tracepoint tests
Git-Commit-ID: a60d79535c21dca4e24d08abf8ab56e2f860af71
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.7 (terminus.zytor.com [127.0.0.1]); Thu, 24 Jan 2013 11:03:12 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  a60d79535c21dca4e24d08abf8ab56e2f860af71
Gitweb:     http://git.kernel.org/tip/a60d79535c21dca4e24d08abf8ab56e2f860af71
Author:     Arnaldo Carvalho de Melo <acme@redhat.com>
AuthorDate: Mon, 10 Dec 2012 15:11:43 -0300
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Mon, 10 Dec 2012 15:11:43 -0300

perf test: Use perf_evsel__newtp constructor in the tracepoint tests

Removing one trace_event__id function, not used anymore.

Cc: David Ahern <dsahern@gmail.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Namhyung Kim <namhyung@gmail.com>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Stephane Eranian <eranian@google.com>
Link: http://lkml.kernel.org/n/tip-13p2ov2rg166y73j9uazukma@git.kernel.org
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>

Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/Makefile                      |  1 -
 tools/perf/tests/mmap-basic.c            | 37 ++++++++++----------------------
 tools/perf/tests/open-syscall-all-cpus.c | 18 +++-------------
 tools/perf/tests/open-syscall.c          | 17 +++------------
 tools/perf/tests/tests.h                 |  3 ---
 tools/perf/tests/util.c                  | 30 --------------------------
 6 files changed, 17 insertions(+), 89 deletions(-)

diff --git a/tools/perf/Makefile b/tools/perf/Makefile
index 2a07b95..10aa24c 100644
--- a/tools/perf/Makefile
+++ b/tools/perf/Makefile
@@ -487,7 +487,6 @@ LIB_OBJS += $(OUTPUT)tests/rdpmc.o
 LIB_OBJS += $(OUTPUT)tests/evsel-roundtrip-name.o
 LIB_OBJS += $(OUTPUT)tests/evsel-tp-sched.o
 LIB_OBJS += $(OUTPUT)tests/pmu.o
-LIB_OBJS += $(OUTPUT)tests/util.o
 
 BUILTIN_OBJS += $(OUTPUT)builtin-annotate.o
 BUILTIN_OBJS += $(OUTPUT)builtin-bench.o
diff --git a/tools/perf/tests/mmap-basic.c b/tools/perf/tests/mmap-basic.c
index 8682ecf..4743b6d 100644
--- a/tools/perf/tests/mmap-basic.c
+++ b/tools/perf/tests/mmap-basic.c
@@ -22,36 +22,16 @@ int test__basic_mmap(void)
 	struct thread_map *threads;
 	struct cpu_map *cpus;
 	struct perf_evlist *evlist;
-	struct perf_event_attr attr = {
-		.type		= PERF_TYPE_TRACEPOINT,
-		.read_format	= PERF_FORMAT_ID,
-		.sample_type	= PERF_SAMPLE_ID,
-		.watermark	= 0,
-	};
 	cpu_set_t cpu_set;
 	const char *syscall_names[] = { "getsid", "getppid", "getpgrp",
 					"getpgid", };
 	pid_t (*syscalls[])(void) = { (void *)getsid, getppid, getpgrp,
 				      (void*)getpgid };
 #define nsyscalls ARRAY_SIZE(syscall_names)
-	int ids[nsyscalls];
 	unsigned int nr_events[nsyscalls],
 		     expected_nr_events[nsyscalls], i, j;
 	struct perf_evsel *evsels[nsyscalls], *evsel;
 
-	for (i = 0; i < nsyscalls; ++i) {
-		char name[64];
-
-		snprintf(name, sizeof(name), "sys_enter_%s", syscall_names[i]);
-		ids[i] = trace_event__id(name);
-		if (ids[i] < 0) {
-			pr_debug("Is debugfs mounted on /sys/kernel/debug?\n");
-			return -1;
-		}
-		nr_events[i] = 0;
-		expected_nr_events[i] = random() % 257;
-	}
-
 	threads = thread_map__new(-1, getpid(), UINT_MAX);
 	if (threads == NULL) {
 		pr_debug("thread_map__new\n");
@@ -79,18 +59,20 @@ int test__basic_mmap(void)
 		goto out_free_cpus;
 	}
 
-	/* anonymous union fields, can't be initialized above */
-	attr.wakeup_events = 1;
-	attr.sample_period = 1;
-
 	for (i = 0; i < nsyscalls; ++i) {
-		attr.config = ids[i];
-		evsels[i] = perf_evsel__new(&attr, i);
+		char name[64];
+
+		snprintf(name, sizeof(name), "sys_enter_%s", syscall_names[i]);
+		evsels[i] = perf_evsel__newtp("syscalls", name, i);
 		if (evsels[i] == NULL) {
 			pr_debug("perf_evsel__new\n");
 			goto out_free_evlist;
 		}
 
+		evsels[i]->attr.wakeup_events = 1;
+		evsels[i]->attr.read_format |= PERF_FORMAT_ID;
+		perf_evsel__set_sample_bit(evsels[i], ID);
+
 		perf_evlist__add(evlist, evsels[i]);
 
 		if (perf_evsel__open(evsels[i], cpus, threads) < 0) {
@@ -99,6 +81,9 @@ int test__basic_mmap(void)
 				 strerror(errno));
 			goto out_close_fd;
 		}
+
+		nr_events[i] = 0;
+		expected_nr_events[i] = 1 + rand() % 127;
 	}
 
 	if (perf_evlist__mmap(evlist, 128, true) < 0) {
diff --git a/tools/perf/tests/open-syscall-all-cpus.c b/tools/perf/tests/open-syscall-all-cpus.c
index 31072ab..9b920a0 100644
--- a/tools/perf/tests/open-syscall-all-cpus.c
+++ b/tools/perf/tests/open-syscall-all-cpus.c
@@ -7,20 +7,12 @@
 int test__open_syscall_event_on_all_cpus(void)
 {
 	int err = -1, fd, cpu;
-	struct thread_map *threads;
 	struct cpu_map *cpus;
 	struct perf_evsel *evsel;
-	struct perf_event_attr attr;
 	unsigned int nr_open_calls = 111, i;
 	cpu_set_t cpu_set;
-	int id = trace_event__id("sys_enter_open");
+	struct thread_map *threads = thread_map__new(-1, getpid(), UINT_MAX);
 
-	if (id < 0) {
-		pr_debug("is debugfs mounted on /sys/kernel/debug?\n");
-		return -1;
-	}
-
-	threads = thread_map__new(-1, getpid(), UINT_MAX);
 	if (threads == NULL) {
 		pr_debug("thread_map__new\n");
 		return -1;
@@ -32,15 +24,11 @@ int test__open_syscall_event_on_all_cpus(void)
 		goto out_thread_map_delete;
 	}
 
-
 	CPU_ZERO(&cpu_set);
 
-	memset(&attr, 0, sizeof(attr));
-	attr.type = PERF_TYPE_TRACEPOINT;
-	attr.config = id;
-	evsel = perf_evsel__new(&attr, 0);
+	evsel = perf_evsel__newtp("syscalls", "sys_enter_open", 0);
 	if (evsel == NULL) {
-		pr_debug("perf_evsel__new\n");
+		pr_debug("is debugfs mounted on /sys/kernel/debug?\n");
 		goto out_thread_map_delete;
 	}
 
diff --git a/tools/perf/tests/open-syscall.c b/tools/perf/tests/open-syscall.c
index 98be8b5..befc067 100644
--- a/tools/perf/tests/open-syscall.c
+++ b/tools/perf/tests/open-syscall.c
@@ -6,29 +6,18 @@
 int test__open_syscall_event(void)
 {
 	int err = -1, fd;
-	struct thread_map *threads;
 	struct perf_evsel *evsel;
-	struct perf_event_attr attr;
 	unsigned int nr_open_calls = 111, i;
-	int id = trace_event__id("sys_enter_open");
+	struct thread_map *threads = thread_map__new(-1, getpid(), UINT_MAX);
 
-	if (id < 0) {
-		pr_debug("is debugfs mounted on /sys/kernel/debug?\n");
-		return -1;
-	}
-
-	threads = thread_map__new(-1, getpid(), UINT_MAX);
 	if (threads == NULL) {
 		pr_debug("thread_map__new\n");
 		return -1;
 	}
 
-	memset(&attr, 0, sizeof(attr));
-	attr.type = PERF_TYPE_TRACEPOINT;
-	attr.config = id;
-	evsel = perf_evsel__new(&attr, 0);
+	evsel = perf_evsel__newtp("syscalls", "sys_enter_open", 0);
 	if (evsel == NULL) {
-		pr_debug("perf_evsel__new\n");
+		pr_debug("is debugfs mounted on /sys/kernel/debug?\n");
 		goto out_thread_map_delete;
 	}
 
diff --git a/tools/perf/tests/tests.h b/tools/perf/tests/tests.h
index fc121ed..0fd94657 100644
--- a/tools/perf/tests/tests.h
+++ b/tools/perf/tests/tests.h
@@ -16,7 +16,4 @@ int test__attr(void);
 int test__dso_data(void);
 int test__parse_events(void);
 
-/* Util */
-int trace_event__id(const char *evname);
-
 #endif /* TESTS_H */
diff --git a/tools/perf/tests/util.c b/tools/perf/tests/util.c
deleted file mode 100644
index 748f2e8..0000000
--- a/tools/perf/tests/util.c
+++ /dev/null
@@ -1,30 +0,0 @@
-#include <stdio.h>
-#include <unistd.h>
-#include <stdlib.h>
-#include <sys/types.h>
-#include <sys/stat.h>
-#include <fcntl.h>
-#include "tests.h"
-#include "debugfs.h"
-
-int trace_event__id(const char *evname)
-{
-	char *filename;
-	int err = -1, fd;
-
-	if (asprintf(&filename,
-		     "%s/syscalls/%s/id",
-		     tracing_events_path, evname) < 0)
-		return -1;
-
-	fd = open(filename, O_RDONLY);
-	if (fd >= 0) {
-		char id[16];
-		if (read(fd, id, sizeof(id)) > 0)
-			err = atoi(id);
-		close(fd);
-	}
-
-	free(filename);
-	return err;
-}
