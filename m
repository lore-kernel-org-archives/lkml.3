Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760641Ab3GZXv0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Jul 2013 19:51:26 -0400
Received: from mail-ea0-f179.google.com ([209.85.215.179]:42455 "EHLO
	mail-ea0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757695Ab3GZXvV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Jul 2013 19:51:21 -0400
From: Zubair Lutfullah <zubair.lutfullah@gmail.com>
To: jic23@cam.ac.uk
Cc: linux-iio@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-input@vger.kernel.org, gregkh@linuxfoundation.org,
        Russ.Dill@ti.com
Subject: [PATCH 1/2] input: ti_tsc: Enable shared IRQ for TSC
Date: Sat, 27 Jul 2013 00:51:13 +0100
Message-Id: <1374882674-18403-2-git-send-email-zubair.lutfullah@gmail.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1374882674-18403-1-git-send-email-zubair.lutfullah@gmail.com>
References: <1374882674-18403-1-git-send-email-zubair.lutfullah@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Patil, Rachna" <rachna@ti.com>

Touchscreen and ADC share the same IRQ line from parent MFD core.
Previously only Touchscreen was interrupt based.
With continuous mode support added in ADC driver, driver requires
interrupt to process the ADC samples, so enable shared IRQ flag bit for
touchscreen.

Signed-off-by: Patil, Rachna <rachna@ti.com>
Acked-by: Vaibhav Hiremath <hvaibhav@ti.com>
Signed-off-by: Zubair Lutfullah <zubair.lutfullah@gmail.com>
Acked-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/input/touchscreen/ti_am335x_tsc.c |   18 ++++++++++++++----
 1 file changed, 14 insertions(+), 4 deletions(-)

diff --git a/drivers/input/touchscreen/ti_am335x_tsc.c b/drivers/input/touchscreen/ti_am335x_tsc.c
index e1c5300..68d1250 100644
--- a/drivers/input/touchscreen/ti_am335x_tsc.c
+++ b/drivers/input/touchscreen/ti_am335x_tsc.c
@@ -260,8 +260,18 @@ static irqreturn_t titsc_irq(int irq, void *dev)
 	unsigned int fsm;
 
 	status = titsc_readl(ts_dev, REG_IRQSTATUS);
-	if (status & IRQENB_FIFO0THRES) {
-
+	/*
+	 * ADC and touchscreen share the IRQ line.
+	 * FIFO1 threshold, FIFO1 Overrun and FIFO1 underflow
+	 * interrupts are used by ADC,
+	 * hence return from touchscreen IRQ handler if FIFO1
+	 * related interrupts occurred.
+	 */
+	if ((status & IRQENB_FIFO1THRES) ||
+			(status & IRQENB_FIFO1OVRRUN) ||
+			(status & IRQENB_FIFO1UNDRFLW))
+		return IRQ_NONE;
+	else if (status & IRQENB_FIFO0THRES) {
 		titsc_read_coordinates(ts_dev, &x, &y, &z1, &z2);
 
 		if (ts_dev->pen_down && z1 != 0 && z2 != 0) {
@@ -315,7 +325,7 @@ static irqreturn_t titsc_irq(int irq, void *dev)
 	}
 
 	if (irqclr) {
-		titsc_writel(ts_dev, REG_IRQSTATUS, irqclr);
+		titsc_writel(ts_dev, REG_IRQSTATUS, (status | irqclr));
 		am335x_tsc_se_update(ts_dev->mfd_tscadc);
 		return IRQ_HANDLED;
 	}
@@ -389,7 +399,7 @@ static int titsc_probe(struct platform_device *pdev)
 	}
 
 	err = request_irq(ts_dev->irq, titsc_irq,
-			  0, pdev->dev.driver->name, ts_dev);
+			  IRQF_SHARED, pdev->dev.driver->name, ts_dev);
 	if (err) {
 		dev_err(&pdev->dev, "failed to allocate irq.\n");
 		goto err_free_mem;
-- 
1.7.9.5

