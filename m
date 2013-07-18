Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934790Ab3GRWWS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Jul 2013 18:22:18 -0400
Received: from mail-ee0-f43.google.com ([74.125.83.43]:55464 "EHLO
	mail-ee0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934600Ab3GRWV6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Jul 2013 18:21:58 -0400
From: Zubair Lutfullah <zubair.lutfullah@gmail.com>
To: jic23@cam.ac.uk
Cc: gregkh@linuxfoundation.org, linux-iio@vger.kernel.org,
        linux-kernel@vger.kernel.org, koen@dominion.thruhere.net
Subject: [PATCH 15/15] iio: ti_am335x_adc: Properly handle out of memory situation.
Date: Thu, 18 Jul 2013 23:21:26 +0100
Message-Id: <1374186086-5015-16-git-send-email-zubair.lutfullah@gmail.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1374186086-5015-1-git-send-email-zubair.lutfullah@gmail.com>
References: <1374186086-5015-1-git-send-email-zubair.lutfullah@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Russ Dill <Russ.Dill@ti.com>

If we fail to allocate a buffer, unmask the interrupt to allow a retry.
The interrupt handler will be re-run, and our workqueue rescheduled.
If we are able to allocate memory next time around, everything will
continue as normal, otherwise, we will eventually get an underrun.
Before this patch, the driver would stop capturing without any
indication of error to the IIO subsystem or the user.

Signed-off-by: Russ Dill <Russ.Dill@ti.com>
Signed-off-by: Zubair Lutfullah <zubair.lutfullah@gmail.com>
---
 drivers/iio/adc/ti_am335x_adc.c |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/iio/adc/ti_am335x_adc.c b/drivers/iio/adc/ti_am335x_adc.c
index 00fdb22..5b0efbe 100644
--- a/drivers/iio/adc/ti_am335x_adc.c
+++ b/drivers/iio/adc/ti_am335x_adc.c
@@ -212,7 +212,7 @@ static void tiadc_poll_handler(struct work_struct *work_s)
 
 	inputbuffer = kmalloc((fifo1count) * sizeof(u32), GFP_KERNEL);
 	if (inputbuffer == NULL)
-		return;
+		goto out;
 
 	for (i = 0; i < fifo1count; i++) {
 		readx1 = tiadc_readl(adc_dev, REG_FIFO1);
@@ -221,12 +221,14 @@ static void tiadc_poll_handler(struct work_struct *work_s)
 	}
 
 	buffer->access->store_to(buffer, (u8 *) inputbuffer);
+	kfree(inputbuffer);
+
+out:
 	tiadc_writel(adc_dev, REG_IRQSTATUS,
 			IRQENB_FIFO1THRES);
 	tiadc_writel(adc_dev, REG_IRQENABLE,
 			IRQENB_FIFO1THRES);
 
-	kfree(inputbuffer);
 }
 
 static int tiadc_buffer_preenable(struct iio_dev *idev)
-- 
1.7.9.5

