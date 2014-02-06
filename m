Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932786AbaBFNwx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Feb 2014 08:52:53 -0500
Received: from merlin.infradead.org ([205.233.59.134]:49168 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932712AbaBFNwW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Feb 2014 08:52:22 -0500
Message-Id: <20140206135001.333583247@infradead.org>
User-Agent: quilt/0.60-1
Date: Thu, 06 Feb 2014 14:48:30 +0100
From: Peter Zijlstra <peterz@infradead.org>
To: linux-arch@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org, mingo@kernel.org,
        will.deacon@arm.com, paulmck@linux.vnet.ibm.com,
        Peter Zijlstra <peterz@infradead.org>
Subject: [RFC][PATCH 5/5] arch: Sanitize atomic_t bitwise ops
References: <20140206134825.305510953@infradead.org>
Content-Disposition: inline; filename=peterz-arch-atomic-kill-mask.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Many archs have atomic_{set,clear}_mask() but not all. Remove these
and provide a comprehensive set of bitops:

  atomic{,64}_{and,or,xor}{,_return}()

for everybody.

Signed-off-by: Peter Zijlstra <peterz@infradead.org>
---
 arch/alpha/include/asm/atomic.h        |    3 +
 arch/arc/include/asm/atomic.h          |   29 ++---------
 arch/arm/include/asm/atomic.h          |   23 ++++----
 arch/arm64/include/asm/atomic.h        |    8 ++-
 arch/avr32/include/asm/atomic.h        |    3 +
 arch/blackfin/include/asm/atomic.h     |    5 +
 arch/blackfin/mach-common/smp.c        |    2 
 arch/cris/include/asm/atomic.h         |    3 +
 arch/hexagon/include/asm/atomic.h      |    3 +
 arch/ia64/include/asm/atomic.h         |   32 ++++++++++--
 arch/m32r/include/asm/atomic.h         |   44 +---------------
 arch/m32r/kernel/smp.c                 |    4 -
 arch/m68k/include/asm/atomic.h         |   13 +---
 arch/metag/include/asm/atomic_lnkget.h |   37 +-------------
 arch/metag/include/asm/atomic_lock1.h  |   23 +-------
 arch/mips/include/asm/atomic.h         |    6 ++
 arch/mn10300/include/asm/atomic.h      |   70 +-------------------------
 arch/mn10300/mm/tlb-smp.c              |    2 
 arch/parisc/include/asm/atomic.h       |    6 ++
 arch/powerpc/include/asm/atomic.h      |    8 ++-
 arch/powerpc/kernel/misc_32.S          |   19 -------
 arch/s390/include/asm/atomic.h         |   87 ++++++++++++++++++++-------------
 arch/s390/kernel/time.c                |    4 -
 arch/s390/kvm/diag.c                   |    2 
 arch/s390/kvm/intercept.c              |    2 
 arch/s390/kvm/interrupt.c              |   16 +++---
 arch/s390/kvm/kvm-s390.c               |   14 ++---
 arch/s390/kvm/sigp.c                   |    6 +-
 arch/sh/include/asm/atomic-grb.h       |   42 +--------------
 arch/sh/include/asm/atomic-irq.h       |   21 +------
 arch/sh/include/asm/atomic-llsc.h      |   31 +----------
 arch/sparc/include/asm/atomic_32.h     |    4 +
 arch/sparc/include/asm/atomic_64.h     |    3 +
 arch/sparc/lib/atomic32.c              |    5 +
 arch/sparc/lib/atomic_64.S             |    6 ++
 arch/sparc/lib/ksyms.c                 |    3 +
 arch/x86/include/asm/atomic.h          |   32 ++++++++----
 arch/x86/include/asm/atomic64_32.h     |   20 +++++++
 arch/x86/include/asm/atomic64_64.h     |   22 ++++++++
 arch/xtensa/include/asm/atomic.h       |   72 +--------------------------
 drivers/gpu/drm/i915/i915_irq.c        |    4 -
 drivers/s390/scsi/zfcp_aux.c           |    2 
 drivers/s390/scsi/zfcp_erp.c           |   68 ++++++++++++-------------
 drivers/s390/scsi/zfcp_fc.c            |    8 +--
 drivers/s390/scsi/zfcp_fsf.c           |   30 +++++------
 drivers/s390/scsi/zfcp_qdio.c          |   14 ++---
 include/asm-generic/atomic.h           |   34 +++++++-----
 include/asm-generic/atomic64.h         |   17 ++++--
 include/linux/atomic.h                 |   13 ----
 lib/atomic64.c                         |   77 +++++++++++------------------
 50 files changed, 404 insertions(+), 598 deletions(-)

--- a/arch/alpha/include/asm/atomic.h
+++ b/arch/alpha/include/asm/atomic.h
@@ -103,6 +103,9 @@ static __inline__ long atomic64_##op##_r
 
 ATOMIC_OPS(add)
 ATOMIC_OPS(sub)
+ATOMIC_OPS(and)
+ATOMIC_OPS(or)
+ATOMIC_OPS(xor)
 
 #undef ATOMIC_OPS
 #undef ATOMIC64_OP
--- a/arch/arc/include/asm/atomic.h
+++ b/arch/arc/include/asm/atomic.h
@@ -58,23 +58,12 @@ static inline int atomic_##op##_return(i
 
 ATOMIC_OP(add)
 ATOMIC_OP(sub)
+ATOMIC_OP(and)
+ATOMIC_OP(or)
+ATOMIC_OP(xor)
 
 #undef ATOMIC_OP
 
-static inline void atomic_clear_mask(unsigned long mask, unsigned long *addr)
-{
-	unsigned int temp;
-
-	__asm__ __volatile__(
-	"1:	llock   %0, [%1]	\n"
-	"	bic     %0, %0, %2	\n"
-	"	scond   %0, [%1]	\n"
-	"	bnz     1b		\n"
-	: "=&r"(temp)
-	: "r"(addr), "ir"(mask)
-	: "cc");
-}
-
 #else	/* !CONFIG_ARC_HAS_LLSC */
 
 #ifndef CONFIG_SMP
@@ -134,18 +123,12 @@ static inline int atomic_##opn##_return(
 
 ATOMIC_OP(add, +=)
 ATOMIC_OP(sub, -=)
+ATOMIC_OP(and, &=)
+ATOMIC_OP(or, |=)
+ATOMIC_OP(xor, ^=)
 
 #undef ATOMIC_OP
 
-static inline void atomic_clear_mask(unsigned long mask, unsigned long *addr)
-{
-	unsigned long flags;
-
-	atomic_ops_lock(flags);
-	*addr &= ~mask;
-	atomic_ops_unlock(flags);
-}
-
 #endif /* !CONFIG_ARC_HAS_LLSC */
 
 /**
--- a/arch/arm/include/asm/atomic.h
+++ b/arch/arm/include/asm/atomic.h
@@ -38,7 +38,7 @@
  * to ensure that the update happens.
  */
 
-#define ATOMIC_OP(op)							\
+#define ATOMIC_OP(op, cop)						\
 static inline void atomic_##op(int i, atomic_t *v)			\
 {									\
 	unsigned long tmp;						\
@@ -78,11 +78,6 @@ static inline int atomic_##op##_return(i
 	return result;							\
 }
 
-ATOMIC_OP(add)
-ATOMIC_OP(sub)
-
-#undef ATOMIC_OP
-
 static inline int atomic_cmpxchg(atomic_t *ptr, int old, int new)
 {
 	int oldval;
@@ -135,11 +130,6 @@ static inline int atomic_##opn##_return(
 	return val;							\
 }
 
-ATOMIC_OP(add, +=)
-ATOMIC_OP(sub, -=)
-
-#undef ATOMIC_OP
-
 static inline int atomic_cmpxchg(atomic_t *v, int old, int new)
 {
 	int ret;
@@ -156,6 +146,14 @@ static inline int atomic_cmpxchg(atomic_
 
 #endif /* __LINUX_ARM_ARCH__ */
 
+ATOMIC_OP(add, +=)
+ATOMIC_OP(sub, -=)
+ATOMIC_OP(and, &=)
+ATOMIC_OP(or, |=)
+ATOMIC_OP(xor, ^=)
+
+#undef ATOMIC_OP
+
 #define atomic_xchg(v, new) (xchg(&((v)->counter), new))
 
 static inline int __atomic_add_unless(atomic_t *v, int a, int u)
@@ -282,6 +280,9 @@ static inline long long atomic64_##opn##
 
 ATOMIC64_OP(add, adds, adc)
 ATOMIC64_OP(sub, subs, sbc)
+ATOMIC64_OP(and, and, and)
+ATOMIC64_OP(or, or, or)
+ATOMIC64_OP(xor, xor, xor)
 
 #undef ATOMIC64_OP
 
--- a/arch/arm64/include/asm/atomic.h
+++ b/arch/arm64/include/asm/atomic.h
@@ -80,6 +80,9 @@ static inline int atomic_##op##_return(i
 
 ATOMIC_OP(add)
 ATOMIC_OP(sub)
+ATOMIC_OP(and)
+ATOMIC_OP(or)
+ATOMIC_OP(xor)
 
 #undef ATOMIC_OP
 
@@ -136,7 +139,7 @@ static inline int __atomic_add_unless(at
 #define atomic64_read(v)	(*(volatile long long *)&(v)->counter)
 #define atomic64_set(v,i)	(((v)->counter) = (i))
 
-#define ATOMIC64_OP(op)							\
+#define ATOMIC_OP(op)							\
 static inline void atomic64_##op(long i, atomic64_t *v)			\
 {									\
 	long result;							\
@@ -172,6 +175,9 @@ static inline long atomic64_##op##_retur
 
 ATOMIC64_OP(add)
 ATOMIC64_OP(sub)
+ATOMIC64_OP(and)
+ATOMIC64_OP(or)
+ATOMIC64_OP(xor)
 
 #undef ATOMIC64_OP
 
--- a/arch/avr32/include/asm/atomic.h
+++ b/arch/avr32/include/asm/atomic.h
@@ -59,6 +59,9 @@ static inline int atomic_##op##_return(i
 
 ATOMIC_OP(add)
 ATOMIC_OP(sub)
+ATOMIC_OP(and)
+ATOMIC_OP(or)
+ATOMIC_OP(xor)
 
 #undef ATOMIC_OP
 
--- a/arch/blackfin/include/asm/atomic.h
+++ b/arch/blackfin/include/asm/atomic.h
@@ -27,8 +27,9 @@ asmlinkage int __raw_atomic_test_asm(con
 #define atomic_add_return(i, v) __raw_atomic_update_asm(&(v)->counter, i)
 #define atomic_sub_return(i, v) __raw_atomic_update_asm(&(v)->counter, -(i))
 
-#define atomic_clear_mask(m, v) __raw_atomic_clear_asm(&(v)->counter, m)
-#define atomic_set_mask(m, v)   __raw_atomic_set_asm(&(v)->counter, m)
+#define atomic_and_return(m, v) __raw_atomic_clear_asm(&(v)->counter, ~m)
+#define atomic_or_return(m, v)  __raw_atomic_set_asm(&(v)->counter, m)
+#define atomic_xor_return(m, v) __raw_atomic_xor_asm(&(v)->counter, m)
 
 #endif
 
--- a/arch/blackfin/mach-common/smp.c
+++ b/arch/blackfin/mach-common/smp.c
@@ -195,7 +195,7 @@ void send_ipi(const struct cpumask *cpum
 	local_irq_save(flags);
 	for_each_cpu(cpu, cpumask) {
 		bfin_ipi_data = &per_cpu(bfin_ipi, cpu);
-		atomic_set_mask((1 << msg), &bfin_ipi_data->bits);
+		atomic_or((1 << msg), &bfin_ipi_data->bits);
 		atomic_inc(&bfin_ipi_data->count);
 	}
 	local_irq_restore(flags);
--- a/arch/cris/include/asm/atomic.h
+++ b/arch/cris/include/asm/atomic.h
@@ -42,6 +42,9 @@ static inline int atomic_##opn##_return(
 
 ATOMIC_OP(add, +=)
 ATOMIC_OP(sub, -=)
+ATOMIC_OP(and, &=)
+ATOMIC_OP(or, |=)
+ATOMIC_OP(xor, ^=)
 
 #undef ATOMIC_OP
 
--- a/arch/hexagon/include/asm/atomic.h
+++ b/arch/hexagon/include/asm/atomic.h
@@ -115,6 +115,9 @@ static inline int atomic_##op##_return(i
 
 ATOMIC_OP(add)
 ATOMIC_OP(sub)
+ATOMIC_OP(and)
+ATOMIC_OP(or)
+ATOMIC_OP(xor)
 
 #undef ATOMIC_OP
 
--- a/arch/ia64/include/asm/atomic.h
+++ b/arch/ia64/include/asm/atomic.h
@@ -44,8 +44,6 @@ ia64_atomic_##opn (int i, atomic_t *v)
 ATOMIC_OP(add, +)
 ATOMIC_OP(sub, -)
 
-#undef ATOMIC_OP
-
 #define atomic_add_return(i,v)						\
 ({									\
 	int __ia64_aar_i = (i);						\
@@ -70,6 +68,20 @@ ATOMIC_OP(sub, -)
 		: ia64_atomic_sub(__ia64_asr_i, v);			\
 })
 
+ATOMIC_OP(and, &)
+ATOMIC_OP(or, |)
+ATOMIC_OP(xor, ^)
+
+#define atomic_and_return(i,v)	ia64_atomic_and(i,v)
+#define atomic_or_return(i,v)	ia64_atomic_or(i,v)
+#define atomic_xor_return(i,v)	ia64_atomic_xor(i,v)
+
+#define atomic_and(i,v)	(void)ia64_atomic_and(i,v)
+#define atomic_or(i,v)	(void)ia64_atomic_or(i,v)
+#define atomic_xor(i,v)	(void)ia64_atomic_xor(i,v)
+
+#undef ATOMIC_OP
+
 #define ATOMIC64_OP(opn, op)						\
 static __inline__ long							\
 ia64_atomic64_##opn (__s64 i, atomic64_t *v)				\
@@ -88,8 +100,6 @@ ia64_atomic64_##opn (__s64 i, atomic64_t
 ATOMIC64_OP(add, +)
 ATOMIC64_OP(sub, -)
 
-#undef ATOMIC64_OP
-
 #define atomic64_add_return(i,v)					\
 ({									\
 	long __ia64_aar_i = (i);					\
@@ -114,6 +124,20 @@ ATOMIC64_OP(sub, -)
 		: ia64_atomic64_sub(__ia64_asr_i, v);			\
 })
 
+ATOMIC64_OP(and, &)
+ATOMIC64_OP(or, |)
+ATOMIC64_OP(xor, ^)
+
+#define atomic64_and_return(i,v)	ia64_atomic64_and(i,v)
+#define atomic64_or_return(i,v)		ia64_atomic64_or(i,v)
+#define atomic64_xor_return(i,v)	ia64_atomic64_xor(i,v)
+
+#define atomic64_and(i,v)	(void)ia64_atomic64_and(i,v)
+#define atomic64_or(i,v)	(void)ia64_atomic64_or(i,v)
+#define atomic64_xor(i,v)	(void)ia64_atomic64_xor(i,v)
+
+#undef ATOMIC64_OP
+
 #define atomic_cmpxchg(v, old, new) (cmpxchg(&((v)->counter), old, new))
 #define atomic_xchg(v, new) (xchg(&((v)->counter), new))
 
--- a/arch/m32r/include/asm/atomic.h
+++ b/arch/m32r/include/asm/atomic.h
@@ -90,6 +90,9 @@ static __inline__ int atomic_##op##_retu
 
 ATOMIC_OP(add)
 ATOMIC_OP(sub)
+ATOMIC_OP(and)
+ATOMIC_OP(or)
+ATOMIC_OP(xor)
 
 #undef ATOMIC_OP
 
@@ -234,45 +237,4 @@ static __inline__ int __atomic_add_unles
 	return c;
 }
 
-
-static __inline__ void atomic_clear_mask(unsigned long  mask, atomic_t *addr)
-{
-	unsigned long flags;
-	unsigned long tmp;
-
-	local_irq_save(flags);
-	__asm__ __volatile__ (
-		"# atomic_clear_mask		\n\t"
-		DCACHE_CLEAR("%0", "r5", "%1")
-		M32R_LOCK" %0, @%1;		\n\t"
-		"and	%0, %2;			\n\t"
-		M32R_UNLOCK" %0, @%1;		\n\t"
-		: "=&r" (tmp)
-		: "r" (addr), "r" (~mask)
-		: "memory"
-		__ATOMIC_CLOBBER
-	);
-	local_irq_restore(flags);
-}
-
-static __inline__ void atomic_set_mask(unsigned long  mask, atomic_t *addr)
-{
-	unsigned long flags;
-	unsigned long tmp;
-
-	local_irq_save(flags);
-	__asm__ __volatile__ (
-		"# atomic_set_mask		\n\t"
-		DCACHE_CLEAR("%0", "r5", "%1")
-		M32R_LOCK" %0, @%1;		\n\t"
-		"or	%0, %2;			\n\t"
-		M32R_UNLOCK" %0, @%1;		\n\t"
-		: "=&r" (tmp)
-		: "r" (addr), "r" (mask)
-		: "memory"
-		__ATOMIC_CLOBBER
-	);
-	local_irq_restore(flags);
-}
-
 #endif	/* _ASM_M32R_ATOMIC_H */
--- a/arch/m32r/kernel/smp.c
+++ b/arch/m32r/kernel/smp.c
@@ -156,7 +156,7 @@ void smp_flush_cache_all(void)
 	cpumask_clear_cpu(smp_processor_id(), &cpumask);
 	spin_lock(&flushcache_lock);
 	mask=cpumask_bits(&cpumask);
-	atomic_set_mask(*mask, (atomic_t *)&flushcache_cpumask);
+	atomic_or(*mask, (atomic_t *)&flushcache_cpumask);
 	send_IPI_mask(&cpumask, INVALIDATE_CACHE_IPI, 0);
 	_flush_cache_copyback_all();
 	while (flushcache_cpumask)
@@ -407,7 +407,7 @@ static void flush_tlb_others(cpumask_t c
 	flush_vma = vma;
 	flush_va = va;
 	mask=cpumask_bits(&cpumask);
-	atomic_set_mask(*mask, (atomic_t *)&flush_cpumask);
+	atomic_or(*mask, (atomic_t *)&flush_cpumask);
 
 	/*
 	 * We have to send the IPI only to
--- a/arch/m68k/include/asm/atomic.h
+++ b/arch/m68k/include/asm/atomic.h
@@ -76,6 +76,9 @@ static inline int atomic_##op##_return(i
 
 ATOMIC_OP(add, +=)
 ATOMIC_OP(sub, -=)
+ATOMIC_OP(and, &=)
+ATOMIC_OP(or , |=)
+ATOMIC_OP(xor, ^=)
 
 #undef ATOMIC_OP
 
@@ -168,16 +171,6 @@ static inline int atomic_add_negative(in
 	return c != 0;
 }
 
-static inline void atomic_clear_mask(unsigned long mask, unsigned long *v)
-{
-	__asm__ __volatile__("andl %1,%0" : "+m" (*v) : ASM_DI (~(mask)));
-}
-
-static inline void atomic_set_mask(unsigned long mask, unsigned long *v)
-{
-	__asm__ __volatile__("orl %1,%0" : "+m" (*v) : ASM_DI (mask));
-}
-
 static __inline__ int __atomic_add_unless(atomic_t *v, int a, int u)
 {
 	int c, old;
--- a/arch/metag/include/asm/atomic_lnkget.h
+++ b/arch/metag/include/asm/atomic_lnkget.h
@@ -70,43 +70,12 @@ static inline int atomic_##op##_return(i
 
 ATOMIC_OP(add)
 ATOMIC_OP(sub)
+ATOMIC_OP(and)
+ATOMIC_OP(or)
+ATOMIC_OP(xor)
 
 #undef ATOMIC_OP
 
-static inline void atomic_clear_mask(unsigned int mask, atomic_t *v)
-{
-	int temp;
-
-	asm volatile (
-		"1:	LNKGETD %0, [%1]\n"
-		"	AND	%0, %0, %2\n"
-		"	LNKSETD	[%1] %0\n"
-		"	DEFR	%0, TXSTAT\n"
-		"	ANDT	%0, %0, #HI(0x3f000000)\n"
-		"	CMPT	%0, #HI(0x02000000)\n"
-		"	BNZ	1b\n"
-		: "=&d" (temp)
-		: "da" (&v->counter), "bd" (~mask)
-		: "cc");
-}
-
-static inline void atomic_set_mask(unsigned int mask, atomic_t *v)
-{
-	int temp;
-
-	asm volatile (
-		"1:	LNKGETD %0, [%1]\n"
-		"	OR	%0, %0, %2\n"
-		"	LNKSETD	[%1], %0\n"
-		"	DEFR	%0, TXSTAT\n"
-		"	ANDT	%0, %0, #HI(0x3f000000)\n"
-		"	CMPT	%0, #HI(0x02000000)\n"
-		"	BNZ	1b\n"
-		: "=&d" (temp)
-		: "da" (&v->counter), "bd" (mask)
-		: "cc");
-}
-
 static inline int atomic_cmpxchg(atomic_t *v, int old, int new)
 {
 	int result, temp;
--- a/arch/metag/include/asm/atomic_lock1.h
+++ b/arch/metag/include/asm/atomic_lock1.h
@@ -65,29 +65,12 @@ static inline int atomic_##opn##_return(
 
 ATOMIC_OP(add, +=)
 ATOMIC_OP(sub, -=)
+ATOMIC_OP(and, &=)
+ATOMIC_OP(or, |=)
+ATOMIC_OP(xor, ^=)
 
 #undef ATOMIC_OP
 
-static inline void atomic_clear_mask(unsigned int mask, atomic_t *v)
-{
-	unsigned long flags;
-
-	__global_lock1(flags);
-	fence();
-	v->counter &= ~mask;
-	__global_unlock1(flags);
-}
-
-static inline void atomic_set_mask(unsigned int mask, atomic_t *v)
-{
-	unsigned long flags;
-
-	__global_lock1(flags);
-	fence();
-	v->counter |= mask;
-	__global_unlock1(flags);
-}
-
 static inline int atomic_cmpxchg(atomic_t *v, int old, int new)
 {
 	int ret;
--- a/arch/mips/include/asm/atomic.h
+++ b/arch/mips/include/asm/atomic.h
@@ -128,6 +128,9 @@ static __inline__ int atomic_##op##_retu
 
 ATOMIC_OP(add, addu, +=)
 ATOMIC_OP(sub, subu, -=)
+ATOMIC_OP(and, and, &=)
+ATOMIC_OP(or, or, |=)
+ATOMIC_OP(xor, xor, ^=)
 
 #undef ATOMIC_OP
 
@@ -397,6 +400,9 @@ static __inline__ long atomic64_##op##_r
 
 ATOMIC64_OP(add, daddu, +=)
 ATOMIC64_OP(sub, dsubu, -=)
+ATOMIC64_OP(and, and, &=)
+ATOMIC64_OP(or, or, |=)
+ATOMIC64_OP(xor, xor, ^=)
 
 #undef ATOMIC64_OP
 
--- a/arch/mn10300/include/asm/atomic.h
+++ b/arch/mn10300/include/asm/atomic.h
@@ -85,6 +85,9 @@ static inline int atomic_##op##_return(i
 
 ATOMIC_OP(add)
 ATOMIC_OP(sub)
+ATOMIC_OP(and)
+ATOMIC_OP(or )
+ATOMIC_OP(xor)
 
 #undef ATOMIC_OP
 
@@ -122,73 +125,6 @@ static inline void atomic_dec(atomic_t *
 #define atomic_xchg(ptr, v)		(xchg(&(ptr)->counter, (v)))
 #define atomic_cmpxchg(v, old, new)	(cmpxchg(&((v)->counter), (old), (new)))
 
-/**
- * atomic_clear_mask - Atomically clear bits in memory
- * @mask: Mask of the bits to be cleared
- * @v: pointer to word in memory
- *
- * Atomically clears the bits set in mask from the memory word specified.
- */
-static inline void atomic_clear_mask(unsigned long mask, unsigned long *addr)
-{
-#ifdef CONFIG_SMP
-	int status;
-
-	asm volatile(
-		"1:	mov	%3,(_AAR,%2)	\n"
-		"	mov	(_ADR,%2),%0	\n"
-		"	and	%4,%0		\n"
-		"	mov	%0,(_ADR,%2)	\n"
-		"	mov	(_ADR,%2),%0	\n"	/* flush */
-		"	mov	(_ASR,%2),%0	\n"
-		"	or	%0,%0		\n"
-		"	bne	1b		\n"
-		: "=&r"(status), "=m"(*addr)
-		: "a"(ATOMIC_OPS_BASE_ADDR), "r"(addr), "r"(~mask)
-		: "memory", "cc");
-#else
-	unsigned long flags;
-
-	mask = ~mask;
-	flags = arch_local_cli_save();
-	*addr &= mask;
-	arch_local_irq_restore(flags);
-#endif
-}
-
-/**
- * atomic_set_mask - Atomically set bits in memory
- * @mask: Mask of the bits to be set
- * @v: pointer to word in memory
- *
- * Atomically sets the bits set in mask from the memory word specified.
- */
-static inline void atomic_set_mask(unsigned long mask, unsigned long *addr)
-{
-#ifdef CONFIG_SMP
-	int status;
-
-	asm volatile(
-		"1:	mov	%3,(_AAR,%2)	\n"
-		"	mov	(_ADR,%2),%0	\n"
-		"	or	%4,%0		\n"
-		"	mov	%0,(_ADR,%2)	\n"
-		"	mov	(_ADR,%2),%0	\n"	/* flush */
-		"	mov	(_ASR,%2),%0	\n"
-		"	or	%0,%0		\n"
-		"	bne	1b		\n"
-		: "=&r"(status), "=m"(*addr)
-		: "a"(ATOMIC_OPS_BASE_ADDR), "r"(addr), "r"(mask)
-		: "memory", "cc");
-#else
-	unsigned long flags;
-
-	flags = arch_local_cli_save();
-	*addr |= mask;
-	arch_local_irq_restore(flags);
-#endif
-}
-
 #endif /* __KERNEL__ */
 #endif /* CONFIG_SMP */
 #endif /* _ASM_ATOMIC_H */
--- a/arch/mn10300/mm/tlb-smp.c
+++ b/arch/mn10300/mm/tlb-smp.c
@@ -119,7 +119,7 @@ static void flush_tlb_others(cpumask_t c
 	flush_mm = mm;
 	flush_va = va;
 #if NR_CPUS <= BITS_PER_LONG
-	atomic_set_mask(cpumask.bits[0], &flush_cpumask.bits[0]);
+	atomic_or(cpumask.bits[0], &flush_cpumask.bits[0]);
 #else
 #error Not supported.
 #endif
--- a/arch/parisc/include/asm/atomic.h
+++ b/arch/parisc/include/asm/atomic.h
@@ -122,6 +122,9 @@ static __inline__ int atomic_##op##_retu
 
 ATOMIC_OP(add, +=)
 ATOMIC_OP(sub, -=)
+ATOMIC_OP(and, &=)
+ATOMIC_OP(or, |=)
+ATOMIC_OP(xor, ^=)
 
 #undef ATOMIC_OP
 
@@ -177,6 +180,9 @@ static __inline__ s64 atomic64_##op##_re
 
 ATOMIC64_OP(add, +=)
 ATOMIC64_OP(sub, -=)
+ATOMIC64_OP(and, &=)
+ATOMIC64_OP(or, |=)
+ATOMIC64_OP(xor, ^=)
 
 #undef ATOMIC64_OP
 
--- a/arch/powerpc/include/asm/atomic.h
+++ b/arch/powerpc/include/asm/atomic.h
@@ -63,6 +63,9 @@ static __inline__ int atomic_##op##_retu
 
 ATOMIC_OP(add, add)
 ATOMIC_OP(sub, subf)
+ATOMIC_OP(and, and)
+ATOMIC_OP(or, or)
+ATOMIC_OP(xor, xor)
 
 #undef ATOMIC_OP
 
@@ -295,7 +298,10 @@ static __inline__ long atomic64_##op##_r
 }
 
 ATOMIC64_OP(add, add)
-ATOMIC64_OP(add, subf)
+ATOMIC64_OP(sub, subf)
+ATOMIC64_OP(and, and)
+ATOMIC64_OP(or, or)
+ATOMIC64_OP(xor, xor)
 
 #undef ATOMIC64_OP
 
--- a/arch/powerpc/kernel/misc_32.S
+++ b/arch/powerpc/kernel/misc_32.S
@@ -593,25 +593,6 @@ _GLOBAL(copy_page)
 	b	2b
 
 /*
- * void atomic_clear_mask(atomic_t mask, atomic_t *addr)
- * void atomic_set_mask(atomic_t mask, atomic_t *addr);
- */
-_GLOBAL(atomic_clear_mask)
-10:	lwarx	r5,0,r4
-	andc	r5,r5,r3
-	PPC405_ERR77(0,r4)
-	stwcx.	r5,0,r4
-	bne-	10b
-	blr
-_GLOBAL(atomic_set_mask)
-10:	lwarx	r5,0,r4
-	or	r5,r5,r3
-	PPC405_ERR77(0,r4)
-	stwcx.	r5,0,r4
-	bne-	10b
-	blr
-
-/*
  * Extended precision shifts.
  *
  * Updated to be valid for shift counts from 0 to 63 inclusive.
--- a/arch/s390/include/asm/atomic.h
+++ b/arch/s390/include/asm/atomic.h
@@ -25,6 +25,7 @@
 #define __ATOMIC_OR	"lao"
 #define __ATOMIC_AND	"lan"
 #define __ATOMIC_ADD	"laa"
+#define __ATOMIC_XOR	"lax"
 
 #define __ATOMIC_LOOP(ptr, op_val, op_string)				\
 ({									\
@@ -44,6 +45,7 @@
 #define __ATOMIC_OR	"or"
 #define __ATOMIC_AND	"nr"
 #define __ATOMIC_ADD	"ar"
+#define __ATOMIC_XOR	"xr"
 
 #define __ATOMIC_LOOP(ptr, op_val, op_string)				\
 ({									\
@@ -114,15 +116,22 @@ static inline void atomic_add(int i, ato
 #define atomic_dec_return(_v)		atomic_sub_return(1, _v)
 #define atomic_dec_and_test(_v)		(atomic_sub_return(1, _v) == 0)
 
-static inline void atomic_clear_mask(unsigned int mask, atomic_t *v)
-{
-	__ATOMIC_LOOP(v, ~mask, __ATOMIC_AND);
+#define ATOMIC_OP(op, OP)						\
+static inline void atomic_##op(int i, atomic_t *v)			\
+{									\
+	__ATOMIC_LOOP(v, i, __ATOMIC_##OP);				\
+}									\
+									\
+static inline int atomic_##op##_return(int i, atomic_t *v)		\
+{									\
+	return __ATOMIC_LOOP(v, i, __ATOMIC_##OP);			\
 }
 
-static inline void atomic_set_mask(unsigned int mask, atomic_t *v)
-{
-	__ATOMIC_LOOP(v, mask, __ATOMIC_OR);
-}
+ATOMIC_OP(and, AND)
+ATOMIC_OP(or, OR)
+ATOMIC_OP(xor, XOR)
+
+#undef ATOMIC_OP
 
 #define atomic_xchg(v, new) (xchg(&((v)->counter), new))
 
@@ -163,6 +172,7 @@ static inline int __atomic_add_unless(at
 #define __ATOMIC64_OR	"laog"
 #define __ATOMIC64_AND	"lang"
 #define __ATOMIC64_ADD	"laag"
+#define __ATOMIC64_XOR	"laxg"
 
 #define __ATOMIC64_LOOP(ptr, op_val, op_string)				\
 ({									\
@@ -182,6 +192,7 @@ static inline int __atomic_add_unless(at
 #define __ATOMIC64_OR	"ogr"
 #define __ATOMIC64_AND	"ngr"
 #define __ATOMIC64_ADD	"agr"
+#define __ATOMIC64_XOR	"xgr"
 
 #define __ATOMIC64_LOOP(ptr, op_val, op_string)				\
 ({									\
@@ -224,16 +235,6 @@ static inline long long atomic64_add_ret
 	return __ATOMIC64_LOOP(v, i, __ATOMIC64_ADD) + i;
 }
 
-static inline void atomic64_clear_mask(unsigned long mask, atomic64_t *v)
-{
-	__ATOMIC64_LOOP(v, ~mask, __ATOMIC64_AND);
-}
-
-static inline void atomic64_set_mask(unsigned long mask, atomic64_t *v)
-{
-	__ATOMIC64_LOOP(v, mask, __ATOMIC64_OR);
-}
-
 #define atomic64_xchg(v, new) (xchg(&((v)->counter), new))
 
 static inline long long atomic64_cmpxchg(atomic64_t *v,
@@ -247,6 +248,22 @@ static inline long long atomic64_cmpxchg
 	return old;
 }
 
+#define ATOMIC64_OP(op, OP, cop)					\
+static inline void atomic64_##op(long i, atomic64_t *v)			\
+{									\
+	__ATOMIC64_LOOP(v, i, __ATOMIC64_##OP);				\
+}									\
+									\
+static inline long atomic64_##op##_return(long i, atomic64_t *v)	\
+{									\
+	return __ATOMIC64_LOOP(v, i, __ATOMIC64_##OP) cop i;		\
+}
+
+ATOMIC64_OP(and, AND, &)
+ATOMIC64_OP(or, OR, |)
+ATOMIC64_OP(xor, XOR, ^)
+
+#undef ATOMIC64_OP
 #undef __ATOMIC64_LOOP
 
 #else /* CONFIG_64BIT */
@@ -315,25 +332,29 @@ static inline long long atomic64_add_ret
 	return new;
 }
 
-static inline void atomic64_set_mask(unsigned long long mask, atomic64_t *v)
-{
-	long long old, new;
-
-	do {
-		old = atomic64_read(v);
-		new = old | mask;
-	} while (atomic64_cmpxchg(v, old, new) != old);
+#define ATOMIC64_OP(op, OP, cop)					\
+static inline void atomic64_##op(long long i, atomic_t *v)		\
+{									\
+	long long c, old;						\
+	c = atomic64_read(v);						\
+	while ((old = atomic64_cmpxchg(v, c, c cop i)) != c)		\
+		c = old;						\
+}									\
+									\
+static inline long long atomic64_##op##_return(long long i, atomic_t *v)\
+{									\
+	long long c, old;						\
+	c = atomic64_read(v);						\
+	while ((old = atomic64_cmpxchg(v, c, c cop i)) != c)		\
+		c = old;						\
+	return c cop i;
 }
 
-static inline void atomic64_clear_mask(unsigned long long mask, atomic64_t *v)
-{
-	long long old, new;
+ATOMIC64_OP(and, AND, &)
+ATOMIC64_OP(or, OR, |)
+ATOMIC64_OP(xor, XOR, ^)
 
-	do {
-		old = atomic64_read(v);
-		new = old & mask;
-	} while (atomic64_cmpxchg(v, old, new) != old);
-}
+#undef ATOMIC64_OP
 
 #endif /* CONFIG_64BIT */
 
--- a/arch/s390/kernel/time.c
+++ b/arch/s390/kernel/time.c
@@ -367,7 +367,7 @@ static void disable_sync_clock(void *dum
 	 * increase the "sequence" counter to avoid the race of an
 	 * etr event and the complete recovery against get_sync_clock.
 	 */
-	atomic_clear_mask(0x80000000, sw_ptr);
+	atomic_and(~0x80000000, sw_ptr);
 	atomic_inc(sw_ptr);
 }
 
@@ -378,7 +378,7 @@ static void disable_sync_clock(void *dum
 static void enable_sync_clock(void)
 {
 	atomic_t *sw_ptr = &__get_cpu_var(clock_sync_word);
-	atomic_set_mask(0x80000000, sw_ptr);
+	atomic_or(0x80000000, sw_ptr);
 }
 
 /*
--- a/arch/s390/kvm/diag.c
+++ b/arch/s390/kvm/diag.c
@@ -94,7 +94,7 @@ static int __diag_ipl_functions(struct k
 		return -EOPNOTSUPP;
 	}
 
-	atomic_set_mask(CPUSTAT_STOPPED, &vcpu->arch.sie_block->cpuflags);
+	atomic_or(CPUSTAT_STOPPED, &vcpu->arch.sie_block->cpuflags);
 	vcpu->run->s390_reset_flags |= KVM_S390_RESET_SUBSYSTEM;
 	vcpu->run->s390_reset_flags |= KVM_S390_RESET_IPL;
 	vcpu->run->s390_reset_flags |= KVM_S390_RESET_CPU_INIT;
--- a/arch/s390/kvm/intercept.c
+++ b/arch/s390/kvm/intercept.c
@@ -63,7 +63,7 @@ static int handle_stop(struct kvm_vcpu *
 	trace_kvm_s390_stop_request(vcpu->arch.local_int.action_bits);
 
 	if (vcpu->arch.local_int.action_bits & ACTION_STOP_ON_STOP) {
-		atomic_set_mask(CPUSTAT_STOPPED,
+		atomic_or(CPUSTAT_STOPPED,
 				&vcpu->arch.sie_block->cpuflags);
 		vcpu->arch.local_int.action_bits &= ~ACTION_STOP_ON_STOP;
 		VCPU_EVENT(vcpu, 3, "%s", "cpu stopped");
--- a/arch/s390/kvm/interrupt.c
+++ b/arch/s390/kvm/interrupt.c
@@ -118,21 +118,21 @@ static int __interrupt_is_deliverable(st
 static void __set_cpu_idle(struct kvm_vcpu *vcpu)
 {
 	BUG_ON(vcpu->vcpu_id > KVM_MAX_VCPUS - 1);
-	atomic_set_mask(CPUSTAT_WAIT, &vcpu->arch.sie_block->cpuflags);
+	atomic_or(CPUSTAT_WAIT, &vcpu->arch.sie_block->cpuflags);
 	set_bit(vcpu->vcpu_id, vcpu->arch.local_int.float_int->idle_mask);
 }
 
 static void __unset_cpu_idle(struct kvm_vcpu *vcpu)
 {
 	BUG_ON(vcpu->vcpu_id > KVM_MAX_VCPUS - 1);
-	atomic_clear_mask(CPUSTAT_WAIT, &vcpu->arch.sie_block->cpuflags);
+	atomic_and(~CPUSTAT_WAIT, &vcpu->arch.sie_block->cpuflags);
 	clear_bit(vcpu->vcpu_id, vcpu->arch.local_int.float_int->idle_mask);
 }
 
 static void __reset_intercept_indicators(struct kvm_vcpu *vcpu)
 {
-	atomic_clear_mask(CPUSTAT_ECALL_PEND |
-		CPUSTAT_IO_INT | CPUSTAT_EXT_INT | CPUSTAT_STOP_INT,
+	atomic_and(~(CPUSTAT_ECALL_PEND |
+		CPUSTAT_IO_INT | CPUSTAT_EXT_INT | CPUSTAT_STOP_INT),
 		&vcpu->arch.sie_block->cpuflags);
 	vcpu->arch.sie_block->lctl = 0x0000;
 	vcpu->arch.sie_block->ictl &= ~ICTL_LPSW;
@@ -140,7 +140,7 @@ static void __reset_intercept_indicators
 
 static void __set_cpuflag(struct kvm_vcpu *vcpu, u32 flag)
 {
-	atomic_set_mask(flag, &vcpu->arch.sie_block->cpuflags);
+	atomic_or(flag, &vcpu->arch.sie_block->cpuflags);
 }
 
 static void __set_intercept_indicator(struct kvm_vcpu *vcpu,
@@ -269,7 +269,7 @@ static void __do_deliver_interrupt(struc
 		rc |= copy_from_guest(vcpu, &vcpu->arch.sie_block->gpsw,
 				      offsetof(struct _lowcore, restart_psw),
 				      sizeof(psw_t));
-		atomic_clear_mask(CPUSTAT_STOPPED, &vcpu->arch.sie_block->cpuflags);
+		atomic_and(~CPUSTAT_STOPPED, &vcpu->arch.sie_block->cpuflags);
 		break;
 	case KVM_S390_PROGRAM_INT:
 		VCPU_EVENT(vcpu, 4, "interrupt: pgm check code:%x, ilc:%x",
@@ -748,7 +748,7 @@ int kvm_s390_inject_vm(struct kvm *kvm,
 	}
 	li = fi->local_int[sigcpu];
 	spin_lock_bh(&li->lock);
-	atomic_set_mask(CPUSTAT_EXT_INT, li->cpuflags);
+	atomic_or(CPUSTAT_EXT_INT, li->cpuflags);
 	if (waitqueue_active(li->wq))
 		wake_up_interruptible(li->wq);
 	spin_unlock_bh(&li->lock);
@@ -834,7 +834,7 @@ int kvm_s390_inject_vcpu(struct kvm_vcpu
 	atomic_set(&li->active, 1);
 	if (inti->type == KVM_S390_SIGP_STOP)
 		li->action_bits |= ACTION_STOP_ON_STOP;
-	atomic_set_mask(CPUSTAT_EXT_INT, li->cpuflags);
+	atomic_or(CPUSTAT_EXT_INT, li->cpuflags);
 	if (waitqueue_active(&vcpu->wq))
 		wake_up_interruptible(&vcpu->wq);
 	spin_unlock_bh(&li->lock);
--- a/arch/s390/kvm/kvm-s390.c
+++ b/arch/s390/kvm/kvm-s390.c
@@ -350,12 +350,12 @@ void kvm_arch_vcpu_load(struct kvm_vcpu
 	restore_fp_regs(vcpu->arch.guest_fpregs.fprs);
 	restore_access_regs(vcpu->run->s.regs.acrs);
 	gmap_enable(vcpu->arch.gmap);
-	atomic_set_mask(CPUSTAT_RUNNING, &vcpu->arch.sie_block->cpuflags);
+	atomic_or(CPUSTAT_RUNNING, &vcpu->arch.sie_block->cpuflags);
 }
 
 void kvm_arch_vcpu_put(struct kvm_vcpu *vcpu)
 {
-	atomic_clear_mask(CPUSTAT_RUNNING, &vcpu->arch.sie_block->cpuflags);
+	atomic_and(~CPUSTAT_RUNNING, &vcpu->arch.sie_block->cpuflags);
 	gmap_disable(vcpu->arch.gmap);
 	save_fp_ctl(&vcpu->arch.guest_fpregs.fpc);
 	save_fp_regs(vcpu->arch.guest_fpregs.fprs);
@@ -380,7 +380,7 @@ static void kvm_s390_vcpu_initial_reset(
 	vcpu->arch.guest_fpregs.fpc = 0;
 	asm volatile("lfpc %0" : : "Q" (vcpu->arch.guest_fpregs.fpc));
 	vcpu->arch.sie_block->gbea = 1;
-	atomic_set_mask(CPUSTAT_STOPPED, &vcpu->arch.sie_block->cpuflags);
+	atomic_or(CPUSTAT_STOPPED, &vcpu->arch.sie_block->cpuflags);
 }
 
 int kvm_arch_vcpu_postcreate(struct kvm_vcpu *vcpu)
@@ -482,12 +482,12 @@ int kvm_arch_vcpu_runnable(struct kvm_vc
 
 void s390_vcpu_block(struct kvm_vcpu *vcpu)
 {
-	atomic_set_mask(PROG_BLOCK_SIE, &vcpu->arch.sie_block->prog20);
+	atomic_or(PROG_BLOCK_SIE, &vcpu->arch.sie_block->prog20);
 }
 
 void s390_vcpu_unblock(struct kvm_vcpu *vcpu)
 {
-	atomic_clear_mask(PROG_BLOCK_SIE, &vcpu->arch.sie_block->prog20);
+	atomic_and(~PROG_BLOCK_SIE, &vcpu->arch.sie_block->prog20);
 }
 
 /*
@@ -496,7 +496,7 @@ void s390_vcpu_unblock(struct kvm_vcpu *
  * return immediately. */
 void exit_sie(struct kvm_vcpu *vcpu)
 {
-	atomic_set_mask(CPUSTAT_STOP_INT, &vcpu->arch.sie_block->cpuflags);
+	atomic_or(CPUSTAT_STOP_INT, &vcpu->arch.sie_block->cpuflags);
 	while (vcpu->arch.sie_block->prog0c & PROG_IN_SIE)
 		cpu_relax();
 }
@@ -804,7 +804,7 @@ int kvm_arch_vcpu_ioctl_run(struct kvm_v
 	if (vcpu->sigset_active)
 		sigprocmask(SIG_SETMASK, &vcpu->sigset, &sigsaved);
 
-	atomic_clear_mask(CPUSTAT_STOPPED, &vcpu->arch.sie_block->cpuflags);
+	atomic_and(~CPUSTAT_STOPPED, &vcpu->arch.sie_block->cpuflags);
 
 	BUG_ON(vcpu->kvm->arch.float_int.local_int[vcpu->vcpu_id] == NULL);
 
--- a/arch/s390/kvm/sigp.c
+++ b/arch/s390/kvm/sigp.c
@@ -78,7 +78,7 @@ static int __sigp_emergency(struct kvm_v
 	spin_lock_bh(&li->lock);
 	list_add_tail(&inti->list, &li->list);
 	atomic_set(&li->active, 1);
-	atomic_set_mask(CPUSTAT_EXT_INT, li->cpuflags);
+	atomic_or(CPUSTAT_EXT_INT, li->cpuflags);
 	if (waitqueue_active(li->wq))
 		wake_up_interruptible(li->wq);
 	spin_unlock_bh(&li->lock);
@@ -147,7 +147,7 @@ static int __sigp_external_call(struct k
 	spin_lock_bh(&li->lock);
 	list_add_tail(&inti->list, &li->list);
 	atomic_set(&li->active, 1);
-	atomic_set_mask(CPUSTAT_EXT_INT, li->cpuflags);
+	atomic_or(CPUSTAT_EXT_INT, li->cpuflags);
 	if (waitqueue_active(li->wq))
 		wake_up_interruptible(li->wq);
 	spin_unlock_bh(&li->lock);
@@ -177,7 +177,7 @@ static int __inject_sigp_stop(struct kvm
 	}
 	list_add_tail(&inti->list, &li->list);
 	atomic_set(&li->active, 1);
-	atomic_set_mask(CPUSTAT_STOP_INT, li->cpuflags);
+	atomic_or(CPUSTAT_STOP_INT, li->cpuflags);
 	li->action_bits |= action;
 	if (waitqueue_active(li->wq))
 		wake_up_interruptible(li->wq);
--- a/arch/sh/include/asm/atomic-grb.h
+++ b/arch/sh/include/asm/atomic-grb.h
@@ -44,46 +44,10 @@ static inline int atomic_##op##_return(i
 
 ATOMIC_OP(add)
 ATOMIC_OP(sub)
+ATOMIC_OP(and)
+ATOMIC_OP(or)
+ATOMIC_OP(xor)
 
 #undef ATOMIC_OP
 
-static inline void atomic_clear_mask(unsigned int mask, atomic_t *v)
-{
-	int tmp;
-	unsigned int _mask = ~mask;
-
-	__asm__ __volatile__ (
-		"   .align 2              \n\t"
-		"   mova    1f,   r0      \n\t" /* r0 = end point */
-		"   mov    r15,   r1      \n\t" /* r1 = saved sp */
-		"   mov    #-6,   r15     \n\t" /* LOGIN: r15 = size */
-		"   mov.l  @%1,   %0      \n\t" /* load  old value */
-		"   and     %2,   %0      \n\t" /* add */
-		"   mov.l   %0,   @%1     \n\t" /* store new value */
-		"1: mov     r1,   r15     \n\t" /* LOGOUT */
-		: "=&r" (tmp),
-		  "+r"  (v)
-		: "r"   (_mask)
-		: "memory" , "r0", "r1");
-}
-
-static inline void atomic_set_mask(unsigned int mask, atomic_t *v)
-{
-	int tmp;
-
-	__asm__ __volatile__ (
-		"   .align 2              \n\t"
-		"   mova    1f,   r0      \n\t" /* r0 = end point */
-		"   mov    r15,   r1      \n\t" /* r1 = saved sp */
-		"   mov    #-6,   r15     \n\t" /* LOGIN: r15 = size */
-		"   mov.l  @%1,   %0      \n\t" /* load  old value */
-		"   or      %2,   %0      \n\t" /* or */
-		"   mov.l   %0,   @%1     \n\t" /* store new value */
-		"1: mov     r1,   r15     \n\t" /* LOGOUT */
-		: "=&r" (tmp),
-		  "+r"  (v)
-		: "r"   (mask)
-		: "memory" , "r0", "r1");
-}
-
 #endif /* __ASM_SH_ATOMIC_GRB_H */
--- a/arch/sh/include/asm/atomic-irq.h
+++ b/arch/sh/include/asm/atomic-irq.h
@@ -34,25 +34,10 @@ static inline int atomic_##op##_return(i
 
 ATOMIC_OP(add, +=)
 ATOMIC_OP(sub, -=)
+ATOMIC_OP(and, &=)
+ATOMIC_OP(or, |=)
+ATOMIC_OP(xor, ^=)
 
 #undef ATOMIC_OP
 
-static inline void atomic_clear_mask(unsigned int mask, atomic_t *v)
-{
-	unsigned long flags;
-
-	raw_local_irq_save(flags);
-	v->counter &= ~mask;
-	raw_local_irq_restore(flags);
-}
-
-static inline void atomic_set_mask(unsigned int mask, atomic_t *v)
-{
-	unsigned long flags;
-
-	raw_local_irq_save(flags);
-	v->counter |= mask;
-	raw_local_irq_restore(flags);
-}
-
 #endif /* __ASM_SH_ATOMIC_IRQ_H */
--- a/arch/sh/include/asm/atomic-llsc.h
+++ b/arch/sh/include/asm/atomic-llsc.h
@@ -49,35 +49,10 @@ static inline int atomic_##op##_return(i
 
 ATOMIC_OP(add)
 ATOMIC_OP(sub)
+ATOMIC_OP(and)
+ATOMIC_OP(or)
+ATOMIC_OP(xor)
 
 #undef ATOMIC_OP
 
-static inline void atomic_clear_mask(unsigned int mask, atomic_t *v)
-{
-	unsigned long tmp;
-
-	__asm__ __volatile__ (
-"1:	movli.l @%2, %0		! atomic_clear_mask	\n"
-"	and	%1, %0					\n"
-"	movco.l	%0, @%2					\n"
-"	bf	1b					\n"
-	: "=&z" (tmp)
-	: "r" (~mask), "r" (&v->counter)
-	: "t");
-}
-
-static inline void atomic_set_mask(unsigned int mask, atomic_t *v)
-{
-	unsigned long tmp;
-
-	__asm__ __volatile__ (
-"1:	movli.l @%2, %0		! atomic_set_mask	\n"
-"	or	%1, %0					\n"
-"	movco.l	%0, @%2					\n"
-"	bf	1b					\n"
-	: "=&z" (tmp)
-	: "r" (mask), "r" (&v->counter)
-	: "t");
-}
-
 #endif /* __ASM_SH_ATOMIC_LLSC_H */
--- a/arch/sparc/include/asm/atomic_32.h
+++ b/arch/sparc/include/asm/atomic_32.h
@@ -39,6 +39,10 @@ extern void atomic_set(atomic_t *, int);
 
 #define atomic_add_negative(a, v)	(atomic_add_return((a), (v)) < 0)
 
+#define atomic_and(i, v)	((void)atomic_and_return(i, v))
+#define atomic_or(i, v)		((void)atomic_or_return(i, v))
+#define atomic_xor(i, v)	((void)atomic_xor_return(i, v))
+
 /*
  * atomic_inc_and_test - increment and test
  * @v: pointer of type atomic_t
--- a/arch/sparc/include/asm/atomic_64.h
+++ b/arch/sparc/include/asm/atomic_64.h
@@ -28,6 +28,9 @@ extern long atomic64_##op##_return(long,
 
 ATOMIC_OP(add)
 ATOMIC_OP(sub)
+ATOMIC_OP(and)
+ATOMIC_OP(or)
+ATOMIC_OP(xor)
 
 #undef ATOMIC_OP
 
--- a/arch/sparc/lib/atomic32.c
+++ b/arch/sparc/lib/atomic32.c
@@ -42,8 +42,9 @@ int atomic_##op##_return(int i, atomic_t
 EXPORT_SYMBOL(atomic_##op##_return);
 
 ATOMIC_OP(add, +=)
-
-#undef ATOMIC_OP
+ATOMIC_OP(and, &=)
+ATOMIC_OP(or, |=)
+ATOMIC_OP(xor, ^=)
 
 int atomic_cmpxchg(atomic_t *v, int old, int new)
 {
--- a/arch/sparc/lib/atomic_64.S
+++ b/arch/sparc/lib/atomic_64.S
@@ -44,6 +44,9 @@ ENDPROC(atomic_##op##_return);
 
 ATOMIC_OP(add)
 ATOMIC_OP(sub)
+ATOMIC_OP(and)
+ATOMIC_OP(or)
+ATOMIC_OP(xor)
 
 #define ATOMIC64_OP(op)							\
 ENTRY(atomic64_##op) /* %o0 = increment, %o1 = atomic_ptr */		\
@@ -74,6 +77,9 @@ ENDPROC(atomic64_##op##_return);
 
 ATOMIC64_OP(add)
 ATOMIC64_OP(sub)
+ATOMIC64_OP(and)
+ATOMIC64_OP(or)
+ATOMIC64_OP(xor)
 
 ENTRY(atomic64_dec_if_positive) /* %o0 = atomic_ptr */
 	BACKOFF_SETUP(%o2)
--- a/arch/sparc/lib/ksyms.c
+++ b/arch/sparc/lib/ksyms.c
@@ -107,6 +107,9 @@ EXPORT_SYMBOL(atomic64_##op##_return);
 
 ATOMIC_OP(add)
 ATOMIC_OP(sub)
+ATOMIC_OP(and)
+ATOMIC_OP(or)
+ATOMIC_OP(xor)
 
 EXPORT_SYMBOL(atomic64_dec_if_positive);
 
--- a/arch/x86/include/asm/atomic.h
+++ b/arch/x86/include/asm/atomic.h
@@ -182,6 +182,28 @@ static inline int atomic_xchg(atomic_t *
 	return xchg(&v->counter, new);
 }
 
+#define ATOMIC_OP(op, cop)						\
+static inline void atomic_##op(int i, atomic_t *v)			\
+{									\
+	asm volatile(LOCK_PREFIX #op"l %1,%0"				\
+			: "+m" (v->counter)				\
+			: "ir" (i));					\
+}									\
+									\
+static inline int atomic_##op##_return(int i, atomic_t *v)		\
+{									\
+	int old, c = atomic_read(v);					\
+	while ((old = atomic_cmpxchg(v, c, c cop i)) != c)		\
+		c = old;						\
+	return c cop i;							\
+}
+
+ATOMIC_OP(and, &)
+ATOMIC_OP(or, |)
+ATOMIC_OP(xor, ^)
+
+#undef ATOMIC_OP
+
 /**
  * __atomic_add_unless - add unless the number is already a given value
  * @v: pointer of type atomic_t
@@ -234,16 +256,6 @@ static inline void atomic_or_long(unsign
 }
 #endif
 
-/* These are x86-specific, used by some header files */
-#define atomic_clear_mask(mask, addr)				\
-	asm volatile(LOCK_PREFIX "andl %0,%1"			\
-		     : : "r" (~(mask)), "m" (*(addr)) : "memory")
-
-#define atomic_set_mask(mask, addr)				\
-	asm volatile(LOCK_PREFIX "orl %0,%1"			\
-		     : : "r" ((unsigned)(mask)), "m" (*(addr))	\
-		     : "memory")
-
 #ifdef CONFIG_X86_32
 # include <asm/atomic64_32.h>
 #else
--- a/arch/x86/include/asm/atomic64_32.h
+++ b/arch/x86/include/asm/atomic64_32.h
@@ -313,4 +313,24 @@ static inline long long atomic64_dec_if_
 #undef alternative_atomic64
 #undef __alternative_atomic64
 
+#define ATOMIC_OP(op, cop)						\
+static inline long long atomic64_##op##_return(long long i, atomic64_t *v)\
+{									\
+	long long old, c = 0;						\
+	while ((old = atomic64_cmpxchg(v, c, c cop i)) != c)		\
+		c = old;						\
+	return c cop i;							\
+}									\
+									\
+static inline void atomic64_##op(long long i, atomic64_t *v)		\
+{									\
+	atomic64_##op##_return(i, v);					\
+}
+
+ATOMIC_OP(and, &)
+ATOMIC_OP(or, |)
+ATOMIC_OP(xor, ^)
+
+#undef ATOMIC_OP
+
 #endif /* _ASM_X86_ATOMIC64_32_H */
--- a/arch/x86/include/asm/atomic64_64.h
+++ b/arch/x86/include/asm/atomic64_64.h
@@ -220,4 +220,26 @@ static inline long atomic64_dec_if_posit
 	return dec;
 }
 
+#define ATOMIC64_OP(op, cop)						\
+static inline void atomic64_##op(long i, atomic64_t *v)			\
+{									\
+	asm volatile(LOCK_PREFIX #op"q %1,%0"				\
+			: "+m" (v->counter)				\
+			: "ir" (i));					\
+}									\
+									\
+static inline long atomic64_##op##_return(long i, atomic64_t *v)	\
+{									\
+	long old, c = atomic64_read(v);					\
+	while ((old = atomic64_cmpxchg(v, c, c cop i)) != c)		\
+		c = old;						\
+	return c cop i;							\
+}
+
+ATOMIC64_OP(and, &)
+ATOMIC64_OP(or, |)
+ATOMIC64_OP(xor, ^)
+
+#undef ATOMIC64_OP
+
 #endif /* _ASM_X86_ATOMIC64_64_H */
--- a/arch/xtensa/include/asm/atomic.h
+++ b/arch/xtensa/include/asm/atomic.h
@@ -140,6 +140,9 @@ static inline int atomic_##op##_return(i
 
 ATOMIC_OP(add)
 ATOMIC_OP(sub)
+ATOMIC_OP(and)
+ATOMIC_OP(or)
+ATOMIC_OP(xor)
 
 #undef ATOMIC_OP
 
@@ -244,75 +247,6 @@ static __inline__ int __atomic_add_unles
 	return c;
 }
 
-
-static inline void atomic_clear_mask(unsigned int mask, atomic_t *v)
-{
-#if XCHAL_HAVE_S32C1I
-	unsigned long tmp;
-	int result;
-
-	__asm__ __volatile__(
-			"1:     l32i    %1, %3, 0\n"
-			"       wsr     %1, scompare1\n"
-			"       and     %0, %1, %2\n"
-			"       s32c1i  %0, %3, 0\n"
-			"       bne     %0, %1, 1b\n"
-			: "=&a" (result), "=&a" (tmp)
-			: "a" (~mask), "a" (v)
-			: "memory"
-			);
-#else
-	unsigned int all_f = -1;
-	unsigned int vval;
-
-	__asm__ __volatile__(
-			"       rsil    a15,"__stringify(LOCKLEVEL)"\n"
-			"       l32i    %0, %2, 0\n"
-			"       xor     %1, %4, %3\n"
-			"       and     %0, %0, %4\n"
-			"       s32i    %0, %2, 0\n"
-			"       wsr     a15, ps\n"
-			"       rsync\n"
-			: "=&a" (vval), "=a" (mask)
-			: "a" (v), "a" (all_f), "1" (mask)
-			: "a15", "memory"
-			);
-#endif
-}
-
-static inline void atomic_set_mask(unsigned int mask, atomic_t *v)
-{
-#if XCHAL_HAVE_S32C1I
-	unsigned long tmp;
-	int result;
-
-	__asm__ __volatile__(
-			"1:     l32i    %1, %3, 0\n"
-			"       wsr     %1, scompare1\n"
-			"       or      %0, %1, %2\n"
-			"       s32c1i  %0, %3, 0\n"
-			"       bne     %0, %1, 1b\n"
-			: "=&a" (result), "=&a" (tmp)
-			: "a" (mask), "a" (v)
-			: "memory"
-			);
-#else
-	unsigned int vval;
-
-	__asm__ __volatile__(
-			"       rsil    a15,"__stringify(LOCKLEVEL)"\n"
-			"       l32i    %0, %2, 0\n"
-			"       or      %0, %0, %1\n"
-			"       s32i    %0, %2, 0\n"
-			"       wsr     a15, ps\n"
-			"       rsync\n"
-			: "=&a" (vval)
-			: "a" (mask), "a" (v)
-			: "a15", "memory"
-			);
-#endif
-}
-
 #endif /* __KERNEL__ */
 
 #endif /* _XTENSA_ATOMIC_H */
--- a/drivers/gpu/drm/i915/i915_irq.c
+++ b/drivers/gpu/drm/i915/i915_irq.c
@@ -2002,7 +2002,7 @@ static void i915_error_work_func(struct
 			kobject_uevent_env(&dev->primary->kdev->kobj,
 					   KOBJ_CHANGE, reset_done_event);
 		} else {
-			atomic_set_mask(I915_WEDGED, &error->reset_counter);
+			atomic_or(I915_WEDGED, &error->reset_counter);
 		}
 
 		/*
@@ -2123,7 +2123,7 @@ void i915_handle_error(struct drm_device
 	i915_report_and_clear_eir(dev);
 
 	if (wedged) {
-		atomic_set_mask(I915_RESET_IN_PROGRESS_FLAG,
+		atomic_or(I915_RESET_IN_PROGRESS_FLAG,
 				&dev_priv->gpu_error.reset_counter);
 
 		/*
--- a/drivers/s390/scsi/zfcp_aux.c
+++ b/drivers/s390/scsi/zfcp_aux.c
@@ -527,7 +527,7 @@ struct zfcp_port *zfcp_port_enqueue(stru
 	list_add_tail(&port->list, &adapter->port_list);
 	write_unlock_irq(&adapter->port_list_lock);
 
-	atomic_set_mask(status | ZFCP_STATUS_COMMON_RUNNING, &port->status);
+	atomic_or(status | ZFCP_STATUS_COMMON_RUNNING, &port->status);
 
 	return port;
 
--- a/drivers/s390/scsi/zfcp_erp.c
+++ b/drivers/s390/scsi/zfcp_erp.c
@@ -190,7 +190,7 @@ static struct zfcp_erp_action *zfcp_erp_
 		if (!(act_status & ZFCP_STATUS_ERP_NO_REF))
 			if (scsi_device_get(sdev))
 				return NULL;
-		atomic_set_mask(ZFCP_STATUS_COMMON_ERP_INUSE,
+		atomic_or(ZFCP_STATUS_COMMON_ERP_INUSE,
 				&zfcp_sdev->status);
 		erp_action = &zfcp_sdev->erp_action;
 		memset(erp_action, 0, sizeof(struct zfcp_erp_action));
@@ -206,7 +206,7 @@ static struct zfcp_erp_action *zfcp_erp_
 		if (!get_device(&port->dev))
 			return NULL;
 		zfcp_erp_action_dismiss_port(port);
-		atomic_set_mask(ZFCP_STATUS_COMMON_ERP_INUSE, &port->status);
+		atomic_or(ZFCP_STATUS_COMMON_ERP_INUSE, &port->status);
 		erp_action = &port->erp_action;
 		memset(erp_action, 0, sizeof(struct zfcp_erp_action));
 		erp_action->port = port;
@@ -217,7 +217,7 @@ static struct zfcp_erp_action *zfcp_erp_
 	case ZFCP_ERP_ACTION_REOPEN_ADAPTER:
 		kref_get(&adapter->ref);
 		zfcp_erp_action_dismiss_adapter(adapter);
-		atomic_set_mask(ZFCP_STATUS_COMMON_ERP_INUSE, &adapter->status);
+		atomic_or(ZFCP_STATUS_COMMON_ERP_INUSE, &adapter->status);
 		erp_action = &adapter->erp_action;
 		memset(erp_action, 0, sizeof(struct zfcp_erp_action));
 		if (!(atomic_read(&adapter->status) &
@@ -254,7 +254,7 @@ static int zfcp_erp_action_enqueue(int w
 	act = zfcp_erp_setup_act(need, act_status, adapter, port, sdev);
 	if (!act)
 		goto out;
-	atomic_set_mask(ZFCP_STATUS_ADAPTER_ERP_PENDING, &adapter->status);
+	atomic_or(ZFCP_STATUS_ADAPTER_ERP_PENDING, &adapter->status);
 	++adapter->erp_total_count;
 	list_add_tail(&act->list, &adapter->erp_ready_head);
 	wake_up(&adapter->erp_ready_wq);
@@ -486,14 +486,14 @@ static void zfcp_erp_adapter_unblock(str
 {
 	if (status_change_set(ZFCP_STATUS_COMMON_UNBLOCKED, &adapter->status))
 		zfcp_dbf_rec_run("eraubl1", &adapter->erp_action);
-	atomic_set_mask(ZFCP_STATUS_COMMON_UNBLOCKED, &adapter->status);
+	atomic_or(ZFCP_STATUS_COMMON_UNBLOCKED, &adapter->status);
 }
 
 static void zfcp_erp_port_unblock(struct zfcp_port *port)
 {
 	if (status_change_set(ZFCP_STATUS_COMMON_UNBLOCKED, &port->status))
 		zfcp_dbf_rec_run("erpubl1", &port->erp_action);
-	atomic_set_mask(ZFCP_STATUS_COMMON_UNBLOCKED, &port->status);
+	atomic_or(ZFCP_STATUS_COMMON_UNBLOCKED, &port->status);
 }
 
 static void zfcp_erp_lun_unblock(struct scsi_device *sdev)
@@ -502,7 +502,7 @@ static void zfcp_erp_lun_unblock(struct
 
 	if (status_change_set(ZFCP_STATUS_COMMON_UNBLOCKED, &zfcp_sdev->status))
 		zfcp_dbf_rec_run("erlubl1", &sdev_to_zfcp(sdev)->erp_action);
-	atomic_set_mask(ZFCP_STATUS_COMMON_UNBLOCKED, &zfcp_sdev->status);
+	atomic_or(ZFCP_STATUS_COMMON_UNBLOCKED, &zfcp_sdev->status);
 }
 
 static void zfcp_erp_action_to_running(struct zfcp_erp_action *erp_action)
@@ -642,7 +642,7 @@ static void zfcp_erp_wakeup(struct zfcp_
 	read_lock_irqsave(&adapter->erp_lock, flags);
 	if (list_empty(&adapter->erp_ready_head) &&
 	    list_empty(&adapter->erp_running_head)) {
-			atomic_clear_mask(ZFCP_STATUS_ADAPTER_ERP_PENDING,
+			atomic_and(~ZFCP_STATUS_ADAPTER_ERP_PENDING,
 					  &adapter->status);
 			wake_up(&adapter->erp_done_wqh);
 	}
@@ -665,16 +665,16 @@ static int zfcp_erp_adapter_strat_fsf_xc
 	int sleep = 1;
 	struct zfcp_adapter *adapter = erp_action->adapter;
 
-	atomic_clear_mask(ZFCP_STATUS_ADAPTER_XCONFIG_OK, &adapter->status);
+	atomic_and(~ZFCP_STATUS_ADAPTER_XCONFIG_OK, &adapter->status);
 
 	for (retries = 7; retries; retries--) {
-		atomic_clear_mask(ZFCP_STATUS_ADAPTER_HOST_CON_INIT,
+		atomic_and(~ZFCP_STATUS_ADAPTER_HOST_CON_INIT,
 				  &adapter->status);
 		write_lock_irq(&adapter->erp_lock);
 		zfcp_erp_action_to_running(erp_action);
 		write_unlock_irq(&adapter->erp_lock);
 		if (zfcp_fsf_exchange_config_data(erp_action)) {
-			atomic_clear_mask(ZFCP_STATUS_ADAPTER_HOST_CON_INIT,
+			atomic_and(~ZFCP_STATUS_ADAPTER_HOST_CON_INIT,
 					  &adapter->status);
 			return ZFCP_ERP_FAILED;
 		}
@@ -692,7 +692,7 @@ static int zfcp_erp_adapter_strat_fsf_xc
 		sleep *= 2;
 	}
 
-	atomic_clear_mask(ZFCP_STATUS_ADAPTER_HOST_CON_INIT,
+	atomic_and(~ZFCP_STATUS_ADAPTER_HOST_CON_INIT,
 			  &adapter->status);
 
 	if (!(atomic_read(&adapter->status) & ZFCP_STATUS_ADAPTER_XCONFIG_OK))
@@ -764,8 +764,8 @@ static void zfcp_erp_adapter_strategy_cl
 	/* all ports and LUNs are closed */
 	zfcp_erp_clear_adapter_status(adapter, ZFCP_STATUS_COMMON_OPEN);
 
-	atomic_clear_mask(ZFCP_STATUS_ADAPTER_XCONFIG_OK |
-			  ZFCP_STATUS_ADAPTER_LINK_UNPLUGGED, &adapter->status);
+	atomic_and(~(ZFCP_STATUS_ADAPTER_XCONFIG_OK |
+			  ZFCP_STATUS_ADAPTER_LINK_UNPLUGGED), &adapter->status);
 }
 
 static int zfcp_erp_adapter_strategy_open(struct zfcp_erp_action *act)
@@ -773,8 +773,8 @@ static int zfcp_erp_adapter_strategy_ope
 	struct zfcp_adapter *adapter = act->adapter;
 
 	if (zfcp_qdio_open(adapter->qdio)) {
-		atomic_clear_mask(ZFCP_STATUS_ADAPTER_XCONFIG_OK |
-				  ZFCP_STATUS_ADAPTER_LINK_UNPLUGGED,
+		atomic_and(~(ZFCP_STATUS_ADAPTER_XCONFIG_OK |
+				  ZFCP_STATUS_ADAPTER_LINK_UNPLUGGED),
 				  &adapter->status);
 		return ZFCP_ERP_FAILED;
 	}
@@ -784,7 +784,7 @@ static int zfcp_erp_adapter_strategy_ope
 		return ZFCP_ERP_FAILED;
 	}
 
-	atomic_set_mask(ZFCP_STATUS_COMMON_OPEN, &adapter->status);
+	atomic_and(~ZFCP_STATUS_COMMON_OPEN, &adapter->status);
 
 	return ZFCP_ERP_SUCCEEDED;
 }
@@ -823,7 +823,7 @@ static int zfcp_erp_port_forced_strategy
 
 static void zfcp_erp_port_strategy_clearstati(struct zfcp_port *port)
 {
-	atomic_clear_mask(ZFCP_STATUS_COMMON_ACCESS_DENIED, &port->status);
+	atomic_and(~ZFCP_STATUS_COMMON_ACCESS_DENIED, &port->status);
 }
 
 static int zfcp_erp_port_forced_strategy(struct zfcp_erp_action *erp_action)
@@ -955,7 +955,7 @@ static void zfcp_erp_lun_strategy_clears
 {
 	struct zfcp_scsi_dev *zfcp_sdev = sdev_to_zfcp(sdev);
 
-	atomic_clear_mask(ZFCP_STATUS_COMMON_ACCESS_DENIED,
+	atomic_and(~ZFCP_STATUS_COMMON_ACCESS_DENIED,
 			  &zfcp_sdev->status);
 }
 
@@ -1194,18 +1194,18 @@ static void zfcp_erp_action_dequeue(stru
 	switch (erp_action->action) {
 	case ZFCP_ERP_ACTION_REOPEN_LUN:
 		zfcp_sdev = sdev_to_zfcp(erp_action->sdev);
-		atomic_clear_mask(ZFCP_STATUS_COMMON_ERP_INUSE,
+		atomic_and(~ZFCP_STATUS_COMMON_ERP_INUSE,
 				  &zfcp_sdev->status);
 		break;
 
 	case ZFCP_ERP_ACTION_REOPEN_PORT_FORCED:
 	case ZFCP_ERP_ACTION_REOPEN_PORT:
-		atomic_clear_mask(ZFCP_STATUS_COMMON_ERP_INUSE,
+		atomic_and(~ZFCP_STATUS_COMMON_ERP_INUSE,
 				  &erp_action->port->status);
 		break;
 
 	case ZFCP_ERP_ACTION_REOPEN_ADAPTER:
-		atomic_clear_mask(ZFCP_STATUS_COMMON_ERP_INUSE,
+		atomic_and(~ZFCP_STATUS_COMMON_ERP_INUSE,
 				  &erp_action->adapter->status);
 		break;
 	}
@@ -1429,19 +1429,19 @@ void zfcp_erp_set_adapter_status(struct
 	unsigned long flags;
 	u32 common_mask = mask & ZFCP_COMMON_FLAGS;
 
-	atomic_set_mask(mask, &adapter->status);
+	atomic_or(mask, &adapter->status);
 
 	if (!common_mask)
 		return;
 
 	read_lock_irqsave(&adapter->port_list_lock, flags);
 	list_for_each_entry(port, &adapter->port_list, list)
-		atomic_set_mask(common_mask, &port->status);
+		atomic_or(common_mask, &port->status);
 	read_unlock_irqrestore(&adapter->port_list_lock, flags);
 
 	spin_lock_irqsave(adapter->scsi_host->host_lock, flags);
 	__shost_for_each_device(sdev, adapter->scsi_host)
-		atomic_set_mask(common_mask, &sdev_to_zfcp(sdev)->status);
+		atomic_or(common_mask, &sdev_to_zfcp(sdev)->status);
 	spin_unlock_irqrestore(adapter->scsi_host->host_lock, flags);
 }
 
@@ -1460,7 +1460,7 @@ void zfcp_erp_clear_adapter_status(struc
 	u32 common_mask = mask & ZFCP_COMMON_FLAGS;
 	u32 clear_counter = mask & ZFCP_STATUS_COMMON_ERP_FAILED;
 
-	atomic_clear_mask(mask, &adapter->status);
+	atomic_and(~mask, &adapter->status);
 
 	if (!common_mask)
 		return;
@@ -1470,7 +1470,7 @@ void zfcp_erp_clear_adapter_status(struc
 
 	read_lock_irqsave(&adapter->port_list_lock, flags);
 	list_for_each_entry(port, &adapter->port_list, list) {
-		atomic_clear_mask(common_mask, &port->status);
+		atomic_and(~common_mask, &port->status);
 		if (clear_counter)
 			atomic_set(&port->erp_counter, 0);
 	}
@@ -1478,7 +1478,7 @@ void zfcp_erp_clear_adapter_status(struc
 
 	spin_lock_irqsave(adapter->scsi_host->host_lock, flags);
 	__shost_for_each_device(sdev, adapter->scsi_host) {
-		atomic_clear_mask(common_mask, &sdev_to_zfcp(sdev)->status);
+		atomic_and(~common_mask, &sdev_to_zfcp(sdev)->status);
 		if (clear_counter)
 			atomic_set(&sdev_to_zfcp(sdev)->erp_counter, 0);
 	}
@@ -1498,7 +1498,7 @@ void zfcp_erp_set_port_status(struct zfc
 	u32 common_mask = mask & ZFCP_COMMON_FLAGS;
 	unsigned long flags;
 
-	atomic_set_mask(mask, &port->status);
+	atomic_or(mask, &port->status);
 
 	if (!common_mask)
 		return;
@@ -1506,7 +1506,7 @@ void zfcp_erp_set_port_status(struct zfc
 	spin_lock_irqsave(port->adapter->scsi_host->host_lock, flags);
 	__shost_for_each_device(sdev, port->adapter->scsi_host)
 		if (sdev_to_zfcp(sdev)->port == port)
-			atomic_set_mask(common_mask,
+			atomic_or(common_mask,
 					&sdev_to_zfcp(sdev)->status);
 	spin_unlock_irqrestore(port->adapter->scsi_host->host_lock, flags);
 }
@@ -1525,7 +1525,7 @@ void zfcp_erp_clear_port_status(struct z
 	u32 clear_counter = mask & ZFCP_STATUS_COMMON_ERP_FAILED;
 	unsigned long flags;
 
-	atomic_clear_mask(mask, &port->status);
+	atomic_and(~mask, &port->status);
 
 	if (!common_mask)
 		return;
@@ -1536,7 +1536,7 @@ void zfcp_erp_clear_port_status(struct z
 	spin_lock_irqsave(port->adapter->scsi_host->host_lock, flags);
 	__shost_for_each_device(sdev, port->adapter->scsi_host)
 		if (sdev_to_zfcp(sdev)->port == port) {
-			atomic_clear_mask(common_mask,
+			atomic_and(~common_mask,
 					  &sdev_to_zfcp(sdev)->status);
 			if (clear_counter)
 				atomic_set(&sdev_to_zfcp(sdev)->erp_counter, 0);
@@ -1553,7 +1553,7 @@ void zfcp_erp_set_lun_status(struct scsi
 {
 	struct zfcp_scsi_dev *zfcp_sdev = sdev_to_zfcp(sdev);
 
-	atomic_set_mask(mask, &zfcp_sdev->status);
+	atomic_or(mask, &zfcp_sdev->status);
 }
 
 /**
@@ -1565,7 +1565,7 @@ void zfcp_erp_clear_lun_status(struct sc
 {
 	struct zfcp_scsi_dev *zfcp_sdev = sdev_to_zfcp(sdev);
 
-	atomic_clear_mask(mask, &zfcp_sdev->status);
+	atomic_and(~mask, &zfcp_sdev->status);
 
 	if (mask & ZFCP_STATUS_COMMON_ERP_FAILED)
 		atomic_set(&zfcp_sdev->erp_counter, 0);
--- a/drivers/s390/scsi/zfcp_fc.c
+++ b/drivers/s390/scsi/zfcp_fc.c
@@ -465,7 +465,7 @@ static void zfcp_fc_adisc_handler(void *
 	/* port is good, unblock rport without going through erp */
 	zfcp_scsi_schedule_rport_register(port);
  out:
-	atomic_clear_mask(ZFCP_STATUS_PORT_LINK_TEST, &port->status);
+	atomic_and(~ZFCP_STATUS_PORT_LINK_TEST, &port->status);
 	put_device(&port->dev);
 	kmem_cache_free(zfcp_fc_req_cache, fc_req);
 }
@@ -521,14 +521,14 @@ void zfcp_fc_link_test_work(struct work_
 	if (atomic_read(&port->status) & ZFCP_STATUS_PORT_LINK_TEST)
 		goto out;
 
-	atomic_set_mask(ZFCP_STATUS_PORT_LINK_TEST, &port->status);
+	atomic_or(ZFCP_STATUS_PORT_LINK_TEST, &port->status);
 
 	retval = zfcp_fc_adisc(port);
 	if (retval == 0)
 		return;
 
 	/* send of ADISC was not possible */
-	atomic_clear_mask(ZFCP_STATUS_PORT_LINK_TEST, &port->status);
+	atomic_and(~ZFCP_STATUS_PORT_LINK_TEST, &port->status);
 	zfcp_erp_port_forced_reopen(port, 0, "fcltwk1");
 
 out:
@@ -597,7 +597,7 @@ static void zfcp_fc_validate_port(struct
 	if (!(atomic_read(&port->status) & ZFCP_STATUS_COMMON_NOESC))
 		return;
 
-	atomic_clear_mask(ZFCP_STATUS_COMMON_NOESC, &port->status);
+	atomic_and(~ZFCP_STATUS_COMMON_NOESC, &port->status);
 
 	if ((port->supported_classes != 0) ||
 	    !list_empty(&port->unit_list))
--- a/drivers/s390/scsi/zfcp_fsf.c
+++ b/drivers/s390/scsi/zfcp_fsf.c
@@ -114,7 +114,7 @@ static void zfcp_fsf_link_down_info_eval
 	if (atomic_read(&adapter->status) & ZFCP_STATUS_ADAPTER_LINK_UNPLUGGED)
 		return;
 
-	atomic_set_mask(ZFCP_STATUS_ADAPTER_LINK_UNPLUGGED, &adapter->status);
+	atomic_or(ZFCP_STATUS_ADAPTER_LINK_UNPLUGGED, &adapter->status);
 
 	zfcp_scsi_schedule_rports_block(adapter);
 
@@ -345,7 +345,7 @@ static void zfcp_fsf_protstatus_eval(str
 		zfcp_erp_adapter_shutdown(adapter, 0, "fspse_3");
 		break;
 	case FSF_PROT_HOST_CONNECTION_INITIALIZING:
-		atomic_set_mask(ZFCP_STATUS_ADAPTER_HOST_CON_INIT,
+		atomic_or(ZFCP_STATUS_ADAPTER_HOST_CON_INIT,
 				&adapter->status);
 		break;
 	case FSF_PROT_DUPLICATE_REQUEST_ID:
@@ -554,7 +554,7 @@ static void zfcp_fsf_exchange_config_dat
 			zfcp_erp_adapter_shutdown(adapter, 0, "fsecdh1");
 			return;
 		}
-		atomic_set_mask(ZFCP_STATUS_ADAPTER_XCONFIG_OK,
+		atomic_or(ZFCP_STATUS_ADAPTER_XCONFIG_OK,
 				&adapter->status);
 		break;
 	case FSF_EXCHANGE_CONFIG_DATA_INCOMPLETE:
@@ -567,7 +567,7 @@ static void zfcp_fsf_exchange_config_dat
 
 		/* avoids adapter shutdown to be able to recognize
 		 * events such as LINK UP */
-		atomic_set_mask(ZFCP_STATUS_ADAPTER_XCONFIG_OK,
+		atomic_or(ZFCP_STATUS_ADAPTER_XCONFIG_OK,
 				&adapter->status);
 		zfcp_fsf_link_down_info_eval(req,
 			&qtcb->header.fsf_status_qual.link_down_info);
@@ -1394,10 +1394,10 @@ static void zfcp_fsf_open_port_handler(s
 		break;
 	case FSF_GOOD:
 		port->handle = header->port_handle;
-		atomic_set_mask(ZFCP_STATUS_COMMON_OPEN |
+		atomic_or(ZFCP_STATUS_COMMON_OPEN |
 				ZFCP_STATUS_PORT_PHYS_OPEN, &port->status);
-		atomic_clear_mask(ZFCP_STATUS_COMMON_ACCESS_DENIED |
-		                  ZFCP_STATUS_COMMON_ACCESS_BOXED,
+		atomic_and(~(ZFCP_STATUS_COMMON_ACCESS_DENIED |
+		                  ZFCP_STATUS_COMMON_ACCESS_BOXED),
 		                  &port->status);
 		/* check whether D_ID has changed during open */
 		/*
@@ -1678,10 +1678,10 @@ static void zfcp_fsf_close_physical_port
 	case FSF_PORT_BOXED:
 		/* can't use generic zfcp_erp_modify_port_status because
 		 * ZFCP_STATUS_COMMON_OPEN must not be reset for the port */
-		atomic_clear_mask(ZFCP_STATUS_PORT_PHYS_OPEN, &port->status);
+		atomic_and(~ZFCP_STATUS_PORT_PHYS_OPEN, &port->status);
 		shost_for_each_device(sdev, port->adapter->scsi_host)
 			if (sdev_to_zfcp(sdev)->port == port)
-				atomic_clear_mask(ZFCP_STATUS_COMMON_OPEN,
+				atomic_and(~ZFCP_STATUS_COMMON_OPEN,
 						  &sdev_to_zfcp(sdev)->status);
 		zfcp_erp_set_port_status(port, ZFCP_STATUS_COMMON_ACCESS_BOXED);
 		zfcp_erp_port_reopen(port, ZFCP_STATUS_COMMON_ERP_FAILED,
@@ -1701,10 +1701,10 @@ static void zfcp_fsf_close_physical_port
 		/* can't use generic zfcp_erp_modify_port_status because
 		 * ZFCP_STATUS_COMMON_OPEN must not be reset for the port
 		 */
-		atomic_clear_mask(ZFCP_STATUS_PORT_PHYS_OPEN, &port->status);
+		atomic_and(~ZFCP_STATUS_PORT_PHYS_OPEN, &port->status);
 		shost_for_each_device(sdev, port->adapter->scsi_host)
 			if (sdev_to_zfcp(sdev)->port == port)
-				atomic_clear_mask(ZFCP_STATUS_COMMON_OPEN,
+				atomic_and(~ZFCP_STATUS_COMMON_OPEN,
 						  &sdev_to_zfcp(sdev)->status);
 		break;
 	}
@@ -1767,8 +1767,8 @@ static void zfcp_fsf_open_lun_handler(st
 
 	zfcp_sdev = sdev_to_zfcp(sdev);
 
-	atomic_clear_mask(ZFCP_STATUS_COMMON_ACCESS_DENIED |
-			  ZFCP_STATUS_COMMON_ACCESS_BOXED,
+	atomic_and(~(ZFCP_STATUS_COMMON_ACCESS_DENIED |
+			  ZFCP_STATUS_COMMON_ACCESS_BOXED),
 			  &zfcp_sdev->status);
 
 	switch (header->fsf_status) {
@@ -1823,7 +1823,7 @@ static void zfcp_fsf_open_lun_handler(st
 
 	case FSF_GOOD:
 		zfcp_sdev->lun_handle = header->lun_handle;
-		atomic_set_mask(ZFCP_STATUS_COMMON_OPEN, &zfcp_sdev->status);
+		atomic_or(ZFCP_STATUS_COMMON_OPEN, &zfcp_sdev->status);
 		break;
 	}
 }
@@ -1914,7 +1914,7 @@ static void zfcp_fsf_close_lun_handler(s
 		}
 		break;
 	case FSF_GOOD:
-		atomic_clear_mask(ZFCP_STATUS_COMMON_OPEN, &zfcp_sdev->status);
+		atomic_and(~ZFCP_STATUS_COMMON_OPEN, &zfcp_sdev->status);
 		break;
 	}
 }
--- a/drivers/s390/scsi/zfcp_qdio.c
+++ b/drivers/s390/scsi/zfcp_qdio.c
@@ -351,7 +351,7 @@ void zfcp_qdio_close(struct zfcp_qdio *q
 
 	/* clear QDIOUP flag, thus do_QDIO is not called during qdio_shutdown */
 	spin_lock_irq(&qdio->req_q_lock);
-	atomic_clear_mask(ZFCP_STATUS_ADAPTER_QDIOUP, &adapter->status);
+	atomic_and(~ZFCP_STATUS_ADAPTER_QDIOUP, &adapter->status);
 	spin_unlock_irq(&qdio->req_q_lock);
 
 	wake_up(&qdio->req_q_wq);
@@ -386,7 +386,7 @@ int zfcp_qdio_open(struct zfcp_qdio *qdi
 	if (atomic_read(&adapter->status) & ZFCP_STATUS_ADAPTER_QDIOUP)
 		return -EIO;
 
-	atomic_clear_mask(ZFCP_STATUS_ADAPTER_SIOSL_ISSUED,
+	atomic_and(~ZFCP_STATUS_ADAPTER_SIOSL_ISSUED,
 			  &qdio->adapter->status);
 
 	zfcp_qdio_setup_init_data(&init_data, qdio);
@@ -398,14 +398,14 @@ int zfcp_qdio_open(struct zfcp_qdio *qdi
 		goto failed_qdio;
 
 	if (ssqd.qdioac2 & CHSC_AC2_DATA_DIV_ENABLED)
-		atomic_set_mask(ZFCP_STATUS_ADAPTER_DATA_DIV_ENABLED,
+		atomic_or(ZFCP_STATUS_ADAPTER_DATA_DIV_ENABLED,
 				&qdio->adapter->status);
 
 	if (ssqd.qdioac2 & CHSC_AC2_MULTI_BUFFER_ENABLED) {
-		atomic_set_mask(ZFCP_STATUS_ADAPTER_MB_ACT, &adapter->status);
+		atomic_or(ZFCP_STATUS_ADAPTER_MB_ACT, &adapter->status);
 		qdio->max_sbale_per_sbal = QDIO_MAX_ELEMENTS_PER_BUFFER;
 	} else {
-		atomic_clear_mask(ZFCP_STATUS_ADAPTER_MB_ACT, &adapter->status);
+		atomic_and(~ZFCP_STATUS_ADAPTER_MB_ACT, &adapter->status);
 		qdio->max_sbale_per_sbal = QDIO_MAX_ELEMENTS_PER_BUFFER - 1;
 	}
 
@@ -429,7 +429,7 @@ int zfcp_qdio_open(struct zfcp_qdio *qdi
 	/* set index of first available SBALS / number of available SBALS */
 	qdio->req_q_idx = 0;
 	atomic_set(&qdio->req_q_free, QDIO_MAX_BUFFERS_PER_Q);
-	atomic_set_mask(ZFCP_STATUS_ADAPTER_QDIOUP, &qdio->adapter->status);
+	atomic_or(ZFCP_STATUS_ADAPTER_QDIOUP, &qdio->adapter->status);
 
 	if (adapter->scsi_host) {
 		adapter->scsi_host->sg_tablesize = qdio->max_sbale_per_req;
@@ -506,6 +506,6 @@ void zfcp_qdio_siosl(struct zfcp_adapter
 
 	rc = ccw_device_siosl(adapter->ccw_device);
 	if (!rc)
-		atomic_set_mask(ZFCP_STATUS_ADAPTER_SIOSL_ISSUED,
+		atomic_or(ZFCP_STATUS_ADAPTER_SIOSL_ISSUED,
 				&adapter->status);
 }
--- a/include/asm-generic/atomic.h
+++ b/include/asm-generic/atomic.h
@@ -61,16 +61,32 @@ GEN_ATOMIC_OP(add, +)
 GEN_ATOMIC_OP(sub, -)
 #endif
 
-#ifndef atomic_clear_mask
+#ifndef atomic_and_return
 GEN_ATOMIC_OP(and, &)
-#define atomic_clear_mask(i, v) (void)atomic_and_return(~(i), (v))
 #endif
 
-#ifndef atomic_set_mask
+#ifndef atomic_or_return
 GEN_ATOMIC_OP(or, |)
-#define atomic_set_mask(i, v)	(void)atomic_or_return((i), (v))
 #endif
 
+#ifndef atomic_xor_return
+GEN_ATOMIC_OP(xor, ^)
+#endif
+
+#undef GEN_ATOMIC_OP
+
+#define GEN_ATOMIC_OP(op)						\
+static inline void atomic_##op(int i, atomic_t *v)			\
+{									\
+	atomic_##op##_return(i, v);					\
+}
+
+GEN_ATOMIC_OP(add)
+GEN_ATOMIC_OP(sub)
+GEN_ATOMIC_OP(and)
+GEN_ATOMIC_OP(or)
+GEN_ATOMIC_OP(xor)
+
 #undef GEN_ATOMIC_OP
 
 /*
@@ -106,16 +122,6 @@ static inline int atomic_add_negative(in
 	return atomic_add_return(i, v) < 0;
 }
 
-static inline void atomic_add(int i, atomic_t *v)
-{
-	atomic_add_return(i, v);
-}
-
-static inline void atomic_sub(int i, atomic_t *v)
-{
-	atomic_sub_return(i, v);
-}
-
 static inline void atomic_inc(atomic_t *v)
 {
 	atomic_add_return(1, v);
--- a/include/asm-generic/atomic64.h
+++ b/include/asm-generic/atomic64.h
@@ -20,10 +20,19 @@ typedef struct {
 
 extern long long atomic64_read(const atomic64_t *v);
 extern void	 atomic64_set(atomic64_t *v, long long i);
-extern void	 atomic64_add(long long a, atomic64_t *v);
-extern long long atomic64_add_return(long long a, atomic64_t *v);
-extern void	 atomic64_sub(long long a, atomic64_t *v);
-extern long long atomic64_sub_return(long long a, atomic64_t *v);
+
+#define ATOMIC64_OP(op)							\
+extern void	 atomic64_##op(long long a, atomic64_t *v);		\
+extern long long atomic64_##op##_return(long long a, atomic64_t *v);
+
+ATOMIC64_OP(add)
+ATOMIC64_OP(sub)
+ATOMIC64_OP(and)
+ATOMIC64_OP(or )
+ATOMIC64_OP(xor)
+
+#undef ATOMIC64_OP
+
 extern long long atomic64_dec_if_positive(atomic64_t *v);
 extern long long atomic64_cmpxchg(atomic64_t *v, long long o, long long n);
 extern long long atomic64_xchg(atomic64_t *v, long long new);
--- a/include/linux/atomic.h
+++ b/include/linux/atomic.h
@@ -111,19 +111,6 @@ static inline int atomic_dec_if_positive
 }
 #endif
 
-#ifndef CONFIG_ARCH_HAS_ATOMIC_OR
-static inline void atomic_or(int i, atomic_t *v)
-{
-	int old;
-	int new;
-
-	do {
-		old = atomic_read(v);
-		new = old | i;
-	} while (atomic_cmpxchg(v, old, new) != old);
-}
-#endif /* #ifndef CONFIG_ARCH_HAS_ATOMIC_OR */
-
 #include <asm-generic/atomic-long.h>
 #ifdef CONFIG_GENERIC_ATOMIC64
 #include <asm-generic/atomic64.h>
--- a/lib/atomic64.c
+++ b/lib/atomic64.c
@@ -70,53 +70,38 @@ void atomic64_set(atomic64_t *v, long lo
 }
 EXPORT_SYMBOL(atomic64_set);
 
-void atomic64_add(long long a, atomic64_t *v)
-{
-	unsigned long flags;
-	raw_spinlock_t *lock = lock_addr(v);
-
-	raw_spin_lock_irqsave(lock, flags);
-	v->counter += a;
-	raw_spin_unlock_irqrestore(lock, flags);
-}
-EXPORT_SYMBOL(atomic64_add);
-
-long long atomic64_add_return(long long a, atomic64_t *v)
-{
-	unsigned long flags;
-	raw_spinlock_t *lock = lock_addr(v);
-	long long val;
-
-	raw_spin_lock_irqsave(lock, flags);
-	val = v->counter += a;
-	raw_spin_unlock_irqrestore(lock, flags);
-	return val;
-}
-EXPORT_SYMBOL(atomic64_add_return);
+#define ATOMIC64_OP(op, cop)						\
+void atomic64_##op(long long a, atomic64_t *v)				\
+{									\
+	unsigned long flags;						\
+	raw_spinlock_t *lock = lock_addr(v);				\
+									\
+	raw_spin_lock_irqsave(lock, flags);				\
+	v->counter cop a;						\
+	raw_spin_unlock_irqrestore(lock, flags);			\
+}									\
+EXPORT_SYMBOL(atomic64_##op);						\
+									\
+long long atomic64_##op##_return(long long a, atomic64_t *v)		\
+{									\
+	unsigned long flags;						\
+	raw_spinlock_t *lock = lock_addr(v);				\
+	long long val;							\
+									\
+	raw_spin_lock_irqsave(lock, flags);				\
+	val = (v->counter cop a);					\
+	raw_spin_unlock_irqrestore(lock, flags);			\
+	return val;							\
+}									\
+EXPORT_SYMBOL(atomic64_##op##_return);
+
+ATOMIC64_OP(add, +=)
+ATOMIC64_OP(sub, -=)
+ATOMIC64_OP(and, &=)
+ATOMIC64_OP(or , |=)
+ATOMIC64_OP(xor, ^=)
 
-void atomic64_sub(long long a, atomic64_t *v)
-{
-	unsigned long flags;
-	raw_spinlock_t *lock = lock_addr(v);
-
-	raw_spin_lock_irqsave(lock, flags);
-	v->counter -= a;
-	raw_spin_unlock_irqrestore(lock, flags);
-}
-EXPORT_SYMBOL(atomic64_sub);
-
-long long atomic64_sub_return(long long a, atomic64_t *v)
-{
-	unsigned long flags;
-	raw_spinlock_t *lock = lock_addr(v);
-	long long val;
-
-	raw_spin_lock_irqsave(lock, flags);
-	val = v->counter -= a;
-	raw_spin_unlock_irqrestore(lock, flags);
-	return val;
-}
-EXPORT_SYMBOL(atomic64_sub_return);
+#undef ATOMIC64_OP
 
 long long atomic64_dec_if_positive(atomic64_t *v)
 {


