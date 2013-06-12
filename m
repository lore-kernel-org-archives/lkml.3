Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932093Ab3FLRM4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Jun 2013 13:12:56 -0400
Received: from www.linutronix.de ([62.245.132.108]:44724 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757679Ab3FLRMy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Jun 2013 13:12:54 -0400
From: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
To: Samuel Ortiz <sameo@linux.intel.com>
Cc: =?UTF-8?q?Beno=C3=AEt=20Cousson?= <b-cousson@ti.com>,
        Tony Lindgren <tony@atomide.com>, Jonathan Cameron <jic23@cam.ac.uk>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Felipe Balbi <balbi@ti.com>, linux-kernel@vger.kernel.org,
        linux-omap@vger.kernel.org, linux-iio@vger.kernel.org,
        linux-input@vger.kernel.org,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Subject: [PATCH 10/21] mfd: ti_am335x_tscadc: remove platform_data support
Date: Wed, 12 Jun 2013 18:58:11 +0200
Message-Id: <1371056302-12714-11-git-send-email-bigeasy@linutronix.de>
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

Signed-off-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
---
 drivers/mfd/ti_am335x_tscadc.c |   23 ++++++-----------------
 1 file changed, 6 insertions(+), 17 deletions(-)

diff --git a/drivers/mfd/ti_am335x_tscadc.c b/drivers/mfd/ti_am335x_tscadc.c
index 292d34e..e78b9df 100644
--- a/drivers/mfd/ti_am335x_tscadc.c
+++ b/drivers/mfd/ti_am335x_tscadc.c
@@ -26,8 +26,6 @@
 #include <linux/of_device.h>
 
 #include <linux/mfd/ti_am335x_tscadc.h>
-#include <linux/input/ti_am335x_tsc.h>
-#include <linux/platform_data/ti_am335x_adc.h>
 
 static unsigned int tscadc_readl(struct ti_tscadc_dev *tsadc, unsigned int reg)
 {
@@ -91,31 +89,22 @@ static	int ti_tscadc_probe(struct platform_device *pdev)
 	struct ti_tscadc_dev	*tscadc;
 	struct resource		*res;
 	struct clk		*clk;
-	struct mfd_tscadc_board	*pdata = pdev->dev.platform_data;
 	struct device_node	*node = pdev->dev.of_node;
 	struct mfd_cell		*cell;
 	int			err, ctrl;
 	int			clk_value, clock_rate;
 	int			tsc_wires = 0, adc_channels = 0, total_channels;
 
-	if (!pdata && !pdev->dev.of_node) {
-		dev_err(&pdev->dev, "Could not find platform data\n");
+	if (!pdev->dev.of_node) {
+		dev_err(&pdev->dev, "Could not find valid DT data.\n");
 		return -EINVAL;
 	}
 
-	if (pdev->dev.platform_data) {
-		if (pdata->tsc_init)
-			tsc_wires = pdata->tsc_init->wires;
+	node = of_get_child_by_name(pdev->dev.of_node, "tsc");
+	of_property_read_u32(node, "ti,wires", &tsc_wires);
 
-		if (pdata->adc_init)
-			adc_channels = pdata->adc_init->adc_channels;
-	} else {
-		node = of_get_child_by_name(pdev->dev.of_node, "tsc");
-		of_property_read_u32(node, "ti,wires", &tsc_wires);
-
-		node = of_get_child_by_name(pdev->dev.of_node, "adc");
-		of_property_read_u32(node, "ti,adc-channels", &adc_channels);
-	}
+	node = of_get_child_by_name(pdev->dev.of_node, "adc");
+	of_property_read_u32(node, "ti,adc-channels", &adc_channels);
 
 	total_channels = tsc_wires + adc_channels;
 
-- 
1.7.10.4

