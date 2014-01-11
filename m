Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753886AbaAKUto (ORCPT <rfc822;w@1wt.eu>);
	Sat, 11 Jan 2014 15:49:44 -0500
Received: from mail.skyhub.de ([78.46.96.112]:56798 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751986AbaAKUtk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 11 Jan 2014 15:49:40 -0500
From: Borislav Petkov <bp@alien8.de>
To: Linux EFI <linux-efi@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>
Cc: Borislav Petkov <bp@suse.de>, Matt Fleming <matt@console-pimps.org>,
        Matthew Garrett <mjg59@srcf.ucam.org>,
        "H. Peter Anvin" <hpa@zytor.com>, Dave Young <dyoung@redhat.com>,
        Toshi Kani <toshi.kani@hp.com>
Subject: [PATCH 2/4] efi: Dump the EFI page table
Date: Sat, 11 Jan 2014 21:49:28 +0100
Message-Id: <1389473370-1940-3-git-send-email-bp@alien8.de>
X-Mailer: git-send-email 1.8.5.2.192.g7794a68
In-Reply-To: <1389473370-1940-1-git-send-email-bp@alien8.de>
References: <1389473370-1940-1-git-send-email-bp@alien8.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Borislav Petkov <bp@suse.de>

This is very useful for debugging issues with the recently added
pagetable switching code for EFI virtual mode.

Signed-off-by: Borislav Petkov <bp@suse.de>
---
 arch/x86/platform/efi/efi.c | 11 +++++++++++
 1 file changed, 11 insertions(+)

diff --git a/arch/x86/platform/efi/efi.c b/arch/x86/platform/efi/efi.c
index d62ec87a2b26..c34be4ce94c9 100644
--- a/arch/x86/platform/efi/efi.c
+++ b/arch/x86/platform/efi/efi.c
@@ -54,6 +54,7 @@
 #include <asm/rtc.h>
 
 #define EFI_DEBUG
+#undef EFI_PGT_DBG
 
 #define EFI_MIN_RESERVE 5120
 
@@ -818,6 +819,15 @@ void efi_memory_uc(u64 addr, unsigned long size)
 	set_memory_uc(addr, npages);
 }
 
+static void dump_pagetable(void)
+{
+#if defined(EFI_PGT_DBG) && defined(CONFIG_X86_PTDUMP)
+	pgd_t *pgd = (pgd_t *)__va(real_mode_header->trampoline_pgd);
+
+	walk_pgd_level(NULL, pgd);
+#endif
+}
+
 void __init old_map_region(efi_memory_desc_t *md)
 {
 	u64 start_pfn, end_pfn, end;
@@ -1033,6 +1043,7 @@ void __init efi_enter_virtual_mode(void)
 
 	efi_setup_page_tables();
 	efi_sync_low_kernel_mappings();
+	dump_pagetable();
 
 	if (!efi_setup) {
 		status = phys_efi_set_virtual_address_map(
-- 
1.8.5.2.192.g7794a68

