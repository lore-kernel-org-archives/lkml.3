Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755514Ab3FQRvD (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Jun 2013 13:51:03 -0400
Received: from mail.skyhub.de ([78.46.96.112]:43989 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754446Ab3FQRu1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Jun 2013 13:50:27 -0400
From: Borislav Petkov <bp@alien8.de>
To: Linux EFI <linux-efi@vger.kernel.org>
Cc: Matt Fleming <matt@console-pimps.org>,
        Matthew Garrett <mjg59@srcf.ucam.org>, X86 ML <x86@kernel.org>,
        LKML <linux-kernel@vger.kernel.org>, Borislav Petkov <bp@suse.de>
Subject: [PATCH -v2 4/4] x86, efi: Map runtime services 1:1
Date: Mon, 17 Jun 2013 19:50:16 +0200
Message-Id: <1371491416-11037-5-git-send-email-bp@alien8.de>
X-Mailer: git-send-email 1.8.3
In-Reply-To: <1371491416-11037-1-git-send-email-bp@alien8.de>
References: <1371491416-11037-1-git-send-email-bp@alien8.de>
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

This implementation is 64-bit only for now.

Signed-off-by: Borislav Petkov <bp@suse.de>
---
 arch/x86/include/asm/efi.h          |  67 +++++++++++----
 arch/x86/platform/efi/efi.c         | 165 +++++++++++++++++++++++++++++-------
 arch/x86/platform/efi/efi_stub_64.S |  56 ++++++++++++
 3 files changed, 240 insertions(+), 48 deletions(-)

diff --git a/arch/x86/include/asm/efi.h b/arch/x86/include/asm/efi.h
index 5b33686b6995..3adeef4a0064 100644
--- a/arch/x86/include/asm/efi.h
+++ b/arch/x86/include/asm/efi.h
@@ -39,8 +39,13 @@ extern unsigned long asmlinkage efi_call_phys(void *, ...);
 
 #else /* !CONFIG_X86_32 */
 
+#include <linux/sched.h>
+
 #define EFI_LOADER_SIGNATURE	"EL64"
 
+extern pgd_t *efi_pgt;
+extern bool efi_use_11_map;
+
 extern u64 efi_call0(void *fp);
 extern u64 efi_call1(void *fp, u64 arg1);
 extern u64 efi_call2(void *fp, u64 arg1, u64 arg2);
@@ -51,6 +56,22 @@ extern u64 efi_call5(void *fp, u64 arg1, u64 arg2, u64 arg3,
 extern u64 efi_call6(void *fp, u64 arg1, u64 arg2, u64 arg3,
 		     u64 arg4, u64 arg5, u64 arg6);
 
+/*
+ * map-in low kernel mapping for passing arguments to EFI functions.
+ */
+static inline void efi_sync_low_kernel_mappings(void)
+{
+	unsigned num_pgds;
+	pgd_t *pgd;
+
+	pgd = (pgd_t *)__va(real_mode_header->trampoline_pgd);
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
@@ -69,24 +90,36 @@ extern u64 efi_call6(void *fp, u64 arg1, u64 arg2, u64 arg3,
 	efi_call6((f), (u64)(a1), (u64)(a2), (u64)(a3),		\
 		  (u64)(a4), (u64)(a5), (u64)(a6))
 
+#define _efi_call_virtX(x, f, ...)					\
+({									\
+	efi_status_t __s;						\
+									\
+	if (efi_use_11_map) {						\
+		efi_sync_low_kernel_mappings();				\
+		preempt_disable();					\
+	}								\
+									\
+	__s = efi_call##x(efi.systab->runtime->f, __VA_ARGS__);		\
+									\
+	if (efi_use_11_map)						\
+		preempt_enable();					\
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
diff --git a/arch/x86/platform/efi/efi.c b/arch/x86/platform/efi/efi.c
index 5af5b97bf203..5409f1ccc9e3 100644
--- a/arch/x86/platform/efi/efi.c
+++ b/arch/x86/platform/efi/efi.c
@@ -94,6 +94,17 @@ unsigned long x86_efi_facility;
 static unsigned long efi_config;
 
 /*
+ * Scratch space for 1:1 mapping
+ */
+struct efi_scratch {
+	u64 r15;
+	u64 prev_cr3;
+	pgd_t *pgt11;
+};
+
+extern struct efi_scratch efi_scratch;
+
+/*
  * Returns 1 if 'facility' is enabled, 0 otherwise.
  */
 int efi_enabled(int facility)
@@ -763,6 +774,25 @@ static int __init efi_runtime_init(void)
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
@@ -954,6 +984,65 @@ void efi_memory_uc(u64 addr, unsigned long size)
 	set_memory_uc(addr, npages);
 }
 
+static void __init __runtime_map_11(efi_memory_desc_t *md)
+{
+	unsigned long page_flags = 0;
+	pgd_t *pgd = NULL;
+
+#ifdef CONFIG_X86_64
+	pgd = (pgd_t *)__va(real_mode_header->trampoline_pgd);
+#endif
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
@@ -966,9 +1055,7 @@ void __init efi_enter_virtual_mode(void)
 {
 	efi_memory_desc_t *md, *prev_md = NULL;
 	efi_status_t status;
-	unsigned long size;
-	u64 end, systab, start_pfn, end_pfn;
-	void *p, *va, *new_memmap = NULL;
+	void *p, *new_memmap = NULL;
 	int count = 0;
 
 	efi.systab = NULL;
@@ -1017,33 +1104,18 @@ void __init efi_enter_virtual_mode(void)
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
@@ -1052,7 +1124,8 @@ void __init efi_enter_virtual_mode(void)
 		count++;
 	}
 
-	BUG_ON(!efi.systab);
+	if (!(efi_config & EFI_CFG_MAP11))
+		BUG_ON(!efi.systab);
 
 	status = phys_efi_set_virtual_address_map(
 		memmap.desc_size * count,
@@ -1072,6 +1145,34 @@ void __init efi_enter_virtual_mode(void)
 	 *
 	 * Call EFI services through wrapper functions.
 	 */
+	if (efi_config & EFI_CFG_MAP11) {
+#define efi_assign(efi, f)	efi.systab->runtime->f = efi_phys.f
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
+#ifdef CONFIG_X86_64
+		efi_scratch.pgt11 = (pgd_t *)(unsigned long)real_mode_header->trampoline_pgd;
+#endif
+		efi_use_11_map = true;
+
+		pr_info("Using 1:1 map.\n");
+	}
+
 	efi.runtime_version = efi_systab.hdr.revision;
 	efi.get_time = virt_efi_get_time;
 	efi.set_time = virt_efi_set_time;
@@ -1086,8 +1187,10 @@ void __init efi_enter_virtual_mode(void)
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
index 4c07ccab8146..a5f1ef4fb14a 100644
--- a/arch/x86/platform/efi/efi_stub_64.S
+++ b/arch/x86/platform/efi/efi_stub_64.S
@@ -34,10 +34,47 @@
 	mov %rsi, %cr0;			\
 	mov (%rsp), %rsp
 
+/* stolen from gcc */
+	.macro FLUSH_TLB_ALL
+	movq %r15, efi_scratch
+	movq %r14, efi_scratch+8
+	movq %cr4, %r15
+	movq %r15, %r14
+	andb $0x7f, %r14b
+	movq %r14, %cr4
+	movq %r15, %cr4
+	movq efi_scratch+8, %r14
+	movq efi_scratch, %r15
+	.endm
+
+	.macro SWITCH_PGT
+	cmpb $0, efi_use_11_map
+	je 1f;
+	movq %r15, efi_scratch		# r15
+	# save previous CR3
+	movq %cr3, %r15
+	movq %r15, efi_scratch+8	# prev_cr3
+	movq efi_scratch+16, %r15	# 1:1 pgt
+	movq %r15, %cr3
+1:
+	.endm
+
+	.macro RESTORE_PGT
+	cmpb $0, efi_use_11_map
+	je 2f
+	movq efi_scratch+8, %r15
+	movq %r15, %cr3
+	movq efi_scratch, %r15
+	FLUSH_TLB_ALL
+2:
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
@@ -109,8 +156,17 @@ ENTRY(efi_call6)
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
+ENTRY(efi_use_11_map)
+	.byte 0
+
+ENTRY(efi_scratch)
+	.fill 3,8,0
-- 
1.8.3

