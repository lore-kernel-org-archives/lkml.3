Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755155AbaDPRTs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Apr 2014 13:19:48 -0400
Received: from mail-lb0-f174.google.com ([209.85.217.174]:50659 "EHLO
	mail-lb0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755067AbaDPRTj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Apr 2014 13:19:39 -0400
From: Sergei Ianovich <ynvich@gmail.com>
To: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Cc: Sergei Ianovich <ynvich@gmail.com>, Rob Herring <robh+dt@kernel.org>,
        Pawel Moll <pawel.moll@arm.com>, Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        Randy Dunlap <rdunlap@infradead.org>, Arnd Bergmann <arnd@arndb.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        devicetree@vger.kernel.org (open list:OPEN FIRMWARE AND...),
        linux-doc@vger.kernel.org (open list:DOCUMENTATION)
Subject: [PATCH v4 16/21] misc: support for writing to LP-8x4x EEPROM
Date: Wed, 16 Apr 2014 21:17:21 +0400
Message-Id: <1397668667-27328-10-git-send-email-ynvich@gmail.com>
X-Mailer: git-send-email 1.9.2
In-Reply-To: <1397668667-27328-1-git-send-email-ynvich@gmail.com>
References: <1397668411-27162-7-git-send-email-ynvich@gmail.com>
 <1397668667-27328-1-git-send-email-ynvich@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

at24c128 write protection is implemented by a separate GPIO line.
EEPROM driver doesn't provide this option, so we implement it
in the board-specific device.

Signed-off-by: Sergei Ianovich <ynvich@gmail.com>
---
   v3..v4
   * move DTS binding to a different patch (8/21)

   v2..v3
   * new patch

 .../devicetree/bindings/misc/lp8x4x-bus.txt        |  3 ++
 Documentation/misc-devices/lp8x4x_bus.txt          |  3 ++
 drivers/misc/lp8x4x_bus.c                          | 50 ++++++++++++++++++++++
 3 files changed, 56 insertions(+)

diff --git a/Documentation/devicetree/bindings/misc/lp8x4x-bus.txt b/Documentation/devicetree/bindings/misc/lp8x4x-bus.txt
index 1b1776a..b0fb145 100644
--- a/Documentation/devicetree/bindings/misc/lp8x4x-bus.txt
+++ b/Documentation/devicetree/bindings/misc/lp8x4x-bus.txt
@@ -10,6 +10,8 @@ Required properties:
        * the 8bit DIP switch
        * the slot count register
 
+- eeprom-gpios : should point to active-low write enable GPIO
+
 Example:
 
 	backplane {
@@ -17,4 +19,5 @@ Example:
 		reg = <0x0 0x2
 		       0x9002 0x2
 		       0x9046 0x2>;
+		eeprom-gpios = <&gpio 4 0>;
 	};
diff --git a/Documentation/misc-devices/lp8x4x_bus.txt b/Documentation/misc-devices/lp8x4x_bus.txt
index 829781b..78ea0a89 100644
--- a/Documentation/misc-devices/lp8x4x_bus.txt
+++ b/Documentation/misc-devices/lp8x4x_bus.txt
@@ -29,6 +29,9 @@ SYSFS
 dip
 	RO - shows status of LP-8x4x 8bit DIP switch
 
+eeprom_write_enable
+	RW - controls write access to board's EEPROM (1 - enable)
+
 rotary
 	RO - shows position of LP-8x4x rotary switch (0-9)
 
diff --git a/drivers/misc/lp8x4x_bus.c b/drivers/misc/lp8x4x_bus.c
index dfbc8c4..567fe078 100644
--- a/drivers/misc/lp8x4x_bus.c
+++ b/drivers/misc/lp8x4x_bus.c
@@ -9,6 +9,7 @@
  *  published by the Free Software Foundation or any later version.
  */
 #include <linux/err.h>
+#include <linux/gpio/consumer.h>
 #include <linux/init.h>
 #include <linux/io.h>
 #include <linux/list.h>
@@ -27,6 +28,7 @@ struct lp8x4x_master {
 	void			*count_addr;
 	void			*rotary_addr;
 	void			*dip_addr;
+	struct gpio_desc        *eeprom_nWE;
 	struct device		dev;
 };
 
@@ -68,6 +70,40 @@ static ssize_t rotary_show(struct device *dev,
 
 static DEVICE_ATTR_RO(rotary);
 
+static ssize_t eeprom_write_enable_show(struct device *dev,
+		struct device_attribute *attr, char *buf)
+{
+	struct lp8x4x_master *m = container_of(dev, struct lp8x4x_master, dev);
+
+	return sprintf(buf, "%u\n", !gpiod_get_value(m->eeprom_nWE));
+}
+
+static ssize_t eeprom_write_enable_store(struct device *dev,
+		struct device_attribute *attr, const char *buf, size_t count)
+{
+	struct lp8x4x_master *m = container_of(dev, struct lp8x4x_master, dev);
+	unsigned int val = 0;
+	int err;
+
+	if (!buf)
+		return count;
+
+	if (0 == count)
+		return count;
+
+	err = kstrtouint(buf, 10, &val);
+	if (err != 0) {
+		dev_err(dev, "Bad input %s\n", buf);
+		return count;
+	}
+
+	gpiod_set_value(m->eeprom_nWE, !val);
+
+	return count;
+}
+
+static DEVICE_ATTR_RW(eeprom_write_enable);
+
 static ssize_t dip_show(struct device *dev,
 		struct device_attribute *attr, char *buf)
 {
@@ -81,6 +117,7 @@ static DEVICE_ATTR_RO(dip);
 static struct attribute *master_dev_attrs[] = {
 	&dev_attr_slot_count.attr,
 	&dev_attr_rotary.attr,
+	&dev_attr_eeprom_write_enable.attr,
 	&dev_attr_dip.attr,
 	NULL,
 };
@@ -156,6 +193,19 @@ static int __init lp8x4x_bus_probe(struct platform_device *pdev)
 		goto err_free;
 	}
 
+	m->eeprom_nWE = devm_gpiod_get(&pdev->dev, "eeprom");
+	if (IS_ERR(m->eeprom_nWE)) {
+		err = PTR_ERR(m->eeprom_nWE);
+		dev_err(&pdev->dev, "Failed to get eeprom GPIO\n");
+		goto err_free;
+	}
+
+	err = gpiod_direction_output(m->eeprom_nWE, 1);
+	if (err < 0) {
+		dev_err(&pdev->dev, "Failed to set eeprom GPIO output\n");
+		goto err_free;
+	}
+
 	m->slot_count = ioread8(m->count_addr);
 	switch (m->slot_count) {
 	case 1:
-- 
1.8.4.2

