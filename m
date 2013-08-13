Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758070Ab3HMQse (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Aug 2013 12:48:34 -0400
Received: from mail-ee0-f42.google.com ([74.125.83.42]:34935 "EHLO
	mail-ee0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757387Ab3HMQsb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Aug 2013 12:48:31 -0400
From: Zubair Lutfullah <zubair.lutfullah@gmail.com>
To: jic23@cam.ac.uk, dmitry.torokhov@gmail.com, sameo@linux.intel.com,
        lee.jones@linaro.org
Cc: linux-iio@vger.kernel.org, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org, bigeasy@linutronix.de,
        gregkh@linuxfoundation.org, Russ.Dill@ti.com
Subject: [PATCH 3/4] input: ti_tsc: Enable shared IRQ for TSC and add overrun, underflow checks
Date: Tue, 13 Aug 2013 17:48:18 +0100
Message-Id: <1376412499-21007-4-git-send-email-zubair.lutfullah@gmail.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1376412499-21007-1-git-send-email-zubair.lutfullah@gmail.com>
References: <1376412499-21007-1-git-send-email-zubair.lutfullah@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Enable shared IRQ to allow ADC to share IRQ line from
parent MFD core. Only FIFO0 IRQs are for TSC and handled
on the TSC side.

Patch also adds overrun and underflow irq handlers.

Russ Dill (TI) worked on overrun and underflow handlers.
Rachna Patil (TI) laid ground work for shared IRQ.

Signed-off-by: Zubair Lutfullah <zubair.lutfullah@gmail.com>
---
 drivers/input/touchscreen/ti_am335x_tsc.c |   37 +++++++++++++++++++++++++----
 include/linux/mfd/ti_am335x_tscadc.h      |    2 ++
 2 files changed, 34 insertions(+), 5 deletions(-)

diff --git a/drivers/input/touchscreen/ti_am335x_tsc.c b/drivers/input/touchscreen/ti_am335x_tsc.c
index 766bc7e..9c114b2 100644
--- a/drivers/input/touchscreen/ti_am335x_tsc.c
+++ b/drivers/input/touchscreen/ti_am335x_tsc.c
@@ -256,14 +256,39 @@ static irqreturn_t titsc_irq(int irq, void *dev)
 {
 	struct titsc *ts_dev = dev;
 	struct input_dev *input_dev = ts_dev->input;
-	unsigned int status, irqclr = 0;
+	unsigned int status, irqclr = 0, config = 0;
 	unsigned int x = 0, y = 0;
 	unsigned int z1, z2, z;
 	unsigned int fsm;
 
 	status = titsc_readl(ts_dev, REG_IRQSTATUS);
-	if (status & IRQENB_FIFO0THRES) {
+	/*
+	 * ADC and touchscreen share the IRQ line.
+	 * FIFO1 threshold, FIFO1 Overrun and FIFO1 underflow
+	 * interrupts are used by ADC. Handle FIFO0 IRQs here only
+	 * and check if any IRQs left in case both fifos interrupt.
+	 * If any irq left, return none, else return handled.
+	 */
+	if ((status & IRQENB_FIFO0OVRRUN) ||
+			(status & IRQENB_FIFO0UNDRFLW)) {
+
+		config = titsc_readl(ts_dev, REG_CTRL);
+		config &= ~(CNTRLREG_TSCSSENB);
+		titsc_writel(ts_dev, REG_CTRL, config);
+
+		if (status & IRQENB_FIFO0UNDRFLW) {
+			titsc_writel(ts_dev, REG_IRQSTATUS,
+				(status | IRQENB_FIFO0UNDRFLW));
+			irqclr |= IRQENB_FIFO0UNDRFLW;
+		} else {
+			titsc_writel(ts_dev, REG_IRQSTATUS,
+				(status | IRQENB_FIFO0OVRRUN));
+			irqclr |= IRQENB_FIFO0OVRRUN;
+		}
 
+		titsc_writel(ts_dev, REG_CTRL,
+			(config | CNTRLREG_TSCSSENB));
+	} else if (status & IRQENB_FIFO0THRES) {
 		titsc_read_coordinates(ts_dev, &x, &y, &z1, &z2);
 
 		if (ts_dev->pen_down && z1 != 0 && z2 != 0) {
@@ -317,9 +342,11 @@ static irqreturn_t titsc_irq(int irq, void *dev)
 	}
 
 	if (irqclr) {
-		titsc_writel(ts_dev, REG_IRQSTATUS, irqclr);
+		titsc_writel(ts_dev, REG_IRQSTATUS, (status | irqclr));
 		am335x_tsc_se_set(ts_dev->mfd_tscadc, ts_dev->step_mask);
-		return IRQ_HANDLED;
+		status = titsc_readl(ts_dev, REG_IRQSTATUS);
+		if (status == false)
+			return IRQ_HANDLED;
 	}
 	return IRQ_NONE;
 }
@@ -391,7 +418,7 @@ static int titsc_probe(struct platform_device *pdev)
 	}
 
 	err = request_irq(ts_dev->irq, titsc_irq,
-			  0, pdev->dev.driver->name, ts_dev);
+			  IRQF_SHARED, pdev->dev.driver->name, ts_dev);
 	if (err) {
 		dev_err(&pdev->dev, "failed to allocate irq.\n");
 		goto err_free_mem;
diff --git a/include/linux/mfd/ti_am335x_tscadc.h b/include/linux/mfd/ti_am335x_tscadc.h
index db1791b..e2db978 100644
--- a/include/linux/mfd/ti_am335x_tscadc.h
+++ b/include/linux/mfd/ti_am335x_tscadc.h
@@ -50,6 +50,8 @@
 /* IRQ enable */
 #define IRQENB_HW_PEN		BIT(0)
 #define IRQENB_FIFO0THRES	BIT(2)
+#define IRQENB_FIFO0OVRRUN	BIT(3)
+#define IRQENB_FIFO0UNDRFLW	BIT(4)
 #define IRQENB_FIFO1THRES	BIT(5)
 #define IRQENB_PENUP		BIT(9)
 
-- 
1.7.9.5

