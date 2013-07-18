Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934633Ab3GRWZm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Jul 2013 18:25:42 -0400
Received: from mail-ee0-f53.google.com ([74.125.83.53]:64092 "EHLO
	mail-ee0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934499Ab3GRWVd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Jul 2013 18:21:33 -0400
From: Zubair Lutfullah <zubair.lutfullah@gmail.com>
To: jic23@cam.ac.uk
Cc: gregkh@linuxfoundation.org, linux-iio@vger.kernel.org,
        linux-kernel@vger.kernel.org, koen@dominion.thruhere.net
Subject: [PATCH 01/15] MFD: ti_tscadc: disable TSC config registers in adc mode
Date: Thu, 18 Jul 2013 23:21:12 +0100
Message-Id: <1374186086-5015-2-git-send-email-zubair.lutfullah@gmail.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1374186086-5015-1-git-send-email-zubair.lutfullah@gmail.com>
References: <1374186086-5015-1-git-send-email-zubair.lutfullah@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Patil, Rachna" <rachna@ti.com>

AFE Pen Ctrl and TouchScreen transistors enabling is not
required when only ADC mode is being used, so check for availability of
TSC driver before accessing control register.

Signed-off-by: Patil, Rachna <rachna@ti.com>
Acked-by: Vaibhav Hiremath <hvaibhav@ti.com>
Signed-off-by: Zubair Lutfullah <zubair.lutfullah@gmail.com>
---
 drivers/mfd/ti_am335x_tscadc.c |   18 +++++++++++-------
 1 file changed, 11 insertions(+), 7 deletions(-)

diff --git a/drivers/mfd/ti_am335x_tscadc.c b/drivers/mfd/ti_am335x_tscadc.c
index b003a16..d72001c 100644
--- a/drivers/mfd/ti_am335x_tscadc.c
+++ b/drivers/mfd/ti_am335x_tscadc.c
@@ -208,13 +208,14 @@ static	int ti_tscadc_probe(struct platform_device *pdev)
 
 	/* Set the control register bits */
 	ctrl = CNTRLREG_STEPCONFIGWRT |
-			CNTRLREG_TSCENB |
-			CNTRLREG_STEPID |
-			CNTRLREG_4WIRE;
+			CNTRLREG_STEPID;
+	if (tsc_wires > 0)
+		ctrl |= CNTRLREG_4WIRE | CNTRLREG_TSCENB;
 	tscadc_writel(tscadc, REG_CTRL, ctrl);
 
 	/* Set register bits for Idle Config Mode */
-	tscadc_idle_config(tscadc);
+	if (tsc_wires > 0)
+		tscadc_idle_config(tscadc);
 
 	/* Enable the TSC module enable bit */
 	ctrl = tscadc_readl(tscadc, REG_CTRL);
@@ -294,10 +295,13 @@ static int tscadc_resume(struct device *dev)
 	pm_runtime_get_sync(dev);
 
 	/* context restore */
-	ctrl = CNTRLREG_STEPCONFIGWRT | CNTRLREG_TSCENB |
-			CNTRLREG_STEPID | CNTRLREG_4WIRE;
+	ctrl = CNTRLREG_STEPCONFIGWRT |	CNTRLREG_STEPID;
+	if (tscadc_dev->tsc_cell != -1)
+		ctrl |= CNTRLREG_TSCENB | CNTRLREG_4WIRE;
 	tscadc_writel(tscadc_dev, REG_CTRL, ctrl);
-	tscadc_idle_config(tscadc_dev);
+
+	if (tscadc_dev->tsc_cell != -1)
+		tscadc_idle_config(tscadc_dev);
 	am335x_tsc_se_update(tscadc_dev);
 	restore = tscadc_readl(tscadc_dev, REG_CTRL);
 	tscadc_writel(tscadc_dev, REG_CTRL,
-- 
1.7.9.5

