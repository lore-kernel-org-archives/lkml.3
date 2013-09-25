Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755740Ab3IYMvn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Sep 2013 08:51:43 -0400
Received: from mx1.redhat.com ([209.132.183.28]:52416 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755668Ab3IYMvk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Sep 2013 08:51:40 -0400
From: Jiri Olsa <jolsa@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: Jiri Olsa <jolsa@redhat.com>, Arnaldo Carvalho de Melo <acme@redhat.com>,
        Corey Ashford <cjashfor@linux.vnet.ibm.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@elte.hu>,
        Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: [PATCH 15/21] perf tests: Adding event inherit toggling test
Date: Wed, 25 Sep 2013 14:50:41 +0200
Message-Id: <1380113447-17144-16-git-send-email-jolsa@redhat.com>
In-Reply-To: <1380113447-17144-1-git-send-email-jolsa@redhat.com>
References: <1380113447-17144-1-git-send-email-jolsa@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Does the same as raw toggling test except it also creates
child process that runs same workload. Testing that the
instructions event's toggling is properly inherited and
count is propagated to the parent.

Signed-off-by: Jiri Olsa <jolsa@redhat.com>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: Corey Ashford <cjashfor@linux.vnet.ibm.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/Makefile                     |   1 +
 tools/perf/tests/builtin-test.c         |   4 +
 tools/perf/tests/tests.h                |   1 +
 tools/perf/tests/toggle-event-inherit.c | 132 ++++++++++++++++++++++++++++++++
 4 files changed, 138 insertions(+)
 create mode 100644 tools/perf/tests/toggle-event-inherit.c

diff --git a/tools/perf/Makefile b/tools/perf/Makefile
index 90d7127..893c4a7 100644
--- a/tools/perf/Makefile
+++ b/tools/perf/Makefile
@@ -400,6 +400,7 @@ LIB_OBJS += $(OUTPUT)tests/sample-parsing.o
 LIB_OBJS += $(OUTPUT)tests/parse-no-sample-id-all.o
 LIB_OBJS += $(OUTPUT)tests/toggle-event-raw.o
 LIB_OBJS += $(OUTPUT)tests/toggle-event-group.o
+LIB_OBJS += $(OUTPUT)tests/toggle-event-inherit.o
 ifeq ($(RAW_ARCH),x86_64)
 LIB_OBJS += $(OUTPUT)arch/x86/tests/toggle-event-raw-64.o
 endif
diff --git a/tools/perf/tests/builtin-test.c b/tools/perf/tests/builtin-test.c
index 7e96550..6768266 100644
--- a/tools/perf/tests/builtin-test.c
+++ b/tools/perf/tests/builtin-test.c
@@ -124,6 +124,10 @@ static struct test {
 		.func = test__toggle_event_group,
 	},
 	{
+		.desc = "Toggle event inherit",
+		.func = test__toggle_event_inherit,
+	},
+	{
 		.func = NULL,
 	},
 };
diff --git a/tools/perf/tests/tests.h b/tools/perf/tests/tests.h
index db692bf..f0ef1050 100644
--- a/tools/perf/tests/tests.h
+++ b/tools/perf/tests/tests.h
@@ -42,5 +42,6 @@ int test__keep_tracking(void);
 int test__parse_no_sample_id_all(void);
 int test__toggle_event_raw(void);
 int test__toggle_event_group(void);
+int test__toggle_event_inherit(void);
 
 #endif /* TESTS_H */
diff --git a/tools/perf/tests/toggle-event-inherit.c b/tools/perf/tests/toggle-event-inherit.c
new file mode 100644
index 0000000..0c02fd8
--- /dev/null
+++ b/tools/perf/tests/toggle-event-inherit.c
@@ -0,0 +1,132 @@
+
+#include <unistd.h>
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
+ * All events are created with inherit flag set.
+ *
+ * Workload executes test__toggle_event_raw_arch
+ * first in parent and then in the child. After
+ * the child is finished, we check we got 10
+ * instructions instead of 5, that means plus extra
+ * 5 from the child.
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
+
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
+int test__toggle_event_inherit(void)
+{
+	pr_err("The toggle event test not implemented for arch.\n");
+	return 0;
+}
+#else
+int test__toggle_event_inherit(void)
+{
+	struct perf_event_attr attr_on = {
+		.type		= PERF_TYPE_TRACEPOINT,
+		.config		= get_tp_id("sys_enter_openat"),
+		.sample_period	= 1,
+		.inherit	= 1,
+	};
+	struct perf_event_attr attr_off = {
+		.type		= PERF_TYPE_TRACEPOINT,
+		.config		= get_tp_id("sys_enter_close"),
+		.sample_period	= 1,
+		.inherit	= 1,
+	};
+	struct perf_event_attr attr_instr = {
+		.type		= PERF_TYPE_HARDWARE,
+		.config		= PERF_COUNT_HW_INSTRUCTIONS,
+		.paused		= 1,
+		.exclude_kernel = 1,
+		.exclude_hv	= 1,
+		.inherit	= 1,
+	};
+	int fd_on, fd_off, fd_instr;
+	__u64 value, instr;
+	int err, status;
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
+	err = fork();
+	if (err == 0) {
+		test__toggle_event_raw_arch();
+		_exit(0);
+	} else if (err < 0) {
+		pr_err("fork failed\n");
+		return -1;
+	}
+
+	waitpid(-1, &status, 0);
+
+	close(fd_on);
+	close(fd_off);
+
+	if (sizeof(value) != read(fd_instr, &value, sizeof(value)))
+		pr_err("failed to read instruction event, errno %d\n", errno);
+
+	instr *= 2;
+
+	pr_debug("got count %llu vs %llu\n", value, instr);
+
+	close(fd_instr);
+	return instr != value;
+}
+#endif /* __x86_64__ */
-- 
1.7.11.7

