Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756763Ab3BFIER (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Feb 2013 03:04:17 -0500
Received: from mail-bk0-f52.google.com ([209.85.214.52]:35395 "EHLO
	mail-bk0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751317Ab3BFIEP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Feb 2013 03:04:15 -0500
From: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
To: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
Cc: Grant Likely <grant.likely@secretlab.ca>,
        Rob Herring <rob.herring@calxeda.com>, Rob Landley <rob@landley.net>,
        Mauro Carvalho Chehab <mchehab@redhat.com>,
        Benoit Thebaudeau <benoit.thebaudeau@advansee.com>,
        David Hardeman <david@hardeman.nu>, Trilok Soni <tsoni@codeaurora.org>,
        devicetree-discuss@lists.ozlabs.org, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-media@vger.kernel.org
Subject: [PATCH RESEND] media: rc: gpio-ir-recv: add support for device tree parsing
Date: Wed,  6 Feb 2013 09:03:52 +0100
Message-Id: <1360137832-13086-1-git-send-email-sebastian.hesselbarth@gmail.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1359400023-25804-1-git-send-email-sebastian.hesselbarth@gmail.com>
References: <1359400023-25804-1-git-send-email-sebastian.hesselbarth@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds device tree parsing for gpio_ir_recv platform_data and
the mandatory binding documentation. It basically follows what we already
have for e.g. gpio_keys. All required device tree properties are OS
independent but optional properties allow linux specific support for rc
protocols and maps.

There was a similar patch sent by Matus Ujhelyi but that discussion
died after the first reviews.

Signed-off-by: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
---
Cc: Grant Likely <grant.likely@secretlab.ca>
Cc: Rob Herring <rob.herring@calxeda.com>
Cc: Rob Landley <rob@landley.net>
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
Cc: Benoit Thebaudeau <benoit.thebaudeau@advansee.com>
Cc: David Hardeman <david@hardeman.nu>
Cc: Trilok Soni <tsoni@codeaurora.org>
Cc: devicetree-discuss@lists.ozlabs.org
Cc: linux-doc@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Cc: linux-media@vger.kernel.org
---
 .../devicetree/bindings/media/gpio-ir-receiver.txt |   20 ++++++
 drivers/media/rc/gpio-ir-recv.c                    |   68 +++++++++++++++++++-
 2 files changed, 86 insertions(+), 2 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/media/gpio-ir-receiver.txt

diff --git a/Documentation/devicetree/bindings/media/gpio-ir-receiver.txt b/Documentation/devicetree/bindings/media/gpio-ir-receiver.txt
new file mode 100644
index 0000000..937760c
--- /dev/null
+++ b/Documentation/devicetree/bindings/media/gpio-ir-receiver.txt
@@ -0,0 +1,20 @@
+Device-Tree bindings for GPIO IR receiver
+
+Required properties:
+	- compatible = "gpio-ir-receiver";
+	- gpios: OF device-tree gpio specification.
+
+Optional properties:
+	- linux,allowed-rc-protocols: Linux specific u64 bitmask of allowed
+	    rc protocols.
+	- linux,rc-map-name: Linux specific remote control map name.
+
+Example node:
+
+	ir: ir-receiver {
+		compatible = "gpio-ir-receiver";
+		gpios = <&gpio0 19 1>;
+		/* allow rc protocols 1-4 */
+		linux,allowed-rc-protocols = <0x00000000 0x0000001e>;
+		linux,rc-map-name = "rc-rc6-mce";
+	};
diff --git a/drivers/media/rc/gpio-ir-recv.c b/drivers/media/rc/gpio-ir-recv.c
index 4f71a7d..25e09fa 100644
--- a/drivers/media/rc/gpio-ir-recv.c
+++ b/drivers/media/rc/gpio-ir-recv.c
@@ -16,6 +16,7 @@
 #include <linux/interrupt.h>
 #include <linux/gpio.h>
 #include <linux/slab.h>
+#include <linux/of_gpio.h>
 #include <linux/platform_device.h>
 #include <linux/irq.h>
 #include <media/rc-core.h>
@@ -30,6 +31,63 @@ struct gpio_rc_dev {
 	bool active_low;
 };
 
+#ifdef CONFIG_OF
+/*
+ * Translate OpenFirmware node properties into platform_data
+ */
+static struct gpio_ir_recv_platform_data *
+gpio_ir_recv_get_devtree_pdata(struct device *dev)
+{
+	struct device_node *np = dev->of_node;
+	struct gpio_ir_recv_platform_data *pdata;
+	enum of_gpio_flags flags;
+	int gpio;
+
+	if (!np)
+		return ERR_PTR(-ENODEV);
+
+	pdata = devm_kzalloc(dev, sizeof(*pdata), GFP_KERNEL);
+	if (!pdata)
+		return ERR_PTR(-ENOMEM);
+
+	if (!of_find_property(np, "gpios", NULL)) {
+		dev_err(dev, "Found gpio-ir-receiver without gpios\n");
+		return ERR_PTR(-EINVAL);
+	}
+
+	gpio = of_get_gpio_flags(np, 0, &flags);
+	if (gpio < 0) {
+		if (gpio != -EPROBE_DEFER)
+			dev_err(dev, "Failed to get gpio flags, error: %d\n",
+				gpio);
+		return ERR_PTR(gpio);
+	}
+
+	pdata->gpio_nr = gpio;
+	pdata->active_low = (flags & OF_GPIO_ACTIVE_LOW) ? true : false;
+	pdata->map_name = of_get_property(np, "linux,rc-map-name", NULL);
+	of_property_read_u64(np, "linux,allowed-rc-protocols",
+			     &pdata->allowed_protos);
+
+	return pdata;
+}
+
+static struct of_device_id gpio_ir_recv_of_match[] = {
+	{ .compatible = "gpio-ir-receiver", },
+	{ },
+};
+MODULE_DEVICE_TABLE(of, gpio_ir_recv_of_match);
+
+#else /* !CONFIG_OF */
+
+static inline struct gpio_ir_recv_platform_data *
+gpio_ir_recv_get_devtree_pdata(struct device *dev)
+{
+	return ERR_PTR(-ENODEV);
+}
+
+#endif
+
 static irqreturn_t gpio_ir_recv_irq(int irq, void *dev_id)
 {
 	struct gpio_rc_dev *gpio_dev = dev_id;
@@ -66,8 +124,11 @@ static int gpio_ir_recv_probe(struct platform_device *pdev)
 					pdev->dev.platform_data;
 	int rc;
 
-	if (!pdata)
-		return -EINVAL;
+	if (!pdata) {
+		pdata = gpio_ir_recv_get_devtree_pdata(&pdev->dev);
+		if (IS_ERR(pdata))
+			return PTR_ERR(pdata);
+	}
 
 	if (pdata->gpio_nr < 0)
 		return -EINVAL;
@@ -195,6 +256,9 @@ static struct platform_driver gpio_ir_recv_driver = {
 #ifdef CONFIG_PM
 		.pm	= &gpio_ir_recv_pm_ops,
 #endif
+#ifdef CONFIG_OF
+		.of_match_table = of_match_ptr(gpio_ir_recv_of_match),
+#endif
 	},
 };
 module_platform_driver(gpio_ir_recv_driver);
-- 
1.7.10.4

