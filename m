Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756559AbaAHSBX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Jan 2014 13:01:23 -0500
Received: from smtp.citrix.com ([66.165.176.89]:30261 "EHLO SMTP.CITRIX.COM"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750793AbaAHSBU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Jan 2014 13:01:20 -0500
X-IronPort-AV: E=Sophos;i="4.95,625,1384300800"; 
   d="scan'208";a="90980126"
From: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
To: <linux@arm.linux.org.uk>
CC: <stefano.stabellini@eu.citrix.com>, <arnd@arndb.de>, <will.deacon@arm.com>,
        <gang.chen@asianux.com>, <catalin.marinas@arm.com>,
        <jaccon.bastiaansen@gmail.com>, <linux-arm-kernel@lists.infradead.org>,
        <linux-kernel@vger.kernel.org>
Subject: [PATCH v3] arm: remove !CPU_V6 and !GENERIC_ATOMIC64 build dependencies for XEN
Date: Wed, 8 Jan 2014 18:00:23 +0000
Message-ID: <1389204023-26912-1-git-send-email-stefano.stabellini@eu.citrix.com>
X-Mailer: git-send-email 1.7.9.5
MIME-Version: 1.0
Content-Type: text/plain
X-DLP: MIA2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Remove !GENERIC_ATOMIC64 build dependency:
- rename atomic64_xchg to armv7_atomic64_xchg and define it even ifdef
  GENERIC_ATOMIC64;
- call armv7_atomic64_xchg directly from xen/events.h.

Remove !CPU_V6 build dependency:
- introduce __cmpxchg8 and __cmpxchg16, compiled even ifdef
  CONFIG_CPU_V6;
- implement sync_cmpxchg using __cmpxchg8 and __cmpxchg16.

Signed-off-by: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
CC: arnd@arndb.de
CC: linux@arm.linux.org.uk
CC: will.deacon@arm.com
CC: gang.chen@asianux.com
CC: catalin.marinas@arm.com
CC: jaccon.bastiaansen@gmail.com
CC: linux-arm-kernel@lists.infradead.org
CC: linux-kernel@vger.kernel.org


---

Changes in v3:
- rebase.

Changes in v2:
- handle return value of __cmpxchg8 and __cmpxchg16 in __cmpxchg;
- remove sync_cmpxchg to sync_cmpxchg16 rename in grant-table.c,
  implement a generic sync_cmpxchg instead.
---
 arch/arm/Kconfig                   |    3 +-
 arch/arm/include/asm/atomic.h      |   47 +++++++++++++++-------------
 arch/arm/include/asm/cmpxchg.h     |   60 ++++++++++++++++++++++++------------
 arch/arm/include/asm/sync_bitops.h |   24 ++++++++++++++-
 arch/arm/include/asm/xen/events.h  |    2 +-
 5 files changed, 91 insertions(+), 45 deletions(-)

diff --git a/arch/arm/Kconfig b/arch/arm/Kconfig
index c1f1a7e..ae54ae0 100644
--- a/arch/arm/Kconfig
+++ b/arch/arm/Kconfig
@@ -1881,8 +1881,7 @@ config XEN_DOM0
 config XEN
 	bool "Xen guest support on ARM (EXPERIMENTAL)"
 	depends on ARM && AEABI && OF
-	depends on CPU_V7 && !CPU_V6
-	depends on !GENERIC_ATOMIC64
+	depends on CPU_V7
 	select ARM_PSCI
 	select SWIOTLB_XEN
 	help
diff --git a/arch/arm/include/asm/atomic.h b/arch/arm/include/asm/atomic.h
index 62d2cb5..dfe1cd6 100644
--- a/arch/arm/include/asm/atomic.h
+++ b/arch/arm/include/asm/atomic.h
@@ -382,26 +382,7 @@ static inline long long atomic64_cmpxchg(atomic64_t *ptr, long long old,
 	return oldval;
 }
 
-static inline long long atomic64_xchg(atomic64_t *ptr, long long new)
-{
-	long long result;
-	unsigned long tmp;
-
-	smp_mb();
-
-	__asm__ __volatile__("@ atomic64_xchg\n"
-"1:	ldrexd	%0, %H0, [%3]\n"
-"	strexd	%1, %4, %H4, [%3]\n"
-"	teq	%1, #0\n"
-"	bne	1b"
-	: "=&r" (result), "=&r" (tmp), "+Qo" (ptr->counter)
-	: "r" (&ptr->counter), "r" (new)
-	: "cc");
-
-	smp_mb();
-
-	return result;
-}
+#define armv7_atomic64_xchg atomic64_xchg
 
 static inline long long atomic64_dec_if_positive(atomic64_t *v)
 {
@@ -469,6 +450,30 @@ static inline int atomic64_add_unless(atomic64_t *v, long long a, long long u)
 #define atomic64_dec_and_test(v)	(atomic64_dec_return((v)) == 0)
 #define atomic64_inc_not_zero(v)	atomic64_add_unless((v), 1LL, 0LL)
 
-#endif /* !CONFIG_GENERIC_ATOMIC64 */
+#else /* !CONFIG_GENERIC_ATOMIC64 */
+#include <asm-generic/atomic64.h>
+#endif
+
+static inline u64 armv7_atomic64_xchg(atomic64_t *ptr, u64 new)
+{
+	long long result;
+	unsigned long tmp;
+
+	smp_mb();
+
+	__asm__ __volatile__("@ armv7_atomic64_xchg\n"
+"1:	ldrexd	%0, %H0, [%3]\n"
+"	strexd	%1, %4, %H4, [%3]\n"
+"	teq	%1, #0\n"
+"	bne	1b"
+	: "=&r" (result), "=&r" (tmp), "+Qo" (ptr->counter)
+	: "r" (&ptr->counter), "r" (new)
+	: "cc");
+
+	smp_mb();
+
+	return result;
+}
+
 #endif
 #endif
diff --git a/arch/arm/include/asm/cmpxchg.h b/arch/arm/include/asm/cmpxchg.h
index df2fbba..cc8a4a2 100644
--- a/arch/arm/include/asm/cmpxchg.h
+++ b/arch/arm/include/asm/cmpxchg.h
@@ -133,6 +133,44 @@ extern void __bad_cmpxchg(volatile void *ptr, int size);
  * cmpxchg only support 32-bits operands on ARMv6.
  */
 
+static inline unsigned long __cmpxchg8(volatile void *ptr, unsigned long old,
+				      unsigned long new)
+{
+	unsigned long oldval, res;
+
+	do {
+		asm volatile("@ __cmpxchg1\n"
+		"	ldrexb	%1, [%2]\n"
+		"	mov	%0, #0\n"
+		"	teq	%1, %3\n"
+		"	strexbeq %0, %4, [%2]\n"
+			: "=&r" (res), "=&r" (oldval)
+			: "r" (ptr), "Ir" (old), "r" (new)
+			: "memory", "cc");
+	} while (res);
+
+	return oldval;
+}
+
+static inline unsigned long __cmpxchg16(volatile void *ptr, unsigned long old,
+				      unsigned long new)
+{
+	unsigned long oldval, res;
+
+	do {
+		asm volatile("@ __cmpxchg1\n"
+		"	ldrexh	%1, [%2]\n"
+		"	mov	%0, #0\n"
+		"	teq	%1, %3\n"
+		"	strexheq %0, %4, [%2]\n"
+			: "=&r" (res), "=&r" (oldval)
+			: "r" (ptr), "Ir" (old), "r" (new)
+			: "memory", "cc");
+	} while (res);
+
+	return oldval;
+}
+
 static inline unsigned long __cmpxchg(volatile void *ptr, unsigned long old,
 				      unsigned long new, int size)
 {
@@ -141,28 +179,10 @@ static inline unsigned long __cmpxchg(volatile void *ptr, unsigned long old,
 	switch (size) {
 #ifndef CONFIG_CPU_V6	/* min ARCH >= ARMv6K */
 	case 1:
-		do {
-			asm volatile("@ __cmpxchg1\n"
-			"	ldrexb	%1, [%2]\n"
-			"	mov	%0, #0\n"
-			"	teq	%1, %3\n"
-			"	strexbeq %0, %4, [%2]\n"
-				: "=&r" (res), "=&r" (oldval)
-				: "r" (ptr), "Ir" (old), "r" (new)
-				: "memory", "cc");
-		} while (res);
+		oldval = __cmpxchg8(ptr, old, new);
 		break;
 	case 2:
-		do {
-			asm volatile("@ __cmpxchg1\n"
-			"	ldrexh	%1, [%2]\n"
-			"	mov	%0, #0\n"
-			"	teq	%1, %3\n"
-			"	strexheq %0, %4, [%2]\n"
-				: "=&r" (res), "=&r" (oldval)
-				: "r" (ptr), "Ir" (old), "r" (new)
-				: "memory", "cc");
-		} while (res);
+		oldval = __cmpxchg16(ptr, old, new);
 		break;
 #endif
 	case 4:
diff --git a/arch/arm/include/asm/sync_bitops.h b/arch/arm/include/asm/sync_bitops.h
index 63479ee..942659a 100644
--- a/arch/arm/include/asm/sync_bitops.h
+++ b/arch/arm/include/asm/sync_bitops.h
@@ -21,7 +21,29 @@
 #define sync_test_and_clear_bit(nr, p)	_test_and_clear_bit(nr, p)
 #define sync_test_and_change_bit(nr, p)	_test_and_change_bit(nr, p)
 #define sync_test_bit(nr, addr)		test_bit(nr, addr)
-#define sync_cmpxchg			cmpxchg
 
+static inline unsigned long sync_cmpxchg(volatile void *ptr,
+										 unsigned long old,
+										 unsigned long new)
+{
+	unsigned long oldval;
+	int size = sizeof(*(ptr));
+
+	smp_mb();
+	switch (size) {
+	case 1:
+		oldval = __cmpxchg8(ptr, old, new);
+		break;
+	case 2:
+		oldval = __cmpxchg16(ptr, old, new);
+		break;
+	default:
+		oldval = __cmpxchg(ptr, old, new, size);
+		break;
+	}
+	smp_mb();
+
+	return oldval;
+}
 
 #endif
diff --git a/arch/arm/include/asm/xen/events.h b/arch/arm/include/asm/xen/events.h
index 8b1f37b..4269519 100644
--- a/arch/arm/include/asm/xen/events.h
+++ b/arch/arm/include/asm/xen/events.h
@@ -16,7 +16,7 @@ static inline int xen_irqs_disabled(struct pt_regs *regs)
 	return raw_irqs_disabled_flags(regs->ARM_cpsr);
 }
 
-#define xchg_xen_ulong(ptr, val) atomic64_xchg(container_of((ptr),	\
+#define xchg_xen_ulong(ptr, val) armv7_atomic64_xchg(container_of((ptr),	\
 							    atomic64_t,	\
 							    counter), (val))
 
-- 
1.7.10.4

