Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756771Ab3JHQsm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Oct 2013 12:48:42 -0400
Received: from mail.skyhub.de ([78.46.96.112]:43608 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756451Ab3JHQsi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Oct 2013 12:48:38 -0400
Date: Tue, 8 Oct 2013 18:48:31 +0200
From: Borislav Petkov <bp@alien8.de>
To: X86 ML <x86@kernel.org>
Cc: LKML <linux-kernel@vger.kernel.org>, Borislav Petkov <bp@suse.de>,
        Matt Fleming <matt@console-pimps.org>,
        Matthew Garrett <mjg59@srcf.ucam.org>,
        "H. Peter Anvin" <hpa@zytor.com>,
        James Bottomley <James.Bottomley@HansenPartnership.com>,
        Vivek Goyal <vgoyal@redhat.com>, Dave Young <dyoung@redhat.com>,
        linux-efi@vger.kernel.org, fwts-devel@lists.ubuntu.com
Subject: [PATCH 12/12] EFI: Runtime services virtual mapping
Message-ID: <20131008164831.GD16793@pd.tnic>
References: <1379602494-26684-1-git-send-email-bp@alien8.de>
 <20131008164551.GB16793@pd.tnic>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20131008164551.GB16793@pd.tnic>
User-Agent: Mutt/1.5.21 (2010-09-15)
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

Also, add a chicken bit called "efi=old_map" which can be used as a
fallback to the old runtime services mapping method in case there's some
b0rkage with a particular EFI implementation (haha, it is hard to hold
up the sarcasm here...).

Add UEFI RT VA space to Documentation/x86/x86_64/mm.txt, while at it.

Signed-off-by: Borislav Petkov <bp@suse.de>
---
 Documentation/x86/x86_64/mm.txt      |  7 +++
 arch/x86/include/asm/efi.h           | 47 ++++++++++++-------
 arch/x86/include/asm/pgtable_types.h |  3 +-
 arch/x86/platform/efi/efi.c          | 91 ++++++++++++++++++++++++++----------
 arch/x86/platform/efi/efi_32.c       |  8 +++-
 arch/x86/platform/efi/efi_64.c       | 83 ++++++++++++++++++++++++++++++++
 arch/x86/platform/efi/efi_stub_64.S  | 54 +++++++++++++++++++++
 include/linux/efi.h                  |  1 +
 8 files changed, 251 insertions(+), 43 deletions(-)

diff --git a/Documentation/x86/x86_64/mm.txt b/Documentation/x86/x86_64/mm.txt
index 881582f75c9c..c584a51add15 100644
--- a/Documentation/x86/x86_64/mm.txt
+++ b/Documentation/x86/x86_64/mm.txt
@@ -28,4 +28,11 @@ reference.
 Current X86-64 implementations only support 40 bits of address space,
 but we support up to 46 bits. This expands into MBZ space in the page tables.
 
+->trampoline_pgd:
+
+We map EFI runtime services in the aforementioned PGD in the virtual
+range of 64Gb (arbitrarily set, can be raised if needed)
+
+0xffffffef00000000 - 0xffffffff00000000
+
 -Andi Kleen, Jul 2004
diff --git a/arch/x86/include/asm/efi.h b/arch/x86/include/asm/efi.h
index 0062a0125041..c70714447a8f 100644
--- a/arch/x86/include/asm/efi.h
+++ b/arch/x86/include/asm/efi.h
@@ -39,6 +39,9 @@ extern unsigned long asmlinkage efi_call_phys(void *, ...);
 
 #else /* !CONFIG_X86_32 */
 
+extern u64 efi_va;
+
+#define EFI_VA_END		(-68 * (1UL << 30))
 #define EFI_LOADER_SIGNATURE	"EL64"
 
 extern u64 efi_call0(void *fp);
@@ -69,24 +72,31 @@ extern u64 efi_call6(void *fp, u64 arg1, u64 arg2, u64 arg3,
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
@@ -101,6 +111,9 @@ extern void efi_call_phys_prelog(void);
 extern void efi_call_phys_epilog(void);
 extern void efi_unmap_memmap(void);
 extern void efi_memory_uc(u64 addr, unsigned long size);
+extern void __init efi_map_region(efi_memory_desc_t *md);
+extern void efi_sync_low_kernel_mappings(void);
+extern void __init old_map_region(efi_memory_desc_t *md);
 
 #ifdef CONFIG_EFI
 
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
index 16996aba5012..91d4fac94e67 100644
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
@@ -55,6 +57,12 @@
 
 #define EFI_MIN_RESERVE 5120
 
+/*
+ * We allocate runtime services regions bottom-up, starting from -4G, i.e.
+ * 0xffff_ffff_0000_0000 and limit EFI VA mapping space to 64G.
+ */
+u64 efi_va		= -4 * (1UL << 30);
+
 #define EFI_DUMMY_GUID \
 	EFI_GUID(0x4424ac57, 0xbe4b, 0x47dd, 0x9e, 0x97, 0xed, 0x50, 0xf0, 0x9f, 0x92, 0xa9)
 
@@ -81,6 +89,17 @@ static efi_system_table_t efi_systab __initdata;
 unsigned long x86_efi_facility;
 
 /*
+ * Scratch space used for switching the pagetable in the EFI stub
+ */
+struct efi_scratch {
+	u64 r15;
+	u64 prev_cr3;
+	pgd_t *efi_pgt;
+	bool use_pgd;
+};
+extern struct efi_scratch efi_scratch;
+
+/*
  * Returns 1 if 'facility' is enabled, 0 otherwise.
  */
 int efi_enabled(int facility)
@@ -851,6 +870,31 @@ void efi_memory_uc(u64 addr, unsigned long size)
 	set_memory_uc(addr, npages);
 }
 
+void __init old_map_region(efi_memory_desc_t *md)
+{
+	u64 start_pfn, end_pfn, end;
+	unsigned long size;
+	void *va;
+
+	start_pfn = PFN_DOWN(md->phys_addr);
+	size	  = md->num_pages << PAGE_SHIFT;
+	end	  = md->phys_addr + size;
+	end_pfn   = PFN_UP(end);
+
+	if (pfn_range_is_mapped(start_pfn, end_pfn)) {
+		va = __va(md->phys_addr);
+
+		if (!(md->attribute & EFI_MEMORY_WB))
+			efi_memory_uc((u64)(unsigned long)va, size);
+	} else
+		va = efi_ioremap(md->phys_addr, size,
+				 md->type, md->attribute);
+
+	md->virt_addr = (u64) (unsigned long) va;
+	if (!va)
+		pr_err("ioremap of 0x%llX failed!\n",
+		       (unsigned long long)md->phys_addr);
+}
 /*
  * This function will switch the EFI runtime services to virtual mode.
  * Essentially, look through the EFI memmap and map every region that
@@ -862,10 +906,10 @@ void efi_memory_uc(u64 addr, unsigned long size)
 void __init efi_enter_virtual_mode(void)
 {
 	efi_memory_desc_t *md, *prev_md = NULL;
-	efi_status_t status;
+	void *p, *new_memmap = NULL;
 	unsigned long size;
-	u64 end, systab, start_pfn, end_pfn;
-	void *p, *va, *new_memmap = NULL;
+	efi_status_t status;
+	u64 end, systab;
 	int count = 0;
 
 	efi.systab = NULL;
@@ -874,7 +918,6 @@ void __init efi_enter_virtual_mode(void)
 	 * We don't do virtual mode, since we don't do runtime services, on
 	 * non-native EFI
 	 */
-
 	if (!efi_is_native()) {
 		efi_unmap_memmap();
 		return;
@@ -905,6 +948,7 @@ void __init efi_enter_virtual_mode(void)
 			continue;
 		}
 		prev_md = md;
+
 	}
 
 	for (p = memmap.map; p < memmap.map_end; p += memmap.desc_size) {
@@ -914,33 +958,18 @@ void __init efi_enter_virtual_mode(void)
 		    md->type != EFI_BOOT_SERVICES_DATA)
 			continue;
 
+		efi_map_region(md);
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
-			continue;
-		}
-
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
@@ -949,8 +978,17 @@ void __init efi_enter_virtual_mode(void)
 		count++;
 	}
 
+#ifdef CONFIG_X86_64
+	efi_scratch.efi_pgt = (pgd_t *)(unsigned long)real_mode_header->trampoline_pgd;
+
+	if (!test_bit(EFI_OLD_MEMMAP, &x86_efi_facility))
+		efi_scratch.use_pgd = true;
+#endif
+
 	BUG_ON(!efi.systab);
 
+	efi_sync_low_kernel_mappings();
+
 	status = phys_efi_set_virtual_address_map(
 		memmap.desc_size * count,
 		memmap.desc_size,
@@ -983,7 +1021,9 @@ void __init efi_enter_virtual_mode(void)
 	efi.query_variable_info = virt_efi_query_variable_info;
 	efi.update_capsule = virt_efi_update_capsule;
 	efi.query_capsule_caps = virt_efi_query_capsule_caps;
-	if (__supported_pte_mask & _PAGE_NX)
+
+	if (test_bit(EFI_OLD_MEMMAP, &x86_efi_facility) &&
+	    (__supported_pte_mask & _PAGE_NX))
 		runtime_code_page_mkexec();
 
 	kfree(new_memmap);
@@ -1119,6 +1159,9 @@ static int __init parse_efi_cmdline(char *str)
 	if (*str == '=')
 		str++;
 
+	if (!strncmp(str, "old_map", 7))
+		set_bit(EFI_OLD_MEMMAP, &x86_efi_facility);
+
 	return 0;
 }
 early_param("efi", parse_efi_cmdline);
diff --git a/arch/x86/platform/efi/efi_32.c b/arch/x86/platform/efi/efi_32.c
index 40e446941dd7..6c697a9633f2 100644
--- a/arch/x86/platform/efi/efi_32.c
+++ b/arch/x86/platform/efi/efi_32.c
@@ -37,9 +37,15 @@
  * claim EFI runtime service handler exclusively and to duplicate a memory in
  * low memory space say 0 - 3G.
  */
-
 static unsigned long efi_rt_eflags;
 
+void efi_sync_low_kernel_mappings(void) {}
+
+void __init efi_map_region(efi_memory_desc_t *md)
+{
+	old_map_region(md);
+}
+
 void efi_call_phys_prelog(void)
 {
 	struct desc_ptr gdt_descr;
diff --git a/arch/x86/platform/efi/efi_64.c b/arch/x86/platform/efi/efi_64.c
index 39a0e7f1f0a3..2ee51db337da 100644
--- a/arch/x86/platform/efi/efi_64.c
+++ b/arch/x86/platform/efi/efi_64.c
@@ -65,6 +65,9 @@ void __init efi_call_phys_prelog(void)
 	int pgd;
 	int n_pgds;
 
+	if (!test_bit(EFI_OLD_MEMMAP, &x86_efi_facility))
+		return;
+
 	early_code_mapping_set_exec(1);
 	local_irq_save(efi_flags);
 
@@ -86,6 +89,10 @@ void __init efi_call_phys_epilog(void)
 	 */
 	int pgd;
 	int n_pgds = DIV_ROUND_UP((max_pfn << PAGE_SHIFT) , PGDIR_SIZE);
+
+	if (!test_bit(EFI_OLD_MEMMAP, &x86_efi_facility))
+		return;
+
 	for (pgd = 0; pgd < n_pgds; pgd++)
 		set_pgd(pgd_offset_k(pgd * PGDIR_SIZE), save_pgd[pgd]);
 	kfree(save_pgd);
@@ -94,6 +101,82 @@ void __init efi_call_phys_epilog(void)
 	early_code_mapping_set_exec(0);
 }
 
+/*
+ * Add low kernel mappings for passing arguments to EFI functions.
+ */
+void efi_sync_low_kernel_mappings(void)
+{
+	unsigned num_pgds;
+	pgd_t *pgd = (pgd_t *)__va(real_mode_header->trampoline_pgd);
+
+	if (test_bit(EFI_OLD_MEMMAP, &x86_efi_facility))
+		return;
+
+	num_pgds = pgd_index(MODULES_END - 1) - pgd_index(PAGE_OFFSET);
+
+	memcpy(pgd + pgd_index(PAGE_OFFSET),
+		init_mm.pgd + pgd_index(PAGE_OFFSET),
+		sizeof(pgd_t) * num_pgds);
+}
+
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
+void __init efi_map_region(efi_memory_desc_t *md)
+{
+	unsigned long size = md->num_pages << PAGE_SHIFT;
+	u64 pa = md->phys_addr;
+
+	if (test_bit(EFI_OLD_MEMMAP, &x86_efi_facility))
+		return old_map_region(md);
+
+	/*
+	 * Make sure the 1:1 mappings are present as a catch-all for b0rked
+	 * firmware which doesn't update all internal pointers after switching
+	 * to virtual mode and would otherwise crap on us.
+	 */
+	__map_region(md, md->phys_addr);
+
+	efi_va -= size;
+
+	/* Is PA 2M-aligned? */
+	if (!(pa & (PMD_SIZE - 1)))
+		efi_va &= PMD_MASK;
+	else {
+		u64 pa_offset = pa & (PMD_SIZE - 1);
+		u64 prev_va = efi_va;
+
+		/* get us the same offset within this 2M page */
+		efi_va = (efi_va & PMD_MASK) + pa_offset;
+
+		if (efi_va > prev_va)
+			efi_va -= PMD_SIZE;
+	}
+
+	if (efi_va < EFI_VA_END) {
+		pr_warning(FW_WARN "VA address range overflow!\n");
+		return;
+	}
+
+	/* Do the VA map */
+	__map_region(md, efi_va);
+	md->virt_addr = efi_va;
+}
+
 void __iomem *__init efi_ioremap(unsigned long phys_addr, unsigned long size,
 				 u32 type, u64 attribute)
 {
diff --git a/arch/x86/platform/efi/efi_stub_64.S b/arch/x86/platform/efi/efi_stub_64.S
index 4c07ccab8146..88073b140298 100644
--- a/arch/x86/platform/efi/efi_stub_64.S
+++ b/arch/x86/platform/efi/efi_stub_64.S
@@ -34,10 +34,47 @@
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
+	cmpb $0, efi_scratch+24(%rip)
+	je 1f
+	movq %r15, efi_scratch(%rip)		# r15
+	# save previous CR3
+	movq %cr3, %r15
+	movq %r15, efi_scratch+8(%rip)		# prev_cr3
+	movq efi_scratch+16(%rip), %r15		# EFI pgt
+	movq %r15, %cr3
+	1:
+	.endm
+
+	.macro RESTORE_PGT
+	cmpb $0, efi_scratch+24(%rip)
+	je 2f
+	movq efi_scratch+8(%rip), %r15
+	movq %r15, %cr3
+	movq efi_scratch(%rip), %r15
+	FLUSH_TLB_ALL
+	2:
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
@@ -47,7 +84,9 @@ ENTRY(efi_call1)
 	SAVE_XMM
 	subq $32, %rsp
 	mov  %rsi, %rcx
+	SWITCH_PGT
 	call *%rdi
+	RESTORE_PGT
 	addq $32, %rsp
 	RESTORE_XMM
 	ret
@@ -57,7 +96,9 @@ ENTRY(efi_call2)
 	SAVE_XMM
 	subq $32, %rsp
 	mov  %rsi, %rcx
+	SWITCH_PGT
 	call *%rdi
+	RESTORE_PGT
 	addq $32, %rsp
 	RESTORE_XMM
 	ret
@@ -68,7 +109,9 @@ ENTRY(efi_call3)
 	subq $32, %rsp
 	mov  %rcx, %r8
 	mov  %rsi, %rcx
+	SWITCH_PGT
 	call *%rdi
+	RESTORE_PGT
 	addq $32, %rsp
 	RESTORE_XMM
 	ret
@@ -80,7 +123,9 @@ ENTRY(efi_call4)
 	mov %r8, %r9
 	mov %rcx, %r8
 	mov %rsi, %rcx
+	SWITCH_PGT
 	call *%rdi
+	RESTORE_PGT
 	addq $32, %rsp
 	RESTORE_XMM
 	ret
@@ -93,7 +138,9 @@ ENTRY(efi_call5)
 	mov %r8, %r9
 	mov %rcx, %r8
 	mov %rsi, %rcx
+	SWITCH_PGT
 	call *%rdi
+	RESTORE_PGT
 	addq $48, %rsp
 	RESTORE_XMM
 	ret
@@ -109,8 +156,15 @@ ENTRY(efi_call6)
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
+	.byte 0
diff --git a/include/linux/efi.h b/include/linux/efi.h
index fa47d80ab4b5..beff433aa8c0 100644
--- a/include/linux/efi.h
+++ b/include/linux/efi.h
@@ -632,6 +632,7 @@ extern int __init efi_setup_pcdp_console(char *);
 #define EFI_RUNTIME_SERVICES	3	/* Can we use runtime services? */
 #define EFI_MEMMAP		4	/* Can we use EFI memory map? */
 #define EFI_64BIT		5	/* Is the firmware 64-bit? */
+#define EFI_OLD_MEMMAP		6	/* Use old mapping method */
 
 #ifdef CONFIG_EFI
 # ifdef CONFIG_X86
-- 
1.8.4

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
