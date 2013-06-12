Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932075Ab3FLROq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Jun 2013 13:14:46 -0400
Received: from www.linutronix.de ([62.245.132.108]:44766 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932129Ab3FLROn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Jun 2013 13:14:43 -0400
From: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
To: Samuel Ortiz <sameo@linux.intel.com>
Cc: =?UTF-8?q?Beno=C3=AEt=20Cousson?= <b-cousson@ti.com>,
        Tony Lindgren <tony@atomide.com>, Jonathan Cameron <jic23@cam.ac.uk>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Felipe Balbi <balbi@ti.com>, linux-kernel@vger.kernel.org,
        linux-omap@vger.kernel.org, linux-iio@vger.kernel.org,
        linux-input@vger.kernel.org,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Subject: [PATCH 19/21] input: ti_am335x_tsc: return IRQ_NONE if there was no IRQ for us
Date: Wed, 12 Jun 2013 18:58:20 +0200
Message-Id: <1371056302-12714-20-git-send-email-bigeasy@linutronix.de>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1371056302-12714-1-git-send-email-bigeasy@linutronix.de>
References: <1371056302-12714-1-git-send-email-bigeasy@linutronix.de>
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The previous patch ("input/ti_am335x_tsc: ACK the HW_PEN irq in ISR")
acked the interrupt so we don't freeze if we don't handle an enabled
interrupt source. The interrupt core has a mechanism for this and to get
it work one should only say that it handled an interrupt if it is
actually the case.

Signed-off-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
---
 drivers/input/touchscreen/ti_am335x_tsc.c |   10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)

diff --git a/drivers/input/touchscreen/ti_am335x_tsc.c b/drivers/input/touchscreen/ti_am335x_tsc.c
index 2ba7703..0e9f02a 100644
--- a/drivers/input/touchscreen/ti_am335x_tsc.c
+++ b/drivers/input/touchscreen/ti_am335x_tsc.c
@@ -314,10 +314,12 @@ static irqreturn_t titsc_irq(int irq, void *dev)
 		titsc_writel(ts_dev, REG_IRQCLR, IRQENB_HW_PEN);
 	}
 
-	titsc_writel(ts_dev, REG_IRQSTATUS, irqclr);
-
-	am335x_tsc_se_update(ts_dev->mfd_tscadc);
-	return IRQ_HANDLED;
+	if (irqclr) {
+		titsc_writel(ts_dev, REG_IRQSTATUS, irqclr);
+		am335x_tsc_se_update(ts_dev->mfd_tscadc);
+		return IRQ_HANDLED;
+	}
+	return IRQ_NONE;
 }
 
 static int titsc_parse_dt(struct platform_device *pdev,
-- 
1.7.10.4

