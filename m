Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752947Ab3LQTka (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Dec 2013 14:40:30 -0500
Received: from mail-la0-f45.google.com ([209.85.215.45]:45369 "EHLO
	mail-la0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752899Ab3LQTkY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Dec 2013 14:40:24 -0500
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
Subject: [PATCH v3 18/21] misc: support for parallel slots in LP-8x4x
Date: Tue, 17 Dec 2013 23:37:48 +0400
Message-Id: <1387309071-22382-19-git-send-email-ynvich@gmail.com>
X-Mailer: git-send-email 1.8.5.1
In-Reply-To: <1387309071-22382-1-git-send-email-ynvich@gmail.com>
References: <1386901645-28895-1-git-send-email-ynvich@gmail.com>
 <1387309071-22382-1-git-send-email-ynvich@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch enumerates parallel modules in expansion slots and exposes
model numbers via sysfs.

Signed-off-by: Sergei Ianovich <ynvich@gmail.com>
---
   v2..v3
   * no changes (except number 13/16 -> 18/21)

   v0..v2
   * use device tree
   * use devm helpers where possible

 .../devicetree/bindings/misc/lp8x4x-bus.txt        |   9 ++
 Documentation/misc-devices/lp8x4x_bus.txt          |   8 ++
 arch/arm/boot/dts/pxa27x-lp8x4x.dts                |   8 ++
 drivers/misc/lp8x4x_bus.c                          | 119 +++++++++++++++++++++
 4 files changed, 144 insertions(+)

diff --git a/Documentation/devicetree/bindings/misc/lp8x4x-bus.txt b/Documentation/devicetree/bindings/misc/lp8x4x-bus.txt
index 24a8c62..75ac3b2 100644
--- a/Documentation/devicetree/bindings/misc/lp8x4x-bus.txt
+++ b/Documentation/devicetree/bindings/misc/lp8x4x-bus.txt
@@ -7,6 +7,7 @@ Required properties:
 
 - reg: physical base addresses and region lengths of
        * the rotary switch
+       * 8 plugable industrial IO slots
        * the 8bit DIP switch
        * the serial slot select register
        * the slot count register
@@ -18,6 +19,14 @@ Example:
 	backplane {
 		compatible = "icpdas,backplane-lp8x4x";
 		reg = <0x0 0x2
+		       0x1000 0x10
+		       0x2000 0x10
+		       0x3000 0x10
+		       0x4000 0x10
+		       0x5000 0x10
+		       0x6000 0x10
+		       0x7000 0x10
+		       0x8000 0x10
 		       0x9002 0x2
 		       0x9004 0x2
 		       0x9046 0x2>;
diff --git a/Documentation/misc-devices/lp8x4x_bus.txt b/Documentation/misc-devices/lp8x4x_bus.txt
index 7b86797..09380fd 100644
--- a/Documentation/misc-devices/lp8x4x_bus.txt
+++ b/Documentation/misc-devices/lp8x4x_bus.txt
@@ -28,6 +28,9 @@ into the device, they could be accessed using the 2nd PXA built-in UART port
 (/dev/ttyS1). However, it seems that addresses are not processed by
 the modules. So the parallel bus needs to select which slot is connected.
 
+Parallel modules allow much faster communication. There are accessed using
+IO memory through the FPGA. Their ports are exposed via sysfs.
+
 SYSFS
 -----
 
@@ -50,3 +53,8 @@ rotary
 
 slot_count
 	RO - shows total number of expansion slots on the device
+
+/sys/bus/icpdas/devices/slot%02i:
+
+model
+	RO - shows expansion module model number
diff --git a/arch/arm/boot/dts/pxa27x-lp8x4x.dts b/arch/arm/boot/dts/pxa27x-lp8x4x.dts
index a6adf45..f13b276 100644
--- a/arch/arm/boot/dts/pxa27x-lp8x4x.dts
+++ b/arch/arm/boot/dts/pxa27x-lp8x4x.dts
@@ -206,6 +206,14 @@
 			backplane {
 				compatible = "icpdas,backplane-lp8x4x";
 				reg = <0x0 0x2
+				       0x1000 0x10
+				       0x2000 0x10
+				       0x3000 0x10
+				       0x4000 0x10
+				       0x5000 0x10
+				       0x6000 0x10
+				       0x7000 0x10
+				       0x8000 0x10
 				       0x9002 0x2
 				       0x9004 0x2
 				       0x9046 0x2>;
diff --git a/drivers/misc/lp8x4x_bus.c b/drivers/misc/lp8x4x_bus.c
index e805640..59dc767 100644
--- a/drivers/misc/lp8x4x_bus.c
+++ b/drivers/misc/lp8x4x_bus.c
@@ -23,6 +23,13 @@ MODULE_LICENSE("GPL");
 MODULE_AUTHOR("Sergei Ianovich <ynvich@gmail.com>");
 MODULE_DESCRIPTION("ICP DAS LP-8x4x parallel bus driver");
 
+struct lp8x4x_slot {
+	void			*data_addr;
+	unsigned int		model;
+	struct device		dev;
+};
+
+#define LP8X4X_MAX_SLOT_COUNT	8
 struct lp8x4x_master {
 	unsigned int		slot_count;
 	void			*count_addr;
@@ -31,9 +38,45 @@ struct lp8x4x_master {
 	struct gpio_desc        *eeprom_nWE;
 	unsigned int		active_slot;
 	void			*switch_addr;
+	struct lp8x4x_slot	slot[LP8X4X_MAX_SLOT_COUNT];
 	struct device		dev;
 };
 
+static unsigned char lp8x4x_model[256] = {
+	   0,    0,    0, 0x11,    0, 0x18, 0x13, 0x11,
+	0x0e, 0x11,    0,    0,    0, 0x5a, 0x5b, 0x5c,
+	0x3c, 0x44, 0x34, 0x3a, 0x39, 0x36, 0x37, 0x33,
+	0x35, 0x40, 0x41, 0x42, 0x38, 0x3f, 0x32, 0x45,
+	0xac, 0x70, 0x8e, 0x8e, 0x1e, 0x72, 0x90, 0x29,
+	0x4a, 0x22, 0xd3, 0xd2, 0x28, 0x25, 0x2a, 0x29,
+	0x48, 0x49, 0x5d, 0x1f, 0x20, 0x23, 0x24, 0x4d,
+	0x3d, 0x3e,    0,    0,    0,    0,    0,    0,
+	   0, 0x78, 0x72, 0x2b, 0x5e, 0x5e, 0x36, 0xae,
+	0x30,    0,    0,    0,    0,    0,    0,    0,
+	   0,    0, 0x5c, 0x5e,    0, 0x5e,    0,    0,
+	   0, 0x3b,    0,    0,    0,    0,    0,    0,
+	   0, 0x50, 0x2e,    0, 0x58,    0,    0, 0x43,
+	   0,    0,    0,    0,    0,    0,    0,    0,
+	   0, 0x54,    0,    0,    0,    0,    0,    0,
+	   0,    0,    0,    0,    0,    0,    0,    0,
+	   0,    0,    0,    0,    0,    0,    0,    0,
+	   0,    0,    0,    0,    0,    0,    0,    0,
+	   0,    0,    0,    0,    0,    0,    0,    0,
+	   0,    0,    0,    0,    0,    0,    0,    0,
+	   0,    0,    0,    0,    0,    0,    0,    0,
+	   0,    0,    0,    0,    0,    0,    0,    0,
+	   0,    0,    0,    0,    0,    0,    0,    0,
+	   0,    0,    0,    0,    0,    0,    0,    0,
+	   0,    0,    0,    0,    0,    0,    0,    0,
+	   0,    0,    0,    0,    0,    0,    0,    0,
+	   0,    0,    0,    0,    0,    0,    0,    0,
+	   0,    0,    0,    0,    0,    0,    0,    0,
+	   0,    0,    0,    0,    0,    0,    0,    0,
+	   0,    0,    0,    0,    0,    0,    0,    0,
+	   0,    0,    0,    0,    0,    0,    0,    0,
+	   0,    0,    0,    0,    0,    0,    0,    0
+};
+
 static int lp8x4x_match(struct device *dev, struct device_driver *drv)
 {
 	return 1;
@@ -44,6 +87,26 @@ static struct bus_type lp8x4x_bus_type = {
 	.match		= lp8x4x_match,
 };
 
+static void lp8x4x_slot_release(struct device *dev)
+{
+}
+
+static ssize_t model_show(struct device *dev,
+		struct device_attribute *attr, char *buf)
+{
+	struct lp8x4x_slot *s = container_of(dev, struct lp8x4x_slot, dev);
+
+	return sprintf(buf, "%u\n", s->model + 8000);
+}
+
+static DEVICE_ATTR_RO(model);
+
+static struct attribute *slot_dev_attrs[] = {
+	&dev_attr_model.attr,
+	NULL,
+};
+ATTRIBUTE_GROUPS(slot_dev);
+
 static void lp8x4x_master_release(struct device *dev)
 {
 	struct lp8x4x_master *m = container_of(dev, struct lp8x4x_master, dev);
@@ -173,18 +236,50 @@ ATTRIBUTE_GROUPS(master_dev);
 static void devm_lp8x4x_bus_release(struct device *dev, void *res)
 {
 	struct lp8x4x_master *m = *(struct lp8x4x_master **)res;
+	struct lp8x4x_slot *s;
+	int i;
 
 	dev_dbg(dev, "releasing devices\n");
+	for (i = 0; i < LP8X4X_MAX_SLOT_COUNT; i++) {
+		s = &m->slot[i];
+		if (s->model)
+			device_unregister(&s->dev);
+	}
 	device_unregister(&m->dev);
 	bus_unregister(&lp8x4x_bus_type);
 }
 
+static void __init lp8x4x_bus_probe_slot(struct lp8x4x_master *m, int i,
+		unsigned char model)
+{
+	struct lp8x4x_slot *s = &m->slot[i];
+	int err;
+
+	dev_info(&m->dev, "found %u in slot %i\n", 8000 + model, i + 1);
+
+	s->dev.bus = &lp8x4x_bus_type;
+	dev_set_name(&s->dev, "slot%02i", i + 1);
+	s->dev.parent = &m->dev;
+	s->dev.release = lp8x4x_slot_release;
+	s->dev.groups = slot_dev_groups;
+	s->model = model;
+
+	err = device_register(&s->dev);
+	if (err < 0) {
+		dev_err(&s->dev, "failed to register device\n");
+		s->model = 0;
+		return;
+	}
+}
+
 static int __init lp8x4x_bus_probe(struct platform_device *pdev)
 {
 	struct lp8x4x_master *m, **p;
 	struct resource *res;
 	int r = 0;
+	int i;
 	int err = 0;
+	unsigned int model;
 
 	m = kzalloc(sizeof(*m), GFP_KERNEL);
 	if (!m)
@@ -211,6 +306,23 @@ static int __init lp8x4x_bus_probe(struct platform_device *pdev)
 		goto err_free;
 	}
 
+	for (i = 0; i < LP8X4X_MAX_SLOT_COUNT; i++) {
+		res = platform_get_resource(pdev, IORESOURCE_MEM, r++);
+		if (!res) {
+			dev_err(&pdev->dev, "Failed to get slot %i address\n",
+					i);
+			err = -ENODEV;
+			goto err_free;
+		}
+
+		m->slot[i].data_addr = devm_ioremap_resource(&pdev->dev, res);
+		if (IS_ERR(m->slot[i].data_addr)) {
+			dev_err(&pdev->dev, "Failed to ioremap slot %i\n", i);
+			err = PTR_ERR(m->slot[i].data_addr);
+			goto err_free;
+		}
+	}
+
 	res = platform_get_resource(pdev, IORESOURCE_MEM, r++);
 	if (!res) {
 		dev_err(&pdev->dev, "Failed to get DIP switch address\n");
@@ -305,6 +417,13 @@ static int __init lp8x4x_bus_probe(struct platform_device *pdev)
 	}
 
 	devres_add(&pdev->dev, p);
+	for (i = 0; i < LP8X4X_MAX_SLOT_COUNT; i++) {
+		model = lp8x4x_model[ioread8(m->slot[i].data_addr)];
+		if (!model)
+			continue;
+
+		lp8x4x_bus_probe_slot(m, i, model);
+	}
 	return 0;
 
 err_bus:
-- 
1.8.4.2

