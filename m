Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932478AbaLBPu4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Dec 2014 10:50:56 -0500
Received: from bastet.se.axis.com ([195.60.68.11]:39183 "EHLO
	bastet.se.axis.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753643AbaLBPuy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Dec 2014 10:50:54 -0500
From: Rabin Vincent <rabin.vincent@axis.com>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>, Paul Mackerras <paulus@samba.org>,
        Ingo Molnar <mingo@redhat.com>,
        Arnaldo Carvalho de Melo <acme@kernel.org>
Cc: linux-kernel@vger.kernel.org, rabin@rab.in,
        Rabin Vincent <rabinv@axis.com>
Subject: [PATCH 1/3] perf: bench: prepare memcpy for merge
Date: Tue,  2 Dec 2014 16:50:39 +0100
Message-Id: <1417535441-3965-1-git-send-email-rabin.vincent@axis.com>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The memset benchmark is largely copy-pasted from the memcpy benchmark.
Prepare the memcpy file for merge with memset by extracting out a
generic function.

Signed-off-by: Rabin Vincent <rabin.vincent@axis.com>
---
 tools/perf/bench/mem-memcpy.c |  182 +++++++++++++++++++++++------------------
 1 file changed, 104 insertions(+), 78 deletions(-)

diff --git a/tools/perf/bench/mem-memcpy.c b/tools/perf/bench/mem-memcpy.c
index 2465141..4a4493a 100644
--- a/tools/perf/bench/mem-memcpy.c
+++ b/tools/perf/bench/mem-memcpy.c
@@ -52,16 +52,18 @@ typedef void *(*memcpy_t)(void *, const void *, size_t);
 struct routine {
 	const char *name;
 	const char *desc;
-	memcpy_t fn;
+	union {
+		memcpy_t memcpy;
+	} fn;
 };
 
-struct routine routines[] = {
-	{ "default",
-	  "Default memcpy() provided by glibc",
-	  memcpy },
+struct routine memcpy_routines[] = {
+	{ .name = "default",
+	  .desc = "Default memcpy() provided by glibc",
+	  .fn.memcpy = memcpy },
 #ifdef HAVE_ARCH_X86_64_SUPPORT
 
-#define MEMCPY_FN(fn, name, desc) { name, desc, fn },
+#define MEMCPY_FN(_fn, _name, _desc) {.name = _name, .desc = _desc, .fn.memcpy = _fn},
 #include "mem-memcpy-x86-64-asm-def.h"
 #undef MEMCPY_FN
 
@@ -69,7 +71,7 @@ struct routine routines[] = {
 
 	{ NULL,
 	  NULL,
-	  NULL   }
+	  {NULL}   }
 };
 
 static const char * const bench_mem_memcpy_usage[] = {
@@ -110,63 +112,6 @@ static double timeval2double(struct timeval *ts)
 		(double)ts->tv_usec / (double)1000000;
 }
 
-static void alloc_mem(void **dst, void **src, size_t length)
-{
-	*dst = zalloc(length);
-	if (!*dst)
-		die("memory allocation failed - maybe length is too large?\n");
-
-	*src = zalloc(length);
-	if (!*src)
-		die("memory allocation failed - maybe length is too large?\n");
-	/* Make sure to always replace the zero pages even if MMAP_THRESH is crossed */
-	memset(*src, 0, length);
-}
-
-static u64 do_memcpy_cycle(memcpy_t fn, size_t len, bool prefault)
-{
-	u64 cycle_start = 0ULL, cycle_end = 0ULL;
-	void *src = NULL, *dst = NULL;
-	int i;
-
-	alloc_mem(&src, &dst, len);
-
-	if (prefault)
-		fn(dst, src, len);
-
-	cycle_start = get_cycle();
-	for (i = 0; i < iterations; ++i)
-		fn(dst, src, len);
-	cycle_end = get_cycle();
-
-	free(src);
-	free(dst);
-	return cycle_end - cycle_start;
-}
-
-static double do_memcpy_gettimeofday(memcpy_t fn, size_t len, bool prefault)
-{
-	struct timeval tv_start, tv_end, tv_diff;
-	void *src = NULL, *dst = NULL;
-	int i;
-
-	alloc_mem(&src, &dst, len);
-
-	if (prefault)
-		fn(dst, src, len);
-
-	BUG_ON(gettimeofday(&tv_start, NULL));
-	for (i = 0; i < iterations; ++i)
-		fn(dst, src, len);
-	BUG_ON(gettimeofday(&tv_end, NULL));
-
-	timersub(&tv_end, &tv_start, &tv_diff);
-
-	free(src);
-	free(dst);
-	return (double)((double)len / timeval2double(&tv_diff));
-}
-
 #define pf (no_prefault ? 0 : 1)
 
 #define print_bps(x) do {					\
@@ -180,8 +125,16 @@ static double do_memcpy_gettimeofday(memcpy_t fn, size_t len, bool prefault)
 			printf(" %14lf GB/Sec", x / K / K / K); \
 	} while (0)
 
-int bench_mem_memcpy(int argc, const char **argv,
-		     const char *prefix __maybe_unused)
+struct bench_mem_info {
+	const struct routine *routines;
+	u64 (*do_cycle)(const struct routine *r, size_t len, bool prefault);
+	double (*do_gettimeofday)(const struct routine *r, size_t len, bool prefault);
+	const char *const *usage;
+};
+
+static int bench_mem_common(int argc, const char **argv,
+		     const char *prefix __maybe_unused,
+		     struct bench_mem_info *info)
 {
 	int i;
 	size_t len;
@@ -189,7 +142,7 @@ int bench_mem_memcpy(int argc, const char **argv,
 	u64 result_cycle[2];
 
 	argc = parse_options(argc, argv, options,
-			     bench_mem_memcpy_usage, 0);
+			     info->usage, 0);
 
 	if (no_prefault && only_prefault) {
 		fprintf(stderr, "Invalid options: -o and -n are mutually exclusive\n");
@@ -213,16 +166,16 @@ int bench_mem_memcpy(int argc, const char **argv,
 	if (only_prefault && no_prefault)
 		only_prefault = no_prefault = false;
 
-	for (i = 0; routines[i].name; i++) {
-		if (!strcmp(routines[i].name, routine))
+	for (i = 0; info->routines[i].name; i++) {
+		if (!strcmp(info->routines[i].name, routine))
 			break;
 	}
-	if (!routines[i].name) {
+	if (!info->routines[i].name) {
 		printf("Unknown routine:%s\n", routine);
 		printf("Available routines...\n");
-		for (i = 0; routines[i].name; i++) {
+		for (i = 0; info->routines[i].name; i++) {
 			printf("\t%s ... %s\n",
-			       routines[i].name, routines[i].desc);
+			       info->routines[i].name, info->routines[i].desc);
 		}
 		return 1;
 	}
@@ -234,25 +187,25 @@ int bench_mem_memcpy(int argc, const char **argv,
 		/* show both of results */
 		if (use_cycle) {
 			result_cycle[0] =
-				do_memcpy_cycle(routines[i].fn, len, false);
+				info->do_cycle(&info->routines[i], len, false);
 			result_cycle[1] =
-				do_memcpy_cycle(routines[i].fn, len, true);
+				info->do_cycle(&info->routines[i], len, true);
 		} else {
 			result_bps[0] =
-				do_memcpy_gettimeofday(routines[i].fn,
+				info->do_gettimeofday(&info->routines[i],
 						len, false);
 			result_bps[1] =
-				do_memcpy_gettimeofday(routines[i].fn,
+				info->do_gettimeofday(&info->routines[i],
 						len, true);
 		}
 	} else {
 		if (use_cycle) {
 			result_cycle[pf] =
-				do_memcpy_cycle(routines[i].fn,
+				info->do_cycle(&info->routines[i],
 						len, only_prefault);
 		} else {
 			result_bps[pf] =
-				do_memcpy_gettimeofday(routines[i].fn,
+				info->do_gettimeofday(&info->routines[i],
 						len, only_prefault);
 		}
 	}
@@ -310,3 +263,76 @@ int bench_mem_memcpy(int argc, const char **argv,
 
 	return 0;
 }
+
+static void memcpy_alloc_mem(void **dst, void **src, size_t length)
+{
+	*dst = zalloc(length);
+	if (!*dst)
+		die("memory allocation failed - maybe length is too large?\n");
+
+	*src = zalloc(length);
+	if (!*src)
+		die("memory allocation failed - maybe length is too large?\n");
+	/* Make sure to always replace the zero pages even if MMAP_THRESH is crossed */
+	memset(*src, 0, length);
+}
+
+static u64 do_memcpy_cycle(const struct routine *r, size_t len, bool prefault)
+{
+	u64 cycle_start = 0ULL, cycle_end = 0ULL;
+	void *src = NULL, *dst = NULL;
+	memcpy_t fn = r->fn.memcpy;
+	int i;
+
+	memcpy_alloc_mem(&src, &dst, len);
+
+	if (prefault)
+		fn(dst, src, len);
+
+	cycle_start = get_cycle();
+	for (i = 0; i < iterations; ++i)
+		fn(dst, src, len);
+	cycle_end = get_cycle();
+
+	free(src);
+	free(dst);
+	return cycle_end - cycle_start;
+}
+
+static double do_memcpy_gettimeofday(const struct routine *r, size_t len,
+				     bool prefault)
+{
+	struct timeval tv_start, tv_end, tv_diff;
+	memcpy_t fn = r->fn.memcpy;
+	void *src = NULL, *dst = NULL;
+	int i;
+
+	memcpy_alloc_mem(&src, &dst, len);
+
+	if (prefault)
+		fn(dst, src, len);
+
+	BUG_ON(gettimeofday(&tv_start, NULL));
+	for (i = 0; i < iterations; ++i)
+		fn(dst, src, len);
+	BUG_ON(gettimeofday(&tv_end, NULL));
+
+	timersub(&tv_end, &tv_start, &tv_diff);
+
+	free(src);
+	free(dst);
+	return (double)((double)len / timeval2double(&tv_diff));
+}
+
+int bench_mem_memcpy(int argc, const char **argv,
+		     const char *prefix __maybe_unused)
+{
+	struct bench_mem_info info = {
+		.routines = memcpy_routines,
+		.do_cycle = do_memcpy_cycle,
+		.do_gettimeofday = do_memcpy_gettimeofday,
+		.usage = bench_mem_memcpy_usage,
+	};
+
+	return bench_mem_common(argc, argv, prefix, &info);
+}
-- 
1.7.10.4

