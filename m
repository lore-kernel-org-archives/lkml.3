Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752927AbaJGHIh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Oct 2014 03:08:37 -0400
Received: from smtp105.ord1c.emailsrvr.com ([108.166.43.105]:52146 "EHLO
	smtp105.ord1c.emailsrvr.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751223AbaJGHIf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Oct 2014 03:08:35 -0400
X-Sender-Id: pramod.gurav@smartplayin.com
From: Pramod Gurav <pramod.gurav@smartplayin.com>
To: linux-kernel@vger.kernel.org
Cc: Pramod Gurav <pramod.gurav@smartplayin.com>,
        Eduardo Valentin <edubezval@gmail.com>,
        Zhang Rui <rui.zhang@intel.com>, linux-pm@vger.kernel.org
Subject: [PATCH v2] thermal: ti-soc-thermal: Switch to using managed resources
Date: Tue,  7 Oct 2014 12:41:56 +0530
Message-Id: <1412665916-3957-1-git-send-email-pramod.gurav@smartplayin.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This change switches to managed resource APIs to allocated resources
such as irq, clock. Hence does away with release statements of the
same resorces in error lables and remove function.

Cc: Eduardo Valentin <edubezval@gmail.com>
Cc: Zhang Rui <rui.zhang@intel.com>
Cc: linux-pm@vger.kernel.org
Signed-off-by: Pramod Gurav <pramod.gurav@smartplayin.com>
---
Change since v1:

Passing struct device to devm_clk_get was missing. Fix the same in v2.

 drivers/thermal/ti-soc-thermal/ti-bandgap.c |   46 +++++++--------------------
 1 file changed, 12 insertions(+), 34 deletions(-)

diff --git a/drivers/thermal/ti-soc-thermal/ti-bandgap.c b/drivers/thermal/ti-soc-thermal/ti-bandgap.c
index 634b6ce..22013ef 100644
--- a/drivers/thermal/ti-soc-thermal/ti-bandgap.c
+++ b/drivers/thermal/ti-soc-thermal/ti-bandgap.c
@@ -1060,7 +1060,7 @@ static int ti_bandgap_tshut_init(struct ti_bandgap *bgp,
 	int status;
 
 	/* Request for gpio_86 line */
-	status = gpio_request(gpio_nr, "tshut");
+	status = devm_gpio_request(&pdev->dev, gpio_nr, "tshut");
 	if (status < 0) {
 		dev_err(bgp->dev, "Could not request for TSHUT GPIO:%i\n", 86);
 		return status;
@@ -1071,11 +1071,12 @@ static int ti_bandgap_tshut_init(struct ti_bandgap *bgp,
 		return status;
 	}
 
-	status = request_irq(gpio_to_irq(gpio_nr), ti_bandgap_tshut_irq_handler,
-			     IRQF_TRIGGER_RISING, "tshut", NULL);
+	status = devm_request_irq(&pdev->dev, gpio_to_irq(gpio_nr),
+				  ti_bandgap_tshut_irq_handler,
+				  IRQF_TRIGGER_RISING, "tshut", NULL);
 	if (status) {
-		gpio_free(gpio_nr);
 		dev_err(bgp->dev, "request irq failed for TSHUT");
+		return status;
 	}
 
 	return 0;
@@ -1104,7 +1105,7 @@ static int ti_bandgap_talert_init(struct ti_bandgap *bgp,
 		dev_err(&pdev->dev, "get_irq failed\n");
 		return bgp->irq;
 	}
-	ret = request_threaded_irq(bgp->irq, NULL,
+	ret = devm_request_threaded_irq(&pdev->dev, bgp->irq, NULL,
 				   ti_bandgap_talert_irq_handler,
 				   IRQF_TRIGGER_HIGH | IRQF_ONESHOT,
 				   "talert", bgp);
@@ -1212,21 +1213,17 @@ int ti_bandgap_probe(struct platform_device *pdev)
 		}
 	}
 
-	bgp->fclock = clk_get(NULL, bgp->conf->fclock_name);
-	ret = IS_ERR(bgp->fclock);
-	if (ret) {
+	bgp->fclock = devm_clk_get(&pdev->dev, NULL, bgp->conf->fclock_name);
+	if (IS_ERR(bgp->fclock)) {
 		dev_err(&pdev->dev, "failed to request fclock reference\n");
-		ret = PTR_ERR(bgp->fclock);
-		goto free_irqs;
+		return PTR_ERR(bgp->fclock);
 	}
 
-	bgp->div_clk = clk_get(NULL,  bgp->conf->div_ck_name);
-	ret = IS_ERR(bgp->div_clk);
-	if (ret) {
+	bgp->div_clk = devm_clk_get(&pdev->dev, NULL,  bgp->conf->div_ck_name);
+	if (IS_ERR(bgp->div_clk)) {
 		dev_err(&pdev->dev,
 			"failed to request div_ts_ck clock ref\n");
-		ret = PTR_ERR(bgp->div_clk);
-		goto free_irqs;
+		return PTR_ERR(bgp->div_clk);
 	}
 
 	for (i = 0; i < bgp->conf->sensor_count; i++) {
@@ -1251,7 +1248,6 @@ int ti_bandgap_probe(struct platform_device *pdev)
 	    clk_rate <= 0) {
 		ret = -ENODEV;
 		dev_err(&pdev->dev, "wrong clock rate (%d)\n", clk_rate);
-		goto put_clks;
 	}
 
 	ret = clk_set_rate(bgp->div_clk, clk_rate);
@@ -1357,14 +1353,6 @@ remove_sensors:
 disable_clk:
 	if (TI_BANDGAP_HAS(bgp, CLK_CTRL))
 		clk_disable_unprepare(bgp->fclock);
-put_clks:
-	clk_put(bgp->fclock);
-	clk_put(bgp->div_clk);
-free_irqs:
-	if (TI_BANDGAP_HAS(bgp, TSHUT)) {
-		free_irq(gpio_to_irq(bgp->tshut_gpio), NULL);
-		gpio_free(bgp->tshut_gpio);
-	}
 
 	return ret;
 }
@@ -1388,16 +1376,6 @@ int ti_bandgap_remove(struct platform_device *pdev)
 
 	if (TI_BANDGAP_HAS(bgp, CLK_CTRL))
 		clk_disable_unprepare(bgp->fclock);
-	clk_put(bgp->fclock);
-	clk_put(bgp->div_clk);
-
-	if (TI_BANDGAP_HAS(bgp, TALERT))
-		free_irq(bgp->irq, bgp);
-
-	if (TI_BANDGAP_HAS(bgp, TSHUT)) {
-		free_irq(gpio_to_irq(bgp->tshut_gpio), NULL);
-		gpio_free(bgp->tshut_gpio);
-	}
 
 	return 0;
 }
-- 
1.7.9.5

