Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751848Ab3LPXgp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Dec 2013 18:36:45 -0500
Received: from mail.skyhub.de ([78.46.96.112]:44153 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750939Ab3LPXgn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Dec 2013 18:36:43 -0500
From: Borislav Petkov <bp@alien8.de>
To: Linux EFI <linux-efi@vger.kernel.org>, X86 ML <x86@kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Cc: Borislav Petkov <bp@suse.de>, Matt Fleming <matt@console-pimps.org>,
        Matthew Garrett <mjg59@srcf.ucam.org>,
        "H. Peter Anvin" <hpa@zytor.com>, Dave Young <dyoung@redhat.com>,
        James Bottomley <James.Bottomley@HansenPartnership.com>,
        Vivek Goyal <vgoyal@redhat.com>, Toshi Kani <toshi.kani@hp.com>,
        Arjan van de Ven <arjan@linux.intel.com>
Subject: [PATCH 2/3] efi: Dump the EFI page table
Date: Tue, 17 Dec 2013 00:36:36 +0100
Message-Id: <1387236997-26975-3-git-send-email-bp@alien8.de>
X-Mailer: git-send-email 1.8.4
In-Reply-To: <1387236997-26975-1-git-send-email-bp@alien8.de>
References: <1387236997-26975-1-git-send-email-bp@alien8.de>
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
index 7d8caccbf2f3..51d6285701e9 100644
--- a/arch/x86/platform/efi/efi.c
+++ b/arch/x86/platform/efi/efi.c
@@ -740,6 +740,15 @@ void efi_memory_uc(u64 addr, unsigned long size)
 	set_memory_uc(addr, npages);
 }
 
+static void efi_dump_pagetable(void)
+{
+#if defined(EFI_DEBUG) && defined(CONFIG_X86_PTDUMP)
+	pgd_t *pgd = (pgd_t *)__va(real_mode_header->trampoline_pgd);
+
+	walk_pgd_level(NULL, pgd);
+#endif
+}
+
 void __init old_map_region(efi_memory_desc_t *md)
 {
 	u64 start_pfn, end_pfn, end;
@@ -869,6 +878,8 @@ void __init efi_enter_virtual_mode(void)
 	efi_setup_page_tables();
 	efi_sync_low_kernel_mappings();
 
+	efi_dump_pagetable();
+
 	status = phys_efi_set_virtual_address_map(
 		memmap.desc_size * count,
 		memmap.desc_size,
-- 
1.8.4

