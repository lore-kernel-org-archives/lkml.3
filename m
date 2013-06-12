Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757784Ab3FLRMQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Jun 2013 13:12:16 -0400
Received: from www.linutronix.de ([62.245.132.108]:44706 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757737Ab3FLRMM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Jun 2013 13:12:12 -0400
From: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
To: Samuel Ortiz <sameo@linux.intel.com>
Cc: =?UTF-8?q?Beno=C3=AEt=20Cousson?= <b-cousson@ti.com>,
        Tony Lindgren <tony@atomide.com>, Jonathan Cameron <jic23@cam.ac.uk>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Felipe Balbi <balbi@ti.com>, linux-kernel@vger.kernel.org,
        linux-omap@vger.kernel.org, linux-iio@vger.kernel.org,
        linux-input@vger.kernel.org,
        Pantelis Antoniou <panto@antoniou-consulting.com>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Subject: [PATCH 12/21] mfd: ti_tscadc: deal with partial activation
Date: Wed, 12 Jun 2013 18:58:13 +0200
Message-Id: <1371056302-12714-13-git-send-email-bigeasy@linutronix.de>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1371056302-12714-1-git-send-email-bigeasy@linutronix.de>
References: <1371056302-12714-1-git-send-email-bigeasy@linutronix.de>
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Pantelis Antoniou <panto@antoniou-consulting.com>

Fix the mfd device in the case where a subdevice might not be activated.

Signed-off-by: Pantelis Antoniou <panto@antoniou-consulting.com>
Signed-off-by: Felipe Balbi <balbi@ti.com>
Signed-off-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
---
 drivers/mfd/ti_am335x_tscadc.c       |   38 ++++++++++++++++++++++------------
 include/linux/mfd/ti_am335x_tscadc.h |    8 +++----
 2 files changed, 28 insertions(+), 18 deletions(-)

diff --git a/drivers/mfd/ti_am335x_tscadc.c b/drivers/mfd/ti_am335x_tscadc.c
index e78b9df..d05fcba 100644
--- a/drivers/mfd/ti_am335x_tscadc.c
+++ b/drivers/mfd/ti_am335x_tscadc.c
@@ -107,11 +107,14 @@ static	int ti_tscadc_probe(struct platform_device *pdev)
 	of_property_read_u32(node, "ti,adc-channels", &adc_channels);
 
 	total_channels = tsc_wires + adc_channels;
-
 	if (total_channels > 8) {
 		dev_err(&pdev->dev, "Number of i/p channels more than 8\n");
 		return -EINVAL;
 	}
+	if (total_channels == 0) {
+		dev_err(&pdev->dev, "Need atleast one channel.\n");
+		return -EINVAL;
+	}
 
 	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
 	if (!res) {
@@ -202,28 +205,37 @@ static	int ti_tscadc_probe(struct platform_device *pdev)
 	ctrl |= CNTRLREG_TSCSSENB;
 	tscadc_writel(tscadc, REG_CTRL, ctrl);
 
+	tscadc->used_cells = 0;
+	tscadc->tsc_cell = -1;
+	tscadc->adc_cell = -1;
+
 	/* TSC Cell */
-	cell = &tscadc->cells[TSC_CELL];
-	cell->name = "tsc";
-	cell->of_compatible = "ti,am3359-tsc";
-	cell->platform_data = &tscadc;
-	cell->pdata_size = sizeof(tscadc);
+	if (tsc_wires > 0) {
+		tscadc->tsc_cell = tscadc->used_cells;
+		cell = &tscadc->cells[tscadc->used_cells++];
+		cell->name = "tsc";
+		cell->of_compatible = "ti,am3359-tsc";
+		cell->platform_data = &tscadc;
+		cell->pdata_size = sizeof(tscadc);
+	}
 
 	/* ADC Cell */
-	cell = &tscadc->cells[ADC_CELL];
-	cell->name = "tiadc";
-	cell->of_compatible = "ti,am3359-adc";
-	cell->platform_data = &tscadc;
-	cell->pdata_size = sizeof(tscadc);
+	if (adc_channels > 0) {
+		tscadc->adc_cell = tscadc->used_cells;
+		cell = &tscadc->cells[tscadc->used_cells++];
+		cell->name = "tiadc";
+		cell->of_compatible = "ti,am3359-adc";
+		cell->platform_data = &tscadc;
+		cell->pdata_size = sizeof(tscadc);
+	}
 
 	err = mfd_add_devices(&pdev->dev, pdev->id, tscadc->cells,
-			TSCADC_CELLS, NULL, 0, NULL);
+			tscadc->used_cells, NULL, 0, NULL);
 	if (err < 0)
 		goto err_disable_clk;
 
 	device_init_wakeup(&pdev->dev, true);
 	platform_set_drvdata(pdev, tscadc);
-
 	return 0;
 
 err_disable_clk:
diff --git a/include/linux/mfd/ti_am335x_tscadc.h b/include/linux/mfd/ti_am335x_tscadc.h
index e36ae41..fe54ba4 100644
--- a/include/linux/mfd/ti_am335x_tscadc.h
+++ b/include/linux/mfd/ti_am335x_tscadc.h
@@ -120,11 +120,6 @@
 
 #define TSCADC_CELLS		2
 
-enum tscadc_cells {
-	TSC_CELL,
-	ADC_CELL,
-};
-
 struct mfd_tscadc_board {
 	struct tsc_data *tsc_init;
 	struct adc_data *adc_init;
@@ -135,6 +130,9 @@ struct ti_tscadc_dev {
 	struct regmap *regmap_tscadc;
 	void __iomem *tscadc_base;
 	int irq;
+	int used_cells;	/* 1-2 */
+	int tsc_cell;	/* -1 if not used */
+	int adc_cell;	/* -1 if not used */
 	struct mfd_cell cells[TSCADC_CELLS];
 	u32 reg_se_cache;
 	spinlock_t reg_lock;
-- 
1.7.10.4

