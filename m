Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756543Ab3BEAcg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Feb 2013 19:32:36 -0500
Received: from LGEMRELSE6Q.lge.com ([156.147.1.121]:58526 "EHLO
	LGEMRELSE6Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756051Ab3BEAb6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Feb 2013 19:31:58 -0500
X-AuditID: 9c930179-b7c24ae00000119c-68-511052faf7e4
From: Joonsoo Kim <iamjoonsoo.kim@lge.com>
To: Russell King <linux@arm.linux.org.uk>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        js1304@gmail.com, Will Deacon <will.deacon@arm.com>,
        Nicolas Pitre <nico@linaro.org>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Joonsoo Kim <iamjoonsoo.kim@lge.com>
Subject: [PATCH v5 3/3] ARM: mm: use static_vm for managing static mapped areas
Date: Tue,  5 Feb 2013 09:31:54 +0900
Message-Id: <1360024314-1895-4-git-send-email-iamjoonsoo.kim@lge.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1360024314-1895-1-git-send-email-iamjoonsoo.kim@lge.com>
References: <1360024314-1895-1-git-send-email-iamjoonsoo.kim@lge.com>
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

A static mapped area is ARM-specific, so it is better not to use
generic vmalloc data structure, that is, vmlist and vmlist_lock
for managing static mapped area. And it causes some needless overhead and
reducing this overhead is better idea.

Now, we have newly introduced static_vm infrastructure.
With it, we don't need to iterate all mapped areas. Instead, we just
iterate static mapped areas. It helps to reduce an overhead of finding
matched area. And architecture dependency on vmalloc layer is removed,
so it will help to maintainability for vmalloc layer.

Signed-off-by: Joonsoo Kim <iamjoonsoo.kim@lge.com>

diff --git a/arch/arm/mm/ioremap.c b/arch/arm/mm/ioremap.c
index 904c15e..c7fef4b 100644
--- a/arch/arm/mm/ioremap.c
+++ b/arch/arm/mm/ioremap.c
@@ -261,13 +261,14 @@ void __iomem * __arm_ioremap_pfn_caller(unsigned long pfn,
 	const struct mem_type *type;
 	int err;
 	unsigned long addr;
- 	struct vm_struct * area;
+	struct vm_struct *area;
+	phys_addr_t paddr = __pfn_to_phys(pfn);
 
 #ifndef CONFIG_ARM_LPAE
 	/*
 	 * High mappings must be supersection aligned
 	 */
-	if (pfn >= 0x100000 && (__pfn_to_phys(pfn) & ~SUPERSECTION_MASK))
+	if (pfn >= 0x100000 && (paddr & ~SUPERSECTION_MASK))
 		return NULL;
 #endif
 
@@ -283,24 +284,16 @@ void __iomem * __arm_ioremap_pfn_caller(unsigned long pfn,
 	/*
 	 * Try to reuse one of the static mapping whenever possible.
 	 */
-	read_lock(&vmlist_lock);
-	for (area = vmlist; area; area = area->next) {
-		if (!size || (sizeof(phys_addr_t) == 4 && pfn >= 0x100000))
-			break;
-		if (!(area->flags & VM_ARM_STATIC_MAPPING))
-			continue;
-		if ((area->flags & VM_ARM_MTYPE_MASK) != VM_ARM_MTYPE(mtype))
-			continue;
-		if (__phys_to_pfn(area->phys_addr) > pfn ||
-		    __pfn_to_phys(pfn) + size-1 > area->phys_addr + area->size-1)
-			continue;
-		/* we can drop the lock here as we know *area is static */
-		read_unlock(&vmlist_lock);
-		addr = (unsigned long)area->addr;
-		addr += __pfn_to_phys(pfn) - area->phys_addr;
-		return (void __iomem *) (offset + addr);
+	if (size && !((sizeof(phys_addr_t) == 4 && pfn >= 0x100000))) {
+		struct static_vm *svm;
+
+		svm = find_static_vm_paddr(paddr, size, mtype);
+		if (svm) {
+			addr = (unsigned long)svm->vm.addr;
+			addr += paddr - svm->vm.phys_addr;
+			return (void __iomem *) (offset + addr);
+		}
 	}
-	read_unlock(&vmlist_lock);
 
 	/*
 	 * Don't allow RAM to be mapped - this causes problems with ARMv6+
@@ -312,21 +305,21 @@ void __iomem * __arm_ioremap_pfn_caller(unsigned long pfn,
  	if (!area)
  		return NULL;
  	addr = (unsigned long)area->addr;
-	area->phys_addr = __pfn_to_phys(pfn);
+	area->phys_addr = paddr;
 
 #if !defined(CONFIG_SMP) && !defined(CONFIG_ARM_LPAE)
 	if (DOMAIN_IO == 0 &&
 	    (((cpu_architecture() >= CPU_ARCH_ARMv6) && (get_cr() & CR_XP)) ||
 	       cpu_is_xsc3()) && pfn >= 0x100000 &&
-	       !((__pfn_to_phys(pfn) | size | addr) & ~SUPERSECTION_MASK)) {
+	       !((paddr | size | addr) & ~SUPERSECTION_MASK)) {
 		area->flags |= VM_ARM_SECTION_MAPPING;
 		err = remap_area_supersections(addr, pfn, size, type);
-	} else if (!((__pfn_to_phys(pfn) | size | addr) & ~PMD_MASK)) {
+	} else if (!((paddr | size | addr) & ~PMD_MASK)) {
 		area->flags |= VM_ARM_SECTION_MAPPING;
 		err = remap_area_sections(addr, pfn, size, type);
 	} else
 #endif
-		err = ioremap_page_range(addr, addr + size, __pfn_to_phys(pfn),
+		err = ioremap_page_range(addr, addr + size, paddr,
 					 __pgprot(type->prot_pte));
 
 	if (err) {
@@ -410,34 +403,28 @@ __arm_ioremap_exec(unsigned long phys_addr, size_t size, bool cached)
 void __iounmap(volatile void __iomem *io_addr)
 {
 	void *addr = (void *)(PAGE_MASK & (unsigned long)io_addr);
-	struct vm_struct *vm;
+	struct static_vm *svm;
+
+	/* If this is a static mapping, we must leave it alone */
+	svm = find_static_vm_vaddr(addr);
+	if (svm)
+		return;
 
-	read_lock(&vmlist_lock);
-	for (vm = vmlist; vm; vm = vm->next) {
-		if (vm->addr > addr)
-			break;
-		if (!(vm->flags & VM_IOREMAP))
-			continue;
-		/* If this is a static mapping we must leave it alone */
-		if ((vm->flags & VM_ARM_STATIC_MAPPING) &&
-		    (vm->addr <= addr) && (vm->addr + vm->size > addr)) {
-			read_unlock(&vmlist_lock);
-			return;
-		}
 #if !defined(CONFIG_SMP) && !defined(CONFIG_ARM_LPAE)
+	{
+		struct vm_struct *vm;
+
+		vm = find_vm_area(addr);
+
 		/*
 		 * If this is a section based mapping we need to handle it
 		 * specially as the VM subsystem does not know how to handle
 		 * such a beast.
 		 */
-		if ((vm->addr == addr) &&
-		    (vm->flags & VM_ARM_SECTION_MAPPING)) {
+		if (vm && (vm->flags & VM_ARM_SECTION_MAPPING))
 			unmap_area_sections((unsigned long)vm->addr, vm->size);
-			break;
-		}
-#endif
 	}
-	read_unlock(&vmlist_lock);
+#endif
 
 	vunmap(addr);
 }
diff --git a/arch/arm/mm/mmu.c b/arch/arm/mm/mmu.c
index ce328c7..b2c0356 100644
--- a/arch/arm/mm/mmu.c
+++ b/arch/arm/mm/mmu.c
@@ -757,21 +757,24 @@ void __init iotable_init(struct map_desc *io_desc, int nr)
 {
 	struct map_desc *md;
 	struct vm_struct *vm;
+	struct static_vm *svm;
 
 	if (!nr)
 		return;
 
-	vm = early_alloc_aligned(sizeof(*vm) * nr, __alignof__(*vm));
+	svm = early_alloc_aligned(sizeof(*svm) * nr, __alignof__(*svm));
 
 	for (md = io_desc; nr; md++, nr--) {
 		create_mapping(md);
+
+		vm = &svm->vm;
 		vm->addr = (void *)(md->virtual & PAGE_MASK);
 		vm->size = PAGE_ALIGN(md->length + (md->virtual & ~PAGE_MASK));
 		vm->phys_addr = __pfn_to_phys(md->pfn);
 		vm->flags = VM_IOREMAP | VM_ARM_STATIC_MAPPING;
 		vm->flags |= VM_ARM_MTYPE(md->type);
 		vm->caller = iotable_init;
-		vm_area_add_early(vm++);
+		add_static_vm_early(svm++);
 	}
 }
 
@@ -779,13 +782,16 @@ void __init vm_reserve_area_early(unsigned long addr, unsigned long size,
 				  void *caller)
 {
 	struct vm_struct *vm;
+	struct static_vm *svm;
+
+	svm = early_alloc_aligned(sizeof(*svm), __alignof__(*svm));
 
-	vm = early_alloc_aligned(sizeof(*vm), __alignof__(*vm));
+	vm = &svm->vm;
 	vm->addr = (void *)addr;
 	vm->size = size;
 	vm->flags = VM_IOREMAP | VM_ARM_EMPTY_MAPPING;
 	vm->caller = caller;
-	vm_area_add_early(vm);
+	add_static_vm_early(svm);
 }
 
 #ifndef CONFIG_ARM_LPAE
@@ -810,14 +816,13 @@ static void __init pmd_empty_section_gap(unsigned long addr)
 
 static void __init fill_pmd_gaps(void)
 {
+	struct static_vm *svm;
 	struct vm_struct *vm;
 	unsigned long addr, next = 0;
 	pmd_t *pmd;
 
-	/* we're still single threaded hence no lock needed here */
-	for (vm = vmlist; vm; vm = vm->next) {
-		if (!(vm->flags & (VM_ARM_STATIC_MAPPING | VM_ARM_EMPTY_MAPPING)))
-			continue;
+	list_for_each_entry(svm, &static_vmlist, list) {
+		vm = &svm->vm;
 		addr = (unsigned long)vm->addr;
 		if (addr < next)
 			continue;
@@ -859,17 +864,12 @@ static void __init pci_reserve_io(void)
 {
 	struct vm_struct *vm;
 	unsigned long addr;
+	struct static_vm *svm;
 
-	/* we're still single threaded hence no lock needed here */
-	for (vm = vmlist; vm; vm = vm->next) {
-		if (!(vm->flags & VM_ARM_STATIC_MAPPING))
-			continue;
-		addr = (unsigned long)vm->addr;
-		addr &= ~(SZ_2M - 1);
-		if (addr == PCI_IO_VIRT_BASE)
-			return;
+	svm = find_static_vm_vaddr((void *)PCI_IO_VIRT_BASE);
+	if (svm)
+		return;
 
-	}
 	vm_reserve_area_early(PCI_IO_VIRT_BASE, SZ_2M, pci_reserve_io);
 }
 #else
-- 
1.7.9.5

