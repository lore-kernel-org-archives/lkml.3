Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752560AbaAQOiF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Jan 2014 09:38:05 -0500
Received: from v094114.home.net.pl ([79.96.170.134]:59159 "HELO
	v094114.home.net.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751980AbaAQOh7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Jan 2014 09:37:59 -0500
From: "Rafael J. Wysocki" <rjw@rjwysocki.net>
To: Linux PM list <linux-pm@vger.kernel.org>
Cc: ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Mika Westerberg <mika.westerberg@linux.intel.com>
Subject: [RFC/RFT][PATCH 4/5] ACPI / LPSS: Support for device latency tolerance PM QoS
Date: Fri, 17 Jan 2014 15:46:40 +0100
Message-ID: <12327024.lrSi2qfq01@vostro.rjw.lan>
User-Agent: KMail/4.11.3 (Linux/3.13.0-rc8+; KDE/4.11.3; x86_64; ; )
In-Reply-To: <5434847.aCyiWHNRe7@vostro.rjw.lan>
References: <5434847.aCyiWHNRe7@vostro.rjw.lan>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rafael J. Wysocki <rafael.j.wysocki@intel.com>

Add a new routine, acpi_lpss_set_ltr(), for setting latency tolerance
values for LPSS devices having LTR (Latency Tolerance Reporting)
registers.  Modify acpi_lpss_platform_notify() to set the LPSS
devices' power.set_latency_tolerance callback pointers to
acpi_lpss_set_ltr() during device addition.

That will cause the device latency tolerance PM QoS to work for
the devices in question as documented.

Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
---
 drivers/acpi/acpi_lpss.c |   66 ++++++++++++++++++++++++++++++++++++++++++++---
 1 file changed, 62 insertions(+), 4 deletions(-)

Index: linux-pm/drivers/acpi/acpi_lpss.c
===================================================================
--- linux-pm.orig/drivers/acpi/acpi_lpss.c
+++ linux-pm/drivers/acpi/acpi_lpss.c
@@ -33,6 +33,12 @@ ACPI_MODULE_NAME("acpi_lpss");
 #define LPSS_GENERAL_UART_RTS_OVRD	BIT(3)
 #define LPSS_SW_LTR			0x10
 #define LPSS_AUTO_LTR			0x14
+#define LPSS_LTR_SNOOP_REQ		BIT(15)
+#define LPSS_LTR_SNOOP_MASK		0x0000FFFF
+#define LPSS_LTR_SNOOP_LAT_1US		0x800
+#define LPSS_LTR_SNOOP_LAT_32US		0xC00
+#define LPSS_LTR_SNOOP_LAT_SHIFT	5
+#define LPSS_LTR_MAX_VAL		0x3FF
 #define LPSS_TX_INT			0x20
 #define LPSS_TX_INT_MASK		BIT(1)
 
@@ -316,6 +322,17 @@ static int acpi_lpss_create_device(struc
 	return ret;
 }
 
+static u32 __lpss_reg_read(struct lpss_private_data *pdata, unsigned int reg)
+{
+	return readl(pdata->mmio_base + pdata->dev_desc->prv_offset + reg);
+}
+
+static void __lpss_reg_write(u32 val, struct lpss_private_data *pdata,
+			     unsigned int reg)
+{
+	writel(val, pdata->mmio_base + pdata->dev_desc->prv_offset + reg);
+}
+
 static int lpss_reg_read(struct device *dev, unsigned int reg, u32 *val)
 {
 	struct acpi_device *adev;
@@ -337,7 +354,7 @@ static int lpss_reg_read(struct device *
 		ret = -ENODEV;
 		goto out;
 	}
-	*val = readl(pdata->mmio_base + pdata->dev_desc->prv_offset + reg);
+	*val = __lpss_reg_read(pdata, reg);
 
  out:
 	spin_unlock_irqrestore(&dev->power.lock, flags);
@@ -390,6 +407,46 @@ static struct attribute_group lpss_attr_
 	.name = "lpss_ltr",
 };
 
+static void acpi_lpss_set_ltr(struct device *dev, s32 val)
+{
+	struct acpi_device *adev = ACPI_COMPANION(dev);
+	struct lpss_private_data *pdata;
+	u32 ltr_mode, ltr_val;
+
+	if (WARN_ON(!adev))
+		return;
+
+	pdata = acpi_driver_data(adev);
+	if (WARN_ON(!pdata || !pdata->mmio_base))
+		return;
+
+	ltr_mode = __lpss_reg_read(pdata, LPSS_GENERAL);
+	if (val < 0) {
+		if (ltr_mode & LPSS_GENERAL_LTR_MODE_SW) {
+			ltr_mode &= ~LPSS_GENERAL_LTR_MODE_SW;
+			__lpss_reg_write(ltr_mode, pdata, LPSS_GENERAL);
+		}
+		return;
+	}
+	ltr_val = __lpss_reg_read(pdata, LPSS_SW_LTR) & ~LPSS_LTR_SNOOP_MASK;
+	if (val > LPSS_LTR_MAX_VAL) {
+		ltr_val |= LPSS_LTR_SNOOP_LAT_32US | LPSS_LTR_SNOOP_REQ;
+		val >>= LPSS_LTR_SNOOP_LAT_SHIFT;
+		if (val > LPSS_LTR_MAX_VAL)
+			val = LPSS_LTR_MAX_VAL;
+	} else {
+		ltr_val |= LPSS_LTR_SNOOP_LAT_1US;
+		if (val > 0)
+			ltr_val |= LPSS_LTR_SNOOP_REQ;
+	}
+	ltr_val |= val;
+	__lpss_reg_write(ltr_val, pdata, LPSS_SW_LTR);
+	if (!(ltr_mode & LPSS_GENERAL_LTR_MODE_SW)) {
+		ltr_mode |= LPSS_GENERAL_LTR_MODE_SW;
+		__lpss_reg_write(ltr_mode, pdata, LPSS_GENERAL);
+	}
+}
+
 static int acpi_lpss_platform_notify(struct notifier_block *nb,
 				     unsigned long action, void *data)
 {
@@ -415,11 +472,12 @@ static int acpi_lpss_platform_notify(str
 		return 0;
 	}
 
-	if (action == BUS_NOTIFY_ADD_DEVICE)
+	if (action == BUS_NOTIFY_ADD_DEVICE) {
 		ret = sysfs_create_group(&pdev->dev.kobj, &lpss_attr_group);
-	else if (action == BUS_NOTIFY_DEL_DEVICE)
+		pdev->dev.power.set_latency_tolerance = acpi_lpss_set_ltr;
+	} else if (action == BUS_NOTIFY_DEL_DEVICE) {
 		sysfs_remove_group(&pdev->dev.kobj, &lpss_attr_group);
-
+	}
 	return ret;
 }
 

