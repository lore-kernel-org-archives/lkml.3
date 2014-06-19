Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755568AbaFSNlC (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jun 2014 09:41:02 -0400
Received: from mail-wi0-f194.google.com ([209.85.212.194]:42316 "EHLO
	mail-wi0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754697AbaFSNkc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jun 2014 09:40:32 -0400
From: Matt Fleming <matt@console-pimps.org>
To: linux-efi@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Alan Cox <alan@lxorguk.ukuu.org.uk>,
        "H. Peter Anvin" <hpa@zytor.com>, Mark Salter <msalter@redhat.com>,
        Aubrey Li <aubrey.li@linux.intel.com>,
        Matt Fleming <matt.fleming@intel.com>
Subject: [PATCH 2/3] efi/reboot: Allow powering off machines using EFI
Date: Thu, 19 Jun 2014 14:40:24 +0100
Message-Id: <1403185225-9031-3-git-send-email-matt@console-pimps.org>
X-Mailer: git-send-email 1.9.0
In-Reply-To: <1403185225-9031-1-git-send-email-matt@console-pimps.org>
References: <1403185225-9031-1-git-send-email-matt@console-pimps.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Matt Fleming <matt.fleming@intel.com>

Not only can EfiResetSystem() be used to reboot, it can also be used to
power down machines.

By and large, this functionality doesn't work very well across the range
of EFI machines in the wild, so it should definitely only be used as a
last resort. In an ideal world, this wouldn't be needed at all.

Unfortunately, we're starting to see machines where EFI is the *only*
reliable way to power down, and nothing else, not PCI, not ACPI, works.

efi_poweroff_required() should be implemented on a per-architecture
basis, since exactly when we should be using EFI runtime services is a
platform-specific decision. There's no analogue for reboot because each
architecture handles reboot very differently - the x86 code in
particular is pretty complex.

Patches to enable this for specific classes of hardware will be
submitted separately.

Cc: Mark Salter <msalter@redhat.com>
Signed-off-by: Matt Fleming <matt.fleming@intel.com>
---
 drivers/firmware/efi/reboot.c | 22 ++++++++++++++++++++++
 include/linux/efi.h           |  2 ++
 2 files changed, 24 insertions(+)

diff --git a/drivers/firmware/efi/reboot.c b/drivers/firmware/efi/reboot.c
index d10acc0a0370..794a276dbe92 100644
--- a/drivers/firmware/efi/reboot.c
+++ b/drivers/firmware/efi/reboot.c
@@ -23,3 +23,25 @@ void efi_reboot(enum reboot_mode reboot_mode, const char *__unused)
 
 	efi.reset_system(efi_mode, EFI_SUCCESS, 0, NULL);
 }
+
+bool __weak efi_poweroff_required(void)
+{
+	return false;
+}
+
+static void efi_power_off(void)
+{
+	efi.reset_system(EFI_RESET_SHUTDOWN, EFI_SUCCESS, 0, NULL);
+}
+
+static int __init efi_shutdown_init(void)
+{
+	if (!efi_enabled(EFI_RUNTIME_SERVICES))
+		return -ENODEV;
+
+	if (efi_poweroff_required())
+		pm_power_off = efi_power_off;
+
+	return 0;
+}
+late_initcall(efi_shutdown_init);
diff --git a/include/linux/efi.h b/include/linux/efi.h
index 0958d4bb399f..2539aff31808 100644
--- a/include/linux/efi.h
+++ b/include/linux/efi.h
@@ -876,6 +876,8 @@ extern void efi_reserve_boot_services(void);
 extern int efi_get_fdt_params(struct efi_fdt_params *params, int verbose);
 extern struct efi_memory_map memmap;
 
+extern bool efi_poweroff_required(void);
+
 /* Iterate through an efi_memory_map */
 #define for_each_efi_memory_desc(m, md)					   \
 	for ((md) = (m)->map;						   \
-- 
1.9.0

