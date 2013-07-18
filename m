Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934774Ab3GRWV7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Jul 2013 18:21:59 -0400
Received: from mail-ea0-f173.google.com ([209.85.215.173]:43677 "EHLO
	mail-ea0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934717Ab3GRWV4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Jul 2013 18:21:56 -0400
From: Zubair Lutfullah <zubair.lutfullah@gmail.com>
To: jic23@cam.ac.uk
Cc: gregkh@linuxfoundation.org, linux-iio@vger.kernel.org,
        linux-kernel@vger.kernel.org, koen@dominion.thruhere.net
Subject: [PATCH 14/15] iio: ti_am335x_adc: Reset and clear overrun status before capture
Date: Thu, 18 Jul 2013 23:21:25 +0100
Message-Id: <1374186086-5015-15-git-send-email-zubair.lutfullah@gmail.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1374186086-5015-1-git-send-email-zubair.lutfullah@gmail.com>
References: <1374186086-5015-1-git-send-email-zubair.lutfullah@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Russ Dill <Russ.Dill@ti.com>

While not pulling out samples, the FIFO will fill up causing an
overrun event. Before starting up another continuous sample, clear that
event.

Signed-off-by: Russ Dill <Russ.Dill@ti.com>
Signed-off-by: Zubair Lutfullah <zubair.lutfullah@gmail.com>
---
 drivers/iio/adc/ti_am335x_adc.c |   21 +++++++++++----------
 1 file changed, 11 insertions(+), 10 deletions(-)

diff --git a/drivers/iio/adc/ti_am335x_adc.c b/drivers/iio/adc/ti_am335x_adc.c
index 265ed27..00fdb22 100644
--- a/drivers/iio/adc/ti_am335x_adc.c
+++ b/drivers/iio/adc/ti_am335x_adc.c
@@ -241,22 +241,23 @@ static int tiadc_buffer_postenable(struct iio_dev *idev)
 {
 	struct tiadc_device *adc_dev = iio_priv(idev);
 	struct iio_buffer *buffer = idev->buffer;
-	unsigned int enb, fifo1count;
-	int stepnum, i;
+	unsigned int enb, config;
+	int stepnum;
 	u8 bit;
 
 	if (!adc_dev->is_continuous_mode) {
 		pr_info("Data cannot be read continuously in one shot mode\n");
 		return -EINVAL;
 	} else {
-		tiadc_writel(adc_dev, REG_IRQENABLE,
-				(IRQENB_FIFO1THRES |
-				IRQENB_FIFO1OVRRUN |
-				IRQENB_FIFO1UNDRFLW));
-
-		fifo1count = tiadc_readl(adc_dev, REG_FIFO1CNT);
-		for (i = 0; i < fifo1count; i++)
-			tiadc_readl(adc_dev, REG_FIFO1);
+		config = tiadc_readl(adc_dev, REG_CTRL);
+		tiadc_writel(adc_dev, REG_CTRL,
+					config & ~CNTRLREG_TSCSSENB);
+		tiadc_writel(adc_dev, REG_CTRL,
+					config |  CNTRLREG_TSCSSENB);
+		tiadc_writel(adc_dev,  REG_IRQSTATUS, IRQENB_FIFO1THRES
+				| IRQENB_FIFO1OVRRUN | IRQENB_FIFO1UNDRFLW);
+		tiadc_writel(adc_dev,  REG_IRQENABLE, IRQENB_FIFO1THRES
+				| IRQENB_FIFO1OVRRUN);
 
 		tiadc_writel(adc_dev, REG_SE, 0x00);
 		for_each_set_bit(bit, buffer->scan_mask,
-- 
1.7.9.5

