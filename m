Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753267AbaABV4l (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Jan 2014 16:56:41 -0500
Received: from smtp.codeaurora.org ([198.145.11.231]:33150 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752478AbaABVxm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Jan 2014 16:53:42 -0500
From: Laura Abbott <lauraa@codeaurora.org>
To: Andrew Morton <akpm@linux-foundation.org>,
        Kyungmin Park <kmpark@infradead.org>, Dave Hansen <dave@sr71.net>,
        linux-mm@kvack.org, Russell King <linux@arm.linux.org.uk>
Cc: linux-kernel@vger.kernel.org, Laura Abbott <lauraa@codeaurora.org>,
        linux-arm-kernel@lists.infradead.org
Subject: [RFC PATCHv3 07/11] arm: mm: Add iotable_init_novmreserve
Date: Thu,  2 Jan 2014 13:53:25 -0800
Message-Id: <1388699609-18214-8-git-send-email-lauraa@codeaurora.org>
X-Mailer: git-send-email 1.7.8.3
In-Reply-To: <1388699609-18214-1-git-send-email-lauraa@codeaurora.org>
References: <1388699609-18214-1-git-send-email-lauraa@codeaurora.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

iotable_init is currently used by dma_contiguous_remap to remap
CMA memory appropriately. This has the side effect of reserving
the area of CMA in the vmalloc tracking structures. This is fine
under normal circumstances but it creates conflicts if we want
to track lowmem in vmalloc. Since dma_contiguous_remap is only
really concerned with the remapping, introduce iotable_init_novmreserve
to allow remapping of pages without reserving the virtual address
in vmalloc space.

Signed-off-by: Laura Abbott <lauraa@codeaurora.org>
---
 arch/arm/include/asm/mach/map.h |    2 ++
 arch/arm/mm/dma-mapping.c       |    2 +-
 arch/arm/mm/ioremap.c           |    5 +++--
 arch/arm/mm/mm.h                |    2 +-
 arch/arm/mm/mmu.c               |   17 ++++++++++++++---
 5 files changed, 21 insertions(+), 7 deletions(-)

diff --git a/arch/arm/include/asm/mach/map.h b/arch/arm/include/asm/mach/map.h
index 2fe141f..02e3509 100644
--- a/arch/arm/include/asm/mach/map.h
+++ b/arch/arm/include/asm/mach/map.h
@@ -37,6 +37,7 @@ struct map_desc {
 
 #ifdef CONFIG_MMU
 extern void iotable_init(struct map_desc *, int);
+extern void iotable_init_novmreserve(struct map_desc *, int);
 extern void vm_reserve_area_early(unsigned long addr, unsigned long size,
 				  void *caller);
 
@@ -56,6 +57,7 @@ extern int ioremap_page(unsigned long virt, unsigned long phys,
 			const struct mem_type *mtype);
 #else
 #define iotable_init(map,num)	do { } while (0)
+#define iotable_init_novmreserve(map,num)	do { } while(0)
 #define vm_reserve_area_early(a,s,c)	do { } while (0)
 #endif
 
diff --git a/arch/arm/mm/dma-mapping.c b/arch/arm/mm/dma-mapping.c
index f61a570..c4c9f4b 100644
--- a/arch/arm/mm/dma-mapping.c
+++ b/arch/arm/mm/dma-mapping.c
@@ -470,7 +470,7 @@ void __init dma_contiguous_remap(void)
 		     addr += PMD_SIZE)
 			pmd_clear(pmd_off_k(addr));
 
-		iotable_init(&map, 1);
+		iotable_init_novmreserve(&map, 1);
 	}
 }
 
diff --git a/arch/arm/mm/ioremap.c b/arch/arm/mm/ioremap.c
index f123d6e..ad92d4f 100644
--- a/arch/arm/mm/ioremap.c
+++ b/arch/arm/mm/ioremap.c
@@ -84,14 +84,15 @@ struct static_vm *find_static_vm_vaddr(void *vaddr)
 	return NULL;
 }
 
-void __init add_static_vm_early(struct static_vm *svm)
+void __init add_static_vm_early(struct static_vm *svm, bool add_to_vm)
 {
 	struct static_vm *curr_svm;
 	struct vm_struct *vm;
 	void *vaddr;
 
 	vm = &svm->vm;
-	vm_area_add_early(vm);
+	if (add_to_vm)
+		vm_area_add_early(vm);
 	vaddr = vm->addr;
 
 	list_for_each_entry(curr_svm, &static_vmlist, list) {
diff --git a/arch/arm/mm/mm.h b/arch/arm/mm/mm.h
index d5a982d..6f9d28b 100644
--- a/arch/arm/mm/mm.h
+++ b/arch/arm/mm/mm.h
@@ -75,7 +75,7 @@ struct static_vm {
 
 extern struct list_head static_vmlist;
 extern struct static_vm *find_static_vm_vaddr(void *vaddr);
-extern __init void add_static_vm_early(struct static_vm *svm);
+extern __init void add_static_vm_early(struct static_vm *svm, bool add_to_vm);
 
 #endif
 
diff --git a/arch/arm/mm/mmu.c b/arch/arm/mm/mmu.c
index 580ef2d..5450b43 100644
--- a/arch/arm/mm/mmu.c
+++ b/arch/arm/mm/mmu.c
@@ -819,7 +819,8 @@ static void __init create_mapping(struct map_desc *md)
 /*
  * Create the architecture specific mappings
  */
-void __init iotable_init(struct map_desc *io_desc, int nr)
+static void __init __iotable_init(struct map_desc *io_desc, int nr,
+					bool add_to_vm)
 {
 	struct map_desc *md;
 	struct vm_struct *vm;
@@ -840,10 +841,20 @@ void __init iotable_init(struct map_desc *io_desc, int nr)
 		vm->flags = VM_IOREMAP | VM_ARM_STATIC_MAPPING;
 		vm->flags |= VM_ARM_MTYPE(md->type);
 		vm->caller = iotable_init;
-		add_static_vm_early(svm++);
+		add_static_vm_early(svm++, add_to_vm);
 	}
 }
 
+void __init iotable_init(struct map_desc *io_desc, int nr)
+{
+	return __iotable_init(io_desc, nr, true);
+}
+
+void __init iotable_init_novmreserve(struct map_desc *io_desc, int nr)
+{
+	return __iotable_init(io_desc, nr, false);
+}
+
 void __init vm_reserve_area_early(unsigned long addr, unsigned long size,
 				  void *caller)
 {
@@ -857,7 +868,7 @@ void __init vm_reserve_area_early(unsigned long addr, unsigned long size,
 	vm->size = size;
 	vm->flags = VM_IOREMAP | VM_ARM_EMPTY_MAPPING;
 	vm->caller = caller;
-	add_static_vm_early(svm);
+	add_static_vm_early(svm, true);
 }
 
 #ifndef CONFIG_ARM_LPAE
-- 
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum,
hosted by The Linux Foundation

