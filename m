Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752835AbaFXIUu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jun 2014 04:20:50 -0400
Received: from mx1.redhat.com ([209.132.183.28]:24908 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752792AbaFXIUr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jun 2014 04:20:47 -0400
From: Jiri Olsa <jolsa@kernel.org>
To: linux-kernel@vger.kernel.org
Cc: Jiri Olsa <jolsa@kernel.org>, Arnaldo Carvalho de Melo <acme@kernel.org>,
        Corey Ashford <cjashfor@linux.vnet.ibm.com>,
        David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@kernel.org>, Namhyung Kim <namhyung@kernel.org>,
        Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: [PATCH 3/3] perf tests: Add test to hit wrong event sched out
Date: Tue, 24 Jun 2014 10:20:26 +0200
Message-Id: <1403598026-2310-3-git-send-email-jolsa@kernel.org>
In-Reply-To: <1403598026-2310-1-git-send-email-jolsa@kernel.org>
References: <1403598026-2310-1-git-send-email-jolsa@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We create single breakpoint event with inherit = true and
create many workload children.

With some luck (which is directly proportional to number of
children) we hit event optimized sched out moving original
(parent) event into one of the child, closing it and causing
wrong measured numbers.

Cc: Arnaldo Carvalho de Melo <acme@kernel.org>
Cc: Corey Ashford <cjashfor@linux.vnet.ibm.com>
Cc: David Ahern <dsahern@gmail.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Signed-off-by: Jiri Olsa <jolsa@kernel.org>
---
 tools/perf/Makefile.perf               |  1 +
 tools/perf/tests/builtin-test.c        |  4 ++
 tools/perf/tests/optimized-sched-out.c | 90 ++++++++++++++++++++++++++++++++++
 tools/perf/tests/tests.h               |  1 +
 4 files changed, 96 insertions(+)
 create mode 100644 tools/perf/tests/optimized-sched-out.c

diff --git a/tools/perf/Makefile.perf b/tools/perf/Makefile.perf
index 9670a16..29ff74e 100644
--- a/tools/perf/Makefile.perf
+++ b/tools/perf/Makefile.perf
@@ -419,6 +419,7 @@ endif
 endif
 LIB_OBJS += $(OUTPUT)tests/mmap-thread-lookup.o
 LIB_OBJS += $(OUTPUT)tests/thread-mg-share.o
+LIB_OBJS += $(OUTPUT)tests/optimized-sched-out.o
 
 BUILTIN_OBJS += $(OUTPUT)builtin-annotate.o
 BUILTIN_OBJS += $(OUTPUT)builtin-bench.o
diff --git a/tools/perf/tests/builtin-test.c b/tools/perf/tests/builtin-test.c
index 6f8b01b..754dc2a 100644
--- a/tools/perf/tests/builtin-test.c
+++ b/tools/perf/tests/builtin-test.c
@@ -154,6 +154,10 @@ static struct test {
 		.func = test__hists_cumulate,
 	},
 	{
+		.desc = "Test optimized event schedule out",
+		.func = test__optimized_sched_out,
+	},
+	{
 		.func = NULL,
 	},
 };
diff --git a/tools/perf/tests/optimized-sched-out.c b/tools/perf/tests/optimized-sched-out.c
new file mode 100644
index 0000000..dfbb1b9
--- /dev/null
+++ b/tools/perf/tests/optimized-sched-out.c
@@ -0,0 +1,90 @@
+#include <linux/perf_event.h>
+#include <linux/hw_breakpoint.h>
+#include <string.h>
+#include <unistd.h>
+#include "tests.h"
+#include "perf.h"
+#include "debug.h"
+
+static void __attribute__ ((noinline)) bp_func(void)
+{
+	asm("" : : : "memory");
+}
+
+static int bp_event(void *fn)
+{
+	struct perf_event_attr pe;
+	int fd;
+
+	memset(&pe, 0, sizeof(struct perf_event_attr));
+	pe.type = PERF_TYPE_BREAKPOINT;
+	pe.size = sizeof(struct perf_event_attr);
+
+	pe.config = 0;
+	pe.bp_type = HW_BREAKPOINT_X;
+	pe.bp_addr = (unsigned long) fn;
+	pe.bp_len = sizeof(long);
+
+	pe.read_format = PERF_FORMAT_ID;
+	pe.inherit = 1;
+	pe.exclude_kernel = 1;
+	pe.exclude_hv = 1;
+	pe.disabled = 1;
+
+	fd = sys_perf_event_open(&pe, 0, -1, -1, 0);
+	if (fd < 0) {
+		pr_debug("failed opening event %llx\n", pe.config);
+		return TEST_FAIL;
+	}
+
+	return fd;
+}
+
+#define CHILDREN 100
+
+int test__optimized_sched_out(void)
+{
+	struct read_data_t {
+		__u64 val;
+		__u64 id;
+	} read_data = { 0 };
+	int fd, err, i;
+	__u64 id;
+
+	fd = bp_event(bp_func);
+	TEST_ASSERT_VAL("create event", fd >= 0);
+
+	err = ioctl(fd, PERF_EVENT_IOC_ID, &id);
+	TEST_ASSERT_VAL("id event", !err);
+
+	err = ioctl(fd, PERF_EVENT_IOC_ENABLE, 0);
+	TEST_ASSERT_VAL("enable event", !err);
+
+	for (i = 0; i < CHILDREN; i++) {
+		err = fork();
+		TEST_ASSERT_VAL("failed to fork", err != -1);
+		if (!err) {
+			pr_debug("child %d created\n", getpid());
+			bp_func();
+			exit(0);
+		}
+	}
+
+	while (wait(&err) > 0)
+		;
+
+	bp_func();
+
+	/* read */
+	err = read(fd, &read_data, sizeof(read_data));
+	TEST_ASSERT_VAL("read values", sizeof(read_data) == err);
+	TEST_ASSERT_VAL("event id", read_data.id  == id);
+
+	pr_debug("read_data.val %llu, expected %u\n",
+		  read_data.val, CHILDREN + 1);
+
+	TEST_ASSERT_VAL("event count", read_data.val == CHILDREN + 1);
+
+	close(fd);
+	return 0;
+}
diff --git a/tools/perf/tests/tests.h b/tools/perf/tests/tests.h
index ed64790..a62d58d 100644
--- a/tools/perf/tests/tests.h
+++ b/tools/perf/tests/tests.h
@@ -48,6 +48,7 @@ int test__mmap_thread_lookup(void);
 int test__thread_mg_share(void);
 int test__hists_output(void);
 int test__hists_cumulate(void);
+int test__optimized_sched_out(void);
 
 #if defined(__x86_64__) || defined(__i386__) || defined(__arm__)
 #ifdef HAVE_DWARF_UNWIND_SUPPORT
-- 
1.8.3.1

