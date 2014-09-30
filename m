Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751613AbaI3XuU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Sep 2014 19:50:20 -0400
Received: from g9t1613g.houston.hp.com ([15.240.0.71]:46131 "EHLO
	g9t1613g.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751182AbaI3XuQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Sep 2014 19:50:16 -0400
Message-ID: <1412120999.2941.11.camel@u64>
Subject: [RFC PATCH] Perf Bench: Locking Microbenchmark
From: Tuan Bui <tuan.d.bui@hp.com>
To: linux-kernel@vger.kernel.org
Cc: dbueso@suse.de, a.p.zijlstra@chello.nl, paulus@samba.org, acme@kernel.org,
        artagnon@gmail.com, jolsa@redhat.com, dvhart@linux.intel.com,
        Aswin Chandramouleeswaran <aswin@hp.com>,
        Jason Low <jason.low2@hp.com>, akpm@linux-foundation.org,
        mingo@kernel.org, Tuan Bui <tuan.d.bui@hp.com>
Date: Tue, 30 Sep 2014 16:49:59 -0700
Organization: HP
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Subject: [RFC PATCH] Perf Bench: Locking Microbenchmark

In response to this thread https://lkml.org/lkml/2014/2/11/93, this is
a micro benchmark that stresses locking contention in the kernel with
creat(2) system call by spawning multiple processes to spam this system
call.  This workload generate similar results and contentions in AIM7
fserver workload but can generate outputs within seconds.

With the creat(2) system call the contention vary on what locks are used
in the particular file system. I have ran this benchmark only on ext4
and xfs file system.

Running the creat workload on ext4 show contention in the mutex lock
that is used by ext4_orphan_add() and ext4_orphan_del() to add or delete
an inode from the list of inodes. At the same time running the creat
workload on xfs show contention in the spinlock that is used by
xsf_log_commit_cil() to commit a transaction to the Committed Item List.

Here is a comparison of this benchmark with AIM7 running fserver workload
at 500-1000 users along with a perf trace running on ext4 file system.

Test machine is a 8-sockets 80 cores Westmere system HT-off on v3.17-rc6.

	AIM7		AIM7		perf-bench	perf-bench
Users	Jobs/min	Jobs/min/child	Ops/sec		Ops/sec/child
500	119668.25	239.34		104249		208
600	126074.90	210.12		106136		176
700	128662.42	183.80		106175		151
800	119822.05	149.78		106290		132
900	106150.25	117.94		105230		116
1000	104681.29	104.68		106489		106

Perf trace for AIM7 fserver:
14.51%	reaim  		[kernel.kallsyms]	[k] osq_lock
4.98%	reaim  		reaim			[.] add_long
4.98%	reaim  		reaim			[.] add_int
4.31%	reaim  		[kernel.kallsyms]	[k] mutex_spin_on_owner
...

Perf trace of perf bench creat
22.37%	locking-creat  [kernel.kallsyms]	[k] osq_lock
5.77%	locking-creat  [kernel.kallsyms]	[k] mutex_spin_on_owner
5.31%	locking-creat  [kernel.kallsyms]	[k] _raw_spin_lock
5.15%	locking-creat  [jbd2]			[k] jbd2_journal_put_journal_head
...

Signed-off-by: Tuan Bui <tuan.d.bui@hp.com>
---
 tools/perf/Documentation/perf-bench.txt |    8 ++
 tools/perf/Makefile.perf                |    1 +
 tools/perf/bench/bench.h                |    1 +
 tools/perf/bench/locking.c              |  234 +++++++++++++++++++++++++++++++
 tools/perf/builtin-bench.c              |    8 ++
 5 files changed, 252 insertions(+)
 create mode 100644 tools/perf/bench/locking.c

diff --git a/tools/perf/Documentation/perf-bench.txt b/tools/perf/Documentation/perf-bench.txt
index f6480cb..e679135 100644
--- a/tools/perf/Documentation/perf-bench.txt
+++ b/tools/perf/Documentation/perf-bench.txt
@@ -58,6 +58,9 @@ SUBSYSTEM
 'futex'::
 	Futex stressing benchmarks.
 
+'locking'::
+        Locking stressing benchmarks.
+
 'all'::
 	All benchmark subsystems.
 
@@ -213,6 +216,11 @@ Suite for evaluating wake calls.
 *requeue*::
 Suite for evaluating requeue calls.
 
+SUITES FOR 'locking'
+~~~~~~~~~~~~~~~~~~
+*creat*::
+Suite for evaluating locking contention through creat(2).
+
 SEE ALSO
 --------
 linkperf:perf[1]
diff --git a/tools/perf/Makefile.perf b/tools/perf/Makefile.perf
index 2240974..e5a9d23 100644
--- a/tools/perf/Makefile.perf
+++ b/tools/perf/Makefile.perf
@@ -438,6 +438,7 @@ BUILTIN_OBJS += $(OUTPUT)bench/mem-memset.o
 BUILTIN_OBJS += $(OUTPUT)bench/futex-hash.o
 BUILTIN_OBJS += $(OUTPUT)bench/futex-wake.o
 BUILTIN_OBJS += $(OUTPUT)bench/futex-requeue.o
+BUILTIN_OBJS += $(OUTPUT)bench/locking.o
 
 BUILTIN_OBJS += $(OUTPUT)builtin-diff.o
 BUILTIN_OBJS += $(OUTPUT)builtin-evlist.o
diff --git a/tools/perf/bench/bench.h b/tools/perf/bench/bench.h
index 3c4dd44..d31c0ba 100644
--- a/tools/perf/bench/bench.h
+++ b/tools/perf/bench/bench.h
@@ -34,6 +34,7 @@ extern int bench_mem_memset(int argc, const char **argv, const char *prefix);
 extern int bench_futex_hash(int argc, const char **argv, const char *prefix);
 extern int bench_futex_wake(int argc, const char **argv, const char *prefix);
 extern int bench_futex_requeue(int argc, const char **argv, const char *prefix);
+extern int bench_locking_creat(int argc, const char **argv, const char *prefix);
 
 #define BENCH_FORMAT_DEFAULT_STR	"default"
 #define BENCH_FORMAT_DEFAULT		0
diff --git a/tools/perf/bench/locking.c b/tools/perf/bench/locking.c
new file mode 100644
index 0000000..8cbe8a6
--- /dev/null
+++ b/tools/perf/bench/locking.c
@@ -0,0 +1,234 @@
+/*
+ * locking.c
+ *
+ * Simple micro benchmark that stress kernel locking contention with
+ * creat(2) system call by spawning multiple processes to call
+ * this system call.
+ *
+ * Results output are average operations/sec for all threads and
+ * average operations/sec per threads.
+ *
+ * Tuan Bui <tuan.d.bui@hp.com>
+ */
+
+#include "../perf.h"
+#include "../util/util.h"
+#include "../util/stat.h"
+#include "../util/parse-options.h"
+#include "../util/header.h"
+#include "bench.h"
+
+#include <err.h>
+#include <stdlib.h>
+#include <sys/time.h>
+#include <unistd.h>
+#include <sys/resource.h>
+#include <linux/futex.h>
+#include <sys/mman.h>
+#include <sys/syscall.h>
+#include <sys/types.h>
+#include <signal.h>
+#include <dirent.h>
+
+struct worker {
+	pid_t pid;
+	unsigned int order_id;
+	char str[50];
+};
+
+struct timeval start, end, total;
+static unsigned int start_nr_threads = 100;
+static unsigned int end_nr_threads = 1100;
+static unsigned int increment_threads_by = 100;
+static unsigned int bench_dur = 5;
+
+/* Shared variables between fork processes*/
+unsigned int *finished, *setup;
+unsigned long long *shared_workers;
+/* all processes will block on the same futex */
+u_int32_t *futex;
+
+static const struct option options[] = {
+	OPT_UINTEGER('s', "start", &start_nr_threads, "Numbers of processes to start"),
+	OPT_UINTEGER('e', "end", &end_nr_threads, "Numbers of process to end"),
+	OPT_UINTEGER('i', "increment", &increment_threads_by, "Number of threads to increment)"),
+	OPT_UINTEGER('r', "runtime", &bench_dur, "Specify benchmark runtime in seconds"),
+	OPT_END()
+};
+
+static const char * const bench_locking_creat_usage[] = {
+	"perf bench locking creat <options>",
+	NULL
+};
+
+/* Running bench creat workload */
+static void *run_bench_creat(struct worker *workers)
+{
+	int fd;
+	unsigned long long nr_ops = 0;
+	int ret;
+
+	sprintf(workers->str, "%d-XXXXXX", getpid());
+	ret = mkstemp(workers->str);
+	if (ret < 0)
+		err(EXIT_FAILURE, "mkstemp");
+
+	/* Signal to parent process and wait till all threads are ready run */
+	setup[workers->order_id] = 1;
+	syscall(SYS_futex, futex, FUTEX_WAIT, 0, NULL, NULL, 0);
+
+	/* Start of the benchmark keep looping till parent process signal completion */
+	while (!*finished) {
+		fd = creat(workers->str, S_IRWXU);
+		if (fd < 0)
+			err(EXIT_FAILURE, "creat");
+		nr_ops++;
+		close(fd);
+	}
+
+	unlink(workers->str);
+	shared_workers[workers->order_id] = nr_ops;
+	setup[workers->order_id] = 0;
+	exit(0);
+}
+
+/* Setting shared variable finished and shared_workers */
+static void setup_shared(void)
+{
+	unsigned int *finished_tmp, *setup_tmp;
+	unsigned long long *shared_workers_tmp;
+	u_int32_t *futex_tmp;
+
+	/* finished shared var is use to signal start and end of benchmark */
+	finished_tmp = (void *)mmap(0, sizeof(unsigned int), PROT_READ|PROT_WRITE,
+			MAP_SHARED|MAP_ANONYMOUS, -1, 0);
+	if (finished_tmp == (void *) -1)
+		err(EXIT_FAILURE, "mmap finished");
+	finished = finished_tmp;
+
+	/* shared_workers is an array of ops perform by each process */
+	shared_workers_tmp = (void *)mmap(0, sizeof(unsigned long long)*end_nr_threads,
+			PROT_READ|PROT_WRITE, MAP_SHARED|MAP_ANONYMOUS, -1, 0);
+	if (shared_workers_tmp == (void *) -1)
+		err(EXIT_FAILURE, "mmap shared_workers");
+	shared_workers = shared_workers_tmp;
+
+	/* setup is use for each processes to signal that it is done
+	 * setting up for the benchmark and is ready to run */
+	setup_tmp = (void *)mmap(0, sizeof(unsigned int)*end_nr_threads,
+			PROT_READ|PROT_WRITE, MAP_SHARED|MAP_ANONYMOUS, -1, 0);
+	if (setup_tmp == (void *) -1)
+		err(EXIT_FAILURE, "mmap shared_workers");
+	setup = setup_tmp;
+
+	/* Processes will sleep on this futex until all other processes
+	 * are done setting up and are ready to run */
+	futex_tmp = (void *)mmap(0, sizeof(u_int32_t *), PROT_READ|PROT_WRITE,
+			MAP_SHARED|MAP_ANONYMOUS, -1, 0);
+	if (futex_tmp == (void *) -1)
+		err(EXIT_FAILURE, "mmap finished");
+	futex = futex_tmp;
+	(*futex) = 0;
+}
+
+/* Freeing shared variables */
+static void free_resources(void)
+{
+	if ((munmap(finished, sizeof(unsigned int)) == -1))
+		err(EXIT_FAILURE, "munmap finished");
+
+	if ((munmap(shared_workers, sizeof(unsigned long long) * end_nr_threads) == -1))
+		err(EXIT_FAILURE, "munmap shared_workers");
+
+	if ((munmap(setup, sizeof(unsigned int) * end_nr_threads) == -1))
+		err(EXIT_FAILURE, "munmap shared_workers");
+
+	if ((munmap(futex, sizeof(u_int32_t))) == -1)
+		err(EXIT_FAILURE, "munmap finished");
+}
+
+/* Start to spawn workers and wait till all workers have been
+ * created before starting workload */
+static void spawn_workers(void *(*bench_ptr) (struct worker *))
+{
+	pid_t parent, child;
+	unsigned int i, j, k;
+	struct worker workers;
+	unsigned long long total_ops;
+	unsigned int total_workers;
+
+	parent = getpid();
+	setup_shared();
+
+	/* This loop through all the run each is increment by increment_threads_by */
+	for (i = start_nr_threads; i <= end_nr_threads; i += increment_threads_by) {
+
+		for (j = 0; j < i; j++) {
+			if (!fork())
+				break;
+		}
+
+		child = getpid();
+		/* Initialize child worker struct and run benchmark */
+		if (child != parent) {
+			workers.order_id = j;
+			workers.pid = child;
+			bench_ptr(&workers);
+		}
+		/* Parent to sleep during the duration of benchmark */
+		else{
+			/* Make sure all child process are created and setup
+			 * before starting benchmark for bench_dur durations */
+			do {
+				total_workers = 0;
+				for (k = 0; k < i; k++)
+					total_workers = total_workers + setup[k];
+			} while (total_workers != i);
+
+			/* Wake up all sleeping process to run the benchmark */
+			(*futex) = 1;
+			syscall(SYS_futex, futex, FUTEX_WAKE, i, NULL, NULL, 0);
+
+			/* All proccesses are ready signal them to run */
+			gettimeofday(&start, NULL);
+			sleep(bench_dur);
+			(*finished) = 1;
+			gettimeofday(&end, NULL);
+			timersub(&end, &start, &total);
+
+			/* Wait for all process to terminate before getting outputs */
+			for (k = 0; k < i; k++)
+				wait(NULL);
+
+			/* Sum up all the ops by each process and report */
+			total_ops = 0;
+			for (k = 0; k < i; k++)
+				total_ops = total_ops + shared_workers[k];
+
+			printf("\n%6d threads: throughput = %llu average opts/sec all threads\n",
+				i, (total_ops / total.tv_sec));
+
+			printf("%6d threads: throughput = %llu average opts/sec per thread\n",
+				i, ((total_ops/total.tv_sec)/(!i ? 1:i)));
+
+			/* Reset back to 0 for next run */
+			(*finished) = 0;
+			(*futex) = 1;
+		}
+	}
+}
+
+int bench_locking_creat(int argc, const char **argv,
+			const char *prefix __maybe_unused)
+{
+	argc = parse_options(argc, argv, options, bench_locking_creat_usage, 0);
+
+	if (argc) {
+		usage_with_options(bench_locking_creat_usage, options);
+		exit(EXIT_FAILURE);
+	}
+
+	spawn_workers(run_bench_creat);
+	free_resources();
+	return 0;
+}
diff --git a/tools/perf/builtin-bench.c b/tools/perf/builtin-bench.c
index b9a56fa..cdaa84a 100644
--- a/tools/perf/builtin-bench.c
+++ b/tools/perf/builtin-bench.c
@@ -63,6 +63,13 @@ static struct bench futex_benchmarks[] = {
 	{ NULL,		NULL,						NULL			}
 };
 
+static struct bench locking_benchmarks[] = {
+	{ "creat",      "Benchmark using creat(2)",			bench_locking_creat     },
+	{ "all",        "Run all benchmarks in this suite",		NULL			},
+	{ NULL,		NULL,						NULL			}
+};
+
+
 struct collection {
 	const char	*name;
 	const char	*summary;
@@ -76,6 +83,7 @@ static struct collection collections[] = {
 	{ "numa",	"NUMA scheduling and MM benchmarks",		numa_benchmarks		},
 #endif
 	{"futex",       "Futex stressing benchmarks",                   futex_benchmarks        },
+	{"locking",     "Kernel locking benchmarks",                    locking_benchmarks      },
 	{ "all",	"All benchmarks",				NULL			},
 	{ NULL,		NULL,						NULL			}
 };
-- 
1.7.9.5



