Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753405Ab3FBM5F (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Jun 2013 08:57:05 -0400
Received: from mail.skyhub.de ([78.46.96.112]:56328 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751492Ab3FBM4A (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Jun 2013 08:56:00 -0400
From: Borislav Petkov <bp@alien8.de>
To: Linux EFI <linux-efi@vger.kernel.org>
Cc: Matt Fleming <matt@console-pimps.org>,
        Matthew Garrett <mjg59@srcf.ucam.org>, Jiri Kosina <jkosina@suse.cz>,
        X86-ML <x86@kernel.org>, LKML <linux-kernel@vger.kernel.org>,
        Borislav Petkov <bp@suse.de>
Subject: [PATCH 4/4] x86, efi: Map runtime services 1:1
Date: Sun,  2 Jun 2013 14:56:10 +0200
Message-Id: <1370177770-26661-5-git-send-email-bp@alien8.de>
X-Mailer: git-send-email 1.8.3.rc1.25.g423ecb0
In-Reply-To: <1370177770-26661-1-git-send-email-bp@alien8.de>
References: <1370177770-26661-1-git-send-email-bp@alien8.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Borislav Petkov <bp@suse.de>

Due to the braindead design of EFI, we cannot map runtime services more
than once for the duration of a booted system. Thus, if we want to use
EFI runtime services in a kexec'ed kernel, maybe the only possible and
sensible approach would be to map them 1:1 so that when the kexec kernel
loads, it can simply call those addresses without the need for remapping
(which doesn't work anyway).

Furthermore, this mapping approach could be of help with b0rked EFI
implementations for a different set of reasons.

This implementation is 64-bit only for now and it boots fine in kvm with
OVMF BIOS.

Signed-off-by: Borislav Petkov <bp@suse.de>
---
 arch/x86/include/asm/efi.h          |   2 +
 arch/x86/platform/efi/efi.c         | 161 +++++++++++++++++++++++++++++-------
 arch/x86/platform/efi/efi_stub_64.S |  48 +++++++++++
 3 files changed, 180 insertions(+), 31 deletions(-)

diff --git a/arch/x86/include/asm/efi.h b/arch/x86/include/asm/efi.h
index 5b33686b6995..1c9c0a5cc280 100644
--- a/arch/x86/include/asm/efi.h
+++ b/arch/x86/include/asm/efi.h
@@ -41,6 +41,8 @@ extern unsigned long asmlinkage efi_call_phys(void *, ...);
 
 #define EFI_LOADER_SIGNATURE	"EL64"
 
+extern pgd_t *efi_pgt;
+
 extern u64 efi_call0(void *fp);
 extern u64 efi_call1(void *fp, u64 arg1);
 extern u64 efi_call2(void *fp, u64 arg1, u64 arg2);
diff --git a/arch/x86/platform/efi/efi.c b/arch/x86/platform/efi/efi.c
index aea4337f7023..36ecefb54495 100644
--- a/arch/x86/platform/efi/efi.c
+++ b/arch/x86/platform/efi/efi.c
@@ -93,6 +93,8 @@ unsigned long x86_efi_facility;
 
 static unsigned long efi_config;
 
+extern bool use_11_map;
+
 /*
  * Returns 1 if 'facility' is enabled, 0 otherwise.
  */
@@ -763,6 +765,25 @@ static int __init efi_runtime_init(void)
 	 * virtual mode.
 	 */
 	efi.get_time = phys_efi_get_time;
+
+	if (efi_config & EFI_CFG_MAP11) {
+#define efi_phys_assign(f) \
+	efi_phys.f = (efi_ ##f## _t *)runtime->f
+
+		efi_phys_assign(set_time);
+		efi_phys_assign(get_wakeup_time);
+		efi_phys_assign(set_wakeup_time);
+		efi_phys_assign(get_variable);
+		efi_phys_assign(get_next_variable);
+		efi_phys_assign(set_variable);
+		efi_phys_assign(get_next_high_mono_count);
+		efi_phys_assign(reset_system);
+		efi_phys_assign(set_virtual_address_map);
+		efi_phys_assign(query_variable_info);
+		efi_phys_assign(update_capsule);
+		efi_phys_assign(query_capsule_caps);
+	}
+
 	early_iounmap(runtime, sizeof(efi_runtime_services_t));
 
 	return 0;
@@ -954,6 +975,61 @@ void efi_memory_uc(u64 addr, unsigned long size)
 	set_memory_uc(addr, npages);
 }
 
+static void __init __runtime_map_11(efi_memory_desc_t *md)
+{
+	pgd_t *pgd = (pgd_t *)__va(real_mode_header->trampoline_pgd);
+	unsigned long page_flags = 0;
+
+	if (md->type == EFI_RUNTIME_SERVICES_DATA ||
+	    md->type == EFI_BOOT_SERVICES_DATA)
+		page_flags |= _PAGE_NX;
+
+	if (!(md->attribute & EFI_MEMORY_WB))
+		page_flags |= _PAGE_PCD;
+
+	kernel_map_pages_in_pgd(pgd + pgd_index(md->phys_addr),
+				md->phys_addr,
+				md->num_pages,
+				page_flags);
+
+	md->virt_addr = md->phys_addr;
+}
+
+static int __init __runtime_ioremap(efi_memory_desc_t *md)
+{
+	u64 end, systab, start_pfn, end_pfn;
+	unsigned long size;
+	void *va;
+
+	size	  = md->num_pages << EFI_PAGE_SHIFT;
+	end	  = md->phys_addr + size;
+	start_pfn = PFN_DOWN(md->phys_addr);
+	end_pfn   = PFN_UP(end);
+
+	if (pfn_range_is_mapped(start_pfn, end_pfn)) {
+		va = __va(md->phys_addr);
+
+		if (!(md->attribute & EFI_MEMORY_WB))
+			efi_memory_uc((u64)(unsigned long)va, size);
+	} else
+		va = efi_ioremap(md->phys_addr, size, md->type, md->attribute);
+
+	md->virt_addr = (u64) (unsigned long) va;
+	if (!va) {
+		pr_err("ioremap of 0x%llX failed!\n",
+			(unsigned long long)md->phys_addr);
+			return 1;
+	}
+
+	systab = (u64) (unsigned long) efi_phys.systab;
+	if (md->phys_addr <= systab && systab < end) {
+		systab += md->virt_addr - md->phys_addr;
+		efi.systab = (efi_system_table_t *) (unsigned long) systab;
+	}
+
+	return 0;
+}
+
 /*
  * This function will switch the EFI runtime services to virtual mode.
  * Essentially, look through the EFI memmap and map every region that
@@ -964,11 +1040,11 @@ void efi_memory_uc(u64 addr, unsigned long size)
  */
 void __init efi_enter_virtual_mode(void)
 {
+	pgd_t *pgd = (pgd_t *)__va(real_mode_header->trampoline_pgd);
 	efi_memory_desc_t *md, *prev_md = NULL;
 	efi_status_t status;
-	unsigned long size;
-	u64 end, systab, start_pfn, end_pfn;
-	void *p, *va, *new_memmap = NULL;
+	void *p, *new_memmap = NULL;
+	unsigned num_pgds;
 	int count = 0;
 
 	efi.systab = NULL;
@@ -1017,33 +1093,18 @@ void __init efi_enter_virtual_mode(void)
 		    md->type != EFI_BOOT_SERVICES_DATA)
 			continue;
 
-		size = md->num_pages << EFI_PAGE_SHIFT;
-		end = md->phys_addr + size;
-
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
+		/*
+		 * XXX: need to map the region which contains
+		 * SetVirtualAddressMap so that we can call it here.
+		 * Probably can be removed after we map boot services 1:1
+		 * too.
+		 */
+		if (__runtime_ioremap(md))
 			continue;
-		}
 
-		systab = (u64) (unsigned long) efi_phys.systab;
-		if (md->phys_addr <= systab && systab < end) {
-			systab += md->virt_addr - md->phys_addr;
-			efi.systab = (efi_system_table_t *) (unsigned long) systab;
-		}
+		if (efi_config & EFI_CFG_MAP11)
+			__runtime_map_11(md);
+
 		new_memmap = krealloc(new_memmap,
 				      (count + 1) * memmap.desc_size,
 				      GFP_KERNEL);
@@ -1052,7 +1113,8 @@ void __init efi_enter_virtual_mode(void)
 		count++;
 	}
 
-	BUG_ON(!efi.systab);
+	if (!(efi_config & EFI_CFG_MAP11))
+		BUG_ON(!efi.systab);
 
 	status = phys_efi_set_virtual_address_map(
 		memmap.desc_size * count,
@@ -1072,6 +1134,41 @@ void __init efi_enter_virtual_mode(void)
 	 *
 	 * Call EFI services through wrapper functions.
 	 */
+	if (efi_config & EFI_CFG_MAP11) {
+#define efi_assign(efi, f)						\
+	efi.systab->runtime->f = efi_phys.f
+
+		efi.systab->runtime = kzalloc(sizeof(efi_runtime_services_t),
+					      GFP_KERNEL);
+		BUG_ON(!efi.systab->runtime);
+
+		efi_assign(efi, get_time);
+		efi_assign(efi, set_time);
+		efi_assign(efi, get_wakeup_time);
+		efi_assign(efi, set_wakeup_time);
+		efi_assign(efi, get_variable);
+		efi_assign(efi, get_next_variable);
+		efi_assign(efi, set_variable);
+		efi_assign(efi, get_next_high_mono_count);
+		efi_assign(efi, reset_system);
+		efi_assign(efi, query_variable_info);
+		efi_assign(efi, update_capsule);
+		efi_assign(efi, query_capsule_caps);
+
+		/*
+		 * map-in low kernel mapping for passing arguments to EFI
+		 * functions.
+		 */
+		num_pgds = pgd_index(VMALLOC_START - 1) - pgd_index(PAGE_OFFSET);
+
+		memcpy(pgd + pgd_index(PAGE_OFFSET),
+			init_mm.pgd + pgd_index(PAGE_OFFSET),
+			sizeof(pgd_t) * num_pgds);
+
+		efi_pgt = (pgd_t *)(unsigned long)real_mode_header->trampoline_pgd;;
+		use_11_map = true;
+	}
+
 	efi.runtime_version = efi_systab.hdr.revision;
 	efi.get_time = virt_efi_get_time;
 	efi.set_time = virt_efi_set_time;
@@ -1086,8 +1183,10 @@ void __init efi_enter_virtual_mode(void)
 	efi.query_variable_info = virt_efi_query_variable_info;
 	efi.update_capsule = virt_efi_update_capsule;
 	efi.query_capsule_caps = virt_efi_query_capsule_caps;
-	if (__supported_pte_mask & _PAGE_NX)
-		runtime_code_page_mkexec();
+
+	if (!(efi_config & EFI_CFG_MAP11))
+		if (__supported_pte_mask & _PAGE_NX)
+			runtime_code_page_mkexec();
 
 	kfree(new_memmap);
 }
diff --git a/arch/x86/platform/efi/efi_stub_64.S b/arch/x86/platform/efi/efi_stub_64.S
index 4c07ccab8146..2f93dcad3804 100644
--- a/arch/x86/platform/efi/efi_stub_64.S
+++ b/arch/x86/platform/efi/efi_stub_64.S
@@ -34,10 +34,40 @@
 	mov %rsi, %cr0;			\
 	mov (%rsp), %rsp
 
+/* happily stolen from gcc, see __flush_tlb_global() */
+#define FLUSH_TLB_ALL			\
+	movq %cr4, %r14;		\
+	movq %r14, %r13;		\
+	and $0x7f, %r13b;		\
+	movq %r13, %cr4;		\
+	movq %r14, %cr4
+
+/*
+ * %r15 is a non-volatile register and is preserved by UEFI so use
+ * it for stashing previous PGD in there.
+ */
+#define SWITCH_PGT			\
+	cmpb $0, use_11_map;		\
+	je 1f;				\
+	movq %cr3, %r15;		\
+	movq efi_pgt, %rax;		\
+	movq %rax, %cr3;		\
+	FLUSH_TLB_ALL;			\
+	1:
+
+#define RESTORE_PGT			\
+	cmpb $0, use_11_map;		\
+	je 2f;				\
+	movq %r15, %cr3;		\
+	FLUSH_TLB_ALL;			\
+	2:
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
@@ -47,7 +77,9 @@ ENTRY(efi_call1)
 	SAVE_XMM
 	subq $32, %rsp
 	mov  %rsi, %rcx
+	SWITCH_PGT
 	call *%rdi
+	RESTORE_PGT
 	addq $32, %rsp
 	RESTORE_XMM
 	ret
@@ -57,7 +89,9 @@ ENTRY(efi_call2)
 	SAVE_XMM
 	subq $32, %rsp
 	mov  %rsi, %rcx
+	SWITCH_PGT
 	call *%rdi
+	RESTORE_PGT
 	addq $32, %rsp
 	RESTORE_XMM
 	ret
@@ -68,7 +102,9 @@ ENTRY(efi_call3)
 	subq $32, %rsp
 	mov  %rcx, %r8
 	mov  %rsi, %rcx
+	SWITCH_PGT
 	call *%rdi
+	RESTORE_PGT
 	addq $32, %rsp
 	RESTORE_XMM
 	ret
@@ -80,7 +116,9 @@ ENTRY(efi_call4)
 	mov %r8, %r9
 	mov %rcx, %r8
 	mov %rsi, %rcx
+	SWITCH_PGT
 	call *%rdi
+	RESTORE_PGT
 	addq $32, %rsp
 	RESTORE_XMM
 	ret
@@ -93,7 +131,9 @@ ENTRY(efi_call5)
 	mov %r8, %r9
 	mov %rcx, %r8
 	mov %rsi, %rcx
+	SWITCH_PGT
 	call *%rdi
+	RESTORE_PGT
 	addq $48, %rsp
 	RESTORE_XMM
 	ret
@@ -109,8 +149,16 @@ ENTRY(efi_call6)
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
+GLOBAL(efi_pgt)
+	.quad 0
+
+ENTRY(use_11_map)
+	.byte 0
-- 
1.8.3.rc1.25.g423ecb0

