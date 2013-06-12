Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757759Ab3FLRMr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Jun 2013 13:12:47 -0400
Received: from www.linutronix.de ([62.245.132.108]:44718 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932066Ab3FLRMp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Jun 2013 13:12:45 -0400
From: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
To: Samuel Ortiz <sameo@linux.intel.com>
Cc: =?UTF-8?q?Beno=C3=AEt=20Cousson?= <b-cousson@ti.com>,
        Tony Lindgren <tony@atomide.com>, Jonathan Cameron <jic23@cam.ac.uk>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Felipe Balbi <balbi@ti.com>, linux-kernel@vger.kernel.org,
        linux-omap@vger.kernel.org, linux-iio@vger.kernel.org,
        linux-input@vger.kernel.org,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Subject: [PATCH 18/21] input: ti_am335x_tsc: ACK the HW_PEN irq in ISR
Date: Wed, 12 Jun 2013 18:58:19 +0200
Message-Id: <1371056302-12714-19-git-send-email-bigeasy@linutronix.de>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1371056302-12714-1-git-send-email-bigeasy@linutronix.de>
References: <1371056302-12714-1-git-send-email-bigeasy@linutronix.de>
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The interrupt source IRQENB_HW_PEN is enabled in suspend and suposed to
be used as a wake up source. Once this interrupt source is unmaksed, the
devices ends up in ISR and never continues.
This change ACKs the interrupt and disables it so the system does not
freeze.

Signed-off-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
---
 drivers/input/touchscreen/ti_am335x_tsc.c |    6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/drivers/input/touchscreen/ti_am335x_tsc.c b/drivers/input/touchscreen/ti_am335x_tsc.c
index 1bceb25..2ba7703 100644
--- a/drivers/input/touchscreen/ti_am335x_tsc.c
+++ b/drivers/input/touchscreen/ti_am335x_tsc.c
@@ -308,6 +308,12 @@ static irqreturn_t titsc_irq(int irq, void *dev)
 		irqclr |= IRQENB_PENUP;
 	}
 
+	if (status & IRQENB_HW_PEN) {
+
+		titsc_writel(ts_dev, REG_IRQWAKEUP, 0x00);
+		titsc_writel(ts_dev, REG_IRQCLR, IRQENB_HW_PEN);
+	}
+
 	titsc_writel(ts_dev, REG_IRQSTATUS, irqclr);
 
 	am335x_tsc_se_update(ts_dev->mfd_tscadc);
-- 
1.7.10.4

