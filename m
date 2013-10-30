Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753756Ab3J3KnX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Oct 2013 06:43:23 -0400
Received: from merlin.infradead.org ([205.233.59.134]:41375 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751596Ab3J3KnV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Oct 2013 06:43:21 -0400
Date: Wed, 30 Oct 2013 11:42:46 +0100
From: Peter Zijlstra <peterz@infradead.org>
To: Vince Weaver <vince@deater.net>
Cc: Victor Kaplansky <VICTORK@il.ibm.com>, Oleg Nesterov <oleg@redhat.com>,
        Anton Blanchard <anton@samba.org>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Linux PPC dev <linuxppc-dev@ozlabs.org>,
        Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
        Michael Ellerman <michael@ellerman.id.au>,
        Michael Neuling <mikey@neuling.org>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        james.hogan@imgtec.com
Subject: Re: perf events ring buffer memory barrier on powerpc
Message-ID: <20131030104246.GH16117@laptop.programming.kicks-ass.net>
References: <20131025173749.GG19466@laptop.lan>
 <CAFTL4hxn47KFKZPLgKeBxxdaAbA4vg9QVzctuW4ZrSgmfX5bAQ@mail.gmail.com>
 <OFB9096CCA.68AAFFFB-ON42257C12.0044F107-42257C12.00457129@il.ibm.com>
 <20131028132634.GO19466@laptop.lan>
 <20131028163418.GD4126@linux.vnet.ibm.com>
 <20131028201735.GA15629@redhat.com>
 <OF58D85F5A.03E37A80-ON42257C12.0070E552-42257C12.00734308@il.ibm.com>
 <20131029102131.GA16117@laptop.programming.kicks-ass.net>
 <20131029103057.GN2490@laptop.programming.kicks-ass.net>
 <alpine.DEB.2.02.1310291524240.6608@pianoman.cluster.toy>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.02.1310291524240.6608@pianoman.cluster.toy>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 29, 2013 at 03:27:05PM -0400, Vince Weaver wrote:
> On Tue, 29 Oct 2013, Peter Zijlstra wrote:
> 
> > On Tue, Oct 29, 2013 at 11:21:31AM +0100, Peter Zijlstra wrote:
> > --- linux-2.6.orig/include/uapi/linux/perf_event.h
> > +++ linux-2.6/include/uapi/linux/perf_event.h
> > @@ -479,13 +479,15 @@ struct perf_event_mmap_page {
> >  	/*
> >  	 * Control data for the mmap() data buffer.
> >  	 *
> > -	 * User-space reading the @data_head value should issue an rmb(), on
> > -	 * SMP capable platforms, after reading this value -- see
> > -	 * perf_event_wakeup().
> > +	 * User-space reading the @data_head value should issue an smp_rmb(),
> > +	 * after reading this value.
> 
> so where's the patch fixing perf to use the new recommendations?

Fair enough, thanks for reminding me about that. See below.

> Is this purely a performance thing or a correctness change?

Correctness, although I suppose on most archs you'd be hard pushed to
notice.

> A change like this a bit of a pain, especially as userspace doesn't really 
> have nice access to smb_mb() defines so a lot of cut-and-pasting will 
> ensue for everyone who's trying to parse the mmap buffer.

Agreed; we should maybe push for a user visible asm/barrier.h or so.

---
Subject: perf, tool: Add required memory barriers

To match patch bf378d341e48 ("perf: Fix perf ring buffer memory
ordering") change userspace to also adhere to the ordering outlined.

Most barrier implementations were gleaned from
arch/*/include/asm/barrier.h and with the exception of metag I'm fairly
sure they're correct.

Cc: James Hogan <james.hogan@imgtec.com>
Signed-off-by: Peter Zijlstra <peterz@infradead.org>
---
 tools/perf/perf.h        | 39 +++++++++++++++++++++++++++++++++++++--
 tools/perf/util/evlist.h |  2 +-
 2 files changed, 38 insertions(+), 3 deletions(-)

diff --git a/tools/perf/perf.h b/tools/perf/perf.h
index f61c230beec4..1b8a0a2a63d4 100644
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
@@ -23,20 +27,28 @@
 
 #ifdef __powerpc__
 #include "../../arch/powerpc/include/uapi/asm/unistd.h"
+#define mb()		asm volatile ("sync" ::: "memory")
+#define wmb()		asm volatile ("sync" ::: "memory")
 #define rmb()		asm volatile ("sync" ::: "memory")
 #define cpu_relax()	asm volatile ("" ::: "memory");
 #define CPUINFO_PROC	"cpu"
 #endif
 
 #ifdef __s390__
+#define mb()		asm volatile("bcr 15,0" ::: "memory")
+#define wmb()		asm volatile("bcr 15,0" ::: "memory")
 #define rmb()		asm volatile("bcr 15,0" ::: "memory")
 #define cpu_relax()	asm volatile("" ::: "memory");
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
 #define cpu_relax()	asm volatile("" ::: "memory")
@@ -44,24 +56,38 @@
 #endif
 
 #ifdef __hppa__
+#define mb()		asm volatile("" ::: "memory")
+#define wmb()		asm volatile("" ::: "memory")
 #define rmb()		asm volatile("" ::: "memory")
 #define cpu_relax()	asm volatile("" ::: "memory");
 #define CPUINFO_PROC	"cpu"
 #endif
 
 #ifdef __sparc__
+#ifdef __LP64__
+#define mb()		asm volatile("ba,pt %%xcc, 1f\n"	\
+				     "membar #StoreLoad\n"	\
+				     "1:\n"":::"memory")
+#else
+#define mb()		asm volatile("":::"memory")
+#endif
+#define wmb()		asm volatile("":::"memory")
 #define rmb()		asm volatile("":::"memory")
 #define cpu_relax()	asm volatile("":::"memory")
 #define CPUINFO_PROC	"cpu"
 #endif
 
 #ifdef __alpha__
+#define mb()		asm volatile("mb" ::: "memory")
+#define wmb()		asm volatile("wmb" ::: "memory")
 #define rmb()		asm volatile("mb" ::: "memory")
 #define cpu_relax()	asm volatile("" ::: "memory")
 #define CPUINFO_PROC	"cpu model"
 #endif
 
 #ifdef __ia64__
+#define mb()		asm volatile ("mf" ::: "memory")
+#define wmb()		asm volatile ("mf" ::: "memory")
 #define rmb()		asm volatile ("mf" ::: "memory")
 #define cpu_relax()	asm volatile ("hint @pause" ::: "memory")
 #define CPUINFO_PROC	"model name"
@@ -72,35 +98,44 @@
  * Use the __kuser_memory_barrier helper in the CPU helper page. See
  * arch/arm/kernel/entry-armv.S in the kernel source for details.
  */
+#define mb()		((void(*)(void))0xffff0fa0)()
+#define wmb()		((void(*)(void))0xffff0fa0)()
 #define rmb()		((void(*)(void))0xffff0fa0)()
 #define cpu_relax()	asm volatile("":::"memory")
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
+#define wmb()	mb()
+#define rmb()	mb()
 #define cpu_relax()	asm volatile("" ::: "memory")
 #define CPUINFO_PROC	"cpu model"
 #endif
 
 #ifdef __arc__
+#define mb()		asm volatile("" ::: "memory")
+#define wmb()		asm volatile("" ::: "memory")
 #define rmb()		asm volatile("" ::: "memory")
 #define cpu_relax()	rmb()
 #define CPUINFO_PROC	"Processor"
 #endif
 
 #ifdef __metag__
+/* XXX no clue */
 #define rmb()		asm volatile("" ::: "memory")
 #define cpu_relax()	asm volatile("" ::: "memory")
 #define CPUINFO_PROC	"CPU"
diff --git a/tools/perf/util/evlist.h b/tools/perf/util/evlist.h
index 6e8acc9abe38..8ab1b5ae4a0e 100644
--- a/tools/perf/util/evlist.h
+++ b/tools/perf/util/evlist.h
@@ -189,7 +189,7 @@ static inline void perf_mmap__write_tail(struct perf_mmap *md,
 	/*
 	 * ensure all reads are done before we write the tail out.
 	 */
-	/* mb(); */
+	mb();
 	pc->data_tail = tail;
 }
 
