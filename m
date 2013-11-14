Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932229Ab3KNVrn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Nov 2013 16:47:43 -0500
Received: from mail-wi0-f172.google.com ([209.85.212.172]:61917 "EHLO
	mail-wi0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757870Ab3KNVrM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Nov 2013 16:47:12 -0500
From: Marek Belisko <marek@goldelico.com>
To: arnd@arndb.de, gregkh@linuxfoundation.org
Cc: neilb@suse.de, hns@goldelico.com, rob.herring@calxeda.com,
        pawel.moll@arm.com, mark.rutland@arm.com, swarren@wwwdotorg.org,
        ijc+devicetree@hellion.org.uk, rob@landley.net,
        devicetree@vger.kernel.org, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, Marek Belisko <marek@goldelico.com>
Subject: [PATCH 3/3] misc: bmp085: Add missing platform data.
Date: Thu, 14 Nov 2013 22:46:49 +0100
Message-Id: <1384465609-26485-4-git-send-email-marek@goldelico.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1384465609-26485-1-git-send-email-marek@goldelico.com>
References: <1384465609-26485-1-git-send-email-marek@goldelico.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

DT bindings contains more parameters to set so add them to platform data also
to have possibility to use on arch where DT isn't available yet.

Signed-off-by: Marek Belisko <marek@goldelico.com>
---
 drivers/misc/bmp085.c      | 21 +++++++++++++++++----
 include/linux/i2c/bmp085.h |  7 +++++++
 2 files changed, 24 insertions(+), 4 deletions(-)

diff --git a/drivers/misc/bmp085.c b/drivers/misc/bmp085.c
index 9792ce2..530b4a1 100644
--- a/drivers/misc/bmp085.c
+++ b/drivers/misc/bmp085.c
@@ -408,13 +408,15 @@ static void bmp085_get_of_properties(struct bmp085_data *data,
 		return;
 
 	if (!of_property_read_u32(np, "chip-id", &prop))
-		data->chip_id = prop & 0xff;
+		pdata->chip_id = prop & 0xff;
 
 	if (!of_property_read_u32(np, "temp-measurement-period", &prop))
-		data->temp_measurement_period = (prop/100)*HZ;
+		pdata->temp_measurement_period = (prop/100)*HZ;
 
 	if (!of_property_read_u32(np, "default-oversampling", &prop))
-		data->oversampling_setting = prop & 0xff;
+		pdata->default_oversampling = prop & 0xff;
+	else
+		pdata->default_oversampling = -1;
 
 	pdata->gpio = of_get_named_gpio(np, "gpio", 0);
 	of_property_read_u32(np, "irq", &pdata->irq);
@@ -443,9 +445,20 @@ static int bmp085_init_client(struct device *dev, struct bmp085_data *data)
 					GFP_KERNEL);
 		if (!pdata)
 			return -ENOMEM;
+
+		bmp085_get_of_properties(data, pdata);
 	}
 
-	bmp085_get_of_properties(data, pdata);
+	if (pdata->chip_id)
+		data->chip_id = pdata->chip_id;
+
+	if (pdata->temp_measurement_period > 0)
+		data->temp_measurement_period =
+			(pdata->temp_measurement_period/100)*HZ;
+
+	if (pdata->default_oversampling >= 0 &&
+		pdata->default_oversampling <= 3)
+		data->oversampling_setting = pdata->default_oversampling;
 
 	if (gpio_is_valid(pdata->gpio)) {
 		err = devm_gpio_request(dev, pdata->gpio, "bmp085_eoc_irq");
diff --git a/include/linux/i2c/bmp085.h b/include/linux/i2c/bmp085.h
index b66cb98..addb972 100644
--- a/include/linux/i2c/bmp085.h
+++ b/include/linux/i2c/bmp085.h
@@ -5,11 +5,18 @@
 
 /*
  * bmp085 platform data
+ * @chip_id: configurable chip id for non-default chip revisions
+ * @temp_measurement_period: in milliseconds
+ * @default_oversampling: used at startup, range is 0-3 with rising sensitivity
+ * set it to -1 when don't want to change default value (3)
  * @gpio: if is set it is the End Of Conversion line which is high when
  * conversion is finished
  * @irq: if gpio < 0 and irq > 0, then it is an interrupt with no gpio
  */
 struct bmp085_platform_data {
+	int	chip_id;
+	int	temp_measurement_period;
+	int	default_oversampling;
 	int	gpio;
 	int	irq;
 };
-- 
1.8.1.2

