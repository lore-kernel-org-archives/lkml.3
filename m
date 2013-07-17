Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756812Ab3GQR1R (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Jul 2013 13:27:17 -0400
Received: from mail-ea0-f176.google.com ([209.85.215.176]:65372 "EHLO
	mail-ea0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756749Ab3GQR1M (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Jul 2013 13:27:12 -0400
From: Zubair Lutfullah <zubair.lutfullah@gmail.com>
To: jic23@cam.ac.uk
Cc: linux-iio@vger.kernel.org, gregkh@linuxfoundation.org,
        linux-kernel@vger.kernel.org, koen@dominion.thruhere.net,
        zubair.lutfullah@gmail.com
Subject: [PATCH 10/21] IIO: ti_adc: Handle overrun before threshold event
Date: Wed, 17 Jul 2013 18:26:39 +0100
Message-Id: <1374082010-28095-11-git-send-email-zubair.lutfullah@gmail.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1374082010-28095-1-git-send-email-zubair.lutfullah@gmail.com>
References: <1374082010-28095-1-git-send-email-zubair.lutfullah@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If an overrun occurs, the threshold event is meaningless, handle

the overrun event first.

Signed-off-by: Russ Dill <Russ.Dill@ti.com>
Signed-off-by: Zubair Lutfullah <zubair.lutfullah@gmail.com>
---
 drivers/iio/adc/ti_am335x_adc.c |   29 ++++++++++++++---------------
 1 file changed, 14 insertions(+), 15 deletions(-)

diff --git a/drivers/iio/adc/ti_am335x_adc.c b/drivers/iio/adc/ti_am335x_adc.c
index 5c95eba..e510da7 100644
--- a/drivers/iio/adc/ti_am335x_adc.c
+++ b/drivers/iio/adc/ti_am335x_adc.c
@@ -171,7 +171,19 @@ static irqreturn_t tiadc_irq(int irq, void *private)
 	unsigned int status, config;
 
         status = tiadc_readl(adc_dev, REG_IRQSTATUS);
-        if (status & IRQENB_FIFO1THRES) {
+        if (status & IRQENB_FIFO1OVRRUN) {
+                config = tiadc_readl(adc_dev, REG_CTRL);
+                config &= ~(CNTRLREG_TSCSSENB);
+                tiadc_writel(adc_dev, REG_CTRL, config);
+
+                tiadc_writel(adc_dev, REG_IRQSTATUS,
+                                IRQENB_FIFO1OVRRUN |
+                                IRQENB_FIFO1UNDRFLW);
+ 
+                tiadc_writel(adc_dev, REG_CTRL,
+                       (config | CNTRLREG_TSCSSENB));
+		return IRQ_HANDLED;
+        } else if (status & IRQENB_FIFO1THRES) {
                 tiadc_writel(adc_dev, REG_IRQCLR,
                                 IRQENB_FIFO1THRES);
 
@@ -183,20 +195,7 @@ static irqreturn_t tiadc_irq(int irq, void *private)
                 }
                 tiadc_writel(adc_dev, REG_IRQSTATUS,
 					IRQENB_FIFO1THRES);
-                return IRQ_HANDLED;
-        } else if ((status &  IRQENB_FIFO1OVRRUN) ||
-                        (status &  IRQENB_FIFO1UNDRFLW)) {
-                config = tiadc_readl(adc_dev,  REG_CTRL);
-                config &= ~( CNTRLREG_TSCSSENB);
-                tiadc_writel(adc_dev,  REG_CTRL, config);
- 
-                tiadc_writel(adc_dev, REG_IRQSTATUS,
-                                IRQENB_FIFO1OVRRUN |
-                                IRQENB_FIFO1UNDRFLW);
-
-                tiadc_writel(adc_dev,  REG_CTRL,
-                        (config |  CNTRLREG_TSCSSENB));
-                return IRQ_HANDLED;        
+                return IRQ_HANDLED;      
 	} else {
                 return IRQ_NONE;
         }
-- 
1.7.9.5

