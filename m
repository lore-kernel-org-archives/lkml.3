Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756849Ab3GQR1V (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Jul 2013 13:27:21 -0400
Received: from mail-ea0-f175.google.com ([209.85.215.175]:35395 "EHLO
	mail-ea0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755889Ab3GQR1O (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Jul 2013 13:27:14 -0400
From: Zubair Lutfullah <zubair.lutfullah@gmail.com>
To: jic23@cam.ac.uk
Cc: linux-iio@vger.kernel.org, gregkh@linuxfoundation.org,
        linux-kernel@vger.kernel.org, koen@dominion.thruhere.net,
        zubair.lutfullah@gmail.com
Subject: [PATCH 11/21] iio: ti_adc: Avoid double threshold event
Date: Wed, 17 Jul 2013 18:26:40 +0100
Message-Id: <1374082010-28095-12-git-send-email-zubair.lutfullah@gmail.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1374082010-28095-1-git-send-email-zubair.lutfullah@gmail.com>
References: <1374082010-28095-1-git-send-email-zubair.lutfullah@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

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
 drivers/iio/adc/ti_am335x_adc.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/iio/adc/ti_am335x_adc.c b/drivers/iio/adc/ti_am335x_adc.c
index e510da7..fcd414d 100644
--- a/drivers/iio/adc/ti_am335x_adc.c
+++ b/drivers/iio/adc/ti_am335x_adc.c
@@ -193,8 +193,7 @@ static irqreturn_t tiadc_irq(int irq, void *private)
                 } else {
                         wake_up_interruptible(&adc_dev->wq_data_avail);
                 }
-                tiadc_writel(adc_dev, REG_IRQSTATUS,
-					IRQENB_FIFO1THRES);
+
                 return IRQ_HANDLED;      
 	} else {
                 return IRQ_NONE;
@@ -230,6 +229,8 @@ static void tiadc_poll_handler(struct work_struct *work_s)
         }
 
         buffer->access->store_to(buffer, (u8 *) iBuf);
+	tiadc_writel(adc_dev, REG_IRQSTATUS,
+				IRQENB_FIFO1THRES);
         tiadc_writel(adc_dev, REG_IRQENABLE, 
 				IRQENB_FIFO1THRES);
 
-- 
1.7.9.5

