Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753454Ab3LRJIA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Dec 2013 04:08:00 -0500
Received: from mga09.intel.com ([134.134.136.24]:51262 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752698Ab3LRJHG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Dec 2013 04:07:06 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.95,506,1384329600"; 
   d="scan'208";a="454116381"
From: Lv Zheng <lv.zheng@intel.com>
To: "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Len Brown <len.brown@intel.com>
Cc: Lv Zheng <lv.zheng@intel.com>, Lv Zheng <zetalog@gmail.com>,
        <linux-kernel@vger.kernel.org>, linux-acpi@vger.kernel.org
Subject: [RFC PATCH 10/15] ACPICA: Linux: Add architecture specific ACPICA headers in Linux.
Date: Wed, 18 Dec 2013 17:06:51 +0800
Message-Id: <c682336441ac2e8d4ddd3c0cd56ca60d48e6b06e.1387336613.git.lv.zheng@intel.com>
X-Mailer: git-send-email 1.7.10
In-Reply-To: <cover.1387336613.git.lv.zheng@intel.com>
References: <cover.1387336613.git.lv.zheng@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Our target is allowing inclusion of <acpi/acpi.h> for CONFIG_ACPI=n build.

This patch tries to achieve this by splitting architecture specific ACPICA
implementation from <asm/acpi.h> into <asm/acenv.h> to improve
maintainability.  Then <asm/acpi.h> could be treated as the architecture
specific part of <linux/acpi.h>, <acpi/acpi_bus.h>,
<acpi/acpi_drivers.h>.

We need to delete <asm/acpi.h> from aclinux.h to achieve our CONFIG_ACPI=n
build target, but in order not to affect Linux build process, it requires
further cleanup on <linux/acpi.h>, <acpi/acpi_bus.h>,
<acpi/acpi_drivers.h> inclusions be done before doing this.

Signed-off-by: Lv Zheng <lv.zheng@intel.com>
---
 arch/ia64/include/asm/acenv.h   |   71 +++++++++++++++++++++++++++++++++++++++
 arch/ia64/include/asm/acpi.h    |   50 ---------------------------
 arch/x86/include/asm/acenv.h    |   66 ++++++++++++++++++++++++++++++++++++
 arch/x86/include/asm/acpi.h     |   45 -------------------------
 include/acpi/platform/aclinux.h |    1 +
 5 files changed, 138 insertions(+), 95 deletions(-)
 create mode 100644 arch/ia64/include/asm/acenv.h
 create mode 100644 arch/x86/include/asm/acenv.h

diff --git a/arch/ia64/include/asm/acenv.h b/arch/ia64/include/asm/acenv.h
new file mode 100644
index 0000000..eb13318
--- /dev/null
+++ b/arch/ia64/include/asm/acenv.h
@@ -0,0 +1,71 @@
+#ifndef _ASM_IA64_ACENV_H
+#define _ASM_IA64_ACENV_H
+
+#include <asm/intrinsics.h>
+
+/*
+ * IA64 specific ACPICA environments and implementation
+ *
+ * Copyright (C) 2013, Intel Corporation
+ *   Author: Lv Zheng <lv.zheng@intel.com>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ */
+
+#define COMPILER_DEPENDENT_INT64	long
+#define COMPILER_DEPENDENT_UINT64	unsigned long
+
+/*
+ * Calling conventions:
+ *
+ * ACPI_SYSTEM_XFACE        - Interfaces to host OS (handlers, threads)
+ * ACPI_EXTERNAL_XFACE      - External ACPI interfaces
+ * ACPI_INTERNAL_XFACE      - Internal ACPI interfaces
+ * ACPI_INTERNAL_VAR_XFACE  - Internal variable-parameter list interfaces
+ */
+#define ACPI_SYSTEM_XFACE
+#define ACPI_EXTERNAL_XFACE
+#define ACPI_INTERNAL_XFACE
+#define ACPI_INTERNAL_VAR_XFACE
+
+/* Asm macros */
+
+#define ACPI_FLUSH_CPU_CACHE()
+
+#ifdef CONFIG_ACPI
+
+static inline int
+ia64_acpi_acquire_global_lock (unsigned int *lock)
+{
+	unsigned int old, new, val;
+	do {
+		old = *lock;
+		new = (((old & ~0x3) + 2) + ((old >> 1) & 0x1));
+		val = ia64_cmpxchg4_acq(lock, new, old);
+	} while (unlikely (val != old));
+	return (new < 3) ? -1 : 0;
+}
+
+static inline int
+ia64_acpi_release_global_lock (unsigned int *lock)
+{
+	unsigned int old, new, val;
+	do {
+		old = *lock;
+		new = old & ~0x3;
+		val = ia64_cmpxchg4_acq(lock, new, old);
+	} while (unlikely (val != old));
+	return old & 0x1;
+}
+
+#define ACPI_ACQUIRE_GLOBAL_LOCK(facs, Acq)				\
+	((Acq) = ia64_acpi_acquire_global_lock(&facs->global_lock))
+
+#define ACPI_RELEASE_GLOBAL_LOCK(facs, Acq)				\
+	((Acq) = ia64_acpi_release_global_lock(&facs->global_lock))
+
+#endif
+
+#endif /* _ASM_IA64_ACENV_H */
diff --git a/arch/ia64/include/asm/acpi.h b/arch/ia64/include/asm/acpi.h
index faa1bf0..84a6f04 100644
--- a/arch/ia64/include/asm/acpi.h
+++ b/arch/ia64/include/asm/acpi.h
@@ -34,56 +34,6 @@
 #include <linux/numa.h>
 #include <asm/numa.h>
 
-#define COMPILER_DEPENDENT_INT64	long
-#define COMPILER_DEPENDENT_UINT64	unsigned long
-
-/*
- * Calling conventions:
- *
- * ACPI_SYSTEM_XFACE        - Interfaces to host OS (handlers, threads)
- * ACPI_EXTERNAL_XFACE      - External ACPI interfaces
- * ACPI_INTERNAL_XFACE      - Internal ACPI interfaces
- * ACPI_INTERNAL_VAR_XFACE  - Internal variable-parameter list interfaces
- */
-#define ACPI_SYSTEM_XFACE
-#define ACPI_EXTERNAL_XFACE
-#define ACPI_INTERNAL_XFACE
-#define ACPI_INTERNAL_VAR_XFACE
-
-/* Asm macros */
-
-#define ACPI_FLUSH_CPU_CACHE()
-
-static inline int
-ia64_acpi_acquire_global_lock (unsigned int *lock)
-{
-	unsigned int old, new, val;
-	do {
-		old = *lock;
-		new = (((old & ~0x3) + 2) + ((old >> 1) & 0x1));
-		val = ia64_cmpxchg4_acq(lock, new, old);
-	} while (unlikely (val != old));
-	return (new < 3) ? -1 : 0;
-}
-
-static inline int
-ia64_acpi_release_global_lock (unsigned int *lock)
-{
-	unsigned int old, new, val;
-	do {
-		old = *lock;
-		new = old & ~0x3;
-		val = ia64_cmpxchg4_acq(lock, new, old);
-	} while (unlikely (val != old));
-	return old & 0x1;
-}
-
-#define ACPI_ACQUIRE_GLOBAL_LOCK(facs, Acq)				\
-	((Acq) = ia64_acpi_acquire_global_lock(&facs->global_lock))
-
-#define ACPI_RELEASE_GLOBAL_LOCK(facs, Acq)				\
-	((Acq) = ia64_acpi_release_global_lock(&facs->global_lock))
-
 #ifdef	CONFIG_ACPI
 #define acpi_disabled 0	/* ACPI always enabled on IA64 */
 #define acpi_noirq 0	/* ACPI always enabled on IA64 */
diff --git a/arch/x86/include/asm/acenv.h b/arch/x86/include/asm/acenv.h
new file mode 100644
index 0000000..2359989
--- /dev/null
+++ b/arch/x86/include/asm/acenv.h
@@ -0,0 +1,66 @@
+#ifndef _ASM_X86_ACENV_H
+#define _ASM_X86_ACENV_H
+
+/*
+ * X86 specific ACPICA environments and implementation
+ *
+ * Copyright (C) 2013, Intel Corporation
+ *   Author: Lv Zheng <lv.zheng@intel.com>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ */
+
+#include <asm/special_insns.h>
+
+#define COMPILER_DEPENDENT_INT64   long long
+#define COMPILER_DEPENDENT_UINT64  unsigned long long
+
+/*
+ * Calling conventions:
+ *
+ * ACPI_SYSTEM_XFACE        - Interfaces to host OS (handlers, threads)
+ * ACPI_EXTERNAL_XFACE      - External ACPI interfaces
+ * ACPI_INTERNAL_XFACE      - Internal ACPI interfaces
+ * ACPI_INTERNAL_VAR_XFACE  - Internal variable-parameter list interfaces
+ */
+#define ACPI_SYSTEM_XFACE
+#define ACPI_EXTERNAL_XFACE
+#define ACPI_INTERNAL_XFACE
+#define ACPI_INTERNAL_VAR_XFACE
+
+/* Asm macros */
+
+#define ACPI_FLUSH_CPU_CACHE()	wbinvd()
+
+#ifdef CONFIG_ACPI
+
+int __acpi_acquire_global_lock(unsigned int *lock);
+int __acpi_release_global_lock(unsigned int *lock);
+
+#define ACPI_ACQUIRE_GLOBAL_LOCK(facs, Acq) \
+	((Acq) = __acpi_acquire_global_lock(&facs->global_lock))
+
+#define ACPI_RELEASE_GLOBAL_LOCK(facs, Acq) \
+	((Acq) = __acpi_release_global_lock(&facs->global_lock))
+
+/*
+ * Math helper asm macros
+ */
+#define ACPI_DIV_64_BY_32(n_hi, n_lo, d32, q32, r32) \
+	asm("divl %2;"				     \
+	    : "=a"(q32), "=d"(r32)		     \
+	    : "r"(d32),				     \
+	     "0"(n_lo), "1"(n_hi))
+
+
+#define ACPI_SHIFT_RIGHT_64(n_hi, n_lo) \
+	asm("shrl   $1,%2	;"	\
+	    "rcrl   $1,%3;"		\
+	    : "=r"(n_hi), "=r"(n_lo)	\
+	    : "0"(n_hi), "1"(n_lo))
+
+#endif
+
+#endif /* _ASM_X86_ACENV_H */
diff --git a/arch/x86/include/asm/acpi.h b/arch/x86/include/asm/acpi.h
index c8c1e70..e06225e 100644
--- a/arch/x86/include/asm/acpi.h
+++ b/arch/x86/include/asm/acpi.h
@@ -32,51 +32,6 @@
 #include <asm/mpspec.h>
 #include <asm/realmode.h>
 
-#define COMPILER_DEPENDENT_INT64   long long
-#define COMPILER_DEPENDENT_UINT64  unsigned long long
-
-/*
- * Calling conventions:
- *
- * ACPI_SYSTEM_XFACE        - Interfaces to host OS (handlers, threads)
- * ACPI_EXTERNAL_XFACE      - External ACPI interfaces
- * ACPI_INTERNAL_XFACE      - Internal ACPI interfaces
- * ACPI_INTERNAL_VAR_XFACE  - Internal variable-parameter list interfaces
- */
-#define ACPI_SYSTEM_XFACE
-#define ACPI_EXTERNAL_XFACE
-#define ACPI_INTERNAL_XFACE
-#define ACPI_INTERNAL_VAR_XFACE
-
-/* Asm macros */
-
-#define ACPI_FLUSH_CPU_CACHE()	wbinvd()
-
-int __acpi_acquire_global_lock(unsigned int *lock);
-int __acpi_release_global_lock(unsigned int *lock);
-
-#define ACPI_ACQUIRE_GLOBAL_LOCK(facs, Acq) \
-	((Acq) = __acpi_acquire_global_lock(&facs->global_lock))
-
-#define ACPI_RELEASE_GLOBAL_LOCK(facs, Acq) \
-	((Acq) = __acpi_release_global_lock(&facs->global_lock))
-
-/*
- * Math helper asm macros
- */
-#define ACPI_DIV_64_BY_32(n_hi, n_lo, d32, q32, r32) \
-	asm("divl %2;"				     \
-	    : "=a"(q32), "=d"(r32)		     \
-	    : "r"(d32),				     \
-	     "0"(n_lo), "1"(n_hi))
-
-
-#define ACPI_SHIFT_RIGHT_64(n_hi, n_lo) \
-	asm("shrl   $1,%2	;"	\
-	    "rcrl   $1,%3;"		\
-	    : "=r"(n_hi), "=r"(n_lo)	\
-	    : "0"(n_hi), "1"(n_lo))
-
 #ifdef CONFIG_ACPI
 extern int acpi_lapic;
 extern int acpi_ioapic;
diff --git a/include/acpi/platform/aclinux.h b/include/acpi/platform/aclinux.h
index b1ddf5c..e9e6374 100644
--- a/include/acpi/platform/aclinux.h
+++ b/include/acpi/platform/aclinux.h
@@ -80,6 +80,7 @@
 #ifdef EXPORT_ACPI_INTERFACES
 #include <linux/export.h>
 #endif
+#include <asm/acenv.h>
 #include <asm/acpi.h>
 
 #ifdef CONFIG_ACPI
-- 
1.7.10.4

