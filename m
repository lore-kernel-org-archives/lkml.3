Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753560AbaFHKKL (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Jun 2014 06:10:11 -0400
Received: from mail-ie0-f180.google.com ([209.85.223.180]:59467 "EHLO
	mail-ie0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753543AbaFHKKJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Jun 2014 06:10:09 -0400
From: Yi Li <yi.li@linaro.org>
To: ard.biesheuvel@linaro.org, msalter@redhat.com, catalin.marinas@arm.com,
        will.deacon@arm.com, sudeep.karkadanagesha@arm.com,
        steve.capper@linaro.org, lorenzo.pieralisi@arm.com,
        liviu.dudau@arm.com, grant.likely@linaro.org, mark.rutland@arm.com
Cc: yi.li@linaro.org, phoenix.liyi@huawei.com,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: [PATCH v2] arm64: dmi: Add SMBIOS/DMI support on arm64
Date: Sun,  8 Jun 2014 18:09:25 +0800
Message-Id: <1402222165-3363-1-git-send-email-yi.li@linaro.org>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add smbios/dmi support on arm64 system, it depends on EFI boot.

Since SMBIOS is very important specification for the hardware vendors
, it describes the hardware informations like BIOS version, 
serial number, physical layout of the ports and so on. All x86 and IA64
servers has supported this specfication. If ARM64 hopes to enter server
market, then SMBIOS needs to support on ARM64, and it has been included
as one important section in SBBR document from ARM.

This has been tested by dmidecode and lshw tools.

Signed-off-by: Yi Li <yi.li@linaro.org>
---

Changes since v1:
  -Followed Ard Biesheuvel's suggestion to rebase the patch on
   Matt Fleming's arm64-efi branch.

  -Followed Mark Rutland's suggesiton to change the include header.
  
  -Followed Grant likely's suggestion to enrich the SMBIOS background
   and the reason why we need to enable the SMBIOS on ARM64 platform.

 arch/arm64/Kconfig           |   10 ++++++++++
 arch/arm64/include/asm/dmi.h |   28 ++++++++++++++++++++++++++++
 arch/arm64/kernel/setup.c    |    2 ++
 3 files changed, 40 insertions(+)
 create mode 100644 arch/arm64/include/asm/dmi.h

diff --git a/arch/arm64/Kconfig b/arch/arm64/Kconfig
index 6c71f12..13ee261 100644
--- a/arch/arm64/Kconfig
+++ b/arch/arm64/Kconfig
@@ -294,6 +294,16 @@ config EFI
 	  allow the kernel to be booted as an EFI application. This
 	  is only useful on systems that have UEFI firmware.
 
+config DMI
+	bool "Enable support for SMBIOS (DMI) tables"
+	depends on EFI
+	default y
+	help
+	  This enables SMBIOS/DMI feature for systems.
+
+	  This option is only useful on systems that have UEFI firmware.
+	  However, even with this option, the resultant kernel should
+	  continue to boot on existing non-UEFI platforms.
 endmenu
 
 menu "Userspace binary formats"
diff --git a/arch/arm64/include/asm/dmi.h b/arch/arm64/include/asm/dmi.h
new file mode 100644
index 0000000..a0b3dac
--- /dev/null
+++ b/arch/arm64/include/asm/dmi.h
@@ -0,0 +1,28 @@
+/*
+ * arch/arm64/include/asm/dmi.h
+ *
+ * Copyright (C) 2013 Linaro Limited.
+ * Written by: Yi Li (yi.li@linaro.org)
+ *
+ * based on arch/ia64/include/asm/dmi.h
+ *
+ * This file is subject to the terms and conditions of the GNU General Public
+ * License.  See the file "COPYING" in the main directory of this archive
+ * for more details.
+ */
+
+
+#ifndef _ASM_DMI_H
+#define _ASM_DMI_H 1
+
+#include <linux/slab.h>
+#include <linux/efi.h>
+
+/* Use efi mappings for DMI */
+#define dmi_early_remap(x, l)	efi_lookup_mapped_addr(x)
+#define dmi_early_unmap(x, l)
+#define dmi_remap(x, l)			efi_lookup_mapped_addr(x)
+#define dmi_unmap(x)
+#define dmi_alloc(l)			kzalloc(l, GFP_ATOMIC)
+
+#endif
diff --git a/arch/arm64/kernel/setup.c b/arch/arm64/kernel/setup.c
index 0a14aaf..7622561 100644
--- a/arch/arm64/kernel/setup.c
+++ b/arch/arm64/kernel/setup.c
@@ -42,6 +42,7 @@
 #include <linux/of_fdt.h>
 #include <linux/of_platform.h>
 #include <linux/efi.h>
+#include <linux/dmi.h>
 
 #include <asm/fixmap.h>
 #include <asm/cputype.h>
@@ -400,6 +401,7 @@ static int __init arm64_device_init(void)
 {
 	of_clk_init(NULL);
 	of_platform_populate(NULL, of_default_bus_match_table, NULL, NULL);
+	dmi_scan_machine();
 	return 0;
 }
 arch_initcall(arm64_device_init);
-- 
1.7.9.5

