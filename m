Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752056AbaBNHYf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Feb 2014 02:24:35 -0500
Received: from mail.skyhub.de ([78.46.96.112]:39341 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751643AbaBNHYd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Feb 2014 02:24:33 -0500
From: Borislav Petkov <bp@alien8.de>
To: Linux EFI <linux-efi@vger.kernel.org>
Cc: Matt Fleming <matt@console-pimps.org>, LKML <linux-kernel@vger.kernel.org>,
        Lejun Zhu <lejun.zhu@intel.com>, Borislav Petkov <bp@suse.de>
Subject: [PATCH] x86, efi: Fix 32-bit fallout
Date: Fri, 14 Feb 2014 08:24:24 +0100
Message-Id: <1392362664-26608-1-git-send-email-bp@alien8.de>
X-Mailer: git-send-email 1.8.5.2.192.g7794a68
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Borislav Petkov <bp@suse.de>

We do not enable the new efi memmap on 32-bit and thus we need to run
runtime_code_page_mkexec() unconditionally there. Fix that.

Reported-and-tested-by: Lejun Zhu <lejun.zhu@intel.com>
Cc: <stable@vger.kernel.org> # v3.14+
Signed-off-by: Borislav Petkov <bp@suse.de>
---
 arch/x86/include/asm/efi.h     | 2 ++
 arch/x86/platform/efi/efi.c    | 8 +++-----
 arch/x86/platform/efi/efi_32.c | 6 ++++++
 arch/x86/platform/efi/efi_64.c | 9 +++++++++
 4 files changed, 20 insertions(+), 5 deletions(-)

diff --git a/arch/x86/include/asm/efi.h b/arch/x86/include/asm/efi.h
index d3c099f53ff2..7fd9830285e0 100644
--- a/arch/x86/include/asm/efi.h
+++ b/arch/x86/include/asm/efi.h
@@ -133,6 +133,8 @@ extern int efi_setup_page_tables(unsigned long pa_memmap, unsigned num_pages);
 extern void efi_cleanup_page_tables(unsigned long pa_memmap, unsigned num_pages);
 extern void __init old_map_region(efi_memory_desc_t *md);
 extern void __init efi_dump_pagetable(void);
+extern void __init runtime_code_page_mkexec(void);
+extern void __init efi_runtime_mkexec(void);
 
 struct efi_setup_data {
 	u64 fw_vendor;
diff --git a/arch/x86/platform/efi/efi.c b/arch/x86/platform/efi/efi.c
index 0c8672b3f9a3..40e62ea52864 100644
--- a/arch/x86/platform/efi/efi.c
+++ b/arch/x86/platform/efi/efi.c
@@ -776,7 +776,7 @@ void __init efi_set_executable(efi_memory_desc_t *md, bool executable)
 		set_memory_nx(addr, npages);
 }
 
-static void __init runtime_code_page_mkexec(void)
+void __init runtime_code_page_mkexec(void)
 {
 	efi_memory_desc_t *md;
 	void *p;
@@ -1024,8 +1024,7 @@ static void __init kexec_enter_virtual_mode(void)
 	efi.update_capsule = virt_efi_update_capsule;
 	efi.query_capsule_caps = virt_efi_query_capsule_caps;
 
-	if (efi_enabled(EFI_OLD_MEMMAP) && (__supported_pte_mask & _PAGE_NX))
-		runtime_code_page_mkexec();
+	efi_runtime_mkexec();
 
 	/* clean DUMMY object */
 	efi.set_variable(efi_dummy_name, &EFI_DUMMY_GUID,
@@ -1125,8 +1124,7 @@ static void __init __efi_enter_virtual_mode(void)
 	efi.update_capsule = virt_efi_update_capsule;
 	efi.query_capsule_caps = virt_efi_query_capsule_caps;
 
-	if (efi_enabled(EFI_OLD_MEMMAP) && (__supported_pte_mask & _PAGE_NX))
-		runtime_code_page_mkexec();
+	efi_runtime_mkexec();
 
 	/*
 	 * We mapped the descriptor array into the EFI pagetable above but we're
diff --git a/arch/x86/platform/efi/efi_32.c b/arch/x86/platform/efi/efi_32.c
index 7ad87ee09525..9ee3491e31fb 100644
--- a/arch/x86/platform/efi/efi_32.c
+++ b/arch/x86/platform/efi/efi_32.c
@@ -82,3 +82,9 @@ void efi_call_phys_epilog(void)
 
 	local_irq_restore(efi_rt_eflags);
 }
+
+void __init efi_runtime_mkexec(void)
+{
+	if (__supported_pte_mask & _PAGE_NX)
+		runtime_code_page_mkexec();
+}
diff --git a/arch/x86/platform/efi/efi_64.c b/arch/x86/platform/efi/efi_64.c
index 0998f3a536ff..50cc39be2271 100644
--- a/arch/x86/platform/efi/efi_64.c
+++ b/arch/x86/platform/efi/efi_64.c
@@ -268,3 +268,12 @@ void __init efi_dump_pagetable(void)
 	ptdump_walk_pgd_level(NULL, pgd);
 #endif
 }
+
+void __init efi_runtime_mkexec(void)
+{
+	if (!efi_enabled(EFI_OLD_MEMMAP))
+		return;
+
+	if (__supported_pte_mask & _PAGE_NX)
+		runtime_code_page_mkexec();
+}
-- 
1.8.5.2.192.g7794a68

