Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934638Ab3GRWVo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Jul 2013 18:21:44 -0400
Received: from mail-ea0-f175.google.com ([209.85.215.175]:36311 "EHLO
	mail-ea0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934600Ab3GRWVm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Jul 2013 18:21:42 -0400
From: Zubair Lutfullah <zubair.lutfullah@gmail.com>
To: jic23@cam.ac.uk
Cc: gregkh@linuxfoundation.org, linux-iio@vger.kernel.org,
        linux-kernel@vger.kernel.org, koen@dominion.thruhere.net
Subject: [PATCH 06/15] iio: ti_am335x_adc: Handle set to clear IRQENABLE
Date: Thu, 18 Jul 2013 23:21:17 +0100
Message-Id: <1374186086-5015-7-git-send-email-zubair.lutfullah@gmail.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1374186086-5015-1-git-send-email-zubair.lutfullah@gmail.com>
References: <1374186086-5015-1-git-send-email-zubair.lutfullah@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Russ Dill <Russ.Dill@ti.com>

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
index c1b051c..b566e6a 100644
--- a/drivers/iio/adc/ti_am335x_adc.c
+++ b/drivers/iio/adc/ti_am335x_adc.c
@@ -207,7 +207,7 @@ static void tiadc_poll_handler(struct work_struct *work_s)
 		container_of(work_s, struct tiadc_device, poll_work);
 	struct iio_dev *idev = iio_priv_to_dev(adc_dev);
 	struct iio_buffer *buffer = idev->buffer;
-	unsigned int fifo1count, readx1, status;
+	unsigned int fifo1count, readx1;
 	int i;
 	u32 *inputbuffer;
 
@@ -223,9 +223,8 @@ static void tiadc_poll_handler(struct work_struct *work_s)
 	}
 
 	buffer->access->store_to(buffer, (u8 *) inputbuffer);
-	status = tiadc_readl(adc_dev, REG_IRQENABLE);
 	tiadc_writel(adc_dev, REG_IRQENABLE,
-			(status | IRQENB_FIFO1THRES));
+			IRQENB_FIFO1THRES);
 
 	kfree(inputbuffer);
 }
@@ -242,7 +241,7 @@ static int tiadc_buffer_postenable(struct iio_dev *idev)
 {
 	struct tiadc_device *adc_dev = iio_priv(idev);
 	struct iio_buffer *buffer = idev->buffer;
-	unsigned int enb, status, fifo1count;
+	unsigned int enb, fifo1count;
 	int stepnum, i;
 	u8 bit;
 
@@ -250,11 +249,10 @@ static int tiadc_buffer_postenable(struct iio_dev *idev)
 		pr_info("Data cannot be read continuously in one shot mode\n");
 		return -EINVAL;
 	} else {
-		status = tiadc_readl(adc_dev, REG_IRQENABLE);
 		tiadc_writel(adc_dev, REG_IRQENABLE,
-				(status | IRQENB_FIFO1THRES)|
-				 IRQENB_FIFO1OVRRUN |
-				 IRQENB_FIFO1UNDRFLW);
+				(IRQENB_FIFO1THRES |
+				IRQENB_FIFO1OVRRUN |
+				IRQENB_FIFO1UNDRFLW));
 
 		fifo1count = tiadc_readl(adc_dev, REG_FIFO1CNT);
 		for (i = 0; i < fifo1count; i++)
-- 
1.7.9.5

