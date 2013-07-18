Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934714Ab3GRWVx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Jul 2013 18:21:53 -0400
Received: from mail-ee0-f48.google.com ([74.125.83.48]:46761 "EHLO
	mail-ee0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934600Ab3GRWVu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Jul 2013 18:21:50 -0400
From: Zubair Lutfullah <zubair.lutfullah@gmail.com>
To: jic23@cam.ac.uk
Cc: gregkh@linuxfoundation.org, linux-iio@vger.kernel.org,
        linux-kernel@vger.kernel.org, koen@dominion.thruhere.net
Subject: [PATCH 11/15] iio: ti_am335x_adc: Print error and handle short FIFO events
Date: Thu, 18 Jul 2013 23:21:22 +0100
Message-Id: <1374186086-5015-12-git-send-email-zubair.lutfullah@gmail.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1374186086-5015-1-git-send-email-zubair.lutfullah@gmail.com>
References: <1374186086-5015-1-git-send-email-zubair.lutfullah@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Russ Dill <Russ.Dill@ti.com>

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
index 6957011..1b0af2a 100644
--- a/drivers/iio/adc/ti_am335x_adc.c
+++ b/drivers/iio/adc/ti_am335x_adc.c
@@ -203,6 +203,13 @@ static void tiadc_poll_handler(struct work_struct *work_s)
 	u32 *inputbuffer;
 
 	fifo1count = tiadc_readl(adc_dev, REG_FIFO1CNT);
+	if (fifo1count * sizeof(u32) <
+				buffer->access->get_bytes_per_datum(buffer)) {
+		dev_err(adc_dev->mfd_tscadc->dev, "%s: Short FIFO event\n",
+								__func__);
+		goto out;
+	}
+
 	inputbuffer = kmalloc((fifo1count + 1) * sizeof(u32), GFP_KERNEL);
 	if (inputbuffer == NULL)
 		return;
-- 
1.7.9.5

