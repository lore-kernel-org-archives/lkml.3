Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756703Ab3HYWpd (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 Aug 2013 18:45:33 -0400
Received: from mail-ee0-f46.google.com ([74.125.83.46]:59556 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756667Ab3HYWpa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 Aug 2013 18:45:30 -0400
From: Zubair Lutfullah <zubair.lutfullah@gmail.com>
To: jic23@cam.ac.uk, lee.jones@linaro.org
Cc: bigeasy@linutronix.de, linux-iio@vger.kernel.org,
        linux-input@vger.kernel.org, linux-kernel@vger.kernel.org,
        gregkh@linuxfoundation.org
Subject: =?UTF-8?q?=5BPATCH=201/2=5D=20input=3A=20ti=5Fam335x=5Ftsc=3A=20Enable=20shared=20IRQ=20for=20TSC?=
Date: Sun, 25 Aug 2013 23:45:23 +0100
Message-Id: <1377470724-15710-2-git-send-email-zubair.lutfullah@gmail.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1377470724-15710-1-git-send-email-zubair.lutfullah@gmail.com>
References: <1377470724-15710-1-git-send-email-zubair.lutfullah@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Enable shared IRQ to allow ADC to share IRQ line from
parent MFD core. Only FIFO0 IRQs are for TSC and handled
on the TSC side.

Step mask would be updated from cached variable only previously.
In rare cases when both TSC and ADC are used, the cached
variable gets mixed up.
The step mask is written with the required mask every time.

Rachna Patil (TI) laid ground work for shared IRQ.

Signed-off-by: Zubair Lutfullah <zubair.lutfullah@gmail.com>
---
 drivers/input/touchscreen/ti_am335x_tsc.c |   24 ++++++++++++++++++------
 1 file changed, 18 insertions(+), 6 deletions(-)

diff --git a/drivers/input/touchscreen/ti_am335x_tsc.c b/drivers/input/touchscreen/ti_am335x_tsc.c
index e1c5300..4124e580 100644
--- a/drivers/input/touchscreen/ti_am335x_tsc.c
+++ b/drivers/input/touchscreen/ti_am335x_tsc.c
@@ -52,6 +52,7 @@ struct titsc {
 	u32			config_inp[4];
 	u32			bit_xp, bit_xn, bit_yp, bit_yn;
 	u32			inp_xp, inp_xn, inp_yp, inp_yn;
+	u32			step_mask;
 };
 
 static unsigned int titsc_readl(struct titsc *ts, unsigned int reg)
@@ -196,7 +197,8 @@ static void titsc_step_config(struct titsc *ts_dev)
 
 	/* The steps1 … end and bit 0 for TS_Charge */
 	stepenable = (1 << (end_step + 2)) - 1;
-	am335x_tsc_se_set(ts_dev->mfd_tscadc, stepenable);
+	ts_dev->step_mask = stepenable;
+	am335x_tsc_se_set(ts_dev->mfd_tscadc, ts_dev->step_mask);
 }
 
 static void titsc_read_coordinates(struct titsc *ts_dev,
@@ -260,6 +262,10 @@ static irqreturn_t titsc_irq(int irq, void *dev)
 	unsigned int fsm;
 
 	status = titsc_readl(ts_dev, REG_IRQSTATUS);
+	/*
+	 * ADC and touchscreen share the IRQ line.
+	 * FIFO1 interrupts are used by ADC. Handle FIFO0 IRQs here only
+	 */
 	if (status & IRQENB_FIFO0THRES) {
 
 		titsc_read_coordinates(ts_dev, &x, &y, &z1, &z2);
@@ -315,11 +321,17 @@ static irqreturn_t titsc_irq(int irq, void *dev)
 	}
 
 	if (irqclr) {
-		titsc_writel(ts_dev, REG_IRQSTATUS, irqclr);
-		am335x_tsc_se_update(ts_dev->mfd_tscadc);
-		return IRQ_HANDLED;
+		titsc_writel(ts_dev, REG_IRQSTATUS, (status | irqclr));
+		am335x_tsc_se_set(ts_dev->mfd_tscadc, ts_dev->step_mask);
 	}
-	return IRQ_NONE;
+
+	/* If any IRQ flags left, return none. So ADC can handle its IRQs */
+	status = titsc_readl(ts_dev, REG_IRQSTATUS);
+	if (status == false)
+		return IRQ_HANDLED;
+	else
+		return IRQ_NONE;
+
 }
 
 static int titsc_parse_dt(struct platform_device *pdev,
@@ -389,7 +401,7 @@ static int titsc_probe(struct platform_device *pdev)
 	}
 
 	err = request_irq(ts_dev->irq, titsc_irq,
-			  0, pdev->dev.driver->name, ts_dev);
+			  IRQF_SHARED, pdev->dev.driver->name, ts_dev);
 	if (err) {
 		dev_err(&pdev->dev, "failed to allocate irq.\n");
 		goto err_free_mem;
-- 
1.7.9.5

