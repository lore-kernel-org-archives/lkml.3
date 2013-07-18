Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934759Ab3GRWX5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Jul 2013 18:23:57 -0400
Received: from mail-ea0-f172.google.com ([209.85.215.172]:43654 "EHLO
	mail-ea0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934379Ab3GRWVo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Jul 2013 18:21:44 -0400
From: Zubair Lutfullah <zubair.lutfullah@gmail.com>
To: jic23@cam.ac.uk
Cc: gregkh@linuxfoundation.org, linux-iio@vger.kernel.org,
        linux-kernel@vger.kernel.org, koen@dominion.thruhere.net
Subject: [PATCH 07/15] iio: ti_am335x_adc: Handle set to clear IRQSTATUS
Date: Thu, 18 Jul 2013 23:21:18 +0100
Message-Id: <1374186086-5015-8-git-send-email-zubair.lutfullah@gmail.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1374186086-5015-1-git-send-email-zubair.lutfullah@gmail.com>
References: <1374186086-5015-1-git-send-email-zubair.lutfullah@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Russ Dill <Russ.Dill@ti.com>

The driver is currently mishandling the IRQSTATUS register by peforming
a read/update/write cycle. The actual functionality of the register is as follows:

Write 0 = No action.
Read 0 = No (enabled) event pending.
Read 1 = Event pending.
Write 1 = Clear (raw) event.

By reading the status and writing it back, the driver is clearing
all pending events, not just the one indicated in the bitmask.

Signed-off-by: Russ Dill <Russ.Dill@ti.com>
Signed-off-by: Zubair Lutfullah <zubair.lutfullah@gmail.com>
---
 drivers/iio/adc/ti_am335x_adc.c |   11 ++++-------
 1 file changed, 4 insertions(+), 7 deletions(-)

diff --git a/drivers/iio/adc/ti_am335x_adc.c b/drivers/iio/adc/ti_am335x_adc.c
index b566e6a..1c47818 100644
--- a/drivers/iio/adc/ti_am335x_adc.c
+++ b/drivers/iio/adc/ti_am335x_adc.c
@@ -178,7 +178,7 @@ static irqreturn_t tiadc_irq(int irq, void *private)
 			wake_up_interruptible(&adc_dev->wq_data_avail);
 		}
 		tiadc_writel(adc_dev, REG_IRQSTATUS,
-				(status | IRQENB_FIFO1THRES));
+					IRQENB_FIFO1THRES);
 		return IRQ_HANDLED;
 	} else if ((status &  IRQENB_FIFO1OVRRUN) ||
 			(status &  IRQENB_FIFO1UNDRFLW)) {
@@ -186,12 +186,9 @@ static irqreturn_t tiadc_irq(int irq, void *private)
 		config &= ~(CNTRLREG_TSCSSENB);
 		tiadc_writel(adc_dev,  REG_CTRL, config);
 
-		if (status &  IRQENB_FIFO1UNDRFLW)
-			tiadc_writel(adc_dev,  REG_IRQSTATUS,
-			(status |  IRQENB_FIFO1UNDRFLW));
-		else
-			tiadc_writel(adc_dev,  REG_IRQSTATUS,
-				(status |  IRQENB_FIFO1OVRRUN));
+		tiadc_writel(adc_dev, REG_IRQSTATUS,
+				IRQENB_FIFO1OVRRUN |
+				IRQENB_FIFO1UNDRFLW);
 
 		tiadc_writel(adc_dev,  REG_CTRL,
 			(config |  CNTRLREG_TSCSSENB));
-- 
1.7.9.5

