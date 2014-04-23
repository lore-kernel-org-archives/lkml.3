Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756174AbaDWGyI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Apr 2014 02:54:08 -0400
Received: from mga03.intel.com ([143.182.124.21]:6808 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753442AbaDWGyF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Apr 2014 02:54:05 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,910,1389772800"; 
   d="scan'208,223";a="517760221"
From: Lv Zheng <lv.zheng@intel.com>
To: "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Len Brown <len.brown@intel.com>
Cc: Lv Zheng <lv.zheng@intel.com>, Lv Zheng <zetalog@gmail.com>,
        <linux-kernel@vger.kernel.org>, linux-acpi@vger.kernel.org
Subject: [PATCH v2 2/5] ACPICA: Add <acpi/acpi_opt.h> to remove mis-ordered inclusion of <acpi/actypes.h> from <acpi/platform/aclinux.h>.
Date: Wed, 23 Apr 2014 14:53:59 +0800
Message-Id: <c1428c5c48ec7c0ab9e5f588365689d0452e2d8f.1398232409.git.lv.zheng@intel.com>
X-Mailer: git-send-email 1.7.10
In-Reply-To: <cover.1398232408.git.lv.zheng@intel.com>
References: <cover.1396930406.git.lv.zheng@intel.com> <cover.1398232408.git.lv.zheng@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>From ACPICA's perspective, <acpi/actypes.h> should be included after
inclusion of <acpi/platform/acenv.h>.  But currently in Linux,
<acpi/platform/aclinux.h> included by <acpi/platform/acenv.h> has
included <acpi/actypes.h> to find ACPICA types for inline functions.

This causes the following problem:
1. Redundant code in <asm/acpi.h> and <acpi/platform/aclinux.h>:
   Linux must be careful to keep conditions for <acpi/actypes.h> inclusion
   consistent with the conditions for <acpi/platform/aclinux.h> inclusion.
   Which finally leads to the issue that we have to keep many useless macro
   definitions in <acpi/platform/aclinux.h> or <asm/acpi.h>.
   Such conditions include:
     COMPILER_DEPENDENT_UINT64
     COMPILER_DEPENDENT_INT64
     ACPI_INLINE
     ACPI_SYSTEM_XFACE
     ACPI_EXTERNAL_XFACE
     ACPI_INTERNAL_XFACE
     ACPI_INTERNAL_VAR_XFACE
     ACPI_MUTEX_TYPE
     DEBUGGER_THREADING
     ACPI_ACQUIRE_GLOBAL_LOCK
     ACPI_RELEASE_GLOBAL_LOCK
     ACPI_FLUSH_CPU_CACHE
   They have default implementations in <include/acpi/platform/acenv.h>
   while Linux need to keep a copy in <asm/acpi.h> to avoid build errors.
   Typical Linux build error if we deletes COMPILER_DEPENDENT_x and
   ACPI_x_XFACE definitions from asm/acpi.h:
      CC      init/main.o
    In file included from include/acpi/platform/aclinux.h:293:0,
                     from include/acpi/platform/acenv.h:149,
                     from include/acpi/acpi.h:56,
                     from include/linux/acpi.h:41,
                     from init/main.c:27:
    include/acpi/actypes.h:129:1: error: unknown type name 'COMPILER_DEPENDENT_UINT64'
    include/acpi/actypes.h:130:1: error: unknown type name 'COMPILER_DEPENDENT_INT64'
    In file included from include/acpi/platform/aclinux.h:293:0,
                     from include/acpi/platform/acenv.h:149,
                     from include/acpi/acpi.h:56,
                     from include/linux/acpi.h:41,
                     from init/main.c:27:
    include/acpi/actypes.h:1025:21: error: expected ')' before '*' token
    include/acpi/actypes.h:1028:21: error: expected ')' before '*' token
    In file included from include/acpi/acpi.h:63:0,
                     from include/linux/acpi.h:41,
                     from init/main.c:27:
    include/acpi/acpiosxf.h:240:7: error: unknown type name 'acpi_osd_handler'
    include/acpi/acpiosxf.h:247:6: error: unknown type name 'acpi_osd_handler'
    include/acpi/acpiosxf.h:260:3: error: unknown type name 'acpi_osd_exec_callback'

This patch introduces <acpi/acpi_opt.h> to fix this issue by splitting
conditions and declarations (most of them are inline functions) into 2
header files so that the wrong inclusion of <acpi/actypes.h> can be removed
from <acpi/platform/aclinux.h>.

Signed-off-by: Lv Zheng <lv.zheng@intel.com>
---
 include/acpi/acpi_opt.h         |   90 ++++++++++++++++++++++++++++++++++
 include/acpi/platform/aclinux.h |  101 +++++----------------------------------
 2 files changed, 101 insertions(+), 90 deletions(-)
 create mode 100644 include/acpi/acpi_opt.h

diff --git a/include/acpi/acpi_opt.h b/include/acpi/acpi_opt.h
new file mode 100644
index 0000000..51ccbe5
--- /dev/null
+++ b/include/acpi/acpi_opt.h
@@ -0,0 +1,90 @@
+/*
+ * Extra OS specific ACPI defines for Linux.
+ *
+ * Copyright (C) 2014, Intel Corporation
+ * Authors: Lv Zheng <lv.zheng@intel.com>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ */
+
+#ifndef _ACPI_OPT_H_
+#define _ACPI_OPT_H_
+
+#ifdef __KERNEL__
+
+/*
+ * Overrides for in-kernel ACPICA
+ */
+acpi_status __init acpi_os_initialize(void);
+
+acpi_status acpi_os_terminate(void);
+
+/*
+ * Memory allocation/deallocation
+ */
+
+/*
+ * The irqs_disabled() check is for resume from RAM.
+ * Interrupts are off during resume, just like they are for boot.
+ * However, boot has  (system_state != SYSTEM_RUNNING)
+ * to quiet __might_sleep() in kmalloc() and resume does not.
+ */
+static inline void *acpi_os_allocate(acpi_size size)
+{
+	return kmalloc(size, irqs_disabled() ? GFP_ATOMIC : GFP_KERNEL);
+}
+
+/* Use native linux version of acpi_os_allocate_zeroed */
+
+static inline void *acpi_os_allocate_zeroed(acpi_size size)
+{
+	return kzalloc(size, irqs_disabled() ? GFP_ATOMIC : GFP_KERNEL);
+}
+
+static inline void acpi_os_free(void *memory)
+{
+	kfree(memory);
+}
+
+static inline void *acpi_os_acquire_object(acpi_cache_t *cache)
+{
+	return kmem_cache_zalloc(cache,
+				 irqs_disabled() ? GFP_ATOMIC : GFP_KERNEL);
+}
+
+static inline acpi_thread_id acpi_os_get_thread_id(void)
+{
+	return (acpi_thread_id)(unsigned long)current;
+}
+
+/*
+ * When lockdep is enabled, the spin_lock_init() macro stringifies it's
+ * argument and uses that as a name for the lock in debugging.
+ * By executing spin_lock_init() in a macro the key changes from "lock" for
+ * all locks to the name of the argument of acpi_os_create_lock(), which
+ * prevents lockdep from reporting false positives for ACPICA locks.
+ */
+#define acpi_os_create_lock(__handle) \
+	({ \
+		spinlock_t *lock = ACPI_ALLOCATE(sizeof(*lock)); \
+		if (lock) { \
+			*(__handle) = lock; \
+			spin_lock_init(*(__handle)); \
+		} \
+		lock ? AE_OK : AE_NO_MEMORY; \
+	})
+
+void __iomem *acpi_os_map_memory(acpi_physical_address where, acpi_size length);
+
+void acpi_os_unmap_memory(void __iomem *logical_address, acpi_size size);
+
+/*
+ * OSL interfaces added by Linux
+ */
+void early_acpi_os_unmap_memory(void __iomem *virt, acpi_size size);
+
+#endif
+
+#endif
diff --git a/include/acpi/platform/aclinux.h b/include/acpi/platform/aclinux.h
index f242909..a20f051 100644
--- a/include/acpi/platform/aclinux.h
+++ b/include/acpi/platform/aclinux.h
@@ -130,73 +130,6 @@
 
 #ifdef __KERNEL__
 
-/*
- * FIXME: Inclusion of actypes.h
- * Linux kernel need this before defining inline OSL interfaces as
- * actypes.h need to be included to find ACPICA type definitions.
- * Since from ACPICA's perspective, the actypes.h should be included after
- * acenv.h (aclinux.h), this leads to a inclusion mis-ordering issue.
- */
-#include <acpi/actypes.h>
-
-/*
- * Overrides for in-kernel ACPICA
- */
-acpi_status __init acpi_os_initialize(void);
-#define ACPI_USE_ALTERNATE_PROTOTYPE_acpi_os_initialize
-
-acpi_status acpi_os_terminate(void);
-#define ACPI_USE_ALTERNATE_PROTOTYPE_acpi_os_terminate
-
-/*
- * Memory allocation/deallocation
- */
-
-/*
- * The irqs_disabled() check is for resume from RAM.
- * Interrupts are off during resume, just like they are for boot.
- * However, boot has  (system_state != SYSTEM_RUNNING)
- * to quiet __might_sleep() in kmalloc() and resume does not.
- */
-static inline void *acpi_os_allocate(acpi_size size)
-{
-	return kmalloc(size, irqs_disabled()? GFP_ATOMIC : GFP_KERNEL);
-}
-
-#define ACPI_USE_ALTERNATE_PROTOTYPE_acpi_os_allocate
-
-/* Use native linux version of acpi_os_allocate_zeroed */
-
-static inline void *acpi_os_allocate_zeroed(acpi_size size)
-{
-	return kzalloc(size, irqs_disabled()? GFP_ATOMIC : GFP_KERNEL);
-}
-
-#define ACPI_USE_ALTERNATE_PROTOTYPE_acpi_os_allocate_zeroed
-#define USE_NATIVE_ALLOCATE_ZEROED
-
-static inline void acpi_os_free(void *memory)
-{
-	kfree(memory);
-}
-
-#define ACPI_USE_ALTERNATE_PROTOTYPE_acpi_os_free
-
-static inline void *acpi_os_acquire_object(acpi_cache_t * cache)
-{
-	return kmem_cache_zalloc(cache,
-				 irqs_disabled()? GFP_ATOMIC : GFP_KERNEL);
-}
-
-#define ACPI_USE_ALTERNATE_PROTOTYPE_acpi_os_acquire_object
-
-static inline acpi_thread_id acpi_os_get_thread_id(void)
-{
-	return (acpi_thread_id) (unsigned long)current;
-}
-
-#define ACPI_USE_ALTERNATE_PROTOTYPE_acpi_os_get_thread_id
-
 #ifndef CONFIG_PREEMPT
 
 /*
@@ -212,27 +145,18 @@ static inline acpi_thread_id acpi_os_get_thread_id(void)
 #endif
 
 /*
- * When lockdep is enabled, the spin_lock_init() macro stringifies it's
- * argument and uses that as a name for the lock in debugging.
- * By executing spin_lock_init() in a macro the key changes from "lock" for
- * all locks to the name of the argument of acpi_os_create_lock(), which
- * prevents lockdep from reporting false positives for ACPICA locks.
+ * Overrides for in-kernel ACPICA
  */
-#define acpi_os_create_lock(__handle) \
-	({ \
-		spinlock_t *lock = ACPI_ALLOCATE(sizeof(*lock)); \
-		if (lock) { \
-			*(__handle) = lock; \
-			spin_lock_init(*(__handle)); \
-		} \
-		lock ? AE_OK : AE_NO_MEMORY; \
-	})
+#define ACPI_USE_ALTERNATE_PROTOTYPE_acpi_os_initialize
+#define ACPI_USE_ALTERNATE_PROTOTYPE_acpi_os_terminate
+#define ACPI_USE_ALTERNATE_PROTOTYPE_acpi_os_allocate
+#define ACPI_USE_ALTERNATE_PROTOTYPE_acpi_os_allocate_zeroed
+#define USE_NATIVE_ALLOCATE_ZEROED
+#define ACPI_USE_ALTERNATE_PROTOTYPE_acpi_os_free
+#define ACPI_USE_ALTERNATE_PROTOTYPE_acpi_os_acquire_object
+#define ACPI_USE_ALTERNATE_PROTOTYPE_acpi_os_get_thread_id
 #define ACPI_USE_ALTERNATE_PROTOTYPE_acpi_os_create_lock
-
-void __iomem *acpi_os_map_memory(acpi_physical_address where, acpi_size length);
 #define ACPI_USE_ALTERNATE_PROTOTYPE_acpi_os_map_memory
-
-void acpi_os_unmap_memory(void __iomem * logical_address, acpi_size size);
 #define ACPI_USE_ALTERNATE_PROTOTYPE_acpi_os_unmap_memory
 
 /*
@@ -253,11 +177,8 @@ void acpi_os_unmap_memory(void __iomem * logical_address, acpi_size size);
 #define ACPI_USE_ALTERNATE_PROTOTYPE_acpi_os_get_next_filename
 #define ACPI_USE_ALTERNATE_PROTOTYPE_acpi_os_close_directory
 
-/*
- * OSL interfaces added by Linux
- */
-void early_acpi_os_unmap_memory(void __iomem * virt, acpi_size size);
-
 #endif				/* __KERNEL__ */
 
+#define ACPI_USE_NATIVE_INTERFACE_HEADER    1
+
 #endif				/* __ACLINUX_H__ */
-- 
1.7.10

