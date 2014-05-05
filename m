Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932358AbaEEMeu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 May 2014 08:34:50 -0400
Received: from mx1.redhat.com ([209.132.183.28]:48179 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932310AbaEEMeP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 May 2014 08:34:15 -0400
From: Jiri Olsa <jolsa@kernel.org>
To: linux-kernel@vger.kernel.org
Cc: Jiri Olsa <jolsa@kernel.org>, Arnaldo Carvalho de Melo <acme@kernel.org>,
        Borislav Petkov <bp@suse.de>,
        Corey Ashford <cjashfor@linux.vnet.ibm.com>,
        David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@kernel.org>, Namhyung Kim <namhyung@kernel.org>,
        Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: [PATCH 08/10] perf tools: Move syscall and arch specific defines from perf.h
Date: Mon,  5 May 2014 14:33:37 +0200
Message-Id: <1399293219-8732-9-git-send-email-jolsa@kernel.org>
In-Reply-To: <1399293219-8732-1-git-send-email-jolsa@kernel.org>
References: <1399293219-8732-1-git-send-email-jolsa@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Into new perf-sys.h header.

The main reason is to separate system specific perf data
from perf tool stuff, so it could be used in small test
programs, as requested Peter:

  http://lkml.kernel.org/r/20140502115201.GI30445@twins.programming.kicks-ass.net

This separation makes the perf.h header more clear.

Requested-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Arnaldo Carvalho de Melo <acme@kernel.org>
Cc: Borislav Petkov <bp@suse.de>
Cc: Corey Ashford <cjashfor@linux.vnet.ibm.com>
Cc: David Ahern <dsahern@gmail.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Signed-off-by: Jiri Olsa <jolsa@kernel.org>
---
 tools/perf/perf-sys.h | 168 ++++++++++++++++++++++++++++++++++++++++++++++++++
 tools/perf/perf.h     | 165 +------------------------------------------------
 2 files changed, 169 insertions(+), 164 deletions(-)
 create mode 100644 tools/perf/perf-sys.h

diff --git a/tools/perf/perf-sys.h b/tools/perf/perf-sys.h
new file mode 100644
index 0000000..4c22c2a
--- /dev/null
+++ b/tools/perf/perf-sys.h
@@ -0,0 +1,168 @@
+#ifndef _PERF_SYS_H
+#define _PERF_SYS_H
+
+#include <asm/unistd.h>
+
+#if defined(__i386__)
+#define mb()		asm volatile("lock; addl $0,0(%%esp)" ::: "memory")
+#define wmb()		asm volatile("lock; addl $0,0(%%esp)" ::: "memory")
+#define rmb()		asm volatile("lock; addl $0,0(%%esp)" ::: "memory")
+#define cpu_relax()	asm volatile("rep; nop" ::: "memory");
+#define CPUINFO_PROC	"model name"
+#ifndef __NR_perf_event_open
+# define __NR_perf_event_open 336
+#endif
+#ifndef __NR_futex
+# define __NR_futex 240
+#endif
+#ifndef __NR_gettid
+# define __NR_gettid 224
+#endif
+#endif
+
+#if defined(__x86_64__)
+#define mb()		asm volatile("mfence" ::: "memory")
+#define wmb()		asm volatile("sfence" ::: "memory")
+#define rmb()		asm volatile("lfence" ::: "memory")
+#define cpu_relax()	asm volatile("rep; nop" ::: "memory");
+#define CPUINFO_PROC	"model name"
+#ifndef __NR_perf_event_open
+# define __NR_perf_event_open 298
+#endif
+#ifndef __NR_futex
+# define __NR_futex 202
+#endif
+#ifndef __NR_gettid
+# define __NR_gettid 186
+#endif
+#endif
+
+#ifdef __powerpc__
+#include "../../arch/powerpc/include/uapi/asm/unistd.h"
+#define mb()		asm volatile ("sync" ::: "memory")
+#define wmb()		asm volatile ("sync" ::: "memory")
+#define rmb()		asm volatile ("sync" ::: "memory")
+#define CPUINFO_PROC	"cpu"
+#endif
+
+#ifdef __s390__
+#define mb()		asm volatile("bcr 15,0" ::: "memory")
+#define wmb()		asm volatile("bcr 15,0" ::: "memory")
+#define rmb()		asm volatile("bcr 15,0" ::: "memory")
+#endif
+
+#ifdef __sh__
+#if defined(__SH4A__) || defined(__SH5__)
+# define mb()		asm volatile("synco" ::: "memory")
+# define wmb()		asm volatile("synco" ::: "memory")
+# define rmb()		asm volatile("synco" ::: "memory")
+#else
+# define mb()		asm volatile("" ::: "memory")
+# define wmb()		asm volatile("" ::: "memory")
+# define rmb()		asm volatile("" ::: "memory")
+#endif
+#define CPUINFO_PROC	"cpu type"
+#endif
+
+#ifdef __hppa__
+#define mb()		asm volatile("" ::: "memory")
+#define wmb()		asm volatile("" ::: "memory")
+#define rmb()		asm volatile("" ::: "memory")
+#define CPUINFO_PROC	"cpu"
+#endif
+
+#ifdef __sparc__
+#ifdef __LP64__
+#define mb()		asm volatile("ba,pt %%xcc, 1f\n"	\
+				     "membar #StoreLoad\n"	\
+				     "1:\n":::"memory")
+#else
+#define mb()		asm volatile("":::"memory")
+#endif
+#define wmb()		asm volatile("":::"memory")
+#define rmb()		asm volatile("":::"memory")
+#define CPUINFO_PROC	"cpu"
+#endif
+
+#ifdef __alpha__
+#define mb()		asm volatile("mb" ::: "memory")
+#define wmb()		asm volatile("wmb" ::: "memory")
+#define rmb()		asm volatile("mb" ::: "memory")
+#define CPUINFO_PROC	"cpu model"
+#endif
+
+#ifdef __ia64__
+#define mb()		asm volatile ("mf" ::: "memory")
+#define wmb()		asm volatile ("mf" ::: "memory")
+#define rmb()		asm volatile ("mf" ::: "memory")
+#define cpu_relax()	asm volatile ("hint @pause" ::: "memory")
+#define CPUINFO_PROC	"model name"
+#endif
+
+#ifdef __arm__
+/*
+ * Use the __kuser_memory_barrier helper in the CPU helper page. See
+ * arch/arm/kernel/entry-armv.S in the kernel source for details.
+ */
+#define mb()		((void(*)(void))0xffff0fa0)()
+#define wmb()		((void(*)(void))0xffff0fa0)()
+#define rmb()		((void(*)(void))0xffff0fa0)()
+#define CPUINFO_PROC	"Processor"
+#endif
+
+#ifdef __aarch64__
+#define mb()		asm volatile("dmb ish" ::: "memory")
+#define wmb()		asm volatile("dmb ishst" ::: "memory")
+#define rmb()		asm volatile("dmb ishld" ::: "memory")
+#define cpu_relax()	asm volatile("yield" ::: "memory")
+#endif
+
+#ifdef __mips__
+#define mb()		asm volatile(					\
+				".set	mips2\n\t"			\
+				"sync\n\t"				\
+				".set	mips0"				\
+				: /* no output */			\
+				: /* no input */			\
+				: "memory")
+#define wmb()	mb()
+#define rmb()	mb()
+#define CPUINFO_PROC	"cpu model"
+#endif
+
+#ifdef __arc__
+#define mb()		asm volatile("" ::: "memory")
+#define wmb()		asm volatile("" ::: "memory")
+#define rmb()		asm volatile("" ::: "memory")
+#define CPUINFO_PROC	"Processor"
+#endif
+
+#ifdef __metag__
+#define mb()		asm volatile("" ::: "memory")
+#define wmb()		asm volatile("" ::: "memory")
+#define rmb()		asm volatile("" ::: "memory")
+#define CPUINFO_PROC	"CPU"
+#endif
+
+#ifdef __xtensa__
+#define mb()		asm volatile("memw" ::: "memory")
+#define wmb()		asm volatile("memw" ::: "memory")
+#define rmb()		asm volatile("" ::: "memory")
+#define CPUINFO_PROC	"core ID"
+#endif
+
+#ifdef __tile__
+#define mb()		asm volatile ("mf" ::: "memory")
+#define wmb()		asm volatile ("mf" ::: "memory")
+#define rmb()		asm volatile ("mf" ::: "memory")
+#define cpu_relax()	asm volatile ("mfspr zero, PASS" ::: "memory")
+#define CPUINFO_PROC    "model name"
+#endif
+
+#define barrier() asm volatile ("" ::: "memory")
+
+#ifndef cpu_relax
+#define cpu_relax() barrier()
+#endif
+
+#endif /* _PERF_SYS_H */
diff --git a/tools/perf/perf.h b/tools/perf/perf.h
index d51a994..ee95965 100644
--- a/tools/perf/perf.h
+++ b/tools/perf/perf.h
@@ -1,173 +1,10 @@
 #ifndef _PERF_PERF_H
 #define _PERF_PERF_H
 
-#include <asm/unistd.h>
-
-#if defined(__i386__)
-#define mb()		asm volatile("lock; addl $0,0(%%esp)" ::: "memory")
-#define wmb()		asm volatile("lock; addl $0,0(%%esp)" ::: "memory")
-#define rmb()		asm volatile("lock; addl $0,0(%%esp)" ::: "memory")
-#define cpu_relax()	asm volatile("rep; nop" ::: "memory");
-#define CPUINFO_PROC	"model name"
-#ifndef __NR_perf_event_open
-# define __NR_perf_event_open 336
-#endif
-#ifndef __NR_futex
-# define __NR_futex 240
-#endif
-#ifndef __NR_gettid
-# define __NR_gettid 224
-#endif
-#endif
-
-#if defined(__x86_64__)
-#define mb()		asm volatile("mfence" ::: "memory")
-#define wmb()		asm volatile("sfence" ::: "memory")
-#define rmb()		asm volatile("lfence" ::: "memory")
-#define cpu_relax()	asm volatile("rep; nop" ::: "memory");
-#define CPUINFO_PROC	"model name"
-#ifndef __NR_perf_event_open
-# define __NR_perf_event_open 298
-#endif
-#ifndef __NR_futex
-# define __NR_futex 202
-#endif
-#ifndef __NR_gettid
-# define __NR_gettid 186
-#endif
-#endif
-
-#ifdef __powerpc__
-#include "../../arch/powerpc/include/uapi/asm/unistd.h"
-#define mb()		asm volatile ("sync" ::: "memory")
-#define wmb()		asm volatile ("sync" ::: "memory")
-#define rmb()		asm volatile ("sync" ::: "memory")
-#define CPUINFO_PROC	"cpu"
-#endif
-
-#ifdef __s390__
-#define mb()		asm volatile("bcr 15,0" ::: "memory")
-#define wmb()		asm volatile("bcr 15,0" ::: "memory")
-#define rmb()		asm volatile("bcr 15,0" ::: "memory")
-#endif
-
-#ifdef __sh__
-#if defined(__SH4A__) || defined(__SH5__)
-# define mb()		asm volatile("synco" ::: "memory")
-# define wmb()		asm volatile("synco" ::: "memory")
-# define rmb()		asm volatile("synco" ::: "memory")
-#else
-# define mb()		asm volatile("" ::: "memory")
-# define wmb()		asm volatile("" ::: "memory")
-# define rmb()		asm volatile("" ::: "memory")
-#endif
-#define CPUINFO_PROC	"cpu type"
-#endif
-
-#ifdef __hppa__
-#define mb()		asm volatile("" ::: "memory")
-#define wmb()		asm volatile("" ::: "memory")
-#define rmb()		asm volatile("" ::: "memory")
-#define CPUINFO_PROC	"cpu"
-#endif
-
-#ifdef __sparc__
-#ifdef __LP64__
-#define mb()		asm volatile("ba,pt %%xcc, 1f\n"	\
-				     "membar #StoreLoad\n"	\
-				     "1:\n":::"memory")
-#else
-#define mb()		asm volatile("":::"memory")
-#endif
-#define wmb()		asm volatile("":::"memory")
-#define rmb()		asm volatile("":::"memory")
-#define CPUINFO_PROC	"cpu"
-#endif
-
-#ifdef __alpha__
-#define mb()		asm volatile("mb" ::: "memory")
-#define wmb()		asm volatile("wmb" ::: "memory")
-#define rmb()		asm volatile("mb" ::: "memory")
-#define CPUINFO_PROC	"cpu model"
-#endif
-
-#ifdef __ia64__
-#define mb()		asm volatile ("mf" ::: "memory")
-#define wmb()		asm volatile ("mf" ::: "memory")
-#define rmb()		asm volatile ("mf" ::: "memory")
-#define cpu_relax()	asm volatile ("hint @pause" ::: "memory")
-#define CPUINFO_PROC	"model name"
-#endif
-
-#ifdef __arm__
-/*
- * Use the __kuser_memory_barrier helper in the CPU helper page. See
- * arch/arm/kernel/entry-armv.S in the kernel source for details.
- */
-#define mb()		((void(*)(void))0xffff0fa0)()
-#define wmb()		((void(*)(void))0xffff0fa0)()
-#define rmb()		((void(*)(void))0xffff0fa0)()
-#define CPUINFO_PROC	"Processor"
-#endif
-
-#ifdef __aarch64__
-#define mb()		asm volatile("dmb ish" ::: "memory")
-#define wmb()		asm volatile("dmb ishst" ::: "memory")
-#define rmb()		asm volatile("dmb ishld" ::: "memory")
-#define cpu_relax()	asm volatile("yield" ::: "memory")
-#endif
-
-#ifdef __mips__
-#define mb()		asm volatile(					\
-				".set	mips2\n\t"			\
-				"sync\n\t"				\
-				".set	mips0"				\
-				: /* no output */			\
-				: /* no input */			\
-				: "memory")
-#define wmb()	mb()
-#define rmb()	mb()
-#define CPUINFO_PROC	"cpu model"
-#endif
-
-#ifdef __arc__
-#define mb()		asm volatile("" ::: "memory")
-#define wmb()		asm volatile("" ::: "memory")
-#define rmb()		asm volatile("" ::: "memory")
-#define CPUINFO_PROC	"Processor"
-#endif
-
-#ifdef __metag__
-#define mb()		asm volatile("" ::: "memory")
-#define wmb()		asm volatile("" ::: "memory")
-#define rmb()		asm volatile("" ::: "memory")
-#define CPUINFO_PROC	"CPU"
-#endif
-
-#ifdef __xtensa__
-#define mb()		asm volatile("memw" ::: "memory")
-#define wmb()		asm volatile("memw" ::: "memory")
-#define rmb()		asm volatile("" ::: "memory")
-#define CPUINFO_PROC	"core ID"
-#endif
-
-#ifdef __tile__
-#define mb()		asm volatile ("mf" ::: "memory")
-#define wmb()		asm volatile ("mf" ::: "memory")
-#define rmb()		asm volatile ("mf" ::: "memory")
-#define cpu_relax()	asm volatile ("mfspr zero, PASS" ::: "memory")
-#define CPUINFO_PROC    "model name"
-#endif
-
-#define barrier() asm volatile ("" ::: "memory")
-
-#ifndef cpu_relax
-#define cpu_relax() barrier()
-#endif
+#include "perf-sys.h"
 
 #define ACCESS_ONCE(x) (*(volatile typeof(x) *)&(x))
 
-
 #include <time.h>
 #include <unistd.h>
 #include <sys/types.h>
-- 
1.8.3.1

