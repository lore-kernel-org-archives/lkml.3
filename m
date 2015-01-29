Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753641AbbA2IKZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Jan 2015 03:10:25 -0500
Received: from LGEMRELSE6Q.lge.com ([156.147.1.121]:51302 "EHLO
	lgemrelse6q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753033AbbA2IKL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Jan 2015 03:10:11 -0500
X-Original-SENDERIP: 10.177.220.203
X-Original-MAILFROM: namhyung@kernel.org
From: Namhyung Kim <namhyung@kernel.org>
To: Arnaldo Carvalho de Melo <acme@kernel.org>
Cc: Ingo Molnar <mingo@kernel.org>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Jiri Olsa <jolsa@redhat.com>, LKML <linux-kernel@vger.kernel.org>,
        David Ahern <dsahern@gmail.com>,
        Adrian Hunter <adrian.hunter@intel.com>,
        Andi Kleen <andi@firstfloor.org>,
        Stephane Eranian <eranian@google.com>,
        Frederic Weisbecker <fweisbec@gmail.com>
Subject: [PATCH 19/42] perf tools: Add a test case for thread comm handling
Date: Thu, 29 Jan 2015 17:07:00 +0900
Message-Id: <1422518843-25818-20-git-send-email-namhyung@kernel.org>
X-Mailer: git-send-email 2.2.2
In-Reply-To: <1422518843-25818-1-git-send-email-namhyung@kernel.org>
References: <1422518843-25818-1-git-send-email-namhyung@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The new test case checks various thread comm handling like overridding
and time sorting.

Cc: Frederic Weisbecker <fweisbec@gmail.com>
Signed-off-by: Namhyung Kim <namhyung@kernel.org>
---
 tools/perf/Makefile.perf        |  1 +
 tools/perf/tests/builtin-test.c |  4 ++++
 tools/perf/tests/tests.h        |  1 +
 tools/perf/tests/thread-comm.c  | 47 +++++++++++++++++++++++++++++++++++++++++
 4 files changed, 53 insertions(+)
 create mode 100644 tools/perf/tests/thread-comm.c

diff --git a/tools/perf/Makefile.perf b/tools/perf/Makefile.perf
index aa6a50447c32..8507891db69d 100644
--- a/tools/perf/Makefile.perf
+++ b/tools/perf/Makefile.perf
@@ -458,6 +458,7 @@ endif
 LIB_OBJS += $(OUTPUT)tests/mmap-thread-lookup.o
 LIB_OBJS += $(OUTPUT)tests/thread-mg-share.o
 LIB_OBJS += $(OUTPUT)tests/switch-tracking.o
+LIB_OBJS += $(OUTPUT)tests/thread-comm.o
 
 BUILTIN_OBJS += $(OUTPUT)builtin-annotate.o
 BUILTIN_OBJS += $(OUTPUT)builtin-bench.o
diff --git a/tools/perf/tests/builtin-test.c b/tools/perf/tests/builtin-test.c
index 4b7d9ab0f049..1b463d82a71a 100644
--- a/tools/perf/tests/builtin-test.c
+++ b/tools/perf/tests/builtin-test.c
@@ -167,6 +167,10 @@ static struct test {
 		.func = test__fdarray__add,
 	},
 	{
+		.desc = "Test thread comm handling",
+		.func = test__thread_comm,
+	},
+	{
 		.func = NULL,
 	},
 };
diff --git a/tools/perf/tests/tests.h b/tools/perf/tests/tests.h
index 00e776a87a9c..43ac17780629 100644
--- a/tools/perf/tests/tests.h
+++ b/tools/perf/tests/tests.h
@@ -51,6 +51,7 @@ int test__hists_cumulate(void);
 int test__switch_tracking(void);
 int test__fdarray__filter(void);
 int test__fdarray__add(void);
+int test__thread_comm(void);
 
 #if defined(__x86_64__) || defined(__i386__) || defined(__arm__)
 #ifdef HAVE_DWARF_UNWIND_SUPPORT
diff --git a/tools/perf/tests/thread-comm.c b/tools/perf/tests/thread-comm.c
new file mode 100644
index 000000000000..44ee85d71581
--- /dev/null
+++ b/tools/perf/tests/thread-comm.c
@@ -0,0 +1,47 @@
+#include "tests.h"
+#include "machine.h"
+#include "thread.h"
+#include "debug.h"
+
+int test__thread_comm(void)
+{
+	struct machines machines;
+	struct machine *machine;
+	struct thread *t;
+
+	/*
+	 * This test is to check whether it can retrieve a correct
+	 * comm for a given time.  When multi-file data storage is
+	 * enabled, those task/comm events are processed first so the
+	 * later sample should find a matching comm properly.
+	 */
+	machines__init(&machines);
+	machine = &machines.host;
+
+	t = machine__findnew_thread(machine, 100, 100);
+	TEST_ASSERT_VAL("wrong init thread comm",
+			!strcmp(thread__comm_str(t), ":100"));
+
+	thread__set_comm(t, "perf-test1", 10000);
+	TEST_ASSERT_VAL("failed to override thread comm",
+			!strcmp(thread__comm_str(t), "perf-test1"));
+
+	thread__set_comm(t, "perf-test2", 20000);
+	thread__set_comm(t, "perf-test3", 30000);
+	thread__set_comm(t, "perf-test4", 40000);
+
+	TEST_ASSERT_VAL("failed to find timed comm",
+			!strcmp(thread__comm_str_time(t, 20000), "perf-test2"));
+	TEST_ASSERT_VAL("failed to find timed comm",
+			!strcmp(thread__comm_str_time(t, 35000), "perf-test3"));
+	TEST_ASSERT_VAL("failed to find timed comm",
+			!strcmp(thread__comm_str_time(t, 50000), "perf-test4"));
+
+	thread__set_comm(t, "perf-test1.5", 15000);
+	TEST_ASSERT_VAL("failed to sort timed comm",
+			!strcmp(thread__comm_str_time(t, 15000), "perf-test1.5"));
+
+	machine__delete_threads(machine);
+	machines__exit(&machines);
+	return 0;
+}
-- 
2.2.2

