Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934779Ab3GRWXg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Jul 2013 18:23:36 -0400
Received: from mail-ee0-f51.google.com ([74.125.83.51]:37000 "EHLO
	mail-ee0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934640Ab3GRWVr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Jul 2013 18:21:47 -0400
From: Zubair Lutfullah <zubair.lutfullah@gmail.com>
To: jic23@cam.ac.uk
Cc: gregkh@linuxfoundation.org, linux-iio@vger.kernel.org,
        linux-kernel@vger.kernel.org, koen@dominion.thruhere.net
Subject: [PATCH 09/15] iio: ti_am335x_adc: Avoid double threshold event
Date: Thu, 18 Jul 2013 23:21:20 +0100
Message-Id: <1374186086-5015-10-git-send-email-zubair.lutfullah@gmail.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1374186086-5015-1-git-send-email-zubair.lutfullah@gmail.com>
References: <1374186086-5015-1-git-send-email-zubair.lutfullah@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Russ Dill <Russ.Dill@ti.com>

The threshold event handler is being called before the FIFO has
actually reached the threshold.
The current code receives a FIFO threshold event, masks the interrupt,
clears the event, and schedules a workqueue. The workqueue is run, it
empties the FIFO, and unmasks the interrupt.
In the above sequence, after the event is cleared, it immediately
retriggers since the FIFO remains beyond the threshold. When the IRQ is
unmasked, this triggered event generates another IRQ. However, as the
FIFO has just been emptied, it is likely to not contain enough samples.
The waits to clear the event until the FIFO has actually been emptied,
in the workqueue. The unmasking and masking of the interrupt remains
unchanged.

Signed-off-by: Russ Dill <Russ.Dill@ti.com>
Signed-off-by: Zubair Lutfullah <zubair.lutfullah@gmail.com>
---
 drivers/iio/adc/ti_am335x_adc.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/iio/adc/ti_am335x_adc.c b/drivers/iio/adc/ti_am335x_adc.c
index 7ac28a9..8dc070d 100644
--- a/drivers/iio/adc/ti_am335x_adc.c
+++ b/drivers/iio/adc/ti_am335x_adc.c
@@ -183,11 +183,9 @@ static irqreturn_t tiadc_irq(int irq, void *private)
 		if (iio_buffer_enabled(idev)) {
 			if (!work_pending(&adc_dev->poll_work))
 				schedule_work(&adc_dev->poll_work);
-		} else {
+		} else
 			wake_up_interruptible(&adc_dev->wq_data_avail);
-		}
-		tiadc_writel(adc_dev, REG_IRQSTATUS,
-					IRQENB_FIFO1THRES);
+
 		return IRQ_HANDLED;
 	} else {
 		return IRQ_NONE;
@@ -216,6 +214,8 @@ static void tiadc_poll_handler(struct work_struct *work_s)
 	}
 
 	buffer->access->store_to(buffer, (u8 *) inputbuffer);
+	tiadc_writel(adc_dev, REG_IRQSTATUS,
+			IRQENB_FIFO1THRES);
 	tiadc_writel(adc_dev, REG_IRQENABLE,
 			IRQENB_FIFO1THRES);
 
-- 
1.7.9.5

