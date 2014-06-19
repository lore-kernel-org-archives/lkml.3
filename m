Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932553AbaFSNkk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jun 2014 09:40:40 -0400
Received: from mail-wi0-f196.google.com ([209.85.212.196]:62187 "EHLO
	mail-wi0-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932138AbaFSNkf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jun 2014 09:40:35 -0400
From: Matt Fleming <matt@console-pimps.org>
To: linux-efi@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Alan Cox <alan@lxorguk.ukuu.org.uk>,
        "H. Peter Anvin" <hpa@zytor.com>, Mark Salter <msalter@redhat.com>,
        Aubrey Li <aubrey.li@linux.intel.com>,
        Matt Fleming <matt.fleming@intel.com>, Len Brown <len.brown@intel.com>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>
Subject: [PATCH 3/3] x86/reboot: Add EFI reboot quirk for ACPI Hardware Reduced flag
Date: Thu, 19 Jun 2014 14:40:25 +0100
Message-Id: <1403185225-9031-4-git-send-email-matt@console-pimps.org>
X-Mailer: git-send-email 1.9.0
In-Reply-To: <1403185225-9031-1-git-send-email-matt@console-pimps.org>
References: <1403185225-9031-1-git-send-email-matt@console-pimps.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Matt Fleming <matt.fleming@intel.com>

It appears that the BayTrail-T class of hardware requires EFI in order
to powerdown and reboot and no other reliable method exists.

This quirk is generally applicable to all hardware that has the ACPI
Hardware Reduced bit set, since usually ACPI would be the preferred
method.

Cc: Len Brown <len.brown@intel.com>
Cc: Mark Salter <msalter@redhat.com>
Cc: "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>
Signed-off-by: Matt Fleming <matt.fleming@intel.com>
---
 arch/x86/include/asm/efi.h     |  6 ++++++
 arch/x86/kernel/reboot.c       | 18 ++++++++++++++++--
 arch/x86/platform/efi/quirks.c | 23 +++++++++++++++++++++++
 drivers/firmware/efi/reboot.c  |  8 ++++++++
 include/linux/efi.h            |  1 +
 5 files changed, 54 insertions(+), 2 deletions(-)

diff --git a/arch/x86/include/asm/efi.h b/arch/x86/include/asm/efi.h
index 3dbf56eb540d..5d71d0eb50b3 100644
--- a/arch/x86/include/asm/efi.h
+++ b/arch/x86/include/asm/efi.h
@@ -158,6 +158,8 @@ static inline efi_status_t efi_thunk_set_virtual_address_map(
 	return EFI_SUCCESS;
 }
 #endif /* CONFIG_EFI_MIXED */
+
+extern bool efi_reboot_required(void);
 #else
 /*
  * IF EFI is not configured, have the EFI calls return -ENOSYS.
@@ -170,6 +172,10 @@ static inline efi_status_t efi_thunk_set_virtual_address_map(
 #define efi_call5(_f, _a1, _a2, _a3, _a4, _a5)		(-ENOSYS)
 #define efi_call6(_f, _a1, _a2, _a3, _a4, _a5, _a6)	(-ENOSYS)
 static inline void parse_efi_setup(u64 phys_addr, u32 data_len) {}
+static inline bool efi_reboot_required(void)
+{
+	return false;
+}
 #endif /* CONFIG_EFI */
 
 #endif /* _ASM_X86_EFI_H */
diff --git a/arch/x86/kernel/reboot.c b/arch/x86/kernel/reboot.c
index 09e709fd1830..17962e667a91 100644
--- a/arch/x86/kernel/reboot.c
+++ b/arch/x86/kernel/reboot.c
@@ -28,6 +28,7 @@
 #include <linux/mc146818rtc.h>
 #include <asm/realmode.h>
 #include <asm/x86_init.h>
+#include <asm/efi.h>
 
 /*
  * Power off function, if any
@@ -401,12 +402,25 @@ static struct dmi_system_id __initdata reboot_dmi_table[] = {
 
 static int __init reboot_init(void)
 {
+	int rv;
+
 	/*
 	 * Only do the DMI check if reboot_type hasn't been overridden
 	 * on the command line
 	 */
-	if (reboot_default)
-		dmi_check_system(reboot_dmi_table);
+	if (!reboot_default)
+		return 0;
+
+	/*
+	 * The DMI quirks table takes precedence. If no quirks entry
+	 * matches and the ACPI Hardware Reduced bit is set, force EFI
+	 * reboot.
+	 */
+	rv = dmi_check_system(reboot_dmi_table);
+
+	if (!rv && efi_reboot_required())
+		reboot_type = BOOT_EFI;
+
 	return 0;
 }
 core_initcall(reboot_init);
diff --git a/arch/x86/platform/efi/quirks.c b/arch/x86/platform/efi/quirks.c
index b4cb9182f155..1c7380da65ff 100644
--- a/arch/x86/platform/efi/quirks.c
+++ b/arch/x86/platform/efi/quirks.c
@@ -7,6 +7,7 @@
 #include <linux/slab.h>
 #include <linux/memblock.h>
 #include <linux/bootmem.h>
+#include <linux/acpi.h>
 #include <asm/efi.h>
 #include <asm/uv/uv.h>
 
@@ -265,3 +266,25 @@ void __init efi_apply_memmap_quirks(void)
 	if (is_uv_system())
 		set_bit(EFI_OLD_MEMMAP, &efi.flags);
 }
+
+/*
+ * For most modern platforms the preferred method of powering off is via
+ * ACPI. However, there are some that are known to require the use of
+ * EFI runtime services and for which ACPI does not work at all.
+ *
+ * Using EFI is a last resort, to be used only if no other option
+ * exists.
+ */
+bool efi_reboot_required(void)
+{
+	if (!acpi_gbl_reduced_hardware)
+		return false;
+
+	efi_reboot_quirk_mode = EFI_RESET_WARM;
+	return true;
+}
+
+bool efi_poweroff_required(void)
+{
+	return !!acpi_gbl_reduced_hardware;
+}
diff --git a/drivers/firmware/efi/reboot.c b/drivers/firmware/efi/reboot.c
index 794a276dbe92..f94fb95db3b7 100644
--- a/drivers/firmware/efi/reboot.c
+++ b/drivers/firmware/efi/reboot.c
@@ -4,6 +4,8 @@
 #include <linux/efi.h>
 #include <linux/reboot.h>
 
+int efi_reboot_quirk_mode = -1;
+
 void efi_reboot(enum reboot_mode reboot_mode, const char *__unused)
 {
 	int efi_mode;
@@ -21,6 +23,12 @@ void efi_reboot(enum reboot_mode reboot_mode, const char *__unused)
 		break;
 	}
 
+	/*
+	 * If a quirk forced an EFI reset mode, always use that.
+	 */
+	if (efi_reboot_quirk_mode != -1)
+		efi_mode = efi_reboot_quirk_mode;
+
 	efi.reset_system(efi_mode, EFI_SUCCESS, 0, NULL);
 }
 
diff --git a/include/linux/efi.h b/include/linux/efi.h
index 2539aff31808..b3fac7c1656c 100644
--- a/include/linux/efi.h
+++ b/include/linux/efi.h
@@ -876,6 +876,7 @@ extern void efi_reserve_boot_services(void);
 extern int efi_get_fdt_params(struct efi_fdt_params *params, int verbose);
 extern struct efi_memory_map memmap;
 
+extern int efi_reboot_quirk_mode;
 extern bool efi_poweroff_required(void);
 
 /* Iterate through an efi_memory_map */
-- 
1.9.0

