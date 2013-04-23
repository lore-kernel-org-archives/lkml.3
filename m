Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754939Ab3DWKQN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Apr 2013 06:16:13 -0400
Received: from mail.skyhub.de ([78.46.96.112]:41931 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752079Ab3DWKP5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Apr 2013 06:15:57 -0400
From: Borislav Petkov <bp@alien8.de>
To: LKML <linux-kernel@vger.kernel.org>
Cc: "H. Peter Anvin" <hpa@zytor.com>, Matt Fleming <matt@console-pimps.org>,
        David Woodhouse <dwmw2@infradead.org>,
        Matthew Garrett <matthew.garrett@nebula.com>,
        Borislav Petkov <bp@suse.de>
Subject: [RFC PATCH 2/2] x86, efi: Add 1:1 mapping of runtime services
Date: Tue, 23 Apr 2013 12:15:52 +0200
Message-Id: <1366712152-8097-3-git-send-email-bp@alien8.de>
X-Mailer: git-send-email 1.8.2.135.g7b592fa
In-Reply-To: <1366712152-8097-1-git-send-email-bp@alien8.de>
References: <1366712152-8097-1-git-send-email-bp@alien8.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Borislav Petkov <bp@suse.de>

Map EFI runtime services 1:1 into the trampoline pgd so that all those
functions can be used in a kexec kernel. As we all know, the braindead
design of SetVirtualAddressMap() doesn't allow a subsequent call to this
function to reestablish virtual mappings, leading us to do all kinds of
crazy dances in the kernel.

64-bit only for now.

Signed-off-by: Borislav Petkov <bp@suse.de>
---
 arch/x86/include/asm/efi.h          |  2 +
 arch/x86/platform/efi/efi.c         | 84 +++++++++++++++++++++++++++----------
 arch/x86/platform/efi/efi_stub_64.S | 39 +++++++++++++++++
 3 files changed, 102 insertions(+), 23 deletions(-)

diff --git a/arch/x86/include/asm/efi.h b/arch/x86/include/asm/efi.h
index 60c89f30c727..3ed4b8c51548 100644
--- a/arch/x86/include/asm/efi.h
+++ b/arch/x86/include/asm/efi.h
@@ -39,6 +39,8 @@ extern unsigned long asmlinkage efi_call_phys(void *, ...);
 
 #else /* !CONFIG_X86_32 */
 
+extern pgd_t *efi_pgt;
+
 #define EFI_LOADER_SIGNATURE	"EL64"
 
 extern u64 efi_call0(void *fp);
diff --git a/arch/x86/platform/efi/efi.c b/arch/x86/platform/efi/efi.c
index 4b70be21fe0a..9e45eac3c33a 100644
--- a/arch/x86/platform/efi/efi.c
+++ b/arch/x86/platform/efi/efi.c
@@ -649,15 +649,24 @@ static int __init efi_runtime_init(void)
 		pr_err("Could not map the runtime service table!\n");
 		return -ENOMEM;
 	}
-	/*
-	 * We will only need *early* access to the following
-	 * two EFI runtime services before set_virtual_address_map
-	 * is invoked.
-	 */
-	efi_phys.get_time = (efi_get_time_t *)runtime->get_time;
-	efi_phys.set_virtual_address_map =
-		(efi_set_virtual_address_map_t *)
-		runtime->set_virtual_address_map;
+
+#define efi_phys_assign(f) \
+	efi_phys.f = (efi_ ##f## _t *)runtime->f
+
+	efi_phys_assign(get_time);
+	efi_phys_assign(set_time);
+	efi_phys_assign(get_wakeup_time);
+	efi_phys_assign(set_wakeup_time);
+	efi_phys_assign(get_variable);
+	efi_phys_assign(get_next_variable);
+	efi_phys_assign(set_variable);
+	efi_phys_assign(get_next_high_mono_count);
+	efi_phys_assign(reset_system);
+	efi_phys_assign(set_virtual_address_map);
+	efi_phys_assign(query_variable_info);
+	efi_phys_assign(update_capsule);
+	efi_phys_assign(query_capsule_caps);
+
 	/*
 	 * Make efi_get_time can be called before entering
 	 * virtual mode.
@@ -845,9 +854,10 @@ void efi_memory_uc(u64 addr, unsigned long size)
  */
 void __init efi_enter_virtual_mode(void)
 {
+	pgd_t *pgd = (pgd_t *)__va(real_mode_header->trampoline_pgd);
 	efi_memory_desc_t *md, *prev_md = NULL;
 	efi_status_t status;
-	unsigned long size;
+	unsigned long size, page_flags;
 	u64 end, systab, start_pfn, end_pfn;
 	void *p, *va, *new_memmap = NULL;
 	int count = 0;
@@ -895,7 +905,8 @@ void __init efi_enter_virtual_mode(void)
 		md = p;
 		if (!(md->attribute & EFI_MEMORY_RUNTIME) &&
 		    md->type != EFI_BOOT_SERVICES_CODE &&
-		    md->type != EFI_BOOT_SERVICES_DATA)
+		    md->type != EFI_BOOT_SERVICES_DATA &&
+		    md->type != EFI_CONVENTIONAL_MEMORY)
 			continue;
 
 		size = md->num_pages << EFI_PAGE_SHIFT;
@@ -920,11 +931,26 @@ void __init efi_enter_virtual_mode(void)
 			continue;
 		}
 
+		page_flags = 0;
+
+		if (md->type == EFI_RUNTIME_SERVICES_DATA ||
+		    md->type == EFI_BOOT_SERVICES_DATA)
+			page_flags = _PAGE_NX;
+
+		if (!(md->attribute & EFI_MEMORY_WB))
+			page_flags |= _PAGE_PCD;
+
+		kernel_map_pages_in_pgd(pgd, md->phys_addr,
+					md->num_pages, page_flags);
+
 		systab = (u64) (unsigned long) efi_phys.systab;
 		if (md->phys_addr <= systab && systab < end) {
 			systab += md->virt_addr - md->phys_addr;
 			efi.systab = (efi_system_table_t *) (unsigned long) systab;
 		}
+
+		md->virt_addr = md->phys_addr;
+
 		new_memmap = krealloc(new_memmap,
 				      (count + 1) * memmap.desc_size,
 				      GFP_KERNEL);
@@ -935,6 +961,8 @@ void __init efi_enter_virtual_mode(void)
 
 	BUG_ON(!efi.systab);
 
+	efi_pgt = (pgd_t *)(unsigned long)real_mode_header->trampoline_pgd;
+
 	status = phys_efi_set_virtual_address_map(
 		memmap.desc_size * count,
 		memmap.desc_size,
@@ -947,6 +975,9 @@ void __init efi_enter_virtual_mode(void)
 		panic("EFI call to SetVirtualAddressMap() failed!");
 	}
 
+	efi.systab->runtime = kzalloc(sizeof(efi_runtime_services_t), GFP_KERNEL);
+	BUG_ON(!efi.systab->runtime);
+
 	/*
 	 * Now that EFI is in virtual mode, update the function
 	 * pointers in the runtime service table to the new virtual addresses.
@@ -954,19 +985,26 @@ void __init efi_enter_virtual_mode(void)
 	 * Call EFI services through wrapper functions.
 	 */
 	efi.runtime_version = efi_systab.hdr.revision;
-	efi.get_time = virt_efi_get_time;
-	efi.set_time = virt_efi_set_time;
-	efi.get_wakeup_time = virt_efi_get_wakeup_time;
-	efi.set_wakeup_time = virt_efi_set_wakeup_time;
-	efi.get_variable = virt_efi_get_variable;
-	efi.get_next_variable = virt_efi_get_next_variable;
-	efi.set_variable = virt_efi_set_variable;
-	efi.get_next_high_mono_count = virt_efi_get_next_high_mono_count;
-	efi.reset_system = virt_efi_reset_system;
+
+
+#define efi_assign(efi, f)						\
+	efi.f = virt_efi_##f;						\
+	efi.systab->runtime->f = (unsigned long)efi_phys.f
+
+	efi_assign(efi, get_time);
+	efi_assign(efi, set_time);
+	efi_assign(efi, get_wakeup_time);
+	efi_assign(efi, set_wakeup_time);
+	efi_assign(efi, get_variable);
+	efi_assign(efi, get_next_variable);
+	efi_assign(efi, set_variable);
+	efi_assign(efi, get_next_high_mono_count);
+	efi_assign(efi, reset_system);
 	efi.set_virtual_address_map = NULL;
-	efi.query_variable_info = virt_efi_query_variable_info;
-	efi.update_capsule = virt_efi_update_capsule;
-	efi.query_capsule_caps = virt_efi_query_capsule_caps;
+	efi_assign(efi, query_variable_info);
+	efi_assign(efi, update_capsule);
+	efi_assign(efi, query_capsule_caps);
+
 	if (__supported_pte_mask & _PAGE_NX)
 		runtime_code_page_mkexec();
 
diff --git a/arch/x86/platform/efi/efi_stub_64.S b/arch/x86/platform/efi/efi_stub_64.S
index 4c07ccab8146..eec8d6d02c17 100644
--- a/arch/x86/platform/efi/efi_stub_64.S
+++ b/arch/x86/platform/efi/efi_stub_64.S
@@ -34,10 +34,34 @@
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
+	movq %cr3, %r15;		\
+	movq efi_pgt, %rax;		\
+	movq %rax, %cr3;		\
+	FLUSH_TLB_ALL
+
+#define RESTORE_PGT			\
+	movq %r15, %cr3;		\
+	FLUSH_TLB_ALL
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
@@ -47,7 +71,9 @@ ENTRY(efi_call1)
 	SAVE_XMM
 	subq $32, %rsp
 	mov  %rsi, %rcx
+	SWITCH_PGT
 	call *%rdi
+	RESTORE_PGT
 	addq $32, %rsp
 	RESTORE_XMM
 	ret
@@ -57,7 +83,9 @@ ENTRY(efi_call2)
 	SAVE_XMM
 	subq $32, %rsp
 	mov  %rsi, %rcx
+	SWITCH_PGT
 	call *%rdi
+	RESTORE_PGT
 	addq $32, %rsp
 	RESTORE_XMM
 	ret
@@ -68,7 +96,9 @@ ENTRY(efi_call3)
 	subq $32, %rsp
 	mov  %rcx, %r8
 	mov  %rsi, %rcx
+	SWITCH_PGT
 	call *%rdi
+	RESTORE_PGT
 	addq $32, %rsp
 	RESTORE_XMM
 	ret
@@ -80,7 +110,9 @@ ENTRY(efi_call4)
 	mov %r8, %r9
 	mov %rcx, %r8
 	mov %rsi, %rcx
+	SWITCH_PGT
 	call *%rdi
+	RESTORE_PGT
 	addq $32, %rsp
 	RESTORE_XMM
 	ret
@@ -93,7 +125,9 @@ ENTRY(efi_call5)
 	mov %r8, %r9
 	mov %rcx, %r8
 	mov %rsi, %rcx
+	SWITCH_PGT
 	call *%rdi
+	RESTORE_PGT
 	addq $48, %rsp
 	RESTORE_XMM
 	ret
@@ -109,8 +143,13 @@ ENTRY(efi_call6)
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
-- 
1.8.2.135.g7b592fa

