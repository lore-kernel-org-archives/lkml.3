Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752897Ab3LQTkW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Dec 2013 14:40:22 -0500
Received: from mail-lb0-f173.google.com ([209.85.217.173]:40080 "EHLO
	mail-lb0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752810Ab3LQTkK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Dec 2013 14:40:10 -0500
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
Subject: [PATCH v3 15/21] misc: support for LP-8x4x DIP switch
Date: Tue, 17 Dec 2013 23:37:45 +0400
Message-Id: <1387309071-22382-16-git-send-email-ynvich@gmail.com>
X-Mailer: git-send-email 1.8.5.1
In-Reply-To: <1387309071-22382-1-git-send-email-ynvich@gmail.com>
References: <1386901645-28895-1-git-send-email-ynvich@gmail.com>
 <1387309071-22382-1-git-send-email-ynvich@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Sergei Ianovich <ynvich@gmail.com>
---
   v2..v3
   * new patch

 .../devicetree/bindings/misc/lp8x4x-bus.txt        |  2 ++
 Documentation/misc-devices/lp8x4x_bus.txt          |  3 +++
 arch/arm/boot/dts/pxa27x-lp8x4x.dts                |  1 +
 drivers/misc/lp8x4x_bus.c                          | 26 ++++++++++++++++++++++
 4 files changed, 32 insertions(+)

diff --git a/Documentation/devicetree/bindings/misc/lp8x4x-bus.txt b/Documentation/devicetree/bindings/misc/lp8x4x-bus.txt
index 8a55020..1b1776a 100644
--- a/Documentation/devicetree/bindings/misc/lp8x4x-bus.txt
+++ b/Documentation/devicetree/bindings/misc/lp8x4x-bus.txt
@@ -7,6 +7,7 @@ Required properties:
 
 - reg: physical base addresses and region lengths of
        * the rotary switch
+       * the 8bit DIP switch
        * the slot count register
 
 Example:
@@ -14,5 +15,6 @@ Example:
 	backplane {
 		compatible = "icpdas,backplane-lp8x4x";
 		reg = <0x0 0x2
+		       0x9002 0x2
 		       0x9046 0x2>;
 	};
diff --git a/Documentation/misc-devices/lp8x4x_bus.txt b/Documentation/misc-devices/lp8x4x_bus.txt
index bea435b..829781b 100644
--- a/Documentation/misc-devices/lp8x4x_bus.txt
+++ b/Documentation/misc-devices/lp8x4x_bus.txt
@@ -26,6 +26,9 @@ SYSFS
 
 /sys/bus/icpdas/devices/backplane:
 
+dip
+	RO - shows status of LP-8x4x 8bit DIP switch
+
 rotary
 	RO - shows position of LP-8x4x rotary switch (0-9)
 
diff --git a/arch/arm/boot/dts/pxa27x-lp8x4x.dts b/arch/arm/boot/dts/pxa27x-lp8x4x.dts
index b50ce43..09a6bc9 100644
--- a/arch/arm/boot/dts/pxa27x-lp8x4x.dts
+++ b/arch/arm/boot/dts/pxa27x-lp8x4x.dts
@@ -206,6 +206,7 @@
 			backplane {
 				compatible = "icpdas,backplane-lp8x4x";
 				reg = <0x0 0x2
+				       0x9002 0x2
 				       0x9046 0x2>;
 			};
 		};
diff --git a/drivers/misc/lp8x4x_bus.c b/drivers/misc/lp8x4x_bus.c
index 18ca8f8..dfbc8c4 100644
--- a/drivers/misc/lp8x4x_bus.c
+++ b/drivers/misc/lp8x4x_bus.c
@@ -26,6 +26,7 @@ struct lp8x4x_master {
 	unsigned int		slot_count;
 	void			*count_addr;
 	void			*rotary_addr;
+	void			*dip_addr;
 	struct device		dev;
 };
 
@@ -67,9 +68,20 @@ static ssize_t rotary_show(struct device *dev,
 
 static DEVICE_ATTR_RO(rotary);
 
+static ssize_t dip_show(struct device *dev,
+		struct device_attribute *attr, char *buf)
+{
+	struct lp8x4x_master *m = container_of(dev, struct lp8x4x_master, dev);
+
+	return sprintf(buf, "0x%02x\n", ioread8(m->dip_addr) ^ 0xff);
+}
+
+static DEVICE_ATTR_RO(dip);
+
 static struct attribute *master_dev_attrs[] = {
 	&dev_attr_slot_count.attr,
 	&dev_attr_rotary.attr,
+	&dev_attr_dip.attr,
 	NULL,
 };
 ATTRIBUTE_GROUPS(master_dev);
@@ -118,6 +130,20 @@ static int __init lp8x4x_bus_probe(struct platform_device *pdev)
 
 	res = platform_get_resource(pdev, IORESOURCE_MEM, r++);
 	if (!res) {
+		dev_err(&pdev->dev, "Failed to get DIP switch address\n");
+		err = -ENODEV;
+		goto err_free;
+	}
+
+	m->dip_addr = devm_ioremap_resource(&pdev->dev, res);
+	if (IS_ERR(m->dip_addr)) {
+		dev_err(&pdev->dev, "Failed to ioremap DIP switch address\n");
+		err = PTR_ERR(m->dip_addr);
+		goto err_free;
+	}
+
+	res = platform_get_resource(pdev, IORESOURCE_MEM, r++);
+	if (!res) {
 		dev_err(&pdev->dev, "could not get slot count address\n");
 		err = -ENODEV;
 		goto err_free;
-- 
1.8.4.2

