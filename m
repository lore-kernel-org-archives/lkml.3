Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752504AbaIMSi5 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 13 Sep 2014 14:38:57 -0400
Received: from mga14.intel.com ([192.55.52.115]:60268 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752215AbaIMSh6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 13 Sep 2014 14:37:58 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.04,518,1406617200"; 
   d="scan'208";a="590897165"
From: Ricardo Neri <ricardo.neri-calderon@linux.intel.com>
To: Matt Fleming <matt.fleming@intel.com>
Cc: "H. Peter Anvin" <hpa@linux.intel.com>, linux-efi@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        "Glenn P. Williamson" <glenn.p.williamson@intel.com>,
        Ricardo Neri <ricardo.neri-calderon@linux.intel.com>
Subject: [PATCH 3/6] x86/efi: add code to fixup page faults in BOOT_SERVICES_* regions
Date: Sat, 13 Sep 2014 11:36:13 -0700
Message-Id: <1410633376-8822-4-git-send-email-ricardo.neri-calderon@linux.intel.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1410633376-8822-1-git-send-email-ricardo.neri-calderon@linux.intel.com>
References: <1410633376-8822-1-git-send-email-ricardo.neri-calderon@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

As per the UEFI specification, accesses to BOOT_SERVICES_* memory
regions by the UEFI firmware are illegal after the OS has called
ExitBootServices. However, buggy firmware implementations may still
access these regions after such call.

The current approach of the kernel is to reserve and map all the
EFI_BOOT_SERVICES_* memory regions until efi_free_boot_services() is
called so that the buggy firmware can freely access such regions.

A good way to detect these illegal accesses is to not map (but only
reserve) these regions so that the accesses generate a page fault that
the kernel can detect. Upon detection, the fault is fixed-up (i.e., the
region is mapped for the buggy firmware to use). As the pages are
reserved, the fixup is safe.

Thus, rather than just silently allowing the buggy firmware to proceed,
we detect the access and complain about it. Of course, this function
will be called by the page fault handler fixup code in a subsequent
patch.

Ideally, the new memory map with the just mapped region should be passed
to the firmware. However, as per the UEFI specification,
SetVirtualAddressMap may be called only once. Subsequent calls will
return EFI_UNSUPPORTED. Thus, it is pointless to pass the new map.
Furthermore, all the EFI_RUNTIME_SERVICES_* should already be mapped at
this point.

Also, at this point, the virtual address of the system table should have
been found. Thus, there is no need to look for it in the just-mapped
region.

Finally, this new mapping will not impact a reboot from kexec, as kexec
is only concerned about runtime memory regions.

Signed-off-by: Ricardo Neri <ricardo.neri-calderon@linux.intel.com>
---
 arch/x86/platform/efi/efi.c | 29 +++++++++++++++++++++++++++++
 include/linux/efi.h         |  8 ++++++++
 2 files changed, 37 insertions(+)

diff --git a/arch/x86/platform/efi/efi.c b/arch/x86/platform/efi/efi.c
index d45decf..2e78083 100644
--- a/arch/x86/platform/efi/efi.c
+++ b/arch/x86/platform/efi/efi.c
@@ -954,3 +954,32 @@ static int __init parse_efi_cmdline(char *str)
 	return 0;
 }
 early_param("efi", parse_efi_cmdline);
+
+#ifdef CONFIG_EFI_BOOT_SERVICES_WARN
+static const char boot_services_warning[] =
+"Fixing illegal access to BOOT_SERVICES_*. Bug in EFI firmware?\n";
+
+int efi_boot_services_fixup(unsigned long phys_addr)
+{
+	efi_memory_desc_t *md;
+
+	md = efi_memory_descriptor(phys_addr);
+
+	if (!md)
+		return 0;
+
+	if (md->type == EFI_BOOT_SERVICES_CODE ||
+	    md->type == EFI_BOOT_SERVICES_DATA)	{
+		/*
+		 * If the page fault was caused by an acccess to BOOT_SERVICES_*
+		 * memory regions, just map the region... and warn about it.
+		 * By now we should have found the virtual address of the system
+		 * table. Thus, no need to update.
+		 */
+		pr_warn_once("%s", (char *)&boot_services_warning);
+		efi_map_region(md);
+		return 1;
+	}
+	return 0;
+}
+#endif
diff --git a/include/linux/efi.h b/include/linux/efi.h
index b36b588..fbdc412 100644
--- a/include/linux/efi.h
+++ b/include/linux/efi.h
@@ -875,6 +875,14 @@ extern void efi_initialize_iomem_resources(struct resource *code_resource,
 		struct resource *data_resource, struct resource *bss_resource);
 extern void efi_get_time(struct timespec *now);
 extern void efi_reserve_boot_services(void);
+#ifdef CONFIG_EFI_BOOT_SERVICES_WARN
+extern int efi_boot_services_fixup(unsigned long phys_addr);
+#else
+static inline int efi_boot_services_fixup(unsigned long phys_addr)
+{
+		return 0;
+}
+#endif
 extern int efi_get_fdt_params(struct efi_fdt_params *params, int verbose);
 extern struct efi_memory_map memmap;
 
-- 
1.9.1

