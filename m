Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755462Ab3LRQyj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Dec 2013 11:54:39 -0500
Received: from www.linutronix.de ([62.245.132.108]:46181 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754748Ab3LRQxR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Dec 2013 11:53:17 -0500
From: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
To: Jonathan Cameron <jic23@kernel.org>
Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Samuel Ortiz <sameo@linux.intel.com>, Lee Jones <lee.jones@linaro.org>,
        Zubair Lutfullah <zubair.lutfullah@gmail.com>,
        Felipe Balbi <balbi@ti.com>, linux-iio@vger.kernel.org,
        linux-input@vger.kernel.org, linux-kernel@vger.kernel.org,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Subject: [PATCH 4/5] mfd: ti_am335x: drop am335x_tsc_se_update() from resume path
Date: Wed, 18 Dec 2013 17:52:56 +0100
Message-Id: <1387385577-24447-5-git-send-email-bigeasy@linutronix.de>
X-Mailer: git-send-email 1.8.5.1
In-Reply-To: <1387385577-24447-1-git-send-email-bigeasy@linutronix.de>
References: <1387385577-24447-1-git-send-email-bigeasy@linutronix.de>
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001,URIBL_BLOCKED=0.001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The update of the SE register in MFD doesn't look right as it has
nothing to do with it. The better place to do it is in TSC driver (which
is already doint it) and in the ADC driver which needs this only in the
continues mode.

Signed-off-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
---
 drivers/iio/adc/ti_am335x_adc.c | 2 ++
 drivers/mfd/ti_am335x_tscadc.c  | 1 -
 2 files changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/iio/adc/ti_am335x_adc.c b/drivers/iio/adc/ti_am335x_adc.c
index 9ad9bd9..e737eef 100644
--- a/drivers/iio/adc/ti_am335x_adc.c
+++ b/drivers/iio/adc/ti_am335x_adc.c
@@ -199,6 +199,7 @@ static int tiadc_buffer_predisable(struct iio_dev *indio_dev)
 	tiadc_writel(adc_dev, REG_IRQCLR, (IRQENB_FIFO1THRES |
 				IRQENB_FIFO1OVRRUN | IRQENB_FIFO1UNDRFLW));
 	am335x_tsc_se_clr(adc_dev->mfd_tscadc, adc_dev->buffer_en_ch_steps);
+	adc_dev->buffer_en_ch_steps = 0;
 
 	/* Flush FIFO of leftover data in the time it takes to disable adc */
 	fifo1count = tiadc_readl(adc_dev, REG_FIFO1CNT);
@@ -494,6 +495,7 @@ static int tiadc_resume(struct device *dev)
 	tiadc_writel(adc_dev, REG_CTRL, restore);
 
 	tiadc_step_config(indio_dev);
+	am335x_tsc_se_set(adc_dev->mfd_tscadc, adc_dev->buffer_en_ch_steps);
 
 	return 0;
 }
diff --git a/drivers/mfd/ti_am335x_tscadc.c b/drivers/mfd/ti_am335x_tscadc.c
index 2948a41..ad560c6 100644
--- a/drivers/mfd/ti_am335x_tscadc.c
+++ b/drivers/mfd/ti_am335x_tscadc.c
@@ -309,7 +309,6 @@ static int tscadc_resume(struct device *dev)
 
 	if (tscadc_dev->tsc_cell != -1)
 		tscadc_idle_config(tscadc_dev);
-	am335x_tsc_se_update(tscadc_dev);
 	restore = tscadc_readl(tscadc_dev, REG_CTRL);
 	tscadc_writel(tscadc_dev, REG_CTRL,
 			(restore | CNTRLREG_TSCSSENB));
-- 
1.8.5.1

