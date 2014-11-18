Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752976AbaKRGmO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Nov 2014 01:42:14 -0500
Received: from mail-bn1on0119.outbound.protection.outlook.com ([157.56.110.119]:56775
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751038AbaKRGmL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Nov 2014 01:42:11 -0500
X-Greylist: delayed 1028 seconds by postgrey-1.27 at vger.kernel.org; Tue, 18 Nov 2014 01:42:11 EST
X-WSS-ID: 0NF812Y-07-ALW-02
X-M-MSG: 
From: Ken Xue <Ken.Xue@amd.com>
To: <rjw@rjwysocki.net>, <lenb@kernel.org>
CC: <linux-acpi@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        Ken Xue <Ken.Xue@amd.com>, Jeff Wu <Jeff.Wu@amd.com>
Subject: [PATCH] acpi:apd:add AMD ACPI2Platform device support for x86 system.
Date: Tue, 18 Nov 2014 13:58:11 +0800
Message-ID: <1416290291-5802-1-git-send-email-Ken.Xue@amd.com>
X-Mailer: git-send-email 1.9.1
MIME-Version: 1.0
Content-Type: text/plain
X-EOPAttributedMessage: 0
Authentication-Results: spf=none (sender IP is 165.204.84.221)
 smtp.mailfrom=Ken.Xue@amd.com; 
X-Forefront-Antispam-Report: CIP:165.204.84.221;CTRY:US;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(10019020)(6009001)(428002)(199003)(189002)(97736003)(87936001)(106466001)(19580395003)(44976005)(19580405001)(50986999)(68736004)(229853001)(77096003)(62966003)(77156002)(92566001)(93916002)(50466002)(92726001)(575784001)(36756003)(86362001)(95666004)(107046002)(48376002)(88136002)(105586002)(89996001)(101416001)(104166001)(21056001)(102836001)(4396001)(120916001)(84676001)(99396003)(46102003)(50226001)(64706001)(87286001)(31966008)(20776003)(47776003)(53416004);DIR:OUT;SFP:1102;SCL:1;SRVR:BY2PR02MB204;H:atltwp01.amd.com;FPR:;MLV:sfv;PTR:InfoDomainNonexistent;A:1;MX:1;LANG:en;
X-Microsoft-Antispam: UriScan:;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:;SRVR:BY2PR02MB204;
X-Exchange-Antispam-Report-Test: UriScan:;
X-Exchange-Antispam-Report-CFA-Test: BCL:0;PCL:0;RULEID:;SRVR:BY2PR02MB204;
X-Forefront-PRVS: 039975700A
X-Exchange-Antispam-Report-CFA-Test: BCL:0;PCL:0;RULEID:;SRVR:BY2PR02MB204;
X-OriginatorOrg: amd4.onmicrosoft.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This new feature is to interpret AMD specific ACPI device to platform device
such as I2C, UART found on AMD CZ and later chipsets. It is based on example
INTEL LPSS. Now, it can support AMD I2C & UART.

Signed-off-by: Ken Xue <Ken.Xue@amd.com>
Signed-off-by: Jeff Wu <Jeff.Wu@amd.com>
---
 arch/x86/Kconfig        |  11 +++
 drivers/acpi/Makefile   |   1 +
 drivers/acpi/acpi_apd.c | 245 ++++++++++++++++++++++++++++++++++++++++++++++++
 drivers/acpi/internal.h |   6 ++
 drivers/acpi/scan.c     |   1 +
 5 files changed, 264 insertions(+)
 create mode 100644 drivers/acpi/acpi_apd.c

diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
index ded8a67..6402c79f 100644
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
+	  such as I2C, UART found on AMD CARRIZO and later chipset. Selecting
+	  this option enables things like clock tree (common clock framework)
+	  and pinctrl.
+
 config IOSF_MBI
 	tristate "Intel SoC IOSF Sideband support for SoC platforms"
 	depends on PCI
diff --git a/drivers/acpi/Makefile b/drivers/acpi/Makefile
index c3b2fcb..91fc1c2 100644
--- a/drivers/acpi/Makefile
+++ b/drivers/acpi/Makefile
@@ -41,6 +41,7 @@ acpi-y				+= ec.o
 acpi-$(CONFIG_ACPI_DOCK)	+= dock.o
 acpi-y				+= pci_root.o pci_link.o pci_irq.o
 acpi-y				+= acpi_lpss.o
+acpi-$(CONFIG_X86_AMD_PLATFORM_DEVICE)	+= acpi_apd.o
 acpi-y				+= acpi_platform.o
 acpi-y				+= acpi_pnp.o
 acpi-y				+= int340x_thermal.o
diff --git a/drivers/acpi/acpi_apd.c b/drivers/acpi/acpi_apd.c
new file mode 100644
index 0000000..994b7db
--- /dev/null
+++ b/drivers/acpi/acpi_apd.c
@@ -0,0 +1,245 @@
+/*
+ * AMD ACPI support for ACPI2platform device.
+ *
+ * Copyright (c) 2014, AMD Corporation.
+ * Authors: Ken Xue <Ken.Xue@amd.com>
+ *	Jeff Wu <Jeff.Wu@amd.com>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ */
+
+#include <linux/acpi.h>
+#include <linux/clk.h>
+#include <linux/clkdev.h>
+#include <linux/clk-provider.h>
+#include <linux/err.h>
+#include <linux/io.h>
+#include <linux/platform_device.h>
+#include <linux/pm_runtime.h>
+
+#include "internal.h"
+
+ACPI_MODULE_NAME("acpi_apd");
+struct apd_private_data;
+
+struct apd_device_desc {
+	bool clk_required;
+	bool fixed_root_clock;
+	const char *clk_name;
+	unsigned long	rate;
+	size_t prv_size_override;
+	void (*setup)(struct apd_private_data *pdata);
+};
+
+struct apd_private_data {
+	void __iomem *mmio_base;
+	resource_size_t mmio_size;
+	struct clk *clk;
+	const struct apd_device_desc *dev_desc;
+};
+
+static struct apd_device_desc amd_i2c_desc = {
+	.clk_required = true,
+	.fixed_root_clock = true,
+	.clk_name = "i2c_clk",
+	.rate = 133000000, /*(133 * 1000 * 1000)*/
+};
+
+static struct apd_device_desc amd_uart_desc = {
+	.clk_required = true,
+	.fixed_root_clock = true,
+	.clk_name = "uart_clk",
+	.rate = 48000000,
+};
+
+static const struct acpi_device_id acpi_apd_device_ids[] = {
+	/* Generic apd devices */
+	{ "AMD0010", (unsigned long)&amd_i2c_desc },
+	{ "AMD0020", (unsigned long)&amd_uart_desc },
+	{ }
+};
+
+static int is_memory(struct acpi_resource *res, void *not_used)
+{
+	struct resource r;
+
+	return !acpi_dev_resource_memory(res, &r);
+}
+
+static int register_device_clock(struct acpi_device *adev,
+				 struct apd_private_data *pdata)
+{
+	const struct apd_device_desc *dev_desc = pdata->dev_desc;
+	struct clk *clk = ERR_PTR(-ENODEV);
+
+	clk = pdata->clk;
+	if (!clk && dev_desc->fixed_root_clock) {
+		clk = clk_register_fixed_rate(&adev->dev, dev_name(&adev->dev),
+				      NULL, CLK_IS_ROOT, dev_desc->rate);
+		pdata->clk = clk;
+		clk_register_clkdev(clk, NULL, dev_name(&adev->dev));
+	}
+
+	return 0;
+}
+
+static int acpi_apd_create_device(struct acpi_device *adev,
+				   const struct acpi_device_id *id)
+{
+	struct apd_device_desc *dev_desc;
+	struct apd_private_data *pdata;
+	struct resource_list_entry *rentry;
+	struct list_head resource_list;
+	struct platform_device *pdev;
+	int ret;
+
+	dev_desc = (struct apd_device_desc *)id->driver_data;
+	if (!dev_desc) {
+		pdev = acpi_create_platform_device(adev);
+		return IS_ERR_OR_NULL(pdev) ? PTR_ERR(pdev) : 1;
+	}
+
+	pdata = kzalloc(sizeof(*pdata), GFP_KERNEL);
+	if (!pdata)
+		return -ENOMEM;
+
+	INIT_LIST_HEAD(&resource_list);
+	ret = acpi_dev_get_resources(adev, &resource_list, is_memory, NULL);
+	if (ret < 0)
+		goto err_out;
+
+	list_for_each_entry(rentry, &resource_list, node)
+		if (resource_type(&rentry->res) == IORESOURCE_MEM) {
+			if (dev_desc->prv_size_override)
+				pdata->mmio_size = dev_desc->prv_size_override;
+			else
+				pdata->mmio_size = resource_size(&rentry->res);
+			pdata->mmio_base = ioremap(rentry->res.start,
+						   pdata->mmio_size);
+			break;
+		}
+
+	acpi_dev_free_resource_list(&resource_list);
+
+	pdata->dev_desc = dev_desc;
+
+	if (dev_desc->clk_required) {
+		ret = register_device_clock(adev, pdata);
+		if (ret) {
+			/* Skip the device, but continue the namespace scan. */
+			ret = 0;
+			goto err_out;
+		}
+	}
+
+	/*
+	 * This works around a known issue in ACPI tables where apd devices
+	 * have _PS0 and _PS3 without _PSC (and no power resources), so
+	 * acpi_bus_init_power() will assume that the BIOS has put them into D0.
+	 */
+	ret = acpi_device_fix_up_power(adev);
+	if (ret) {
+		/* Skip the device, but continue the namespace scan. */
+		ret = 0;
+		goto err_out;
+	}
+
+	if (dev_desc->setup)
+		dev_desc->setup(pdata);
+
+	adev->driver_data = pdata;
+	pdev = acpi_create_platform_device(adev);
+	if (!IS_ERR_OR_NULL(pdev)) {
+		device_enable_async_suspend(&pdev->dev);
+		return ret;
+	}
+
+	ret = PTR_ERR(pdev);
+	adev->driver_data = NULL;
+
+ err_out:
+	kfree(pdata);
+	return ret;
+}
+
+static ssize_t apd_device_desc_show(struct device *dev,
+				struct device_attribute *attr, char *buf)
+{
+	int ret;
+	struct acpi_device *adev;
+	struct apd_private_data *pdata;
+
+	ret = acpi_bus_get_device(ACPI_HANDLE(dev), &adev);
+	if (WARN_ON(ret))
+		return ret;
+
+	pdata = acpi_driver_data(adev);
+	if (WARN_ON(!pdata || !pdata->dev_desc))
+		return -ENODEV;
+
+	if (pdata->dev_desc->clk_required)
+		return sprintf(buf, "Required clk: %s %s %ld\n",
+			pdata->dev_desc->clk_name,
+			pdata->dev_desc->fixed_root_clock ?
+			"fix rate" : "no fix rate",
+			pdata->dev_desc->rate);
+	else
+		return sprintf(buf, "No need clk\n");
+}
+
+static DEVICE_ATTR(device_desc, S_IRUSR, apd_device_desc_show, NULL);
+
+static struct attribute *apd_attrs[] = {
+	&dev_attr_device_desc.attr,
+	NULL,
+};
+
+static struct attribute_group apd_attr_group = {
+	.attrs = apd_attrs,
+	.name = "apd_ltr",
+};
+
+static int acpi_apd_platform_notify(struct notifier_block *nb,
+				     unsigned long action, void *data)
+{
+	struct platform_device *pdev = to_platform_device(data);
+	struct apd_private_data *pdata;
+	struct acpi_device *adev;
+	const struct acpi_device_id *id;
+	int ret = 0;
+
+	id = acpi_match_device(acpi_apd_device_ids, &pdev->dev);
+	if (!id || !id->driver_data)
+		return 0;
+
+	if (acpi_bus_get_device(ACPI_HANDLE(&pdev->dev), &adev))
+		return 0;
+
+	pdata = acpi_driver_data(adev);
+	if (!pdata || !pdata->mmio_base)
+		return 0;
+
+	if (action == BUS_NOTIFY_ADD_DEVICE)
+		ret = sysfs_create_group(&pdev->dev.kobj, &apd_attr_group);
+	else if (action == BUS_NOTIFY_DEL_DEVICE)
+		sysfs_remove_group(&pdev->dev.kobj, &apd_attr_group);
+
+	return ret;
+}
+
+static struct notifier_block acpi_apd_nb = {
+	.notifier_call = acpi_apd_platform_notify,
+};
+
+static struct acpi_scan_handler apd_handler = {
+	.ids = acpi_apd_device_ids,
+	.attach = acpi_apd_create_device,
+};
+
+void __init acpi_apd_init(void)
+{
+	bus_register_notifier(&platform_bus_type, &acpi_apd_nb);
+	acpi_scan_add_handler(&apd_handler);
+}
diff --git a/drivers/acpi/internal.h b/drivers/acpi/internal.h
index 447f6d6..c8a0e8e 100644
--- a/drivers/acpi/internal.h
+++ b/drivers/acpi/internal.h
@@ -68,6 +68,12 @@ static inline void acpi_debugfs_init(void) { return; }
 #endif
 void acpi_lpss_init(void);
 
+#ifdef CONFIG_X86_AMD_PLATFORM_DEVICE
+void acpi_apd_init(void);
+#else
+static inline void acpi_apd_init(void) {}
+#endif
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

