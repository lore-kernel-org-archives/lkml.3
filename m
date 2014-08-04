Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752176AbaHDLzr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Aug 2014 07:55:47 -0400
Received: from mail-wi0-f174.google.com ([209.85.212.174]:52564 "EHLO
	mail-wi0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751181AbaHDLzq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Aug 2014 07:55:46 -0400
Date: Mon, 4 Aug 2014 13:55:40 +0200
From: Ingo Molnar <mingo@kernel.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, "H. Peter Anvin" <hpa@zytor.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [GIT PULL] x86/cleanups for v3.17
Message-ID: <20140804115540.GA25890@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

Please pull the latest x86-cleanups-for-linus git tree from:

   git://git.kernel.org/pub/scm/linux/kernel/git/tip/tip.git x86-cleanups-for-linus

   # HEAD: b08ee5f7e4135d64b8edd769367f8964a725122e x86: Simplify __HAVE_ARCH_CMPXCHG tests

Two cleanups.

 Thanks,

	Ingo

------------------>
Borislav Petkov (1):
      x86: Simplify __HAVE_ARCH_CMPXCHG tests

Michal Nazarewicz (1):
      x86/tsc: Get rid of custom DIV_ROUND() macro


 arch/x86/include/asm/cmpxchg.h     |  4 ++--
 arch/x86/include/asm/cmpxchg_32.h  |  2 --
 arch/x86/include/asm/cmpxchg_64.h  |  2 --
 arch/x86/include/asm/mc146818rtc.h |  2 +-
 arch/x86/include/asm/mutex_32.h    | 16 ++--------------
 arch/x86/kernel/acpi/boot.c        |  4 ----
 arch/x86/kernel/tsc.c              |  7 +++----
 7 files changed, 8 insertions(+), 29 deletions(-)

diff --git a/arch/x86/include/asm/cmpxchg.h b/arch/x86/include/asm/cmpxchg.h
index d47786a..99c105d7 100644
--- a/arch/x86/include/asm/cmpxchg.h
+++ b/arch/x86/include/asm/cmpxchg.h
@@ -4,6 +4,8 @@
 #include <linux/compiler.h>
 #include <asm/alternative.h> /* Provides LOCK_PREFIX */
 
+#define __HAVE_ARCH_CMPXCHG 1
+
 /*
  * Non-existant functions to indicate usage errors at link time
  * (or compile-time if the compiler implements __compiletime_error().
@@ -143,7 +145,6 @@ extern void __add_wrong_size(void)
 # include <asm/cmpxchg_64.h>
 #endif
 
-#ifdef __HAVE_ARCH_CMPXCHG
 #define cmpxchg(ptr, old, new)						\
 	__cmpxchg(ptr, old, new, sizeof(*(ptr)))
 
@@ -152,7 +153,6 @@ extern void __add_wrong_size(void)
 
 #define cmpxchg_local(ptr, old, new)					\
 	__cmpxchg_local(ptr, old, new, sizeof(*(ptr)))
-#endif
 
 /*
  * xadd() adds "inc" to "*ptr" and atomically returns the previous
diff --git a/arch/x86/include/asm/cmpxchg_32.h b/arch/x86/include/asm/cmpxchg_32.h
index f8bf2ee..f7e1429 100644
--- a/arch/x86/include/asm/cmpxchg_32.h
+++ b/arch/x86/include/asm/cmpxchg_32.h
@@ -34,8 +34,6 @@ static inline void set_64bit(volatile u64 *ptr, u64 value)
 		     : "memory");
 }
 
-#define __HAVE_ARCH_CMPXCHG 1
-
 #ifdef CONFIG_X86_CMPXCHG64
 #define cmpxchg64(ptr, o, n)						\
 	((__typeof__(*(ptr)))__cmpxchg64((ptr), (unsigned long long)(o), \
diff --git a/arch/x86/include/asm/cmpxchg_64.h b/arch/x86/include/asm/cmpxchg_64.h
index 614be87..1af9469 100644
--- a/arch/x86/include/asm/cmpxchg_64.h
+++ b/arch/x86/include/asm/cmpxchg_64.h
@@ -6,8 +6,6 @@ static inline void set_64bit(volatile u64 *ptr, u64 val)
 	*ptr = val;
 }
 
-#define __HAVE_ARCH_CMPXCHG 1
-
 #define cmpxchg64(ptr, o, n)						\
 ({									\
 	BUILD_BUG_ON(sizeof(*(ptr)) != 8);				\
diff --git a/arch/x86/include/asm/mc146818rtc.h b/arch/x86/include/asm/mc146818rtc.h
index a55c7ef..0f555cc 100644
--- a/arch/x86/include/asm/mc146818rtc.h
+++ b/arch/x86/include/asm/mc146818rtc.h
@@ -13,7 +13,7 @@
 #define RTC_ALWAYS_BCD	1	/* RTC operates in binary mode */
 #endif
 
-#if defined(CONFIG_X86_32) && defined(__HAVE_ARCH_CMPXCHG)
+#if defined(CONFIG_X86_32)
 /*
  * This lock provides nmi access to the CMOS/RTC registers.  It has some
  * special properties.  It is owned by a CPU and stores the index register
diff --git a/arch/x86/include/asm/mutex_32.h b/arch/x86/include/asm/mutex_32.h
index 0208c3c..85e6cda 100644
--- a/arch/x86/include/asm/mutex_32.h
+++ b/arch/x86/include/asm/mutex_32.h
@@ -100,23 +100,11 @@ do {								\
 static inline int __mutex_fastpath_trylock(atomic_t *count,
 					   int (*fail_fn)(atomic_t *))
 {
-	/*
-	 * We have two variants here. The cmpxchg based one is the best one
-	 * because it never induce a false contention state.  It is included
-	 * here because architectures using the inc/dec algorithms over the
-	 * xchg ones are much more likely to support cmpxchg natively.
-	 *
-	 * If not we fall back to the spinlock based variant - that is
-	 * just as efficient (and simpler) as a 'destructive' probing of
-	 * the mutex state would be.
-	 */
-#ifdef __HAVE_ARCH_CMPXCHG
+	/* cmpxchg because it never induces a false contention state. */
 	if (likely(atomic_cmpxchg(count, 1, 0) == 1))
 		return 1;
+
 	return 0;
-#else
-	return fail_fn(count);
-#endif
 }
 
 #endif /* _ASM_X86_MUTEX_32_H */
diff --git a/arch/x86/kernel/acpi/boot.c b/arch/x86/kernel/acpi/boot.c
index 86281ff..a531f65 100644
--- a/arch/x86/kernel/acpi/boot.c
+++ b/arch/x86/kernel/acpi/boot.c
@@ -74,10 +74,6 @@ int acpi_fix_pin2_polarity __initdata;
 static u64 acpi_lapic_addr __initdata = APIC_DEFAULT_PHYS_BASE;
 #endif
 
-#ifndef __HAVE_ARCH_CMPXCHG
-#warning ACPI uses CMPXCHG, i486 and later hardware
-#endif
-
 /* --------------------------------------------------------------------------
                               Boot-time Configuration
    -------------------------------------------------------------------------- */
diff --git a/arch/x86/kernel/tsc.c b/arch/x86/kernel/tsc.c
index 57e5ce1..8764232 100644
--- a/arch/x86/kernel/tsc.c
+++ b/arch/x86/kernel/tsc.c
@@ -234,9 +234,6 @@ static inline unsigned long long cycles_2_ns(unsigned long long cyc)
 	return ns;
 }
 
-/* XXX surely we already have this someplace in the kernel?! */
-#define DIV_ROUND(n, d) (((n) + ((d) / 2)) / (d))
-
 static void set_cyc2ns_scale(unsigned long cpu_khz, int cpu)
 {
 	unsigned long long tsc_now, ns_now;
@@ -259,7 +256,9 @@ static void set_cyc2ns_scale(unsigned long cpu_khz, int cpu)
 	 * time function is continuous; see the comment near struct
 	 * cyc2ns_data.
 	 */
-	data->cyc2ns_mul = DIV_ROUND(NSEC_PER_MSEC << CYC2NS_SCALE_FACTOR, cpu_khz);
+	data->cyc2ns_mul =
+		DIV_ROUND_CLOSEST(NSEC_PER_MSEC << CYC2NS_SCALE_FACTOR,
+				  cpu_khz);
 	data->cyc2ns_shift = CYC2NS_SCALE_FACTOR;
 	data->cyc2ns_offset = ns_now -
 		mul_u64_u32_shr(tsc_now, data->cyc2ns_mul, CYC2NS_SCALE_FACTOR);
