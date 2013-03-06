Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757020Ab3CFWwN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Mar 2013 17:52:13 -0500
Received: from hydra.sisk.pl ([212.160.235.94]:60250 "EHLO hydra.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754581Ab3CFWwL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Mar 2013 17:52:11 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: LKML <linux-kernel@vger.kernel.org>
Cc: ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
        Mika Westerberg <mika.westerberg@linux.intel.com>,
        Mike Turquette <mturquette@linaro.org>,
        "Kristen C. Accardi" <kristen.c.accardi@intel.com>,
        Len Brown <lenb@kernel.org>
Subject: [Update][PATCH 2/2] ACPI / LPSS: Add support for exposing LTR registers to user space
Date: Wed, 06 Mar 2013 23:59:07 +0100
Message-ID: <1692006.SGTZ3bcltu@vostro.rjw.lan>
User-Agent: KMail/4.9.5 (Linux/3.9.0-rc1+; KDE/4.9.5; x86_64; ; )
In-Reply-To: <6910166.A6hvu2UJQ6@vostro.rjw.lan>
References: <1878438.IOSu0hheXQ@vostro.rjw.lan> <6910166.A6hvu2UJQ6@vostro.rjw.lan>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Subject: ACPI / LPSS: Add support for exposing LTR registers to user space

Devices on the Intel Lynxpoint Low Power Subsystem (LPSS) have
registers providing access to LTR (Latency Tolerance Reporting)
functionality that allows software to monitor and possibly influence
the aggressiveness of the platform's active-state power management.

For each LPSS device, there are two modes of operation related to LTR,
the auto mode and the software mode.  In the auto mode the LTR is
set up by the platform firmware and managed by hardware.  Software
can only read the LTR register values to monitor the platform's
behavior.  In the software mode it is possible to use LTR to control
the extent to which the platform will use its built-in power
management features.

This changeset adds support for reading the LPSS devices' LTR
registers and exposing their values to user space for monitoring and
diagnostics purposes.  It re-uses the MMIO mappings created to access
the LPSS devices' clock registers for reading the values of the LTR
registers and exposes them to user space through sysfs device
attributes.  Namely, a new atrribute group, lpss_ltr, is created for
each LPSS device.  It contains three new attributes: ltr_mode,
auto_ltr, sw_ltr.  The value of the ltr_mode attribute reflects the
LTR mode being used at the moment (software vs auto) and the other
two contain the actual register values (raw) whose meaning depends
on the LTR mode.  All of these attributes are read-only.

Signed-off-by: Mika Westerberg <mika.westerberg@linux.intel.com>
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
---

This update changes the ABI doc to follow the code more closely.

Thanks,
Rafael

---
 Documentation/ABI/testing/sysfs-devices-lpss_ltr |   44 +++++++
 drivers/acpi/acpi_lpss.c                         |  139 ++++++++++++++++++++++-
 2 files changed, 178 insertions(+), 5 deletions(-)

Index: linux-pm/Documentation/ABI/testing/sysfs-devices-lpss_ltr
===================================================================
--- /dev/null
+++ linux-pm/Documentation/ABI/testing/sysfs-devices-lpss_ltr
@@ -0,0 +1,44 @@
+What:		/sys/devices/.../lpss_ltr/
+Date:		March 2013
+Contact:	Rafael J. Wysocki <rafael.j.wysocki@intel.com>
+Description:
+		The /sys/devices/.../lpss_ltr/ directory is only present for
+		devices included into the Intel Lynxpoint Low Power Subsystem
+		(LPSS).  If present, it contains attributes containing the LTR
+		mode and the values of LTR registers of the device.
+
+What:		/sys/devices/.../lpss_ltr/ltr_mode
+Date:		March 2013
+Contact:	Rafael J. Wysocki <rafael.j.wysocki@intel.com>
+Description:
+		The /sys/devices/.../lpss_ltr/ltr_mode attribute contains an
+		integer number (0 or 1) indicating whether or not the devices'
+		LTR functionality is working in the software mode (1).
+
+		This attribute is read-only.  If the device's runtime PM status
+		is not "active", attempts to read from this attribute cause
+		-EAGAIN to be returned.
+
+What:		/sys/devices/.../lpss_ltr/auto_ltr
+Date:		March 2013
+Contact:	Rafael J. Wysocki <rafael.j.wysocki@intel.com>
+Description:
+		The /sys/devices/.../lpss_ltr/auto_ltr attribute contains the
+		current value of the device's AUTO_LTR register (raw)
+		represented as an 8-digit hexadecimal number.
+
+		This attribute is read-only.  If the device's runtime PM status
+		is not "active", attempts to read from this attribute cause
+		-EAGAIN to be returned.
+
+What:		/sys/devices/.../lpss_ltr/sw_ltr
+Date:		March 2013
+Contact:	Rafael J. Wysocki <rafael.j.wysocki@intel.com>
+Description:
+		The /sys/devices/.../lpss_ltr/auto_ltr attribute contains the
+		current value of the device's SW_LTR register (raw) represented
+		as an 8-digit hexadecimal number.
+
+		This attribute is read-only.  If the device's runtime PM status
+		is not "active", attempts to read from this attribute cause
+		-EAGAIN to be returned.
Index: linux-pm/drivers/acpi/acpi_lpss.c
===================================================================
--- linux-pm.orig/drivers/acpi/acpi_lpss.c
+++ linux-pm/drivers/acpi/acpi_lpss.c
@@ -18,17 +18,26 @@
 #include <linux/io.h>
 #include <linux/platform_device.h>
 #include <linux/platform_data/clk-lpss.h>
+#include <linux/pm_runtime.h>
 
 #include "internal.h"
 
 ACPI_MODULE_NAME("acpi_lpss");
 
-#define LPSS_CLK_OFFSET 0x800
 #define LPSS_CLK_SIZE	0x04
+#define LPSS_LTR_SIZE	0x18
+
+/* Offsets relative to LPSS_PRIVATE_OFFSET */
+#define LPSS_GENERAL			0x08
+#define LPSS_GENERAL_LTR_MODE_SW	BIT(2)
+#define LPSS_SW_LTR			0x10
+#define LPSS_AUTO_LTR			0x14
 
 struct lpss_device_desc {
 	bool clk_required;
 	const char *clk_parent;
+	bool ltr_required;
+	unsigned int prv_offset;
 };
 
 struct lpss_private_data {
@@ -41,6 +50,13 @@ struct lpss_private_data {
 static struct lpss_device_desc lpt_dev_desc = {
 	.clk_required = true,
 	.clk_parent = "lpss_clk",
+	.prv_offset = 0x800,
+	.ltr_required = true,
+};
+
+static struct lpss_device_desc lpt_sdio_dev_desc = {
+	.prv_offset = 0x1000,
+	.ltr_required = true,
 };
 
 static const struct acpi_device_id acpi_lpss_device_ids[] = {
@@ -51,7 +67,7 @@ static const struct acpi_device_id acpi_
 	{ "INT33C3", (unsigned long)&lpt_dev_desc },
 	{ "INT33C4", (unsigned long)&lpt_dev_desc },
 	{ "INT33C5", (unsigned long)&lpt_dev_desc },
-	{ "INT33C6", },
+	{ "INT33C6", (unsigned long)&lpt_sdio_dev_desc },
 	{ "INT33C7", },
 
 	{ }
@@ -80,12 +96,12 @@ static int register_device_clock(struct
 		lpt_register_clock_device();
 
 	if (!dev_desc->clk_parent || !pdata->mmio_base
-	    || pdata->mmio_size < LPSS_CLK_OFFSET + LPSS_CLK_SIZE)
+	    || pdata->mmio_size < dev_desc->prv_offset + LPSS_CLK_SIZE)
 		return -ENODATA;
 
 	pdata->clk = clk_register_gate(NULL, dev_name(&adev->dev),
 				       dev_desc->clk_parent, 0,
-				       pdata->mmio_base + LPSS_CLK_OFFSET,
+				       pdata->mmio_base + dev_desc->prv_offset,
 				       0, 0, NULL);
 	if (IS_ERR(pdata->clk))
 		return PTR_ERR(pdata->clk);
@@ -151,6 +167,117 @@ static int acpi_lpss_create_device(struc
 	return ret;
 }
 
+static int lpss_reg_read(struct device *dev, unsigned int reg, u32 *val)
+{
+	struct acpi_device *adev;
+	struct lpss_private_data *pdata;
+	unsigned long flags;
+	int ret;
+
+	ret = acpi_bus_get_device(ACPI_HANDLE(dev), &adev);
+	if (WARN_ON(ret))
+		return ret;
+
+	spin_lock_irqsave(&dev->power.lock, flags);
+	if (pm_runtime_suspended(dev)) {
+		ret = -EAGAIN;
+		goto out;
+	}
+	pdata = acpi_driver_data(adev);
+	if (WARN_ON(!pdata || !pdata->mmio_base)) {
+		ret = -ENODEV;
+		goto out;
+	}
+	*val = readl(pdata->mmio_base + pdata->dev_desc->prv_offset + reg);
+
+ out:
+	spin_unlock_irqrestore(&dev->power.lock, flags);
+	return ret;
+}
+
+static ssize_t lpss_ltr_show(struct device *dev, struct device_attribute *attr,
+			     char *buf)
+{
+	u32 ltr_value = 0;
+	unsigned int reg;
+	int ret;
+
+	reg = strcmp(attr->attr.name, "auto_ltr") ? LPSS_SW_LTR : LPSS_AUTO_LTR;
+	ret = lpss_reg_read(dev, reg, &ltr_value);
+	if (ret)
+		return ret;
+
+	return snprintf(buf, PAGE_SIZE, "%08x\n", ltr_value);
+}
+
+static ssize_t lpss_ltr_mode_show(struct device *dev,
+				  struct device_attribute *attr, char *buf)
+{
+	u32 ltr_mode = 0;
+	char *outstr;
+	int ret;
+
+	ret = lpss_reg_read(dev, LPSS_GENERAL, &ltr_mode);
+	if (ret)
+		return ret;
+
+	outstr = (ltr_mode & LPSS_GENERAL_LTR_MODE_SW) ? "sw" : "auto";
+	return sprintf(buf, "%s\n", outstr);
+}
+
+static DEVICE_ATTR(auto_ltr, S_IRUSR, lpss_ltr_show, NULL);
+static DEVICE_ATTR(sw_ltr, S_IRUSR, lpss_ltr_show, NULL);
+static DEVICE_ATTR(ltr_mode, S_IRUSR, lpss_ltr_mode_show, NULL);
+
+static struct attribute *lpss_attrs[] = {
+	&dev_attr_auto_ltr.attr,
+	&dev_attr_sw_ltr.attr,
+	&dev_attr_ltr_mode.attr,
+	NULL,
+};
+
+static struct attribute_group lpss_attr_group = {
+	.attrs = lpss_attrs,
+	.name = "lpss_ltr",
+};
+
+static int acpi_lpss_platform_notify(struct notifier_block *nb,
+				     unsigned long action, void *data)
+{
+	struct platform_device *pdev = to_platform_device(data);
+	struct lpss_private_data *pdata;
+	struct acpi_device *adev;
+	const struct acpi_device_id *id;
+	int ret = 0;
+
+	id = acpi_match_device(acpi_lpss_device_ids, &pdev->dev);
+	if (!id || !id->driver_data)
+		return 0;
+
+	if (acpi_bus_get_device(ACPI_HANDLE(&pdev->dev), &adev))
+		return 0;
+
+	pdata = acpi_driver_data(adev);
+	if (!pdata || !pdata->mmio_base || !pdata->dev_desc->ltr_required)
+		return 0;
+
+	if (pdata->mmio_size < pdata->dev_desc->prv_offset + LPSS_LTR_SIZE) {
+		dev_err(&pdev->dev, "MMIO size insufficient to access LTR\n");
+		return 0;
+	}
+
+	if (action == BUS_NOTIFY_ADD_DEVICE)
+		ret = sysfs_create_group(&pdev->dev.kobj, &lpss_attr_group);
+	else if (action == BUS_NOTIFY_DEL_DEVICE)
+		sysfs_remove_group(&pdev->dev.kobj, &lpss_attr_group);
+
+	return ret;
+}
+
+static struct notifier_block acpi_lpss_nb = {
+	.notifier_call = acpi_lpss_platform_notify,
+};
+
 static struct acpi_scan_handler lpss_handler = {
 	.ids = acpi_lpss_device_ids,
 	.attach = acpi_lpss_create_device,
@@ -158,6 +285,8 @@ static struct acpi_scan_handler lpss_han
 
 void __init acpi_lpss_init(void)
 {
-	if (!lpt_clk_init())
+	if (!lpt_clk_init()) {
+		bus_register_notifier(&platform_bus_type, &acpi_lpss_nb);
 		acpi_scan_add_handler(&lpss_handler);
+	}
 }

