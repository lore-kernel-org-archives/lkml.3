Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756475Ab3AaBAh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jan 2013 20:00:37 -0500
Received: from LGEMRELSE7Q.lge.com ([156.147.1.151]:55464 "EHLO
	LGEMRELSE7Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755390Ab3AaBA2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jan 2013 20:00:28 -0500
X-AuditID: 9c930197-b7ca4ae000006ba8-a0-5109c2280203
From: Joonsoo Kim <iamjoonsoo.kim@lge.com>
To: Russell King <linux@arm.linux.org.uk>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        js1304@gmail.com, Will Deacon <will.deacon@arm.com>,
        Nicolas Pitre <nico@linaro.org>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Joonsoo Kim <iamjoonsoo.kim@lge.com>
Subject: [PATCH v4 2/3] ARM: ioremap: introduce an infrastructure for static mapped area
Date: Thu, 31 Jan 2013 10:00:07 +0900
Message-Id: <1359594008-14688-3-git-send-email-iamjoonsoo.kim@lge.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1359594008-14688-1-git-send-email-iamjoonsoo.kim@lge.com>
References: <1359594008-14688-1-git-send-email-iamjoonsoo.kim@lge.com>
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
index 88fd86c..ceb34ae 100644
--- a/arch/arm/mm/ioremap.c
+++ b/arch/arm/mm/ioremap.c
@@ -39,6 +39,78 @@
 #include <asm/mach/pci.h>
 #include "mm.h"
 
+
+LIST_HEAD(static_vmlist);
+static DEFINE_RWLOCK(static_vmlist_lock);
+
+static struct static_vm *find_static_vm_paddr(phys_addr_t paddr,
+			size_t size, unsigned long flags)
+{
+	struct static_vm *svm;
+	struct vm_struct *vm;
+
+	read_lock(&static_vmlist_lock);
+	list_for_each_entry(svm, &static_vmlist, list) {
+		if (svm->flags != flags)
+			continue;
+
+		vm = &svm->vm;
+		if (vm->phys_addr > paddr ||
+			paddr + size - 1 > vm->phys_addr + vm->size - 1)
+			continue;
+
+		read_unlock(&static_vmlist_lock);
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
+	read_lock(&static_vmlist_lock);
+	list_for_each_entry(svm, &static_vmlist, list) {
+		vm = &svm->vm;
+
+		/* static_vmlist is ascending order */
+		if (vm->addr > vaddr)
+			break;
+
+		if (vm->addr <= vaddr && vm->addr + vm->size > vaddr) {
+			read_unlock(&static_vmlist_lock);
+			return svm;
+		}
+	}
+	read_unlock(&static_vmlist_lock);
+
+	return NULL;
+}
+
+void add_static_vm_early(struct static_vm *svm, unsigned long flags)
+{
+	struct static_vm *curr_svm;
+	struct vm_struct *vm;
+	void *vaddr;
+
+	vm_area_add_early(&svm->vm);
+
+	vaddr = svm->vm.addr;
+	svm->flags = flags;
+
+	write_lock(&static_vmlist_lock);
+	list_for_each_entry(curr_svm, &static_vmlist, list) {
+		vm = &curr_svm->vm;
+
+		if (vm->addr > vaddr)
+			break;
+	}
+	list_add_tail(&svm->list, &curr_svm->list);
+	write_unlock(&static_vmlist_lock);
+}
+
 int ioremap_page(unsigned long virt, unsigned long phys,
 		 const struct mem_type *mtype)
 {
diff --git a/arch/arm/mm/mm.h b/arch/arm/mm/mm.h
index a8ee92d..fb45c79 100644
--- a/arch/arm/mm/mm.h
+++ b/arch/arm/mm/mm.h
@@ -1,4 +1,6 @@
 #ifdef CONFIG_MMU
+#include <linux/list.h>
+#include <linux/vmalloc.h>
 
 /* the upper-most page table pointer */
 extern pmd_t *top_pmd;
@@ -65,6 +67,24 @@ extern void __flush_dcache_page(struct address_space *mapping, struct page *page
 /* consistent regions used by dma_alloc_attrs() */
 #define VM_ARM_DMA_CONSISTENT	0x20000000
 
+
+/* ARM specific static_vm->flags bits */
+#define STATIC_VM_MEM		0x00000001
+#define STATIC_VM_EMPTY		0x00000002
+#define STATIC_VM_MTYPE(mtype)	((mtype) << 20)
+
+#define STATIC_VM_TYPE(type, mtype) (type | STATIC_VM_MTYPE(mtype))
+
+struct static_vm {
+	struct vm_struct vm;
+	struct list_head list;
+	unsigned long flags;
+};
+
+extern struct list_head static_vmlist;
+extern struct static_vm *find_static_vm_vaddr(void *vaddr);
+extern void add_static_vm_early(struct static_vm *svm, unsigned long flags);
+
 #endif
 
 #ifdef CONFIG_ZONE_DMA
-- 
1.7.9.5

