Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757598Ab3FLQ6s (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Jun 2013 12:58:48 -0400
Received: from www.linutronix.de ([62.245.132.108]:44587 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755017Ab3FLQ6n (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Jun 2013 12:58:43 -0400
From: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
To: Samuel Ortiz <sameo@linux.intel.com>
Cc: =?UTF-8?q?Beno=C3=AEt=20Cousson?= <b-cousson@ti.com>,
        Tony Lindgren <tony@atomide.com>, Jonathan Cameron <jic23@cam.ac.uk>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Felipe Balbi <balbi@ti.com>, linux-kernel@vger.kernel.org,
        linux-omap@vger.kernel.org, linux-iio@vger.kernel.org,
        linux-input@vger.kernel.org,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Subject: [PATCH 08/21] iio: ti_am335x_adc: remove platform_data support
Date: Wed, 12 Jun 2013 18:58:09 +0200
Message-Id: <1371056302-12714-9-git-send-email-bigeasy@linutronix.de>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1371056302-12714-1-git-send-email-bigeasy@linutronix.de>
References: <1371056302-12714-1-git-send-email-bigeasy@linutronix.de>
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch removes access to platform data mfd_tscadc_board because the
platform is DT only.

Acked-by: Jonathan Cameron <jic23@kernel.org>
Signed-off-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
---
 drivers/iio/adc/ti_am335x_adc.c |   21 +++++++--------------
 1 file changed, 7 insertions(+), 14 deletions(-)

diff --git a/drivers/iio/adc/ti_am335x_adc.c b/drivers/iio/adc/ti_am335x_adc.c
index b24402c..2868c0c 100644
--- a/drivers/iio/adc/ti_am335x_adc.c
+++ b/drivers/iio/adc/ti_am335x_adc.c
@@ -26,7 +26,6 @@
 #include <linux/of_device.h>
 
 #include <linux/mfd/ti_am335x_tscadc.h>
-#include <linux/platform_data/ti_am335x_adc.h>
 
 struct tiadc_device {
 	struct ti_tscadc_dev *mfd_tscadc;
@@ -153,14 +152,12 @@ static int tiadc_probe(struct platform_device *pdev)
 {
 	struct iio_dev		*indio_dev;
 	struct tiadc_device	*adc_dev;
-	struct ti_tscadc_dev	*tscadc_dev = ti_tscadc_dev_get(pdev);
-	struct mfd_tscadc_board	*pdata = tscadc_dev->dev->platform_data;
 	struct device_node	*node = pdev->dev.of_node;
 	int			err;
 	u32			val32;
 
-	if (!pdata && !node) {
-		dev_err(&pdev->dev, "Could not find platform data\n");
+	if (!node) {
+		dev_err(&pdev->dev, "Could not find valid DT data.\n");
 		return -EINVAL;
 	}
 
@@ -174,15 +171,11 @@ static int tiadc_probe(struct platform_device *pdev)
 
 	adc_dev->mfd_tscadc = ti_tscadc_dev_get(pdev);
 
-	if (pdata)
-		adc_dev->channels = pdata->adc_init->adc_channels;
-	else {
-		err = of_property_read_u32(node,
-				"ti,adc-channels", &val32);
-		if (err < 0)
-			goto err_free_device;
-		adc_dev->channels = val32;
-	}
+	err = of_property_read_u32(node,
+			"ti,adc-channels", &val32);
+	if (err < 0)
+		goto err_free_device;
+	adc_dev->channels = val32;
 
 	indio_dev->dev.parent = &pdev->dev;
 	indio_dev->name = dev_name(&pdev->dev);
-- 
1.7.10.4

