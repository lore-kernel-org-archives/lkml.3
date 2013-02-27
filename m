Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759744Ab3B0DAW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Feb 2013 22:00:22 -0500
Received: from wolverine02.qualcomm.com ([199.106.114.251]:30385 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753873Ab3B0DAU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Feb 2013 22:00:20 -0500
X-IronPort-AV: E=Sophos;i="4.84,744,1355126400"; 
   d="scan'208";a="26968080"
From: Stephen Boyd <sboyd@codeaurora.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>,
        Ingo Molnar <mingo@elte.hu>, "H. Peter Anvin" <hpa@zytor.com>,
        linux-parisc@vger.kernel.org, linux-s390@vger.kernel.org,
        Arjan van de Ven <arjan@linux.intel.com>, Helge Deller <deller@gmx.de>,
        Heiko Carstens <heiko.carstens@de.ibm.com>,
        Stephen Rothwell <sfr@canb.auug.org.au>,
        Chris Metcalf <cmetcalf@tilera.com>
Subject: [PATCH] Consolidate CONFIG_DEBUG_STRICT_USER_COPY_CHECKS
Date: Tue, 26 Feb 2013 19:00:16 -0800
Message-Id: <1361934016-22630-1-git-send-email-sboyd@codeaurora.org>
X-Mailer: git-send-email 1.8.2.rc0.22.gb3600c3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The help text for this config is duplicated across the x86,
parisc, and s390 Kconfig.debug files. Arnd Bergman noted that the
help text was slightly misleading and should be fixed to state
that enabling this option isn't a problem when using pre 4.4 gcc.

To simplify the rewording, consolidate the text into
lib/Kconfig.debug and modify it there to be more explicit about
when you should say N to this config.

Also, make the text a bit more generic by stating that this
option enables compile time checks so we can cover architectures
which emit warnings vs. ones which emit errors. The details of
how an architecture decided to implement the checks isn't as
important as the concept of compile time checking of
copy_from_user() calls.

While we're doing this, remove all the copy_from_user_overflow()
code that's duplicated many times and place it into lib/ so that
any architecture supporting this option can get the function for
free.

Cc: Arnd Bergmann <arnd@arndb.de>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: H. Peter Anvin <hpa@zytor.com>
Cc: linux-parisc@vger.kernel.org
Cc: linux-s390@vger.kernel.org
Cc: Arjan van de Ven <arjan@linux.intel.com>
Cc: Helge Deller <deller@gmx.de>
Cc: Heiko Carstens <heiko.carstens@de.ibm.com>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Chris Metcalf <cmetcalf@tilera.com>
Signed-off-by: Stephen Boyd <sboyd@codeaurora.org>
---

Per Helge Deller prodding me, I'm resending just this patch.

https://patchwork.kernel.org/patch/833182/

 arch/parisc/Kconfig             |  1 +
 arch/parisc/Kconfig.debug       | 14 --------------
 arch/s390/Kconfig               |  1 +
 arch/s390/Kconfig.debug         | 14 --------------
 arch/s390/lib/Makefile          |  1 -
 arch/s390/lib/usercopy.c        |  8 --------
 arch/sparc/lib/Makefile         |  1 -
 arch/sparc/lib/usercopy.c       |  9 ---------
 arch/tile/Kconfig               |  8 +-------
 arch/tile/include/asm/uaccess.h |  7 ++++++-
 arch/tile/lib/uaccess.c         |  8 --------
 arch/x86/Kconfig                |  1 +
 arch/x86/Kconfig.debug          | 14 --------------
 arch/x86/lib/usercopy_32.c      |  6 ------
 lib/Kconfig.debug               | 18 ++++++++++++++++++
 lib/Makefile                    |  1 +
 lib/usercopy.c                  |  9 +++++++++
 17 files changed, 38 insertions(+), 83 deletions(-)
 delete mode 100644 arch/s390/lib/usercopy.c
 delete mode 100644 arch/sparc/lib/usercopy.c
 create mode 100644 lib/usercopy.c

diff --git a/arch/parisc/Kconfig b/arch/parisc/Kconfig
index a2a47d9..96be92f 100644
--- a/arch/parisc/Kconfig
+++ b/arch/parisc/Kconfig
@@ -1,5 +1,6 @@
 config PARISC
 	def_bool y
+	select ARCH_HAS_DEBUG_STRICT_USER_COPY_CHECKS
 	select HAVE_IDE
 	select HAVE_OPROFILE
 	select HAVE_FUNCTION_TRACER if 64BIT
diff --git a/arch/parisc/Kconfig.debug b/arch/parisc/Kconfig.debug
index 7305ac8..bc989e5 100644
--- a/arch/parisc/Kconfig.debug
+++ b/arch/parisc/Kconfig.debug
@@ -12,18 +12,4 @@ config DEBUG_RODATA
          portion of the kernel code won't be covered by a TLB anymore.
          If in doubt, say "N".
 
-config DEBUG_STRICT_USER_COPY_CHECKS
-	bool "Strict copy size checks"
-	depends on DEBUG_KERNEL && !TRACE_BRANCH_PROFILING
-	---help---
-	  Enabling this option turns a certain set of sanity checks for user
-	  copy operations into compile time failures.
-
-	  The copy_from_user() etc checks are there to help test if there
-	  are sufficient security checks on the length argument of
-	  the copy operation, by having gcc prove that the argument is
-	  within bounds.
-
-	  If unsure, or if you run an older (pre 4.4) gcc, say N.
-
 endmenu
diff --git a/arch/s390/Kconfig b/arch/s390/Kconfig
index 4b50537..516621f 100644
--- a/arch/s390/Kconfig
+++ b/arch/s390/Kconfig
@@ -91,6 +91,7 @@ config S390
 	select ARCH_INLINE_WRITE_UNLOCK_BH
 	select ARCH_INLINE_WRITE_UNLOCK_IRQ
 	select ARCH_INLINE_WRITE_UNLOCK_IRQRESTORE
+	select ARCH_HAS_DEBUG_STRICT_USER_COPY_CHECKS
 	select ARCH_SAVE_PAGE_KEYS if HIBERNATION
 	select ARCH_WANT_IPC_PARSE_VERSION
 	select BUILDTIME_EXTABLE_SORT
diff --git a/arch/s390/Kconfig.debug b/arch/s390/Kconfig.debug
index fc32a2d..c56878e 100644
--- a/arch/s390/Kconfig.debug
+++ b/arch/s390/Kconfig.debug
@@ -17,20 +17,6 @@ config STRICT_DEVMEM
 
 	  If you are unsure, say Y.
 
-config DEBUG_STRICT_USER_COPY_CHECKS
-	def_bool n
-	prompt "Strict user copy size checks"
-	---help---
-	  Enabling this option turns a certain set of sanity checks for user
-	  copy operations into compile time warnings.
-
-	  The copy_from_user() etc checks are there to help test if there
-	  are sufficient security checks on the length argument of
-	  the copy operation, by having gcc prove that the argument is
-	  within bounds.
-
-	  If unsure, or if you run an older (pre 4.4) gcc, say N.
-
 config S390_PTDUMP
 	bool "Export kernel pagetable layout to userspace via debugfs"
 	depends on DEBUG_KERNEL
diff --git a/arch/s390/lib/Makefile b/arch/s390/lib/Makefile
index 6ab0d0b..20b0e97 100644
--- a/arch/s390/lib/Makefile
+++ b/arch/s390/lib/Makefile
@@ -3,7 +3,6 @@
 #
 
 lib-y += delay.o string.o uaccess_std.o uaccess_pt.o
-obj-y += usercopy.o
 obj-$(CONFIG_32BIT) += div64.o qrnnd.o ucmpdi2.o mem32.o
 obj-$(CONFIG_64BIT) += mem64.o
 lib-$(CONFIG_64BIT) += uaccess_mvcos.o
diff --git a/arch/s390/lib/usercopy.c b/arch/s390/lib/usercopy.c
deleted file mode 100644
index 14b363f..0000000
--- a/arch/s390/lib/usercopy.c
+++ /dev/null
@@ -1,8 +0,0 @@
-#include <linux/module.h>
-#include <linux/bug.h>
-
-void copy_from_user_overflow(void)
-{
-	WARN(1, "Buffer overflow detected!\n");
-}
-EXPORT_SYMBOL(copy_from_user_overflow);
diff --git a/arch/sparc/lib/Makefile b/arch/sparc/lib/Makefile
index 8410065f2..dbe119b 100644
--- a/arch/sparc/lib/Makefile
+++ b/arch/sparc/lib/Makefile
@@ -45,4 +45,3 @@ obj-y                 += iomap.o
 obj-$(CONFIG_SPARC32) += atomic32.o ucmpdi2.o
 obj-y                 += ksyms.o
 obj-$(CONFIG_SPARC64) += PeeCeeI.o
-obj-y                 += usercopy.o
diff --git a/arch/sparc/lib/usercopy.c b/arch/sparc/lib/usercopy.c
deleted file mode 100644
index 5c4284c..0000000
--- a/arch/sparc/lib/usercopy.c
+++ /dev/null
@@ -1,9 +0,0 @@
-#include <linux/module.h>
-#include <linux/kernel.h>
-#include <linux/bug.h>
-
-void copy_from_user_overflow(void)
-{
-	WARN(1, "Buffer overflow detected!\n");
-}
-EXPORT_SYMBOL(copy_from_user_overflow);
diff --git a/arch/tile/Kconfig b/arch/tile/Kconfig
index 1404497..9d65a48 100644
--- a/arch/tile/Kconfig
+++ b/arch/tile/Kconfig
@@ -19,6 +19,7 @@ config TILE
 	select HAVE_SYSCALL_WRAPPERS if TILEGX
 	select HAVE_VIRT_TO_BUS
 	select SYS_HYPERVISOR
+	select ARCH_HAS_DEBUG_STRICT_USER_COPY_CHECKS
 	select ARCH_HAVE_NMI_SAFE_CMPXCHG
 	select GENERIC_CLOCKEVENTS
 	select MODULES_USE_ELF_RELA
@@ -117,13 +118,6 @@ config STRICT_DEVMEM
 config SMP
 	def_bool y
 
-# Allow checking for compile-time determined overflow errors in
-# copy_from_user().  There are still unprovable places in the
-# generic code as of 2.6.34, so this option is not really compatible
-# with -Werror, which is more useful in general.
-config DEBUG_COPY_FROM_USER
-	def_bool n
-
 config HVC_TILE
 	depends on TTY
 	select HVC_DRIVER
diff --git a/arch/tile/include/asm/uaccess.h b/arch/tile/include/asm/uaccess.h
index 9ab078a..8a082bc 100644
--- a/arch/tile/include/asm/uaccess.h
+++ b/arch/tile/include/asm/uaccess.h
@@ -395,7 +395,12 @@ _copy_from_user(void *to, const void __user *from, unsigned long n)
 	return n;
 }
 
-#ifdef CONFIG_DEBUG_COPY_FROM_USER
+#ifdef CONFIG_DEBUG_STRICT_USER_COPY_CHECKS
+/*
+ * There are still unprovable places in the generic code as of 2.6.34, so this
+ * option is not really compatible with -Werror, which is more useful in
+ * general.
+ */
 extern void copy_from_user_overflow(void)
 	__compiletime_warning("copy_from_user() size is not provably correct");
 
diff --git a/arch/tile/lib/uaccess.c b/arch/tile/lib/uaccess.c
index f8d398c..030abe3 100644
--- a/arch/tile/lib/uaccess.c
+++ b/arch/tile/lib/uaccess.c
@@ -22,11 +22,3 @@ int __range_ok(unsigned long addr, unsigned long size)
 		 is_arch_mappable_range(addr, size));
 }
 EXPORT_SYMBOL(__range_ok);
-
-#ifdef CONFIG_DEBUG_COPY_FROM_USER
-void copy_from_user_overflow(void)
-{
-       WARN(1, "Buffer overflow detected!\n");
-}
-EXPORT_SYMBOL(copy_from_user_overflow);
-#endif
diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
index a4f24f5..f045e0a 100644
--- a/arch/x86/Kconfig
+++ b/arch/x86/Kconfig
@@ -20,6 +20,7 @@ config X86_64
 ### Arch settings
 config X86
 	def_bool y
+	select ARCH_HAS_DEBUG_STRICT_USER_COPY_CHECKS
 	select HAVE_AOUT if X86_32
 	select HAVE_UNSTABLE_SCHED_CLOCK
 	select ARCH_SUPPORTS_NUMA_BALANCING
diff --git a/arch/x86/Kconfig.debug b/arch/x86/Kconfig.debug
index b322f12..dea0da5 100644
--- a/arch/x86/Kconfig.debug
+++ b/arch/x86/Kconfig.debug
@@ -292,20 +292,6 @@ config OPTIMIZE_INLINING
 
 	  If unsure, say N.
 
-config DEBUG_STRICT_USER_COPY_CHECKS
-	bool "Strict copy size checks"
-	depends on DEBUG_KERNEL && !TRACE_BRANCH_PROFILING
-	---help---
-	  Enabling this option turns a certain set of sanity checks for user
-	  copy operations into compile time failures.
-
-	  The copy_from_user() etc checks are there to help test if there
-	  are sufficient security checks on the length argument of
-	  the copy operation, by having gcc prove that the argument is
-	  within bounds.
-
-	  If unsure, or if you run an older (pre 4.4) gcc, say N.
-
 config DEBUG_NMI_SELFTEST
 	bool "NMI Selftest"
 	depends on DEBUG_KERNEL && X86_LOCAL_APIC
diff --git a/arch/x86/lib/usercopy_32.c b/arch/x86/lib/usercopy_32.c
index f0312d7..3eb18ac 100644
--- a/arch/x86/lib/usercopy_32.c
+++ b/arch/x86/lib/usercopy_32.c
@@ -689,9 +689,3 @@ _copy_from_user(void *to, const void __user *from, unsigned long n)
 	return n;
 }
 EXPORT_SYMBOL(_copy_from_user);
-
-void copy_from_user_overflow(void)
-{
-	WARN(1, "Buffer overflow detected!\n");
-}
-EXPORT_SYMBOL(copy_from_user_overflow);
diff --git a/lib/Kconfig.debug b/lib/Kconfig.debug
index 28be08c..ae80518 100644
--- a/lib/Kconfig.debug
+++ b/lib/Kconfig.debug
@@ -1292,6 +1292,24 @@ config LATENCYTOP
 	  Enable this option if you want to use the LatencyTOP tool
 	  to find out which userspace is blocking on what kernel operations.
 
+config ARCH_HAS_DEBUG_STRICT_USER_COPY_CHECKS
+	bool
+
+config DEBUG_STRICT_USER_COPY_CHECKS
+	bool "Strict user copy size checks"
+	depends on ARCH_HAS_DEBUG_STRICT_USER_COPY_CHECKS
+	depends on DEBUG_KERNEL && !TRACE_BRANCH_PROFILING
+	help
+	  Enabling this option turns a certain set of sanity checks for user
+	  copy operations into compile time failures.
+
+	  The copy_from_user() etc checks are there to help test if there
+	  are sufficient security checks on the length argument of
+	  the copy operation, by having gcc prove that the argument is
+	  within bounds.
+
+	  If unsure, say N.
+
 source mm/Kconfig.debug
 source kernel/trace/Kconfig
 
diff --git a/lib/Makefile b/lib/Makefile
index 32f4455..59fabd0 100644
--- a/lib/Makefile
+++ b/lib/Makefile
@@ -15,6 +15,7 @@ lib-y := ctype.o string.o vsprintf.o cmdline.o \
 	 is_single_threaded.o plist.o decompress.o kobject_uevent.o \
 	 earlycpio.o percpu-refcount.o
 
+lib-$(CONFIG_ARCH_HAS_DEBUG_STRICT_USER_COPY_CHECKS) += usercopy.o
 lib-$(CONFIG_MMU) += ioremap.o
 lib-$(CONFIG_SMP) += cpumask.o
 
diff --git a/lib/usercopy.c b/lib/usercopy.c
new file mode 100644
index 0000000..4f5b1dd
--- /dev/null
+++ b/lib/usercopy.c
@@ -0,0 +1,9 @@
+#include <linux/export.h>
+#include <linux/bug.h>
+#include <linux/uaccess.h>
+
+void copy_from_user_overflow(void)
+{
+	WARN(1, "Buffer overflow detected!\n");
+}
+EXPORT_SYMBOL(copy_from_user_overflow);
-- 
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum,
hosted by The Linux Foundation

