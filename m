Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754522Ab3KZGAu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Nov 2013 01:00:50 -0500
Received: from mx1.redhat.com ([209.132.183.28]:51658 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754446Ab3KZGAp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Nov 2013 01:00:45 -0500
From: Dave Young <dyoung@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: linux-efi@vger.kernel.org, x86@kernel.org, mjg59@srcf.ucam.org,
        hpa@zytor.com, James.Bottomley@HansenPartnership.com,
        vgoyal@redhat.com, ebiederm@xmission.com, horms@verge.net.au,
        kexec@lists.infradead.org, bp@alien8.de, greg@kroah.com,
        matt@console-pimps.org, toshi.kani@hp.com
Subject: [PATCH v4 08/12] efi: only print saved efi runtime maps instead of all memmap ranges for kexec
Date: Tue, 26 Nov 2013 13:57:53 +0800
Message-Id: <1385445477-9665-9-git-send-email-dyoung@redhat.com>
In-Reply-To: <1385445477-9665-1-git-send-email-dyoung@redhat.com>
References: <1385445477-9665-1-git-send-email-dyoung@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

For kexec/kdump kernel efi runtime mappings are saved, printing original whole
memmap ranges does not make sense anymore. So introduce a new function to only
print runtime maps in case kexec/kdump kernel is used.

Signed-off-by: Dave Young <dyoung@redhat.com>
---
 arch/x86/platform/efi/efi.c | 23 ++++++++++++++++++++++-
 1 file changed, 22 insertions(+), 1 deletion(-)

diff --git a/arch/x86/platform/efi/efi.c b/arch/x86/platform/efi/efi.c
index fafeb40..c65b0b8 100644
--- a/arch/x86/platform/efi/efi.c
+++ b/arch/x86/platform/efi/efi.c
@@ -430,6 +430,24 @@ int __init efi_memblock_x86_reserve_range(void)
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
-- 
1.8.3.1

