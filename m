Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932730Ab3GQR1Y (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Jul 2013 13:27:24 -0400
Received: from mail-ee0-f50.google.com ([74.125.83.50]:45181 "EHLO
	mail-ee0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756823Ab3GQR1U (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Jul 2013 13:27:20 -0400
From: Zubair Lutfullah <zubair.lutfullah@gmail.com>
To: jic23@cam.ac.uk
Cc: linux-iio@vger.kernel.org, gregkh@linuxfoundation.org,
        linux-kernel@vger.kernel.org, koen@dominion.thruhere.net,
        zubair.lutfullah@gmail.com
Subject: [PATCH 14/21] IIO: ti_adc: Properly handle out of memory situation.
Date: Wed, 17 Jul 2013 18:26:43 +0100
Message-Id: <1374082010-28095-15-git-send-email-zubair.lutfullah@gmail.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1374082010-28095-1-git-send-email-zubair.lutfullah@gmail.com>
References: <1374082010-28095-1-git-send-email-zubair.lutfullah@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If we fail to allocate a buffer, unmask the interrupt to allow a retry.

The interrupt handler will be re-run, and our workqueue rescheduled.

If we are able to allocate memory next time around, everything will

continue as normal, otherwise, we will eventually get an underrun.

Before this patch, the driver would stop capturing without any

indication of error to the IIO subsystem or the user.

Signed-off-by: Russ Dill <Russ.Dill@ti.com>
Signed-off-by: Zubair Lutfullah <zubair.lutfullah@gmail.com>
---
 drivers/iio/adc/ti_am335x_adc.c |    8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff --git a/drivers/iio/adc/ti_am335x_adc.c b/drivers/iio/adc/ti_am335x_adc.c
index eb47385..69abde0 100644
--- a/drivers/iio/adc/ti_am335x_adc.c
+++ b/drivers/iio/adc/ti_am335x_adc.c
@@ -214,7 +214,7 @@ static void tiadc_poll_handler(struct work_struct *work_s)
         fifo1count = tiadc_readl(adc_dev, REG_FIFO1CNT);
         iBuf = kmalloc((fifo1count + 1) * sizeof(u32), GFP_KERNEL);
         if (iBuf == NULL)
-                return;
+                goto out;
         /*
          * Wait for ADC sequencer to settle down.
          * There could be a scenario where in we
@@ -230,12 +230,14 @@ static void tiadc_poll_handler(struct work_struct *work_s)
         }
 
         buffer->access->store_to(buffer, (u8 *) iBuf);
+	kfree(iBuf);
+
+out:	
 	tiadc_writel(adc_dev, REG_IRQSTATUS,
 				IRQENB_FIFO1THRES);
         tiadc_writel(adc_dev, REG_IRQENABLE, 
 				IRQENB_FIFO1THRES);
-
-        kfree(iBuf);
+    
 }
 
 static int tiadc_buffer_preenable(struct iio_dev *idev)
-- 
1.7.9.5

