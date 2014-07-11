Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752689AbaGKJvy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jul 2014 05:51:54 -0400
Received: from mail.skyhub.de ([78.46.96.112]:55429 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751854AbaGKJvx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jul 2014 05:51:53 -0400
From: Borislav Petkov <bp@alien8.de>
To: Thomas Gleixner <tglx@linutronix.de>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: X86 ML <x86@kernel.org>, LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH] x86: Get rid of __HAVE_ARCH_CMPXCHG
Date: Fri, 11 Jul 2014 11:51:41 +0200
Message-Id: <1405072301-8719-1-git-send-email-bp@alien8.de>
X-Mailer: git-send-email 2.0.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Borislav Petkov <bp@suse.de>

Both the 32-bit and 64-bit cmpxchg.h header define __HAVE_ARCH_CMPXCHG
and there's ifdeffery which checks it. But since both bitness define it,
we can just as well drop it and simpify a bit of code in doing that.

Signed-off-by: Borislav Petkov <bp@suse.de>
---
 arch/x86/include/asm/cmpxchg.h     |  2 --
 arch/x86/include/asm/cmpxchg_32.h  |  2 --
 arch/x86/include/asm/cmpxchg_64.h  |  2 --
 arch/x86/include/asm/mc146818rtc.h |  2 +-
 arch/x86/include/asm/mutex_32.h    | 16 ++--------------
 arch/x86/kernel/acpi/boot.c        |  4 ----
 kernel/locking/rtmutex.c           |  2 +-
 7 files changed, 4 insertions(+), 26 deletions(-)

diff --git a/arch/x86/include/asm/cmpxchg.h b/arch/x86/include/asm/cmpxchg.h
index d47786acb016..ad19841eddfe 100644
--- a/arch/x86/include/asm/cmpxchg.h
+++ b/arch/x86/include/asm/cmpxchg.h
@@ -143,7 +143,6 @@ extern void __add_wrong_size(void)
 # include <asm/cmpxchg_64.h>
 #endif
 
-#ifdef __HAVE_ARCH_CMPXCHG
 #define cmpxchg(ptr, old, new)						\
 	__cmpxchg(ptr, old, new, sizeof(*(ptr)))
 
@@ -152,7 +151,6 @@ extern void __add_wrong_size(void)
 
 #define cmpxchg_local(ptr, old, new)					\
 	__cmpxchg_local(ptr, old, new, sizeof(*(ptr)))
-#endif
 
 /*
  * xadd() adds "inc" to "*ptr" and atomically returns the previous
diff --git a/arch/x86/include/asm/cmpxchg_32.h b/arch/x86/include/asm/cmpxchg_32.h
index f8bf2eecab86..f7e142926481 100644
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
index 614be87f1a9b..1af94697aae5 100644
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
index a55c7efcc4ed..0f555cc31984 100644
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
index 0208c3c2cbc6..85e6cda45a02 100644
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
index 86281ffb96d6..a531f6564ed0 100644
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
diff --git a/kernel/locking/rtmutex.c b/kernel/locking/rtmutex.c
index fc605941b9b8..28477b9ac6a9 100644
--- a/kernel/locking/rtmutex.c
+++ b/kernel/locking/rtmutex.c
@@ -73,7 +73,7 @@ static void fixup_rt_mutex_waiters(struct rt_mutex *lock)
  * We can speed up the acquire/release, if the architecture
  * supports cmpxchg and if there's no debugging state to be set up
  */
-#if defined(__HAVE_ARCH_CMPXCHG) && !defined(CONFIG_DEBUG_RT_MUTEXES)
+#ifndef CONFIG_DEBUG_RT_MUTEXES
 # define rt_mutex_cmpxchg(l,c,n)	(cmpxchg(&l->owner, c, n) == c)
 static inline void mark_rt_mutex_waiters(struct rt_mutex *lock)
 {
-- 
2.0.0

