Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755661AbaJHJD5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Oct 2014 05:03:57 -0400
Received: from ozlabs.org ([103.22.144.67]:53276 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754268AbaJHIzV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Oct 2014 04:55:21 -0400
From: Michael Neuling <mikey@neuling.org>
To: greg@kroah.com, arnd@arndb.de, mpe@ellerman.id.au,
        benh@kernel.crashing.org
Cc: mikey@neuling.org, anton@samba.org, linux-kernel@vger.kernel.org,
        linuxppc-dev@ozlabs.org, jk@ozlabs.org, imunsie@au.ibm.com,
        cbe-oss-dev@lists.ozlabs.org,
        "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Subject: [PATCH v4 01/16] powerpc/cell: Move spu_handle_mm_fault() out of cell platform
Date: Wed,  8 Oct 2014 19:54:50 +1100
Message-Id: <1412758505-23495-2-git-send-email-mikey@neuling.org>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1412758505-23495-1-git-send-email-mikey@neuling.org>
References: <1412758505-23495-1-git-send-email-mikey@neuling.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Ian Munsie <imunsie@au1.ibm.com>

Currently spu_handle_mm_fault() is in the cell platform.

This code is generically useful for other non-cell co-processors on powerpc.

This patch moves this function out of the cell platform into arch/powerpc/mm so
that others may use it.

Signed-off-by: Ian Munsie <imunsie@au1.ibm.com>
Signed-off-by: Michael Neuling <mikey@neuling.org>
---
 arch/powerpc/Kconfig                                     |  4 ++++
 arch/powerpc/include/asm/copro.h                         | 16 ++++++++++++++++
 arch/powerpc/include/asm/spu.h                           |  5 ++---
 arch/powerpc/mm/Makefile                                 |  1 +
 .../{platforms/cell/spu_fault.c => mm/copro_fault.c}     | 14 ++++++--------
 arch/powerpc/platforms/cell/Kconfig                      |  1 +
 arch/powerpc/platforms/cell/Makefile                     |  2 +-
 arch/powerpc/platforms/cell/spufs/fault.c                |  4 ++--
 8 files changed, 33 insertions(+), 14 deletions(-)
 create mode 100644 arch/powerpc/include/asm/copro.h
 rename arch/powerpc/{platforms/cell/spu_fault.c => mm/copro_fault.c} (89%)

diff --git a/arch/powerpc/Kconfig b/arch/powerpc/Kconfig
index 4bc7b62..8f094e9 100644
--- a/arch/powerpc/Kconfig
+++ b/arch/powerpc/Kconfig
@@ -603,6 +603,10 @@ config PPC_SUBPAGE_PROT
 	  to set access permissions (read/write, readonly, or no access)
 	  on the 4k subpages of each 64k page.
 
+config PPC_COPRO_BASE
+	bool
+	default n
+
 config SCHED_SMT
 	bool "SMT (Hyperthreading) scheduler support"
 	depends on PPC64 && SMP
diff --git a/arch/powerpc/include/asm/copro.h b/arch/powerpc/include/asm/copro.h
new file mode 100644
index 0000000..51cae85
--- /dev/null
+++ b/arch/powerpc/include/asm/copro.h
@@ -0,0 +1,16 @@
+/*
+ * Copyright 2014 IBM Corp.
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public License
+ * as published by the Free Software Foundation; either version
+ * 2 of the License, or (at your option) any later version.
+ */
+
+#ifndef _ASM_POWERPC_COPRO_H
+#define _ASM_POWERPC_COPRO_H
+
+int copro_handle_mm_fault(struct mm_struct *mm, unsigned long ea,
+			  unsigned long dsisr, unsigned *flt);
+
+#endif /* _ASM_POWERPC_COPRO_H */
diff --git a/arch/powerpc/include/asm/spu.h b/arch/powerpc/include/asm/spu.h
index 37b7ca3..a6e6e2b 100644
--- a/arch/powerpc/include/asm/spu.h
+++ b/arch/powerpc/include/asm/spu.h
@@ -27,6 +27,8 @@
 #include <linux/workqueue.h>
 #include <linux/device.h>
 #include <linux/mutex.h>
+#include <asm/reg.h>
+#include <asm/copro.h>
 
 #define LS_SIZE (256 * 1024)
 #define LS_ADDR_MASK (LS_SIZE - 1)
@@ -277,9 +279,6 @@ void spu_remove_dev_attr(struct device_attribute *attr);
 int spu_add_dev_attr_group(struct attribute_group *attrs);
 void spu_remove_dev_attr_group(struct attribute_group *attrs);
 
-int spu_handle_mm_fault(struct mm_struct *mm, unsigned long ea,
-		unsigned long dsisr, unsigned *flt);
-
 /*
  * Notifier blocks:
  *
diff --git a/arch/powerpc/mm/Makefile b/arch/powerpc/mm/Makefile
index d0130ff..325e861 100644
--- a/arch/powerpc/mm/Makefile
+++ b/arch/powerpc/mm/Makefile
@@ -34,3 +34,4 @@ obj-$(CONFIG_TRANSPARENT_HUGEPAGE) += hugepage-hash64.o
 obj-$(CONFIG_PPC_SUBPAGE_PROT)	+= subpage-prot.o
 obj-$(CONFIG_NOT_COHERENT_CACHE) += dma-noncoherent.o
 obj-$(CONFIG_HIGHMEM)		+= highmem.o
+obj-$(CONFIG_PPC_COPRO_BASE)	+= copro_fault.o
diff --git a/arch/powerpc/platforms/cell/spu_fault.c b/arch/powerpc/mm/copro_fault.c
similarity index 89%
rename from arch/powerpc/platforms/cell/spu_fault.c
rename to arch/powerpc/mm/copro_fault.c
index 641e727..ba7df14 100644
--- a/arch/powerpc/platforms/cell/spu_fault.c
+++ b/arch/powerpc/mm/copro_fault.c
@@ -1,5 +1,5 @@
 /*
- * SPU mm fault handler
+ * CoProcessor (SPU/AFU) mm fault handler
  *
  * (C) Copyright IBM Deutschland Entwicklung GmbH 2007
  *
@@ -23,16 +23,14 @@
 #include <linux/sched.h>
 #include <linux/mm.h>
 #include <linux/export.h>
-
-#include <asm/spu.h>
-#include <asm/spu_csa.h>
+#include <asm/reg.h>
 
 /*
  * This ought to be kept in sync with the powerpc specific do_page_fault
  * function. Currently, there are a few corner cases that we haven't had
  * to handle fortunately.
  */
-int spu_handle_mm_fault(struct mm_struct *mm, unsigned long ea,
+int copro_handle_mm_fault(struct mm_struct *mm, unsigned long ea,
 		unsigned long dsisr, unsigned *flt)
 {
 	struct vm_area_struct *vma;
@@ -58,12 +56,12 @@ int spu_handle_mm_fault(struct mm_struct *mm, unsigned long ea,
 			goto out_unlock;
 	}
 
-	is_write = dsisr & MFC_DSISR_ACCESS_PUT;
+	is_write = dsisr & DSISR_ISSTORE;
 	if (is_write) {
 		if (!(vma->vm_flags & VM_WRITE))
 			goto out_unlock;
 	} else {
-		if (dsisr & MFC_DSISR_ACCESS_DENIED)
+		if (dsisr & DSISR_PROTFAULT)
 			goto out_unlock;
 		if (!(vma->vm_flags & (VM_READ | VM_EXEC)))
 			goto out_unlock;
@@ -91,4 +89,4 @@ out_unlock:
 	up_read(&mm->mmap_sem);
 	return ret;
 }
-EXPORT_SYMBOL_GPL(spu_handle_mm_fault);
+EXPORT_SYMBOL_GPL(copro_handle_mm_fault);
diff --git a/arch/powerpc/platforms/cell/Kconfig b/arch/powerpc/platforms/cell/Kconfig
index 9978f59..870b6db 100644
--- a/arch/powerpc/platforms/cell/Kconfig
+++ b/arch/powerpc/platforms/cell/Kconfig
@@ -86,6 +86,7 @@ config SPU_FS_64K_LS
 config SPU_BASE
 	bool
 	default n
+	select PPC_COPRO_BASE
 
 config CBE_RAS
 	bool "RAS features for bare metal Cell BE"
diff --git a/arch/powerpc/platforms/cell/Makefile b/arch/powerpc/platforms/cell/Makefile
index fe053e7..2d16884 100644
--- a/arch/powerpc/platforms/cell/Makefile
+++ b/arch/powerpc/platforms/cell/Makefile
@@ -20,7 +20,7 @@ spu-manage-$(CONFIG_PPC_CELL_COMMON)	+= spu_manage.o
 
 obj-$(CONFIG_SPU_BASE)			+= spu_callbacks.o spu_base.o \
 					   spu_notify.o \
-					   spu_syscalls.o spu_fault.o \
+					   spu_syscalls.o \
 					   $(spu-priv1-y) \
 					   $(spu-manage-y) \
 					   spufs/
diff --git a/arch/powerpc/platforms/cell/spufs/fault.c b/arch/powerpc/platforms/cell/spufs/fault.c
index 8cb6260..e45894a 100644
--- a/arch/powerpc/platforms/cell/spufs/fault.c
+++ b/arch/powerpc/platforms/cell/spufs/fault.c
@@ -138,7 +138,7 @@ int spufs_handle_class1(struct spu_context *ctx)
 	if (ctx->state == SPU_STATE_RUNNABLE)
 		ctx->spu->stats.hash_flt++;
 
-	/* we must not hold the lock when entering spu_handle_mm_fault */
+	/* we must not hold the lock when entering copro_handle_mm_fault */
 	spu_release(ctx);
 
 	access = (_PAGE_PRESENT | _PAGE_USER);
@@ -149,7 +149,7 @@ int spufs_handle_class1(struct spu_context *ctx)
 
 	/* hashing failed, so try the actual fault handler */
 	if (ret)
-		ret = spu_handle_mm_fault(current->mm, ea, dsisr, &flt);
+		ret = copro_handle_mm_fault(current->mm, ea, dsisr, &flt);
 
 	/*
 	 * This is nasty: we need the state_mutex for all the bookkeeping even
-- 
1.9.1

