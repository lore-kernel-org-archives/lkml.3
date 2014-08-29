Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754253AbaH2R7O (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Aug 2014 13:59:14 -0400
Received: from mail-pa0-f42.google.com ([209.85.220.42]:48263 "EHLO
	mail-pa0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751944AbaH2R7I (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Aug 2014 13:59:08 -0400
From: Soren Brinkmann <soren.brinkmann@xilinx.com>
To: Alexandre Courbot <gnurou@gmail.com>,
        Linus Walleij <linus.walleij@linaro.org>
Cc: =?UTF-8?q?S=C3=B6ren=20Brinkmann?= <soren.brinkmann@xilinx.com>,
        Michal Simek <michal.simek@xilinx.com>,
        Harini Katakam <harinik@xilinx.com>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-gpio@vger.kernel.org, Lars-Peter Clausen <lars@metafoo.de>,
        Ezra Savard <ezras@xilinx.com>
Subject: [PATCH 3/3] gpio: lib-sysfs: Add 'wakeup' attribute
Date: Fri, 29 Aug 2014 10:58:47 -0700
Message-Id: <1409335127-26712-4-git-send-email-soren.brinkmann@xilinx.com>
X-Mailer: git-send-email 2.1.0.1.g27b9230
In-Reply-To: <1409335127-26712-1-git-send-email-soren.brinkmann@xilinx.com>
References: <1409335127-26712-1-git-send-email-soren.brinkmann@xilinx.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add an attribute 'wakeup' to the GPIO sysfs interface which allows
marking/unmarking a GPIO as wake IRQ.
The file 'wakeup' is created in each exported GPIOs directory, if an IRQ
is associated with that GPIO and the irqchip implements set_wake().
Writing 'enabled' to that file will enable wake for that GPIO, while
writing 'disabled' will disable wake.
Reading that file will return either 'disabled' or 'enabled' depening on
the currently set flag for the GPIO's IRQ.

Signed-off-by: Soren Brinkmann <soren.brinkmann@xilinx.com>
---
 drivers/gpio/gpiolib-sysfs.c | 75 ++++++++++++++++++++++++++++++++++++++++----
 1 file changed, 69 insertions(+), 6 deletions(-)

diff --git a/drivers/gpio/gpiolib-sysfs.c b/drivers/gpio/gpiolib-sysfs.c
index 5f2150b619a7..aaf021eaaff5 100644
--- a/drivers/gpio/gpiolib-sysfs.c
+++ b/drivers/gpio/gpiolib-sysfs.c
@@ -286,6 +286,56 @@ found:
 
 static DEVICE_ATTR(edge, 0644, gpio_edge_show, gpio_edge_store);
 
+static ssize_t gpio_wakeup_show(struct device *dev,
+		struct device_attribute *attr, char *buf)
+{
+	ssize_t			status;
+	const struct gpio_desc	*desc = dev_get_drvdata(dev);
+	int			irq = gpiod_to_irq(desc);
+	struct irq_desc		*irq_desc = irq_to_desc(irq);
+
+	mutex_lock(&sysfs_lock);
+
+	if (irqd_is_wakeup_set(&irq_desc->irq_data))
+		status = sprintf(buf, "enabled\n");
+	else
+		status = sprintf(buf, "disabled\n");
+
+	mutex_unlock(&sysfs_lock);
+
+	return status;
+}
+
+static ssize_t gpio_wakeup_store(struct device *dev,
+		struct device_attribute *attr, const char *buf, size_t size)
+{
+	int			ret;
+	unsigned int		on;
+	struct gpio_desc	*desc = dev_get_drvdata(dev);
+	int			irq = gpiod_to_irq(desc);
+
+	mutex_lock(&sysfs_lock);
+
+	if (sysfs_streq("enabled", buf))
+		on = true;
+	else if (sysfs_streq("disabled", buf))
+		on = false;
+	else
+		return -EINVAL;
+
+	ret = irq_set_irq_wake(irq, on);
+
+	mutex_unlock(&sysfs_lock);
+
+	if (ret)
+		pr_warn("%s: failed to %s wake\n", __func__,
+				on ? "enable" : "disable");
+
+	return size;
+}
+
+static DEVICE_ATTR(wakeup, 0644, gpio_wakeup_show, gpio_wakeup_store);
+
 static int sysfs_set_active_low(struct gpio_desc *desc, struct device *dev,
 				int value)
 {
@@ -526,7 +576,7 @@ static struct class gpio_class = {
 int gpiod_export(struct gpio_desc *desc, bool direction_may_change)
 {
 	unsigned long		flags;
-	int			status;
+	int			status, irq;
 	const char		*ioname = NULL;
 	struct device		*dev;
 	int			offset;
@@ -582,11 +632,24 @@ int gpiod_export(struct gpio_desc *desc, bool direction_may_change)
 			goto fail_unregister_device;
 	}
 
-	if (gpiod_to_irq(desc) >= 0 && (direction_may_change ||
-				       !test_bit(FLAG_IS_OUT, &desc->flags))) {
-		status = device_create_file(dev, &dev_attr_edge);
-		if (status)
-			goto fail_unregister_device;
+	irq = gpiod_to_irq(desc);
+	if (irq >= 0) {
+		struct irq_desc *irq_desc = irq_to_desc(irq);
+		struct irq_chip	*irqchip = irq_desc_get_chip(irq_desc);
+
+		if (direction_may_change ||
+				!test_bit(FLAG_IS_OUT, &desc->flags)) {
+			status = device_create_file(dev, &dev_attr_edge);
+			if (status)
+				goto fail_unregister_device;
+		}
+
+		if (irqchip->flags & IRQCHIP_SKIP_SET_WAKE ||
+				irqchip->irq_set_wake) {
+			status = device_create_file(dev, &dev_attr_wakeup);
+			if (status)
+				goto fail_unregister_device;
+		}
 	}
 
 	set_bit(FLAG_EXPORT, &desc->flags);
-- 
2.1.0.1.g27b9230

