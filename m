Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932368Ab3KFNUv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Nov 2013 08:20:51 -0500
Received: from terminus.zytor.com ([198.137.202.10]:48977 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932252Ab3KFNUq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Nov 2013 08:20:46 -0500
Date: Wed, 6 Nov 2013 05:19:33 -0800
From: tip-bot for Peter Zijlstra <tipbot@zytor.com>
Message-ID: <tip-a94d342b9cb09edfe888ea972af0883b6a8d992b@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, mathieu.desnoyers@polymtl.ca,
        anton@samba.org, hpa@zytor.com, mingo@kernel.org,
        michael@ellerman.id.au, peterz@infradead.org,
        paulmck@linux.vnet.ibm.com, vince@deater.net, fweisbec@gmail.com,
        benh@kernel.crashing.org, oleg@redhat.com, tglx@linutronix.de,
        VICTORK@il.ibm.com, mikey@neuling.org
Reply-To: mingo@kernel.org, hpa@zytor.com, anton@samba.org,
        mathieu.desnoyers@polymtl.ca, linux-kernel@vger.kernel.org,
        peterz@infradead.org, michael@ellerman.id.au, vince@deater.net,
        paulmck@linux.vnet.ibm.com, benh@kernel.crashing.org,
        fweisbec@gmail.com, VICTORK@il.ibm.com, tglx@linutronix.de,
        oleg@redhat.com, mikey@neuling.org
In-Reply-To: <20131030104246.GH16117@laptop.programming.kicks-ass.net>
References: <20131030104246.GH16117@laptop.programming.kicks-ass.net>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] tools/perf: Add required memory barriers
Git-Commit-ID: a94d342b9cb09edfe888ea972af0883b6a8d992b
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.1 (terminus.zytor.com [127.0.0.1]); Wed, 06 Nov 2013 05:19:39 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  a94d342b9cb09edfe888ea972af0883b6a8d992b
Gitweb:     http://git.kernel.org/tip/a94d342b9cb09edfe888ea972af0883b6a8d992b
Author:     Peter Zijlstra <peterz@infradead.org>
AuthorDate: Wed, 30 Oct 2013 11:42:46 +0100
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Wed, 6 Nov 2013 12:34:26 +0100

tools/perf: Add required memory barriers

To match patch bf378d341e48 ("perf: Fix perf ring buffer memory
ordering") change userspace to also adhere to the ordering outlined.

Signed-off-by: Peter Zijlstra <peterz@infradead.org>
Cc: Michael Neuling <mikey@neuling.org>
Cc: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: james.hogan@imgtec.com
Cc: Vince Weaver <vince@deater.net>
Cc: Victor Kaplansky <VICTORK@il.ibm.com>
Cc: Oleg Nesterov <oleg@redhat.com>
Cc: Anton Blanchard <anton@samba.org>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
Cc: Michael Ellerman <michael@ellerman.id.au>
Link: http://lkml.kernel.org/r/20131030104246.GH16117@laptop.programming.kicks-ass.net
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 tools/perf/perf.h        | 59 ++++++++++++++++++++++++++++++++++++++----------
 tools/perf/tests/rdpmc.c |  2 --
 tools/perf/util/evlist.h |  4 ++--
 3 files changed, 49 insertions(+), 16 deletions(-)

diff --git a/tools/perf/perf.h b/tools/perf/perf.h
index f61c230..6a587e84 100644
--- a/tools/perf/perf.h
+++ b/tools/perf/perf.h
@@ -4,6 +4,8 @@
 #include <asm/unistd.h>
 
 #if defined(__i386__)
+#define mb()		asm volatile("lock; addl $0,0(%%esp)" ::: "memory")
+#define wmb()		asm volatile("lock; addl $0,0(%%esp)" ::: "memory")
 #define rmb()		asm volatile("lock; addl $0,0(%%esp)" ::: "memory")
 #define cpu_relax()	asm volatile("rep; nop" ::: "memory");
 #define CPUINFO_PROC	"model name"
@@ -13,6 +15,8 @@
 #endif
 
 #if defined(__x86_64__)
+#define mb()		asm volatile("mfence" ::: "memory")
+#define wmb()		asm volatile("sfence" ::: "memory")
 #define rmb()		asm volatile("lfence" ::: "memory")
 #define cpu_relax()	asm volatile("rep; nop" ::: "memory");
 #define CPUINFO_PROC	"model name"
@@ -23,45 +27,61 @@
 
 #ifdef __powerpc__
 #include "../../arch/powerpc/include/uapi/asm/unistd.h"
+#define mb()		asm volatile ("sync" ::: "memory")
+#define wmb()		asm volatile ("sync" ::: "memory")
 #define rmb()		asm volatile ("sync" ::: "memory")
-#define cpu_relax()	asm volatile ("" ::: "memory");
 #define CPUINFO_PROC	"cpu"
 #endif
 
 #ifdef __s390__
+#define mb()		asm volatile("bcr 15,0" ::: "memory")
+#define wmb()		asm volatile("bcr 15,0" ::: "memory")
 #define rmb()		asm volatile("bcr 15,0" ::: "memory")
-#define cpu_relax()	asm volatile("" ::: "memory");
 #endif
 
 #ifdef __sh__
 #if defined(__SH4A__) || defined(__SH5__)
+# define mb()		asm volatile("synco" ::: "memory")
+# define wmb()		asm volatile("synco" ::: "memory")
 # define rmb()		asm volatile("synco" ::: "memory")
 #else
+# define mb()		asm volatile("" ::: "memory")
+# define wmb()		asm volatile("" ::: "memory")
 # define rmb()		asm volatile("" ::: "memory")
 #endif
-#define cpu_relax()	asm volatile("" ::: "memory")
 #define CPUINFO_PROC	"cpu type"
 #endif
 
 #ifdef __hppa__
+#define mb()		asm volatile("" ::: "memory")
+#define wmb()		asm volatile("" ::: "memory")
 #define rmb()		asm volatile("" ::: "memory")
-#define cpu_relax()	asm volatile("" ::: "memory");
 #define CPUINFO_PROC	"cpu"
 #endif
 
 #ifdef __sparc__
+#ifdef __LP64__
+#define mb()		asm volatile("ba,pt %%xcc, 1f\n"	\
+				     "membar #StoreLoad\n"	\
+				     "1:\n":::"memory")
+#else
+#define mb()		asm volatile("":::"memory")
+#endif
+#define wmb()		asm volatile("":::"memory")
 #define rmb()		asm volatile("":::"memory")
-#define cpu_relax()	asm volatile("":::"memory")
 #define CPUINFO_PROC	"cpu"
 #endif
 
 #ifdef __alpha__
+#define mb()		asm volatile("mb" ::: "memory")
+#define wmb()		asm volatile("wmb" ::: "memory")
 #define rmb()		asm volatile("mb" ::: "memory")
-#define cpu_relax()	asm volatile("" ::: "memory")
 #define CPUINFO_PROC	"cpu model"
 #endif
 
 #ifdef __ia64__
+#define mb()		asm volatile ("mf" ::: "memory")
+#define wmb()		asm volatile ("mf" ::: "memory")
 #define rmb()		asm volatile ("mf" ::: "memory")
 #define cpu_relax()	asm volatile ("hint @pause" ::: "memory")
 #define CPUINFO_PROC	"model name"
@@ -72,40 +92,55 @@
  * Use the __kuser_memory_barrier helper in the CPU helper page. See
  * arch/arm/kernel/entry-armv.S in the kernel source for details.
  */
+#define mb()		((void(*)(void))0xffff0fa0)()
+#define wmb()		((void(*)(void))0xffff0fa0)()
 #define rmb()		((void(*)(void))0xffff0fa0)()
-#define cpu_relax()	asm volatile("":::"memory")
 #define CPUINFO_PROC	"Processor"
 #endif
 
 #ifdef __aarch64__
-#define rmb()		asm volatile("dmb ld" ::: "memory")
+#define mb()		asm volatile("dmb ish" ::: "memory")
+#define wmb()		asm volatile("dmb ishld" ::: "memory")
+#define rmb()		asm volatile("dmb ishst" ::: "memory")
 #define cpu_relax()	asm volatile("yield" ::: "memory")
 #endif
 
 #ifdef __mips__
-#define rmb()		asm volatile(					\
+#define mb()		asm volatile(					\
 				".set	mips2\n\t"			\
 				"sync\n\t"				\
 				".set	mips0"				\
 				: /* no output */			\
 				: /* no input */			\
 				: "memory")
-#define cpu_relax()	asm volatile("" ::: "memory")
+#define wmb()	mb()
+#define rmb()	mb()
 #define CPUINFO_PROC	"cpu model"
 #endif
 
 #ifdef __arc__
+#define mb()		asm volatile("" ::: "memory")
+#define wmb()		asm volatile("" ::: "memory")
 #define rmb()		asm volatile("" ::: "memory")
-#define cpu_relax()	rmb()
 #define CPUINFO_PROC	"Processor"
 #endif
 
 #ifdef __metag__
+#define mb()		asm volatile("" ::: "memory")
+#define wmb()		asm volatile("" ::: "memory")
 #define rmb()		asm volatile("" ::: "memory")
-#define cpu_relax()	asm volatile("" ::: "memory")
 #define CPUINFO_PROC	"CPU"
 #endif
 
+#define barrier() asm volatile ("" ::: "memory")
+
+#ifndef cpu_relax
+#define cpu_relax() barrier()
+#endif
+
+#define ACCESS_ONCE(x) (*(volatile typeof(x) *)&(x))
+
+
 #include <time.h>
 #include <unistd.h>
 #include <sys/types.h>
diff --git a/tools/perf/tests/rdpmc.c b/tools/perf/tests/rdpmc.c
index ff94886..46649c2 100644
--- a/tools/perf/tests/rdpmc.c
+++ b/tools/perf/tests/rdpmc.c
@@ -9,8 +9,6 @@
 
 #if defined(__x86_64__) || defined(__i386__)
 
-#define barrier() asm volatile("" ::: "memory")
-
 static u64 rdpmc(unsigned int counter)
 {
 	unsigned int low, high;
diff --git a/tools/perf/util/evlist.h b/tools/perf/util/evlist.h
index e99eaed..ecaa582 100644
--- a/tools/perf/util/evlist.h
+++ b/tools/perf/util/evlist.h
@@ -177,7 +177,7 @@ int perf_evlist__strerror_open(struct perf_evlist *evlist, int err, char *buf, s
 static inline unsigned int perf_mmap__read_head(struct perf_mmap *mm)
 {
 	struct perf_event_mmap_page *pc = mm->base;
-	int head = pc->data_head;
+	int head = ACCESS_ONCE(pc->data_head);
 	rmb();
 	return head;
 }
@@ -190,7 +190,7 @@ static inline void perf_mmap__write_tail(struct perf_mmap *md,
 	/*
 	 * ensure all reads are done before we write the tail out.
 	 */
-	/* mb(); */
+	mb();
 	pc->data_tail = tail;
 }
 
