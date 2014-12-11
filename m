Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933688AbaLKDbn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Dec 2014 22:31:43 -0500
Received: from mail-bl2on0146.outbound.protection.outlook.com ([65.55.169.146]:35058
	"EHLO na01-bl2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S933460AbaLKDbl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Dec 2014 22:31:41 -0500
X-Greylist: delayed 926 seconds by postgrey-1.27 at vger.kernel.org; Wed, 10 Dec 2014 22:31:40 EST
X-WSS-ID: 0NGEEEU-08-1TE-02
X-M-MSG: 
From: Ken Xue <Ken.Xue@amd.com>
To: <mika.westerberg@linux.intel.com>, <rjw@rjwysocki.net>
CC: <linux-acpi@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        Ken Xue <Ken.Xue@amd.com>
Subject: [PATCH 2/3 V2] acpi:apd:add AMD ACPI2Platform device support
Date: Thu, 11 Dec 2014 11:05:33 +0800
Message-ID: <1418267133-5609-1-git-send-email-Ken.Xue@amd.com>
X-Mailer: git-send-email 1.9.1
MIME-Version: 1.0
Content-Type: text/plain
X-EOPAttributedMessage: 0
Authentication-Results: spf=none (sender IP is 165.204.84.222)
 smtp.mailfrom=Ken.Xue@amd.com; 
X-Forefront-Antispam-Report: CIP:165.204.84.222;CTRY:US;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(10019020)(6009001)(428002)(199003)(189002)(97736003)(19580405001)(19580395003)(229853001)(46102003)(107046002)(86362001)(36756003)(101416001)(92566001)(31966008)(47776003)(20776003)(84676001)(64706001)(106466001)(4396001)(50226001)(62966003)(77156002)(105586002)(50986999)(48376002)(68736005)(87936001)(89996001)(77096005)(21056001)(99396003)(53416004)(50466002)(120916001)(2004002);DIR:OUT;SFP:1102;SCL:1;SRVR:BY2PR02MB204;H:atltwp02.amd.com;FPR:;SPF:None;MLV:sfv;PTR:InfoDomainNonexistent;A:1;MX:1;LANG:en;
X-Microsoft-Antispam: UriScan:;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:;SRVR:BY2PR02MB204;
X-Exchange-Antispam-Report-Test: UriScan:;
X-Exchange-Antispam-Report-CFA-Test: BCL:0;PCL:0;RULEID:(601003);SRVR:BY2PR02MB204;
X-Forefront-PRVS: 0422860ED4
X-Exchange-Antispam-Report-CFA-Test: BCL:0;PCL:0;RULEID:;SRVR:BY2PR02MB204;
X-OriginatorOrg: amd4.onmicrosoft.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a new feature to interpret AMD specific ACPI device to
platform device such as I2C, UART found on AMD CZ and later
chipsets. It based on acpi soc.

Signed-off-by: Ken Xue <Ken.Xue@amd.com>
---
 arch/x86/Kconfig        | 11 ++++++++
 drivers/acpi/Makefile   |  2 +-
 drivers/acpi/acpi_apd.c | 71 +++++++++++++++++++++++++++++++++++++++++++++++++
 drivers/acpi/internal.h |  2 ++
 drivers/acpi/scan.c     |  1 +
 5 files changed, 86 insertions(+), 1 deletion(-)
 create mode 100644 drivers/acpi/acpi_apd.c

diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
index ded8a67..030f508 100644
--- a/arch/x86/Kconfig
+++ b/arch/x86/Kconfig
@@ -495,6 +495,17 @@ config X86_INTEL_LPSS
 	  things like clock tree (common clock framework) and pincontrol
 	  which are needed by the LPSS peripheral drivers.
 
+config X86_AMD_PLATFORM_DEVICE
+	bool "AMD ACPI2Platform devices support"
+	depends on ACPI
+	select COMMON_CLK
+	select PINCTRL
+	---help---
+	  Select to interpret AMD specific ACPI device to platform device
+	  such as I2C, UART found on AMD Carrizo and later chipsets. Selecting
+	  this option enables things like clock tree (common clock framework)
+	  and pinctrl.
+
 config IOSF_MBI
 	tristate "Intel SoC IOSF Sideband support for SoC platforms"
 	depends on PCI
diff --git a/drivers/acpi/Makefile b/drivers/acpi/Makefile
index ae3397d..b07003a 100644
--- a/drivers/acpi/Makefile
+++ b/drivers/acpi/Makefile
@@ -40,7 +40,7 @@ acpi-$(CONFIG_ARCH_MIGHT_HAVE_ACPI_PDC) += processor_pdc.o
 acpi-y				+= ec.o
 acpi-$(CONFIG_ACPI_DOCK)	+= dock.o
 acpi-y				+= pci_root.o pci_link.o pci_irq.o
-acpi-y				+= acpi_soc.o acpi_lpss.o
+acpi-y				+= acpi_soc.o acpi_lpss.o acpi_apd.o
 acpi-y				+= acpi_platform.o
 acpi-y				+= acpi_pnp.o
 acpi-y				+= int340x_thermal.o
diff --git a/drivers/acpi/acpi_apd.c b/drivers/acpi/acpi_apd.c
new file mode 100644
index 0000000..b46e2af
--- /dev/null
+++ b/drivers/acpi/acpi_apd.c
@@ -0,0 +1,71 @@
+/*
+ * AMD ACPI support for  ACPI2platform device.
+ *
+ * Copyright (c) 2014, AMD Corporation.
+ * Authors: Ken Xue <Ken.Xue@amd.com>
+ *	Wu, Jeff <Jeff.Wu@amd.com>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ */
+#include <linux/clkdev.h>
+#include <linux/clk-provider.h>
+#include <linux/err.h>
+
+#include "acpi_soc.h"
+#include "internal.h"
+
+static struct acpi_soc a_soc;
+
+#ifdef CONFIG_X86_AMD_PLATFORM_DEVICE
+#define APD_ADDR(desc)	((unsigned long)&desc)
+
+static int acpi_apd_setup(struct acpi_soc_dev_private_data *pdata)
+{
+	struct acpi_soc_dev_desc *dev_desc = pdata->dev_desc;
+	struct clk *clk = ERR_PTR(-ENODEV);
+
+	if (dev_desc->fixed_clk_rate) {
+		clk = clk_register_fixed_rate(&pdata->adev->dev,
+					dev_name(&pdata->adev->dev),
+					NULL, CLK_IS_ROOT,
+					dev_desc->fixed_clk_rate);
+		clk_register_clkdev(clk, NULL, dev_name(&pdata->adev->dev));
+	}
+
+	return 0;
+}
+
+static struct acpi_soc_dev_desc cz_i2c_desc = {
+	.setup = acpi_apd_setup,
+	.fixed_clk_rate = 133000000,
+};
+
+static struct acpi_soc_dev_desc cz_uart_desc = {
+	.setup = acpi_apd_setup,
+	.fixed_clk_rate = 48000000,
+};
+
+#else
+
+#define APD_ADDR(desc) (0UL)
+
+#endif /* CONFIG_X86_AMD_PLATFORM_DEVICE */
+
+static struct acpi_device_id acpi_apd_device_ids[] = {
+	/* Generic apd devices */
+	{ "AMD0010", APD_ADDR(cz_i2c_desc) },
+	{ "AMD0020", APD_ADDR(cz_uart_desc) },
+	{ }
+};
+
+void __init acpi_apd_init(void)
+{
+	a_soc.ids = acpi_apd_device_ids;
+#ifdef CONFIG_X86_AMD_PLATFORM_DEVICE
+	register_acpi_soc(&a_soc, false);
+#else
+	register_acpi_soc(&a_soc, true);
+#endif /* CONFIG_X86_AMD_PLATFORM_DEVICE */
+}
diff --git a/drivers/acpi/internal.h b/drivers/acpi/internal.h
index 447f6d6..bade825 100644
--- a/drivers/acpi/internal.h
+++ b/drivers/acpi/internal.h
@@ -68,6 +68,8 @@ static inline void acpi_debugfs_init(void) { return; }
 #endif
 void acpi_lpss_init(void);
 
+void acpi_apd_init(void);
+
 acpi_status acpi_hotplug_schedule(struct acpi_device *adev, u32 src);
 bool acpi_queue_hotplug_work(struct work_struct *work);
 void acpi_device_hotplug(struct acpi_device *adev, u32 src);
diff --git a/drivers/acpi/scan.c b/drivers/acpi/scan.c
index 0476e90..24fef2b 100644
--- a/drivers/acpi/scan.c
+++ b/drivers/acpi/scan.c
@@ -2349,6 +2349,7 @@ int __init acpi_scan_init(void)
 	acpi_pci_link_init();
 	acpi_processor_init();
 	acpi_lpss_init();
+	acpi_apd_init();
 	acpi_cmos_rtc_init();
 	acpi_container_init();
 	acpi_memory_hotplug_init();
-- 
1.9.1

