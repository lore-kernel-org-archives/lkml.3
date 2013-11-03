Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753760Ab3KCPRb (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Nov 2013 10:17:31 -0500
Received: from merlin.infradead.org ([205.233.59.134]:48247 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752603Ab3KCPR3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Nov 2013 10:17:29 -0500
Date: Sun, 3 Nov 2013 16:17:04 +0100
From: Peter Zijlstra <peterz@infradead.org>
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: Victor Kaplansky <VICTORK@il.ibm.com>, Oleg Nesterov <oleg@redhat.com>,
        Anton Blanchard <anton@samba.org>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Linux PPC dev <linuxppc-dev@ozlabs.org>,
        Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
        Michael Ellerman <michael@ellerman.id.au>,
        Michael Neuling <mikey@neuling.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: [RFC] arch: Introduce new TSO memory barrier smp_tmb()
Message-ID: <20131103151704.GJ19466@laptop.lan>
References: <20131028132634.GO19466@laptop.lan>
 <20131028163418.GD4126@linux.vnet.ibm.com>
 <20131028201735.GA15629@redhat.com>
 <OF58D85F5A.03E37A80-ON42257C12.0070E552-42257C12.00734308@il.ibm.com>
 <20131030092725.GL4126@linux.vnet.ibm.com>
 <20131030112526.GI16117@laptop.programming.kicks-ass.net>
 <20131031064015.GV4126@linux.vnet.ibm.com>
 <20131101145634.GH19466@laptop.lan>
 <20131102173239.GB3947@linux.vnet.ibm.com>
 <20131103144017.GA25118@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131103144017.GA25118@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
X-Bad-Reply: References and In-Reply-To but no 'Re:' in Subject.
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Nov 03, 2013 at 06:40:17AM -0800, Paul E. McKenney wrote:
> If there was an smp_tmb(), I would likely use it in rcu_assign_pointer().

Well, I'm obviously all for introducing this new barrier, for it will
reduce a full mfence on x86 to a compiler barrier. And ppc can use
lwsync as opposed to sync afaict. Not sure ARM can do better.

---
Subject: arch: Introduce new TSO memory barrier smp_tmb()

A few sites could be downgraded from smp_mb() to smp_tmb() and a few
site should be upgraded to smp_tmb() that are now using smp_wmb().

XXX hope PaulMck explains things better..

X86 (!OOSTORE), SPARC have native TSO memory models and smp_tmb()
reduces to barrier().

PPC can use lwsync instead of sync

For the other archs, have smp_tmb map to smp_mb, as the stronger barrier
is always correct but possibly suboptimal.

Suggested-by: Paul McKenney <paulmck@linux.vnet.ibm.com>
Not-Signed-off-by: Peter Zijlstra <peterz@infradead.org>
---
 arch/alpha/include/asm/barrier.h      | 2 ++
 arch/arc/include/asm/barrier.h        | 2 ++
 arch/arm/include/asm/barrier.h        | 2 ++
 arch/arm64/include/asm/barrier.h      | 2 ++
 arch/avr32/include/asm/barrier.h      | 1 +
 arch/blackfin/include/asm/barrier.h   | 1 +
 arch/cris/include/asm/barrier.h       | 2 ++
 arch/frv/include/asm/barrier.h        | 1 +
 arch/h8300/include/asm/barrier.h      | 2 ++
 arch/hexagon/include/asm/barrier.h    | 1 +
 arch/ia64/include/asm/barrier.h       | 2 ++
 arch/m32r/include/asm/barrier.h       | 2 ++
 arch/m68k/include/asm/barrier.h       | 1 +
 arch/metag/include/asm/barrier.h      | 3 +++
 arch/microblaze/include/asm/barrier.h | 1 +
 arch/mips/include/asm/barrier.h       | 3 +++
 arch/mn10300/include/asm/barrier.h    | 2 ++
 arch/parisc/include/asm/barrier.h     | 1 +
 arch/powerpc/include/asm/barrier.h    | 2 ++
 arch/s390/include/asm/barrier.h       | 1 +
 arch/score/include/asm/barrier.h      | 1 +
 arch/sh/include/asm/barrier.h         | 2 ++
 arch/sparc/include/asm/barrier_32.h   | 1 +
 arch/sparc/include/asm/barrier_64.h   | 3 +++
 arch/tile/include/asm/barrier.h       | 2 ++
 arch/unicore32/include/asm/barrier.h  | 1 +
 arch/x86/include/asm/barrier.h        | 3 +++
 arch/xtensa/include/asm/barrier.h     | 1 +
 28 files changed, 48 insertions(+)

diff --git a/arch/alpha/include/asm/barrier.h b/arch/alpha/include/asm/barrier.h
index ce8860a0b32d..02ea63897038 100644
--- a/arch/alpha/include/asm/barrier.h
+++ b/arch/alpha/include/asm/barrier.h
@@ -18,12 +18,14 @@ __asm__ __volatile__("mb": : :"memory")
 #ifdef CONFIG_SMP
 #define __ASM_SMP_MB	"\tmb\n"
 #define smp_mb()	mb()
+#define smp_tmb()	mb()
 #define smp_rmb()	rmb()
 #define smp_wmb()	wmb()
 #define smp_read_barrier_depends()	read_barrier_depends()
 #else
 #define __ASM_SMP_MB
 #define smp_mb()	barrier()
+#define smp_tmb()	barrier()
 #define smp_rmb()	barrier()
 #define smp_wmb()	barrier()
 #define smp_read_barrier_depends()	do { } while (0)
diff --git a/arch/arc/include/asm/barrier.h b/arch/arc/include/asm/barrier.h
index f6cb7c4ffb35..456c790fa1ad 100644
--- a/arch/arc/include/asm/barrier.h
+++ b/arch/arc/include/asm/barrier.h
@@ -22,10 +22,12 @@
 /* TODO-vineetg verify the correctness of macros here */
 #ifdef CONFIG_SMP
 #define smp_mb()        mb()
+#define smp_tmb()	mb()
 #define smp_rmb()       rmb()
 #define smp_wmb()       wmb()
 #else
 #define smp_mb()        barrier()
+#define smp_tmb()	barrier()
 #define smp_rmb()       barrier()
 #define smp_wmb()       barrier()
 #endif
diff --git a/arch/arm/include/asm/barrier.h b/arch/arm/include/asm/barrier.h
index 60f15e274e6d..bc88a8505673 100644
--- a/arch/arm/include/asm/barrier.h
+++ b/arch/arm/include/asm/barrier.h
@@ -51,10 +51,12 @@
 
 #ifndef CONFIG_SMP
 #define smp_mb()	barrier()
+#define smp_tmb()	barrier()
 #define smp_rmb()	barrier()
 #define smp_wmb()	barrier()
 #else
 #define smp_mb()	dmb(ish)
+#define smp_tmb()	smp_mb()
 #define smp_rmb()	smp_mb()
 #define smp_wmb()	dmb(ishst)
 #endif
diff --git a/arch/arm64/include/asm/barrier.h b/arch/arm64/include/asm/barrier.h
index d4a63338a53c..ec0531f4892f 100644
--- a/arch/arm64/include/asm/barrier.h
+++ b/arch/arm64/include/asm/barrier.h
@@ -33,10 +33,12 @@
 
 #ifndef CONFIG_SMP
 #define smp_mb()	barrier()
+#define smp_tmb()	barrier()
 #define smp_rmb()	barrier()
 #define smp_wmb()	barrier()
 #else
 #define smp_mb()	asm volatile("dmb ish" : : : "memory")
+#define smp_tmb()	asm volatile("dmb ish" : : : "memory")
 #define smp_rmb()	asm volatile("dmb ishld" : : : "memory")
 #define smp_wmb()	asm volatile("dmb ishst" : : : "memory")
 #endif
diff --git a/arch/avr32/include/asm/barrier.h b/arch/avr32/include/asm/barrier.h
index 0961275373db..6c6ccb9cf290 100644
--- a/arch/avr32/include/asm/barrier.h
+++ b/arch/avr32/include/asm/barrier.h
@@ -20,6 +20,7 @@
 # error "The AVR32 port does not support SMP"
 #else
 # define smp_mb()		barrier()
+# define smp_tmb()		barrier()
 # define smp_rmb()		barrier()
 # define smp_wmb()		barrier()
 # define smp_read_barrier_depends() do { } while(0)
diff --git a/arch/blackfin/include/asm/barrier.h b/arch/blackfin/include/asm/barrier.h
index ebb189507dd7..100f49121a18 100644
--- a/arch/blackfin/include/asm/barrier.h
+++ b/arch/blackfin/include/asm/barrier.h
@@ -40,6 +40,7 @@
 #endif /* !CONFIG_SMP */
 
 #define smp_mb()  mb()
+#define smp_tmb() mb()
 #define smp_rmb() rmb()
 #define smp_wmb() wmb()
 #define set_mb(var, value) do { var = value; mb(); } while (0)
diff --git a/arch/cris/include/asm/barrier.h b/arch/cris/include/asm/barrier.h
index 198ad7fa6b25..679c33738b4c 100644
--- a/arch/cris/include/asm/barrier.h
+++ b/arch/cris/include/asm/barrier.h
@@ -12,11 +12,13 @@
 
 #ifdef CONFIG_SMP
 #define smp_mb()        mb()
+#define smp_tmb()       mb()
 #define smp_rmb()       rmb()
 #define smp_wmb()       wmb()
 #define smp_read_barrier_depends()     read_barrier_depends()
 #else
 #define smp_mb()        barrier()
+#define smp_tmb()       barrier()
 #define smp_rmb()       barrier()
 #define smp_wmb()       barrier()
 #define smp_read_barrier_depends()     do { } while(0)
diff --git a/arch/frv/include/asm/barrier.h b/arch/frv/include/asm/barrier.h
index 06776ad9f5e9..60354ce13ba0 100644
--- a/arch/frv/include/asm/barrier.h
+++ b/arch/frv/include/asm/barrier.h
@@ -20,6 +20,7 @@
 #define read_barrier_depends()	do { } while (0)
 
 #define smp_mb()			barrier()
+#define smp_tmb()			barrier()
 #define smp_rmb()			barrier()
 #define smp_wmb()			barrier()
 #define smp_read_barrier_depends()	do {} while(0)
diff --git a/arch/h8300/include/asm/barrier.h b/arch/h8300/include/asm/barrier.h
index 9e0aa9fc195d..e8e297fa4e9a 100644
--- a/arch/h8300/include/asm/barrier.h
+++ b/arch/h8300/include/asm/barrier.h
@@ -16,11 +16,13 @@
 
 #ifdef CONFIG_SMP
 #define smp_mb()	mb()
+#define smp_tmb()	mb()
 #define smp_rmb()	rmb()
 #define smp_wmb()	wmb()
 #define smp_read_barrier_depends()	read_barrier_depends()
 #else
 #define smp_mb()	barrier()
+#define smp_tmb()	barrier()
 #define smp_rmb()	barrier()
 #define smp_wmb()	barrier()
 #define smp_read_barrier_depends()	do { } while(0)
diff --git a/arch/hexagon/include/asm/barrier.h b/arch/hexagon/include/asm/barrier.h
index 1041a8e70ce8..2dd5b2ad4d21 100644
--- a/arch/hexagon/include/asm/barrier.h
+++ b/arch/hexagon/include/asm/barrier.h
@@ -28,6 +28,7 @@
 #define smp_rmb()			barrier()
 #define smp_read_barrier_depends()	barrier()
 #define smp_wmb()			barrier()
+#define smp_tmb()			barrier()
 #define smp_mb()			barrier()
 #define smp_mb__before_atomic_dec()	barrier()
 #define smp_mb__after_atomic_dec()	barrier()
diff --git a/arch/ia64/include/asm/barrier.h b/arch/ia64/include/asm/barrier.h
index 60576e06b6fb..a5f92146b091 100644
--- a/arch/ia64/include/asm/barrier.h
+++ b/arch/ia64/include/asm/barrier.h
@@ -42,11 +42,13 @@
 
 #ifdef CONFIG_SMP
 # define smp_mb()	mb()
+# define smp_tmb()	mb()
 # define smp_rmb()	rmb()
 # define smp_wmb()	wmb()
 # define smp_read_barrier_depends()	read_barrier_depends()
 #else
 # define smp_mb()	barrier()
+# define smp_tmb()	barrier()
 # define smp_rmb()	barrier()
 # define smp_wmb()	barrier()
 # define smp_read_barrier_depends()	do { } while(0)
diff --git a/arch/m32r/include/asm/barrier.h b/arch/m32r/include/asm/barrier.h
index 6976621efd3f..a6fa29facd7a 100644
--- a/arch/m32r/include/asm/barrier.h
+++ b/arch/m32r/include/asm/barrier.h
@@ -79,12 +79,14 @@
 
 #ifdef CONFIG_SMP
 #define smp_mb()	mb()
+#define smp_tmb()	mb()
 #define smp_rmb()	rmb()
 #define smp_wmb()	wmb()
 #define smp_read_barrier_depends()	read_barrier_depends()
 #define set_mb(var, value) do { (void) xchg(&var, value); } while (0)
 #else
 #define smp_mb()	barrier()
+#define smp_tmb()	barrier()
 #define smp_rmb()	barrier()
 #define smp_wmb()	barrier()
 #define smp_read_barrier_depends()	do { } while (0)
diff --git a/arch/m68k/include/asm/barrier.h b/arch/m68k/include/asm/barrier.h
index 445ce22c23cb..8ecf52c87847 100644
--- a/arch/m68k/include/asm/barrier.h
+++ b/arch/m68k/include/asm/barrier.h
@@ -13,6 +13,7 @@
 #define set_mb(var, value)	({ (var) = (value); wmb(); })
 
 #define smp_mb()	barrier()
+#define smp_tmb()	barrier()
 #define smp_rmb()	barrier()
 #define smp_wmb()	barrier()
 #define smp_read_barrier_depends()	((void)0)
diff --git a/arch/metag/include/asm/barrier.h b/arch/metag/include/asm/barrier.h
index c90bfc6bf648..eb179fbce580 100644
--- a/arch/metag/include/asm/barrier.h
+++ b/arch/metag/include/asm/barrier.h
@@ -50,6 +50,7 @@ static inline void wmb(void)
 #ifndef CONFIG_SMP
 #define fence()		do { } while (0)
 #define smp_mb()        barrier()
+#define smp_tmb()       barrier()
 #define smp_rmb()       barrier()
 #define smp_wmb()       barrier()
 #else
@@ -70,11 +71,13 @@ static inline void fence(void)
 	*flushptr = 0;
 }
 #define smp_mb()        fence()
+#define smp_tmb()       fence()
 #define smp_rmb()       fence()
 #define smp_wmb()       barrier()
 #else
 #define fence()		do { } while (0)
 #define smp_mb()        barrier()
+#define smp_tmb()       barrier()
 #define smp_rmb()       barrier()
 #define smp_wmb()       barrier()
 #endif
diff --git a/arch/microblaze/include/asm/barrier.h b/arch/microblaze/include/asm/barrier.h
index df5be3e87044..d573c170a717 100644
--- a/arch/microblaze/include/asm/barrier.h
+++ b/arch/microblaze/include/asm/barrier.h
@@ -21,6 +21,7 @@
 #define set_wmb(var, value)	do { var = value; wmb(); } while (0)
 
 #define smp_mb()		mb()
+#define smp_tmb()		mb()
 #define smp_rmb()		rmb()
 #define smp_wmb()		wmb()
 
diff --git a/arch/mips/include/asm/barrier.h b/arch/mips/include/asm/barrier.h
index 314ab5532019..535e699eec3b 100644
--- a/arch/mips/include/asm/barrier.h
+++ b/arch/mips/include/asm/barrier.h
@@ -144,15 +144,18 @@
 #if defined(CONFIG_WEAK_ORDERING) && defined(CONFIG_SMP)
 # ifdef CONFIG_CPU_CAVIUM_OCTEON
 #  define smp_mb()	__sync()
+#  define smp_tmb()	__sync()
 #  define smp_rmb()	barrier()
 #  define smp_wmb()	__syncw()
 # else
 #  define smp_mb()	__asm__ __volatile__("sync" : : :"memory")
+#  define smp_tmb()	__asm__ __volatile__("sync" : : :"memory")
 #  define smp_rmb()	__asm__ __volatile__("sync" : : :"memory")
 #  define smp_wmb()	__asm__ __volatile__("sync" : : :"memory")
 # endif
 #else
 #define smp_mb()	barrier()
+#define smp_tmb()	barrier()
 #define smp_rmb()	barrier()
 #define smp_wmb()	barrier()
 #endif
diff --git a/arch/mn10300/include/asm/barrier.h b/arch/mn10300/include/asm/barrier.h
index 2bd97a5c8af7..a345b0776e5f 100644
--- a/arch/mn10300/include/asm/barrier.h
+++ b/arch/mn10300/include/asm/barrier.h
@@ -19,11 +19,13 @@
 
 #ifdef CONFIG_SMP
 #define smp_mb()	mb()
+#define smp_tmb()	mb()
 #define smp_rmb()	rmb()
 #define smp_wmb()	wmb()
 #define set_mb(var, value)  do { xchg(&var, value); } while (0)
 #else  /* CONFIG_SMP */
 #define smp_mb()	barrier()
+#define smp_tmb()	barrier()
 #define smp_rmb()	barrier()
 #define smp_wmb()	barrier()
 #define set_mb(var, value)  do { var = value;  mb(); } while (0)
diff --git a/arch/parisc/include/asm/barrier.h b/arch/parisc/include/asm/barrier.h
index e77d834aa803..f53196b589ec 100644
--- a/arch/parisc/include/asm/barrier.h
+++ b/arch/parisc/include/asm/barrier.h
@@ -25,6 +25,7 @@
 #define rmb()		mb()
 #define wmb()		mb()
 #define smp_mb()	mb()
+#define smp_tmb()	mb()
 #define smp_rmb()	mb()
 #define smp_wmb()	mb()
 #define smp_read_barrier_depends()	do { } while(0)
diff --git a/arch/powerpc/include/asm/barrier.h b/arch/powerpc/include/asm/barrier.h
index ae782254e731..d7e8a560f1fe 100644
--- a/arch/powerpc/include/asm/barrier.h
+++ b/arch/powerpc/include/asm/barrier.h
@@ -46,11 +46,13 @@
 #endif
 
 #define smp_mb()	mb()
+#define smp_tmb()	__asm__ __volatile__ (stringify_in_c(LWSYNC) : : :"memory")
 #define smp_rmb()	__asm__ __volatile__ (stringify_in_c(LWSYNC) : : :"memory")
 #define smp_wmb()	__asm__ __volatile__ (stringify_in_c(SMPWMB) : : :"memory")
 #define smp_read_barrier_depends()	read_barrier_depends()
 #else
 #define smp_mb()	barrier()
+#define smp_tmb()	barrier()
 #define smp_rmb()	barrier()
 #define smp_wmb()	barrier()
 #define smp_read_barrier_depends()	do { } while(0)
diff --git a/arch/s390/include/asm/barrier.h b/arch/s390/include/asm/barrier.h
index 16760eeb79b0..f0409a874243 100644
--- a/arch/s390/include/asm/barrier.h
+++ b/arch/s390/include/asm/barrier.h
@@ -24,6 +24,7 @@
 #define wmb()				mb()
 #define read_barrier_depends()		do { } while(0)
 #define smp_mb()			mb()
+#define smp_tmb()			mb()
 #define smp_rmb()			rmb()
 #define smp_wmb()			wmb()
 #define smp_read_barrier_depends()	read_barrier_depends()
diff --git a/arch/score/include/asm/barrier.h b/arch/score/include/asm/barrier.h
index 0eacb6471e6d..865652083dde 100644
--- a/arch/score/include/asm/barrier.h
+++ b/arch/score/include/asm/barrier.h
@@ -5,6 +5,7 @@
 #define rmb()		barrier()
 #define wmb()		barrier()
 #define smp_mb()	barrier()
+#define smp_tmb()	barrier()
 #define smp_rmb()	barrier()
 #define smp_wmb()	barrier()
 
diff --git a/arch/sh/include/asm/barrier.h b/arch/sh/include/asm/barrier.h
index 72c103dae300..f8dce7926432 100644
--- a/arch/sh/include/asm/barrier.h
+++ b/arch/sh/include/asm/barrier.h
@@ -39,11 +39,13 @@
 
 #ifdef CONFIG_SMP
 #define smp_mb()	mb()
+#define smp_tmb()	mb()
 #define smp_rmb()	rmb()
 #define smp_wmb()	wmb()
 #define smp_read_barrier_depends()	read_barrier_depends()
 #else
 #define smp_mb()	barrier()
+#define smp_tmb()	barrier()
 #define smp_rmb()	barrier()
 #define smp_wmb()	barrier()
 #define smp_read_barrier_depends()	do { } while(0)
diff --git a/arch/sparc/include/asm/barrier_32.h b/arch/sparc/include/asm/barrier_32.h
index c1b76654ee76..1037ce189cee 100644
--- a/arch/sparc/include/asm/barrier_32.h
+++ b/arch/sparc/include/asm/barrier_32.h
@@ -8,6 +8,7 @@
 #define read_barrier_depends()	do { } while(0)
 #define set_mb(__var, __value)  do { __var = __value; mb(); } while(0)
 #define smp_mb()	__asm__ __volatile__("":::"memory")
+#define smp_tmb()	__asm__ __volatile__("":::"memory")
 #define smp_rmb()	__asm__ __volatile__("":::"memory")
 #define smp_wmb()	__asm__ __volatile__("":::"memory")
 #define smp_read_barrier_depends()	do { } while(0)
diff --git a/arch/sparc/include/asm/barrier_64.h b/arch/sparc/include/asm/barrier_64.h
index 95d45986f908..0f3c2fdb86b8 100644
--- a/arch/sparc/include/asm/barrier_64.h
+++ b/arch/sparc/include/asm/barrier_64.h
@@ -34,6 +34,7 @@ do {	__asm__ __volatile__("ba,pt	%%xcc, 1f\n\t" \
  * memory ordering than required by the specifications.
  */
 #define mb()	membar_safe("#StoreLoad")
+#define tmb()	__asm__ __volatile__("":::"memory")
 #define rmb()	__asm__ __volatile__("":::"memory")
 #define wmb()	__asm__ __volatile__("":::"memory")
 
@@ -43,10 +44,12 @@ do {	__asm__ __volatile__("ba,pt	%%xcc, 1f\n\t" \
 
 #ifdef CONFIG_SMP
 #define smp_mb()	mb()
+#define smp_tmb()	tmb()
 #define smp_rmb()	rmb()
 #define smp_wmb()	wmb()
 #else
 #define smp_mb()	__asm__ __volatile__("":::"memory")
+#define smp_tmb()	__asm__ __volatile__("":::"memory")
 #define smp_rmb()	__asm__ __volatile__("":::"memory")
 #define smp_wmb()	__asm__ __volatile__("":::"memory")
 #endif
diff --git a/arch/tile/include/asm/barrier.h b/arch/tile/include/asm/barrier.h
index a9a73da5865d..cad3c6ae28bf 100644
--- a/arch/tile/include/asm/barrier.h
+++ b/arch/tile/include/asm/barrier.h
@@ -127,11 +127,13 @@ mb_incoherent(void)
 
 #ifdef CONFIG_SMP
 #define smp_mb()	mb()
+#define smp_tmb()	mb()
 #define smp_rmb()	rmb()
 #define smp_wmb()	wmb()
 #define smp_read_barrier_depends()	read_barrier_depends()
 #else
 #define smp_mb()	barrier()
+#define smp_tmb()	barrier()
 #define smp_rmb()	barrier()
 #define smp_wmb()	barrier()
 #define smp_read_barrier_depends()	do { } while (0)
diff --git a/arch/unicore32/include/asm/barrier.h b/arch/unicore32/include/asm/barrier.h
index a6620e5336b6..8b341fffbda6 100644
--- a/arch/unicore32/include/asm/barrier.h
+++ b/arch/unicore32/include/asm/barrier.h
@@ -18,6 +18,7 @@
 #define rmb()				barrier()
 #define wmb()				barrier()
 #define smp_mb()			barrier()
+#define smp_tmb()			barrier()
 #define smp_rmb()			barrier()
 #define smp_wmb()			barrier()
 #define read_barrier_depends()		do { } while (0)
diff --git a/arch/x86/include/asm/barrier.h b/arch/x86/include/asm/barrier.h
index c6cd358a1eec..480201d83af1 100644
--- a/arch/x86/include/asm/barrier.h
+++ b/arch/x86/include/asm/barrier.h
@@ -86,14 +86,17 @@
 # define smp_rmb()	barrier()
 #endif
 #ifdef CONFIG_X86_OOSTORE
+# define smp_tmb()	mb()
 # define smp_wmb() 	wmb()
 #else
+# define smp_tmb()	barrier()
 # define smp_wmb()	barrier()
 #endif
 #define smp_read_barrier_depends()	read_barrier_depends()
 #define set_mb(var, value) do { (void)xchg(&var, value); } while (0)
 #else
 #define smp_mb()	barrier()
+#define smp_tmb()	barrier()
 #define smp_rmb()	barrier()
 #define smp_wmb()	barrier()
 #define smp_read_barrier_depends()	do { } while (0)
diff --git a/arch/xtensa/include/asm/barrier.h b/arch/xtensa/include/asm/barrier.h
index ef021677d536..7839db843ea5 100644
--- a/arch/xtensa/include/asm/barrier.h
+++ b/arch/xtensa/include/asm/barrier.h
@@ -20,6 +20,7 @@
 #error smp_* not defined
 #else
 #define smp_mb()	barrier()
+#define smp_tmb()	barrier()
 #define smp_rmb()	barrier()
 #define smp_wmb()	barrier()
 #endif

