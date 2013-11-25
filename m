Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754262Ab3KYJIk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Nov 2013 04:08:40 -0500
Received: from mx1.redhat.com ([209.132.183.28]:52336 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753478Ab3KYJIg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Nov 2013 04:08:36 -0500
Message-Id: <20131125090034.636810276@dhcp-16-126.nay.redhat.com>
User-Agent: quilt/0.60-1
Date: Mon, 25 Nov 2013 16:56:32 +0800
From: dyoung@redhat.com
To: linux-kernel@vger.kernel.org
Cc: linux-efi@vger.kernel.org, x86@kernel.org, mjg59@srcf.ucam.org,
        hpa@zytor.com, James.Bottomley@HansenPartnership.com,
        vgoyal@redhat.com, ebiederm@xmission.com, horms@verge.net.au,
        kexec@lists.infradead.org, bp@alien8.de, greg@kroah.com,
        matt@console-pimps.org, toshi.kani@hp.com,
        Dave Young <dyoung@redhat.com>, Borislav Petkov <bp@suse.de>
Subject: [patch 02/12 v4] efi: add a wrapper function efi_map_region_fixed
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,
References: <20131125085630.417850406@dhcp-16-126.nay.redhat.com>
Content-Disposition: inline; filename=02-efi-map-fixed-addr.patch

Kexec kernel will use saved runtime virtual mapping, so add a
new function efi_map_region_fixed for directly mapping a md
to md->virt.

The md is passed in from 1st kernel, the virtual addr is
saved in md->virt_addr.

Matt: coding style
      reuse __map_region
Boris: Strenthen comment lines to 80 cols.

Signed-off-by: Dave Young <dyoung@redhat.com>
Acked-by: Borislav Petkov <bp@suse.de>
---
 arch/x86/include/asm/efi.h     |    1 +
 arch/x86/platform/efi/efi_32.c |    2 ++
 arch/x86/platform/efi/efi_64.c |   10 ++++++++++
 3 files changed, 13 insertions(+)

--- efi.orig/arch/x86/include/asm/efi.h
+++ efi/arch/x86/include/asm/efi.h
@@ -128,6 +128,7 @@ extern void efi_call_phys_epilog(void);
 extern void efi_unmap_memmap(void);
 extern void efi_memory_uc(u64 addr, unsigned long size);
 extern void __init efi_map_region(efi_memory_desc_t *md);
+extern void __init efi_map_region_fixed(efi_memory_desc_t *md);
 extern void efi_sync_low_kernel_mappings(void);
 extern void efi_setup_page_tables(void);
 extern void __init old_map_region(efi_memory_desc_t *md);
--- efi.orig/arch/x86/platform/efi/efi_64.c
+++ efi/arch/x86/platform/efi/efi_64.c
@@ -199,6 +199,16 @@ void __init efi_map_region(efi_memory_de
 	md->virt_addr = efi_va;
 }
 
+/*
+ * kexec kernel will use efi_map_region_fixed to map efi runtime memory ranges.
+ * md->virt_addr is the original virtual address which had been mapped in kexec
+ * 1st kernel.
+ */
+void __init efi_map_region_fixed(efi_memory_desc_t *md)
+{
+	__map_region(md, md->virt_addr);
+}
+
 void __iomem *__init efi_ioremap(unsigned long phys_addr, unsigned long size,
 				 u32 type, u64 attribute)
 {
--- efi.orig/arch/x86/platform/efi/efi_32.c
+++ efi/arch/x86/platform/efi/efi_32.c
@@ -47,6 +47,8 @@ void __init efi_map_region(efi_memory_de
 	old_map_region(md);
 }
 
+void __init efi_map_region_fixed(efi_memory_desc_t *md) {}
+
 void efi_call_phys_prelog(void)
 {
 	struct desc_ptr gdt_descr;

