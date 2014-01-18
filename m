Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753877AbaARLtF (ORCPT <rfc822;w@1wt.eu>);
	Sat, 18 Jan 2014 06:49:05 -0500
Received: from mail.skyhub.de ([78.46.96.112]:49959 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752155AbaARLsb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 18 Jan 2014 06:48:31 -0500
From: Borislav Petkov <bp@alien8.de>
To: Linux EFI <linux-efi@vger.kernel.org>
Cc: LKML <linux-kernel@vger.kernel.org>, Borislav Petkov <bp@suse.de>,
        Matt Fleming <matt@console-pimps.org>,
        Matthew Garrett <mjg59@srcf.ucam.org>,
        "H. Peter Anvin" <hpa@zytor.com>, Toshi Kani <toshi.kani@hp.com>
Subject: [PATCH 2/5] efi: Dump the EFI page table
Date: Sat, 18 Jan 2014 12:48:15 +0100
Message-Id: <1390045698-16882-3-git-send-email-bp@alien8.de>
X-Mailer: git-send-email 1.8.5.2.192.g7794a68
In-Reply-To: <1390045698-16882-1-git-send-email-bp@alien8.de>
References: <1390045698-16882-1-git-send-email-bp@alien8.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Borislav Petkov <bp@suse.de>

This is very useful for debugging issues with the recently added
pagetable switching code for EFI virtual mode.

Signed-off-by: Borislav Petkov <bp@suse.de>
Tested-by: Toshi Kani <toshi.kani@hp.com>
---
 arch/x86/Kconfig               | 9 +++++++++
 arch/x86/include/asm/efi.h     | 1 +
 arch/x86/platform/efi/efi.c    | 1 +
 arch/x86/platform/efi/efi_32.c | 1 +
 arch/x86/platform/efi/efi_64.c | 9 +++++++++
 5 files changed, 21 insertions(+)

diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
index 02241d8dcab6..ba0d86cca926 100644
--- a/arch/x86/Kconfig
+++ b/arch/x86/Kconfig
@@ -1614,6 +1614,15 @@ config EFI_STUB
 
 	  See Documentation/efi-stub.txt for more information.
 
+config EFI_PGT_DUMP
+	bool "Dump the EFI pagetable"
+	depends on EFI && X86_PTDUMP
+	---help---
+	  Enable this if you want to dump the EFI page table before
+	  enabling virtual mode. This can be used to debug miscellaneous
+	  issues with the mapping of the EFI runtime regions into that
+	  table.
+
 config SECCOMP
 	def_bool y
 	prompt "Enable seccomp to safely compute untrusted bytecode"
diff --git a/arch/x86/include/asm/efi.h b/arch/x86/include/asm/efi.h
index 3b978c472d08..dfc319e7a7b8 100644
--- a/arch/x86/include/asm/efi.h
+++ b/arch/x86/include/asm/efi.h
@@ -132,6 +132,7 @@ extern void __init efi_map_region_fixed(efi_memory_desc_t *md);
 extern void efi_sync_low_kernel_mappings(void);
 extern void efi_setup_page_tables(void);
 extern void __init old_map_region(efi_memory_desc_t *md);
+extern void __init efi_dump_pagetable(void);
 
 struct efi_setup_data {
 	u64 fw_vendor;
diff --git a/arch/x86/platform/efi/efi.c b/arch/x86/platform/efi/efi.c
index d62ec87a2b26..35450ab3a123 100644
--- a/arch/x86/platform/efi/efi.c
+++ b/arch/x86/platform/efi/efi.c
@@ -1033,6 +1033,7 @@ void __init efi_enter_virtual_mode(void)
 
 	efi_setup_page_tables();
 	efi_sync_low_kernel_mappings();
+	efi_dump_pagetable();
 
 	if (!efi_setup) {
 		status = phys_efi_set_virtual_address_map(
diff --git a/arch/x86/platform/efi/efi_32.c b/arch/x86/platform/efi/efi_32.c
index 249b183cf417..b9b827cbfecc 100644
--- a/arch/x86/platform/efi/efi_32.c
+++ b/arch/x86/platform/efi/efi_32.c
@@ -41,6 +41,7 @@ static unsigned long efi_rt_eflags;
 
 void efi_sync_low_kernel_mappings(void) {}
 void efi_setup_page_tables(void) {}
+void __init efi_dump_pagetable(void) {}
 
 void __init efi_map_region(efi_memory_desc_t *md)
 {
diff --git a/arch/x86/platform/efi/efi_64.c b/arch/x86/platform/efi/efi_64.c
index 6284f158a47d..76fce828c31d 100644
--- a/arch/x86/platform/efi/efi_64.c
+++ b/arch/x86/platform/efi/efi_64.c
@@ -233,3 +233,12 @@ void __init parse_efi_setup(u64 phys_addr, u32 data_len)
 {
 	efi_setup = phys_addr + sizeof(struct setup_data);
 }
+
+void __init efi_dump_pagetable(void)
+{
+#ifdef CONFIG_EFI_PGT_DUMP
+	pgd_t *pgd = (pgd_t *)__va(real_mode_header->trampoline_pgd);
+
+	ptdump_walk_pgd_level(NULL, pgd);
+#endif
+}
-- 
1.8.5.2.192.g7794a68

