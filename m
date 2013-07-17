Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933342Ab3GQR3J (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Jul 2013 13:29:09 -0400
Received: from mail-ea0-f170.google.com ([209.85.215.170]:60848 "EHLO
	mail-ea0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756845Ab3GQR1W (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Jul 2013 13:27:22 -0400
From: Zubair Lutfullah <zubair.lutfullah@gmail.com>
To: jic23@cam.ac.uk
Cc: linux-iio@vger.kernel.org, gregkh@linuxfoundation.org,
        linux-kernel@vger.kernel.org, koen@dominion.thruhere.net,
        zubair.lutfullah@gmail.com
Subject: [PATCH 15/21] IIO: ti_adc: Print error and handle short FIFO events
Date: Wed, 17 Jul 2013 18:26:44 +0100
Message-Id: <1374082010-28095-16-git-send-email-zubair.lutfullah@gmail.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1374082010-28095-1-git-send-email-zubair.lutfullah@gmail.com>
References: <1374082010-28095-1-git-send-email-zubair.lutfullah@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In the case that the FIFO threshold handler gets called when the

FIFO has not actually reached the threshold, the driver will pass

uninitialized memory to the IIO subsystem.

In the past, this would occur due to bugs in the driver, those bugs

have been fixed. However, it is still a good idea to close this just

in case additional bugs in hardware or software exist.

Signed-off-by: Russ Dill <Russ.Dill@ti.com>
Signed-off-by: Zubair Lutfullah <zubair.lutfullah@gmail.com>
---
 drivers/iio/adc/ti_am335x_adc.c |    7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/drivers/iio/adc/ti_am335x_adc.c b/drivers/iio/adc/ti_am335x_adc.c
index 69abde0..c257169 100644
--- a/drivers/iio/adc/ti_am335x_adc.c
+++ b/drivers/iio/adc/ti_am335x_adc.c
@@ -212,6 +212,13 @@ static void tiadc_poll_handler(struct work_struct *work_s)
         u32 *iBuf;
 
         fifo1count = tiadc_readl(adc_dev, REG_FIFO1CNT);
+        if (fifo1count * sizeof(u32) <
+                                buffer->access->get_bytes_per_datum(buffer)) {
+                dev_err(adc_dev->mfd_tscadc->dev, "%s: Short FIFO event\n",
+                                                                __func__);
+                goto out;
+        }
+
         iBuf = kmalloc((fifo1count + 1) * sizeof(u32), GFP_KERNEL);
         if (iBuf == NULL)
                 goto out;
-- 
1.7.9.5

