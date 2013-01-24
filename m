Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755445Ab3AXDqj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jan 2013 22:46:39 -0500
Received: from bear.ext.ti.com ([192.94.94.41]:38594 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753630Ab3AXDpe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jan 2013 22:45:34 -0500
From: "Patil, Rachna" <rachna@ti.com>
To: <linux-doc@vger.kernel.org>, <devicetree-discuss@lists.ozlabs.org>,
        <linux-kernel@vger.kernel.org>, <linux-input@vger.kernel.org>,
        <linux-iio@vger.kernel.org>, <linux-omap@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>
CC: Samuel Ortiz <sameo@linux.intel.com>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Dmitry Torokhov <dtor@mail.ru>, Rob Herring <rob.herring@calxeda.com>,
        Jonathan Cameron <jic23@cam.ac.uk>, Tony Lindgren <tony@atomide.com>,
        Benit Cousson <b-cousson@ti.com>,
        Grant Likely <grant.likely@secretlab.ca>,
        Rob Landley <rob@landley.net>, Russell King <linux@arm.linux.org.uk>,
        <gururaja.hebbar@ti.com>, "Patil, Rachna" <rachna@ti.com>
Subject: [PATCH v4 6/8] input: ti_am335x_tsc: Add DT support
Date: Thu, 24 Jan 2013 09:15:10 +0530
Message-ID: <1358999112-31192-7-git-send-email-rachna@ti.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1358999112-31192-1-git-send-email-rachna@ti.com>
References: <1358999112-31192-1-git-send-email-rachna@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Patil, Rachna" <rachna@ti.com>

Add DT support for client touchscreen driver

Signed-off-by: Patil, Rachna <rachna@ti.com>
---
Changes in v4:
	Non-standard properties prefixed with vendor name.

 drivers/input/touchscreen/ti_am335x_tsc.c |   94 +++++++++++++++++++++++++----
 1 file changed, 81 insertions(+), 13 deletions(-)

diff --git a/drivers/input/touchscreen/ti_am335x_tsc.c b/drivers/input/touchscreen/ti_am335x_tsc.c
index 064d2b2..6ff5a76 100644
--- a/drivers/input/touchscreen/ti_am335x_tsc.c
+++ b/drivers/input/touchscreen/ti_am335x_tsc.c
@@ -26,6 +26,8 @@
 #include <linux/io.h>
 #include <linux/input/ti_am335x_tsc.h>
 #include <linux/delay.h>
+#include <linux/of.h>
+#include <linux/of_device.h>
 
 #include <linux/mfd/ti_am335x_tscadc.h>
 
@@ -366,6 +368,74 @@ static irqreturn_t titsc_irq(int irq, void *dev)
 	return IRQ_HANDLED;
 }
 
+static int titsc_parse_dt(struct ti_tscadc_dev *tscadc_dev,
+					struct titsc *ts_dev)
+{
+	struct device_node *node = tscadc_dev->dev->of_node;
+	int err, i;
+	u32 val32, wires_conf[4];
+
+	if (!node)
+		return -EINVAL;
+	else {
+		node = of_find_node_by_name(node, "tsc");
+		if (!node)
+			return -EINVAL;
+		else {
+			err = of_property_read_u32(node, "ti,wires", &val32);
+			if (err < 0)
+				goto error_ret;
+			else
+				ts_dev->wires = val32;
+
+			err = of_property_read_u32(node,
+					"ti,x-plate-resistance", &val32);
+			if (err < 0)
+				goto error_ret;
+			else
+				ts_dev->x_plate_resistance = val32;
+
+			err = of_property_read_u32(node,
+					"ti,steps-to-configure", &val32);
+			if (err < 0)
+				goto error_ret;
+			else
+				ts_dev->steps_to_configure = val32;
+
+			err = of_property_read_u32_array(node, "ti,wire-config",
+					wires_conf, ARRAY_SIZE(wires_conf));
+			if (err < 0)
+				goto error_ret;
+			else {
+				for (i = 0; i < ARRAY_SIZE(wires_conf); i++)
+					ts_dev->config_inp[i] = wires_conf[i];
+			}
+		}
+	}
+	return 0;
+
+error_ret:
+	return err;
+}
+
+static int titsc_parse_pdata(struct ti_tscadc_dev *tscadc_dev,
+					struct titsc *ts_dev)
+{
+	struct mfd_tscadc_board	*pdata = tscadc_dev->dev->platform_data;
+
+	if (!pdata)
+		return -EINVAL;
+
+	ts_dev->wires = pdata->tsc_init->wires;
+	ts_dev->x_plate_resistance =
+		pdata->tsc_init->x_plate_resistance;
+	ts_dev->steps_to_configure =
+		pdata->tsc_init->steps_to_configure;
+	memcpy(ts_dev->config_inp, pdata->tsc_init->wire_config,
+		sizeof(pdata->tsc_init->wire_config));
+	return 0;
+}
+
 /*
  * The functions for inserting/removing driver as a module.
  */
@@ -375,16 +445,8 @@ static int titsc_probe(struct platform_device *pdev)
 	struct titsc *ts_dev;
 	struct input_dev *input_dev;
 	struct ti_tscadc_dev *tscadc_dev = pdev->dev.platform_data;
-	struct mfd_tscadc_board	*pdata;
 	int err;
 
-	pdata = tscadc_dev->dev->platform_data;
-
-	if (!pdata) {
-		dev_err(&pdev->dev, "Could not find platform data\n");
-		return -EINVAL;
-	}
-
 	/* Allocate memory for device */
 	ts_dev = kzalloc(sizeof(struct titsc), GFP_KERNEL);
 	input_dev = input_allocate_device();
@@ -398,11 +460,17 @@ static int titsc_probe(struct platform_device *pdev)
 	ts_dev->mfd_tscadc = tscadc_dev;
 	ts_dev->input = input_dev;
 	ts_dev->irq = tscadc_dev->irq;
-	ts_dev->wires = pdata->tsc_init->wires;
-	ts_dev->x_plate_resistance = pdata->tsc_init->x_plate_resistance;
-	ts_dev->steps_to_configure = pdata->tsc_init->steps_to_configure;
-	memcpy(ts_dev->config_inp, pdata->tsc_init->wire_config,
-			sizeof(pdata->tsc_init->wire_config));
+
+	if (tscadc_dev->dev->platform_data)
+		err = titsc_parse_pdata(tscadc_dev, ts_dev);
+	else
+		err = titsc_parse_dt(tscadc_dev, ts_dev);
+
+	if (err) {
+		dev_err(&pdev->dev, "Could not find platform data\n");
+		err = -EINVAL;
+		goto err_free_mem;
+	}
 
 	err = request_irq(ts_dev->irq, titsc_irq,
 			  0, pdev->dev.driver->name, ts_dev);
-- 
1.7.9.5

