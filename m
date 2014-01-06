Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754137AbaAFKwb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Jan 2014 05:52:31 -0500
Received: from smtp5-g21.free.fr ([212.27.42.5]:58225 "EHLO smtp5-g21.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753005AbaAFKwa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Jan 2014 05:52:30 -0500
X-Greylist: delayed 51285 seconds by postgrey-1.27 at vger.kernel.org; Mon, 06 Jan 2014 05:52:29 EST
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
Cc: Yann Droneaud <ydroneaud@opteya.com>, linux-kernel@vger.kernel.org,
        Peter Zijlstra <peterz@infradead.org>
Subject: [PATCH] perf tools: enable close-on-exec flag on perf file descriptor
Date: Mon,  6 Jan 2014 11:51:25 +0100
Message-Id: <1389005485-12778-1-git-send-email-ydroneaud@opteya.com>
X-Mailer: git-send-email 1.8.4.2
References: <cover.1388952061.git.ydroneaud@opteya.com> <8c03f54e1598b1727c19706f3af03f98685d9fe6.1388952061.git.ydroneaud@opteya.com> <20140106092929.GA31570@twins.programming.kicks-ass.net>
In-Reply-To: <20140106092929.GA31570@twins.programming.kicks-ass.net> 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In a previous patch [1][2], flag PERF_FLAG_FD_CLOEXEC was
added to perf_event_open(2) syscall to allows userspace
to enable close-on-exec behavor atomically when creating
the file descriptor.

This patch makes perf tools use the new flag.

Beware that perf tools compiled with the new flag won't work
on older kernel which do not support flag PERF_FLAG_FD_CLOEXEC.

[1] http://lkml.kernel.org/r/8c03f54e1598b1727c19706f3af03f98685d9fe6.1388952061.git.ydroneaud@opteya.com
[2] https://patchwork.kernel.org/patch/3434971/

Cc: Peter Zijlstra <peterz@infradead.org>
Signed-off-by: Yann Droneaud <ydroneaud@opteya.com>
Link: http://lkml.kernel.org/r/cover.1388952061.git.ydroneaud@opteya.com
---
 tools/perf/bench/mem-memcpy.c               | 3 ++-
 tools/perf/bench/mem-memset.c               | 3 ++-
 tools/perf/builtin-sched.c                  | 2 +-
 tools/perf/tests/bp_signal.c                | 2 +-
 tools/perf/tests/bp_signal_overflow.c       | 2 +-
 tools/perf/tests/rdpmc.c                    | 2 +-
 tools/perf/util/evsel.c                     | 4 ++--
 tools/perf/util/record.c                    | 9 ++++++---
 tools/testing/selftests/powerpc/pmu/event.c | 3 ++-
 9 files changed, 18 insertions(+), 12 deletions(-)

diff --git a/tools/perf/bench/mem-memcpy.c b/tools/perf/bench/mem-memcpy.c
index 5ce71d3b72cf..c1be6c17b382 100644
--- a/tools/perf/bench/mem-memcpy.c
+++ b/tools/perf/bench/mem-memcpy.c
@@ -83,7 +83,8 @@ static struct perf_event_attr cycle_attr = {
 
 static void init_cycle(void)
 {
-	cycle_fd = sys_perf_event_open(&cycle_attr, getpid(), -1, -1, 0);
+	cycle_fd = sys_perf_event_open(&cycle_attr, getpid(), -1, -1,
+				       PERF_FLAG_FD_CLOEXEC);
 
 	if (cycle_fd < 0 && errno == ENOSYS)
 		die("No CONFIG_PERF_EVENTS=y kernel support configured?\n");
diff --git a/tools/perf/bench/mem-memset.c b/tools/perf/bench/mem-memset.c
index 9af79d2b18e5..3b92b7da9cf2 100644
--- a/tools/perf/bench/mem-memset.c
+++ b/tools/perf/bench/mem-memset.c
@@ -83,7 +83,8 @@ static struct perf_event_attr cycle_attr = {
 
 static void init_cycle(void)
 {
-	cycle_fd = sys_perf_event_open(&cycle_attr, getpid(), -1, -1, 0);
+	cycle_fd = sys_perf_event_open(&cycle_attr, getpid(), -1, -1,
+				       PERF_FLAG_FD_CLOEXEC);
 
 	if (cycle_fd < 0 && errno == ENOSYS)
 		die("No CONFIG_PERF_EVENTS=y kernel support configured?\n");
diff --git a/tools/perf/builtin-sched.c b/tools/perf/builtin-sched.c
index 0f3c65518a2c..933a15783a54 100644
--- a/tools/perf/builtin-sched.c
+++ b/tools/perf/builtin-sched.c
@@ -435,7 +435,7 @@ static int self_open_counters(void)
 	attr.type = PERF_TYPE_SOFTWARE;
 	attr.config = PERF_COUNT_SW_TASK_CLOCK;
 
-	fd = sys_perf_event_open(&attr, 0, -1, -1, 0);
+	fd = sys_perf_event_open(&attr, 0, -1, -1, PERF_FLAG_FD_CLOEXEC);
 
 	if (fd < 0)
 		pr_err("Error: sys_perf_event_open() syscall returned "
diff --git a/tools/perf/tests/bp_signal.c b/tools/perf/tests/bp_signal.c
index aba095489193..de33526ff9d6 100644
--- a/tools/perf/tests/bp_signal.c
+++ b/tools/perf/tests/bp_signal.c
@@ -78,7 +78,7 @@ static int bp_event(void *fn, int setup_signal)
 	pe.exclude_kernel = 1;
 	pe.exclude_hv = 1;
 
-	fd = sys_perf_event_open(&pe, 0, -1, -1, 0);
+	fd = sys_perf_event_open(&pe, 0, -1, -1, PERF_FLAG_FD_CLOEXEC);
 	if (fd < 0) {
 		pr_debug("failed opening event %llx\n", pe.config);
 		return TEST_FAIL;
diff --git a/tools/perf/tests/bp_signal_overflow.c b/tools/perf/tests/bp_signal_overflow.c
index 44ac82179708..e54bf622adb2 100644
--- a/tools/perf/tests/bp_signal_overflow.c
+++ b/tools/perf/tests/bp_signal_overflow.c
@@ -91,7 +91,7 @@ int test__bp_signal_overflow(void)
 	pe.exclude_kernel = 1;
 	pe.exclude_hv = 1;
 
-	fd = sys_perf_event_open(&pe, 0, -1, -1, 0);
+	fd = sys_perf_event_open(&pe, 0, -1, -1, PERF_FLAG_FD_CLOEXEC);
 	if (fd < 0) {
 		pr_debug("failed opening event %llx\n", pe.config);
 		return TEST_FAIL;
diff --git a/tools/perf/tests/rdpmc.c b/tools/perf/tests/rdpmc.c
index 46649c25fa5e..46664eca77af 100644
--- a/tools/perf/tests/rdpmc.c
+++ b/tools/perf/tests/rdpmc.c
@@ -104,7 +104,7 @@ static int __test__rdpmc(void)
 	sa.sa_sigaction = segfault_handler;
 	sigaction(SIGSEGV, &sa, NULL);
 
-	fd = sys_perf_event_open(&attr, 0, -1, -1, 0);
+	fd = sys_perf_event_open(&attr, 0, -1, -1, PERF_FLAG_FD_CLOEXEC);
 	if (fd < 0) {
 		pr_err("Error: sys_perf_event_open() syscall returned "
 		       "with %d (%s)\n", fd, strerror(errno));
diff --git a/tools/perf/util/evsel.c b/tools/perf/util/evsel.c
index 01ff4cfde1f5..8f5d6bc2ad3e 100644
--- a/tools/perf/util/evsel.c
+++ b/tools/perf/util/evsel.c
@@ -970,7 +970,7 @@ static int __perf_evsel__open(struct perf_evsel *evsel, struct cpu_map *cpus,
 			      struct thread_map *threads)
 {
 	int cpu, thread;
-	unsigned long flags = 0;
+	unsigned long flags = PERF_FLAG_FD_CLOEXEC;
 	int pid = -1, err;
 	enum { NO_CHANGE, SET_TO_MAX, INCREASED_MAX } set_rlimit = NO_CHANGE;
 
@@ -979,7 +979,7 @@ static int __perf_evsel__open(struct perf_evsel *evsel, struct cpu_map *cpus,
 		return -ENOMEM;
 
 	if (evsel->cgrp) {
-		flags = PERF_FLAG_PID_CGROUP;
+		flags |= PERF_FLAG_PID_CGROUP;
 		pid = evsel->cgrp->fd;
 	}
 
diff --git a/tools/perf/util/record.c b/tools/perf/util/record.c
index e5104538c354..1146fa9003ab 100644
--- a/tools/perf/util/record.c
+++ b/tools/perf/util/record.c
@@ -22,14 +22,16 @@ static int perf_do_probe_api(setup_probe_fn_t fn, int cpu, const char *str)
 
 	evsel = perf_evlist__first(evlist);
 
-	fd = sys_perf_event_open(&evsel->attr, -1, cpu, -1, 0);
+	fd = sys_perf_event_open(&evsel->attr, -1, cpu, -1,
+				 PERF_FLAG_FD_CLOEXEC);
 	if (fd < 0)
 		goto out_delete;
 	close(fd);
 
 	fn(evsel);
 
-	fd = sys_perf_event_open(&evsel->attr, -1, cpu, -1, 0);
+	fd = sys_perf_event_open(&evsel->attr, -1, cpu, -1,
+				 PERF_FLAG_FD_CLOEXEC);
 	if (fd < 0) {
 		if (errno == EINVAL)
 			err = -EINVAL;
@@ -204,7 +206,8 @@ bool perf_evlist__can_select_event(struct perf_evlist *evlist, const char *str)
 		cpu = evlist->cpus->map[0];
 	}
 
-	fd = sys_perf_event_open(&evsel->attr, -1, cpu, -1, 0);
+	fd = sys_perf_event_open(&evsel->attr, -1, cpu, -1,
+				 PERF_FLAG_FD_CLOEXEC);
 	if (fd >= 0) {
 		close(fd);
 		ret = true;
diff --git a/tools/testing/selftests/powerpc/pmu/event.c b/tools/testing/selftests/powerpc/pmu/event.c
index 2b2d11df2450..a705e42b6132 100644
--- a/tools/testing/selftests/powerpc/pmu/event.c
+++ b/tools/testing/selftests/powerpc/pmu/event.c
@@ -45,7 +45,8 @@ void event_init_named(struct event *e, u64 config, char *name)
 
 int event_open_with_options(struct event *e, pid_t pid, int cpu, int group_fd)
 {
-	e->fd = perf_event_open(&e->attr, pid, cpu, group_fd, 0);
+	e->fd = perf_event_open(&e->attr, pid, cpu, group_fd,
+				PERF_FLAG_FD_CLOEXEC);
 	if (e->fd == -1) {
 		perror("perf_event_open");
 		return -1;
-- 
1.8.4.2

