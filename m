Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932967Ab3GQR36 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Jul 2013 13:29:58 -0400
Received: from mail-ee0-f42.google.com ([74.125.83.42]:39136 "EHLO
	mail-ee0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756749Ab3GQR1S (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Jul 2013 13:27:18 -0400
From: Zubair Lutfullah <zubair.lutfullah@gmail.com>
To: jic23@cam.ac.uk
Cc: linux-iio@vger.kernel.org, gregkh@linuxfoundation.org,
        linux-kernel@vger.kernel.org, koen@dominion.thruhere.net,
        zubair.lutfullah@gmail.com
Subject: [PATCH 13/21] IO: ti_adc: Reset and clear overrun status before capture.
Date: Wed, 17 Jul 2013 18:26:42 +0100
Message-Id: <1374082010-28095-14-git-send-email-zubair.lutfullah@gmail.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1374082010-28095-1-git-send-email-zubair.lutfullah@gmail.com>
References: <1374082010-28095-1-git-send-email-zubair.lutfullah@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

While not pulling out samples, the FIFO will fill up causing an

overrun event. Before starting up another continuous sample, clear that

event.

Signed-off-by: Russ Dill <Russ.Dill@ti.com>
Signed-off-by: Zubair Lutfullah <zubair.lutfullah@gmail.com>
---
 drivers/iio/adc/ti_am335x_adc.c |   24 +++++++++++++++---------
 1 file changed, 15 insertions(+), 9 deletions(-)

diff --git a/drivers/iio/adc/ti_am335x_adc.c b/drivers/iio/adc/ti_am335x_adc.c
index 1e48799..eb47385 100644
--- a/drivers/iio/adc/ti_am335x_adc.c
+++ b/drivers/iio/adc/ti_am335x_adc.c
@@ -250,22 +250,28 @@ static int tiadc_buffer_postenable(struct iio_dev *idev)
 {
         struct tiadc_device *adc_dev = iio_priv(idev);
         struct iio_buffer *buffer = idev->buffer;
-        unsigned int enb, fifo1count;
-        int stepnum, i;
+        unsigned int enb, config;
+        int stepnum;
         u8 bit;
 
         if (!adc_dev->is_continuous_mode) {
                 printk("Data cannot be read continuously in one shot mode\n");
                 return -EINVAL;
         } else {
-                tiadc_writel(adc_dev, REG_IRQENABLE,
-                                (IRQENB_FIFO1THRES |
-                                 IRQENB_FIFO1OVRRUN |
-                                 IRQENB_FIFO1UNDRFLW));
 
-                fifo1count = tiadc_readl(adc_dev, REG_FIFO1CNT);
-                for (i = 0; i < fifo1count; i++)
-                        tiadc_readl(adc_dev, REG_FIFO1);
+                config = tiadc_readl(adc_dev, REG_CTRL);
+                tiadc_writel(adc_dev, REG_CTRL,
+                                        config & ~CNTRLREG_TSCSSENB);
+                tiadc_writel(adc_dev, REG_CTRL,
+                                        config |  CNTRLREG_TSCSSENB);
+
+                tiadc_writel(adc_dev,  REG_IRQSTATUS,
+                                 IRQENB_FIFO1THRES |
+                                 IRQENB_FIFO1OVRRUN |
+                                 IRQENB_FIFO1UNDRFLW);
+                tiadc_writel(adc_dev,  REG_IRQENABLE,
+                                 IRQENB_FIFO1THRES |
+                                 IRQENB_FIFO1OVRRUN);
 
                 tiadc_writel(adc_dev, REG_SE, 0x00);
                 for_each_set_bit(bit, buffer->scan_mask,
-- 
1.7.9.5

