Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751527AbaAMKKh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Jan 2014 05:10:37 -0500
Received: from smtp5-g21.free.fr ([212.27.42.5]:45663 "EHLO smtp5-g21.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751024AbaAMKKe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Jan 2014 05:10:34 -0500
From: Yann Droneaud <ydroneaud@opteya.com>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>, Paul Mackerras <paulus@samba.org>,
        Ingo Molnar <mingo@redhat.com>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Jiri Olsa <jolsa@redhat.com>, Namhyung Kim <namhyung@kernel.org>,
        Andi Kleen <ak@linux.intel.com>, David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Mike Galbraith <efault@gmx.de>, Stephane Eranian <eranian@google.com>,
        Adrian Hunter <adrian.hunter@intel.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Michael Ellerman <michael@ellerman.id.au>
Cc: linux-kernel@vger.kernel.org, Yann Droneaud <ydroneaud@opteya.com>,
        Peter Zijlstra <peterz@infradead.org>
Subject: [PATCHv2] perf tools: enable close-on-exec flag on perf file descriptor
Date: Mon, 13 Jan 2014 11:09:30 +0100
Message-Id: <1389607770-4485-1-git-send-email-ydroneaud@opteya.com>
X-Mailer: git-send-email 1.8.4.2
References: <cover.1388952061.git.ydroneaud@opteya.com> <8c03f54e1598b1727c19706f3af03f98685d9fe6.1388952061.git.ydroneaud@opteya.com> <20140106092929.GA31570@twins.programming.kicks-ass.net> <1389005485-12778-1-git-send-email-ydroneaud@opteya.com> <20140106112436.GF31570@twins.programming.kicks-ass.net> <20140106144347.GA13500@ghostprotocols.net> <20140106142220.GB1183@krava.brq.redhat.com> <1389463628-24869-1-git-send-email-ydroneaud@opteya.com>
In-Reply-To: <1389463628-24869-1-git-send-email-ydroneaud@opteya.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In a previous patch [1], flag PERF_FLAG_FD_CLOEXEC was
added to perf_event_open(2) syscall to allows userspace
to enable close-on-exec behavor atomically when creating
the file descriptor.

This patch makes perf tools use the new flag if supported
by the kernel, so that the event file descriptors got
automatically closed if perf tool exec a sub-command.

Changes from v1 [2]:
- don't probe PERF_FLAG_FD_CLOEXEC for each call to
  perf_event_open_cloexec_flag(): don't forget to set
  'probed' variable once flag was probed.
- call perf_event_open_cloexec_flag() only once in
  util/record.c:perf_do_probe_api().
- fixed minor coding style issue (unneeded braces)
  in util/cloexec.c

Changes from v0 [3]:
- add probing for PERF_FLAG_FD_CLOEXEC flag allowing
  perf to run on older kernel:
  * use "missing feature" pattern in evsel to disable
    PERF_FLAG_FD_CLOEXEC in perf_evsel__open() if not
    supported by kernel;
  * add a dedicated function to probe for
    PERF_FLAG_FD_CLOEXEC support in the current kernel.
    This function is to be used by other functions
    calling sys_perf_event_open() directly.
- remove PERF_FLAG_FD_CLOEXEC from PowerPC selftest
  as it's not related to perf tool: it should be part
  of a separate patch.

[1] http://lkml.kernel.org/r/8c03f54e1598b1727c19706f3af03f98685d9fe6.1388952061.git.ydroneaud@opteya.com
    https://patchwork.kernel.org/patch/3434971/
[2] http://lkml.kernel.org/r/1389463628-24869-1-git-send-email-ydroneaud@opteya.com
    https://patchwork.kernel.org/patch/3469571/
[3] http://lkml.kernel.org/r/1389005485-12778-1-git-send-email-ydroneaud@opteya.com
    https://patchwork.kernel.org/patch/3437111/

Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Andi Kleen <ak@linux.intel.com>
Signed-off-by: Yann Droneaud <ydroneaud@opteya.com>
Link: http://lkml.kernel.org/r/cover.1388952061.git.ydroneaud@opteya.com
---
 tools/perf/Makefile.perf              |  1 +
 tools/perf/bench/mem-memcpy.c         |  4 ++-
 tools/perf/bench/mem-memset.c         |  4 ++-
 tools/perf/builtin-sched.c            |  4 ++-
 tools/perf/tests/bp_signal.c          |  4 ++-
 tools/perf/tests/bp_signal_overflow.c |  4 ++-
 tools/perf/tests/rdpmc.c              |  4 ++-
 tools/perf/util/cloexec.c             | 54 +++++++++++++++++++++++++++++++++++
 tools/perf/util/cloexec.h             |  6 ++++
 tools/perf/util/evsel.c               | 12 ++++++--
 tools/perf/util/record.c              |  9 ++++--
 11 files changed, 94 insertions(+), 12 deletions(-)
 create mode 100644 tools/perf/util/cloexec.c
 create mode 100644 tools/perf/util/cloexec.h

diff --git a/tools/perf/Makefile.perf b/tools/perf/Makefile.perf
index 3638b0bd20dc..bcce558b5407 100644
--- a/tools/perf/Makefile.perf
+++ b/tools/perf/Makefile.perf
@@ -372,6 +372,7 @@ LIB_OBJS += $(OUTPUT)util/stat.o
 LIB_OBJS += $(OUTPUT)util/record.o
 LIB_OBJS += $(OUTPUT)util/srcline.o
 LIB_OBJS += $(OUTPUT)util/data.o
+LIB_OBJS += $(OUTPUT)util/cloexec.o
 
 LIB_OBJS += $(OUTPUT)ui/setup.o
 LIB_OBJS += $(OUTPUT)ui/helpline.o
diff --git a/tools/perf/bench/mem-memcpy.c b/tools/perf/bench/mem-memcpy.c
index 5ce71d3b72cf..bf5a21b848a9 100644
--- a/tools/perf/bench/mem-memcpy.c
+++ b/tools/perf/bench/mem-memcpy.c
@@ -10,6 +10,7 @@
 #include "../util/util.h"
 #include "../util/parse-options.h"
 #include "../util/header.h"
+#include "../util/cloexec.h"
 #include "bench.h"
 #include "mem-memcpy-arch.h"
 
@@ -83,7 +84,8 @@ static struct perf_event_attr cycle_attr = {
 
 static void init_cycle(void)
 {
-	cycle_fd = sys_perf_event_open(&cycle_attr, getpid(), -1, -1, 0);
+	cycle_fd = sys_perf_event_open(&cycle_attr, getpid(), -1, -1,
+				       perf_event_open_cloexec_flag());
 
 	if (cycle_fd < 0 && errno == ENOSYS)
 		die("No CONFIG_PERF_EVENTS=y kernel support configured?\n");
diff --git a/tools/perf/bench/mem-memset.c b/tools/perf/bench/mem-memset.c
index 9af79d2b18e5..260747ea1e0e 100644
--- a/tools/perf/bench/mem-memset.c
+++ b/tools/perf/bench/mem-memset.c
@@ -10,6 +10,7 @@
 #include "../util/util.h"
 #include "../util/parse-options.h"
 #include "../util/header.h"
+#include "../util/cloexec.h"
 #include "bench.h"
 #include "mem-memset-arch.h"
 
@@ -83,7 +84,8 @@ static struct perf_event_attr cycle_attr = {
 
 static void init_cycle(void)
 {
-	cycle_fd = sys_perf_event_open(&cycle_attr, getpid(), -1, -1, 0);
+	cycle_fd = sys_perf_event_open(&cycle_attr, getpid(), -1, -1,
+				       perf_event_open_cloexec_flag());
 
 	if (cycle_fd < 0 && errno == ENOSYS)
 		die("No CONFIG_PERF_EVENTS=y kernel support configured?\n");
diff --git a/tools/perf/builtin-sched.c b/tools/perf/builtin-sched.c
index 6a76a07b6789..54017bdec88c 100644
--- a/tools/perf/builtin-sched.c
+++ b/tools/perf/builtin-sched.c
@@ -10,6 +10,7 @@
 #include "util/header.h"
 #include "util/session.h"
 #include "util/tool.h"
+#include "util/cloexec.h"
 
 #include "util/parse-options.h"
 #include "util/trace-event.h"
@@ -435,7 +436,8 @@ static int self_open_counters(void)
 	attr.type = PERF_TYPE_SOFTWARE;
 	attr.config = PERF_COUNT_SW_TASK_CLOCK;
 
-	fd = sys_perf_event_open(&attr, 0, -1, -1, 0);
+	fd = sys_perf_event_open(&attr, 0, -1, -1,
+				 perf_event_open_cloexec_flag());
 
 	if (fd < 0)
 		pr_err("Error: sys_perf_event_open() syscall returned "
diff --git a/tools/perf/tests/bp_signal.c b/tools/perf/tests/bp_signal.c
index aba095489193..fdc0d3e185f9 100644
--- a/tools/perf/tests/bp_signal.c
+++ b/tools/perf/tests/bp_signal.c
@@ -25,6 +25,7 @@
 #include "tests.h"
 #include "debug.h"
 #include "perf.h"
+#include "../util/cloexec.h"
 
 static int fd1;
 static int fd2;
@@ -78,7 +79,8 @@ static int bp_event(void *fn, int setup_signal)
 	pe.exclude_kernel = 1;
 	pe.exclude_hv = 1;
 
-	fd = sys_perf_event_open(&pe, 0, -1, -1, 0);
+	fd = sys_perf_event_open(&pe, 0, -1, -1,
+				 perf_event_open_cloexec_flag());
 	if (fd < 0) {
 		pr_debug("failed opening event %llx\n", pe.config);
 		return TEST_FAIL;
diff --git a/tools/perf/tests/bp_signal_overflow.c b/tools/perf/tests/bp_signal_overflow.c
index 44ac82179708..b0b17415f18c 100644
--- a/tools/perf/tests/bp_signal_overflow.c
+++ b/tools/perf/tests/bp_signal_overflow.c
@@ -24,6 +24,7 @@
 #include "tests.h"
 #include "debug.h"
 #include "perf.h"
+#include "../util/cloexec.h"
 
 static int overflows;
 
@@ -91,7 +92,8 @@ int test__bp_signal_overflow(void)
 	pe.exclude_kernel = 1;
 	pe.exclude_hv = 1;
 
-	fd = sys_perf_event_open(&pe, 0, -1, -1, 0);
+	fd = sys_perf_event_open(&pe, 0, -1, -1,
+				 perf_event_open_cloexec_flag());
 	if (fd < 0) {
 		pr_debug("failed opening event %llx\n", pe.config);
 		return TEST_FAIL;
diff --git a/tools/perf/tests/rdpmc.c b/tools/perf/tests/rdpmc.c
index 46649c25fa5e..c1e55ff18774 100644
--- a/tools/perf/tests/rdpmc.c
+++ b/tools/perf/tests/rdpmc.c
@@ -6,6 +6,7 @@
 #include "perf.h"
 #include "debug.h"
 #include "tests.h"
+#include "../util/cloexec.h"
 
 #if defined(__x86_64__) || defined(__i386__)
 
@@ -104,7 +105,8 @@ static int __test__rdpmc(void)
 	sa.sa_sigaction = segfault_handler;
 	sigaction(SIGSEGV, &sa, NULL);
 
-	fd = sys_perf_event_open(&attr, 0, -1, -1, 0);
+	fd = sys_perf_event_open(&attr, 0, -1, -1,
+				 perf_event_open_cloexec_flag());
 	if (fd < 0) {
 		pr_err("Error: sys_perf_event_open() syscall returned "
 		       "with %d (%s)\n", fd, strerror(errno));
diff --git a/tools/perf/util/cloexec.c b/tools/perf/util/cloexec.c
new file mode 100644
index 000000000000..06f6ee087fa1
--- /dev/null
+++ b/tools/perf/util/cloexec.c
@@ -0,0 +1,54 @@
+#include "util.h"
+#include "../perf.h"
+#include "cloexec.h"
+
+static unsigned long flag = PERF_FLAG_FD_CLOEXEC;
+
+static int perf_flag_probe(void)
+{
+	struct perf_event_attr attr;
+	int fd;
+	int err;
+
+	/* check cloexec flag */
+	memset(&attr, 0, sizeof(attr));
+	fd = sys_perf_event_open(&attr, 0, -1, -1,
+				 PERF_FLAG_FD_CLOEXEC);
+	if (fd >= 0) {
+		close(fd);
+		return 1;
+	}
+
+	if (errno != EINVAL) {
+		err = errno;
+		pr_warning("sys_perf_event_open() syscall returned "
+			   "%d (%d: %s)\n", fd, err, strerror(err));
+	}
+
+	/* not supported, confirm error related to PERF_FLAG_FD_CLOEXEC */
+	memset(&attr, 0, sizeof(attr));
+	fd = sys_perf_event_open(&attr, 0, -1, -1, 0);
+	if (fd >= 0) {
+		close(fd);
+		return 0;
+	}
+
+	err = errno;
+	die("sys_perf_event_open() syscall returned "
+	    "%d (%d: %s)\n", fd, err, strerror(err));
+
+	return -1;
+}
+
+unsigned long perf_event_open_cloexec_flag(void)
+{
+	static bool probed;
+
+	if (!probed) {
+		if (perf_flag_probe() <= 0)
+			flag = 0;
+		probed = true;
+	}
+
+	return flag;
+}
diff --git a/tools/perf/util/cloexec.h b/tools/perf/util/cloexec.h
new file mode 100644
index 000000000000..94a5a7d829d5
--- /dev/null
+++ b/tools/perf/util/cloexec.h
@@ -0,0 +1,6 @@
+#ifndef __PERF_CLOEXEC_H
+#define __PERF_CLOEXEC_H
+
+unsigned long perf_event_open_cloexec_flag(void);
+
+#endif /* __PERF_CLOEXEC_H */
diff --git a/tools/perf/util/evsel.c b/tools/perf/util/evsel.c
index ade8d9c1c431..ff845c7e7a4f 100644
--- a/tools/perf/util/evsel.c
+++ b/tools/perf/util/evsel.c
@@ -29,6 +29,7 @@ static struct {
 	bool sample_id_all;
 	bool exclude_guest;
 	bool mmap2;
+	bool cloexec;
 } perf_missing_features;
 
 #define FD(e, x, y) (*(int *)xyarray__entry(e->fd, x, y))
@@ -968,7 +969,7 @@ static int __perf_evsel__open(struct perf_evsel *evsel, struct cpu_map *cpus,
 			      struct thread_map *threads)
 {
 	int cpu, thread;
-	unsigned long flags = 0;
+	unsigned long flags = PERF_FLAG_FD_CLOEXEC;
 	int pid = -1, err;
 	enum { NO_CHANGE, SET_TO_MAX, INCREASED_MAX } set_rlimit = NO_CHANGE;
 
@@ -977,11 +978,13 @@ static int __perf_evsel__open(struct perf_evsel *evsel, struct cpu_map *cpus,
 		return -ENOMEM;
 
 	if (evsel->cgrp) {
-		flags = PERF_FLAG_PID_CGROUP;
+		flags |= PERF_FLAG_PID_CGROUP;
 		pid = evsel->cgrp->fd;
 	}
 
 fallback_missing_features:
+	if (perf_missing_features.cloexec)
+		flags &= ~(unsigned long)PERF_FLAG_FD_CLOEXEC;
 	if (perf_missing_features.mmap2)
 		evsel->attr.mmap2 = 0;
 	if (perf_missing_features.exclude_guest)
@@ -1050,7 +1053,10 @@ try_fallback:
 	if (err != -EINVAL || cpu > 0 || thread > 0)
 		goto out_close;
 
-	if (!perf_missing_features.mmap2 && evsel->attr.mmap2) {
+	if (!perf_missing_features.cloexec && (flags & PERF_FLAG_FD_CLOEXEC)) {
+		perf_missing_features.cloexec = true;
+		goto fallback_missing_features;
+	} else if (!perf_missing_features.mmap2 && evsel->attr.mmap2) {
 		perf_missing_features.mmap2 = true;
 		goto fallback_missing_features;
 	} else if (!perf_missing_features.exclude_guest &&
diff --git a/tools/perf/util/record.c b/tools/perf/util/record.c
index 104a47563d39..6483ef5df31b 100644
--- a/tools/perf/util/record.c
+++ b/tools/perf/util/record.c
@@ -4,6 +4,7 @@
 #include "parse-events.h"
 #include "fs.h"
 #include "util.h"
+#include "cloexec.h"
 
 typedef void (*setup_probe_fn_t)(struct perf_evsel *evsel);
 
@@ -11,6 +12,7 @@ static int perf_do_probe_api(setup_probe_fn_t fn, int cpu, const char *str)
 {
 	struct perf_evlist *evlist;
 	struct perf_evsel *evsel;
+	unsigned long flags = perf_event_open_cloexec_flag();
 	int err = -EAGAIN, fd;
 
 	evlist = perf_evlist__new();
@@ -22,14 +24,14 @@ static int perf_do_probe_api(setup_probe_fn_t fn, int cpu, const char *str)
 
 	evsel = perf_evlist__first(evlist);
 
-	fd = sys_perf_event_open(&evsel->attr, -1, cpu, -1, 0);
+	fd = sys_perf_event_open(&evsel->attr, -1, cpu, -1, flags);
 	if (fd < 0)
 		goto out_delete;
 	close(fd);
 
 	fn(evsel);
 
-	fd = sys_perf_event_open(&evsel->attr, -1, cpu, -1, 0);
+	fd = sys_perf_event_open(&evsel->attr, -1, cpu, -1, flags);
 	if (fd < 0) {
 		if (errno == EINVAL)
 			err = -EINVAL;
@@ -203,7 +205,8 @@ bool perf_evlist__can_select_event(struct perf_evlist *evlist, const char *str)
 		cpu = evlist->cpus->map[0];
 	}
 
-	fd = sys_perf_event_open(&evsel->attr, -1, cpu, -1, 0);
+	fd = sys_perf_event_open(&evsel->attr, -1, cpu, -1,
+				 perf_event_open_cloexec_flag());
 	if (fd >= 0) {
 		close(fd);
 		ret = true;
-- 
1.8.4.2

