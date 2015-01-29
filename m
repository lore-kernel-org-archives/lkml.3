Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754254AbbA2IP6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Jan 2015 03:15:58 -0500
Received: from LGEMRELSE6Q.lge.com ([156.147.1.121]:51451 "EHLO
	lgemrelse6q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753242AbbA2IKP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Jan 2015 03:10:15 -0500
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
Subject: [PATCH 26/42] perf tools: Add a test case for timed map groups handling
Date: Thu, 29 Jan 2015 17:07:07 +0900
Message-Id: <1422518843-25818-27-git-send-email-namhyung@kernel.org>
X-Mailer: git-send-email 2.2.2
In-Reply-To: <1422518843-25818-1-git-send-email-namhyung@kernel.org>
References: <1422518843-25818-1-git-send-email-namhyung@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

A test case for verifying thread->mg and ->mg_list handling during
time change and new thread__find_addr_map_time() and friends.

Cc: Frederic Weisbecker <fweisbec@gmail.com>
Signed-off-by: Namhyung Kim <namhyung@kernel.org>
---
 tools/perf/Makefile.perf          |  1 +
 tools/perf/tests/builtin-test.c   |  4 ++
 tools/perf/tests/tests.h          |  1 +
 tools/perf/tests/thread-mg-time.c | 88 +++++++++++++++++++++++++++++++++++++++
 4 files changed, 94 insertions(+)
 create mode 100644 tools/perf/tests/thread-mg-time.c

diff --git a/tools/perf/Makefile.perf b/tools/perf/Makefile.perf
index 8bb35ee91fd5..2f8c8b918cac 100644
--- a/tools/perf/Makefile.perf
+++ b/tools/perf/Makefile.perf
@@ -460,6 +460,7 @@ LIB_OBJS += $(OUTPUT)tests/thread-mg-share.o
 LIB_OBJS += $(OUTPUT)tests/switch-tracking.o
 LIB_OBJS += $(OUTPUT)tests/thread-comm.o
 LIB_OBJS += $(OUTPUT)tests/thread-lookup-time.o
+LIB_OBJS += $(OUTPUT)tests/thread-mg-time.o
 
 BUILTIN_OBJS += $(OUTPUT)builtin-annotate.o
 BUILTIN_OBJS += $(OUTPUT)builtin-bench.o
diff --git a/tools/perf/tests/builtin-test.c b/tools/perf/tests/builtin-test.c
index e4d335de19ea..8f61a7e291ee 100644
--- a/tools/perf/tests/builtin-test.c
+++ b/tools/perf/tests/builtin-test.c
@@ -175,6 +175,10 @@ static struct test {
 		.func = test__thread_lookup_time,
 	},
 	{
+		.desc = "Test thread map group handling with time",
+		.func = test__thread_mg_time,
+	},
+	{
 		.func = NULL,
 	},
 };
diff --git a/tools/perf/tests/tests.h b/tools/perf/tests/tests.h
index 1090337f63e5..03557563f31d 100644
--- a/tools/perf/tests/tests.h
+++ b/tools/perf/tests/tests.h
@@ -53,6 +53,7 @@ int test__fdarray__filter(void);
 int test__fdarray__add(void);
 int test__thread_comm(void);
 int test__thread_lookup_time(void);
+int test__thread_mg_time(void);
 
 #if defined(__x86_64__) || defined(__i386__) || defined(__arm__)
 #ifdef HAVE_DWARF_UNWIND_SUPPORT
diff --git a/tools/perf/tests/thread-mg-time.c b/tools/perf/tests/thread-mg-time.c
new file mode 100644
index 000000000000..69fd13752c1d
--- /dev/null
+++ b/tools/perf/tests/thread-mg-time.c
@@ -0,0 +1,88 @@
+#include "tests.h"
+#include "machine.h"
+#include "thread.h"
+#include "map.h"
+#include "debug.h"
+
+#define PERF_MAP_START  0x40000
+
+int test__thread_mg_time(void)
+{
+	struct machines machines;
+	struct machine *machine;
+	struct thread *t;
+	struct map_groups *mg;
+	struct map *map;
+	struct addr_location al = { .map = NULL, };
+
+	/*
+	 * This test is to check whether it can retrieve a correct map
+	 * for a given time.  When multi-file data storage is enabled,
+	 * those task/comm/mmap events are processed first so the
+	 * later sample should find a matching comm properly.
+	 */
+	machines__init(&machines);
+	machine = &machines.host;
+
+	t = machine__findnew_thread(machine, 0, 0);
+	mg = t->mg;
+
+	map = dso__new_map("/usr/bin/perf");
+	map->start = PERF_MAP_START;
+	map->end = PERF_MAP_START + 0x1000;
+
+	thread__insert_map(t, map);
+
+	if (verbose > 1)
+		map_groups__fprintf(t->mg, stderr);
+
+	thread__find_addr_map(t, PERF_RECORD_MISC_USER, MAP__FUNCTION,
+			      PERF_MAP_START, &al);
+
+	TEST_ASSERT_VAL("cannot find mapping for perf", al.map != NULL);
+	TEST_ASSERT_VAL("non matched mapping found", al.map == map);
+	TEST_ASSERT_VAL("incorrect map groups", al.map->groups == mg);
+	TEST_ASSERT_VAL("incorrect map groups", al.map->groups == t->mg);
+
+	thread__find_addr_map_time(t, PERF_RECORD_MISC_USER,
+				   MAP__FUNCTION, PERF_MAP_START, &al, -1ULL);
+
+	TEST_ASSERT_VAL("cannot find timed mapping for perf", al.map != NULL);
+	TEST_ASSERT_VAL("non matched timed mapping", al.map == map);
+	TEST_ASSERT_VAL("incorrect timed map groups", al.map->groups == mg);
+	TEST_ASSERT_VAL("incorrect map groups", al.map->groups == t->mg);
+
+
+	pr_debug("simulate EXEC event (generate new mg)\n");
+	__thread__set_comm(t, "perf-test", 10000, true);
+
+	map = dso__new_map("/usr/bin/perf-test");
+	map->start = PERF_MAP_START;
+	map->end = PERF_MAP_START + 0x2000;
+
+	thread__insert_map(t, map);
+
+	if (verbose > 1)
+		map_groups__fprintf(t->mg, stderr);
+
+	thread__find_addr_map(t, PERF_RECORD_MISC_USER, MAP__FUNCTION,
+			      PERF_MAP_START + 4, &al);
+
+	TEST_ASSERT_VAL("cannot find mapping for perf-test", al.map != NULL);
+	TEST_ASSERT_VAL("invalid mapping found", al.map == map);
+	TEST_ASSERT_VAL("incorrect map groups", al.map->groups != mg);
+	TEST_ASSERT_VAL("incorrect map groups", al.map->groups == t->mg);
+
+	pr_debug("searching map in the old mag groups\n");
+	thread__find_addr_map_time(t, PERF_RECORD_MISC_USER,
+				   MAP__FUNCTION, PERF_MAP_START, &al, 5000);
+
+	TEST_ASSERT_VAL("cannot find timed mapping for perf-test", al.map != NULL);
+	TEST_ASSERT_VAL("non matched timed mapping", al.map != map);
+	TEST_ASSERT_VAL("incorrect timed map groups", al.map->groups == mg);
+	TEST_ASSERT_VAL("incorrect map groups", al.map->groups != t->mg);
+
+	machine__delete_threads(machine);
+	machines__exit(&machines);
+	return 0;
+}
-- 
2.2.2

