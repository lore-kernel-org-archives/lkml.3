Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755949AbaEERuf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 May 2014 13:50:35 -0400
Received: from terminus.zytor.com ([198.137.202.10]:53185 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752161AbaEERua (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 May 2014 13:50:30 -0400
Date: Mon, 5 May 2014 10:49:26 -0700
From: tip-bot for Jiri Olsa <tipbot@zytor.com>
Message-ID: <tip-43599d1f7adffbbf990b00716ba22974ec1487be@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, paulus@samba.org, acme@redhat.com,
        hpa@zytor.com, mingo@kernel.org, jolsa@kernel.org,
        a.p.zijlstra@chello.nl, peterz@infradead.org, acme@kernel.org,
        namhyung@kernel.org, fweisbec@gmail.com, dsahern@gmail.com,
        tglx@linutronix.de, cjashfor@linux.vnet.ibm.com, bp@suse.de
Reply-To: mingo@kernel.org, hpa@zytor.com, acme@redhat.com, paulus@samba.org,
        linux-kernel@vger.kernel.org, jolsa@kernel.org, a.p.zijlstra@chello.nl,
        peterz@infradead.org, acme@kernel.org, namhyung@kernel.org,
        fweisbec@gmail.com, dsahern@gmail.com, tglx@linutronix.de, bp@suse.de,
        cjashfor@linux.vnet.ibm.com
In-Reply-To: <1399293219-8732-9-git-send-email-jolsa@kernel.org>
References: <1399293219-8732-9-git-send-email-jolsa@kernel.org>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf tools:
  Move syscall and arch specific defines from perf.h
Git-Commit-ID: 43599d1f7adffbbf990b00716ba22974ec1487be
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

Commit-ID:  43599d1f7adffbbf990b00716ba22974ec1487be
Gitweb:     http://git.kernel.org/tip/43599d1f7adffbbf990b00716ba22974ec1487be
Author:     Jiri Olsa <jolsa@kernel.org>
AuthorDate: Mon, 5 May 2014 12:53:20 +0200
Committer:  Jiri Olsa <jolsa@kernel.org>
CommitDate: Mon, 5 May 2014 17:48:28 +0200

perf tools: Move syscall and arch specific defines from perf.h

Into new perf-sys.h header.

The main reason is to separate system specific perf data
from perf tool stuff, so it could be used in small test
programs, as requested Peter:

  http://lkml.kernel.org/r/20140502115201.GI30445@twins.programming.kicks-ass.net

This separation makes the perf.h header more clear.

Requested-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Acked-by: Arnaldo Carvalho de Melo <acme@redhat.com>
Acked-by: Peter Zijlstra <peterz@infradead.org>
Cc: Arnaldo Carvalho de Melo <acme@kernel.org>
Cc: Borislav Petkov <bp@suse.de>
Cc: Corey Ashford <cjashfor@linux.vnet.ibm.com>
Cc: David Ahern <dsahern@gmail.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Link: http://lkml.kernel.org/r/1399293219-8732-9-git-send-email-jolsa@kernel.org
Signed-off-by: Jiri Olsa <jolsa@kernel.org>
---
 tools/perf/{perf.h => perf-sys.h} |  89 +-------------------
 tools/perf/perf.h                 | 165 +-------------------------------------
 2 files changed, 4 insertions(+), 250 deletions(-)

diff --git a/tools/perf/perf.h b/tools/perf/perf-sys.h
similarity index 71%
copy from tools/perf/perf.h
copy to tools/perf/perf-sys.h
index d51a994..4c22c2a 100644
--- a/tools/perf/perf.h
+++ b/tools/perf/perf-sys.h
@@ -1,5 +1,5 @@
-#ifndef _PERF_PERF_H
-#define _PERF_PERF_H
+#ifndef _PERF_SYS_H
+#define _PERF_SYS_H
 
 #include <asm/unistd.h>
 
@@ -165,87 +165,4 @@
 #define cpu_relax() barrier()
 #endif
 
-#define ACCESS_ONCE(x) (*(volatile typeof(x) *)&(x))
-
-
-#include <time.h>
-#include <unistd.h>
-#include <sys/types.h>
-#include <sys/syscall.h>
-
-#include <linux/types.h>
-#include <linux/perf_event.h>
-
-#ifndef NSEC_PER_SEC
-# define NSEC_PER_SEC			1000000000ULL
-#endif
-#ifndef NSEC_PER_USEC
-# define NSEC_PER_USEC			1000ULL
-#endif
-
-static inline unsigned long long rdclock(void)
-{
-	struct timespec ts;
-
-	clock_gettime(CLOCK_MONOTONIC, &ts);
-	return ts.tv_sec * 1000000000ULL + ts.tv_nsec;
-}
-
-extern bool test_attr__enabled;
-void test_attr__init(void);
-void test_attr__open(struct perf_event_attr *attr, pid_t pid, int cpu,
-		     int fd, int group_fd, unsigned long flags);
-
-static inline int
-sys_perf_event_open(struct perf_event_attr *attr,
-		      pid_t pid, int cpu, int group_fd,
-		      unsigned long flags)
-{
-	int fd;
-
-	fd = syscall(__NR_perf_event_open, attr, pid, cpu,
-		     group_fd, flags);
-
-	if (unlikely(test_attr__enabled))
-		test_attr__open(attr, pid, cpu, fd, group_fd, flags);
-
-	return fd;
-}
-
-#define MAX_NR_CPUS			256
-
-extern const char *input_name;
-extern bool perf_host, perf_guest;
-extern const char perf_version_string[];
-
-void pthread__unblock_sigwinch(void);
-
-#include "util/target.h"
-
-struct record_opts {
-	struct target target;
-	int	     call_graph;
-	bool         call_graph_enabled;
-	bool	     group;
-	bool	     inherit_stat;
-	bool	     no_buffering;
-	bool	     no_inherit;
-	bool	     no_inherit_set;
-	bool	     no_samples;
-	bool	     raw_samples;
-	bool	     sample_address;
-	bool	     sample_weight;
-	bool	     sample_time;
-	bool	     period;
-	unsigned int freq;
-	unsigned int mmap_pages;
-	unsigned int user_freq;
-	u64          branch_stack;
-	u64	     default_interval;
-	u64	     user_interval;
-	u16	     stack_dump_size;
-	bool	     sample_transaction;
-	unsigned     initial_delay;
-};
-
-#endif
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
