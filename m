Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753201Ab3LQTlx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Dec 2013 14:41:53 -0500
Received: from mail-lb0-f172.google.com ([209.85.217.172]:37649 "EHLO
	mail-lb0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752843Ab3LQTkU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Dec 2013 14:40:20 -0500
From: Sergei Ianovich <ynvich@gmail.com>
To: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Cc: Sergei Ianovich <ynvich@gmail.com>, Rob Herring <rob.herring@calxeda.com>,
        Pawel Moll <pawel.moll@arm.com>, Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>, Rob Landley <rob@landley.net>,
        Russell King <linux@arm.linux.org.uk>, Arnd Bergmann <arnd@arndb.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        devicetree@vger.kernel.org (open list:OPEN FIRMWARE AND...),
        linux-doc@vger.kernel.org (open list:DOCUMENTATION)
Subject: [PATCH v3 17/21] misc: support for serial slots in LP-8x4x
Date: Tue, 17 Dec 2013 23:37:47 +0400
Message-Id: <1387309071-22382-18-git-send-email-ynvich@gmail.com>
X-Mailer: git-send-email 1.8.5.1
In-Reply-To: <1387309071-22382-1-git-send-email-ynvich@gmail.com>
References: <1386901645-28895-1-git-send-email-ynvich@gmail.com>
 <1387309071-22382-1-git-send-email-ynvich@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Serial modules (I-870xxW series) implement DCON protocol which
allows one-master-many-slaves configuration over RS-485. When
these modules are installed into the device, they could be
accessed using the 2nd PXA built-in UART port (/dev/ttyS1).
However, it seems that addresses are not processed by the modules.
So the parallel bus needs to select which slot is connected.

Signed-off-by: Sergei Ianovich <ynvich@gmail.com>
---
   v2..v3
   * no changes (except number 12/16 -> 17/21)

   v0..v2
   * use device tree
   * use devm helpers where possible

 .../devicetree/bindings/misc/lp8x4x-bus.txt        |  2 +
 Documentation/misc-devices/lp8x4x_bus.txt          | 15 +++++-
 arch/arm/boot/dts/pxa27x-lp8x4x.dts                |  1 +
 drivers/misc/lp8x4x_bus.c                          | 63 ++++++++++++++++++++++
 4 files changed, 80 insertions(+), 1 deletion(-)

diff --git a/Documentation/devicetree/bindings/misc/lp8x4x-bus.txt b/Documentation/devicetree/bindings/misc/lp8x4x-bus.txt
index b0fb145..24a8c62 100644
--- a/Documentation/devicetree/bindings/misc/lp8x4x-bus.txt
+++ b/Documentation/devicetree/bindings/misc/lp8x4x-bus.txt
@@ -8,6 +8,7 @@ Required properties:
 - reg: physical base addresses and region lengths of
        * the rotary switch
        * the 8bit DIP switch
+       * the serial slot select register
        * the slot count register
 
 - eeprom-gpios : should point to active-low write enable GPIO
@@ -18,6 +19,7 @@ Example:
 		compatible = "icpdas,backplane-lp8x4x";
 		reg = <0x0 0x2
 		       0x9002 0x2
+		       0x9004 0x2
 		       0x9046 0x2>;
 		eeprom-gpios = <&gpio 4 0>;
 	};
diff --git a/Documentation/misc-devices/lp8x4x_bus.txt b/Documentation/misc-devices/lp8x4x_bus.txt
index 78ea0a89..7b86797 100644
--- a/Documentation/misc-devices/lp8x4x_bus.txt
+++ b/Documentation/misc-devices/lp8x4x_bus.txt
@@ -19,13 +19,26 @@ LP-8x4x is an ARM-based industrial computer with a custom parallel bus to
 connect expansion modules with digital input/output, analog input/output,
 serial, CAN and other types of ports.
 
-The bus is implemented by a FPGA.
+The bus is implemented by a FPGA. There are two major groups of expansion
+modules: serial and parallel.
+
+Serial modules (I-870xxW series) implement DCON protocol which allows one-
+master-many-slaves configuration over RS-485. When these modules are installed
+into the device, they could be accessed using the 2nd PXA built-in UART port
+(/dev/ttyS1). However, it seems that addresses are not processed by
+the modules. So the parallel bus needs to select which slot is connected.
 
 SYSFS
 -----
 
 /sys/bus/icpdas/devices/backplane:
 
+active_slot
+	RW - connects the select slot for serial communications. If there
+	     is a parallel module in the selected slot, it simply ignores
+	     incoming packets. So it is safe to activate any available
+	     slot.
+
 dip
 	RO - shows status of LP-8x4x 8bit DIP switch
 
diff --git a/arch/arm/boot/dts/pxa27x-lp8x4x.dts b/arch/arm/boot/dts/pxa27x-lp8x4x.dts
index 52f0036..a6adf45 100644
--- a/arch/arm/boot/dts/pxa27x-lp8x4x.dts
+++ b/arch/arm/boot/dts/pxa27x-lp8x4x.dts
@@ -207,6 +207,7 @@
 				compatible = "icpdas,backplane-lp8x4x";
 				reg = <0x0 0x2
 				       0x9002 0x2
+				       0x9004 0x2
 				       0x9046 0x2>;
 				eeprom-gpios = <&gpio 4 0>;
 			};
diff --git a/drivers/misc/lp8x4x_bus.c b/drivers/misc/lp8x4x_bus.c
index 567fe078..e805640 100644
--- a/drivers/misc/lp8x4x_bus.c
+++ b/drivers/misc/lp8x4x_bus.c
@@ -29,6 +29,8 @@ struct lp8x4x_master {
 	void			*rotary_addr;
 	void			*dip_addr;
 	struct gpio_desc        *eeprom_nWE;
+	unsigned int		active_slot;
+	void			*switch_addr;
 	struct device		dev;
 };
 
@@ -47,6 +49,9 @@ static void lp8x4x_master_release(struct device *dev)
 	struct lp8x4x_master *m = container_of(dev, struct lp8x4x_master, dev);
 	WARN_ON(!dev);
 
+	/* Disable serial communications */
+	iowrite8(0xff, m->switch_addr);
+
 	kfree(m);
 }
 
@@ -114,11 +119,52 @@ static ssize_t dip_show(struct device *dev,
 
 static DEVICE_ATTR_RO(dip);
 
+static ssize_t active_slot_show(struct device *dev,
+		struct device_attribute *attr, char *buf)
+{
+	struct lp8x4x_master *m = container_of(dev, struct lp8x4x_master, dev);
+
+	return sprintf(buf, "%u\n", m->active_slot);
+}
+
+static ssize_t active_slot_store(struct device *dev,
+		struct device_attribute *attr, const char *buf, size_t count)
+{
+	struct lp8x4x_master *m = container_of(dev, struct lp8x4x_master, dev);
+	unsigned int active_slot = 0;
+	int err;
+
+	if (!buf)
+		return count;
+	if (0 == count)
+		return count;
+
+	err = kstrtouint(buf, 10, &active_slot);
+	if (err != 0 || active_slot > m->slot_count) {
+		dev_err(dev, "slot number is out of range 1..%u\n",
+				m->slot_count);
+		return count;
+	}
+
+	if (!active_slot) {
+		m->active_slot = 0;
+		iowrite8(0xff, m->switch_addr);
+		return count;
+	}
+
+	m->active_slot = active_slot;
+	iowrite8((1 << (m->active_slot - 1)) ^ 0xff, m->switch_addr);
+	return count;
+}
+
+static DEVICE_ATTR_RW(active_slot);
+
 static struct attribute *master_dev_attrs[] = {
 	&dev_attr_slot_count.attr,
 	&dev_attr_rotary.attr,
 	&dev_attr_eeprom_write_enable.attr,
 	&dev_attr_dip.attr,
+	&dev_attr_active_slot.attr,
 	NULL,
 };
 ATTRIBUTE_GROUPS(master_dev);
@@ -181,6 +227,20 @@ static int __init lp8x4x_bus_probe(struct platform_device *pdev)
 
 	res = platform_get_resource(pdev, IORESOURCE_MEM, r++);
 	if (!res) {
+		dev_err(&pdev->dev, "Failed to get slot switch address\n");
+		err = -ENODEV;
+		goto err_free;
+	}
+
+	m->switch_addr = devm_ioremap_resource(&pdev->dev, res);
+	if (IS_ERR(m->switch_addr)) {
+		dev_err(&pdev->dev, "Failed to ioremap switch address\n");
+		err = PTR_ERR(m->switch_addr);
+		goto err_free;
+	}
+
+	res = platform_get_resource(pdev, IORESOURCE_MEM, r++);
+	if (!res) {
 		dev_err(&pdev->dev, "could not get slot count address\n");
 		err = -ENODEV;
 		goto err_free;
@@ -223,6 +283,9 @@ static int __init lp8x4x_bus_probe(struct platform_device *pdev)
 
 	dev_info(&pdev->dev, "found bus with up to %u slots\n", m->slot_count);
 
+	/* Disable serial communications until explicitly enabled */
+	iowrite8(0xff, m->switch_addr);
+
 	err = bus_register(&lp8x4x_bus_type);
 	if (err < 0) {
 		dev_err(&pdev->dev, "failed to register bus type\n");
-- 
1.8.4.2

