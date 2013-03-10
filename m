Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753296Ab3CJSlz (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Mar 2013 14:41:55 -0400
Received: from mx1.redhat.com ([209.132.183.28]:44983 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753271Ab3CJSlw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Mar 2013 14:41:52 -0400
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
Subject: [PATCH 5/6] perf tests: Test breakpoint overflow signal handler
Date: Sun, 10 Mar 2013 19:41:10 +0100
Message-Id: <1362940871-24486-6-git-send-email-jolsa@redhat.com>
In-Reply-To: <1362940871-24486-1-git-send-email-jolsa@redhat.com>
References: <1362940871-24486-1-git-send-email-jolsa@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Adding automated test for breakpoint event signal
handler checking if it's executed properly.

The test is related to the proper handling of the RF
EFLAGS bit on x86_64, but it's generic for all archs.

First we check the signal handler is properly called
and that the following debug exception return to user
space wouldn't trigger recursive breakpoint.

This is related to x86_64 RF EFLAGS bit being managed
in a wrong way.

Second we check that we can set breakpoint in signal
handler, which is not possible on x86_64 if the signal
handler is executed with RF EFLAG set.

This test is inpired by overflow tests done by Vince
Weaver.

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
 tools/perf/Makefile             |   1 +
 tools/perf/tests/bp_signal.c    | 187 ++++++++++++++++++++++++++++++++++++++++
 tools/perf/tests/builtin-test.c |   4 +
 tools/perf/tests/tests.h        |   1 +
 4 files changed, 193 insertions(+)
 create mode 100644 tools/perf/tests/bp_signal.c

diff --git a/tools/perf/Makefile b/tools/perf/Makefile
index a2108ca..bea66fe 100644
--- a/tools/perf/Makefile
+++ b/tools/perf/Makefile
@@ -497,6 +497,7 @@ LIB_OBJS += $(OUTPUT)tests/evsel-tp-sched.o
 LIB_OBJS += $(OUTPUT)tests/pmu.o
 LIB_OBJS += $(OUTPUT)tests/hists_link.o
 LIB_OBJS += $(OUTPUT)tests/python-use.o
+LIB_OBJS += $(OUTPUT)tests/bp_signal.o
 
 BUILTIN_OBJS += $(OUTPUT)builtin-annotate.o
 BUILTIN_OBJS += $(OUTPUT)builtin-bench.o
diff --git a/tools/perf/tests/bp_signal.c b/tools/perf/tests/bp_signal.c
new file mode 100644
index 0000000..a40b019
--- /dev/null
+++ b/tools/perf/tests/bp_signal.c
@@ -0,0 +1,187 @@
+/*
+ * Inspired by breakpoint overflow test done by
+ * Vince Weaver <vincent.weaver@maine.edu> for perf_event_tests
+ * (git://github.com/deater/perf_event_tests)
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
+static int fd1;
+static int fd2;
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
+
+	if (overflows > 10) {
+		/*
+		 * This should be executed only once during
+		 * this test, if we are here for the 10th
+		 * time, consider this the recursive issue.
+		 *
+		 * We can get out of here by disable events,
+		 * so no new SIGIO is delivered.
+		 */
+		ioctl(fd1, PERF_EVENT_IOC_DISABLE, 0);
+		ioctl(fd2, PERF_EVENT_IOC_DISABLE, 0);
+	}
+}
+
+static int bp_event(void *fn, int setup_signal)
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
+	pe.sample_period = 1;
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
+	if (setup_signal) {
+		fcntl(fd, F_SETFL, O_RDWR|O_NONBLOCK|O_ASYNC);
+		fcntl(fd, F_SETSIG, SIGIO);
+		fcntl(fd, F_SETOWN, getpid());
+	}
+
+	ioctl(fd, PERF_EVENT_IOC_RESET, 0);
+
+	return fd;
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
+int test__bp_signal(void)
+{
+	struct sigaction sa;
+	long long count1, count2;
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
+	/*
+	 * We create following events:
+	 *
+	 * fd1 - breakpoint event on test_function with SIGIO
+	 *       signal configured. We should get signal
+	 *       notification each time the breakpoint is hit
+	 *
+	 * fd2 - breakpoint event on sig_handler without SIGIO
+	 *       configured.
+	 *
+	 * Following processing should happen:
+	 *   - execute test_function
+	 *   - fd1 event breakpoint hit -> count1 == 1
+	 *   - SIGIO is delivered       -> overflows == 1
+	 *   - fd2 event breakpoint hit -> count2 == 1
+	 *
+	 * The test case check following error conditions:
+	 * - we get stuck in signal handler because of debug
+	 *   exception being triggered receursively due to
+	 *   the wrong RF EFLAG management
+	 *
+	 * - we never trigger the sig_handler breakpoint due
+	 *   to the rong RF EFLAG management
+	 *
+	 */
+
+	fd1 = bp_event(test_function, 1);
+	fd2 = bp_event(sig_handler, 0);
+
+	ioctl(fd1, PERF_EVENT_IOC_ENABLE, 0);
+	ioctl(fd2, PERF_EVENT_IOC_ENABLE, 0);
+
+	/*
+	 * Kick off the test by trigering 'fd1'
+	 * breakpoint.
+	 */
+	test_function();
+
+	ioctl(fd1, PERF_EVENT_IOC_DISABLE, 0);
+	ioctl(fd2, PERF_EVENT_IOC_DISABLE, 0);
+
+	count1 = bp_count(fd1);
+	count2 = bp_count(fd2);
+
+	close(fd1);
+	close(fd2);
+
+	pr_debug("count1 %lld, count2 %lld, overflow %d\n",
+		 count1, count2, overflows);
+
+	if (count1 != 1) {
+		if (count1 == 11)
+			pr_err("failed: RF EFLAG recursion issue detected\n");
+		else
+			pr_err("failed: wrong count for bp1%lld\n",
+			       count1);
+	}
+
+	if (overflows != 1)
+		pr_err("failed: wrong overflow hit\n");
+
+	if (count2 != 1)
+		pr_err("failed: wrong count for bp2\n");
+
+	return count1 == 1 && overflows == 1 && count2 == 1 ?
+		TEST_OK : TEST_FAIL;
+}
diff --git a/tools/perf/tests/builtin-test.c b/tools/perf/tests/builtin-test.c
index acb98e0..37b108b 100644
--- a/tools/perf/tests/builtin-test.c
+++ b/tools/perf/tests/builtin-test.c
@@ -78,6 +78,10 @@ static struct test {
 		.func = test__python_use,
 	},
 	{
+		.desc = "Test breakpoint overflow signal handler",
+		.func = test__bp_signal,
+	},
+	{
 		.func = NULL,
 	},
 };
diff --git a/tools/perf/tests/tests.h b/tools/perf/tests/tests.h
index 5de0be1..05d0e58 100644
--- a/tools/perf/tests/tests.h
+++ b/tools/perf/tests/tests.h
@@ -23,5 +23,6 @@ int test__dso_data(void);
 int test__parse_events(void);
 int test__hists_link(void);
 int test__python_use(void);
+int test__bp_signal(void);
 
 #endif /* TESTS_H */
-- 
1.7.11.7

