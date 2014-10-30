Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758341AbaJ3GkU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Oct 2014 02:40:20 -0400
Received: from terminus.zytor.com ([198.137.202.10]:37758 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757898AbaJ3GkS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Oct 2014 02:40:18 -0400
Date: Wed, 29 Oct 2014 23:39:54 -0700
From: tip-bot for Wang Nan <tipbot@zytor.com>
Message-ID: <tip-493c3031336a49bbd50777dc2adfa52a49933d43@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, tglx@linutronix.de, hpa@zytor.com,
        wangnan0@huawei.com, lizefan@huawei.com, acme@redhat.com,
        namhyung@kernel.org, mingo@kernel.org
Reply-To: linux-kernel@vger.kernel.org, tglx@linutronix.de, hpa@zytor.com,
        wangnan0@huawei.com, acme@redhat.com, lizefan@huawei.com,
        namhyung@kernel.org, mingo@kernel.org
In-Reply-To: <1414115126-7479-1-git-send-email-wangnan0@huawei.com>
References: <1414115126-7479-1-git-send-email-wangnan0@huawei.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf tools:
  Make CPUINFO_PROC an array to support different kernel versions
Git-Commit-ID: 493c3031336a49bbd50777dc2adfa52a49933d43
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

Commit-ID:  493c3031336a49bbd50777dc2adfa52a49933d43
Gitweb:     http://git.kernel.org/tip/493c3031336a49bbd50777dc2adfa52a49933d43
Author:     Wang Nan <wangnan0@huawei.com>
AuthorDate: Fri, 24 Oct 2014 09:45:26 +0800
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Wed, 29 Oct 2014 10:27:36 -0200

perf tools: Make CPUINFO_PROC an array to support different kernel versions

After kernel 3.7 (commit b4b8f770eb10a1bccaf8aa0ec1956e2dd7ed1e0a),
/proc/cpuinfo replaces 'Processor' to 'model name'.

This patch makes CPUINFO_PROC to an array and provides two choices for
ARM, makes it compatible for different kernel version.

v1 -> v2: minor changes as suggested by Namhyung Kim:

 - Doesn't pass @h and @evlist to __write_cpudesc;
 - Coding style fix.

v2 -> v3:
  - Rebase:
    git://git.kernel.org/pub/scm/linux/kernel/git/acme/linux.git perf/core

Signed-off-by: Wang Nan <wangnan0@huawei.com>
Acked-by: Namhyung Kim <namhyung@kernel.org>
Cc: Li Zefan <lizefan@huawei.com>
Cc: Namhyung Kim <namhyung@kernel.org>
Link: http://lkml.kernel.org/r/1414115126-7479-1-git-send-email-wangnan0@huawei.com
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/perf-sys.h    | 30 +++++++++++++++---------------
 tools/perf/util/header.c | 27 +++++++++++++++++++++------
 2 files changed, 36 insertions(+), 21 deletions(-)

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
index ce0de00..26f5b2f 100644
--- a/tools/perf/util/header.c
+++ b/tools/perf/util/header.c
@@ -579,16 +579,12 @@ static int write_version(int fd, struct perf_header *h __maybe_unused,
 	return do_write_string(fd, perf_version_string);
 }
 
-static int write_cpudesc(int fd, struct perf_header *h __maybe_unused,
-		       struct perf_evlist *evlist __maybe_unused)
+static int __write_cpudesc(int fd, const char *cpuinfo_proc)
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
 
@@ -638,6 +634,25 @@ done:
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
+
+	for (i = 0; i < ARRAY_SIZE(cpuinfo_procs); i++) {
+		int ret;
+		ret = __write_cpudesc(fd, cpuinfo_procs[i]);
+		if (ret >= 0)
+			return ret;
+	}
+	return -1;
+}
+
+
 static int write_nrcpus(int fd, struct perf_header *h __maybe_unused,
 			struct perf_evlist *evlist __maybe_unused)
 {
