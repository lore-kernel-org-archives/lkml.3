Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753343Ab3CJSmA (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Mar 2013 14:42:00 -0400
Received: from mx1.redhat.com ([209.132.183.28]:59610 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752836Ab3CJSl5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Mar 2013 14:41:57 -0400
From: Jiri Olsa <jolsa@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: Jiri Olsa <jolsa@redhat.com>, Thomas Gleixner <tglx@linutronix.de>,
        "H. Peter Anvin" <hpa@zytor.com>, Andi Kleen <andi@firstfloor.org>,
        Oleg Nesterov <oleg@redhat.com>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>, Ingo Molnar <mingo@elte.hu>,
        Paul Mackerras <paulus@samba.org>,
        Corey Ashford <cjashfor@linux.vnet.ibm.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Vince Weaver <vincent.weaver@maine.edu>,
        Stephane Eranian <eranian@google.com>
Subject: [PATCH 6/6] perf tests: Test breakpoint overflow signal handler counts
Date: Sun, 10 Mar 2013 19:41:11 +0100
Message-Id: <1362940871-24486-7-git-send-email-jolsa@redhat.com>
In-Reply-To: <1362940871-24486-1-git-send-email-jolsa@redhat.com>
References: <1362940871-24486-1-git-send-email-jolsa@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Adding automated test to check the exact number of
breakpoint event overflows and counts.

This test was originally done by Vince Weaver for
perf_event_tests.

Signed-off-by: Jiri Olsa <jolsa@redhat.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: H. Peter Anvin <hpa@zytor.com>
Cc: Andi Kleen <andi@firstfloor.org>
Cc: Oleg Nesterov <oleg@redhat.com>
Cc: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Corey Ashford <cjashfor@linux.vnet.ibm.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Vince Weaver <vincent.weaver@maine.edu>
Cc: Stephane Eranian <eranian@google.com>
---
 tools/perf/Makefile                   |   1 +
 tools/perf/tests/bp_signal_overflow.c | 126 ++++++++++++++++++++++++++++++++++
 tools/perf/tests/builtin-test.c       |   4 ++
 tools/perf/tests/tests.h              |   1 +
 4 files changed, 132 insertions(+)
 create mode 100644 tools/perf/tests/bp_signal_overflow.c

diff --git a/tools/perf/Makefile b/tools/perf/Makefile
index bea66fe..34a63ce 100644
--- a/tools/perf/Makefile
+++ b/tools/perf/Makefile
@@ -498,6 +498,7 @@ LIB_OBJS += $(OUTPUT)tests/pmu.o
 LIB_OBJS += $(OUTPUT)tests/hists_link.o
 LIB_OBJS += $(OUTPUT)tests/python-use.o
 LIB_OBJS += $(OUTPUT)tests/bp_signal.o
+LIB_OBJS += $(OUTPUT)tests/bp_signal_overflow.o
 
 BUILTIN_OBJS += $(OUTPUT)builtin-annotate.o
 BUILTIN_OBJS += $(OUTPUT)builtin-bench.o
diff --git a/tools/perf/tests/bp_signal_overflow.c b/tools/perf/tests/bp_signal_overflow.c
new file mode 100644
index 0000000..556d2ce
--- /dev/null
+++ b/tools/perf/tests/bp_signal_overflow.c
@@ -0,0 +1,126 @@
+/*
+ * Originally done by Vince Weaver <vincent.weaver@maine.edu> for
+ * perf_event_tests (git://github.com/deater/perf_event_tests)
+ */
+
+#include <stdlib.h>
+#include <stdio.h>
+#include <unistd.h>
+#include <string.h>
+#include <sys/ioctl.h>
+#include <time.h>
+#include <fcntl.h>
+#include <signal.h>
+#include <sys/mman.h>
+#include <linux/compiler.h>
+#include <linux/hw_breakpoint.h>
+
+#include "tests.h"
+#include "debug.h"
+#include "perf.h"
+
+static int overflows;
+
+__attribute__ ((noinline))
+static int test_function(void)
+{
+	return time(NULL);
+}
+
+static void sig_handler(int signum __maybe_unused,
+			siginfo_t *oh __maybe_unused,
+			void *uc __maybe_unused)
+{
+	overflows++;
+}
+
+static long long bp_count(int fd)
+{
+	long long count;
+	int ret;
+
+	ret = read(fd, &count, sizeof(long long));
+	if (ret != sizeof(long long)) {
+		pr_err("failed to read: %d\n", ret);
+		return TEST_FAIL;
+	}
+
+	return count;
+}
+
+#define EXECUTIONS 10000
+#define THRESHOLD  100
+
+int test__bp_signal_overflow(void)
+{
+	struct perf_event_attr pe;
+	struct sigaction sa;
+	long long count;
+	int fd, i, fails = 0;
+
+	/* setup SIGIO signal handler */
+	memset(&sa, 0, sizeof(struct sigaction));
+	sa.sa_sigaction = (void *) sig_handler;
+	sa.sa_flags = SA_SIGINFO;
+
+	if (sigaction(SIGIO, &sa, NULL) < 0) {
+		pr_err("failed setting up signal handler\n");
+		return TEST_FAIL;
+	}
+
+	memset(&pe, 0, sizeof(struct perf_event_attr));
+	pe.type = PERF_TYPE_BREAKPOINT;
+	pe.size = sizeof(struct perf_event_attr);
+
+	pe.config = 0;
+	pe.bp_type = HW_BREAKPOINT_X;
+	pe.bp_addr = (unsigned long) test_function;
+	pe.bp_len = sizeof(long);
+
+	pe.sample_period = THRESHOLD;
+	pe.sample_type = PERF_SAMPLE_IP;
+	pe.wakeup_events = 1;
+
+	pe.disabled = 1;
+	pe.exclude_kernel = 1;
+	pe.exclude_hv = 1;
+
+	fd = sys_perf_event_open(&pe, 0, -1, -1, 0);
+	if (fd < 0) {
+		pr_err("failed opening event %llx\n", pe.config);
+		return TEST_FAIL;
+	}
+
+	fcntl(fd, F_SETFL, O_RDWR|O_NONBLOCK|O_ASYNC);
+	fcntl(fd, F_SETSIG, SIGIO);
+	fcntl(fd, F_SETOWN, getpid());
+
+	ioctl(fd, PERF_EVENT_IOC_RESET, 0);
+	ioctl(fd, PERF_EVENT_IOC_ENABLE, 0);
+
+	for (i = 0; i < EXECUTIONS; i++)
+		test_function();
+
+	ioctl(fd, PERF_EVENT_IOC_DISABLE, 0);
+
+	count = bp_count(fd);
+
+	close(fd);
+
+	pr_debug("count %lld, overflow %d\n",
+		 count, overflows);
+
+	if (count != EXECUTIONS) {
+		pr_err("\tWrong number of executions %lld != %d\n",
+		count, EXECUTIONS);
+		fails++;
+	}
+
+	if (overflows != EXECUTIONS / THRESHOLD) {
+		pr_err("\tWrong number of overflows %d != %d\n",
+		overflows, EXECUTIONS / THRESHOLD);
+		fails++;
+	}
+
+	return fails ? TEST_FAIL : TEST_OK;
+}
diff --git a/tools/perf/tests/builtin-test.c b/tools/perf/tests/builtin-test.c
index 37b108b..45d9ad4 100644
--- a/tools/perf/tests/builtin-test.c
+++ b/tools/perf/tests/builtin-test.c
@@ -82,6 +82,10 @@ static struct test {
 		.func = test__bp_signal,
 	},
 	{
+		.desc = "Test breakpoint overflow sampling",
+		.func = test__bp_signal_overflow,
+	},
+	{
 		.func = NULL,
 	},
 };
diff --git a/tools/perf/tests/tests.h b/tools/perf/tests/tests.h
index 05d0e58..6cf1ec4 100644
--- a/tools/perf/tests/tests.h
+++ b/tools/perf/tests/tests.h
@@ -24,5 +24,6 @@ int test__parse_events(void);
 int test__hists_link(void);
 int test__python_use(void);
 int test__bp_signal(void);
+int test__bp_signal_overflow(void);
 
 #endif /* TESTS_H */
-- 
1.7.11.7

