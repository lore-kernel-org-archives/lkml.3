Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754616Ab3KFPYF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Nov 2013 10:24:05 -0500
Received: from charlotte.tuxdriver.com ([70.61.120.58]:44129 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753391Ab3KFPYD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Nov 2013 10:24:03 -0500
From: Neil Horman <nhorman@tuxdriver.com>
To: linux-kernel@vger.kernel.org
Cc: Neil Horman <nhorman@tuxdriver.com>, sebastien.dugue@bull.net,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, x86@kernel.org
Subject: [PATCH v2 1/2] perf: Add csum benchmark tests to perf
Date: Wed,  6 Nov 2013 10:23:18 -0500
Message-Id: <1383751399-10298-2-git-send-email-nhorman@tuxdriver.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1383751399-10298-1-git-send-email-nhorman@tuxdriver.com>
References: <1381510298-20572-1-git-send-email-nhorman@tuxdriver.com>
 <1383751399-10298-1-git-send-email-nhorman@tuxdriver.com>
X-Spam-Score: -2.9 (--)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Adding perf benchmarks to test the arch independent and x86[64] versions of
do_csum to the perf suite.  Other arches can be added as needed.  To avoid
creating a new suite instance (as I didn't think it was warranted), the csum
benchmarks have been added to the mem suite

Signed-off-by: Neil Horman <nhorman@tuxdriver.com>
CC: sebastien.dugue@bull.net
CC: Thomas Gleixner <tglx@linutronix.de>
CC: Ingo Molnar <mingo@redhat.com>
CC: "H. Peter Anvin" <hpa@zytor.com>
CC: x86@kernel.org
---
 tools/perf/Makefile.perf               |   3 +
 tools/perf/bench/bench.h               |   2 +
 tools/perf/bench/mem-csum-generic.c    |  21 +++
 tools/perf/bench/mem-csum-x86-64-def.h |   8 +
 tools/perf/bench/mem-csum-x86-64.c     |  51 +++++++
 tools/perf/bench/mem-csum.c            | 266 +++++++++++++++++++++++++++++++++
 tools/perf/bench/mem-csum.h            |  46 ++++++
 tools/perf/builtin-bench.c             |   1 +
 8 files changed, 398 insertions(+)
 create mode 100644 tools/perf/bench/mem-csum-generic.c
 create mode 100644 tools/perf/bench/mem-csum-x86-64-def.h
 create mode 100644 tools/perf/bench/mem-csum-x86-64.c
 create mode 100644 tools/perf/bench/mem-csum.c
 create mode 100644 tools/perf/bench/mem-csum.h

diff --git a/tools/perf/Makefile.perf b/tools/perf/Makefile.perf
index 5b86390..d0ac05b 100644
--- a/tools/perf/Makefile.perf
+++ b/tools/perf/Makefile.perf
@@ -413,9 +413,12 @@ BUILTIN_OBJS += $(OUTPUT)bench/sched-pipe.o
 ifeq ($(RAW_ARCH),x86_64)
 BUILTIN_OBJS += $(OUTPUT)bench/mem-memcpy-x86-64-asm.o
 BUILTIN_OBJS += $(OUTPUT)bench/mem-memset-x86-64-asm.o
+BUILTIN_OBJS += $(OUTPUT)bench/mem-csum-x86-64.o
 endif
 BUILTIN_OBJS += $(OUTPUT)bench/mem-memcpy.o
 BUILTIN_OBJS += $(OUTPUT)bench/mem-memset.o
+BUILTIN_OBJS += $(OUTPUT)bench/mem-csum.o
+BUILTIN_OBJS += $(OUTPUT)bench/mem-csum-generic.o
 
 BUILTIN_OBJS += $(OUTPUT)builtin-diff.o
 BUILTIN_OBJS += $(OUTPUT)builtin-evlist.o
diff --git a/tools/perf/bench/bench.h b/tools/perf/bench/bench.h
index 0fdc852..3bbe43e 100644
--- a/tools/perf/bench/bench.h
+++ b/tools/perf/bench/bench.h
@@ -32,6 +32,8 @@ extern int bench_mem_memcpy(int argc, const char **argv,
 			    const char *prefix __maybe_unused);
 extern int bench_mem_memset(int argc, const char **argv, const char *prefix);
 
+extern int bench_mem_csum(int argc, const char **argv, const char *prefix);
+
 #define BENCH_FORMAT_DEFAULT_STR	"default"
 #define BENCH_FORMAT_DEFAULT		0
 #define BENCH_FORMAT_SIMPLE_STR		"simple"
diff --git a/tools/perf/bench/mem-csum-generic.c b/tools/perf/bench/mem-csum-generic.c
new file mode 100644
index 0000000..3e77b0d
--- /dev/null
+++ b/tools/perf/bench/mem-csum-generic.c
@@ -0,0 +1,21 @@
+#include "mem-csum.h"
+
+u32 generic_do_csum(unsigned char *buff, unsigned int len);
+
+__wsum csum_partial_copy(const void *src, void *dst, int len, __wsum sum);
+
+/*
+ * Each arch specific implementation file exports these functions,
+ * So we get link time conflicts.  Since we're not testing these paths right now
+ * just rename them to something generic here
+ */
+#define csum_partial(x, y, z) csum_partial_generic(x, y, z)
+#define ip_compute_csum(x, y) ip_complete_csum_generic(x, y)
+
+#include "../../../lib/checksum.c"
+
+u32 generic_do_csum(unsigned char *buff, unsigned int len)
+{
+	return do_csum(buff, len);
+}
+
diff --git a/tools/perf/bench/mem-csum-x86-64-def.h b/tools/perf/bench/mem-csum-x86-64-def.h
new file mode 100644
index 0000000..6698193
--- /dev/null
+++ b/tools/perf/bench/mem-csum-x86-64-def.h
@@ -0,0 +1,8 @@
+/*
+ * Arch specific bench tests for x86[_64]
+ */
+
+CSUM_FN(x86_do_csum, x86_do_csum_init,
+	"x86-64-csum",
+	"x86 unrolled optimized csum() from kernel")
+
diff --git a/tools/perf/bench/mem-csum-x86-64.c b/tools/perf/bench/mem-csum-x86-64.c
new file mode 100644
index 0000000..72bc855
--- /dev/null
+++ b/tools/perf/bench/mem-csum-x86-64.c
@@ -0,0 +1,51 @@
+#include "mem-csum.h"
+
+static int clflush_size;
+
+/*
+ * This overrides the cache_line_size() function from the kernel
+ * The kernel version returns the size of the processor cache line, so 
+ * we emulate that here
+ */
+static inline int cache_line_size(void)
+{
+	return clflush_size;
+}
+
+/*
+ * userspace has no idea what these macros do, and since we don't 
+ * need them to do anything for perf, just make them go away
+ */
+#define unlikely(x) x
+#define EXPORT_SYMBOL(x)
+
+u32 x86_do_csum(unsigned char *buff, unsigned int len);
+void x86_do_csum_init(void);
+
+#include "../../../arch/x86/lib/csum-partial_64.c"
+
+u32 x86_do_csum(unsigned char *buff, unsigned int len)
+{
+	return do_csum(buff, len);
+}
+
+void x86_do_csum_init(void)
+{
+	/*
+	 * The do_csum routine we're testing requires the kernel
+	 * implementation of cache_line_size(), which relies on data
+	 * parsed from the cpuid instruction, do that computation here
+	 */
+	asm("mov $0x1, %%eax\n\t"
+	    "cpuid\n\t"
+	    "mov %%ebx, %[size]\n"
+	    : : [size] "m" (clflush_size));
+
+	/*
+	 * The size of a cache line evicted by a clflush operation is
+	 * contained in bits 15:8 of ebx when cpuid 0x1 is issued
+	 * and is reported in 8 byte words, hence the multiplcation below
+	 */
+	clflush_size = (clflush_size >> 8) & 0x0000000f;
+	clflush_size *= 8;
+}
diff --git a/tools/perf/bench/mem-csum.c b/tools/perf/bench/mem-csum.c
new file mode 100644
index 0000000..3676f6e
--- /dev/null
+++ b/tools/perf/bench/mem-csum.c
@@ -0,0 +1,266 @@
+/*
+ * mem-csum.c
+ *
+ * csum: checksum speed tests
+ *
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
+#include <errno.h>
+
+#define K 1024
+
+static const char	*length_str	= "1500B";
+static const char	*size_str	= "64MB";
+static const char	*routine	= "default";
+static int		iterations	= 1;
+static bool		use_cycle;
+static int		cycle_fd;
+
+static const struct option options[] = {
+	OPT_STRING('l', "length", &length_str, "1MB",
+		    "Specify length of memory to checksum. "
+		    "Available units: B, KB, MB, GB and TB (upper and lower)"),
+	OPT_STRING('s', "size", &size_str, "64MB",
+		   "Size of working set to draw csumed buffer from."
+		   "Available units: B, KB, MB, GB and TB"),
+	OPT_STRING('r', "routine", &routine, "default",
+		    "Specify routine to set"),
+	OPT_INTEGER('i', "iterations", &iterations,
+		    "repeat csum() invocation this number of times"),
+	OPT_BOOLEAN('c', "cycle", &use_cycle,
+		    "Use cycles event instead of gettimeofday() for measuring"),
+	OPT_END()
+};
+
+
+extern u32 generic_do_csum(unsigned char *buff, unsigned int len);
+
+#ifdef HAVE_ARCH_X86_64_SUPPORT
+extern u32 x86_do_csum(unsigned char *buff, unsigned int len);
+extern void x86_do_csum_init(void);
+#endif
+
+typedef u32 (*csum_t)(unsigned char *, unsigned int);
+typedef void (*csum_init_t)(void);
+
+struct routine {
+	const char *name;
+	const char *desc;
+	csum_t fn;
+	csum_init_t initfn;
+};
+
+static const struct routine routines[] = {
+	{ "default",
+	  "Default arch-independent csum",
+	  generic_do_csum,
+	  NULL },
+#ifdef HAVE_ARCH_X86_64_SUPPORT
+#define CSUM_FN(fn, init, name, desc) { name, desc, fn, init },
+#include "mem-csum-x86-64-def.h"
+#undef CSUM_FN
+
+#endif
+
+	{ NULL,
+	  NULL,
+	  NULL,
+	  NULL }
+};
+
+static const char * const bench_mem_csum_usage[] = {
+	"perf bench mem csum <options>",
+	NULL
+};
+
+static struct perf_event_attr cycle_attr = {
+	.type		= PERF_TYPE_HARDWARE,
+	.config		= PERF_COUNT_HW_CPU_CYCLES
+};
+
+static void init_cycle(void)
+{
+	cycle_fd = sys_perf_event_open(&cycle_attr, getpid(), -1, -1, 0);
+
+	if (cycle_fd < 0 && errno == ENOSYS)
+		die("No CONFIG_PERF_EVENTS=y kernel support configured?\n");
+	else
+		BUG_ON(cycle_fd < 0);
+}
+
+static u64 get_cycle(void)
+{
+	int ret;
+	u64 clk;
+
+	ret = read(cycle_fd, &clk, sizeof(u64));
+	BUG_ON(ret != sizeof(u64));
+
+	return clk;
+}
+
+static double timeval2double(struct timeval *ts)
+{
+	return (double)ts->tv_sec +
+		(double)ts->tv_usec / (double)1000000;
+}
+
+static void alloc_mem(void **dst, size_t length)
+{
+	*dst = malloc(length);
+	if (!*dst)
+		die("memory allocation failed - maybe length is too large?\n");
+}
+
+
+static u64 do_csum_cycle(csum_t fn, size_t size, size_t len)
+{
+	u64 cycle_start = 0ULL, cycle_end = 0ULL;
+	void *dst = NULL;
+	void *pool = NULL;
+	unsigned int segments;
+	u64 total_cycles = 0;
+	int i;
+
+	alloc_mem(&pool, size);
+
+	segments = (size / len) - 1;
+	for (i = 0; i < iterations; ++i) {
+		dst = pool + ((random() % segments) * len);
+		cycle_start = get_cycle();
+		fn(dst, len);
+		cycle_end = get_cycle();
+		total_cycles += (cycle_end - cycle_start);
+	}
+
+	free(pool);
+	return total_cycles;
+}
+
+static double do_csum_gettimeofday(csum_t fn, size_t size, size_t len)
+{
+	struct timeval tv_start, tv_end, tv_diff, tv_total;
+	void *dst = NULL;
+	void *pool = NULL;
+	unsigned int segments;
+	int i;
+
+	alloc_mem(&pool, size);
+	timerclear(&tv_total);
+	segments = (size / len) - 1;
+
+	for (i = 0; i < iterations; ++i) {
+		dst = pool + ((random() % segments) * len);
+		BUG_ON(gettimeofday(&tv_start, NULL));
+		fn(dst, len);
+		BUG_ON(gettimeofday(&tv_end, NULL));
+		timersub(&tv_end, &tv_start, &tv_diff);
+		timeradd(&tv_total, &tv_diff, &tv_total);
+	}
+
+
+	free(pool);
+	return (double)((double)(len*iterations) / timeval2double(&tv_total));
+}
+
+#define print_bps(x) do {					\
+		if (x < K)					\
+			printf(" %14lf B/Sec\n", x);		\
+		else if (x < K * K)				\
+			printf(" %14lfd KB/Sec\n", x / K);	\
+		else if (x < K * K * K)				\
+			printf(" %14lf MB/Sec\n", x / K / K);	\
+		else						\
+			printf(" %14lf GB/Sec\n", x / K / K / K); \
+	} while (0)
+
+int bench_mem_csum(int argc, const char **argv,
+		   const char *prefix __maybe_unused)
+{
+	int i;
+	size_t len;
+	size_t setsize;
+	double result_bps;
+	u64 result_cycle;
+
+	argc = parse_options(argc, argv, options,
+			     bench_mem_csum_usage, 0);
+
+	if (use_cycle)
+		init_cycle();
+
+	len = (size_t)perf_atoll((char *)length_str);
+	setsize = (size_t)perf_atoll((char *)size_str);
+
+	result_cycle = 0ULL;
+	result_bps = 0.0;
+
+	if ((s64)len <= 0) {
+		fprintf(stderr, "Invalid length:%s\n", length_str);
+		return 1;
+	}
+
+	for (i = 0; routines[i].name; i++) {
+		if (!strcmp(routines[i].name, routine))
+			break;
+	}
+	if (!routines[i].name) {
+		printf("Unknown routine:%s\n", routine);
+		printf("Available routines...\n");
+		for (i = 0; routines[i].name; i++) {
+			printf("\t%s ... %s\n",
+			       routines[i].name, routines[i].desc);
+		}
+		return 1;
+	}
+
+	if (routines[i].initfn)
+		routines[i].initfn();
+
+	if (bench_format == BENCH_FORMAT_DEFAULT)
+		printf("# Copying %s Bytes ...\n\n", length_str);
+
+	if (use_cycle) {
+		result_cycle =
+			do_csum_cycle(routines[i].fn, setsize, len);
+	} else {
+		result_bps =
+			do_csum_gettimeofday(routines[i].fn, setsize, len);
+	}
+
+	switch (bench_format) {
+	case BENCH_FORMAT_DEFAULT:
+		if (use_cycle) {
+			printf(" %14lf Cycle/Byte\n",
+				(double)result_cycle
+				/ (double)(len*iterations));
+		} else
+			print_bps(result_bps);
+
+
+		break;
+	case BENCH_FORMAT_SIMPLE:
+		if (use_cycle) {
+			printf("%lf\n", (double)result_cycle
+				/ (double)(len*iterations));
+		} else
+			printf("%lf\n", result_bps);
+		break;
+	default:
+		/* reaching this means there's some disaster: */
+		die("unknown format: %d\n", bench_format);
+		break;
+	}
+
+	return 0;
+}
diff --git a/tools/perf/bench/mem-csum.h b/tools/perf/bench/mem-csum.h
new file mode 100644
index 0000000..cca9a77
--- /dev/null
+++ b/tools/perf/bench/mem-csum.h
@@ -0,0 +1,46 @@
+/*
+ * Header for mem-csum
+ * mostly trickery to get the kernel code to compile
+ * in user space
+ */
+
+#include "../util/util.h"
+
+#include <linux/types.h>
+
+
+typedef __u16 __le16;
+typedef __u16 __be16;
+typedef __u32 __le32;
+typedef __u32 __be32;
+typedef __u64 __le64;
+typedef __u64 __be64;
+
+typedef __u16 __sum16;
+typedef __u32 __wsum;
+
+/*
+ * __visible isn't defined in userspace, so make it dissappear
+ */
+#define __visible
+
+/*
+ * These get multiple definitions in the kernel with a common inline version
+ * We're not testing them so just move them to another name
+ */
+#define ip_fast_csum ip_fast_csum_backup
+#define csum_tcpudp_nofold csum_tcpudp_nofold_backup
+
+/*
+ * Most csum implementations need this defined, for the copy_and_csum variants.
+ * Since we're building in userspace, this can be voided out
+ */
+static inline int __copy_from_user(void *dst, const void *src, size_t len)
+{
+	(void)dst;
+	(void)src;
+	(void)len;
+	return 0;
+}
+
+
diff --git a/tools/perf/builtin-bench.c b/tools/perf/builtin-bench.c
index e47f90c..44199e0 100644
--- a/tools/perf/builtin-bench.c
+++ b/tools/perf/builtin-bench.c
@@ -50,6 +50,7 @@ static struct bench sched_benchmarks[] = {
 static struct bench mem_benchmarks[] = {
 	{ "memcpy",	"Benchmark for memcpy()",			bench_mem_memcpy	},
 	{ "memset",	"Benchmark for memset() tests",			bench_mem_memset	},
+	{ "csum",	"Simple csum timing for various arches",	bench_mem_csum		},
 	{ "all",	"Test all memory benchmarks",			NULL			},
 	{ NULL,		NULL,						NULL			}
 };
-- 
1.8.3.1

