Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754233AbaAUXL2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Jan 2014 18:11:28 -0500
Received: from v094114.home.net.pl ([79.96.170.134]:63676 "HELO
	v094114.home.net.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752690AbaAUXLY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Jan 2014 18:11:24 -0500
From: "Rafael J. Wysocki" <rjw@rjwysocki.net>
To: Mika Westerberg <mika.westerberg@linux.intel.com>
Cc: Linux PM list <linux-pm@vger.kernel.org>,
        ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: [RFC/RFT][PATCH 4-2/5] ACPI / LPSS: Support for device latency tolerance PM QoS
Date: Wed, 22 Jan 2014 00:25:28 +0100
Message-ID: <6633189.Zcqs73QzT4@vostro.rjw.lan>
User-Agent: KMail/4.11.4 (Linux/3.13.0-rc8+; KDE/4.11.4; x86_64; ; )
In-Reply-To: <5380624.AVmYnxjkQF@vostro.rjw.lan>
References: <5434847.aCyiWHNRe7@vostro.rjw.lan> <1623216.7y3zYLQxqp@vostro.rjw.lan> <5380624.AVmYnxjkQF@vostro.rjw.lan>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rafael J. Wysocki <rafael.j.wysocki@intel.com>

Add a new routine, acpi_lpss_set_ltr(), for setting latency tolerance
values for LPSS devices having LTR (Latency Tolerance Reporting)
registers.  Add .bind()/.unbind() callbacks to lpss_handler to set
the LPSS devices' power.set_latency_tolerance callback pointers to
acpi_lpss_set_ltr() during device addition and to clear those pointers
on device removal, respectively.

That will cause the device latency tolerance PM QoS to work for
the devices in question as documented.

Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
---
 drivers/acpi/acpi_lpss.c |   71 ++++++++++++++++++++++++++++++++++++++++++++++-
 1 file changed, 70 insertions(+), 1 deletion(-)

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
@@ -390,6 +407,38 @@ static struct attribute_group lpss_attr_
 	.name = "lpss_ltr",
 };
 
+static void acpi_lpss_set_ltr(struct device *dev, s32 val)
+{
+	struct lpss_private_data *pdata = acpi_driver_data(ACPI_COMPANION(dev));
+	u32 ltr_mode, ltr_val;
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
@@ -427,9 +476,29 @@ static struct notifier_block acpi_lpss_n
 	.notifier_call = acpi_lpss_platform_notify,
 };
 
+static void acpi_lpss_bind(struct device *dev)
+{
+	struct lpss_private_data *pdata = acpi_driver_data(ACPI_COMPANION(dev));
+
+	if (WARN_ON(!pdata || !pdata->mmio_base))
+		return;
+
+	if (pdata->mmio_size >= pdata->dev_desc->prv_offset + LPSS_LTR_SIZE)
+		dev->power.set_latency_tolerance = acpi_lpss_set_ltr;
+	else
+		dev_err(dev, "MMIO size insufficient to access LTR\n");
+}
+
+static void acpi_lpss_unbind(struct device *dev)
+{
+	dev->power.set_latency_tolerance = NULL;
+}
+
 static struct acpi_scan_handler lpss_handler = {
 	.ids = acpi_lpss_device_ids,
 	.attach = acpi_lpss_create_device,
+	.bind = acpi_lpss_bind,
+	.unbind = acpi_lpss_unbind,
 };
 
 void __init acpi_lpss_init(void)

