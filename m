Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756829Ab3GQR1T (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Jul 2013 13:27:19 -0400
Received: from mail-ea0-f181.google.com ([209.85.215.181]:51124 "EHLO
	mail-ea0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756780Ab3GQR1L (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Jul 2013 13:27:11 -0400
From: Zubair Lutfullah <zubair.lutfullah@gmail.com>
To: jic23@cam.ac.uk
Cc: linux-iio@vger.kernel.org, gregkh@linuxfoundation.org,
        linux-kernel@vger.kernel.org, koen@dominion.thruhere.net,
        zubair.lutfullah@gmail.com
Subject: [PATCH 09/21] IIO: ti_adc: Handle set to clear IRQSTATUS register properly
Date: Wed, 17 Jul 2013 18:26:38 +0100
Message-Id: <1374082010-28095-10-git-send-email-zubair.lutfullah@gmail.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1374082010-28095-1-git-send-email-zubair.lutfullah@gmail.com>
References: <1374082010-28095-1-git-send-email-zubair.lutfullah@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

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
 drivers/iio/adc/ti_am335x_adc.c |   13 +++++--------
 1 file changed, 5 insertions(+), 8 deletions(-)

diff --git a/drivers/iio/adc/ti_am335x_adc.c b/drivers/iio/adc/ti_am335x_adc.c
index a86830b..5c95eba 100644
--- a/drivers/iio/adc/ti_am335x_adc.c
+++ b/drivers/iio/adc/ti_am335x_adc.c
@@ -182,7 +182,7 @@ static irqreturn_t tiadc_irq(int irq, void *private)
                         wake_up_interruptible(&adc_dev->wq_data_avail);
                 }
                 tiadc_writel(adc_dev, REG_IRQSTATUS,
-                                (status | IRQENB_FIFO1THRES));
+					IRQENB_FIFO1THRES);
                 return IRQ_HANDLED;
         } else if ((status &  IRQENB_FIFO1OVRRUN) ||
                         (status &  IRQENB_FIFO1UNDRFLW)) {
@@ -190,13 +190,10 @@ static irqreturn_t tiadc_irq(int irq, void *private)
                 config &= ~( CNTRLREG_TSCSSENB);
                 tiadc_writel(adc_dev,  REG_CTRL, config);
  
-                if (status &  IRQENB_FIFO1UNDRFLW)
-                        tiadc_writel(adc_dev,  REG_IRQSTATUS,
-                        (status |  IRQENB_FIFO1UNDRFLW));
-                else
-                        tiadc_writel(adc_dev,  REG_IRQSTATUS,
-                                (status |  IRQENB_FIFO1OVRRUN));
- 
+                tiadc_writel(adc_dev, REG_IRQSTATUS,
+                                IRQENB_FIFO1OVRRUN |
+                                IRQENB_FIFO1UNDRFLW);
+
                 tiadc_writel(adc_dev,  REG_CTRL,
                         (config |  CNTRLREG_TSCSSENB));
                 return IRQ_HANDLED;        
-- 
1.7.9.5

