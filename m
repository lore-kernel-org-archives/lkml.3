Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753065Ab3KDTMB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Nov 2013 14:12:01 -0500
Received: from merlin.infradead.org ([205.233.59.134]:39268 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751519Ab3KDTL7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Nov 2013 14:11:59 -0500
Date: Mon, 4 Nov 2013 20:11:27 +0100
From: Peter Zijlstra <peterz@infradead.org>
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Victor Kaplansky <VICTORK@il.ibm.com>, Oleg Nesterov <oleg@redhat.com>,
        Anton Blanchard <anton@samba.org>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Linux PPC dev <linuxppc-dev@ozlabs.org>,
        Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
        Michael Ellerman <michael@ellerman.id.au>,
        Michael Neuling <mikey@neuling.org>
Subject: Re: [RFC] arch: Introduce new TSO memory barrier smp_tmb()
Message-ID: <20131104191127.GW16117@laptop.programming.kicks-ass.net>
References: <20131102173239.GB3947@linux.vnet.ibm.com>
 <20131103144017.GA25118@linux.vnet.ibm.com>
 <20131103151704.GJ19466@laptop.lan>
 <CA+55aFx_kuvR-0dwJtjvnhtha5QBc5XcLZPRH=WKT+hYVAKOrw@mail.gmail.com>
 <20131103200124.GK19466@laptop.lan>
 <20131103224242.GF3947@linux.vnet.ibm.com>
 <CA+55aFyD_kCkAHQwHCUBrumO-pH6LaZikTNvyWDW_tWsHdqk6Q@mail.gmail.com>
 <20131104105059.GL3947@linux.vnet.ibm.com>
 <20131104112254.GK28601@twins.programming.kicks-ass.net>
 <20131104162732.GN3947@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131104162732.GN3947@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 04, 2013 at 08:27:32AM -0800, Paul E. McKenney wrote:
> All this is leading me to suggest the following shortenings of names:
> 
> 	smp_load_with_acquire_semantics() -> smp_load_acquire()
> 
> 	smp_store_with_release_semantics() -> smp_store_release()
> 
> But names aside, the above gets rid of explicit barriers on TSO architectures,
> allows ARM to avoid full DMB, and allows PowerPC to use lwsync instead of
> the heavier-weight sync.

A little something like this? Completely guessed at the arm/arm64/ia64
asm, but at least for those archs I found proper instructions (I hope),
for x86,sparc,s390 which are TSO we can do with a barrier and PPC like
said can do with the lwsync, all others fall back to using a smp_mb().

Should probably come with a proper changelog and an addition to _The_
document.

---
 arch/alpha/include/asm/barrier.h      | 13 +++++++++++
 arch/arc/include/asm/barrier.h        | 13 +++++++++++
 arch/arm/include/asm/barrier.h        | 26 +++++++++++++++++++++
 arch/arm64/include/asm/barrier.h      | 28 +++++++++++++++++++++++
 arch/avr32/include/asm/barrier.h      | 12 ++++++++++
 arch/blackfin/include/asm/barrier.h   | 13 +++++++++++
 arch/cris/include/asm/barrier.h       | 13 +++++++++++
 arch/frv/include/asm/barrier.h        | 13 +++++++++++
 arch/h8300/include/asm/barrier.h      | 13 +++++++++++
 arch/hexagon/include/asm/barrier.h    | 13 +++++++++++
 arch/ia64/include/asm/barrier.h       | 43 +++++++++++++++++++++++++++++++++++
 arch/m32r/include/asm/barrier.h       | 13 +++++++++++
 arch/m68k/include/asm/barrier.h       | 13 +++++++++++
 arch/metag/include/asm/barrier.h      | 13 +++++++++++
 arch/microblaze/include/asm/barrier.h | 13 +++++++++++
 arch/mips/include/asm/barrier.h       | 13 +++++++++++
 arch/mn10300/include/asm/barrier.h    | 13 +++++++++++
 arch/parisc/include/asm/barrier.h     | 13 +++++++++++
 arch/powerpc/include/asm/barrier.h    | 15 ++++++++++++
 arch/s390/include/asm/barrier.h       | 13 +++++++++++
 arch/score/include/asm/barrier.h      | 13 +++++++++++
 arch/sh/include/asm/barrier.h         | 13 +++++++++++
 arch/sparc/include/asm/barrier_32.h   | 13 +++++++++++
 arch/sparc/include/asm/barrier_64.h   | 13 +++++++++++
 arch/tile/include/asm/barrier.h       | 13 +++++++++++
 arch/unicore32/include/asm/barrier.h  | 13 +++++++++++
 arch/x86/include/asm/barrier.h        | 13 +++++++++++
 arch/xtensa/include/asm/barrier.h     | 13 +++++++++++
 28 files changed, 423 insertions(+)

diff --git a/arch/alpha/include/asm/barrier.h b/arch/alpha/include/asm/barrier.h
index ce8860a0b32d..464139feee97 100644
--- a/arch/alpha/include/asm/barrier.h
+++ b/arch/alpha/include/asm/barrier.h
@@ -29,6 +29,19 @@ __asm__ __volatile__("mb": : :"memory")
 #define smp_read_barrier_depends()	do { } while (0)
 #endif
 
+#define smp_store_release(p, v)						\
+do {									\
+	smp_mb();							\
+	ACCESS_ONCE(p) = (v);						\
+} while (0)
+
+#define smp_load_acquire(p)						\
+do {									\
+	typeof(p) ___p1 = ACCESS_ONCE(p);				\
+	smp_mb();							\
+	return ___p1;							\
+} while (0)
+
 #define set_mb(var, value) \
 do { var = value; mb(); } while (0)
 
diff --git a/arch/arc/include/asm/barrier.h b/arch/arc/include/asm/barrier.h
index f6cb7c4ffb35..a779da846fb5 100644
--- a/arch/arc/include/asm/barrier.h
+++ b/arch/arc/include/asm/barrier.h
@@ -30,6 +30,19 @@
 #define smp_wmb()       barrier()
 #endif
 
+#define smp_store_release(p, v)						\
+do {									\
+	smp_mb();							\
+	ACCESS_ONCE(p) = (v);						\
+} while (0)
+
+#define smp_load_acquire(p)						\
+do {									\
+	typeof(p) ___p1 = ACCESS_ONCE(p);				\
+	smp_mb();							\
+	return ___p1;							\
+} while (0)
+
 #define smp_mb__before_atomic_dec()	barrier()
 #define smp_mb__after_atomic_dec()	barrier()
 #define smp_mb__before_atomic_inc()	barrier()
diff --git a/arch/arm/include/asm/barrier.h b/arch/arm/include/asm/barrier.h
index 60f15e274e6d..a804093d6891 100644
--- a/arch/arm/include/asm/barrier.h
+++ b/arch/arm/include/asm/barrier.h
@@ -53,10 +53,36 @@
 #define smp_mb()	barrier()
 #define smp_rmb()	barrier()
 #define smp_wmb()	barrier()
+
+#define smp_store_release(p, v)						\
+do {									\
+	smp_mb();							\
+	ACCESS_ONCE(p) = (v);						\
+} while (0)
+
+#define smp_load_acquire(p, v)						\
+do {									\
+	typeof(p) ___p1 = ACCESS_ONCE(p);				\
+	smp_mb();							\
+	return ___p1;							\
+} while (0)
 #else
 #define smp_mb()	dmb(ish)
 #define smp_rmb()	smp_mb()
 #define smp_wmb()	dmb(ishst)
+
+#define smp_store_release(p, v)						\
+do {									\
+	asm volatile ("stlr %w0 [%1]" : : "r" (v), "r" (&p) : "memory");\
+} while (0)
+
+#define smp_load_acquire(p)						\
+do {									\
+	typeof(p) ___p1;						\
+	asm volatile ("ldar %w0, [%1]"					\
+			: "=r" (___p1) : "r" (&p) : "memory");		\
+	return ___p1;							\
+} while (0)
 #endif
 
 #define read_barrier_depends()		do { } while(0)
diff --git a/arch/arm64/include/asm/barrier.h b/arch/arm64/include/asm/barrier.h
index d4a63338a53c..0da2d4ebb9a8 100644
--- a/arch/arm64/include/asm/barrier.h
+++ b/arch/arm64/include/asm/barrier.h
@@ -35,10 +35,38 @@
 #define smp_mb()	barrier()
 #define smp_rmb()	barrier()
 #define smp_wmb()	barrier()
+
+#define smp_store_release(p, v)						\
+do {									\
+	smp_mb();							\
+	ACCESS_ONCE(p) = (v);						\
+} while (0)
+
+#define smp_load_acquire(p, v)						\
+do {									\
+	typeof(p) ___p1 = ACCESS_ONCE(p);				\
+	smp_mb();							\
+	return ___p1;							\
+} while (0)
+
 #else
+
 #define smp_mb()	asm volatile("dmb ish" : : : "memory")
 #define smp_rmb()	asm volatile("dmb ishld" : : : "memory")
 #define smp_wmb()	asm volatile("dmb ishst" : : : "memory")
+
+#define smp_store_release(p, v)						\
+do {									\
+	asm volatile ("stlr %w0 [%1]" : : "r" (v), "r" (&p) : "memory");\
+} while (0)
+
+#define smp_load_acquire(p)						\
+do {									\
+	typeof(p) ___p1;						\
+	asm volatile ("ldar %w0, [%1]"					\
+			: "=r" (___p1) : "r" (&p) : "memory");		\
+	return ___p1;							\
+} while (0)
 #endif
 
 #define read_barrier_depends()		do { } while(0)
diff --git a/arch/avr32/include/asm/barrier.h b/arch/avr32/include/asm/barrier.h
index 0961275373db..a0c48ad684f8 100644
--- a/arch/avr32/include/asm/barrier.h
+++ b/arch/avr32/include/asm/barrier.h
@@ -25,5 +25,17 @@
 # define smp_read_barrier_depends() do { } while(0)
 #endif
 
+#define smp_store_release(p, v)						\
+do {									\
+	smp_mb();							\
+	ACCESS_ONCE(p) = (v);						\
+} while (0)
+
+#define smp_load_acquire(p, v)						\
+do {									\
+	typeof(p) ___p1 = ACCESS_ONCE(p);				\
+	smp_mb();							\
+	return ___p1;							\
+} while (0)
 
 #endif /* __ASM_AVR32_BARRIER_H */
diff --git a/arch/blackfin/include/asm/barrier.h b/arch/blackfin/include/asm/barrier.h
index ebb189507dd7..67889d9225d9 100644
--- a/arch/blackfin/include/asm/barrier.h
+++ b/arch/blackfin/include/asm/barrier.h
@@ -45,4 +45,17 @@
 #define set_mb(var, value) do { var = value; mb(); } while (0)
 #define smp_read_barrier_depends()	read_barrier_depends()
 
+#define smp_store_release(p, v)						\
+do {									\
+	smp_mb();							\
+	ACCESS_ONCE(p) = (v);						\
+} while (0)
+
+#define smp_load_acquire(p, v)						\
+do {									\
+	typeof(p) ___p1 = ACCESS_ONCE(p);				\
+	smp_mb();							\
+	return ___p1;							\
+} while (0)
+
 #endif /* _BLACKFIN_BARRIER_H */
diff --git a/arch/cris/include/asm/barrier.h b/arch/cris/include/asm/barrier.h
index 198ad7fa6b25..34243dc44ef1 100644
--- a/arch/cris/include/asm/barrier.h
+++ b/arch/cris/include/asm/barrier.h
@@ -22,4 +22,17 @@
 #define smp_read_barrier_depends()     do { } while(0)
 #endif
 
+#define smp_store_release(p, v)						\
+do {									\
+	smp_mb();							\
+	ACCESS_ONCE(p) = (v);						\
+} while (0)
+
+#define smp_load_acquire(p, v)						\
+do {									\
+	typeof(p) ___p1 = ACCESS_ONCE(p);				\
+	smp_mb();							\
+	return ___p1;							\
+} while (0)
+
 #endif /* __ASM_CRIS_BARRIER_H */
diff --git a/arch/frv/include/asm/barrier.h b/arch/frv/include/asm/barrier.h
index 06776ad9f5e9..92f89934d4ed 100644
--- a/arch/frv/include/asm/barrier.h
+++ b/arch/frv/include/asm/barrier.h
@@ -26,4 +26,17 @@
 #define set_mb(var, value) \
 	do { var = (value); barrier(); } while (0)
 
+#define smp_store_release(p, v)						\
+do {									\
+	smp_mb();							\
+	ACCESS_ONCE(p) = (v);						\
+} while (0)
+
+#define smp_load_acquire(p, v)						\
+do {									\
+	typeof(p) ___p1 = ACCESS_ONCE(p);				\
+	smp_mb();							\
+	return ___p1;							\
+} while (0)
+
 #endif /* _ASM_BARRIER_H */
diff --git a/arch/h8300/include/asm/barrier.h b/arch/h8300/include/asm/barrier.h
index 9e0aa9fc195d..516e9d379e25 100644
--- a/arch/h8300/include/asm/barrier.h
+++ b/arch/h8300/include/asm/barrier.h
@@ -26,4 +26,17 @@
 #define smp_read_barrier_depends()	do { } while(0)
 #endif
 
+#define smp_store_release(p, v)						\
+do {									\
+	smp_mb();							\
+	ACCESS_ONCE(p) = (v);						\
+} while (0)
+
+#define smp_load_acquire(p, v)						\
+do {									\
+	typeof(p) ___p1 = ACCESS_ONCE(p);				\
+	smp_mb();							\
+	return ___p1;							\
+} while (0)
+
 #endif /* _H8300_BARRIER_H */
diff --git a/arch/hexagon/include/asm/barrier.h b/arch/hexagon/include/asm/barrier.h
index 1041a8e70ce8..838a2ebe07a5 100644
--- a/arch/hexagon/include/asm/barrier.h
+++ b/arch/hexagon/include/asm/barrier.h
@@ -38,4 +38,17 @@
 #define set_mb(var, value) \
 	do { var = value; mb(); } while (0)
 
+#define smp_store_release(p, v)						\
+do {									\
+	smp_mb();							\
+	ACCESS_ONCE(p) = (v);						\
+} while (0)
+
+#define smp_load_acquire(p, v)						\
+do {									\
+	typeof(p) ___p1 = ACCESS_ONCE(p);				\
+	smp_mb();							\
+	return ___p1;							\
+} while (0)
+
 #endif /* _ASM_BARRIER_H */
diff --git a/arch/ia64/include/asm/barrier.h b/arch/ia64/include/asm/barrier.h
index 60576e06b6fb..4598d390fabb 100644
--- a/arch/ia64/include/asm/barrier.h
+++ b/arch/ia64/include/asm/barrier.h
@@ -45,11 +45,54 @@
 # define smp_rmb()	rmb()
 # define smp_wmb()	wmb()
 # define smp_read_barrier_depends()	read_barrier_depends()
+
+#define smp_store_release(p, v)						\
+do {									\
+	switch (sizeof(p)) {						\
+	case 4:								\
+		asm volatile ("st4.acq [%0]=%1" 			\
+				:: "r" (&p), "r" (v) : "memory");	\
+		break;							\
+	case 8:								\
+		asm volatile ("st8.acq [%0]=%1" 			\
+				:: "r" (&p), "r" (v) : "memory"); 	\
+		break;							\
+	}								\
+} while (0)
+
+#define smp_load_acquire(p, v)						\
+do {									\
+	typeof(p) ___p1;						\
+	switch (sizeof(p)) {						\
+	case 4:								\
+		asm volatile ("ld4.rel %0=[%1]" 			\
+				: "=r"(___p1) : "r" (&p) : "memory"); 	\
+		break;							\
+	case 8:								\
+		asm volatile ("ld8.rel %0=[%1]" 			\
+				: "=r"(___p1) : "r" (&p) : "memory"); 	\
+		break;							\
+	}								\
+	return ___p1;							\
+} while (0)
 #else
 # define smp_mb()	barrier()
 # define smp_rmb()	barrier()
 # define smp_wmb()	barrier()
 # define smp_read_barrier_depends()	do { } while(0)
+
+#define smp_store_release(p, v)						\
+do {									\
+	smp_mb();							\
+	ACCESS_ONCE(p) = (v);						\
+} while (0)
+
+#define smp_load_acquire(p, v)						\
+do {									\
+	typeof(p) ___p1 = ACCESS_ONCE(p);				\
+	smp_mb();							\
+	return ___p1;							\
+} while (0)
 #endif
 
 /*
diff --git a/arch/m32r/include/asm/barrier.h b/arch/m32r/include/asm/barrier.h
index 6976621efd3f..e5d42bcf90c5 100644
--- a/arch/m32r/include/asm/barrier.h
+++ b/arch/m32r/include/asm/barrier.h
@@ -91,4 +91,17 @@
 #define set_mb(var, value) do { var = value; barrier(); } while (0)
 #endif
 
+#define smp_store_release(p, v)						\
+do {									\
+	smp_mb();							\
+	ACCESS_ONCE(p) = (v);						\
+} while (0)
+
+#define smp_load_acquire(p, v)						\
+do {									\
+	typeof(p) ___p1 = ACCESS_ONCE(p);				\
+	smp_mb();							\
+	return ___p1;							\
+} while (0)
+
 #endif /* _ASM_M32R_BARRIER_H */
diff --git a/arch/m68k/include/asm/barrier.h b/arch/m68k/include/asm/barrier.h
index 445ce22c23cb..eeb9ecf713cc 100644
--- a/arch/m68k/include/asm/barrier.h
+++ b/arch/m68k/include/asm/barrier.h
@@ -17,4 +17,17 @@
 #define smp_wmb()	barrier()
 #define smp_read_barrier_depends()	((void)0)
 
+#define smp_store_release(p, v)						\
+do {									\
+	smp_mb();							\
+	ACCESS_ONCE(p) = (v);						\
+} while (0)
+
+#define smp_load_acquire(p, v)						\
+do {									\
+	typeof(p) ___p1 = ACCESS_ONCE(p);				\
+	smp_mb();							\
+	return ___p1;							\
+} while (0)
+
 #endif /* _M68K_BARRIER_H */
diff --git a/arch/metag/include/asm/barrier.h b/arch/metag/include/asm/barrier.h
index c90bfc6bf648..d8e6f2e4a27c 100644
--- a/arch/metag/include/asm/barrier.h
+++ b/arch/metag/include/asm/barrier.h
@@ -82,4 +82,17 @@ static inline void fence(void)
 #define smp_read_barrier_depends()     do { } while (0)
 #define set_mb(var, value) do { var = value; smp_mb(); } while (0)
 
+#define smp_store_release(p, v)						\
+do {									\
+	smp_mb();							\
+	ACCESS_ONCE(p) = (v);						\
+} while (0)
+
+#define smp_load_acquire(p, v)						\
+do {									\
+	typeof(p) ___p1 = ACCESS_ONCE(p);				\
+	smp_mb();							\
+	return ___p1;							\
+} while (0)
+
 #endif /* _ASM_METAG_BARRIER_H */
diff --git a/arch/microblaze/include/asm/barrier.h b/arch/microblaze/include/asm/barrier.h
index df5be3e87044..a890702061c9 100644
--- a/arch/microblaze/include/asm/barrier.h
+++ b/arch/microblaze/include/asm/barrier.h
@@ -24,4 +24,17 @@
 #define smp_rmb()		rmb()
 #define smp_wmb()		wmb()
 
+#define smp_store_release(p, v)						\
+do {									\
+	smp_mb();							\
+	ACCESS_ONCE(p) = (v);						\
+} while (0)
+
+#define smp_load_acquire(p, v)						\
+do {									\
+	typeof(p) ___p1 = ACCESS_ONCE(p);				\
+	smp_mb();							\
+	return ___p1;							\
+} while (0)
+
 #endif /* _ASM_MICROBLAZE_BARRIER_H */
diff --git a/arch/mips/include/asm/barrier.h b/arch/mips/include/asm/barrier.h
index 314ab5532019..e59bcd051f36 100644
--- a/arch/mips/include/asm/barrier.h
+++ b/arch/mips/include/asm/barrier.h
@@ -180,4 +180,17 @@
 #define nudge_writes() mb()
 #endif
 
+#define smp_store_release(p, v)						\
+do {									\
+	smp_mb();							\
+	ACCESS_ONCE(p) = (v);						\
+} while (0)
+
+#define smp_load_acquire(p, v)						\
+do {									\
+	typeof(p) ___p1 = ACCESS_ONCE(p);				\
+	smp_mb();							\
+	return ___p1;							\
+} while (0)
+
 #endif /* __ASM_BARRIER_H */
diff --git a/arch/mn10300/include/asm/barrier.h b/arch/mn10300/include/asm/barrier.h
index 2bd97a5c8af7..0e6a0608d4a1 100644
--- a/arch/mn10300/include/asm/barrier.h
+++ b/arch/mn10300/include/asm/barrier.h
@@ -34,4 +34,17 @@
 #define read_barrier_depends()		do {} while (0)
 #define smp_read_barrier_depends()	do {} while (0)
 
+#define smp_store_release(p, v)						\
+do {									\
+	smp_mb();							\
+	ACCESS_ONCE(p) = (v);						\
+} while (0)
+
+#define smp_load_acquire(p, v)						\
+do {									\
+	typeof(p) ___p1 = ACCESS_ONCE(p);				\
+	smp_mb();							\
+	return ___p1;							\
+} while (0)
+
 #endif /* _ASM_BARRIER_H */
diff --git a/arch/parisc/include/asm/barrier.h b/arch/parisc/include/asm/barrier.h
index e77d834aa803..f1145a8594a0 100644
--- a/arch/parisc/include/asm/barrier.h
+++ b/arch/parisc/include/asm/barrier.h
@@ -32,4 +32,17 @@
 
 #define set_mb(var, value)		do { var = value; mb(); } while (0)
 
+#define smp_store_release(p, v)						\
+do {									\
+	smp_mb();							\
+	ACCESS_ONCE(p) = (v);						\
+} while (0)
+
+#define smp_load_acquire(p, v)						\
+do {									\
+	typeof(p) ___p1 = ACCESS_ONCE(p);				\
+	smp_mb();							\
+	return ___p1;							\
+} while (0)
+
 #endif /* __PARISC_BARRIER_H */
diff --git a/arch/powerpc/include/asm/barrier.h b/arch/powerpc/include/asm/barrier.h
index ae782254e731..b5cc36791f42 100644
--- a/arch/powerpc/include/asm/barrier.h
+++ b/arch/powerpc/include/asm/barrier.h
@@ -65,4 +65,19 @@
 #define data_barrier(x)	\
 	asm volatile("twi 0,%0,0; isync" : : "r" (x) : "memory");
 
+/* use smp_rmb() as that is either lwsync or a barrier() depending on SMP */
+
+#define smp_store_release(p, v)						\
+do {									\
+	smp_rmb();							\
+	ACCESS_ONCE(p) = (v);						\
+} while (0)
+
+#define smp_load_acquire(p, v)						\
+do {									\
+	typeof(p) ___p1 = ACCESS_ONCE(p);				\
+	smp_rmb();							\
+	return ___p1;							\
+} while (0)
+
 #endif /* _ASM_POWERPC_BARRIER_H */
diff --git a/arch/s390/include/asm/barrier.h b/arch/s390/include/asm/barrier.h
index 16760eeb79b0..e8989c40e11c 100644
--- a/arch/s390/include/asm/barrier.h
+++ b/arch/s390/include/asm/barrier.h
@@ -32,4 +32,17 @@
 
 #define set_mb(var, value)		do { var = value; mb(); } while (0)
 
+#define smp_store_release(p, v)						\
+do {									\
+	barrier();							\
+	ACCESS_ONCE(p) = (v);						\
+} while (0)
+
+#define smp_load_acquire(p, v)						\
+do {									\
+	typeof(p) ___p1 = ACCESS_ONCE(p);				\
+	barrier();							\
+	return ___p1;							\
+} while (0)
+
 #endif /* __ASM_BARRIER_H */
diff --git a/arch/score/include/asm/barrier.h b/arch/score/include/asm/barrier.h
index 0eacb6471e6d..5f101ef8ade9 100644
--- a/arch/score/include/asm/barrier.h
+++ b/arch/score/include/asm/barrier.h
@@ -13,4 +13,17 @@
 
 #define set_mb(var, value) 		do {var = value; wmb(); } while (0)
 
+#define smp_store_release(p, v)						\
+do {									\
+	smp_mb();							\
+	ACCESS_ONCE(p) = (v);						\
+} while (0)
+
+#define smp_load_acquire(p, v)						\
+do {									\
+	typeof(p) ___p1 = ACCESS_ONCE(p);				\
+	smp_mb();							\
+	return ___p1;							\
+} while (0)
+
 #endif /* _ASM_SCORE_BARRIER_H */
diff --git a/arch/sh/include/asm/barrier.h b/arch/sh/include/asm/barrier.h
index 72c103dae300..611128c2f636 100644
--- a/arch/sh/include/asm/barrier.h
+++ b/arch/sh/include/asm/barrier.h
@@ -51,4 +51,17 @@
 
 #define set_mb(var, value) do { (void)xchg(&var, value); } while (0)
 
+#define smp_store_release(p, v)						\
+do {									\
+	smp_mb();							\
+	ACCESS_ONCE(p) = (v);						\
+} while (0)
+
+#define smp_load_acquire(p, v)						\
+do {									\
+	typeof(p) ___p1 = ACCESS_ONCE(p);				\
+	smp_mb();							\
+	return ___p1;							\
+} while (0)
+
 #endif /* __ASM_SH_BARRIER_H */
diff --git a/arch/sparc/include/asm/barrier_32.h b/arch/sparc/include/asm/barrier_32.h
index c1b76654ee76..f47f9d51f326 100644
--- a/arch/sparc/include/asm/barrier_32.h
+++ b/arch/sparc/include/asm/barrier_32.h
@@ -12,4 +12,17 @@
 #define smp_wmb()	__asm__ __volatile__("":::"memory")
 #define smp_read_barrier_depends()	do { } while(0)
 
+#define smp_store_release(p, v)						\
+do {									\
+	smp_mb();							\
+	ACCESS_ONCE(p) = (v);						\
+} while (0)
+
+#define smp_load_acquire(p, v)						\
+do {									\
+	typeof(p) ___p1 = ACCESS_ONCE(p);				\
+	smp_mb();							\
+	return ___p1;							\
+} while (0)
+
 #endif /* !(__SPARC_BARRIER_H) */
diff --git a/arch/sparc/include/asm/barrier_64.h b/arch/sparc/include/asm/barrier_64.h
index 95d45986f908..77cbe6982ca0 100644
--- a/arch/sparc/include/asm/barrier_64.h
+++ b/arch/sparc/include/asm/barrier_64.h
@@ -53,4 +53,17 @@ do {	__asm__ __volatile__("ba,pt	%%xcc, 1f\n\t" \
 
 #define smp_read_barrier_depends()	do { } while(0)
 
+#define smp_store_release(p, v)						\
+do {									\
+	barrier();							\
+	ACCESS_ONCE(p) = (v);						\
+} while (0)
+
+#define smp_load_acquire(p, v)						\
+do {									\
+	typeof(p) ___p1 = ACCESS_ONCE(p);				\
+	barrier();							\
+	return ___p1;							\
+} while (0)
+
 #endif /* !(__SPARC64_BARRIER_H) */
diff --git a/arch/tile/include/asm/barrier.h b/arch/tile/include/asm/barrier.h
index a9a73da5865d..4d5330d4fd31 100644
--- a/arch/tile/include/asm/barrier.h
+++ b/arch/tile/include/asm/barrier.h
@@ -140,5 +140,18 @@ mb_incoherent(void)
 #define set_mb(var, value) \
 	do { var = value; mb(); } while (0)
 
+#define smp_store_release(p, v)						\
+do {									\
+	smp_mb();							\
+	ACCESS_ONCE(p) = (v);						\
+} while (0)
+
+#define smp_load_acquire(p, v)						\
+do {									\
+	typeof(p) ___p1 = ACCESS_ONCE(p);				\
+	smp_mb();							\
+	return ___p1;							\
+} while (0)
+
 #endif /* !__ASSEMBLY__ */
 #endif /* _ASM_TILE_BARRIER_H */
diff --git a/arch/unicore32/include/asm/barrier.h b/arch/unicore32/include/asm/barrier.h
index a6620e5336b6..5471ff6aae10 100644
--- a/arch/unicore32/include/asm/barrier.h
+++ b/arch/unicore32/include/asm/barrier.h
@@ -25,4 +25,17 @@
 
 #define set_mb(var, value)		do { var = value; smp_mb(); } while (0)
 
+#define smp_store_release(p, v)						\
+do {									\
+	smp_mb();							\
+	ACCESS_ONCE(p) = (v);						\
+} while (0)
+
+#define smp_load_acquire(p, v)						\
+do {									\
+	typeof(p) ___p1 = ACCESS_ONCE(p);				\
+	smp_mb();							\
+	return ___p1;							\
+} while (0)
+
 #endif /* __UNICORE_BARRIER_H__ */
diff --git a/arch/x86/include/asm/barrier.h b/arch/x86/include/asm/barrier.h
index c6cd358a1eec..a7fd8201ab09 100644
--- a/arch/x86/include/asm/barrier.h
+++ b/arch/x86/include/asm/barrier.h
@@ -100,6 +100,19 @@
 #define set_mb(var, value) do { var = value; barrier(); } while (0)
 #endif
 
+#define smp_store_release(p, v)						\
+do {									\
+	barrier();							\
+	ACCESS_ONCE(p) = (v);						\
+} while (0)
+
+#define smp_load_acquire(p, v)						\
+do {									\
+	typeof(p) ___p1 = ACCESS_ONCE(p);				\
+	barrier();							\
+	return ___p1;							\
+} while (0)
+
 /*
  * Stop RDTSC speculation. This is needed when you need to use RDTSC
  * (or get_cycles or vread that possibly accesses the TSC) in a defined
diff --git a/arch/xtensa/include/asm/barrier.h b/arch/xtensa/include/asm/barrier.h
index ef021677d536..703d511add49 100644
--- a/arch/xtensa/include/asm/barrier.h
+++ b/arch/xtensa/include/asm/barrier.h
@@ -26,4 +26,17 @@
 
 #define set_mb(var, value)	do { var = value; mb(); } while (0)
 
+#define smp_store_release(p, v)						\
+do {									\
+	smp_mb();							\
+	ACCESS_ONCE(p) = (v);						\
+} while (0)
+
+#define smp_load_acquire(p, v)						\
+do {									\
+	typeof(p) ___p1 = ACCESS_ONCE(p);				\
+	smp_mb();							\
+	return ___p1;							\
+} while (0)
+
 #endif /* _XTENSA_SYSTEM_H */
