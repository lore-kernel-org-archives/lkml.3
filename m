Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932124Ab3KNVrT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Nov 2013 16:47:19 -0500
Received: from mail-wi0-f179.google.com ([209.85.212.179]:50195 "EHLO
	mail-wi0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757787Ab3KNVrJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Nov 2013 16:47:09 -0500
From: Marek Belisko <marek@goldelico.com>
To: arnd@arndb.de, gregkh@linuxfoundation.org
Cc: neilb@suse.de, hns@goldelico.com, rob.herring@calxeda.com,
        pawel.moll@arm.com, mark.rutland@arm.com, swarren@wwwdotorg.org,
        ijc+devicetree@hellion.org.uk, rob@landley.net,
        devicetree@vger.kernel.org, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, Marek Belisko <marek@goldelico.com>
Subject: [PATCH 2/3] misc: bmp085: Add DT bindings for EOC gpio line and direct irq.
Date: Thu, 14 Nov 2013 22:46:48 +0100
Message-Id: <1384465609-26485-3-git-send-email-marek@goldelico.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1384465609-26485-1-git-send-email-marek@goldelico.com>
References: <1384465609-26485-1-git-send-email-marek@goldelico.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Marek Belisko <marek@goldelico.com>
---
 Documentation/devicetree/bindings/misc/bmp085.txt |  8 ++++
 drivers/misc/bmp085.c                             | 53 ++++++++++++++++++++---
 2 files changed, 55 insertions(+), 6 deletions(-)

diff --git a/Documentation/devicetree/bindings/misc/bmp085.txt b/Documentation/devicetree/bindings/misc/bmp085.txt
index 91dfda2..c6033d5 100644
--- a/Documentation/devicetree/bindings/misc/bmp085.txt
+++ b/Documentation/devicetree/bindings/misc/bmp085.txt
@@ -8,6 +8,9 @@ Optional properties:
 - temp-measurement-period: temperature measurement period (milliseconds)
 - default-oversampling: default oversampling value to be used at startup,
   value range is 0-3 with rising sensitivity.
+- gpio: if device is using EOC irq line gpio can be specified to setup interrupt
+  handling
+- irq: interrupt with no gpio
 
 Example:
 
@@ -17,4 +20,9 @@ pressure@77 {
 	chip-id = <10>;
 	temp-measurement-period = <100>;
 	default-oversampling = <2>;
+	gpio = <&gpio0 17 0>;
+
+	OR
+
+	irq = <75>;
 };
diff --git a/drivers/misc/bmp085.c b/drivers/misc/bmp085.c
index 1510a7b..9792ce2 100644
--- a/drivers/misc/bmp085.c
+++ b/drivers/misc/bmp085.c
@@ -50,6 +50,7 @@
 #include <linux/init.h>
 #include <linux/slab.h>
 #include <linux/of.h>
+#include <linux/of_gpio.h>
 #include "bmp085.h"
 #include <linux/interrupt.h>
 #include <linux/completion.h>
@@ -396,7 +397,8 @@ int bmp085_detect(struct device *dev)
 }
 EXPORT_SYMBOL_GPL(bmp085_detect);
 
-static void bmp085_get_of_properties(struct bmp085_data *data)
+static void bmp085_get_of_properties(struct bmp085_data *data,
+			struct bmp085_platform_data *pdata)
 {
 #ifdef CONFIG_OF
 	struct device_node *np = data->dev->of_node;
@@ -413,12 +415,18 @@ static void bmp085_get_of_properties(struct bmp085_data *data)
 
 	if (!of_property_read_u32(np, "default-oversampling", &prop))
 		data->oversampling_setting = prop & 0xff;
+
+	pdata->gpio = of_get_named_gpio(np, "gpio", 0);
+	of_property_read_u32(np, "irq", &pdata->irq);
 #endif
 }
 
-static int bmp085_init_client(struct bmp085_data *data)
+static int bmp085_init_client(struct device *dev, struct bmp085_data *data)
 {
 	int status = bmp085_read_calibration_data(data);
+	struct bmp085_platform_data *pdata = dev->platform_data;
+	struct device_node *node = dev->of_node;
+	int err;
 
 	if (status < 0)
 		return status;
@@ -429,11 +437,46 @@ static int bmp085_init_client(struct bmp085_data *data)
 	data->temp_measurement_period = 1*HZ;
 	data->oversampling_setting = 3;
 
-	bmp085_get_of_properties(data);
+	/* parse DT to get platform data */
+	if (node && !pdata) {
+		pdata = devm_kzalloc(dev, sizeof(struct bmp085_platform_data),
+					GFP_KERNEL);
+		if (!pdata)
+			return -ENOMEM;
+	}
+
+	bmp085_get_of_properties(data, pdata);
+
+	if (gpio_is_valid(pdata->gpio)) {
+		err = devm_gpio_request(dev, pdata->gpio, "bmp085_eoc_irq");
+		if (err)
+			goto exit_free;
+		err = gpio_direction_input(pdata->gpio);
+		if (err)
+			goto exit_free;
+		data->irq = gpio_to_irq(pdata->gpio);
+		data->gpio = pdata->gpio;
+	} else {
+		if (pdata->irq > 0)
+			data->irq = pdata->irq;
+		else
+			data->irq = 0;
+		data->gpio = -EINVAL;
+	}
+	if (data->irq > 0) {
+		err = request_any_context_irq(data->irq, bmp085_eoc_isr,
+					      IRQF_TRIGGER_RISING, "bmp085",
+					      data);
+		if (err < 0)
+			goto exit_free;
+	}
 
 	mutex_init(&data->lock);
 
 	return 0;
+
+exit_free:
+	return err;
 }
 
 struct regmap_config bmp085_regmap_config = {
@@ -445,7 +488,6 @@ EXPORT_SYMBOL_GPL(bmp085_regmap_config);
 int bmp085_probe(struct device *dev, struct regmap *regmap)
 {
 	struct bmp085_data *data;
-	struct bmp085_platform_data *pdata = dev->platform_data;
 	int err = 0;
 
 	data = kzalloc(sizeof(struct bmp085_data), GFP_KERNEL);
@@ -484,7 +526,7 @@ int bmp085_probe(struct device *dev, struct regmap *regmap)
 		data->irq = 0;
 
 	/* Initialize the BMP085 chip */
-	err = bmp085_init_client(data);
+	err = bmp085_init_client(dev, data);
 	if (err < 0)
 		goto exit_free_irq;
 
@@ -506,7 +548,6 @@ int bmp085_probe(struct device *dev, struct regmap *regmap)
 exit_free_irq:
 	if (data->irq)
 		free_irq(data->irq, data);
-exit_free:
 	kfree(data);
 exit:
 	return err;
-- 
1.8.1.2

