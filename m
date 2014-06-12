Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756260AbaFLQXl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jun 2014 12:23:41 -0400
Received: from mail-qc0-f172.google.com ([209.85.216.172]:53038 "EHLO
	mail-qc0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756131AbaFLQXi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jun 2014 12:23:38 -0400
From: Tejun Heo <tj@kernel.org>
To: cl@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, Tejun Heo <tj@kernel.org>
Subject: [PATCH 03/12] percpu: include/asm-generic/percpu.h should contain only arch-overridable parts
Date: Thu, 12 Jun 2014 12:23:20 -0400
Message-Id: <1402590209-31610-4-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.9.3
In-Reply-To: <1402590209-31610-1-git-send-email-tj@kernel.org>
References: <1402590209-31610-1-git-send-email-tj@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The roles of the various percpu header files has become unclear.
There are four header files involved.

 include/linux/percpu-defs.h
 include/linux/percpu.h
 include/asm-generic/percpu.h
 arch/*/include/asm/percpu.h

The original intention for include/asm-generic/percpu.h is providing
generic definitions for arch-overridable parts; however, it now hosts
various stuff which can't be overridden by archs.

Also, include/linux/percpu-defs.h was initially added to contain
section and percpu variable definition macros so that arch header
files can make use of them without worrying about introducing cyclic
inclusion dependency by including include/linux/percpu.h; however,
arch headers sometimes need to access percpu variables too and this is
one of the reasons why some accessors were implemented in
include/linux/asm-generic/percpu.h.

Let's clear up the situation by making include/asm-generic/percpu.h
contain only arch-overridable parts and moving accessors and
operations into include/linux/percpu-defs.  Note that this patch only
moves things from include/asm-generic/percpu.h.
include/linux/percpu.h will be taken care of by later patches.

This patch moves the followings.

* SHIFT_PERCPU_PTR() / VERIFY_PERCPU_PTR()
* per_cpu()
* raw_cpu_ptr()
* this_cpu_ptr()
* __get_cpu_var()
* __raw_get_cpu_var()
* __this_cpu_ptr()
* PER_CPU_[SHARED_]ALIGNED_SECTION
* PER_CPU_[SHARED_]ALIGNED_SECTION
* PER_CPU_FIRST_SECTION

This patch is pure reorganization.

Signed-off-by: Tejun Heo <tj@kernel.org>
Cc: Christoph Lameter <cl@linux-foundation.org>
---
 include/asm-generic/percpu.h | 64 -------------------------------
 include/linux/percpu-defs.h  | 89 ++++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 89 insertions(+), 64 deletions(-)

diff --git a/include/asm-generic/percpu.h b/include/asm-generic/percpu.h
index a247d80..e5ace4d 100644
--- a/include/asm-generic/percpu.h
+++ b/include/asm-generic/percpu.h
@@ -36,24 +36,6 @@ extern unsigned long __per_cpu_offset[NR_CPUS];
 #endif
 
 /*
- * Add an offset to a pointer but keep the pointer as-is.  Use RELOC_HIDE()
- * to prevent the compiler from making incorrect assumptions about the
- * pointer value.  The weird cast keeps both GCC and sparse happy.
- */
-#define SHIFT_PERCPU_PTR(__p, __offset)	({				\
-	__verify_pcpu_ptr((__p));					\
-	RELOC_HIDE((typeof(*(__p)) __kernel __force *)(__p), (__offset)); \
-})
-
-/*
- * A percpu variable may point to a discarded regions. The following are
- * established ways to produce a usable pointer from the percpu variable
- * offset.
- */
-#define per_cpu(var, cpu) \
-	(*SHIFT_PERCPU_PTR(&(var), per_cpu_offset(cpu)))
-
-/*
  * Arch may define arch_raw_cpu_ptr() to provide more efficient address
  * translations for raw_cpu_ptr().
  */
@@ -61,34 +43,10 @@ extern unsigned long __per_cpu_offset[NR_CPUS];
 #define arch_raw_cpu_ptr(ptr) SHIFT_PERCPU_PTR(ptr, __my_cpu_offset)
 #endif
 
-#define raw_cpu_ptr(ptr) arch_raw_cpu_ptr(ptr)
-
-#ifdef CONFIG_DEBUG_PREEMPT
-#define this_cpu_ptr(ptr) SHIFT_PERCPU_PTR(ptr, my_cpu_offset)
-#else
-#define this_cpu_ptr(ptr) raw_cpu_ptr(ptr)
-#endif
-
-#define __get_cpu_var(var) (*this_cpu_ptr(&(var)))
-#define __raw_get_cpu_var(var) (*raw_cpu_ptr(&(var)))
-
 #ifdef CONFIG_HAVE_SETUP_PER_CPU_AREA
 extern void setup_per_cpu_areas(void);
 #endif
 
-#else /* ! SMP */
-
-#define VERIFY_PERCPU_PTR(__p) ({			\
-	__verify_pcpu_ptr((__p));			\
-	(typeof(*(__p)) __kernel __force *)(__p);	\
-})
-
-#define per_cpu(var, cpu)	(*((void)(cpu), VERIFY_PERCPU_PTR(&(var))))
-#define __get_cpu_var(var)	(*VERIFY_PERCPU_PTR(&(var)))
-#define __raw_get_cpu_var(var)	(*VERIFY_PERCPU_PTR(&(var)))
-#define this_cpu_ptr(ptr)	per_cpu_ptr(ptr, 0)
-#define raw_cpu_ptr(ptr)	this_cpu_ptr(ptr)
-
 #endif	/* SMP */
 
 #ifndef PER_CPU_BASE_SECTION
@@ -99,25 +57,6 @@ extern void setup_per_cpu_areas(void);
 #endif
 #endif
 
-#ifdef CONFIG_SMP
-
-#ifdef MODULE
-#define PER_CPU_SHARED_ALIGNED_SECTION ""
-#define PER_CPU_ALIGNED_SECTION ""
-#else
-#define PER_CPU_SHARED_ALIGNED_SECTION "..shared_aligned"
-#define PER_CPU_ALIGNED_SECTION "..shared_aligned"
-#endif
-#define PER_CPU_FIRST_SECTION "..first"
-
-#else
-
-#define PER_CPU_SHARED_ALIGNED_SECTION ""
-#define PER_CPU_ALIGNED_SECTION "..shared_aligned"
-#define PER_CPU_FIRST_SECTION ""
-
-#endif
-
 #ifndef PER_CPU_ATTRIBUTES
 #define PER_CPU_ATTRIBUTES
 #endif
@@ -126,7 +65,4 @@ extern void setup_per_cpu_areas(void);
 #define PER_CPU_DEF_ATTRIBUTES
 #endif
 
-/* Keep until we have removed all uses of __this_cpu_ptr */
-#define __this_cpu_ptr raw_cpu_ptr
-
 #endif /* _ASM_GENERIC_PERCPU_H_ */
diff --git a/include/linux/percpu-defs.h b/include/linux/percpu-defs.h
index b91bb37..55e04e9 100644
--- a/include/linux/percpu-defs.h
+++ b/include/linux/percpu-defs.h
@@ -1,8 +1,42 @@
+/*
+ * linux/percpu-defs.h - basic definitions for percpu areas
+ *
+ * DO NOT INCLUDE DIRECTLY OUTSIDE PERCPU IMPLEMENTATION PROPER.
+ *
+ * This file is separate from linux/percpu.h to avoid cyclic inclusion
+ * dependency from arch header files.  Only to be included from
+ * asm/percpu.h.
+ *
+ * This file includes macros necessary to declare percpu sections and
+ * variables, and definitions of percpu accessors and operations.  It
+ * should provide enough percpu features to arch header files even when
+ * they can only include asm/percpu.h to avoid cyclic inclusion dependency.
+ */
+
 #ifndef _LINUX_PERCPU_DEFS_H
 #define _LINUX_PERCPU_DEFS_H
 
 #include <asm/barrier.h>
 
+#ifdef CONFIG_SMP
+
+#ifdef MODULE
+#define PER_CPU_SHARED_ALIGNED_SECTION ""
+#define PER_CPU_ALIGNED_SECTION ""
+#else
+#define PER_CPU_SHARED_ALIGNED_SECTION "..shared_aligned"
+#define PER_CPU_ALIGNED_SECTION "..shared_aligned"
+#endif
+#define PER_CPU_FIRST_SECTION "..first"
+
+#else
+
+#define PER_CPU_SHARED_ALIGNED_SECTION ""
+#define PER_CPU_ALIGNED_SECTION "..shared_aligned"
+#define PER_CPU_FIRST_SECTION ""
+
+#endif
+
 /*
  * Base implementations of per-CPU variable declarations and definitions, where
  * the section in which the variable is to be placed is provided by the
@@ -173,4 +207,59 @@
 #define EXPORT_PER_CPU_SYMBOL_GPL(var)
 #endif
 
+/*
+ * Accessors and operations.
+ */
+#ifndef __ASSEMBLY__
+
+#ifdef CONFIG_SMP
+
+/*
+ * Add an offset to a pointer but keep the pointer as-is.  Use RELOC_HIDE()
+ * to prevent the compiler from making incorrect assumptions about the
+ * pointer value.  The weird cast keeps both GCC and sparse happy.
+ */
+#define SHIFT_PERCPU_PTR(__p, __offset)	({				\
+	__verify_pcpu_ptr((__p));					\
+	RELOC_HIDE((typeof(*(__p)) __kernel __force *)(__p), (__offset)); \
+})
+
+/*
+ * A percpu variable may point to a discarded regions. The following are
+ * established ways to produce a usable pointer from the percpu variable
+ * offset.
+ */
+#define per_cpu(var, cpu) \
+	(*SHIFT_PERCPU_PTR(&(var), per_cpu_offset(cpu)))
+
+#define raw_cpu_ptr(ptr) arch_raw_cpu_ptr(ptr)
+
+#ifdef CONFIG_DEBUG_PREEMPT
+#define this_cpu_ptr(ptr) SHIFT_PERCPU_PTR(ptr, my_cpu_offset)
+#else
+#define this_cpu_ptr(ptr) raw_cpu_ptr(ptr)
+#endif
+
+#define __get_cpu_var(var) (*this_cpu_ptr(&(var)))
+#define __raw_get_cpu_var(var) (*raw_cpu_ptr(&(var)))
+
+#else	/* CONFIG_SMP */
+
+#define VERIFY_PERCPU_PTR(__p) ({			\
+	__verify_pcpu_ptr((__p));			\
+	(typeof(*(__p)) __kernel __force *)(__p);	\
+})
+
+#define per_cpu(var, cpu)	(*((void)(cpu), VERIFY_PERCPU_PTR(&(var))))
+#define __get_cpu_var(var)	(*VERIFY_PERCPU_PTR(&(var)))
+#define __raw_get_cpu_var(var)	(*VERIFY_PERCPU_PTR(&(var)))
+#define this_cpu_ptr(ptr)	per_cpu_ptr(ptr, 0)
+#define raw_cpu_ptr(ptr)	this_cpu_ptr(ptr)
+
+#endif	/* CONFIG_SMP */
+
+/* keep until we have removed all uses of __this_cpu_ptr */
+#define __this_cpu_ptr(ptr)	raw_cpu_ptr(ptr)
+
+#endif /* __ASSEMBLY__ */
 #endif /* _LINUX_PERCPU_DEFS_H */
-- 
1.9.3

