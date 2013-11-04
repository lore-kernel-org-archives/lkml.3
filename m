Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753509Ab3KDWgq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Nov 2013 17:36:46 -0500
Received: from mga09.intel.com ([134.134.136.24]:32443 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751517Ab3KDWgo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Nov 2013 17:36:44 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.93,535,1378882800"; 
   d="scan'208";a="403576439"
Subject: Re: [PATCH v8 0/9] rwsem performance optimizations
From: Tim Chen <tim.c.chen@linux.intel.com>
To: Ingo Molnar <mingo@kernel.org>
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrea Arcangeli <aarcange@redhat.com>, Alex Shi <alex.shi@linaro.org>,
        Andi Kleen <andi@firstfloor.org>,
        Michel Lespinasse <walken@google.com>,
        Davidlohr Bueso <davidlohr.bueso@hp.com>,
        Matthew R Wilcox <matthew.r.wilcox@intel.com>,
        Dave Hansen <dave.hansen@intel.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Rik van Riel <riel@redhat.com>,
        Peter Hurley <peter@hurleysoftware.com>,
        "Paul E.McKenney" <paulmck@linux.vnet.ibm.com>,
        Jason Low <jason.low2@hp.com>, Waiman Long <Waiman.Long@hp.com>,
        YuanhanLiu <yuanhan.liu@linux.intel.com>, linux-kernel@vger.kernel.org,
        linux-mm <linux-mm@kvack.org>
In-Reply-To: <1381948114.11046.194.camel@schen9-DESK>
References: <cover.1380748401.git.tim.c.chen@linux.intel.com>
	 <1380753493.11046.82.camel@schen9-DESK> <20131003073212.GC5775@gmail.com>
	 <1381186674.11046.105.camel@schen9-DESK> <20131009061551.GD7664@gmail.com>
	 <1381336441.11046.128.camel@schen9-DESK> <20131010075444.GD17990@gmail.com>
	 <1381882156.11046.178.camel@schen9-DESK> <20131016065526.GB22509@gmail.com>
	 <1381948114.11046.194.camel@schen9-DESK>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 04 Nov 2013 14:36:25 -0800
Message-ID: <1383604585.11046.258.camel@schen9-DESK>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.3 (2.32.3-1.fc14) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo,

Sorry for the late response.  My old 4 socket Westmere
test machine went down and I have to find a new one, 
which is a 4 socket Ivybridge machine with 15 cores per socket.

I've updated the workload as a perf benchmark (see patch)
attached.  The workload will mmap, then access memory
in the mmaped area and then unmap, doing so repeatedly
for a specified time.  Each thread is pinned to a
particular core, with the threads distributed evenly between
the sockets. The throughput is reported with standard deviation
info.

First some baseline comparing the workload with serialized mmap vs
without serialized mmap running under vanilla kernel.

Threads		Throughput	std dev(%)
		serail vs non serial
		mmap(%)
1		0.10		0.16
2		0.78		0.09
3		-5.00		0.12
4		-3.27		0.08
5		-0.11		0.09
10		5.32		0.10
20		-2.05		0.05
40		-9.75		0.15
60		11.69		0.05


Here's the data for complete rwsem patch vs the plain vanilla kernel
case.  Overall there's improvement except for the 3 thread case.

Threads		Throughput	std dev(%)
		vs vanilla(%)
1		0.62		0.11
2		3.86		0.10
3		-7.02		0.19
4		-0.01		0.13
5		2.74		0.06
10		5.66		0.03
20		1.44		0.09
40		5.54		0.09
60		15.63		0.13

Now testing with both patched kernel and vanilla kernel
running serialized mmap with mutex acquisition in user space.

Threads		Throughput	std dev(%)
		vs vanilla(%)
1		0.60		0.02
2		6.40		0.11
3		14.13		0.07
4		-2.41		0.07
5		1.05		0.08
10		4.15		0.05
20		-0.26		0.06
40		-3.45		0.13
60		-4.33		0.07

Here's another run with the rwsem patchset without
optimistic spinning

Threads		Throughput	std dev(%)
		vs vanilla(%)
1		0.81		0.04
2		2.85		0.17
3		-4.09		0.05
4		-8.31		0.07
5		-3.19		0.03
10		1.02		0.05
20		-4.77		0.04
40		-3.11		0.10
60		2.06		0.10

No-optspin comparing serialized mmaped workload under
patched kernel vs vanilla kernel

Threads		Throughput	std dev(%)
		vs vanilla(%)
1		0.57		0.03
2		2.13		0.17
3		14.78		0.33
4		-1.23		0.11
5		2.99		0.08
10		-0.43		0.10
20		0.01		0.03
40		3.03		0.10
60		-1.74		0.09


The data is a bit of a mixed bag.  I'll spin off
the MCS cleanup patch separately so we can merge that first
for Waiman's qrwlock work.

Tim

---
>From 6c5916315c1515fb2281d9344b2c4f371ca99879 Mon Sep 17 00:00:00 2001
From: Tim Chen <tim.c.chen@linux.intel.com>
Date: Wed, 30 Oct 2013 05:18:29 -0700
Subject: [PATCH] perf mmap and memory write test

This patch add a perf benchmark to mmap a piece of memory,
write to the memory and unmap the memory for a given
number of threads.  The threads are distributed and pinned
evenly to the sockets on the machine.  The options
for the benchmark are as follow:

 usage: perf bench mem mmap <options>

    -l, --length <1MB>    Specify length of memory to set. Available units: B, KB, MB, GB and TB (upper and lower)
    -i, --iterations <n>  repeat mmap() invocation this number of times
    -n, --threads <n>     number of threads doing mmap() invocation
    -r, --runtime <n>     runtime per iteration in sec
    -w, --warmup <n>      warmup time in sec
    -s, --serialize       serialize the mmap() operations with mutex
    -v, --verbose         verbose output giving info about each iteration

Signed-off-by: Tim Chen <tim.c.chen@linux.intel.com>
---
 tools/perf/Makefile         |   1 +
 tools/perf/bench/bench.h    |   1 +
 tools/perf/bench/mem-mmap.c | 312 ++++++++++++++++++++++++++++++++++++++++++++
 tools/perf/builtin-bench.c  |   3 +
 4 files changed, 317 insertions(+)
 create mode 100644 tools/perf/bench/mem-mmap.c

diff --git a/tools/perf/Makefile b/tools/perf/Makefile
index 64c043b..80e32d1 100644
--- a/tools/perf/Makefile
+++ b/tools/perf/Makefile
@@ -408,6 +408,7 @@ BUILTIN_OBJS += $(OUTPUT)bench/mem-memset-x86-64-asm.o
 endif
 BUILTIN_OBJS += $(OUTPUT)bench/mem-memcpy.o
 BUILTIN_OBJS += $(OUTPUT)bench/mem-memset.o
+BUILTIN_OBJS += $(OUTPUT)bench/mem-mmap.o
 
 BUILTIN_OBJS += $(OUTPUT)builtin-diff.o
 BUILTIN_OBJS += $(OUTPUT)builtin-evlist.o
diff --git a/tools/perf/bench/bench.h b/tools/perf/bench/bench.h
index 0fdc852..dbd0515 100644
--- a/tools/perf/bench/bench.h
+++ b/tools/perf/bench/bench.h
@@ -31,6 +31,7 @@ extern int bench_sched_pipe(int argc, const char **argv, const char *prefix);
 extern int bench_mem_memcpy(int argc, const char **argv,
 			    const char *prefix __maybe_unused);
 extern int bench_mem_memset(int argc, const char **argv, const char *prefix);
+extern int bench_mem_mmap(int argc, const char **argv, const char *prefix);
 
 #define BENCH_FORMAT_DEFAULT_STR	"default"
 #define BENCH_FORMAT_DEFAULT		0
diff --git a/tools/perf/bench/mem-mmap.c b/tools/perf/bench/mem-mmap.c
new file mode 100644
index 0000000..11d96ad
--- /dev/null
+++ b/tools/perf/bench/mem-mmap.c
@@ -0,0 +1,312 @@
+/*
+ * mem-mmap.c
+ *
+ * memset: Simple parallel mmap and touch maped memory
+ */
+
+#include "../perf.h"
+#include "../util/util.h"
+#include "../util/parse-options.h"
+#include "../util/header.h"
+#include "bench.h"
+
+#include <stdio.h>
+#include <stdlib.h>
+#include <string.h>
+#include <sys/time.h>
+#include <sys/types.h>
+#include <sys/mman.h>
+#include <math.h>
+#include <unistd.h>
+#include <errno.h>
+#include <pthread.h>
+#include <numa.h>
+#include <numaif.h>
+#include <sched.h>
+
+#define K 1024
+#define CACHELINE_SIZE 128
+
+static const char	*length_str	= "1MB";
+static int		iterations	= 10;
+static int		threads		= 1;
+static int		stride		= 8;
+static int		warmup		= 5;
+static int		runtime		= 10;
+static bool		serialize_mmap  = false;
+static bool		verbose		= false;
+static bool		do_cnt		= false;
+static size_t		len		= 1024*1024;
+static unsigned long long	**results;
+static pthread_mutex_t mutex = PTHREAD_MUTEX_INITIALIZER;
+static int		nr_cpus;
+static int		nr_nodes;
+static struct bitmask	*nodemask	= NULL;
+static int		*cur_cpu;
+static int		cur_node;
+static struct bitmask	*cpumask;
+
+static const struct option options[] = {
+	OPT_STRING('l', "length", &length_str, "1MB",
+		    "Specify length of memory to set. "
+		    "Available units: B, KB, MB, GB and TB (upper and lower)"),
+	OPT_INTEGER('i', "iterations", &iterations,
+		    "repeat mmap() invocation this number of times"),
+	OPT_INTEGER('n', "threads", &threads,
+		    "number of threads doing mmap() invocation"),
+	OPT_INTEGER('r', "runtime", &runtime,
+		    "runtime per iteration in sec"),
+	OPT_INTEGER('w', "warmup", &warmup,
+		    "warmup time in sec"),
+	OPT_BOOLEAN('s', "serialize", &serialize_mmap,
+		    "serialize the mmap() operations with mutex"),
+	OPT_BOOLEAN('v', "verbose", &verbose,
+		    "verbose output giving info about each iteration"),
+	OPT_END()
+};
+
+static const char * const bench_mem_mmap_usage[] = {
+	"perf bench mem mmap <options>",
+	NULL
+};
+
+static double timeval2double(struct timeval *ts)
+{
+	return (double)ts->tv_sec +
+		(double)ts->tv_usec / (double)1000000;
+}
+
+static void alloc_mem(void **dst, size_t length)
+{
+	if (serialize_mmap) {
+		pthread_mutex_lock(&mutex);
+		*dst = mmap(NULL, length, PROT_READ|PROT_WRITE,
+				MAP_PRIVATE|MAP_ANONYMOUS, -1, 0);
+		pthread_mutex_unlock(&mutex);
+	} else
+		*dst = mmap(NULL, length, PROT_READ|PROT_WRITE,
+				MAP_PRIVATE|MAP_ANONYMOUS, -1, 0);
+	if (!*dst)
+		die("memory allocation failed - maybe length is too large?\n");
+}
+static void free_mem(void *dst, size_t length)
+{
+	if (serialize_mmap) {
+		pthread_mutex_lock(&mutex);
+		munmap(dst, length);
+		pthread_mutex_unlock(&mutex);
+	} else
+		munmap(dst, length);
+}
+
+static void *do_mmap(void *itr)
+{
+	void *dst = NULL;
+	char *c;
+	size_t l;
+	unsigned long long *cnt;
+
+	cnt = (unsigned long long *) itr;
+	while (1) {
+		/* alloc memory with mmap */
+		alloc_mem(&dst, len);
+		c = (char *) dst;
+
+		/* touch memory allocated */
+		for (l = 0; l < len; l += stride)
+			c[l] = 0xa;
+		free_mem(dst, len);
+		if (do_cnt)
+			(*cnt)++;
+	}
+	return NULL;
+}
+
+static int get_next_node(int node)
+{
+	int i;
+
+	i = (node+1) % nr_nodes;
+	while (i != node) {
+		if (numa_bitmask_isbitset(nodemask, i))
+			return i;
+		i = (i+1) % nr_nodes;
+	}
+	return (-1);
+}
+
+static int get_next_cpu(int node)
+{
+	int i, prev_cpu;
+
+	prev_cpu = cur_cpu[node];
+	i = (prev_cpu + 1) % nr_cpus;
+	numa_node_to_cpus(node, cpumask);
+	while (i != prev_cpu) {
+		if (numa_bitmask_isbitset(cpumask, i)) {
+			cur_cpu[node] = i;
+			return i;
+		}
+		i = (i+1) % nr_cpus;
+	}
+	return (-1);
+}
+
+static void set_attr_to_cpu(pthread_attr_t *attr, int cpu)
+{
+	cpu_set_t cpuset;
+
+	CPU_ZERO(&cpuset);
+	CPU_SET(cpu, &cpuset);
+	pthread_attr_setaffinity_np(attr, sizeof(cpuset), &cpuset);
+}
+
+int bench_mem_mmap(int argc, const char **argv,
+		     const char *prefix __maybe_unused)
+{
+	int i, itr = 0;
+	char *m, *r;
+	struct timeval tv_start, tv_end, tv_diff;
+	double sum = 0.0, min = -1.0, max = 0.0, tput_total = 0.0;
+	double mean = 0, sdv = 0, tsq = 0.0;
+	pthread_t tid;
+	pthread_attr_t attr;
+	u64 addr;
+
+	argc = parse_options(argc, argv, options,
+			     bench_mem_mmap_usage, 0);
+
+	nodemask = numa_get_run_node_mask();
+	nr_nodes = numa_max_node() + 1;
+	nr_cpus = numa_num_configured_cpus();
+	cur_node = 0;
+	cur_cpu = (int *) malloc(nr_nodes * sizeof(int));
+	if (cur_cpu == NULL) {
+		fprintf(stderr, "Not enough memory to set up benchmark\n");
+	}
+	for (i = 0; i < nr_nodes; ++i)
+		cur_cpu[i] = 0;
+
+	cpumask = numa_allocate_cpumask();
+	if ((s64)len <= 0) {
+		fprintf(stderr, "Invalid length:%s\n", length_str);
+		return 1;
+	}
+
+	m = (char *) malloc(CACHELINE_SIZE * (threads+1));
+	addr = (u64) m;
+	if (m == NULL) {
+		fprintf(stderr, "Not enough memory to store results\n");
+		return 1;
+	}
+	results = (unsigned long long **) malloc(sizeof(unsigned long long *)
+							* threads);
+	if (results == NULL) {
+		fprintf(stderr, "Not enough memory to store results\n");
+		free (m);
+		return 1;
+	}
+	r = (char *) ((addr + CACHELINE_SIZE - 1) & ~(CACHELINE_SIZE - 1));
+	for (i = 0; i < threads; i++)
+		results[i] = (unsigned long long *) &r[i * CACHELINE_SIZE];
+
+	for (i = 0; i < threads; i++) {
+		int cpu;
+
+		pthread_attr_init(&attr);
+		cur_node = get_next_node(cur_node);
+		cpu = get_next_cpu(cur_node);
+		if (cur_node < 0 || cpu < 0) {
+			fprintf(stderr, "Cannot set thread to cpu. \n");
+			return 1;
+		}
+		set_attr_to_cpu(&attr, cpu);
+		pthread_create(&tid, &attr, do_mmap, results[i]);
+		pthread_attr_destroy(&attr);
+	}
+
+	if (bench_format == BENCH_FORMAT_DEFAULT) {
+		printf("# Repeatedly memory map %s bytes and touch %llu bytes"
+			" for %d sec with %d threads ...\n", length_str,
+			(unsigned long long) len/stride, runtime, threads);
+		printf("# Warming up ");
+		fflush(stdout);
+	}
+
+	while (1) {
+		double elapsed, tput;
+
+		sleep(1);
+		BUG_ON(gettimeofday(&tv_start, NULL));
+		do_cnt = true;
+		sleep(runtime);
+		do_cnt = false;
+		BUG_ON(gettimeofday(&tv_end, NULL));
+		timersub(&tv_end, &tv_start, &tv_diff);
+		elapsed = timeval2double(&tv_diff);
+
+		sum = 0.0;
+		max = 0.0;
+		if (bench_format == BENCH_FORMAT_DEFAULT) {
+			if (itr < warmup)
+				printf(".");
+			else if (itr == warmup)
+				printf("\n\n");
+			fflush(stdout);
+		}
+
+		for (i = 0; i < threads; i++) {
+			unsigned long long val = *(results[i]);
+
+			*(results[i]) = 0;
+			tput = val / elapsed;
+			if (i == 0)
+				min = tput;
+			else if (tput < min)
+				min = tput;
+
+			if (tput > max)
+				max = tput;
+
+			sum += tput;
+		}
+
+		if (itr++ > warmup) {
+			tput_total += sum;
+			tsq += (double) (sum*sum);
+		}
+
+		if (verbose && (itr > warmup))
+			printf("iteration:%d   %10lf (mmap/unmap per sec)"
+				" %10lf (MB accessed per sec)\n",
+				(itr-warmup), sum, sum*len/(stride*1024*1024));
+
+		if (itr > (iterations + warmup)) {
+			mean = tput_total/iterations;
+			sdv = sqrt((tsq - mean*mean*iterations)/iterations);
+			/* convert to percentage */
+			sdv = 100.0*(sdv/mean);
+			break;
+		}
+	}
+
+	switch (bench_format) {
+	case BENCH_FORMAT_DEFAULT:
+		printf(" %d threads %10lf (mmap/munmap per sec),"
+			"  access %10lf (MB/sec) (std dev +/- %-10lf %%)\n",
+			threads, mean, mean*len/(stride*1024*1024), sdv);
+		break;
+	case BENCH_FORMAT_SIMPLE:
+		printf(" %d %-10lf %-10lf %-10lf \n", threads, mean,
+			mean*len/(stride*1024*1024), sdv);
+		break;
+	default:
+		/* reaching this means there's some disaster: */
+		die("unknown format: %d\n", bench_format);
+		break;
+	}
+
+	free (m);
+	free (results);
+	return 0;
+}
diff --git a/tools/perf/builtin-bench.c b/tools/perf/builtin-bench.c
index 77298bf..7cd4218 100644
--- a/tools/perf/builtin-bench.c
+++ b/tools/perf/builtin-bench.c
@@ -64,6 +64,9 @@ static struct bench_suite mem_suites[] = {
 	{ "memcpy",
 	  "Simple memory copy in various ways",
 	  bench_mem_memcpy },
+	{ "mmap",
+	  "Simple memory map + memory set in various ways",
+	  bench_mem_mmap },
 	{ "memset",
 	  "Simple memory set in various ways",
 	  bench_mem_memset },
-- 
1.7.11.7



