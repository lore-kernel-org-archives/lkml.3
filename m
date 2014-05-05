Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755842AbaEEJGs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 May 2014 05:06:48 -0400
Received: from comal.ext.ti.com ([198.47.26.152]:37992 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755095AbaEEJE4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 May 2014 05:04:56 -0400
From: Roger Quadros <rogerq@ti.com>
To: <dmitry.torokhov@gmail.com>
CC: <rydberg@euromail.se>, <balbi@ti.com>, <dmurphy@ti.com>,
        <mugunthanvnm@ti.com>, <nsekhar@ti.com>, <linux-input@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <devicetree@vger.kernel.org>,
        Roger Quadros <rogerq@ti.com>
Subject: [PATCH v4 3/7] Input: pixcir_i2c_ts: Get rid of pdata->attb_read_val()
Date: Mon, 5 May 2014 12:04:34 +0300
Message-ID: <1399280678-23925-4-git-send-email-rogerq@ti.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1399280678-23925-1-git-send-email-rogerq@ti.com>
References: <1399280678-23925-1-git-send-email-rogerq@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Get rid of the attb_read_val() platform hook. Instead,
read the ATTB gpio directly from the driver.

Fail if valid ATTB gpio is not provided by patform data.

Signed-off-by: Roger Quadros <rogerq@ti.com>
Acked-by: Mugunthan V N <mugunthanvnm@ti.com>
---
 drivers/input/touchscreen/pixcir_i2c_ts.c | 16 +++++++++++++++-
 include/linux/input/pixcir_ts.h           |  2 +-
 2 files changed, 16 insertions(+), 2 deletions(-)

diff --git a/drivers/input/touchscreen/pixcir_i2c_ts.c b/drivers/input/touchscreen/pixcir_i2c_ts.c
index 53d01d4..d0f6989 100644
--- a/drivers/input/touchscreen/pixcir_i2c_ts.c
+++ b/drivers/input/touchscreen/pixcir_i2c_ts.c
@@ -24,6 +24,7 @@
 #include <linux/i2c.h>
 #include <linux/input.h>
 #include <linux/input/pixcir_ts.h>
+#include <linux/gpio.h>
 
 struct pixcir_i2c_ts_data {
 	struct i2c_client *client;
@@ -87,11 +88,12 @@ static void pixcir_ts_poscheck(struct pixcir_i2c_ts_data *data)
 static irqreturn_t pixcir_ts_isr(int irq, void *dev_id)
 {
 	struct pixcir_i2c_ts_data *tsdata = dev_id;
+	const struct pixcir_ts_platform_data *pdata = tsdata->chip;
 
 	while (!tsdata->exiting) {
 		pixcir_ts_poscheck(tsdata);
 
-		if (tsdata->chip->attb_read_val())
+		if (gpio_get_value(pdata->gpio_attb))
 			break;
 
 		msleep(20);
@@ -296,6 +298,11 @@ static int pixcir_i2c_ts_probe(struct i2c_client *client,
 	if (!pdata) {
 		dev_err(&client->dev, "platform data not defined\n");
 		return -EINVAL;
+	} else {
+		if (!gpio_is_valid(pdata->gpio_attb)) {
+			dev_err(dev, "Invalid gpio_attb in pdata\n");
+			return -EINVAL;
+		}
 	}
 
 	tsdata = devm_kzalloc(dev, sizeof(*tsdata), GFP_KERNEL);
@@ -328,6 +335,13 @@ static int pixcir_i2c_ts_probe(struct i2c_client *client,
 
 	input_set_drvdata(input, tsdata);
 
+	error = devm_gpio_request_one(dev, pdata->gpio_attb,
+				      GPIOF_DIR_IN, "pixcir_i2c_attb");
+	if (error) {
+		dev_err(dev, "Failed to request ATTB gpio\n");
+		return error;
+	}
+
 	error = devm_request_threaded_irq(dev, client->irq, NULL, pixcir_ts_isr,
 					  IRQF_TRIGGER_FALLING | IRQF_ONESHOT,
 					  client->name, tsdata);
diff --git a/include/linux/input/pixcir_ts.h b/include/linux/input/pixcir_ts.h
index 7942804..160cf35 100644
--- a/include/linux/input/pixcir_ts.h
+++ b/include/linux/input/pixcir_ts.h
@@ -44,9 +44,9 @@ enum pixcir_int_mode {
 #define PIXCIR_INT_POL_HIGH	(1UL << 2)
 
 struct pixcir_ts_platform_data {
-	int (*attb_read_val)(void);
 	int x_max;
 	int y_max;
+	int gpio_attb;		/* GPIO connected to ATTB line */
 };
 
 #endif
-- 
1.8.3.2

