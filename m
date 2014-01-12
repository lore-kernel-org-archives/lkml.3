Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752493AbaALSpQ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Jan 2014 13:45:16 -0500
Received: from terminus.zytor.com ([198.137.202.10]:46401 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751922AbaALSpK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Jan 2014 13:45:10 -0500
Date: Sun, 12 Jan 2014 10:43:50 -0800
From: tip-bot for Peter Zijlstra <tipbot@zytor.com>
Message-ID: <tip-47933ad41a86a4a9b50bed7c9b9bd2ba242aac63@git.kernel.org>
Cc: mathieu.desnoyers@polymtl.ca, mingo@kernel.org,
        torvalds@linux-foundation.org, schwidefsky@de.ibm.com,
        peterz@infradead.org, tony.luck@intel.com, fweisbec@gmail.com,
        linux@arm.linux.org.uk, heiko.carstens@de.ibm.com, oleg@redhat.com,
        VICTORK@il.ibm.com, tglx@linutronix.de, linux-kernel@vger.kernel.org,
        hpa@zytor.com, will.deacon@arm.com, michael@ellerman.id.au,
        paulmck@linux.vnet.ibm.com, benh@kernel.crashing.org,
        geert@linux-m68k.org, mikey@neuling.org
Reply-To: mingo@kernel.org, mathieu.desnoyers@polymtl.ca,
        torvalds@linux-foundation.org, peterz@infradead.org,
        schwidefsky@de.ibm.com, tony.luck@intel.com, fweisbec@gmail.com,
        linux@arm.linux.org.uk, heiko.carstens@de.ibm.com, tglx@linutronix.de,
        VICTORK@il.ibm.com, oleg@redhat.com, linux-kernel@vger.kernel.org,
        hpa@zytor.com, will.deacon@arm.com, michael@ellerman.id.au,
        paulmck@linux.vnet.ibm.com, geert@linux-m68k.org,
        benh@kernel.crashing.org, mikey@neuling.org
In-Reply-To: <20131213150640.908486364@infradead.org>
References: <20131213150640.908486364@infradead.org>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:core/locking] arch: Introduce smp_load_acquire(),
  smp_store_release()
Git-Commit-ID: 47933ad41a86a4a9b50bed7c9b9bd2ba242aac63
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.1 (terminus.zytor.com [127.0.0.1]); Sun, 12 Jan 2014 10:43:57 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  47933ad41a86a4a9b50bed7c9b9bd2ba242aac63
Gitweb:     http://git.kernel.org/tip/47933ad41a86a4a9b50bed7c9b9bd2ba242aac63
Author:     Peter Zijlstra <peterz@infradead.org>
AuthorDate: Wed, 6 Nov 2013 14:57:36 +0100
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Sun, 12 Jan 2014 10:37:17 +0100

arch: Introduce smp_load_acquire(), smp_store_release()

A number of situations currently require the heavyweight smp_mb(),
even though there is no need to order prior stores against later
loads.  Many architectures have much cheaper ways to handle these
situations, but the Linux kernel currently has no portable way
to make use of them.

This commit therefore supplies smp_load_acquire() and
smp_store_release() to remedy this situation.  The new
smp_load_acquire() primitive orders the specified load against
any subsequent reads or writes, while the new smp_store_release()
primitive orders the specifed store against any prior reads or
writes.  These primitives allow array-based circular FIFOs to be
implemented without an smp_mb(), and also allow a theoretical
hole in rcu_assign_pointer() to be closed at no additional
expense on most architectures.

In addition, the RCU experience transitioning from explicit
smp_read_barrier_depends() and smp_wmb() to rcu_dereference()
and rcu_assign_pointer(), respectively resulted in substantial
improvements in readability.  It therefore seems likely that
replacing other explicit barriers with smp_load_acquire() and
smp_store_release() will provide similar benefits.  It appears
that roughly half of the explicit barriers in core kernel code
might be so replaced.

[Changelog by PaulMck]

Reviewed-by: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Signed-off-by: Peter Zijlstra <peterz@infradead.org>
Acked-by: Will Deacon <will.deacon@arm.com>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
Cc: Michael Ellerman <michael@ellerman.id.au>
Cc: Michael Neuling <mikey@neuling.org>
Cc: Russell King <linux@arm.linux.org.uk>
Cc: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Heiko Carstens <heiko.carstens@de.ibm.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Martin Schwidefsky <schwidefsky@de.ibm.com>
Cc: Victor Kaplansky <VICTORK@il.ibm.com>
Cc: Tony Luck <tony.luck@intel.com>
Cc: Oleg Nesterov <oleg@redhat.com>
Link: http://lkml.kernel.org/r/20131213150640.908486364@infradead.org
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 arch/arm/include/asm/barrier.h      | 15 +++++++++++
 arch/arm64/include/asm/barrier.h    | 50 +++++++++++++++++++++++++++++++++++++
 arch/ia64/include/asm/barrier.h     | 23 +++++++++++++++++
 arch/metag/include/asm/barrier.h    | 15 +++++++++++
 arch/mips/include/asm/barrier.h     | 15 +++++++++++
 arch/powerpc/include/asm/barrier.h  | 21 +++++++++++++++-
 arch/s390/include/asm/barrier.h     | 15 +++++++++++
 arch/sparc/include/asm/barrier_64.h | 15 +++++++++++
 arch/x86/include/asm/barrier.h      | 43 ++++++++++++++++++++++++++++++-
 include/asm-generic/barrier.h       | 15 +++++++++++
 include/linux/compiler.h            |  9 +++++++
 11 files changed, 234 insertions(+), 2 deletions(-)

diff --git a/arch/arm/include/asm/barrier.h b/arch/arm/include/asm/barrier.h
index 60f15e2..2f59f74 100644
--- a/arch/arm/include/asm/barrier.h
+++ b/arch/arm/include/asm/barrier.h
@@ -59,6 +59,21 @@
 #define smp_wmb()	dmb(ishst)
 #endif
 
+#define smp_store_release(p, v)						\
+do {									\
+	compiletime_assert_atomic_type(*p);				\
+	smp_mb();							\
+	ACCESS_ONCE(*p) = (v);						\
+} while (0)
+
+#define smp_load_acquire(p)						\
+({									\
+	typeof(*p) ___p1 = ACCESS_ONCE(*p);				\
+	compiletime_assert_atomic_type(*p);				\
+	smp_mb();							\
+	___p1;								\
+})
+
 #define read_barrier_depends()		do { } while(0)
 #define smp_read_barrier_depends()	do { } while(0)
 
diff --git a/arch/arm64/include/asm/barrier.h b/arch/arm64/include/asm/barrier.h
index d4a6333..78e20ba 100644
--- a/arch/arm64/include/asm/barrier.h
+++ b/arch/arm64/include/asm/barrier.h
@@ -35,10 +35,60 @@
 #define smp_mb()	barrier()
 #define smp_rmb()	barrier()
 #define smp_wmb()	barrier()
+
+#define smp_store_release(p, v)						\
+do {									\
+	compiletime_assert_atomic_type(*p);				\
+	smp_mb();							\
+	ACCESS_ONCE(*p) = (v);						\
+} while (0)
+
+#define smp_load_acquire(p)						\
+({									\
+	typeof(*p) ___p1 = ACCESS_ONCE(*p);				\
+	compiletime_assert_atomic_type(*p);				\
+	smp_mb();							\
+	___p1;								\
+})
+
 #else
+
 #define smp_mb()	asm volatile("dmb ish" : : : "memory")
 #define smp_rmb()	asm volatile("dmb ishld" : : : "memory")
 #define smp_wmb()	asm volatile("dmb ishst" : : : "memory")
+
+#define smp_store_release(p, v)						\
+do {									\
+	compiletime_assert_atomic_type(*p);				\
+	switch (sizeof(*p)) {						\
+	case 4:								\
+		asm volatile ("stlr %w1, %0"				\
+				: "=Q" (*p) : "r" (v) : "memory");	\
+		break;							\
+	case 8:								\
+		asm volatile ("stlr %1, %0"				\
+				: "=Q" (*p) : "r" (v) : "memory");	\
+		break;							\
+	}								\
+} while (0)
+
+#define smp_load_acquire(p)						\
+({									\
+	typeof(*p) ___p1;						\
+	compiletime_assert_atomic_type(*p);				\
+	switch (sizeof(*p)) {						\
+	case 4:								\
+		asm volatile ("ldar %w0, %1"				\
+			: "=r" (___p1) : "Q" (*p) : "memory");		\
+		break;							\
+	case 8:								\
+		asm volatile ("ldar %0, %1"				\
+			: "=r" (___p1) : "Q" (*p) : "memory");		\
+		break;							\
+	}								\
+	___p1;								\
+})
+
 #endif
 
 #define read_barrier_depends()		do { } while(0)
diff --git a/arch/ia64/include/asm/barrier.h b/arch/ia64/include/asm/barrier.h
index 60576e0..d0a69aa 100644
--- a/arch/ia64/include/asm/barrier.h
+++ b/arch/ia64/include/asm/barrier.h
@@ -45,14 +45,37 @@
 # define smp_rmb()	rmb()
 # define smp_wmb()	wmb()
 # define smp_read_barrier_depends()	read_barrier_depends()
+
 #else
+
 # define smp_mb()	barrier()
 # define smp_rmb()	barrier()
 # define smp_wmb()	barrier()
 # define smp_read_barrier_depends()	do { } while(0)
+
 #endif
 
 /*
+ * IA64 GCC turns volatile stores into st.rel and volatile loads into ld.acq no
+ * need for asm trickery!
+ */
+
+#define smp_store_release(p, v)						\
+do {									\
+	compiletime_assert_atomic_type(*p);				\
+	barrier();							\
+	ACCESS_ONCE(*p) = (v);						\
+} while (0)
+
+#define smp_load_acquire(p)						\
+({									\
+	typeof(*p) ___p1 = ACCESS_ONCE(*p);				\
+	compiletime_assert_atomic_type(*p);				\
+	barrier();							\
+	___p1;								\
+})
+
+/*
  * XXX check on this ---I suspect what Linus really wants here is
  * acquire vs release semantics but we can't discuss this stuff with
  * Linus just yet.  Grrr...
diff --git a/arch/metag/include/asm/barrier.h b/arch/metag/include/asm/barrier.h
index c90bfc6..5d6b4b4 100644
--- a/arch/metag/include/asm/barrier.h
+++ b/arch/metag/include/asm/barrier.h
@@ -82,4 +82,19 @@ static inline void fence(void)
 #define smp_read_barrier_depends()     do { } while (0)
 #define set_mb(var, value) do { var = value; smp_mb(); } while (0)
 
+#define smp_store_release(p, v)						\
+do {									\
+	compiletime_assert_atomic_type(*p);				\
+	smp_mb();							\
+	ACCESS_ONCE(*p) = (v);						\
+} while (0)
+
+#define smp_load_acquire(p)						\
+({									\
+	typeof(*p) ___p1 = ACCESS_ONCE(*p);				\
+	compiletime_assert_atomic_type(*p);				\
+	smp_mb();							\
+	___p1;								\
+})
+
 #endif /* _ASM_METAG_BARRIER_H */
diff --git a/arch/mips/include/asm/barrier.h b/arch/mips/include/asm/barrier.h
index f26d8e1..e1aa4e4 100644
--- a/arch/mips/include/asm/barrier.h
+++ b/arch/mips/include/asm/barrier.h
@@ -180,4 +180,19 @@
 #define nudge_writes() mb()
 #endif
 
+#define smp_store_release(p, v)						\
+do {									\
+	compiletime_assert_atomic_type(*p);				\
+	smp_mb();							\
+	ACCESS_ONCE(*p) = (v);						\
+} while (0)
+
+#define smp_load_acquire(p)						\
+({									\
+	typeof(*p) ___p1 = ACCESS_ONCE(*p);				\
+	compiletime_assert_atomic_type(*p);				\
+	smp_mb();							\
+	___p1;								\
+})
+
 #endif /* __ASM_BARRIER_H */
diff --git a/arch/powerpc/include/asm/barrier.h b/arch/powerpc/include/asm/barrier.h
index ae78225..f89da80 100644
--- a/arch/powerpc/include/asm/barrier.h
+++ b/arch/powerpc/include/asm/barrier.h
@@ -45,11 +45,15 @@
 #    define SMPWMB      eieio
 #endif
 
+#define __lwsync()	__asm__ __volatile__ (stringify_in_c(LWSYNC) : : :"memory")
+
 #define smp_mb()	mb()
-#define smp_rmb()	__asm__ __volatile__ (stringify_in_c(LWSYNC) : : :"memory")
+#define smp_rmb()	__lwsync()
 #define smp_wmb()	__asm__ __volatile__ (stringify_in_c(SMPWMB) : : :"memory")
 #define smp_read_barrier_depends()	read_barrier_depends()
 #else
+#define __lwsync()	barrier()
+
 #define smp_mb()	barrier()
 #define smp_rmb()	barrier()
 #define smp_wmb()	barrier()
@@ -65,4 +69,19 @@
 #define data_barrier(x)	\
 	asm volatile("twi 0,%0,0; isync" : : "r" (x) : "memory");
 
+#define smp_store_release(p, v)						\
+do {									\
+	compiletime_assert_atomic_type(*p);				\
+	__lwsync();							\
+	ACCESS_ONCE(*p) = (v);						\
+} while (0)
+
+#define smp_load_acquire(p)						\
+({									\
+	typeof(*p) ___p1 = ACCESS_ONCE(*p);				\
+	compiletime_assert_atomic_type(*p);				\
+	__lwsync();							\
+	___p1;								\
+})
+
 #endif /* _ASM_POWERPC_BARRIER_H */
diff --git a/arch/s390/include/asm/barrier.h b/arch/s390/include/asm/barrier.h
index 16760ee..578680f 100644
--- a/arch/s390/include/asm/barrier.h
+++ b/arch/s390/include/asm/barrier.h
@@ -32,4 +32,19 @@
 
 #define set_mb(var, value)		do { var = value; mb(); } while (0)
 
+#define smp_store_release(p, v)						\
+do {									\
+	compiletime_assert_atomic_type(*p);				\
+	barrier();							\
+	ACCESS_ONCE(*p) = (v);						\
+} while (0)
+
+#define smp_load_acquire(p)						\
+({									\
+	typeof(*p) ___p1 = ACCESS_ONCE(*p);				\
+	compiletime_assert_atomic_type(*p);				\
+	barrier();							\
+	___p1;								\
+})
+
 #endif /* __ASM_BARRIER_H */
diff --git a/arch/sparc/include/asm/barrier_64.h b/arch/sparc/include/asm/barrier_64.h
index 95d4598..b5aad96 100644
--- a/arch/sparc/include/asm/barrier_64.h
+++ b/arch/sparc/include/asm/barrier_64.h
@@ -53,4 +53,19 @@ do {	__asm__ __volatile__("ba,pt	%%xcc, 1f\n\t" \
 
 #define smp_read_barrier_depends()	do { } while(0)
 
+#define smp_store_release(p, v)						\
+do {									\
+	compiletime_assert_atomic_type(*p);				\
+	barrier();							\
+	ACCESS_ONCE(*p) = (v);						\
+} while (0)
+
+#define smp_load_acquire(p)						\
+({									\
+	typeof(*p) ___p1 = ACCESS_ONCE(*p);				\
+	compiletime_assert_atomic_type(*p);				\
+	barrier();							\
+	___p1;								\
+})
+
 #endif /* !(__SPARC64_BARRIER_H) */
diff --git a/arch/x86/include/asm/barrier.h b/arch/x86/include/asm/barrier.h
index c6cd358..04a4890 100644
--- a/arch/x86/include/asm/barrier.h
+++ b/arch/x86/include/asm/barrier.h
@@ -92,12 +92,53 @@
 #endif
 #define smp_read_barrier_depends()	read_barrier_depends()
 #define set_mb(var, value) do { (void)xchg(&var, value); } while (0)
-#else
+#else /* !SMP */
 #define smp_mb()	barrier()
 #define smp_rmb()	barrier()
 #define smp_wmb()	barrier()
 #define smp_read_barrier_depends()	do { } while (0)
 #define set_mb(var, value) do { var = value; barrier(); } while (0)
+#endif /* SMP */
+
+#if defined(CONFIG_X86_OOSTORE) || defined(CONFIG_X86_PPRO_FENCE)
+
+/*
+ * For either of these options x86 doesn't have a strong TSO memory
+ * model and we should fall back to full barriers.
+ */
+
+#define smp_store_release(p, v)						\
+do {									\
+	compiletime_assert_atomic_type(*p);				\
+	smp_mb();							\
+	ACCESS_ONCE(*p) = (v);						\
+} while (0)
+
+#define smp_load_acquire(p)						\
+({									\
+	typeof(*p) ___p1 = ACCESS_ONCE(*p);				\
+	compiletime_assert_atomic_type(*p);				\
+	smp_mb();							\
+	___p1;								\
+})
+
+#else /* regular x86 TSO memory ordering */
+
+#define smp_store_release(p, v)						\
+do {									\
+	compiletime_assert_atomic_type(*p);				\
+	barrier();							\
+	ACCESS_ONCE(*p) = (v);						\
+} while (0)
+
+#define smp_load_acquire(p)						\
+({									\
+	typeof(*p) ___p1 = ACCESS_ONCE(*p);				\
+	compiletime_assert_atomic_type(*p);				\
+	barrier();							\
+	___p1;								\
+})
+
 #endif
 
 /*
diff --git a/include/asm-generic/barrier.h b/include/asm-generic/barrier.h
index d12a90f..6f692f8 100644
--- a/include/asm-generic/barrier.h
+++ b/include/asm-generic/barrier.h
@@ -62,5 +62,20 @@
 #define set_mb(var, value)  do { (var) = (value); mb(); } while (0)
 #endif
 
+#define smp_store_release(p, v)						\
+do {									\
+	compiletime_assert_atomic_type(*p);				\
+	smp_mb();							\
+	ACCESS_ONCE(*p) = (v);						\
+} while (0)
+
+#define smp_load_acquire(p)						\
+({									\
+	typeof(*p) ___p1 = ACCESS_ONCE(*p);				\
+	compiletime_assert_atomic_type(*p);				\
+	smp_mb();							\
+	___p1;								\
+})
+
 #endif /* !__ASSEMBLY__ */
 #endif /* __ASM_GENERIC_BARRIER_H */
diff --git a/include/linux/compiler.h b/include/linux/compiler.h
index 92669cd..fe7a686 100644
--- a/include/linux/compiler.h
+++ b/include/linux/compiler.h
@@ -298,6 +298,11 @@ void ftrace_likely_update(struct ftrace_branch_data *f, int val, int expect);
 # define __same_type(a, b) __builtin_types_compatible_p(typeof(a), typeof(b))
 #endif
 
+/* Is this type a native word size -- useful for atomic operations */
+#ifndef __native_word
+# define __native_word(t) (sizeof(t) == sizeof(int) || sizeof(t) == sizeof(long))
+#endif
+
 /* Compile time object size, -1 for unknown */
 #ifndef __compiletime_object_size
 # define __compiletime_object_size(obj) -1
@@ -337,6 +342,10 @@ void ftrace_likely_update(struct ftrace_branch_data *f, int val, int expect);
 #define compiletime_assert(condition, msg) \
 	_compiletime_assert(condition, msg, __compiletime_assert_, __LINE__)
 
+#define compiletime_assert_atomic_type(t)				\
+	compiletime_assert(__native_word(t),				\
+		"Need native word sized stores/loads for atomicity.")
+
 /*
  * Prevent the compiler from merging or refetching accesses.  The compiler
  * is also forbidden from reordering successive instances of ACCESS_ONCE(),
