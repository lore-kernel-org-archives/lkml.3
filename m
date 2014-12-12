Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759428AbaLLIQb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Dec 2014 03:16:31 -0500
Received: from terminus.zytor.com ([198.137.202.10]:43031 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751751AbaLLIQ2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Dec 2014 03:16:28 -0500
Date: Fri, 12 Dec 2014 00:16:07 -0800
From: tip-bot for Rabin Vincent <tipbot@zytor.com>
Message-ID: <tip-5bce1a5772cb52aad7e0466484ba07cfbfec2478@git.kernel.org>
Cc: mingo@redhat.com, mingo@kernel.org, acme@redhat.com,
        linux-kernel@vger.kernel.org, tglx@linutronix.de,
        a.p.zijlstra@chello.nl, hpa@zytor.com, paulus@samba.org,
        rabin.vincent@axis.com, rabinv@axis.com
Reply-To: mingo@redhat.com, linux-kernel@vger.kernel.org, acme@redhat.com,
        mingo@kernel.org, tglx@linutronix.de, a.p.zijlstra@chello.nl,
        rabin.vincent@axis.com, paulus@samba.org, hpa@zytor.com,
        rabinv@axis.com
In-Reply-To: <1417535441-3965-2-git-send-email-rabin.vincent@axis.com>
References: <1417535441-3965-2-git-send-email-rabin.vincent@axis.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/urgent] perf bench: Merge memset into memcpy
Git-Commit-ID: 5bce1a5772cb52aad7e0466484ba07cfbfec2478
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

Commit-ID:  5bce1a5772cb52aad7e0466484ba07cfbfec2478
Gitweb:     http://git.kernel.org/tip/5bce1a5772cb52aad7e0466484ba07cfbfec2478
Author:     Rabin Vincent <rabin.vincent@axis.com>
AuthorDate: Tue, 2 Dec 2014 16:50:40 +0100
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Tue, 9 Dec 2014 09:14:05 -0300

perf bench: Merge memset into memcpy

The memset benchmark is largely copy-pasted from the memcpy benchmark.
Merge the two now that memcpy is made more generic.

Signed-off-by: Rabin Vincent <rabin.vincent@axis.com>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Rabin Vincent <rabinv@axis.com>
Link: http://lkml.kernel.org/r/1417535441-3965-2-git-send-email-rabin.vincent@axis.com
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/Makefile.perf      |   1 -
 tools/perf/bench/mem-memcpy.c |  90 +++++++++++++
 tools/perf/bench/mem-memset.c | 304 ------------------------------------------
 3 files changed, 90 insertions(+), 305 deletions(-)

diff --git a/tools/perf/Makefile.perf b/tools/perf/Makefile.perf
index 478efa9..763e68f 100644
--- a/tools/perf/Makefile.perf
+++ b/tools/perf/Makefile.perf
@@ -458,7 +458,6 @@ BUILTIN_OBJS += $(OUTPUT)bench/mem-memcpy-x86-64-asm.o
 BUILTIN_OBJS += $(OUTPUT)bench/mem-memset-x86-64-asm.o
 endif
 BUILTIN_OBJS += $(OUTPUT)bench/mem-memcpy.o
-BUILTIN_OBJS += $(OUTPUT)bench/mem-memset.o
 BUILTIN_OBJS += $(OUTPUT)bench/futex-hash.o
 BUILTIN_OBJS += $(OUTPUT)bench/futex-wake.o
 BUILTIN_OBJS += $(OUTPUT)bench/futex-requeue.o
diff --git a/tools/perf/bench/mem-memcpy.c b/tools/perf/bench/mem-memcpy.c
index 4a4493a..e18be70 100644
--- a/tools/perf/bench/mem-memcpy.c
+++ b/tools/perf/bench/mem-memcpy.c
@@ -13,6 +13,7 @@
 #include "../util/cloexec.h"
 #include "bench.h"
 #include "mem-memcpy-arch.h"
+#include "mem-memset-arch.h"
 
 #include <stdio.h>
 #include <stdlib.h>
@@ -48,12 +49,14 @@ static const struct option options[] = {
 };
 
 typedef void *(*memcpy_t)(void *, const void *, size_t);
+typedef void *(*memset_t)(void *, int, size_t);
 
 struct routine {
 	const char *name;
 	const char *desc;
 	union {
 		memcpy_t memcpy;
+		memset_t memset;
 	} fn;
 };
 
@@ -336,3 +339,90 @@ int bench_mem_memcpy(int argc, const char **argv,
 
 	return bench_mem_common(argc, argv, prefix, &info);
 }
+
+static void memset_alloc_mem(void **dst, size_t length)
+{
+	*dst = zalloc(length);
+	if (!*dst)
+		die("memory allocation failed - maybe length is too large?\n");
+}
+
+static u64 do_memset_cycle(const struct routine *r, size_t len, bool prefault)
+{
+	u64 cycle_start = 0ULL, cycle_end = 0ULL;
+	memset_t fn = r->fn.memset;
+	void *dst = NULL;
+	int i;
+
+	memset_alloc_mem(&dst, len);
+
+	if (prefault)
+		fn(dst, -1, len);
+
+	cycle_start = get_cycle();
+	for (i = 0; i < iterations; ++i)
+		fn(dst, i, len);
+	cycle_end = get_cycle();
+
+	free(dst);
+	return cycle_end - cycle_start;
+}
+
+static double do_memset_gettimeofday(const struct routine *r, size_t len,
+				     bool prefault)
+{
+	struct timeval tv_start, tv_end, tv_diff;
+	memset_t fn = r->fn.memset;
+	void *dst = NULL;
+	int i;
+
+	memset_alloc_mem(&dst, len);
+
+	if (prefault)
+		fn(dst, -1, len);
+
+	BUG_ON(gettimeofday(&tv_start, NULL));
+	for (i = 0; i < iterations; ++i)
+		fn(dst, i, len);
+	BUG_ON(gettimeofday(&tv_end, NULL));
+
+	timersub(&tv_end, &tv_start, &tv_diff);
+
+	free(dst);
+	return (double)((double)len / timeval2double(&tv_diff));
+}
+
+static const char * const bench_mem_memset_usage[] = {
+	"perf bench mem memset <options>",
+	NULL
+};
+
+static const struct routine memset_routines[] = {
+	{ .name ="default",
+	  .desc = "Default memset() provided by glibc",
+	  .fn.memset = memset },
+#ifdef HAVE_ARCH_X86_64_SUPPORT
+
+#define MEMSET_FN(_fn, _name, _desc) { .name = _name, .desc = _desc, .fn.memset = _fn },
+#include "mem-memset-x86-64-asm-def.h"
+#undef MEMSET_FN
+
+#endif
+
+	{ .name = NULL,
+	  .desc = NULL,
+	  .fn.memset = NULL   }
+};
+
+int bench_mem_memset(int argc, const char **argv,
+		     const char *prefix __maybe_unused)
+{
+	struct bench_mem_info info = {
+		.routines = memset_routines,
+		.do_cycle = do_memset_cycle,
+		.do_gettimeofday = do_memset_gettimeofday,
+		.usage = bench_mem_memset_usage,
+	};
+
+	return bench_mem_common(argc, argv, prefix, &info);
+}
diff --git a/tools/perf/bench/mem-memset.c b/tools/perf/bench/mem-memset.c
deleted file mode 100644
index 75fc3e6..0000000
--- a/tools/perf/bench/mem-memset.c
+++ /dev/null
@@ -1,304 +0,0 @@
-/*
- * mem-memset.c
- *
- * memset: Simple memory set in various ways
- *
- * Trivial clone of mem-memcpy.c.
- */
-
-#include "../perf.h"
-#include "../util/util.h"
-#include "../util/parse-options.h"
-#include "../util/header.h"
-#include "../util/cloexec.h"
-#include "bench.h"
-#include "mem-memset-arch.h"
-
-#include <stdio.h>
-#include <stdlib.h>
-#include <string.h>
-#include <sys/time.h>
-#include <errno.h>
-
-#define K 1024
-
-static const char	*length_str	= "1MB";
-static const char	*routine	= "default";
-static int		iterations	= 1;
-static bool		use_cycle;
-static int		cycle_fd;
-static bool		only_prefault;
-static bool		no_prefault;
-
-static const struct option options[] = {
-	OPT_STRING('l', "length", &length_str, "1MB",
-		    "Specify length of memory to set. "
-		    "Available units: B, KB, MB, GB and TB (upper and lower)"),
-	OPT_STRING('r', "routine", &routine, "default",
-		    "Specify routine to set"),
-	OPT_INTEGER('i', "iterations", &iterations,
-		    "repeat memset() invocation this number of times"),
-	OPT_BOOLEAN('c', "cycle", &use_cycle,
-		    "Use cycles event instead of gettimeofday() for measuring"),
-	OPT_BOOLEAN('o', "only-prefault", &only_prefault,
-		    "Show only the result with page faults before memset()"),
-	OPT_BOOLEAN('n', "no-prefault", &no_prefault,
-		    "Show only the result without page faults before memset()"),
-	OPT_END()
-};
-
-typedef void *(*memset_t)(void *, int, size_t);
-
-struct routine {
-	const char *name;
-	const char *desc;
-	memset_t fn;
-};
-
-static const struct routine routines[] = {
-	{ "default",
-	  "Default memset() provided by glibc",
-	  memset },
-#ifdef HAVE_ARCH_X86_64_SUPPORT
-
-#define MEMSET_FN(fn, name, desc) { name, desc, fn },
-#include "mem-memset-x86-64-asm-def.h"
-#undef MEMSET_FN
-
-#endif
-
-	{ NULL,
-	  NULL,
-	  NULL   }
-};
-
-static const char * const bench_mem_memset_usage[] = {
-	"perf bench mem memset <options>",
-	NULL
-};
-
-static struct perf_event_attr cycle_attr = {
-	.type		= PERF_TYPE_HARDWARE,
-	.config		= PERF_COUNT_HW_CPU_CYCLES
-};
-
-static void init_cycle(void)
-{
-	cycle_fd = sys_perf_event_open(&cycle_attr, getpid(), -1, -1,
-				       perf_event_open_cloexec_flag());
-
-	if (cycle_fd < 0 && errno == ENOSYS)
-		die("No CONFIG_PERF_EVENTS=y kernel support configured?\n");
-	else
-		BUG_ON(cycle_fd < 0);
-}
-
-static u64 get_cycle(void)
-{
-	int ret;
-	u64 clk;
-
-	ret = read(cycle_fd, &clk, sizeof(u64));
-	BUG_ON(ret != sizeof(u64));
-
-	return clk;
-}
-
-static double timeval2double(struct timeval *ts)
-{
-	return (double)ts->tv_sec +
-		(double)ts->tv_usec / (double)1000000;
-}
-
-static void alloc_mem(void **dst, size_t length)
-{
-	*dst = zalloc(length);
-	if (!*dst)
-		die("memory allocation failed - maybe length is too large?\n");
-}
-
-static u64 do_memset_cycle(memset_t fn, size_t len, bool prefault)
-{
-	u64 cycle_start = 0ULL, cycle_end = 0ULL;
-	void *dst = NULL;
-	int i;
-
-	alloc_mem(&dst, len);
-
-	if (prefault)
-		fn(dst, -1, len);
-
-	cycle_start = get_cycle();
-	for (i = 0; i < iterations; ++i)
-		fn(dst, i, len);
-	cycle_end = get_cycle();
-
-	free(dst);
-	return cycle_end - cycle_start;
-}
-
-static double do_memset_gettimeofday(memset_t fn, size_t len, bool prefault)
-{
-	struct timeval tv_start, tv_end, tv_diff;
-	void *dst = NULL;
-	int i;
-
-	alloc_mem(&dst, len);
-
-	if (prefault)
-		fn(dst, -1, len);
-
-	BUG_ON(gettimeofday(&tv_start, NULL));
-	for (i = 0; i < iterations; ++i)
-		fn(dst, i, len);
-	BUG_ON(gettimeofday(&tv_end, NULL));
-
-	timersub(&tv_end, &tv_start, &tv_diff);
-
-	free(dst);
-	return (double)((double)len / timeval2double(&tv_diff));
-}
-
-#define pf (no_prefault ? 0 : 1)
-
-#define print_bps(x) do {					\
-		if (x < K)					\
-			printf(" %14lf B/Sec", x);		\
-		else if (x < K * K)				\
-			printf(" %14lfd KB/Sec", x / K);	\
-		else if (x < K * K * K)				\
-			printf(" %14lf MB/Sec", x / K / K);	\
-		else						\
-			printf(" %14lf GB/Sec", x / K / K / K); \
-	} while (0)
-
-int bench_mem_memset(int argc, const char **argv,
-		     const char *prefix __maybe_unused)
-{
-	int i;
-	size_t len;
-	double result_bps[2];
-	u64 result_cycle[2];
-
-	argc = parse_options(argc, argv, options,
-			     bench_mem_memset_usage, 0);
-
-	if (no_prefault && only_prefault) {
-		fprintf(stderr, "Invalid options: -o and -n are mutually exclusive\n");
-		return 1;
-	}
-
-	if (use_cycle)
-		init_cycle();
-
-	len = (size_t)perf_atoll((char *)length_str);
-
-	result_cycle[0] = result_cycle[1] = 0ULL;
-	result_bps[0] = result_bps[1] = 0.0;
-
-	if ((s64)len <= 0) {
-		fprintf(stderr, "Invalid length:%s\n", length_str);
-		return 1;
-	}
-
-	/* same to without specifying either of prefault and no-prefault */
-	if (only_prefault && no_prefault)
-		only_prefault = no_prefault = false;
-
-	for (i = 0; routines[i].name; i++) {
-		if (!strcmp(routines[i].name, routine))
-			break;
-	}
-	if (!routines[i].name) {
-		printf("Unknown routine:%s\n", routine);
-		printf("Available routines...\n");
-		for (i = 0; routines[i].name; i++) {
-			printf("\t%s ... %s\n",
-			       routines[i].name, routines[i].desc);
-		}
-		return 1;
-	}
-
-	if (bench_format == BENCH_FORMAT_DEFAULT)
-		printf("# Copying %s Bytes ...\n\n", length_str);
-
-	if (!only_prefault && !no_prefault) {
-		/* show both of results */
-		if (use_cycle) {
-			result_cycle[0] =
-				do_memset_cycle(routines[i].fn, len, false);
-			result_cycle[1] =
-				do_memset_cycle(routines[i].fn, len, true);
-		} else {
-			result_bps[0] =
-				do_memset_gettimeofday(routines[i].fn,
-						len, false);
-			result_bps[1] =
-				do_memset_gettimeofday(routines[i].fn,
-						len, true);
-		}
-	} else {
-		if (use_cycle) {
-			result_cycle[pf] =
-				do_memset_cycle(routines[i].fn,
-						len, only_prefault);
-		} else {
-			result_bps[pf] =
-				do_memset_gettimeofday(routines[i].fn,
-						len, only_prefault);
-		}
-	}
-
-	switch (bench_format) {
-	case BENCH_FORMAT_DEFAULT:
-		if (!only_prefault && !no_prefault) {
-			if (use_cycle) {
-				printf(" %14lf Cycle/Byte\n",
-					(double)result_cycle[0]
-					/ (double)len);
-				printf(" %14lf Cycle/Byte (with prefault)\n ",
-					(double)result_cycle[1]
-					/ (double)len);
-			} else {
-				print_bps(result_bps[0]);
-				printf("\n");
-				print_bps(result_bps[1]);
-				printf(" (with prefault)\n");
-			}
-		} else {
-			if (use_cycle) {
-				printf(" %14lf Cycle/Byte",
-					(double)result_cycle[pf]
-					/ (double)len);
-			} else
-				print_bps(result_bps[pf]);
-
-			printf("%s\n", only_prefault ? " (with prefault)" : "");
-		}
-		break;
-	case BENCH_FORMAT_SIMPLE:
-		if (!only_prefault && !no_prefault) {
-			if (use_cycle) {
-				printf("%lf %lf\n",
-					(double)result_cycle[0] / (double)len,
-					(double)result_cycle[1] / (double)len);
-			} else {
-				printf("%lf %lf\n",
-					result_bps[0], result_bps[1]);
-			}
-		} else {
-			if (use_cycle) {
-				printf("%lf\n", (double)result_cycle[pf]
-					/ (double)len);
-			} else
-				printf("%lf\n", result_bps[pf]);
-		}
-		break;
-	default:
-		/* reaching this means there's some disaster: */
-		die("unknown format: %d\n", bench_format);
-		break;
-	}
-
-	return 0;
-}
