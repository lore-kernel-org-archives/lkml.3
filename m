Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753552Ab3ISO4l (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Sep 2013 10:56:41 -0400
Received: from mail.skyhub.de ([78.46.96.112]:58793 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752261Ab3ISOzG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Sep 2013 10:55:06 -0400
From: Borislav Petkov <bp@alien8.de>
To: X86 ML <x86@kernel.org>
Cc: LKML <linux-kernel@vger.kernel.org>, Borislav Petkov <bp@suse.de>,
        Matt Fleming <matt@console-pimps.org>,
        Matthew Garrett <mjg59@srcf.ucam.org>,
        "H. Peter Anvin" <hpa@zytor.com>,
        James Bottomley <James.Bottomley@HansenPartnership.com>,
        Vivek Goyal <vgoyal@redhat.com>, Dave Young <dyoung@redhat.com>,
        linux-efi@vger.kernel.org
Subject: [PATCH 11/11] EFI: Runtime services virtual mapping
Date: Thu, 19 Sep 2013 16:54:54 +0200
Message-Id: <1379602494-26684-12-git-send-email-bp@alien8.de>
X-Mailer: git-send-email 1.8.4
In-Reply-To: <1379602494-26684-1-git-send-email-bp@alien8.de>
References: <1379602494-26684-1-git-send-email-bp@alien8.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Borislav Petkov <bp@suse.de>

We map the EFI regions needed for runtime services contiguously on
virtual addresses starting from -4G down for a total max space of 64G.
This way, we provide for stable runtime services addresses across
kernels so that a kexec'd kernel can still use them.

This way, they're mapped in a separate pagetable so that we don't
pollute the kernel namespace (you can see how the whole ioremapping and
saving and restoring of PGDs is gone now).

Signed-off-by: Borislav Petkov <bp@suse.de>
---
 arch/x86/include/asm/efi.h           | 58 +++++++++++++++-------
 arch/x86/include/asm/pgtable_types.h |  3 +-
 arch/x86/platform/efi/efi.c          | 95 +++++++++++++++++++++---------------
 arch/x86/platform/efi/efi_64.c       | 56 +--------------------
 arch/x86/platform/efi/efi_stub_64.S  | 47 ++++++++++++++++++
 5 files changed, 149 insertions(+), 110 deletions(-)

diff --git a/arch/x86/include/asm/efi.h b/arch/x86/include/asm/efi.h
index 0062a0125041..745c8d27265b 100644
--- a/arch/x86/include/asm/efi.h
+++ b/arch/x86/include/asm/efi.h
@@ -39,6 +39,8 @@ extern unsigned long asmlinkage efi_call_phys(void *, ...);
 
 #else /* !CONFIG_X86_32 */
 
+#include <linux/sched.h>
+
 #define EFI_LOADER_SIGNATURE	"EL64"
 
 extern u64 efi_call0(void *fp);
@@ -51,6 +53,21 @@ extern u64 efi_call5(void *fp, u64 arg1, u64 arg2, u64 arg3,
 extern u64 efi_call6(void *fp, u64 arg1, u64 arg2, u64 arg3,
 		     u64 arg4, u64 arg5, u64 arg6);
 
+/*
+ * Add low kernel mappings for passing arguments to EFI functions.
+ */
+static inline void efi_sync_low_kernel_mappings(void)
+{
+	unsigned num_pgds;
+	pgd_t *pgd = (pgd_t *)__va(real_mode_header->trampoline_pgd);
+
+	num_pgds = pgd_index(VMALLOC_START - 1) - pgd_index(PAGE_OFFSET);
+
+	memcpy(pgd + pgd_index(PAGE_OFFSET),
+		init_mm.pgd + pgd_index(PAGE_OFFSET),
+		sizeof(pgd_t) * num_pgds);
+}
+
 #define efi_call_phys0(f)			\
 	efi_call0((f))
 #define efi_call_phys1(f, a1)			\
@@ -69,24 +86,31 @@ extern u64 efi_call6(void *fp, u64 arg1, u64 arg2, u64 arg3,
 	efi_call6((f), (u64)(a1), (u64)(a2), (u64)(a3),		\
 		  (u64)(a4), (u64)(a5), (u64)(a6))
 
+#define _efi_call_virtX(x, f, ...)					\
+({									\
+	efi_status_t __s;						\
+									\
+	efi_sync_low_kernel_mappings();					\
+	preempt_disable();						\
+	__s = efi_call##x((void *)efi.systab->runtime->f, __VA_ARGS__);	\
+	preempt_enable();						\
+	__s;								\
+})
+
 #define efi_call_virt0(f)				\
-	efi_call0((efi.systab->runtime->f))
-#define efi_call_virt1(f, a1)					\
-	efi_call1((efi.systab->runtime->f), (u64)(a1))
-#define efi_call_virt2(f, a1, a2)					\
-	efi_call2((efi.systab->runtime->f), (u64)(a1), (u64)(a2))
-#define efi_call_virt3(f, a1, a2, a3)					\
-	efi_call3((efi.systab->runtime->f), (u64)(a1), (u64)(a2), \
-		  (u64)(a3))
-#define efi_call_virt4(f, a1, a2, a3, a4)				\
-	efi_call4((efi.systab->runtime->f), (u64)(a1), (u64)(a2), \
-		  (u64)(a3), (u64)(a4))
-#define efi_call_virt5(f, a1, a2, a3, a4, a5)				\
-	efi_call5((efi.systab->runtime->f), (u64)(a1), (u64)(a2), \
-		  (u64)(a3), (u64)(a4), (u64)(a5))
-#define efi_call_virt6(f, a1, a2, a3, a4, a5, a6)			\
-	efi_call6((efi.systab->runtime->f), (u64)(a1), (u64)(a2), \
-		  (u64)(a3), (u64)(a4), (u64)(a5), (u64)(a6))
+	_efi_call_virtX(0, f)
+#define efi_call_virt1(f, a1)				\
+	_efi_call_virtX(1, f, (u64)(a1))
+#define efi_call_virt2(f, a1, a2)			\
+	_efi_call_virtX(2, f, (u64)(a1), (u64)(a2))
+#define efi_call_virt3(f, a1, a2, a3)			\
+	_efi_call_virtX(3, f, (u64)(a1), (u64)(a2), (u64)(a3))
+#define efi_call_virt4(f, a1, a2, a3, a4)		\
+	_efi_call_virtX(4, f, (u64)(a1), (u64)(a2), (u64)(a3), (u64)(a4))
+#define efi_call_virt5(f, a1, a2, a3, a4, a5)		\
+	_efi_call_virtX(5, f, (u64)(a1), (u64)(a2), (u64)(a3), (u64)(a4), (u64)(a5))
+#define efi_call_virt6(f, a1, a2, a3, a4, a5, a6)	\
+	_efi_call_virtX(6, f, (u64)(a1), (u64)(a2), (u64)(a3), (u64)(a4), (u64)(a5), (u64)(a6))
 
 extern void __iomem *efi_ioremap(unsigned long addr, unsigned long size,
 				 u32 type, u64 attribute);
diff --git a/arch/x86/include/asm/pgtable_types.h b/arch/x86/include/asm/pgtable_types.h
index 0ecac257fb26..a83aa44bb1fb 100644
--- a/arch/x86/include/asm/pgtable_types.h
+++ b/arch/x86/include/asm/pgtable_types.h
@@ -382,7 +382,8 @@ static inline void update_page_count(int level, unsigned long pages) { }
  */
 extern pte_t *lookup_address(unsigned long address, unsigned int *level);
 extern phys_addr_t slow_virt_to_phys(void *__address);
-
+extern int kernel_map_pages_in_pgd(pgd_t *pgd, u64 pfn, unsigned long address,
+				   unsigned numpages, unsigned long page_flags);
 #endif	/* !__ASSEMBLY__ */
 
 #endif /* _ASM_X86_PGTABLE_DEFS_H */
diff --git a/arch/x86/platform/efi/efi.c b/arch/x86/platform/efi/efi.c
index 538c1e6b7b2c..9c54ce5b9975 100644
--- a/arch/x86/platform/efi/efi.c
+++ b/arch/x86/platform/efi/efi.c
@@ -12,6 +12,8 @@
  *	Bibo Mao <bibo.mao@intel.com>
  *	Chandramouli Narayanan <mouli@linux.intel.com>
  *	Huang Ying <ying.huang@intel.com>
+ * Copyright (C) 2013 SuSE Labs
+ * 	Borislav Petkov <bp@suse.de> - runtime services VA mapping
  *
  * Copied from efi_32.c to eliminate the duplicated code between EFI
  * 32/64 support code. --ying 2007-10-26
@@ -60,6 +62,13 @@
 
 static efi_char16_t efi_dummy_name[6] = { 'D', 'U', 'M', 'M', 'Y', 0 };
 
+/*
+ * We allocate runtime services regions top-down, starting from -4G, i.e.
+ * 0xffff_ffff_0000_0000 and limit EFI VA mapping space to 64G.
+ */
+static unsigned long efi_va = -4 * (1UL << 30);
+#define EFI_VA_END	    (-68 * (1UL << 30))
+
 struct efi __read_mostly efi = {
 	.mps        = EFI_INVALID_TABLE_ADDR,
 	.acpi       = EFI_INVALID_TABLE_ADDR,
@@ -81,6 +90,16 @@ static efi_system_table_t efi_systab __initdata;
 unsigned long x86_efi_facility;
 
 /*
+ * Scratch space used for switching the pagetable in the EFI stub
+ */
+struct efi_scratch {
+	u64 r15;
+	u64 prev_cr3;
+	pgd_t *efi_pgt;
+};
+extern struct efi_scratch efi_scratch;
+
+/*
  * Returns 1 if 'facility' is enabled, 0 otherwise.
  */
 int efi_enabled(int facility)
@@ -797,22 +816,6 @@ void __init efi_set_executable(efi_memory_desc_t *md, bool executable)
 		set_memory_nx(addr, npages);
 }
 
-static void __init runtime_code_page_mkexec(void)
-{
-	efi_memory_desc_t *md;
-	void *p;
-
-	/* Make EFI runtime service code area executable */
-	for (p = memmap.map; p < memmap.map_end; p += memmap.desc_size) {
-		md = p;
-
-		if (md->type != EFI_RUNTIME_SERVICES_CODE)
-			continue;
-
-		efi_set_executable(md, true);
-	}
-}
-
 /*
  * We can't ioremap data in EFI boot services RAM, because we've already mapped
  * it as RAM.  So, look it up in the existing EFI memory map instead.  Only
@@ -851,6 +854,23 @@ void efi_memory_uc(u64 addr, unsigned long size)
 	set_memory_uc(addr, npages);
 }
 
+static void __init __map_region(efi_memory_desc_t *md, u64 va)
+{
+	pgd_t *pgd = (pgd_t *)__va(real_mode_header->trampoline_pgd);
+	unsigned long pf = 0, size;
+	u64 end;
+
+	if (!(md->attribute & EFI_MEMORY_WB))
+		pf |= _PAGE_PCD;
+
+	size = md->num_pages << PAGE_SHIFT;
+	end  = va + size;
+
+	if(kernel_map_pages_in_pgd(pgd, md->phys_addr, va, md->num_pages, pf))
+		pr_warning("Error mapping PA 0x%llx -> VA 0x%llx!\n",
+			   md->phys_addr, va);
+}
+
 /*
  * This function will switch the EFI runtime services to virtual mode.
  * Essentially, look through the EFI memmap and map every region that
@@ -862,10 +882,10 @@ void efi_memory_uc(u64 addr, unsigned long size)
 void __init efi_enter_virtual_mode(void)
 {
 	efi_memory_desc_t *md, *prev_md = NULL;
-	efi_status_t status;
+	void *p, *new_memmap = NULL;
 	unsigned long size;
-	u64 end, systab, start_pfn, end_pfn;
-	void *p, *va, *new_memmap = NULL;
+	efi_status_t status;
+	u64 end, systab, new_va;
 	int count = 0;
 
 	efi.systab = NULL;
@@ -874,7 +894,6 @@ void __init efi_enter_virtual_mode(void)
 	 * We don't do virtual mode, since we don't do runtime services, on
 	 * non-native EFI
 	 */
-
 	if (!efi_is_native()) {
 		efi_unmap_memmap();
 		return;
@@ -914,33 +933,31 @@ void __init efi_enter_virtual_mode(void)
 		    md->type != EFI_BOOT_SERVICES_DATA)
 			continue;
 
+		/* Do the 1:1 map */
+		__map_region(md, md->phys_addr);
+
 		size = md->num_pages << PAGE_SHIFT;
 		end = md->phys_addr + size;
 
-		start_pfn = PFN_DOWN(md->phys_addr);
-		end_pfn = PFN_UP(end);
-		if (pfn_range_is_mapped(start_pfn, end_pfn)) {
-			va = __va(md->phys_addr);
-
-			if (!(md->attribute & EFI_MEMORY_WB))
-				efi_memory_uc((u64)(unsigned long)va, size);
-		} else
-			va = efi_ioremap(md->phys_addr, size,
-					 md->type, md->attribute);
-
-		md->virt_addr = (u64) (unsigned long) va;
-
-		if (!va) {
-			pr_err("ioremap of 0x%llX failed!\n",
-			       (unsigned long long)md->phys_addr);
+		new_va = efi_va - size;
+		if (new_va < EFI_VA_END) {
+			pr_warning(FW_WARN "VA address range overflow!\n");
 			continue;
 		}
 
+		efi_va -= size;
+
+		/* Do the VA map */
+		__map_region(md, new_va);
+		md->virt_addr = new_va;
+
 		systab = (u64) (unsigned long) efi_phys.systab;
 		if (md->phys_addr <= systab && systab < end) {
 			systab += md->virt_addr - md->phys_addr;
+
 			efi.systab = (efi_system_table_t *) (unsigned long) systab;
 		}
+
 		new_memmap = krealloc(new_memmap,
 				      (count + 1) * memmap.desc_size,
 				      GFP_KERNEL);
@@ -949,8 +966,12 @@ void __init efi_enter_virtual_mode(void)
 		count++;
 	}
 
+	efi_scratch.efi_pgt = (pgd_t *)(unsigned long)real_mode_header->trampoline_pgd;
+
 	BUG_ON(!efi.systab);
 
+	efi_sync_low_kernel_mappings();
+
 	status = phys_efi_set_virtual_address_map(
 		memmap.desc_size * count,
 		memmap.desc_size,
@@ -983,8 +1004,6 @@ void __init efi_enter_virtual_mode(void)
 	efi.query_variable_info = virt_efi_query_variable_info;
 	efi.update_capsule = virt_efi_update_capsule;
 	efi.query_capsule_caps = virt_efi_query_capsule_caps;
-	if (__supported_pte_mask & _PAGE_NX)
-		runtime_code_page_mkexec();
 
 	kfree(new_memmap);
 
diff --git a/arch/x86/platform/efi/efi_64.c b/arch/x86/platform/efi/efi_64.c
index 39a0e7f1f0a3..a16fa9a6cf3e 100644
--- a/arch/x86/platform/efi/efi_64.c
+++ b/arch/x86/platform/efi/efi_64.c
@@ -39,60 +39,8 @@
 #include <asm/cacheflush.h>
 #include <asm/fixmap.h>
 
-static pgd_t *save_pgd __initdata;
-static unsigned long efi_flags __initdata;
-
-static void __init early_code_mapping_set_exec(int executable)
-{
-	efi_memory_desc_t *md;
-	void *p;
-
-	if (!(__supported_pte_mask & _PAGE_NX))
-		return;
-
-	/* Make EFI service code area executable */
-	for (p = memmap.map; p < memmap.map_end; p += memmap.desc_size) {
-		md = p;
-		if (md->type == EFI_RUNTIME_SERVICES_CODE ||
-		    md->type == EFI_BOOT_SERVICES_CODE)
-			efi_set_executable(md, executable);
-	}
-}
-
-void __init efi_call_phys_prelog(void)
-{
-	unsigned long vaddress;
-	int pgd;
-	int n_pgds;
-
-	early_code_mapping_set_exec(1);
-	local_irq_save(efi_flags);
-
-	n_pgds = DIV_ROUND_UP((max_pfn << PAGE_SHIFT), PGDIR_SIZE);
-	save_pgd = kmalloc(n_pgds * sizeof(pgd_t), GFP_KERNEL);
-
-	for (pgd = 0; pgd < n_pgds; pgd++) {
-		save_pgd[pgd] = *pgd_offset_k(pgd * PGDIR_SIZE);
-		vaddress = (unsigned long)__va(pgd * PGDIR_SIZE);
-		set_pgd(pgd_offset_k(pgd * PGDIR_SIZE), *pgd_offset_k(vaddress));
-	}
-	__flush_tlb_all();
-}
-
-void __init efi_call_phys_epilog(void)
-{
-	/*
-	 * After the lock is released, the original page table is restored.
-	 */
-	int pgd;
-	int n_pgds = DIV_ROUND_UP((max_pfn << PAGE_SHIFT) , PGDIR_SIZE);
-	for (pgd = 0; pgd < n_pgds; pgd++)
-		set_pgd(pgd_offset_k(pgd * PGDIR_SIZE), save_pgd[pgd]);
-	kfree(save_pgd);
-	__flush_tlb_all();
-	local_irq_restore(efi_flags);
-	early_code_mapping_set_exec(0);
-}
+void __init efi_call_phys_prelog(void) {}
+void __init efi_call_phys_epilog(void) {}
 
 void __iomem *__init efi_ioremap(unsigned long phys_addr, unsigned long size,
 				 u32 type, u64 attribute)
diff --git a/arch/x86/platform/efi/efi_stub_64.S b/arch/x86/platform/efi/efi_stub_64.S
index 4c07ccab8146..f3bc4127f9e8 100644
--- a/arch/x86/platform/efi/efi_stub_64.S
+++ b/arch/x86/platform/efi/efi_stub_64.S
@@ -34,10 +34,41 @@
 	mov %rsi, %cr0;			\
 	mov (%rsp), %rsp
 
+	/* stolen from gcc */
+	.macro FLUSH_TLB_ALL
+	movq %r15, efi_scratch(%rip)
+	movq %r14, efi_scratch+8(%rip)
+	movq %cr4, %r15
+	movq %r15, %r14
+	andb $0x7f, %r14b
+	movq %r14, %cr4
+	movq %r15, %cr4
+	movq efi_scratch+8(%rip), %r14
+	movq efi_scratch(%rip), %r15
+	.endm
+
+	.macro SWITCH_PGT
+	movq %r15, efi_scratch(%rip)		# r15
+	# save previous CR3
+	movq %cr3, %r15
+	movq %r15, efi_scratch+8(%rip)		# prev_cr3
+	movq efi_scratch+16(%rip), %r15		# EFI pgt
+	movq %r15, %cr3
+	.endm
+
+	.macro RESTORE_PGT
+	movq efi_scratch+8(%rip), %r15
+	movq %r15, %cr3
+	movq efi_scratch(%rip), %r15
+	FLUSH_TLB_ALL
+	.endm
+
 ENTRY(efi_call0)
 	SAVE_XMM
 	subq $32, %rsp
+	SWITCH_PGT
 	call *%rdi
+	RESTORE_PGT
 	addq $32, %rsp
 	RESTORE_XMM
 	ret
@@ -47,7 +78,9 @@ ENTRY(efi_call1)
 	SAVE_XMM
 	subq $32, %rsp
 	mov  %rsi, %rcx
+	SWITCH_PGT
 	call *%rdi
+	RESTORE_PGT
 	addq $32, %rsp
 	RESTORE_XMM
 	ret
@@ -57,7 +90,9 @@ ENTRY(efi_call2)
 	SAVE_XMM
 	subq $32, %rsp
 	mov  %rsi, %rcx
+	SWITCH_PGT
 	call *%rdi
+	RESTORE_PGT
 	addq $32, %rsp
 	RESTORE_XMM
 	ret
@@ -68,7 +103,9 @@ ENTRY(efi_call3)
 	subq $32, %rsp
 	mov  %rcx, %r8
 	mov  %rsi, %rcx
+	SWITCH_PGT
 	call *%rdi
+	RESTORE_PGT
 	addq $32, %rsp
 	RESTORE_XMM
 	ret
@@ -80,7 +117,9 @@ ENTRY(efi_call4)
 	mov %r8, %r9
 	mov %rcx, %r8
 	mov %rsi, %rcx
+	SWITCH_PGT
 	call *%rdi
+	RESTORE_PGT
 	addq $32, %rsp
 	RESTORE_XMM
 	ret
@@ -93,7 +132,9 @@ ENTRY(efi_call5)
 	mov %r8, %r9
 	mov %rcx, %r8
 	mov %rsi, %rcx
+	SWITCH_PGT
 	call *%rdi
+	RESTORE_PGT
 	addq $48, %rsp
 	RESTORE_XMM
 	ret
@@ -109,8 +150,14 @@ ENTRY(efi_call6)
 	mov %r8, %r9
 	mov %rcx, %r8
 	mov %rsi, %rcx
+	SWITCH_PGT
 	call *%rdi
+	RESTORE_PGT
 	addq $48, %rsp
 	RESTORE_XMM
 	ret
 ENDPROC(efi_call6)
+
+	.data
+ENTRY(efi_scratch)
+	.fill 3,8,0
-- 
1.8.4

