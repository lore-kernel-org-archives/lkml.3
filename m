Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754948Ab3FKLbw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Jun 2013 07:31:52 -0400
Received: from www.linutronix.de ([62.245.132.108]:33461 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754837Ab3FKLbr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Jun 2013 07:31:47 -0400
From: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
To: Lee Jones <lee.jones@linaro.org>, Samuel Ortiz <sameo@linux.intel.com>
Cc: =?UTF-8?q?Beno=C3=AEt=20Cousson?= <b-cousson@ti.com>,
        Tony Lindgren <tony@atomide.com>, Jonathan Cameron <jic23@cam.ac.uk>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Felipe Balbi <balbi@ti.com>, linux-kernel@vger.kernel.org,
        linux-omap@vger.kernel.org, linux-iio@vger.kernel.org,
        linux-input@vger.kernel.org, "Patil, Rachna" <rachna@ti.com>,
        Pantelis Antoniou <panto@antoniou-consulting.com>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Subject: [PATCH 08/22] iio/ti_am335x_adc: Add DT support
Date: Tue, 11 Jun 2013 13:30:54 +0200
Message-Id: <1370950268-7224-9-git-send-email-bigeasy@linutronix.de>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1370950268-7224-1-git-send-email-bigeasy@linutronix.de>
References: <1370950268-7224-1-git-send-email-bigeasy@linutronix.de>
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Patil, Rachna" <rachna@ti.com>

Add DT support for client ADC driver.

[ panto@antoniou-consulting.com : use of_get_child_by_name
	instead of of_find_node_by_name ]

Acked-by: Jonathan Cameron <jic23@kernel.org>
Signed-off-by: Pantelis Antoniou <panto@antoniou-consulting.com>
Signed-off-by: Patil, Rachna <rachna@ti.com>
Signed-off-by: Felipe Balbi <balbi@ti.com>
[bigeasy: shift the code to the left, fix clean up on
          of_get_child_by_name() failer, provide OF binding in mfd, use
	  own of node, get rid of of_get_child_by_name()]
Signed-off-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
---
 drivers/iio/adc/ti_am335x_adc.c |   29 ++++++++++++++++++++++++-----
 drivers/mfd/ti_am335x_tscadc.c  |    1 +
 2 files changed, 25 insertions(+), 5 deletions(-)

diff --git a/drivers/iio/adc/ti_am335x_adc.c b/drivers/iio/adc/ti_am335x_adc.c
index 543b9c4..b24402c 100644
--- a/drivers/iio/adc/ti_am335x_adc.c
+++ b/drivers/iio/adc/ti_am335x_adc.c
@@ -22,6 +22,8 @@
 #include <linux/platform_device.h>
 #include <linux/io.h>
 #include <linux/iio/iio.h>
+#include <linux/of.h>
+#include <linux/of_device.h>
 
 #include <linux/mfd/ti_am335x_tscadc.h>
 #include <linux/platform_data/ti_am335x_adc.h>
@@ -152,11 +154,12 @@ static int tiadc_probe(struct platform_device *pdev)
 	struct iio_dev		*indio_dev;
 	struct tiadc_device	*adc_dev;
 	struct ti_tscadc_dev	*tscadc_dev = ti_tscadc_dev_get(pdev);
-	struct mfd_tscadc_board	*pdata;
+	struct mfd_tscadc_board	*pdata = tscadc_dev->dev->platform_data;
+	struct device_node	*node = pdev->dev.of_node;
 	int			err;
+	u32			val32;
 
-	pdata = tscadc_dev->dev->platform_data;
-	if (!pdata || !pdata->adc_init) {
+	if (!pdata && !node) {
 		dev_err(&pdev->dev, "Could not find platform data\n");
 		return -EINVAL;
 	}
@@ -169,8 +172,17 @@ static int tiadc_probe(struct platform_device *pdev)
 	}
 	adc_dev = iio_priv(indio_dev);
 
-	adc_dev->mfd_tscadc = tscadc_dev;
-	adc_dev->channels = pdata->adc_init->adc_channels;
+	adc_dev->mfd_tscadc = ti_tscadc_dev_get(pdev);
+
+	if (pdata)
+		adc_dev->channels = pdata->adc_init->adc_channels;
+	else {
+		err = of_property_read_u32(node,
+				"ti,adc-channels", &val32);
+		if (err < 0)
+			goto err_free_device;
+		adc_dev->channels = val32;
+	}
 
 	indio_dev->dev.parent = &pdev->dev;
 	indio_dev->name = dev_name(&pdev->dev);
@@ -260,11 +272,18 @@ static const struct dev_pm_ops tiadc_pm_ops = {
 #define TIADC_PM_OPS NULL
 #endif
 
+static const struct of_device_id ti_adc_dt_ids[] = {
+	{ .compatible = "ti,am3359-adc", },
+	{ }
+};
+MODULE_DEVICE_TABLE(of, ti_adc_dt_ids);
+
 static struct platform_driver tiadc_driver = {
 	.driver = {
 		.name   = "tiadc",
 		.owner	= THIS_MODULE,
 		.pm	= TIADC_PM_OPS,
+		.of_match_table = of_match_ptr(ti_adc_dt_ids),
 	},
 	.probe	= tiadc_probe,
 	.remove	= tiadc_remove,
diff --git a/drivers/mfd/ti_am335x_tscadc.c b/drivers/mfd/ti_am335x_tscadc.c
index 15a01f6..eaaa253 100644
--- a/drivers/mfd/ti_am335x_tscadc.c
+++ b/drivers/mfd/ti_am335x_tscadc.c
@@ -191,6 +191,7 @@ static	int ti_tscadc_probe(struct platform_device *pdev)
 	/* ADC Cell */
 	cell = &tscadc->cells[ADC_CELL];
 	cell->name = "tiadc";
+	cell->of_compatible = "ti,am3359-adc";
 	cell->platform_data = &tscadc;
 	cell->pdata_size = sizeof(tscadc);
 
-- 
1.7.10.4

