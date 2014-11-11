Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751523AbaKKS5J (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Nov 2014 13:57:09 -0500
Received: from mail-pd0-f182.google.com ([209.85.192.182]:49037 "EHLO
	mail-pd0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751164AbaKKS5H (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Nov 2014 13:57:07 -0500
Subject: [PATCH] arch: Introduce read_acquire()
To: linux-arch@vger.kernel.org, linux-kernel@vger.kernel.org
From: alexander.duyck@gmail.com
Cc: Michael Neuling <mikey@neuling.org>, Tony Luck <tony.luck@intel.com>,
        Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
        Alexander Duyck <alexander.h.duyck@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Heiko Carstens <heiko.carstens@de.ibm.com>,
        Oleg Nesterov <oleg@redhat.com>, Will Deacon <will.deacon@arm.com>,
        Michael Ellerman <michael@ellerman.id.au>,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Martin Schwidefsky <schwidefsky@de.ibm.com>,
        Russell King <linux@arm.linux.org.uk>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Ingo Molnar <mingo@kernel.org>
Date: Tue, 11 Nov 2014 10:57:05 -0800
Message-ID: <20141111185510.2181.75347.stgit@ahduyck-workstation.home>
User-Agent: StGit/0.16
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Alexander Duyck <alexander.h.duyck@redhat.com>

In the case of device drivers it is common to utilize receive descriptors
in which a single field is used to determine if the descriptor is currently
in the possession of the device or the CPU.  In order to prevent any other
fields from being read a rmb() is used resulting in something like code
snippet from ixgbe_main.c:

	if (!ixgbe_test_staterr(rx_desc, IXGBE_RXD_STAT_DD))
		break;

	/*
	 * This memory barrier is needed to keep us from reading
	 * any other fields out of the rx_desc until we know the
	 * RXD_STAT_DD bit is set
	 */
	rmb();

On reviewing the documentation and code for smp_load_acquire() it occured
to me that implementing something similar for CPU <-> device interraction
would be worth while.  This commit provides just the load/read side of this
in the form of read_acquire().  This new primative orders the specified
read against any subsequent reads.  As a result we can reduce the above
code snippet down to:

	/* This memory barrier is needed to keep us from reading
	 * any other fields out of the rx_desc until we know the
	 * RXD_STAT_DD bit is set
	 */
	if (!(read_acquire(&rx_desc->wb.upper.status_error) &
	      cpu_to_le32(IXGBE_RXD_STAT_DD)))
		break;

With this commit and the above change I have seen a reduction in processing
time of at least 7ns per 64B frame in the ixgbe driver on an Intel
Core i7-4930K.

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
Cc: Tony Luck <tony.luck@intel.com>
Cc: Oleg Nesterov <oleg@redhat.com>
Cc: Will Deacon <will.deacon@arm.com>
Cc: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Ingo Molnar <mingo@kernel.org>
Signed-off-by: Alexander Duyck <alexander.h.duyck@redhat.com>
---
 arch/arm/include/asm/barrier.h      |    8 ++++++++
 arch/arm64/include/asm/barrier.h    |   10 ++++++++++
 arch/ia64/include/asm/barrier.h     |    2 ++
 arch/metag/include/asm/barrier.h    |    8 ++++++++
 arch/mips/include/asm/barrier.h     |    8 ++++++++
 arch/powerpc/include/asm/barrier.h  |    8 ++++++++
 arch/s390/include/asm/barrier.h     |    2 ++
 arch/sparc/include/asm/barrier_64.h |    1 +
 arch/x86/include/asm/barrier.h      |   10 ++++++++++
 include/asm-generic/barrier.h       |    8 ++++++++
 10 files changed, 65 insertions(+)

diff --git a/arch/arm/include/asm/barrier.h b/arch/arm/include/asm/barrier.h
index c6a3e73..b082578 100644
--- a/arch/arm/include/asm/barrier.h
+++ b/arch/arm/include/asm/barrier.h
@@ -59,6 +59,14 @@
 #define smp_wmb()	dmb(ishst)
 #endif
 
+#define read_acquire(p)							\
+({									\
+	typeof(*p) ___p1 = ACCESS_ONCE(*p);				\
+	compiletime_assert_atomic_type(*p);				\
+	rmb();								\
+	___p1;								\
+})
+
 #define smp_store_release(p, v)						\
 do {									\
 	compiletime_assert_atomic_type(*p);				\
diff --git a/arch/arm64/include/asm/barrier.h b/arch/arm64/include/asm/barrier.h
index 6389d60..5b0bfa7 100644
--- a/arch/arm64/include/asm/barrier.h
+++ b/arch/arm64/include/asm/barrier.h
@@ -52,6 +52,14 @@ do {									\
 	___p1;								\
 })
 
+#define read_acquire(p)							\
+({									\
+	typeof(*p) ___p1 = ACCESS_ONCE(*p);				\
+	compiletime_assert_atomic_type(*p);				\
+	rmb();								\
+	___p1;								\
+})
+
 #else
 
 #define smp_mb()	dmb(ish)
@@ -90,6 +98,8 @@ do {									\
 	___p1;								\
 })
 
+#define read_acquire(p)	smp_load_acquire(p)
+
 #endif
 
 #define read_barrier_depends()		do { } while(0)
diff --git a/arch/ia64/include/asm/barrier.h b/arch/ia64/include/asm/barrier.h
index a48957c..2288d09 100644
--- a/arch/ia64/include/asm/barrier.h
+++ b/arch/ia64/include/asm/barrier.h
@@ -78,6 +78,8 @@ do {									\
 	___p1;								\
 })
 
+#define read_acquire(p)	smp_load_acquire(p)
+
 /*
  * XXX check on this ---I suspect what Linus really wants here is
  * acquire vs release semantics but we can't discuss this stuff with
diff --git a/arch/metag/include/asm/barrier.h b/arch/metag/include/asm/barrier.h
index c7591e8..670b679 100644
--- a/arch/metag/include/asm/barrier.h
+++ b/arch/metag/include/asm/barrier.h
@@ -100,6 +100,14 @@ do {									\
 	___p1;								\
 })
 
+#define read_acquire(p)							\
+({									\
+	typeof(*p) ___p1 = ACCESS_ONCE(*p);				\
+	compiletime_assert_atomic_type(*p);				\
+	rmb();								\
+	___p1;								\
+})
+
 #define smp_mb__before_atomic()	barrier()
 #define smp_mb__after_atomic()	barrier()
 
diff --git a/arch/mips/include/asm/barrier.h b/arch/mips/include/asm/barrier.h
index d0101dd..aa5eb06 100644
--- a/arch/mips/include/asm/barrier.h
+++ b/arch/mips/include/asm/barrier.h
@@ -195,6 +195,14 @@ do {									\
 	___p1;								\
 })
 
+#define read_acquire(p)							\
+({									\
+	typeof(*p) ___p1 = ACCESS_ONCE(*p);				\
+	compiletime_assert_atomic_type(*p);				\
+	rmb();								\
+	___p1;								\
+})
+
 #define smp_mb__before_atomic()	smp_mb__before_llsc()
 #define smp_mb__after_atomic()	smp_llsc_mb()
 
diff --git a/arch/powerpc/include/asm/barrier.h b/arch/powerpc/include/asm/barrier.h
index bab79a1..3ddc884 100644
--- a/arch/powerpc/include/asm/barrier.h
+++ b/arch/powerpc/include/asm/barrier.h
@@ -84,6 +84,14 @@ do {									\
 	___p1;								\
 })
 
+#define read_acquire(p)							\
+({									\
+	typeof(*p) ___p1 = ACCESS_ONCE(*p);				\
+	compiletime_assert_atomic_type(*p);				\
+	rmb();							\
+	___p1;								\
+})
+
 #define smp_mb__before_atomic()     smp_mb()
 #define smp_mb__after_atomic()      smp_mb()
 
diff --git a/arch/s390/include/asm/barrier.h b/arch/s390/include/asm/barrier.h
index b5dce65..516ad04 100644
--- a/arch/s390/include/asm/barrier.h
+++ b/arch/s390/include/asm/barrier.h
@@ -50,4 +50,6 @@ do {									\
 	___p1;								\
 })
 
+#define read_acquire(p)			smp_load_acquire(p)
+
 #endif /* __ASM_BARRIER_H */
diff --git a/arch/sparc/include/asm/barrier_64.h b/arch/sparc/include/asm/barrier_64.h
index 305dcc3..c0ba305 100644
--- a/arch/sparc/include/asm/barrier_64.h
+++ b/arch/sparc/include/asm/barrier_64.h
@@ -68,6 +68,7 @@ do {									\
 	___p1;								\
 })
 
+#define read_acquire(p)		smp_load_acquire(p)
 #define smp_mb__before_atomic()	barrier()
 #define smp_mb__after_atomic()	barrier()
 
diff --git a/arch/x86/include/asm/barrier.h b/arch/x86/include/asm/barrier.h
index 0f4460b..6aa9641 100644
--- a/arch/x86/include/asm/barrier.h
+++ b/arch/x86/include/asm/barrier.h
@@ -118,6 +118,14 @@ do {									\
 	___p1;								\
 })
 
+#define read_acquire(p)							\
+({									\
+	typeof(*p) ___p1 = ACCESS_ONCE(*p);				\
+	compiletime_assert_atomic_type(*p);				\
+	rmb();								\
+	___p1;								\
+})
+
 #else /* regular x86 TSO memory ordering */
 
 #define smp_store_release(p, v)						\
@@ -135,6 +143,8 @@ do {									\
 	___p1;								\
 })
 
+#define read_acquire(p)	smp_load_acquire(p)
+
 #endif
 
 /* Atomic operations are already serializing on x86 */
diff --git a/include/asm-generic/barrier.h b/include/asm-generic/barrier.h
index 1402fa8..c186bfb 100644
--- a/include/asm-generic/barrier.h
+++ b/include/asm-generic/barrier.h
@@ -70,6 +70,14 @@
 #define smp_mb__after_atomic()	smp_mb()
 #endif
 
+#define read_acquire(p)							\
+({									\
+	typeof(*p) ___p1 = ACCESS_ONCE(*p);				\
+	compiletime_assert_atomic_type(*p);				\
+	rmb();								\
+	___p1;								\
+})
+
 #define smp_store_release(p, v)						\
 do {									\
 	compiletime_assert_atomic_type(*p);				\

