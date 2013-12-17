Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753616Ab3LQTrE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Dec 2013 14:47:04 -0500
Received: from mail-lb0-f172.google.com ([209.85.217.172]:45305 "EHLO
	mail-lb0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752747Ab3LQTkG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Dec 2013 14:40:06 -0500
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
Subject: [PATCH v3 14/21] misc: support for LP-8x4x rotary switch
Date: Tue, 17 Dec 2013 23:37:44 +0400
Message-Id: <1387309071-22382-15-git-send-email-ynvich@gmail.com>
X-Mailer: git-send-email 1.8.5.1
In-Reply-To: <1387309071-22382-1-git-send-email-ynvich@gmail.com>
References: <1386901645-28895-1-git-send-email-ynvich@gmail.com>
 <1387309071-22382-1-git-send-email-ynvich@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Reorder backplane resources by start address.

Reorder backplane attributes alphabetically.

Signed-off-by: Sergei Ianovich <ynvich@gmail.com>
---
   v2..v3
   * new patch

 .../devicetree/bindings/misc/lp8x4x-bus.txt        |  8 ++--
 Documentation/misc-devices/lp8x4x_bus.txt          |  3 ++
 arch/arm/boot/dts/pxa27x-lp8x4x.dts                |  3 +-
 drivers/misc/lp8x4x_bus.c                          | 43 ++++++++++++++++++----
 4 files changed, 45 insertions(+), 12 deletions(-)

diff --git a/Documentation/devicetree/bindings/misc/lp8x4x-bus.txt b/Documentation/devicetree/bindings/misc/lp8x4x-bus.txt
index 1c87a29..8a55020 100644
--- a/Documentation/devicetree/bindings/misc/lp8x4x-bus.txt
+++ b/Documentation/devicetree/bindings/misc/lp8x4x-bus.txt
@@ -5,12 +5,14 @@ See Documentation/misc-devices/lp8x4x_bus.txt for details.
 Required properties:
 - compatible : should be "icpdas,backplane-lp8x4x"
 
-- reg: physical base address of the slot count register and the length
-       of the memory mapped region.
+- reg: physical base addresses and region lengths of
+       * the rotary switch
+       * the slot count register
 
 Example:
 
 	backplane {
 		compatible = "icpdas,backplane-lp8x4x";
-		reg = <0x17009046 0x2>;
+		reg = <0x0 0x2
+		       0x9046 0x2>;
 	};
diff --git a/Documentation/misc-devices/lp8x4x_bus.txt b/Documentation/misc-devices/lp8x4x_bus.txt
index f5392b3..bea435b 100644
--- a/Documentation/misc-devices/lp8x4x_bus.txt
+++ b/Documentation/misc-devices/lp8x4x_bus.txt
@@ -26,5 +26,8 @@ SYSFS
 
 /sys/bus/icpdas/devices/backplane:
 
+rotary
+	RO - shows position of LP-8x4x rotary switch (0-9)
+
 slot_count
 	RO - shows total number of expansion slots on the device
diff --git a/arch/arm/boot/dts/pxa27x-lp8x4x.dts b/arch/arm/boot/dts/pxa27x-lp8x4x.dts
index 4ea566c..b50ce43 100644
--- a/arch/arm/boot/dts/pxa27x-lp8x4x.dts
+++ b/arch/arm/boot/dts/pxa27x-lp8x4x.dts
@@ -205,7 +205,8 @@
 
 			backplane {
 				compatible = "icpdas,backplane-lp8x4x";
-				reg = <0x9046 0x2>;
+				reg = <0x0 0x2
+				       0x9046 0x2>;
 			};
 		};
 	};
diff --git a/drivers/misc/lp8x4x_bus.c b/drivers/misc/lp8x4x_bus.c
index 7aa55cf..18ca8f8 100644
--- a/drivers/misc/lp8x4x_bus.c
+++ b/drivers/misc/lp8x4x_bus.c
@@ -25,6 +25,7 @@ MODULE_DESCRIPTION("ICP DAS LP-8x4x parallel bus driver");
 struct lp8x4x_master {
 	unsigned int		slot_count;
 	void			*count_addr;
+	void			*rotary_addr;
 	struct device		dev;
 };
 
@@ -56,8 +57,19 @@ static ssize_t slot_count_show(struct device *dev,
 
 static DEVICE_ATTR_RO(slot_count);
 
+static ssize_t rotary_show(struct device *dev,
+		struct device_attribute *attr, char *buf)
+{
+	struct lp8x4x_master *m = container_of(dev, struct lp8x4x_master, dev);
+
+	return sprintf(buf, "%u\n", (ioread8(m->rotary_addr) ^ 0xf) & 0xf);
+}
+
+static DEVICE_ATTR_RO(rotary);
+
 static struct attribute *master_dev_attrs[] = {
 	&dev_attr_slot_count.attr,
+	&dev_attr_rotary.attr,
 	NULL,
 };
 ATTRIBUTE_GROUPS(master_dev);
@@ -76,6 +88,7 @@ static int __init lp8x4x_bus_probe(struct platform_device *pdev)
 {
 	struct lp8x4x_master *m, **p;
 	struct resource *res;
+	int r = 0;
 	int err = 0;
 
 	m = kzalloc(sizeof(*m), GFP_KERNEL);
@@ -89,18 +102,32 @@ static int __init lp8x4x_bus_probe(struct platform_device *pdev)
 	}
 	*p = m;
 
-	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
+	res = platform_get_resource(pdev, IORESOURCE_MEM, r++);
+	if (!res) {
+		dev_err(&pdev->dev, "Failed to get rotary address\n");
+		err = -ENODEV;
+		goto err_free;
+	}
+
+	m->rotary_addr = devm_ioremap_resource(&pdev->dev, res);
+	if (IS_ERR(m->rotary_addr)) {
+		dev_err(&pdev->dev, "Failed to ioremap rotary address\n");
+		err = PTR_ERR(m->rotary_addr);
+		goto err_free;
+	}
+
+	res = platform_get_resource(pdev, IORESOURCE_MEM, r++);
 	if (!res) {
 		dev_err(&pdev->dev, "could not get slot count address\n");
 		err = -ENODEV;
-		goto err2;
+		goto err_free;
 	}
 
 	m->count_addr = devm_ioremap_resource(&pdev->dev, res);
 	if (IS_ERR(m->count_addr)) {
 		dev_err(&pdev->dev, "Failed to ioremap slot count address\n");
 		err = PTR_ERR(m->count_addr);
-		goto err2;
+		goto err_free;
 	}
 
 	m->slot_count = ioread8(m->count_addr);
@@ -115,7 +142,7 @@ static int __init lp8x4x_bus_probe(struct platform_device *pdev)
 		dev_err(&pdev->dev, "unexpected slot number(%u)",
 				m->slot_count);
 		err = -ENODEV;
-		goto err2;
+		goto err_free;
 	};
 
 	dev_info(&pdev->dev, "found bus with up to %u slots\n", m->slot_count);
@@ -123,7 +150,7 @@ static int __init lp8x4x_bus_probe(struct platform_device *pdev)
 	err = bus_register(&lp8x4x_bus_type);
 	if (err < 0) {
 		dev_err(&pdev->dev, "failed to register bus type\n");
-		goto err2;
+		goto err_free;
 	}
 
 	m->dev.bus = &lp8x4x_bus_type;
@@ -135,15 +162,15 @@ static int __init lp8x4x_bus_probe(struct platform_device *pdev)
 	err = device_register(&m->dev);
 	if (err < 0) {
 		dev_err(&pdev->dev, "failed to register backplane device\n");
-		goto err3;
+		goto err_bus;
 	}
 
 	devres_add(&pdev->dev, p);
 	return 0;
 
-err3:
+err_bus:
 	bus_unregister(&lp8x4x_bus_type);
-err2:
+err_free:
 	devres_free(p);
 err1:
 	kfree(m);
-- 
1.8.4.2

