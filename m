Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753364Ab3KYIst (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Nov 2013 03:48:49 -0500
Received: from mx1.redhat.com ([209.132.183.28]:26905 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752629Ab3KYIsq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Nov 2013 03:48:46 -0500
Message-Id: <20131125084810.820708838@dhcp-16-126.nay.redhat.com>
User-Agent: quilt/0.60-1
Date: Mon, 25 Nov 2013 16:47:09 +0800
From: dyoung@redhat.com
To: linux-kernel@vger.kernel.org
Cc: linux-efi@vger.kernel.org, x86@kernel.org, mjg59@srcf.ucam.org,
        hpa@zytor.com, James.Bottomley@HansenPartnership.com,
        vgoyal@redhat.com, ebiederm@xmission.com, horms@verge.net.au,
        kexec@lists.infradead.org, bp@alien8.de, greg@kroah.com,
        matt@console-pimps.org, toshi.kani@hp.com,
        Dave Young <dyoung@redhat.com>
Subject-Prefi: [patch @num@/@total@ v4]
Subject: Only print saved efi runtime maps instead of all memmap ranges.
References: <20131125084659.182036023@dhcp-16-126.nay.redhat.com>
Content-Disposition: inline; filename=10-print-efi-runtime-memmap.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

For kexec/kdump kernel efi runtime mappings are saved, printing original whole
memmap ranges does not make sense anymore. So introduce a new function to only
print runtime maps in case kexec/kdump kernel is used.

Signed-off-by: Dave Young <dyoung@redhat.com>
---
 arch/x86/platform/efi/efi.c |   23 ++++++++++++++++++++++-
 1 file changed, 22 insertions(+), 1 deletion(-)

--- efi.orig/arch/x86/platform/efi/efi.c
+++ efi/arch/x86/platform/efi/efi.c
@@ -430,6 +430,24 @@ int __init efi_memblock_x86_reserve_rang
 	return 0;
 }
 
+/* for kexec kernel runtime maps are passed in setup_data */
+static void __init print_saved_runtime_map(void)
+{
+#ifdef EFI_DEBUG
+	int i;
+	efi_memory_desc_t *md;
+
+	for (i = 0; i < nr_efi_runtime_map; i++) {
+		md = esdata->map + i;
+		pr_info("mem%02u: type=%u, attr=0x%llx, "
+			"range=[0x%016llx-0x%016llx) (%lluMB)\n",
+			i, md->type, md->attribute, md->phys_addr,
+			md->phys_addr + (md->num_pages << EFI_PAGE_SHIFT),
+			(md->num_pages >> (20 - EFI_PAGE_SHIFT)));
+	}
+#endif  /*  EFI_DEBUG  */
+}
+
 static void __init print_efi_memmap(void)
 {
 #ifdef EFI_DEBUG
@@ -782,7 +800,10 @@ void __init efi_init(void)
 		x86_platform.set_wallclock = efi_set_rtc_mmss;
 	}
 #endif
-	print_efi_memmap();
+	if (esdata)
+		print_saved_runtime_map();
+	else
+		print_efi_memmap();
 }
 
 void __init efi_late_init(void)

