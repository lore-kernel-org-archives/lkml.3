Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1947288Ab3BHWr7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Feb 2013 17:47:59 -0500
Received: from mail-bk0-f45.google.com ([209.85.214.45]:51771 "EHLO
	mail-bk0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1947094Ab3BHWr5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Feb 2013 17:47:57 -0500
From: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
To: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
Cc: Grant Likely <grant.likely@secretlab.ca>,
        Rob Herring <rob.herring@calxeda.com>, Rob Landley <rob@landley.net>,
        Mauro Carvalho Chehab <mchehab@redhat.com>,
        Benoit Thebaudeau <benoit.thebaudeau@advansee.com>,
        David Hardeman <david@hardeman.nu>, Trilok Soni <tsoni@codeaurora.org>,
        Sylwester Nawrocki <s.nawrocki@samsung.com>,
        Matus Ujhelyi <ujhelyi.m@gmail.com>,
        devicetree-discuss@lists.ozlabs.org, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-media@vger.kernel.org
Subject: [PATCH v3] media: rc: gpio-ir-recv: add support for device tree parsing
Date: Fri,  8 Feb 2013 23:47:30 +0100
Message-Id: <1360363651-30814-1-git-send-email-sebastian.hesselbarth@gmail.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1360355887-19973-1-git-send-email-sebastian.hesselbarth@gmail.com>
References: <1360355887-19973-1-git-send-email-sebastian.hesselbarth@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds device tree parsing for gpio_ir_recv platform_data and
the mandatory binding documentation. It basically follows what we already
have for e.g. gpio_keys. All required device tree properties are OS
independent but an optional property allows linux specific support for rc
maps.

Signed-off-by: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
Reviewed-by: Sylwester Nawrocki <s.nawrocki@samsung.com>
---
There was a similar patch sent by Matus Ujhelyi but that discussion
died after the first reviews.

Changelog

v1->v2:
- get rid of ptr returned by _get_devtree_pdata()
- check for of_node instead for NULL pdata
- remove unneccessary double check for gpios property
- remove unneccessary #ifdef CONFIG_OF around match table

v2->v3:
- use define for !OF_CONFIG _get_devtree_pdata()
- simplify flags test and of_get_gpio_flags error msg
- fix some typos in binding documentation
- move note about previous patch submission to non-commit area
 
Cc: Grant Likely <grant.likely@secretlab.ca>
Cc: Rob Herring <rob.herring@calxeda.com>
Cc: Rob Landley <rob@landley.net>
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
Cc: Benoit Thebaudeau <benoit.thebaudeau@advansee.com>
Cc: David Hardeman <david@hardeman.nu>
Cc: Trilok Soni <tsoni@codeaurora.org>
Cc: Sylwester Nawrocki <s.nawrocki@samsung.com>
Cc: Matus Ujhelyi <ujhelyi.m@gmail.com>
Cc: devicetree-discuss@lists.ozlabs.org
Cc: linux-doc@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Cc: linux-media@vger.kernel.org
---
 .../devicetree/bindings/media/gpio-ir-receiver.txt |   16 ++++++
 drivers/media/rc/gpio-ir-recv.c                    |   52 ++++++++++++++++++++
 2 files changed, 68 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/media/gpio-ir-receiver.txt

diff --git a/Documentation/devicetree/bindings/media/gpio-ir-receiver.txt b/Documentation/devicetree/bindings/media/gpio-ir-receiver.txt
new file mode 100644
index 0000000..56e726e
--- /dev/null
+++ b/Documentation/devicetree/bindings/media/gpio-ir-receiver.txt
@@ -0,0 +1,16 @@
+Device-Tree bindings for GPIO IR receiver
+
+Required properties:
+	- compatible: should be "gpio-ir-receiver".
+	- gpios: specifies GPIO used for IR signal reception.
+
+Optional properties:
+	- linux,rc-map-name: Linux specific remote control map name.
+
+Example node:
+
+	ir: ir-receiver {
+		compatible = "gpio-ir-receiver";
+		gpios = <&gpio0 19 1>;
+		linux,rc-map-name = "rc-rc6-mce";
+	};
diff --git a/drivers/media/rc/gpio-ir-recv.c b/drivers/media/rc/gpio-ir-recv.c
index 4f71a7d..b5cfb44 100644
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
@@ -30,6 +31,45 @@ struct gpio_rc_dev {
 	bool active_low;
 };
 
+#ifdef CONFIG_OF
+/*
+ * Translate OpenFirmware node properties into platform_data
+ */
+static int gpio_ir_recv_get_devtree_pdata(struct device *dev,
+				  struct gpio_ir_recv_platform_data *pdata)
+{
+	struct device_node *np = dev->of_node;
+	enum of_gpio_flags flags;
+	int gpio;
+
+	gpio = of_get_gpio_flags(np, 0, &flags);
+	if (gpio < 0) {
+		if (gpio != -EPROBE_DEFER)
+			dev_err(dev, "Failed to get gpio flags (%d)\n", gpio);
+		return gpio;
+	}
+
+	pdata->gpio_nr = gpio;
+	pdata->active_low = (flags & OF_GPIO_ACTIVE_LOW);
+	/* probe() takes care of map_name == NULL or allowed_protos == 0 */
+	pdata->map_name = of_get_property(np, "linux,rc-map-name", NULL);
+	pdata->allowed_protos = 0;
+
+	return 0;
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
+#define gpio_ir_recv_get_devtree_pdata(dev, pdata)	(-ENOSYS)
+
+#endif
+
 static irqreturn_t gpio_ir_recv_irq(int irq, void *dev_id)
 {
 	struct gpio_rc_dev *gpio_dev = dev_id;
@@ -66,6 +106,17 @@ static int gpio_ir_recv_probe(struct platform_device *pdev)
 					pdev->dev.platform_data;
 	int rc;
 
+	if (pdev->dev.of_node) {
+		struct gpio_ir_recv_platform_data *dtpdata =
+			devm_kzalloc(&pdev->dev, sizeof(*dtpdata), GFP_KERNEL);
+		if (!dtpdata)
+			return -ENOMEM;
+		rc = gpio_ir_recv_get_devtree_pdata(&pdev->dev, dtpdata);
+		if (rc)
+			return rc;
+		pdata = dtpdata;
+	}
+
 	if (!pdata)
 		return -EINVAL;
 
@@ -192,6 +243,7 @@ static struct platform_driver gpio_ir_recv_driver = {
 	.driver = {
 		.name   = GPIO_IR_DRIVER_NAME,
 		.owner  = THIS_MODULE,
+		.of_match_table = of_match_ptr(gpio_ir_recv_of_match),
 #ifdef CONFIG_PM
 		.pm	= &gpio_ir_recv_pm_ops,
 #endif
-- 
1.7.10.4

