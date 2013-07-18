Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934737Ab3GRWYt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Jul 2013 18:24:49 -0400
Received: from mail-ee0-f51.google.com ([74.125.83.51]:46370 "EHLO
	mail-ee0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932931Ab3GRWVg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Jul 2013 18:21:36 -0400
From: Zubair Lutfullah <zubair.lutfullah@gmail.com>
To: jic23@cam.ac.uk
Cc: gregkh@linuxfoundation.org, linux-iio@vger.kernel.org,
        linux-kernel@vger.kernel.org, koen@dominion.thruhere.net
Subject: [PATCH 03/15] input: ti_tsc: Enable shared IRQ for TSC
Date: Thu, 18 Jul 2013 23:21:14 +0100
Message-Id: <1374186086-5015-4-git-send-email-zubair.lutfullah@gmail.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1374186086-5015-1-git-send-email-zubair.lutfullah@gmail.com>
References: <1374186086-5015-1-git-send-email-zubair.lutfullah@gmail.com>
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
---
 drivers/input/touchscreen/ti_am335x_tsc.c |   14 +++++++++++---
 1 file changed, 11 insertions(+), 3 deletions(-)

diff --git a/drivers/input/touchscreen/ti_am335x_tsc.c b/drivers/input/touchscreen/ti_am335x_tsc.c
index 0e9f02a..edc3d03 100644
--- a/drivers/input/touchscreen/ti_am335x_tsc.c
+++ b/drivers/input/touchscreen/ti_am335x_tsc.c
@@ -260,8 +260,16 @@ static irqreturn_t titsc_irq(int irq, void *dev)
 	unsigned int fsm;
 
 	status = titsc_readl(ts_dev, REG_IRQSTATUS);
-	if (status & IRQENB_FIFO0THRES) {
 
+	/*
+	* ADC and touchscreen share the IRQ line.
+	* FIFO1 threshold interrupt is used by ADC,
+	* hence return from touchscreen IRQ handler if FIFO1
+	* threshold interrupt occurred.
+	*/
+	if (status & IRQENB_FIFO1THRES)
+		return IRQ_NONE;
+	else if (status & IRQENB_FIFO0THRES) {
 		titsc_read_coordinates(ts_dev, &x, &y, &z1, &z2);
 
 		if (ts_dev->pen_down && z1 != 0 && z2 != 0) {
@@ -315,7 +323,7 @@ static irqreturn_t titsc_irq(int irq, void *dev)
 	}
 
 	if (irqclr) {
-		titsc_writel(ts_dev, REG_IRQSTATUS, irqclr);
+		titsc_writel(ts_dev, REG_IRQSTATUS, (status | irqclr));
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

