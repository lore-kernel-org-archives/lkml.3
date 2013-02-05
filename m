Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756365Ab3BEAcA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Feb 2013 19:32:00 -0500
Received: from LGEMRELSE6Q.lge.com ([156.147.1.121]:58526 "EHLO
	LGEMRELSE6Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754431Ab3BEAb6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Feb 2013 19:31:58 -0500
X-AuditID: 9c930179-b7c24ae00000119c-5f-511052faa516
From: Joonsoo Kim <iamjoonsoo.kim@lge.com>
To: Russell King <linux@arm.linux.org.uk>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        js1304@gmail.com, Will Deacon <will.deacon@arm.com>,
        Nicolas Pitre <nico@linaro.org>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Joonsoo Kim <iamjoonsoo.kim@lge.com>
Subject: [PATCH v5 2/3] ARM: ioremap: introduce an infrastructure for static mapped area
Date: Tue,  5 Feb 2013 09:31:53 +0900
Message-Id: <1360024314-1895-3-git-send-email-iamjoonsoo.kim@lge.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1360024314-1895-1-git-send-email-iamjoonsoo.kim@lge.com>
References: <1360024314-1895-1-git-send-email-iamjoonsoo.kim@lge.com>
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In current implementation, we used ARM-specific flag, that is,
VM_ARM_STATIC_MAPPING, for distinguishing ARM specific static mapped area.
The purpose of static mapped area is to re-use static mapped area when
entire physical address range of the ioremap request can be covered
by this area.

This implementation causes needless overhead for some cases.
For example, assume that there is only one static mapped area and
vmlist has 300 areas. Every time we call ioremap, we check 300 areas for
deciding whether it is matched or not. Moreover, even if there is
no static mapped area and vmlist has 300 areas, every time we call
ioremap, we check 300 areas in now.

If we construct a extra list for static mapped area, we can eliminate
above mentioned overhead.
With a extra list, if there is one static mapped area,
we just check only one area and proceed next operation quickly.

In fact, it is not a critical problem, because ioremap is not frequently
used. But reducing overhead is better idea.

Another reason for doing this work is for removing architecture dependency
on vmalloc layer. I think that vmlist and vmlist_lock is internal data
structure for vmalloc layer. Some codes for debugging and stat inevitably
use vmlist and vmlist_lock. But it is preferable that they are used
as least as possible in outside of vmalloc.c

Now, I introduce an ARM-specific infrastructure for static mapped area. In
the following patch, we will use this and resolve above mentioned problem.

Signed-off-by: Joonsoo Kim <iamjoonsoo.kim@lge.com>

diff --git a/arch/arm/mm/ioremap.c b/arch/arm/mm/ioremap.c
index 88fd86c..904c15e 100644
--- a/arch/arm/mm/ioremap.c
+++ b/arch/arm/mm/ioremap.c
@@ -39,6 +39,70 @@
 #include <asm/mach/pci.h>
 #include "mm.h"
 
+
+LIST_HEAD(static_vmlist);
+
+static struct static_vm *find_static_vm_paddr(phys_addr_t paddr,
+			size_t size, unsigned int mtype)
+{
+	struct static_vm *svm;
+	struct vm_struct *vm;
+
+	list_for_each_entry(svm, &static_vmlist, list) {
+		vm = &svm->vm;
+		if (!(vm->flags & VM_ARM_STATIC_MAPPING))
+			continue;
+		if ((vm->flags & VM_ARM_MTYPE_MASK) != VM_ARM_MTYPE(mtype))
+			continue;
+
+		if (vm->phys_addr > paddr ||
+			paddr + size - 1 > vm->phys_addr + vm->size - 1)
+			continue;
+
+		return svm;
+	}
+
+	return NULL;
+}
+
+struct static_vm *find_static_vm_vaddr(void *vaddr)
+{
+	struct static_vm *svm;
+	struct vm_struct *vm;
+
+	list_for_each_entry(svm, &static_vmlist, list) {
+		vm = &svm->vm;
+
+		/* static_vmlist is ascending order */
+		if (vm->addr > vaddr)
+			break;
+
+		if (vm->addr <= vaddr && vm->addr + vm->size > vaddr)
+			return svm;
+	}
+
+	return NULL;
+}
+
+void __init add_static_vm_early(struct static_vm *svm)
+{
+	struct static_vm *curr_svm;
+	struct vm_struct *vm;
+	void *vaddr;
+
+	vm = &svm->vm;
+	vm_area_add_early(vm);
+	vaddr = vm->addr;
+
+	list_for_each_entry(curr_svm, &static_vmlist, list) {
+		vm = &curr_svm->vm;
+
+		if (vm->addr > vaddr)
+			break;
+	}
+	list_add_tail(&svm->list, &curr_svm->list);
+}
+
 int ioremap_page(unsigned long virt, unsigned long phys,
 		 const struct mem_type *mtype)
 {
diff --git a/arch/arm/mm/mm.h b/arch/arm/mm/mm.h
index a8ee92d..d5a4e9a 100644
--- a/arch/arm/mm/mm.h
+++ b/arch/arm/mm/mm.h
@@ -1,4 +1,6 @@
 #ifdef CONFIG_MMU
+#include <linux/list.h>
+#include <linux/vmalloc.h>
 
 /* the upper-most page table pointer */
 extern pmd_t *top_pmd;
@@ -65,6 +67,16 @@ extern void __flush_dcache_page(struct address_space *mapping, struct page *page
 /* consistent regions used by dma_alloc_attrs() */
 #define VM_ARM_DMA_CONSISTENT	0x20000000
 
+
+struct static_vm {
+	struct vm_struct vm;
+	struct list_head list;
+};
+
+extern struct list_head static_vmlist;
+extern struct static_vm *find_static_vm_vaddr(void *vaddr);
+extern __init void add_static_vm_early(struct static_vm *svm);
+
 #endif
 
 #ifdef CONFIG_ZONE_DMA
-- 
1.7.9.5

