Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753036Ab3LPJcC (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Dec 2013 04:32:02 -0500
Received: from mx1.redhat.com ([209.132.183.28]:14269 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752977Ab3LPJb5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Dec 2013 04:31:57 -0500
From: Dave Young <dyoung@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: linux-efi@vger.kernel.org, x86@kernel.org, mjg59@srcf.ucam.org,
        hpa@zytor.com, James.Bottomley@HansenPartnership.com,
        vgoyal@redhat.com, ebiederm@xmission.com, horms@verge.net.au,
        kexec@lists.infradead.org, bp@alien8.de, greg@kroah.com,
        matt@console-pimps.org, toshi.kani@hp.com, akpm@linux-foundation.org,
        mingo@kernel.org, msalter@redhat.com, leif.lindholm@linaro.org
Subject: [PATCH v6 04/14] efi: add a wrapper function efi_map_region_fixed
Date: Mon, 16 Dec 2013 17:30:25 +0800
Message-Id: <1387186235-15972-5-git-send-email-dyoung@redhat.com>
In-Reply-To: <1387186235-15972-1-git-send-email-dyoung@redhat.com>
References: <1387186235-15972-1-git-send-email-dyoung@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

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
 arch/x86/include/asm/efi.h     |  1 +
 arch/x86/platform/efi/efi_32.c |  2 ++
 arch/x86/platform/efi/efi_64.c | 10 ++++++++++
 3 files changed, 13 insertions(+)

diff --git a/arch/x86/include/asm/efi.h b/arch/x86/include/asm/efi.h
index 89a05b0..9fbaeb2 100644
--- a/arch/x86/include/asm/efi.h
+++ b/arch/x86/include/asm/efi.h
@@ -128,6 +128,7 @@ extern void efi_call_phys_epilog(void);
 extern void efi_unmap_memmap(void);
 extern void efi_memory_uc(u64 addr, unsigned long size);
 extern void __init efi_map_region(efi_memory_desc_t *md);
+extern void __init efi_map_region_fixed(efi_memory_desc_t *md);
 extern void efi_sync_low_kernel_mappings(void);
 extern void efi_setup_page_tables(void);
 extern void __init old_map_region(efi_memory_desc_t *md);
diff --git a/arch/x86/platform/efi/efi_32.c b/arch/x86/platform/efi/efi_32.c
index e94557c..7b3ec6e 100644
--- a/arch/x86/platform/efi/efi_32.c
+++ b/arch/x86/platform/efi/efi_32.c
@@ -47,6 +47,8 @@ void __init efi_map_region(efi_memory_desc_t *md)
 	old_map_region(md);
 }
 
+void __init efi_map_region_fixed(efi_memory_desc_t *md) {}
+
 void efi_call_phys_prelog(void)
 {
 	struct desc_ptr gdt_descr;
diff --git a/arch/x86/platform/efi/efi_64.c b/arch/x86/platform/efi/efi_64.c
index c5a6491..ff08cb1 100644
--- a/arch/x86/platform/efi/efi_64.c
+++ b/arch/x86/platform/efi/efi_64.c
@@ -199,6 +199,16 @@ void __init efi_map_region(efi_memory_desc_t *md)
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
-- 
1.8.3.1

