Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756749Ab3GQRcI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Jul 2013 13:32:08 -0400
Received: from mail-ea0-f177.google.com ([209.85.215.177]:41897 "EHLO
	mail-ea0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756739Ab3GQR1B (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Jul 2013 13:27:01 -0400
From: Zubair Lutfullah <zubair.lutfullah@gmail.com>
To: jic23@cam.ac.uk
Cc: linux-iio@vger.kernel.org, gregkh@linuxfoundation.org,
        linux-kernel@vger.kernel.org, koen@dominion.thruhere.net,
        zubair.lutfullah@gmail.com
Subject: [PATCH 04/21] input: ti_tsc: Enable shared IRQ for TSC
Date: Wed, 17 Jul 2013 18:26:33 +0100
Message-Id: <1374082010-28095-5-git-send-email-zubair.lutfullah@gmail.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1374082010-28095-1-git-send-email-zubair.lutfullah@gmail.com>
References: <1374082010-28095-1-git-send-email-zubair.lutfullah@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Touchscreen and ADC share the same IRQ line from parent

MFD core.

Previously only Touchscreen was interrupt based.

With continuous mode support added in ADC driver, now driver requires

interrupt to process the ADC samples, so enable shared IRQ flag bit for

touchscreen.

This patch is based on work in the 3.2 tree by TI
Original Author is Patil Rachna

Signed-off-by: Zubair Lutfullah <zubair.lutfullah@gmail.com>
---
 drivers/input/touchscreen/ti_am335x_tsc.c |   16 ++++++++++++----
 1 file changed, 12 insertions(+), 4 deletions(-)

diff --git a/drivers/input/touchscreen/ti_am335x_tsc.c b/drivers/input/touchscreen/ti_am335x_tsc.c
index 0e9f02a..cf56cae 100644
--- a/drivers/input/touchscreen/ti_am335x_tsc.c
+++ b/drivers/input/touchscreen/ti_am335x_tsc.c
@@ -260,8 +260,16 @@ static irqreturn_t titsc_irq(int irq, void *dev)
 	unsigned int fsm;
 
 	status = titsc_readl(ts_dev, REG_IRQSTATUS);
-	if (status & IRQENB_FIFO0THRES) {
-
+ 
+        /*
+         * ADC and touchscreen share the IRQ line.
+         * FIFO1 threshold interrupt is used by ADC,
+         * hence return from touchscreen IRQ handler if FIFO1
+         * threshold interrupt occurred.
+         */
+        if (status & IRQENB_FIFO1THRES)
+                return IRQ_NONE;
+        else if (status & IRQENB_FIFO0THRES) {
 		titsc_read_coordinates(ts_dev, &x, &y, &z1, &z2);
 
 		if (ts_dev->pen_down && z1 != 0 && z2 != 0) {
@@ -315,7 +323,7 @@ static irqreturn_t titsc_irq(int irq, void *dev)
 	}
 
 	if (irqclr) {
-		titsc_writel(ts_dev, REG_IRQSTATUS, irqclr);
+		titsc_writel(ts_dev, REG_IRQSTATUS, (status | irqclr) );
 		am335x_tsc_se_update(ts_dev->mfd_tscadc);
 		return IRQ_HANDLED;
 	}
@@ -389,7 +397,7 @@ static int titsc_probe(struct platform_device *pdev)
 	}
 
 	err = request_irq(ts_dev->irq, titsc_irq,
-			  0, pdev->dev.driver->name, ts_dev);
+			  IRQF_SHARED, pdev->dev.driver->name, ts_dev);
 	if (err) {
 		dev_err(&pdev->dev, "failed to allocate irq.\n");
 		goto err_free_mem;
-- 
1.7.9.5

