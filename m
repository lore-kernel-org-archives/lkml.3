Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752053AbaLXHPA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Dec 2014 02:15:00 -0500
Received: from LGEMRELSE6Q.lge.com ([156.147.1.121]:39770 "EHLO
	lgemrelse6q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751464AbaLXHO6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Dec 2014 02:14:58 -0500
X-Original-SENDERIP: 10.177.222.235
X-Original-MAILFROM: namhyung@kernel.org
From: Namhyung Kim <namhyung@kernel.org>
To: Arnaldo Carvalho de Melo <acme@kernel.org>
Cc: Ingo Molnar <mingo@kernel.org>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Jiri Olsa <jolsa@redhat.com>, LKML <linux-kernel@vger.kernel.org>,
        David Ahern <dsahern@gmail.com>, Stephane Eranian <eranian@google.com>,
        Adrian Hunter <adrian.hunter@intel.com>,
        Andi Kleen <andi@firstfloor.org>,
        Frederic Weisbecker <fweisbec@gmail.com>
Subject: [PATCH 16/37] perf tools: Add a test case for timed thread handling
Date: Wed, 24 Dec 2014 16:15:12 +0900
Message-Id: <1419405333-27952-17-git-send-email-namhyung@kernel.org>
X-Mailer: git-send-email 2.1.3
In-Reply-To: <1419405333-27952-1-git-send-email-namhyung@kernel.org>
References: <1419405333-27952-1-git-send-email-namhyung@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

A test case for verifying live and dead thread tree management during
time change and new machine__find{,new}_thread_time().

Cc: Frederic Weisbecker <fweisbec@gmail.com>
Signed-off-by: Namhyung Kim <namhyung@kernel.org>
---
 tools/perf/Makefile.perf              |   1 +
 tools/perf/tests/builtin-test.c       |   4 +
 tools/perf/tests/tests.h              |   1 +
 tools/perf/tests/thread-lookup-time.c | 174 ++++++++++++++++++++++++++++++++++
 4 files changed, 180 insertions(+)
 create mode 100644 tools/perf/tests/thread-lookup-time.c

diff --git a/tools/perf/Makefile.perf b/tools/perf/Makefile.perf
index e4528a4a3a8c..6094f0a10d8b 100644
--- a/tools/perf/Makefile.perf
+++ b/tools/perf/Makefile.perf
@@ -448,6 +448,7 @@ LIB_OBJS += $(OUTPUT)tests/mmap-thread-lookup.o
 LIB_OBJS += $(OUTPUT)tests/thread-mg-share.o
 LIB_OBJS += $(OUTPUT)tests/switch-tracking.o
 LIB_OBJS += $(OUTPUT)tests/thread-comm.o
+LIB_OBJS += $(OUTPUT)tests/thread-lookup-time.o
 
 BUILTIN_OBJS += $(OUTPUT)builtin-annotate.o
 BUILTIN_OBJS += $(OUTPUT)builtin-bench.o
diff --git a/tools/perf/tests/builtin-test.c b/tools/perf/tests/builtin-test.c
index 1b463d82a71a..e4d335de19ea 100644
--- a/tools/perf/tests/builtin-test.c
+++ b/tools/perf/tests/builtin-test.c
@@ -171,6 +171,10 @@ static struct test {
 		.func = test__thread_comm,
 	},
 	{
+		.desc = "Test thread lookup with time",
+		.func = test__thread_lookup_time,
+	},
+	{
 		.func = NULL,
 	},
 };
diff --git a/tools/perf/tests/tests.h b/tools/perf/tests/tests.h
index 43ac17780629..1090337f63e5 100644
--- a/tools/perf/tests/tests.h
+++ b/tools/perf/tests/tests.h
@@ -52,6 +52,7 @@ int test__switch_tracking(void);
 int test__fdarray__filter(void);
 int test__fdarray__add(void);
 int test__thread_comm(void);
+int test__thread_lookup_time(void);
 
 #if defined(__x86_64__) || defined(__i386__) || defined(__arm__)
 #ifdef HAVE_DWARF_UNWIND_SUPPORT
diff --git a/tools/perf/tests/thread-lookup-time.c b/tools/perf/tests/thread-lookup-time.c
new file mode 100644
index 000000000000..6237ecf8caae
--- /dev/null
+++ b/tools/perf/tests/thread-lookup-time.c
@@ -0,0 +1,174 @@
+#include "tests.h"
+#include "machine.h"
+#include "thread.h"
+#include "map.h"
+#include "debug.h"
+
+static int thread__print_cb(struct thread *th, void *arg __maybe_unused)
+{
+	printf("thread: %d, start time: %"PRIu64" %s\n",
+	       th->tid, th->start_time, th->dead ? "(dead)" : "");
+	return 0;
+}
+
+static int lookup_with_timestamp(struct machine *machine)
+{
+	struct thread *t1, *t2, *t3;
+	union perf_event fork = {
+		.fork = {
+			.pid = 0,
+			.tid = 0,
+			.ppid = 1,
+			.ptid = 1,
+		},
+	};
+	struct perf_sample sample = {
+		.time = 50000,
+	};
+
+	/* start_time is set to 0 */
+	t1 = machine__findnew_thread(machine, 0, 0);
+
+	if (verbose > 1) {
+		printf("========= after t1 created ==========\n");
+		machine__for_each_thread(machine, thread__print_cb, NULL);
+	}
+
+	TEST_ASSERT_VAL("wrong start time of old thread", t1->start_time == 0);
+
+	TEST_ASSERT_VAL("cannot find current thread",
+			machine__find_thread(machine, 0, 0) == t1);
+
+	TEST_ASSERT_VAL("cannot find current thread with time",
+			machine__findnew_thread_time(machine, 0, 0, 10000) == t1);
+
+	/* start_time is overwritten to new value */
+	thread__set_comm(t1, "/usr/bin/perf", 20000);
+
+	if (verbose > 1) {
+		printf("========= after t1 set comm ==========\n");
+		machine__for_each_thread(machine, thread__print_cb, NULL);
+	}
+
+	TEST_ASSERT_VAL("failed to update start time", t1->start_time == 20000);
+
+	TEST_ASSERT_VAL("should not find passed thread",
+			/* this will create yet another dead thread */
+			machine__findnew_thread_time(machine, 0, 0, 10000) != t1);
+
+	TEST_ASSERT_VAL("cannot find overwritten thread with time",
+			machine__find_thread_time(machine, 0, 0, 20000) == t1);
+
+	/* now t1 goes to dead thread tree, and create t2 */
+	machine__process_fork_event(machine, &fork, &sample);
+
+	if (verbose > 1) {
+		printf("========= after t2 forked ==========\n");
+		machine__for_each_thread(machine, thread__print_cb, NULL);
+	}
+
+	t2 = machine__find_thread(machine, 0, 0);
+	TEST_ASSERT_VAL("cannot find current thread", t2 != NULL);
+
+	TEST_ASSERT_VAL("wrong start time of new thread", t2->start_time == 50000);
+
+	TEST_ASSERT_VAL("dead thread cannot be found",
+			machine__find_thread_time(machine, 0, 0, 10000) != t1);
+
+	TEST_ASSERT_VAL("cannot find dead thread after new thread",
+			machine__find_thread_time(machine, 0, 0, 30000) == t1);
+
+	TEST_ASSERT_VAL("cannot find current thread after new thread",
+			machine__find_thread_time(machine, 0, 0, 50000) == t2);
+
+	/* now t2 goes to dead thread tree, and create t3 */
+	sample.time = 60000;
+	machine__process_fork_event(machine, &fork, &sample);
+
+	if (verbose > 1) {
+		printf("========= after t3 forked ==========\n");
+		machine__for_each_thread(machine, thread__print_cb, NULL);
+	}
+
+	t3 = machine__find_thread(machine, 0, 0);
+	TEST_ASSERT_VAL("cannot find current thread", t3 != NULL);
+
+	TEST_ASSERT_VAL("wrong start time of new thread", t3->start_time == 60000);
+
+	TEST_ASSERT_VAL("cannot find dead thread after new thread",
+			machine__findnew_thread_time(machine, 0, 0, 30000) == t1);
+
+	TEST_ASSERT_VAL("cannot find dead thread after new thread",
+			machine__findnew_thread_time(machine, 0, 0, 50000) == t2);
+
+	TEST_ASSERT_VAL("cannot find current thread after new thread",
+			machine__findnew_thread_time(machine, 0, 0, 70000) == t3);
+
+	machine__delete_threads(machine);
+	return 0;
+}
+
+static int lookup_without_timestamp(struct machine *machine)
+{
+	struct thread *t1, *t2, *t3;
+	union perf_event fork = {
+		.fork = {
+			.pid = 0,
+			.tid = 0,
+			.ppid = 1,
+			.ptid = 1,
+		},
+	};
+	struct perf_sample sample = {
+		.time = -1ULL,
+	};
+
+	t1 = machine__findnew_thread(machine, 0, 0);
+	TEST_ASSERT_VAL("cannot find current thread", t1 != NULL);
+
+	TEST_ASSERT_VAL("cannot find new thread with time",
+			machine__findnew_thread_time(machine, 0, 0, -1ULL) == t1);
+
+	machine__process_fork_event(machine, &fork, &sample);
+
+	t2 = machine__find_thread(machine, 0, 0);
+	TEST_ASSERT_VAL("cannot find current thread", t2 != NULL);
+
+	TEST_ASSERT_VAL("cannot find new thread with time",
+			machine__find_thread_time(machine, 0, 0, -1ULL) == t2);
+
+	machine__process_fork_event(machine, &fork, &sample);
+
+	t3 = machine__find_thread(machine, 0, 0);
+	TEST_ASSERT_VAL("cannot find current thread", t3 != NULL);
+
+	TEST_ASSERT_VAL("cannot find new thread with time",
+			machine__findnew_thread_time(machine, 0, 0, -1ULL) == t3);
+
+	machine__delete_threads(machine);
+	return 0;
+}
+
+int test__thread_lookup_time(void)
+{
+	struct machines machines;
+	struct machine *machine;
+
+	/*
+	 * This test is to check whether it can retrieve a correct
+	 * thread for a given time.  When multi-file data storage is
+	 * enabled, those task/comm/mmap events are processed first so
+	 * the later sample should find a matching thread properly.
+	 */
+	machines__init(&machines);
+	machine = &machines.host;
+
+	if (lookup_with_timestamp(machine) < 0)
+		return -1;
+
+	if (lookup_without_timestamp(machine) < 0)
+		return -1;
+
+	machines__exit(&machines);
+	return 0;
+}
-- 
2.1.3

