Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933290Ab3GQRa5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Jul 2013 13:30:57 -0400
Received: from mail-ee0-f51.google.com ([74.125.83.51]:39220 "EHLO
	mail-ee0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756772Ab3GQR1J (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Jul 2013 13:27:09 -0400
From: Zubair Lutfullah <zubair.lutfullah@gmail.com>
To: jic23@cam.ac.uk
Cc: linux-iio@vger.kernel.org, gregkh@linuxfoundation.org,
        linux-kernel@vger.kernel.org, koen@dominion.thruhere.net,
        zubair.lutfullah@gmail.com
Subject: [PATCH 08/21] IIO: ti_adc: Handle set to clear IRQENABLE register properly.
Date: Wed, 17 Jul 2013 18:26:37 +0100
Message-Id: <1374082010-28095-9-git-send-email-zubair.lutfullah@gmail.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1374082010-28095-1-git-send-email-zubair.lutfullah@gmail.com>
References: <1374082010-28095-1-git-send-email-zubair.lutfullah@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The driver is currently mishandling the IRQENABLE register. The driver

should write a 1 for bits it wishes to set, and a zero for bits it does not

wish to change. The read of the current register contents is not

necessary.

Write 0 = No action.

Read 0 = Interrupt disabled (masked).

Read 1 = Interrupt enabled.

Write 1 = Enable interrupt.

The current read/update/write method is currently not causing any

problems, but could cause confusion in the future.

Signed-off-by: Russ Dill <Russ.Dill@ti.com>
Signed-off-by: Zubair Lutfullah <zubair.lutfullah@gmail.com>
---
 drivers/iio/adc/ti_am335x_adc.c |   14 ++++++--------
 1 file changed, 6 insertions(+), 8 deletions(-)

diff --git a/drivers/iio/adc/ti_am335x_adc.c b/drivers/iio/adc/ti_am335x_adc.c
index 31665fa..a86830b 100644
--- a/drivers/iio/adc/ti_am335x_adc.c
+++ b/drivers/iio/adc/ti_am335x_adc.c
@@ -211,7 +211,7 @@ static void tiadc_poll_handler(struct work_struct *work_s)
                 container_of(work_s, struct tiadc_device, poll_work);
         struct iio_dev *idev = iio_priv_to_dev(adc_dev);
         struct iio_buffer *buffer = idev->buffer;
-        unsigned int fifo1count, readx1, status;
+        unsigned int fifo1count, readx1;
         int i;
         u32 *iBuf;
 
@@ -234,9 +234,8 @@ static void tiadc_poll_handler(struct work_struct *work_s)
         }
 
         buffer->access->store_to(buffer, (u8 *) iBuf);
-        status = tiadc_readl(adc_dev, REG_IRQENABLE);
-        tiadc_writel(adc_dev, REG_IRQENABLE,
-                        (status | IRQENB_FIFO1THRES));
+        tiadc_writel(adc_dev, REG_IRQENABLE, 
+				IRQENB_FIFO1THRES);
 
         kfree(iBuf);
 }
@@ -253,7 +252,7 @@ static int tiadc_buffer_postenable(struct iio_dev *idev)
 {
         struct tiadc_device *adc_dev = iio_priv(idev);
         struct iio_buffer *buffer = idev->buffer;
-        unsigned int enb, status, fifo1count;
+        unsigned int enb, fifo1count;
         int stepnum, i;
         u8 bit;
 
@@ -261,11 +260,10 @@ static int tiadc_buffer_postenable(struct iio_dev *idev)
                 printk("Data cannot be read continuously in one shot mode\n");
                 return -EINVAL;
         } else {
-                status = tiadc_readl(adc_dev, REG_IRQENABLE);
                 tiadc_writel(adc_dev, REG_IRQENABLE,
-                                (status | IRQENB_FIFO1THRES)|
+                                (IRQENB_FIFO1THRES |
                                  IRQENB_FIFO1OVRRUN |
-                                 IRQENB_FIFO1UNDRFLW);
+                                 IRQENB_FIFO1UNDRFLW));
 
                 fifo1count = tiadc_readl(adc_dev, REG_FIFO1CNT);
                 for (i = 0; i < fifo1count; i++)
-- 
1.7.9.5

