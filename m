Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756755Ab3GQR1D (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Jul 2013 13:27:03 -0400
Received: from mail-ea0-f169.google.com ([209.85.215.169]:39847 "EHLO
	mail-ea0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755900Ab3GQR05 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Jul 2013 13:26:57 -0400
From: Zubair Lutfullah <zubair.lutfullah@gmail.com>
To: jic23@cam.ac.uk
Cc: linux-iio@vger.kernel.org, gregkh@linuxfoundation.org,
        linux-kernel@vger.kernel.org, koen@dominion.thruhere.net,
        zubair.lutfullah@gmail.com
Subject: [PATCH 01/21] MFD: ti_tscadc: disable TSC control
Date: Wed, 17 Jul 2013 18:26:30 +0100
Message-Id: <1374082010-28095-2-git-send-email-zubair.lutfullah@gmail.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1374082010-28095-1-git-send-email-zubair.lutfullah@gmail.com>
References: <1374082010-28095-1-git-send-email-zubair.lutfullah@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Register bits when TSC not in use

AFE Pen Ctrl and TouchScreen transistors enabling is not

required when only ADC mode is being used, so check for availability of

TSC driver before accessing control register.

This patch is based on work in the 3.2 tree by TI
Original Author is Patil Rachna

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

