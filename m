Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755693Ab3IYMvi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Sep 2013 08:51:38 -0400
Received: from mx1.redhat.com ([209.132.183.28]:61750 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755615Ab3IYMvg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Sep 2013 08:51:36 -0400
From: Jiri Olsa <jolsa@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: Jiri Olsa <jolsa@redhat.com>, Arnaldo Carvalho de Melo <acme@redhat.com>,
        Corey Ashford <cjashfor@linux.vnet.ibm.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@elte.hu>,
        Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: [PATCH 13/21] perf tests: Adding event simple toggling test
Date: Wed, 25 Sep 2013 14:50:39 +0200
Message-Id: <1380113447-17144-14-git-send-email-jolsa@redhat.com>
In-Reply-To: <1380113447-17144-1-git-send-email-jolsa@redhat.com>
References: <1380113447-17144-1-git-send-email-jolsa@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Adding toggle toggle interface test into automated suite.

The test creates HW userspace instruction counter, which is
triggered by 'openat' tracepoint and disabled by 'close'
tracepoint.

The test compares number of the userspace instructions
measured by counter with expected count.

Signed-off-by: Jiri Olsa <jolsa@redhat.com>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: Corey Ashford <cjashfor@linux.vnet.ibm.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/Makefile                             |   4 +
 tools/perf/arch/x86/tests/toggle-event-raw-64.S |  28 +++++++
 tools/perf/tests/builtin-test.c                 |   4 +
 tools/perf/tests/tests.h                        |   1 +
 tools/perf/tests/toggle-event-raw.c             | 106 ++++++++++++++++++++++++
 5 files changed, 143 insertions(+)
 create mode 100644 tools/perf/arch/x86/tests/toggle-event-raw-64.S
 create mode 100644 tools/perf/tests/toggle-event-raw.c

diff --git a/tools/perf/Makefile b/tools/perf/Makefile
index 430878a..2072389 100644
--- a/tools/perf/Makefile
+++ b/tools/perf/Makefile
@@ -398,6 +398,10 @@ endif
 LIB_OBJS += $(OUTPUT)tests/code-reading.o
 LIB_OBJS += $(OUTPUT)tests/sample-parsing.o
 LIB_OBJS += $(OUTPUT)tests/parse-no-sample-id-all.o
+LIB_OBJS += $(OUTPUT)tests/toggle-event-raw.o
+ifeq ($(RAW_ARCH),x86_64)
+LIB_OBJS += $(OUTPUT)arch/x86/tests/toggle-event-raw-64.o
+endif
 
 BUILTIN_OBJS += $(OUTPUT)builtin-annotate.o
 BUILTIN_OBJS += $(OUTPUT)builtin-bench.o
diff --git a/tools/perf/arch/x86/tests/toggle-event-raw-64.S b/tools/perf/arch/x86/tests/toggle-event-raw-64.S
new file mode 100644
index 0000000..027fccd
--- /dev/null
+++ b/tools/perf/arch/x86/tests/toggle-event-raw-64.S
@@ -0,0 +1,28 @@
+
+/*
+ * XXX I'd normally do '#include <asm/unistd_64.h>', but it's
+ * overloaded in ./util/include/asm/ with empty file. So using
+ * my own syscall defines instead for now.
+ */
+#define __NR_openat 257
+#define __NR_close 3
+
+	.global test__toggle_event_raw_arch
+test__toggle_event_raw_arch:
+	movq $__NR_openat,%rax
+	xorq %rdi, %rdi
+	xorq %rdx, %rdx
+	xorq %rcx, %rcx
+	xorq %r8, %r8
+	xorq %r9, %r9
+	syscall
+
+	nop			# 1
+	nop			# 2
+
+	movq $__NR_close,%rax	# 3
+	movq $-1, %rdi		# 4
+	syscall			# 5
+
+	mov $5, %rax
+	retq
diff --git a/tools/perf/tests/builtin-test.c b/tools/perf/tests/builtin-test.c
index 1e67437..db9d924b 100644
--- a/tools/perf/tests/builtin-test.c
+++ b/tools/perf/tests/builtin-test.c
@@ -116,6 +116,10 @@ static struct test {
 		.func = test__parse_no_sample_id_all,
 	},
 	{
+		.desc = "Toggle event raw",
+		.func = test__toggle_event_raw,
+	},
+	{
 		.func = NULL,
 	},
 };
diff --git a/tools/perf/tests/tests.h b/tools/perf/tests/tests.h
index e0ac713..4f2a8a1 100644
--- a/tools/perf/tests/tests.h
+++ b/tools/perf/tests/tests.h
@@ -40,5 +40,6 @@ int test__code_reading(void);
 int test__sample_parsing(void);
 int test__keep_tracking(void);
 int test__parse_no_sample_id_all(void);
+int test__toggle_event_raw(void);
 
 #endif /* TESTS_H */
diff --git a/tools/perf/tests/toggle-event-raw.c b/tools/perf/tests/toggle-event-raw.c
new file mode 100644
index 0000000..5d4406d
--- /dev/null
+++ b/tools/perf/tests/toggle-event-raw.c
@@ -0,0 +1,106 @@
+
+#include <traceevent/event-parse.h>
+#include "thread_map.h"
+#include "evsel.h"
+#include "debug.h"
+#include "tests.h"
+
+/*
+ * This test creates following events:
+ *
+ * 1) tracepoint sys_enter_openat
+ * 2) tracepoint sys_enter_close
+ * 3) HW event instruction
+ *
+ * Events 1) and 2) are set to toggle ON and OFF
+ * respectively event 3).
+ *
+ * Workload in test__toggle_event_raw_arch:
+ *  - executes open_at syscall
+ *  - executes 5 instructions
+ *  - executes close syscall
+ *
+ * We read instruction event to validate
+ * we counted 5 instructions.
+ *
+ */
+extern int test__toggle_event_raw_arch(void);
+
+static int get_tp_id(const char *name)
+{
+	struct event_format *tp_format = event_format__new("syscalls", name);
+	u64 id = 0;
+
+	if (tp_format) {
+		id = tp_format->id;
+		pevent_free_format(tp_format);
+	}
+
+	return id;
+}
+
+#ifndef __x86_64__
+int test__toggle_event_raw(void)
+{
+	pr_err("The toggle event test not implemented for arch.\n");
+	return 0;
+}
+#else
+int test__toggle_event_raw(void)
+{
+	struct perf_event_attr attr_on = {
+		.type   = PERF_TYPE_TRACEPOINT,
+		.config = get_tp_id("sys_enter_openat"),
+		.sample_period = 1,
+	};
+	struct perf_event_attr attr_off = {
+		.type   = PERF_TYPE_TRACEPOINT,
+		.config = get_tp_id("sys_enter_close"),
+		.sample_period = 1,
+	};
+	struct perf_event_attr attr_instr = {
+		.type		= PERF_TYPE_HARDWARE,
+		.config		= PERF_COUNT_HW_INSTRUCTIONS,
+		.paused		= 1,
+		.exclude_kernel = 1,
+		.exclude_hv	= 1,
+	};
+	int fd_on, fd_off, fd_instr;
+	__u64 value, instr;
+
+	fd_instr = sys_perf_event_open(&attr_instr, 0, -1, -1, 0);
+	if (fd_instr < 0) {
+		pr_err("failed to open instruction event, errno %d\n", errno);
+		return -1;
+	}
+
+	fd_on = sys_perf_event_open(&attr_on, 0, -1,
+				    fd_instr,
+				    PERF_FLAG_TOGGLE_ON);
+	if (fd_on < 0) {
+		pr_err("failed to open 'on' event, errno %d\n", errno);
+		return -1;
+	}
+
+	fd_off = sys_perf_event_open(&attr_off, 0, -1,
+				     fd_instr,
+				     PERF_FLAG_TOGGLE_OFF);
+	if (fd_off < 0) {
+		pr_err("failed to open 'off' event, errno %d\n", errno);
+		return -1;
+	}
+
+	instr = test__toggle_event_raw_arch();
+
+	close(fd_on);
+	close(fd_off);
+
+	if (sizeof(value) != read(fd_instr, &value, sizeof(value)))
+		pr_err("failed to read instruction event, errno %d\n", errno);
+
+	pr_debug("got count %llu vs %llu\n", value, instr);
+
+	close(fd_instr);
+	return instr != value;
+}
+#endif /* __x86_64__ */
-- 
1.7.11.7

