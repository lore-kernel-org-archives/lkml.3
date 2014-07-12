Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755401AbaGLAaj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jul 2014 20:30:39 -0400
Received: from terminus.zytor.com ([198.137.202.10]:40786 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755360AbaGLAah (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jul 2014 20:30:37 -0400
Date: Fri, 11 Jul 2014 17:30:23 -0700
From: tip-bot for Borislav Petkov <tipbot@zytor.com>
Message-ID: <tip-b08ee5f7e4135d64b8edd769367f8964a725122e@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        tglx@linutronix.de, hpa@linux.intel.com, bp@suse.de
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        tglx@linutronix.de, bp@suse.de, hpa@linux.intel.com
In-Reply-To: <20140711104338.GB17083@pd.tnic>
References: <20140711104338.GB17083@pd.tnic>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/cleanups] x86: Simplify __HAVE_ARCH_CMPXCHG tests
Git-Commit-ID: b08ee5f7e4135d64b8edd769367f8964a725122e
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  b08ee5f7e4135d64b8edd769367f8964a725122e
Gitweb:     http://git.kernel.org/tip/b08ee5f7e4135d64b8edd769367f8964a725122e
Author:     Borislav Petkov <bp@suse.de>
AuthorDate: Fri, 11 Jul 2014 12:43:38 +0200
Committer:  H. Peter Anvin <hpa@linux.intel.com>
CommitDate: Fri, 11 Jul 2014 17:28:51 -0700

x86: Simplify __HAVE_ARCH_CMPXCHG tests

Both the 32-bit and 64-bit cmpxchg.h header define __HAVE_ARCH_CMPXCHG
and there's ifdeffery which checks it. But since both bitness define it,
we can just as well move it up to the main cmpxchg header and simpify a
bit of code in doing that.

Signed-off-by: Borislav Petkov <bp@suse.de>
Link: http://lkml.kernel.org/r/20140711104338.GB17083@pd.tnic
Signed-off-by: H. Peter Anvin <hpa@linux.intel.com>
---
 arch/x86/include/asm/cmpxchg.h     |  4 ++--
 arch/x86/include/asm/cmpxchg_32.h  |  2 --
 arch/x86/include/asm/cmpxchg_64.h  |  2 --
 arch/x86/include/asm/mc146818rtc.h |  2 +-
 arch/x86/include/asm/mutex_32.h    | 16 ++--------------
 arch/x86/kernel/acpi/boot.c        |  4 ----
 6 files changed, 5 insertions(+), 25 deletions(-)

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
