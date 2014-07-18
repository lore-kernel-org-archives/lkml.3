Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761548AbaGRKWe (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jul 2014 06:22:34 -0400
Received: from terminus.zytor.com ([198.137.202.10]:36677 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761027AbaGRKWa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jul 2014 06:22:30 -0400
Date: Fri, 18 Jul 2014 03:21:44 -0700
From: tip-bot for Yann Droneaud <tipbot@zytor.com>
Message-ID: <tip-57480d2cd93579d665e57e144e1e63f7f02ef058@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        jolsa@kernel.org, peterz@infradead.org, acme@ghostprotocols.net,
        ydroneaud@opteya.com, jolsa@redhat.com, ak@linux.intel.com,
        tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        jolsa@kernel.org, acme@ghostprotocols.net, peterz@infradead.org,
        ydroneaud@opteya.com, jolsa@redhat.com, ak@linux.intel.com,
        tglx@linutronix.de
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf tools:
  Enable close-on-exec flag on perf file descriptor
Git-Commit-ID: 57480d2cd93579d665e57e144e1e63f7f02ef058
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  57480d2cd93579d665e57e144e1e63f7f02ef058
Gitweb:     http://git.kernel.org/tip/57480d2cd93579d665e57e144e1e63f7f02ef058
Author:     Yann Droneaud <ydroneaud@opteya.com>
AuthorDate: Mon, 30 Jun 2014 22:28:47 +0200
Committer:  Jiri Olsa <jolsa@kernel.org>
CommitDate: Fri, 18 Jul 2014 09:09:34 +0200

perf tools: Enable close-on-exec flag on perf file descriptor

In commit a21b0b354d4a ('perf: Introduce a flag to enable
close-on-exec in perf_event_open()'), flag PERF_FLAG_FD_CLOEXEC
was added to perf_event_open(2) syscall to allows userspace
to atomically enable close-on-exec behavor when creating
the file descriptor.

This patch makes perf tools use the new flag if supported
by the kernel, so that the event file descriptors got
automatically closed if perf tool exec a sub-command.

Signed-off-by: Yann Droneaud <ydroneaud@opteya.com>
Cc: Andi Kleen <ak@linux.intel.com>
Cc: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Link: http://lkml.kernel.org/n/1404160127-7475-1-git-send-email-ydroneaud@opteya.com
Signed-off-by: Jiri Olsa <jolsa@kernel.org>
---
 tools/perf/Makefile.perf              |  1 +
 tools/perf/bench/mem-memcpy.c         |  4 ++-
 tools/perf/bench/mem-memset.c         |  4 ++-
 tools/perf/builtin-sched.c            |  4 ++-
 tools/perf/tests/bp_signal.c          |  4 ++-
 tools/perf/tests/bp_signal_overflow.c |  4 ++-
 tools/perf/tests/rdpmc.c              |  4 ++-
 tools/perf/util/cloexec.c             | 57 +++++++++++++++++++++++++++++++++++
 tools/perf/util/cloexec.h             |  6 ++++
 tools/perf/util/evsel.c               | 12 ++++++--
 tools/perf/util/record.c              |  9 ++++--
 11 files changed, 97 insertions(+), 12 deletions(-)

diff --git a/tools/perf/Makefile.perf b/tools/perf/Makefile.perf
index 3308b22..2240974 100644
--- a/tools/perf/Makefile.perf
+++ b/tools/perf/Makefile.perf
@@ -376,6 +376,7 @@ LIB_OBJS += $(OUTPUT)util/record.o
 LIB_OBJS += $(OUTPUT)util/srcline.o
 LIB_OBJS += $(OUTPUT)util/data.o
 LIB_OBJS += $(OUTPUT)util/tsc.o
+LIB_OBJS += $(OUTPUT)util/cloexec.o
 
 LIB_OBJS += $(OUTPUT)ui/setup.o
 LIB_OBJS += $(OUTPUT)ui/helpline.o
diff --git a/tools/perf/bench/mem-memcpy.c b/tools/perf/bench/mem-memcpy.c
index e622c3e..2465141 100644
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
index 2a65468..75fc3e6 100644
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
index b7f555a..f83c08c 100644
--- a/tools/perf/builtin-sched.c
+++ b/tools/perf/builtin-sched.c
@@ -10,6 +10,7 @@
 #include "util/header.h"
 #include "util/session.h"
 #include "util/tool.h"
+#include "util/cloexec.h"
 
 #include "util/parse-options.h"
 #include "util/trace-event.h"
@@ -434,7 +435,8 @@ static int self_open_counters(void)
 	attr.type = PERF_TYPE_SOFTWARE;
 	attr.config = PERF_COUNT_SW_TASK_CLOCK;
 
-	fd = sys_perf_event_open(&attr, 0, -1, -1, 0);
+	fd = sys_perf_event_open(&attr, 0, -1, -1,
+				 perf_event_open_cloexec_flag());
 
 	if (fd < 0)
 		pr_err("Error: sys_perf_event_open() syscall returned "
diff --git a/tools/perf/tests/bp_signal.c b/tools/perf/tests/bp_signal.c
index aba0954..a02b035 100644
--- a/tools/perf/tests/bp_signal.c
+++ b/tools/perf/tests/bp_signal.c
@@ -25,6 +25,7 @@
 #include "tests.h"
 #include "debug.h"
 #include "perf.h"
+#include "cloexec.h"
 
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
index 44ac821..e765377 100644
--- a/tools/perf/tests/bp_signal_overflow.c
+++ b/tools/perf/tests/bp_signal_overflow.c
@@ -24,6 +24,7 @@
 #include "tests.h"
 #include "debug.h"
 #include "perf.h"
+#include "cloexec.h"
 
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
index e59143f..c04d1f2 100644
--- a/tools/perf/tests/rdpmc.c
+++ b/tools/perf/tests/rdpmc.c
@@ -6,6 +6,7 @@
 #include "perf.h"
 #include "debug.h"
 #include "tests.h"
+#include "cloexec.h"
 
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
index 0000000..c5d05ec
--- /dev/null
+++ b/tools/perf/util/cloexec.c
@@ -0,0 +1,57 @@
+#include "util.h"
+#include "../perf.h"
+#include "cloexec.h"
+#include "asm/bug.h"
+
+static unsigned long flag = PERF_FLAG_FD_CLOEXEC;
+
+static int perf_flag_probe(void)
+{
+	/* use 'safest' configuration as used in perf_evsel__fallback() */
+	struct perf_event_attr attr = {
+		.type = PERF_COUNT_SW_CPU_CLOCK,
+		.config = PERF_COUNT_SW_CPU_CLOCK,
+	};
+	int fd;
+	int err;
+
+	/* check cloexec flag */
+	fd = sys_perf_event_open(&attr, 0, -1, -1,
+				 PERF_FLAG_FD_CLOEXEC);
+	err = errno;
+
+	if (fd >= 0) {
+		close(fd);
+		return 1;
+	}
+
+	WARN_ONCE(err != EINVAL,
+		  "perf_event_open(..., PERF_FLAG_FD_CLOEXEC) failed with unexpected error %d (%s)\n",
+		  err, strerror(err));
+
+	/* not supported, confirm error related to PERF_FLAG_FD_CLOEXEC */
+	fd = sys_perf_event_open(&attr, 0, -1, -1, 0);
+	err = errno;
+
+	if (WARN_ONCE(fd < 0,
+		      "perf_event_open(..., 0) failed unexpectedly with error %d (%s)\n",
+		      err, strerror(err)))
+		return -1;
+
+	close(fd);
+
+	return 0;
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
index 0000000..94a5a7d
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
index 90f58cd..21a373e 100644
--- a/tools/perf/util/evsel.c
+++ b/tools/perf/util/evsel.c
@@ -29,6 +29,7 @@ static struct {
 	bool sample_id_all;
 	bool exclude_guest;
 	bool mmap2;
+	bool cloexec;
 } perf_missing_features;
 
 #define FD(e, x, y) (*(int *)xyarray__entry(e->fd, x, y))
@@ -994,7 +995,7 @@ static int __perf_evsel__open(struct perf_evsel *evsel, struct cpu_map *cpus,
 			      struct thread_map *threads)
 {
 	int cpu, thread;
-	unsigned long flags = 0;
+	unsigned long flags = PERF_FLAG_FD_CLOEXEC;
 	int pid = -1, err;
 	enum { NO_CHANGE, SET_TO_MAX, INCREASED_MAX } set_rlimit = NO_CHANGE;
 
@@ -1003,11 +1004,13 @@ static int __perf_evsel__open(struct perf_evsel *evsel, struct cpu_map *cpus,
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
@@ -1076,7 +1079,10 @@ try_fallback:
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
index 1657231..fe8079e 100644
--- a/tools/perf/util/record.c
+++ b/tools/perf/util/record.c
@@ -4,6 +4,7 @@
 #include "parse-events.h"
 #include <api/fs/fs.h>
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
@@ -219,7 +221,8 @@ bool perf_evlist__can_select_event(struct perf_evlist *evlist, const char *str)
 		cpu = evlist->cpus->map[0];
 	}
 
-	fd = sys_perf_event_open(&evsel->attr, -1, cpu, -1, 0);
+	fd = sys_perf_event_open(&evsel->attr, -1, cpu, -1,
+				 perf_event_open_cloexec_flag());
 	if (fd >= 0) {
 		close(fd);
 		ret = true;
