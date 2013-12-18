Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755398Ab3LRQxl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Dec 2013 11:53:41 -0500
Received: from www.linutronix.de ([62.245.132.108]:46198 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755061Ab3LRQxW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Dec 2013 11:53:22 -0500
From: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
To: Jonathan Cameron <jic23@kernel.org>
Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Samuel Ortiz <sameo@linux.intel.com>, Lee Jones <lee.jones@linaro.org>,
        Zubair Lutfullah <zubair.lutfullah@gmail.com>,
        Felipe Balbi <balbi@ti.com>, linux-iio@vger.kernel.org,
        linux-input@vger.kernel.org, linux-kernel@vger.kernel.org,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Subject: [PATCH 3/5] mfd: ti_am335x_tscadc: don't read back REG_SE
Date: Wed, 18 Dec 2013 17:52:55 +0100
Message-Id: <1387385577-24447-4-git-send-email-bigeasy@linutronix.de>
X-Mailer: git-send-email 1.8.5.1
In-Reply-To: <1387385577-24447-1-git-send-email-bigeasy@linutronix.de>
References: <1387385577-24447-1-git-send-email-bigeasy@linutronix.de>
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001,URIBL_BLOCKED=0.001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The purpose of reg_se_cache has been defeated. It should avoid the
read-back of the register to avoid the latency and the fact that the
bits are reset to 0 after the individual conversation took place.

The reason why this is required like this to work, is that read-back of
the register removes the bits of the ADC so they do not start another
conversation after the register is re-written from the TSC side for the
update.
To avoid the unrequired read-back I introduce a "set adc" variant which
does not update the cache mask. After the conversation completes, the
register bit is removed from the SE reister anyway and we don't plan a
new conversation "any time soon".
This is a small preparation for a larger sync-rework.

Signed-off-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
---
 drivers/iio/adc/ti_am335x_adc.c      |  2 +-
 drivers/mfd/ti_am335x_tscadc.c       | 12 ++++++++++--
 include/linux/mfd/ti_am335x_tscadc.h |  1 +
 3 files changed, 12 insertions(+), 3 deletions(-)

diff --git a/drivers/iio/adc/ti_am335x_adc.c b/drivers/iio/adc/ti_am335x_adc.c
index e948454..9ad9bd9 100644
--- a/drivers/iio/adc/ti_am335x_adc.c
+++ b/drivers/iio/adc/ti_am335x_adc.c
@@ -335,7 +335,7 @@ static int tiadc_read_raw(struct iio_dev *indio_dev,
 		return -EBUSY;
 
 	step_en = get_adc_step_mask(adc_dev);
-	am335x_tsc_se_set(adc_dev->mfd_tscadc, step_en);
+	am335x_tsc_se_adc_set(adc_dev->mfd_tscadc, step_en);
 
 	/* Wait for ADC sequencer to complete sampling */
 	while (tiadc_readl(adc_dev, REG_ADCFSM) & SEQ_STATUS) {
diff --git a/drivers/mfd/ti_am335x_tscadc.c b/drivers/mfd/ti_am335x_tscadc.c
index 67d0eb4..2948a41 100644
--- a/drivers/mfd/ti_am335x_tscadc.c
+++ b/drivers/mfd/ti_am335x_tscadc.c
@@ -58,19 +58,27 @@ void am335x_tsc_se_set(struct ti_tscadc_dev *tsadc, u32 val)
 	unsigned long flags;
 
 	spin_lock_irqsave(&tsadc->reg_lock, flags);
-	tsadc->reg_se_cache = tscadc_readl(tsadc, REG_SE);
 	tsadc->reg_se_cache |= val;
 	am335x_tsc_se_update(tsadc);
 	spin_unlock_irqrestore(&tsadc->reg_lock, flags);
 }
 EXPORT_SYMBOL_GPL(am335x_tsc_se_set);
 
+void am335x_tsc_se_adc_set(struct ti_tscadc_dev *tsadc, u32 val)
+{
+	unsigned long flags;
+
+	spin_lock_irqsave(&tsadc->reg_lock, flags);
+	tscadc_writel(tsadc, REG_SE, tsadc->reg_se_cache | val);
+	spin_unlock_irqrestore(&tsadc->reg_lock, flags);
+}
+EXPORT_SYMBOL_GPL(am335x_tsc_se_adc_set);
+
 void am335x_tsc_se_clr(struct ti_tscadc_dev *tsadc, u32 val)
 {
 	unsigned long flags;
 
 	spin_lock_irqsave(&tsadc->reg_lock, flags);
-	tsadc->reg_se_cache = tscadc_readl(tsadc, REG_SE);
 	tsadc->reg_se_cache &= ~val;
 	am335x_tsc_se_update(tsadc);
 	spin_unlock_irqrestore(&tsadc->reg_lock, flags);
diff --git a/include/linux/mfd/ti_am335x_tscadc.h b/include/linux/mfd/ti_am335x_tscadc.h
index 1fe7219..be44a66 100644
--- a/include/linux/mfd/ti_am335x_tscadc.h
+++ b/include/linux/mfd/ti_am335x_tscadc.h
@@ -177,6 +177,7 @@ static inline struct ti_tscadc_dev *ti_tscadc_dev_get(struct platform_device *p)
 }
 
 void am335x_tsc_se_set(struct ti_tscadc_dev *tsadc, u32 val);
+void am335x_tsc_se_adc_set(struct ti_tscadc_dev *tsadc, u32 val);
 void am335x_tsc_se_clr(struct ti_tscadc_dev *tsadc, u32 val);
 
 #endif
-- 
1.8.5.1

