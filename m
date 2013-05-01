Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761416Ab3EAPRA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 May 2013 11:17:00 -0400
Received: from mx1.redhat.com ([209.132.183.28]:18669 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761446Ab3EAPQs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 May 2013 11:16:48 -0400
From: Jiri Olsa <jolsa@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: Jiri Olsa <jolsa@redhat.com>, Arnaldo Carvalho de Melo <acme@redhat.com>,
        Namhyung Kim <namhyung@kernel.org>,
        Corey Ashford <cjashfor@linux.vnet.ibm.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@elte.hu>,
        Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Andi Kleen <andi@firstfloor.org>, David Ahern <dsahern@gmail.com>,
        Ulrich Drepper <drepper@gmail.com>, Will Deacon <will.deacon@arm.com>,
        Stephane Eranian <eranian@google.com>
Subject: [PATCH 6/8] perf tests: Add automated tests for formula object
Date: Wed,  1 May 2013 17:15:44 +0200
Message-Id: <1367421346-18257-7-git-send-email-jolsa@redhat.com>
In-Reply-To: <1367421346-18257-1-git-send-email-jolsa@redhat.com>
References: <1367421346-18257-1-git-send-email-jolsa@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Adding automated tests to test basic formula
object definitions and interface.

Signed-off-by: Jiri Olsa <jolsa@redhat.com>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Corey Ashford <cjashfor@linux.vnet.ibm.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Andi Kleen <andi@firstfloor.org>
Cc: David Ahern <dsahern@gmail.com>
Cc: Ulrich Drepper <drepper@gmail.com>
Cc: Will Deacon <will.deacon@arm.com>
Cc: Stephane Eranian <eranian@google.com>
---
 tools/perf/Makefile             |   1 +
 tools/perf/tests/builtin-test.c |   4 +
 tools/perf/tests/formula.c      | 183 ++++++++++++++++++++++++++++++++++++++++
 tools/perf/tests/parse-events.c |   8 --
 tools/perf/tests/tests.h        |  10 +++
 5 files changed, 198 insertions(+), 8 deletions(-)
 create mode 100644 tools/perf/tests/formula.c

diff --git a/tools/perf/Makefile b/tools/perf/Makefile
index c35bb7f..aac10d0 100644
--- a/tools/perf/Makefile
+++ b/tools/perf/Makefile
@@ -532,6 +532,7 @@ LIB_OBJS += $(OUTPUT)tests/bp_signal.o
 LIB_OBJS += $(OUTPUT)tests/bp_signal_overflow.o
 LIB_OBJS += $(OUTPUT)tests/task-exit.o
 LIB_OBJS += $(OUTPUT)tests/sw-clock.o
+LIB_OBJS += $(OUTPUT)tests/formula.o
 
 BUILTIN_OBJS += $(OUTPUT)builtin-annotate.o
 BUILTIN_OBJS += $(OUTPUT)builtin-bench.o
diff --git a/tools/perf/tests/builtin-test.c b/tools/perf/tests/builtin-test.c
index 0918ada..8c48adf 100644
--- a/tools/perf/tests/builtin-test.c
+++ b/tools/perf/tests/builtin-test.c
@@ -94,6 +94,10 @@ static struct test {
 		.func = test__sw_clock_freq,
 	},
 	{
+		.desc = "Test formula interface",
+		.func = test__formula,
+	},
+	{
 		.func = NULL,
 	},
 };
diff --git a/tools/perf/tests/formula.c b/tools/perf/tests/formula.c
new file mode 100644
index 0000000..db2e71c
--- /dev/null
+++ b/tools/perf/tests/formula.c
@@ -0,0 +1,183 @@
+
+#include <linux/kernel.h>
+#include <linux/compiler.h>
+#include <stdlib.h>
+#include <unistd.h>
+#include "tests.h"
+#include "formula.h"
+#include "evlist.h"
+#include "evsel.h"
+
+static void file_put(const char *file)
+{
+	unlink(file);
+}
+
+static char *file_get(const char *data, size_t size)
+{
+	char file[] = "/tmp/perf-tests-formula-XXXXXX";
+	bool failed = false;
+	int fd;
+
+	fd = mkstemp(file);
+	if (fd < 0) {
+		pr_debug("failed to create temp file\n");
+		return NULL;
+	}
+
+	if (size != (size_t) write(fd, data, size))
+		failed = true;
+
+	close(fd);
+
+	if (failed)
+		file_put(file);
+
+	return failed ? NULL : file;
+}
+
+static int __test_basics(char *file)
+{
+	struct perf_formula fml;
+	struct perf_formula_set *set;
+	struct perf_formula_counter *counter;
+	struct perf_evlist *evlist;
+	struct perf_evsel *evsel;
+	struct perf_counts *counts;
+	struct perf_formula_expr expr;
+	int ret;
+
+	pr_debug("file %s\n", file);
+
+	perf_formula__init(&fml);
+
+	ret = perf_formula__load(&fml, file);
+	TEST_ASSERT_VAL("failed to load formula", !ret);
+
+	set = perf_formula__set(&fml, (char *) "set");
+	TEST_ASSERT_VAL("failed to load set", set);
+	TEST_ASSERT_VAL("wrong set name", !strcmp(set->name, "set"));
+
+	evlist = perf_evlist__new();
+	TEST_ASSERT_VAL("failed to create evlist", evlist);
+
+	ret = perf_formula__evlist(&fml, set, evlist);
+	TEST_ASSERT_VAL("failed to load evlist with set", !ret);
+
+	evsel = perf_evlist__first(evlist);
+	TEST_ASSERT_VAL("wrong type", PERF_TYPE_HARDWARE == evsel->attr.type);
+	TEST_ASSERT_VAL("wrong config",
+		PERF_COUNT_HW_CPU_CYCLES == evsel->attr.config);
+	TEST_ASSERT_VAL("wrong exclude_user", !evsel->attr.exclude_user);
+	TEST_ASSERT_VAL("wrong exclude_kernel", evsel->attr.exclude_kernel);
+	TEST_ASSERT_VAL("wrong exclude_hv", evsel->attr.exclude_hv);
+	TEST_ASSERT_VAL("wrong exclude guest", !evsel->attr.exclude_guest);
+	TEST_ASSERT_VAL("wrong exclude host", !evsel->attr.exclude_host);
+	TEST_ASSERT_VAL("wrong precise_ip", !evsel->attr.precise_ip);
+
+	ret = perf_evsel__alloc_counts(evsel, 1);
+	TEST_ASSERT_VAL("failed to alloc coiunts for evsel", !ret);
+
+	counts = evsel->counts;
+	counts->aggr.val = 1000;
+
+	evsel = perf_evsel__next(evsel);
+	TEST_ASSERT_VAL("wrong type", PERF_TYPE_HARDWARE == evsel->attr.type);
+	TEST_ASSERT_VAL("wrong config",
+		PERF_COUNT_HW_INSTRUCTIONS == evsel->attr.config);
+	TEST_ASSERT_VAL("wrong exclude_user", !evsel->attr.exclude_user);
+	TEST_ASSERT_VAL("wrong exclude_kernel", evsel->attr.exclude_kernel);
+	TEST_ASSERT_VAL("wrong exclude_hv", evsel->attr.exclude_hv);
+	TEST_ASSERT_VAL("wrong exclude guest", !evsel->attr.exclude_guest);
+	TEST_ASSERT_VAL("wrong exclude host", !evsel->attr.exclude_host);
+	TEST_ASSERT_VAL("wrong precise_ip", !evsel->attr.precise_ip);
+
+	ret = perf_evsel__alloc_counts(evsel, 1);
+	TEST_ASSERT_VAL("failed to alloc coiunts for evsel", !ret);
+
+	counts = evsel->counts;
+	counts->aggr.val = 500;
+
+	memset(&expr, 0x0, sizeof(expr));
+	expr.set    = set;
+	expr.evlist = evlist;
+
+	perf_formula__eval(&fml, set, &expr);
+
+	counter = list_first_entry(&set->head_counters,
+				   struct perf_formula_counter,
+				   list);
+	TEST_ASSERT_VAL("failed to calculated the counter", !ret);
+	TEST_ASSERT_VAL("wrong counter final value", counter->result == 4.5);
+
+	counter = list_entry(counter->list.next,
+			     struct perf_formula_counter,
+			     list);
+	TEST_ASSERT_VAL("failed to calculated the counter", !ret);
+	TEST_ASSERT_VAL("wrong counter final value", counter->result == 2);
+
+	perf_formula__free(&fml);
+	return 0;
+}
+
+static int test_basics(void)
+{
+	int ret;
+	char *file;
+	char data[] =
+"							\n\
+set {							\n\
+	events {					\n\
+		CY = cycles:u				\n\
+		IN = instructions:u			\n\
+	}						\n\
+							\n\
+	t   = -IN / 1000 + 5				\n\
+	cpi = CY / -((t - 5) * 1000)			\n\
+							\n\
+	print cpi					\n\
+}							\n\
+";
+
+	file = file_get(data, sizeof(data));
+	TEST_ASSERT_VAL("failed to get data file", file);
+
+	ret = __test_basics(file);
+
+	file_put(file);
+	return ret;
+}
+
+typedef int (*fn_t)(void);
+
+struct formula_test {
+	const char *desc;
+	fn_t fn;
+} tests[] = {
+	{
+		.desc	= "basics",
+		.fn	= test_basics,
+	},
+	{
+		.desc	= NULL,
+		.fn	= NULL,
+	},
+};
+
+
+int test__formula(void)
+{
+	struct formula_test *t = &tests[0];
+	int ret = 0;
+
+	while (t->desc) {
+		pr_debug("test: %s\n", t->desc);
+
+		if (t->fn())
+			ret = -1;
+
+		t++;
+	}
+
+	return ret;
+}
diff --git a/tools/perf/tests/parse-events.c b/tools/perf/tests/parse-events.c
index 88e2f44..91a0004 100644
--- a/tools/perf/tests/parse-events.c
+++ b/tools/perf/tests/parse-events.c
@@ -7,14 +7,6 @@
 #include "tests.h"
 #include <linux/hw_breakpoint.h>
 
-#define TEST_ASSERT_VAL(text, cond) \
-do { \
-	if (!(cond)) { \
-		pr_debug("FAILED %s:%d %s\n", __FILE__, __LINE__, text); \
-		return -1; \
-	} \
-} while (0)
-
 #define PERF_TP_SAMPLE_TYPE (PERF_SAMPLE_RAW | PERF_SAMPLE_TIME | \
 			     PERF_SAMPLE_CPU | PERF_SAMPLE_PERIOD)
 
diff --git a/tools/perf/tests/tests.h b/tools/perf/tests/tests.h
index dd7feae..c3e3cea 100644
--- a/tools/perf/tests/tests.h
+++ b/tools/perf/tests/tests.h
@@ -7,6 +7,15 @@ enum {
 	TEST_SKIP = -2,
 };
 
+#define TEST_ASSERT_VAL(text, cond) \
+do { \
+	if (!(cond)) { \
+		pr_debug("FAILED %s:%d %s\n", __FILE__, __LINE__, text); \
+		return -1; \
+	} \
+} while (0)
+
+
 /* Tests */
 int test__vmlinux_matches_kallsyms(void);
 int test__open_syscall_event(void);
@@ -27,5 +36,6 @@ int test__bp_signal(void);
 int test__bp_signal_overflow(void);
 int test__task_exit(void);
 int test__sw_clock_freq(void);
+int test__formula(void);
 
 #endif /* TESTS_H */
-- 
1.7.11.7

