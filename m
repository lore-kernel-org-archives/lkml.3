Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752300AbaHOQvL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Aug 2014 12:51:11 -0400
Received: from mail.kernel.org ([198.145.19.201]:44810 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752248AbaHOQvI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Aug 2014 12:51:08 -0400
From: Arnaldo Carvalho de Melo <acme@kernel.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Ingo Molnar <mingo@redhat.com>, Namhyung Kim <namhyung@kernel.org>,
        Naohiro Aota <naota@elisp.net>, Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 13/18] perf test: Use strerror_r instead of strerror
Date: Fri, 15 Aug 2014 13:49:58 -0300
Message-Id: <1408121403-11919-14-git-send-email-acme@kernel.org>
X-Mailer: git-send-email 1.9.3
In-Reply-To: <1408121403-11919-1-git-send-email-acme@kernel.org>
References: <1408121403-11919-1-git-send-email-acme@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>

Use strerror_r instead of strerror in error messages for thread-safety.

Signed-off-by: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Naohiro Aota <naota@elisp.net>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Link: http://lkml.kernel.org/r/20140814022245.3545.91394.stgit@kbuild-fedora.novalocal
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/tests/builtin-test.c           |  4 +++-
 tools/perf/tests/mmap-basic.c             |  7 ++++---
 tools/perf/tests/open-syscall-all-cpus.c  |  5 +++--
 tools/perf/tests/open-syscall-tp-fields.c |  7 +++++--
 tools/perf/tests/open-syscall.c           |  3 ++-
 tools/perf/tests/perf-record.c            | 13 +++++++++----
 tools/perf/tests/rdpmc.c                  |  6 ++++--
 tools/perf/tests/sw-clock.c               |  6 ++++--
 tools/perf/tests/task-exit.c              |  6 ++++--
 9 files changed, 38 insertions(+), 19 deletions(-)

diff --git a/tools/perf/tests/builtin-test.c b/tools/perf/tests/builtin-test.c
index c6796d22423a..99481361b19f 100644
--- a/tools/perf/tests/builtin-test.c
+++ b/tools/perf/tests/builtin-test.c
@@ -185,9 +185,11 @@ static bool perf_test__matches(int curr, int argc, const char *argv[])
 static int run_test(struct test *test)
 {
 	int status, err = -1, child = fork();
+	char sbuf[STRERR_BUFSIZE];
 
 	if (child < 0) {
-		pr_err("failed to fork test: %s\n", strerror(errno));
+		pr_err("failed to fork test: %s\n",
+			strerror_r(errno, sbuf, sizeof(sbuf)));
 		return -1;
 	}
 
diff --git a/tools/perf/tests/mmap-basic.c b/tools/perf/tests/mmap-basic.c
index 142263492f6f..9b9622a33932 100644
--- a/tools/perf/tests/mmap-basic.c
+++ b/tools/perf/tests/mmap-basic.c
@@ -31,6 +31,7 @@ int test__basic_mmap(void)
 	unsigned int nr_events[nsyscalls],
 		     expected_nr_events[nsyscalls], i, j;
 	struct perf_evsel *evsels[nsyscalls], *evsel;
+	char sbuf[STRERR_BUFSIZE];
 
 	threads = thread_map__new(-1, getpid(), UINT_MAX);
 	if (threads == NULL) {
@@ -49,7 +50,7 @@ int test__basic_mmap(void)
 	sched_setaffinity(0, sizeof(cpu_set), &cpu_set);
 	if (sched_setaffinity(0, sizeof(cpu_set), &cpu_set) < 0) {
 		pr_debug("sched_setaffinity() failed on CPU %d: %s ",
-			 cpus->map[0], strerror(errno));
+			 cpus->map[0], strerror_r(errno, sbuf, sizeof(sbuf)));
 		goto out_free_cpus;
 	}
 
@@ -79,7 +80,7 @@ int test__basic_mmap(void)
 		if (perf_evsel__open(evsels[i], cpus, threads) < 0) {
 			pr_debug("failed to open counter: %s, "
 				 "tweak /proc/sys/kernel/perf_event_paranoid?\n",
-				 strerror(errno));
+				 strerror_r(errno, sbuf, sizeof(sbuf)));
 			goto out_delete_evlist;
 		}
 
@@ -89,7 +90,7 @@ int test__basic_mmap(void)
 
 	if (perf_evlist__mmap(evlist, 128, true) < 0) {
 		pr_debug("failed to mmap events: %d (%s)\n", errno,
-			 strerror(errno));
+			 strerror_r(errno, sbuf, sizeof(sbuf)));
 		goto out_delete_evlist;
 	}
 
diff --git a/tools/perf/tests/open-syscall-all-cpus.c b/tools/perf/tests/open-syscall-all-cpus.c
index 5fecdbd2f5f7..8fa82d1700c7 100644
--- a/tools/perf/tests/open-syscall-all-cpus.c
+++ b/tools/perf/tests/open-syscall-all-cpus.c
@@ -12,6 +12,7 @@ int test__open_syscall_event_on_all_cpus(void)
 	unsigned int nr_open_calls = 111, i;
 	cpu_set_t cpu_set;
 	struct thread_map *threads = thread_map__new(-1, getpid(), UINT_MAX);
+	char sbuf[STRERR_BUFSIZE];
 
 	if (threads == NULL) {
 		pr_debug("thread_map__new\n");
@@ -35,7 +36,7 @@ int test__open_syscall_event_on_all_cpus(void)
 	if (perf_evsel__open(evsel, cpus, threads) < 0) {
 		pr_debug("failed to open counter: %s, "
 			 "tweak /proc/sys/kernel/perf_event_paranoid?\n",
-			 strerror(errno));
+			 strerror_r(errno, sbuf, sizeof(sbuf)));
 		goto out_evsel_delete;
 	}
 
@@ -56,7 +57,7 @@ int test__open_syscall_event_on_all_cpus(void)
 		if (sched_setaffinity(0, sizeof(cpu_set), &cpu_set) < 0) {
 			pr_debug("sched_setaffinity() failed on CPU %d: %s ",
 				 cpus->map[cpu],
-				 strerror(errno));
+				 strerror_r(errno, sbuf, sizeof(sbuf)));
 			goto out_close_fd;
 		}
 		for (i = 0; i < ncalls; ++i) {
diff --git a/tools/perf/tests/open-syscall-tp-fields.c b/tools/perf/tests/open-syscall-tp-fields.c
index 0785b64ffd6c..922bdb627950 100644
--- a/tools/perf/tests/open-syscall-tp-fields.c
+++ b/tools/perf/tests/open-syscall-tp-fields.c
@@ -22,6 +22,7 @@ int test__syscall_open_tp_fields(void)
 	struct perf_evlist *evlist = perf_evlist__new();
 	struct perf_evsel *evsel;
 	int err = -1, i, nr_events = 0, nr_polls = 0;
+	char sbuf[STRERR_BUFSIZE];
 
 	if (evlist == NULL) {
 		pr_debug("%s: perf_evlist__new\n", __func__);
@@ -48,13 +49,15 @@ int test__syscall_open_tp_fields(void)
 
 	err = perf_evlist__open(evlist);
 	if (err < 0) {
-		pr_debug("perf_evlist__open: %s\n", strerror(errno));
+		pr_debug("perf_evlist__open: %s\n",
+			 strerror_r(errno, sbuf, sizeof(sbuf)));
 		goto out_delete_evlist;
 	}
 
 	err = perf_evlist__mmap(evlist, UINT_MAX, false);
 	if (err < 0) {
-		pr_debug("perf_evlist__mmap: %s\n", strerror(errno));
+		pr_debug("perf_evlist__mmap: %s\n",
+			 strerror_r(errno, sbuf, sizeof(sbuf)));
 		goto out_delete_evlist;
 	}
 
diff --git a/tools/perf/tests/open-syscall.c b/tools/perf/tests/open-syscall.c
index c1dc7d25f38c..a33b2daae40f 100644
--- a/tools/perf/tests/open-syscall.c
+++ b/tools/perf/tests/open-syscall.c
@@ -9,6 +9,7 @@ int test__open_syscall_event(void)
 	struct perf_evsel *evsel;
 	unsigned int nr_open_calls = 111, i;
 	struct thread_map *threads = thread_map__new(-1, getpid(), UINT_MAX);
+	char sbuf[STRERR_BUFSIZE];
 
 	if (threads == NULL) {
 		pr_debug("thread_map__new\n");
@@ -24,7 +25,7 @@ int test__open_syscall_event(void)
 	if (perf_evsel__open_per_thread(evsel, threads) < 0) {
 		pr_debug("failed to open counter: %s, "
 			 "tweak /proc/sys/kernel/perf_event_paranoid?\n",
-			 strerror(errno));
+			 strerror_r(errno, sbuf, sizeof(sbuf)));
 		goto out_evsel_delete;
 	}
 
diff --git a/tools/perf/tests/perf-record.c b/tools/perf/tests/perf-record.c
index aca1a83dd13a..2ce753c1db63 100644
--- a/tools/perf/tests/perf-record.c
+++ b/tools/perf/tests/perf-record.c
@@ -59,6 +59,7 @@ int test__PERF_RECORD(void)
 	int err = -1, errs = 0, i, wakeups = 0;
 	u32 cpu;
 	int total_events = 0, nr_events[PERF_RECORD_MAX] = { 0, };
+	char sbuf[STRERR_BUFSIZE];
 
 	if (evlist == NULL || argv == NULL) {
 		pr_debug("Not enough memory to create evlist\n");
@@ -100,7 +101,8 @@ int test__PERF_RECORD(void)
 
 	err = sched__get_first_possible_cpu(evlist->workload.pid, &cpu_mask);
 	if (err < 0) {
-		pr_debug("sched__get_first_possible_cpu: %s\n", strerror(errno));
+		pr_debug("sched__get_first_possible_cpu: %s\n",
+			 strerror_r(errno, sbuf, sizeof(sbuf)));
 		goto out_delete_evlist;
 	}
 
@@ -110,7 +112,8 @@ int test__PERF_RECORD(void)
 	 * So that we can check perf_sample.cpu on all the samples.
 	 */
 	if (sched_setaffinity(evlist->workload.pid, cpu_mask_size, &cpu_mask) < 0) {
-		pr_debug("sched_setaffinity: %s\n", strerror(errno));
+		pr_debug("sched_setaffinity: %s\n",
+			 strerror_r(errno, sbuf, sizeof(sbuf)));
 		goto out_delete_evlist;
 	}
 
@@ -120,7 +123,8 @@ int test__PERF_RECORD(void)
 	 */
 	err = perf_evlist__open(evlist);
 	if (err < 0) {
-		pr_debug("perf_evlist__open: %s\n", strerror(errno));
+		pr_debug("perf_evlist__open: %s\n",
+			 strerror_r(errno, sbuf, sizeof(sbuf)));
 		goto out_delete_evlist;
 	}
 
@@ -131,7 +135,8 @@ int test__PERF_RECORD(void)
 	 */
 	err = perf_evlist__mmap(evlist, opts.mmap_pages, false);
 	if (err < 0) {
-		pr_debug("perf_evlist__mmap: %s\n", strerror(errno));
+		pr_debug("perf_evlist__mmap: %s\n",
+			 strerror_r(errno, sbuf, sizeof(sbuf)));
 		goto out_delete_evlist;
 	}
 
diff --git a/tools/perf/tests/rdpmc.c b/tools/perf/tests/rdpmc.c
index c04d1f268576..d31f2c4d9f64 100644
--- a/tools/perf/tests/rdpmc.c
+++ b/tools/perf/tests/rdpmc.c
@@ -100,6 +100,7 @@ static int __test__rdpmc(void)
 	};
 	u64 delta_sum = 0;
         struct sigaction sa;
+	char sbuf[STRERR_BUFSIZE];
 
 	sigfillset(&sa.sa_mask);
 	sa.sa_sigaction = segfault_handler;
@@ -109,14 +110,15 @@ static int __test__rdpmc(void)
 				 perf_event_open_cloexec_flag());
 	if (fd < 0) {
 		pr_err("Error: sys_perf_event_open() syscall returned "
-		       "with %d (%s)\n", fd, strerror(errno));
+		       "with %d (%s)\n", fd,
+		       strerror_r(errno, sbuf, sizeof(sbuf)));
 		return -1;
 	}
 
 	addr = mmap(NULL, page_size, PROT_READ, MAP_SHARED, fd, 0);
 	if (addr == (void *)(-1)) {
 		pr_err("Error: mmap() syscall returned with (%s)\n",
-		       strerror(errno));
+		       strerror_r(errno, sbuf, sizeof(sbuf)));
 		goto out_close;
 	}
 
diff --git a/tools/perf/tests/sw-clock.c b/tools/perf/tests/sw-clock.c
index 983d6b8562a8..1aa21c90731b 100644
--- a/tools/perf/tests/sw-clock.c
+++ b/tools/perf/tests/sw-clock.c
@@ -22,6 +22,7 @@ static int __test__sw_clock_freq(enum perf_sw_ids clock_id)
 	volatile int tmp = 0;
 	u64 total_periods = 0;
 	int nr_samples = 0;
+	char sbuf[STRERR_BUFSIZE];
 	union perf_event *event;
 	struct perf_evsel *evsel;
 	struct perf_evlist *evlist;
@@ -62,14 +63,15 @@ static int __test__sw_clock_freq(enum perf_sw_ids clock_id)
 
 		err = -errno;
 		pr_debug("Couldn't open evlist: %s\nHint: check %s, using %" PRIu64 " in this test.\n",
-			 strerror(errno), knob, (u64)attr.sample_freq);
+			 strerror_r(errno, sbuf, sizeof(sbuf)),
+			 knob, (u64)attr.sample_freq);
 		goto out_delete_evlist;
 	}
 
 	err = perf_evlist__mmap(evlist, 128, true);
 	if (err < 0) {
 		pr_debug("failed to mmap event: %d (%s)\n", errno,
-			 strerror(errno));
+			 strerror_r(errno, sbuf, sizeof(sbuf)));
 		goto out_delete_evlist;
 	}
 
diff --git a/tools/perf/tests/task-exit.c b/tools/perf/tests/task-exit.c
index 5ff3db318f12..87522f01c7ad 100644
--- a/tools/perf/tests/task-exit.c
+++ b/tools/perf/tests/task-exit.c
@@ -42,6 +42,7 @@ int test__task_exit(void)
 		.uses_mmap	= true,
 	};
 	const char *argv[] = { "true", NULL };
+	char sbuf[STRERR_BUFSIZE];
 
 	signal(SIGCHLD, sig_handler);
 
@@ -82,13 +83,14 @@ int test__task_exit(void)
 
 	err = perf_evlist__open(evlist);
 	if (err < 0) {
-		pr_debug("Couldn't open the evlist: %s\n", strerror(-err));
+		pr_debug("Couldn't open the evlist: %s\n",
+			 strerror_r(-err, sbuf, sizeof(sbuf)));
 		goto out_delete_evlist;
 	}
 
 	if (perf_evlist__mmap(evlist, 128, true) < 0) {
 		pr_debug("failed to mmap events: %d (%s)\n", errno,
-			 strerror(errno));
+			 strerror_r(errno, sbuf, sizeof(sbuf)));
 		goto out_delete_evlist;
 	}
 
-- 
1.9.3

