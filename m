Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751272AbaJPDKT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Oct 2014 23:10:19 -0400
Received: from szxga01-in.huawei.com ([119.145.14.64]:38452 "EHLO
	szxga01-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750993AbaJPDKR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Oct 2014 23:10:17 -0400
From: Wang Nan <wangnan0@huawei.com>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>, Paul Mackerras <paulus@samba.org>,
        Ingo Molnar <mingo@redhat.com>,
        Arnaldo Carvalho de Melo <acme@kernel.org>,
        Jiri Olsa <jolsa@redhat.com>, Adrian Hunter <adrian.hunter@intel.com>,
        Namhyung Kim <namhyung.kim@lge.com>, Wang Nan <wangnan0@huawei.com>,
        Waiman Long <Waiman.Long@hp.com>
CC: <linux-kernel@vger.kernel.org>, Li Zefan <lizefan@huawei.com>
Subject: [PATCH] perf tools: makes CPUINFO_PROC to array for different kernel version
Date: Thu, 16 Oct 2014 11:08:43 +0800
Message-ID: <1413428923-80073-1-git-send-email-wangnan0@huawei.com>
X-Mailer: git-send-email 1.8.4
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.107.197.247]
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

After kerne 3.7 (commit b4b8f770eb10a1bccaf8aa0ec1956e2dd7ed1e0a),
/proc/cpuinfo replcae 'Processor' to 'model name'. This patch makes
CPUINFO_PROC to an array and provides two choices for ARM, make it
compatible for different kernel version.

Signed-off-by: Wang Nan <wangnan0@huawei.com>
---
 tools/perf/perf-sys.h    | 30 +++++++++++++++---------------
 tools/perf/util/header.c | 26 ++++++++++++++++++++------
 2 files changed, 35 insertions(+), 21 deletions(-)

diff --git a/tools/perf/perf-sys.h b/tools/perf/perf-sys.h
index 937e432..a3b13d7 100644
--- a/tools/perf/perf-sys.h
+++ b/tools/perf/perf-sys.h
@@ -13,7 +13,7 @@
 #define wmb()		asm volatile("lock; addl $0,0(%%esp)" ::: "memory")
 #define rmb()		asm volatile("lock; addl $0,0(%%esp)" ::: "memory")
 #define cpu_relax()	asm volatile("rep; nop" ::: "memory");
-#define CPUINFO_PROC	"model name"
+#define CPUINFO_PROC	{"model name"}
 #ifndef __NR_perf_event_open
 # define __NR_perf_event_open 336
 #endif
@@ -30,7 +30,7 @@
 #define wmb()		asm volatile("sfence" ::: "memory")
 #define rmb()		asm volatile("lfence" ::: "memory")
 #define cpu_relax()	asm volatile("rep; nop" ::: "memory");
-#define CPUINFO_PROC	"model name"
+#define CPUINFO_PROC	{"model name"}
 #ifndef __NR_perf_event_open
 # define __NR_perf_event_open 298
 #endif
@@ -47,14 +47,14 @@
 #define mb()		asm volatile ("sync" ::: "memory")
 #define wmb()		asm volatile ("sync" ::: "memory")
 #define rmb()		asm volatile ("sync" ::: "memory")
-#define CPUINFO_PROC	"cpu"
+#define CPUINFO_PROC	{"cpu"}
 #endif
 
 #ifdef __s390__
 #define mb()		asm volatile("bcr 15,0" ::: "memory")
 #define wmb()		asm volatile("bcr 15,0" ::: "memory")
 #define rmb()		asm volatile("bcr 15,0" ::: "memory")
-#define CPUINFO_PROC	"vendor_id"
+#define CPUINFO_PROC	{"vendor_id"}
 #endif
 
 #ifdef __sh__
@@ -67,14 +67,14 @@
 # define wmb()		asm volatile("" ::: "memory")
 # define rmb()		asm volatile("" ::: "memory")
 #endif
-#define CPUINFO_PROC	"cpu type"
+#define CPUINFO_PROC	{"cpu type"}
 #endif
 
 #ifdef __hppa__
 #define mb()		asm volatile("" ::: "memory")
 #define wmb()		asm volatile("" ::: "memory")
 #define rmb()		asm volatile("" ::: "memory")
-#define CPUINFO_PROC	"cpu"
+#define CPUINFO_PROC	{"cpu"}
 #endif
 
 #ifdef __sparc__
@@ -87,14 +87,14 @@
 #endif
 #define wmb()		asm volatile("":::"memory")
 #define rmb()		asm volatile("":::"memory")
-#define CPUINFO_PROC	"cpu"
+#define CPUINFO_PROC	{"cpu"}
 #endif
 
 #ifdef __alpha__
 #define mb()		asm volatile("mb" ::: "memory")
 #define wmb()		asm volatile("wmb" ::: "memory")
 #define rmb()		asm volatile("mb" ::: "memory")
-#define CPUINFO_PROC	"cpu model"
+#define CPUINFO_PROC	{"cpu model"}
 #endif
 
 #ifdef __ia64__
@@ -102,7 +102,7 @@
 #define wmb()		asm volatile ("mf" ::: "memory")
 #define rmb()		asm volatile ("mf" ::: "memory")
 #define cpu_relax()	asm volatile ("hint @pause" ::: "memory")
-#define CPUINFO_PROC	"model name"
+#define CPUINFO_PROC	{"model name"}
 #endif
 
 #ifdef __arm__
@@ -113,7 +113,7 @@
 #define mb()		((void(*)(void))0xffff0fa0)()
 #define wmb()		((void(*)(void))0xffff0fa0)()
 #define rmb()		((void(*)(void))0xffff0fa0)()
-#define CPUINFO_PROC	"Processor"
+#define CPUINFO_PROC	{"model name", "Processor"}
 #endif
 
 #ifdef __aarch64__
@@ -133,28 +133,28 @@
 				: "memory")
 #define wmb()	mb()
 #define rmb()	mb()
-#define CPUINFO_PROC	"cpu model"
+#define CPUINFO_PROC	{"cpu model"}
 #endif
 
 #ifdef __arc__
 #define mb()		asm volatile("" ::: "memory")
 #define wmb()		asm volatile("" ::: "memory")
 #define rmb()		asm volatile("" ::: "memory")
-#define CPUINFO_PROC	"Processor"
+#define CPUINFO_PROC	{"Processor"}
 #endif
 
 #ifdef __metag__
 #define mb()		asm volatile("" ::: "memory")
 #define wmb()		asm volatile("" ::: "memory")
 #define rmb()		asm volatile("" ::: "memory")
-#define CPUINFO_PROC	"CPU"
+#define CPUINFO_PROC	{"CPU"}
 #endif
 
 #ifdef __xtensa__
 #define mb()		asm volatile("memw" ::: "memory")
 #define wmb()		asm volatile("memw" ::: "memory")
 #define rmb()		asm volatile("" ::: "memory")
-#define CPUINFO_PROC	"core ID"
+#define CPUINFO_PROC	{"core ID"}
 #endif
 
 #ifdef __tile__
@@ -162,7 +162,7 @@
 #define wmb()		asm volatile ("mf" ::: "memory")
 #define rmb()		asm volatile ("mf" ::: "memory")
 #define cpu_relax()	asm volatile ("mfspr zero, PASS" ::: "memory")
-#define CPUINFO_PROC    "model name"
+#define CPUINFO_PROC    {"model name"}
 #endif
 
 #define barrier() asm volatile ("" ::: "memory")
diff --git a/tools/perf/util/header.c b/tools/perf/util/header.c
index 39b80ac..e23cd45 100644
--- a/tools/perf/util/header.c
+++ b/tools/perf/util/header.c
@@ -579,16 +579,13 @@ static int write_version(int fd, struct perf_header *h __maybe_unused,
 	return do_write_string(fd, perf_version_string);
 }
 
-static int write_cpudesc(int fd, struct perf_header *h __maybe_unused,
-		       struct perf_evlist *evlist __maybe_unused)
+static int __write_cpudesc(int fd, struct perf_header *h __maybe_unused,
+		       struct perf_evlist *evlist __maybe_unused, const char *cpuinfo_proc)
 {
-#ifndef CPUINFO_PROC
-#define CPUINFO_PROC NULL
-#endif
 	FILE *file;
 	char *buf = NULL;
 	char *s, *p;
-	const char *search = CPUINFO_PROC;
+	const char *search = cpuinfo_proc;
 	size_t len = 0;
 	int ret = -1;
 
@@ -640,6 +637,23 @@ done:
 	return ret;
 }
 
+static int write_cpudesc(int fd, struct perf_header *h __maybe_unused,
+		       struct perf_evlist *evlist __maybe_unused)
+{
+#ifndef CPUINFO_PROC
+#define CPUINFO_PROC {"model name", }
+#endif
+	const char *cpuinfo_procs[] = CPUINFO_PROC;
+	unsigned int i;
+	for (i = 0; i < ARRAY_SIZE(cpuinfo_procs); i++) {
+		int ret;
+		ret = __write_cpudesc(fd, h, evlist, cpuinfo_procs[i]);
+		if (ret >= 0)
+			return ret;
+	}
+	return -1;
+}
+
 static int write_nrcpus(int fd, struct perf_header *h __maybe_unused,
 			struct perf_evlist *evlist __maybe_unused)
 {
-- 
1.8.4

