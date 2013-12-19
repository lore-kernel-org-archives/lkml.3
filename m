Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753646Ab3LSPa4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Dec 2013 10:30:56 -0500
Received: from www.linutronix.de ([62.245.132.108]:53648 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753962Ab3LSP2s (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Dec 2013 10:28:48 -0500
From: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
To: Lee Jones <lee.jones@linaro.org>, Samuel Ortiz <sameo@linux.intel.com>
Cc: Jonathan Cameron <jic23@kernel.org>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Zubair Lutfullah <zubair.lutfullah@gmail.com>,
        Felipe Balbi <balbi@ti.com>, linux-iio@vger.kernel.org,
        linux-input@vger.kernel.org, linux-kernel@vger.kernel.org,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Subject: [PATCH 5/5] mfd: input: iio: ti_amm335x: Rework TSC/ADC synchronization
Date: Thu, 19 Dec 2013 16:28:31 +0100
Message-Id: <1387466911-3732-6-git-send-email-bigeasy@linutronix.de>
X-Mailer: git-send-email 1.8.5.1
In-Reply-To: <1387466911-3732-1-git-send-email-bigeasy@linutronix.de>
References: <1387466911-3732-1-git-send-email-bigeasy@linutronix.de>
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001,URIBL_BLOCKED=0.001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The ADC driver always programs all possible ADC values and discards
them except for the value IIO asked for. On the am335x-evm the driver
programs four values and it takes 500us to gather them. Reducing the number
of conversations down to the (required) one also reduces the busy loop down
to 125us.

This leads to another error, namely the FIFOCOUNT register is sometimes
(like one out of 10 attempts) not updated in time leading to EBUSY.
The next read has the FIFOCOUNT register updated.
Checking for the ADCSTAT register for being idle isn't a good choice either.
The problem is that if TSC is used at the same time, the HW completes the
conversation for ADC *and* before the driver noticed it, the HW begins to
perform a TSC conversation and so the driver never seen the HW idle. The
next time we would have two values in the FIFO but since the driver reads
everything we always see the current one.
So instead of polling for the IDLE bit in ADCStatus register, we should
check the FIFOCOUNT register. It should be one instead of zero because we
request one value.

This change in turn leads to another error. Sometimes if TSC & ADC are
used together the TSC starts becoming interrupts even if nobody
actually touched the touchscreen. The interrupts seem valid because TSC's
FIFO is filled with values for each channel of the TSC. This condition stops
after a few ADC reads but will occur again. Not good.

On top of this (even without the changes I just mentioned) there is a ADC
& TSC lockup condition which was reported to me by Jeff Lance including the
following test case:
A busy loop of "cat /sys/bus/iio/devices/iio\:device0/in_voltage4_raw"
and a mug on touch screen. With this setup, the hardware will lockup after
something between 20 minutes and it could take up to a couple of hours.
During that lockup, the ADCSTAT register says 0x30 (or 0x70) which means
STEP_ID = IDLE and FSM_BUSY = yes. That means the hardware says that it is
idle and busy at the same time which is an invalid condition.

For all this reasons I decided to rework this TSC/ADC part and add a
handshake / synchronization here:
First the ADC signals that it needs the HW and writes a 0 mask into the
SE register. The HW (if active) will complete the current conversation
and become idle. The TSC driver will gather the values from the FIFO
(woken up by an interrupt) and won't "enable" another conversation.
Instead it will wake up the ADC driver which is already waiting. The ADC
driver will start "its" conversation and once it is done, it will
enable the TSC steps so the TSC will work again.

After this rework I haven't observed the lockup so far. Plus the busy
loop has been reduced from 500us to 125us.

The continues-read mode remains unchanged.

Signed-off-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
---
 drivers/iio/adc/ti_am335x_adc.c      | 64 ++++++++++++++++++++++++++----------
 drivers/mfd/ti_am335x_tscadc.c       | 63 +++++++++++++++++++++++++++++------
 include/linux/mfd/ti_am335x_tscadc.h |  4 +++
 3 files changed, 103 insertions(+), 28 deletions(-)

diff --git a/drivers/iio/adc/ti_am335x_adc.c b/drivers/iio/adc/ti_am335x_adc.c
index 6822b9f..31e786e 100644
--- a/drivers/iio/adc/ti_am335x_adc.c
+++ b/drivers/iio/adc/ti_am335x_adc.c
@@ -60,6 +60,24 @@ static u32 get_adc_step_mask(struct tiadc_device *adc_dev)
 	return step_en;
 }
 
+static u32 get_adc_chan_step_mask(struct tiadc_device *adc_dev,
+		struct iio_chan_spec const *chan)
+{
+	int i;
+
+	for (i = 0; i < ARRAY_SIZE(adc_dev->channel_step); i++) {
+		if (chan->channel == adc_dev->channel_line[i]) {
+			u32 step;
+
+			step = adc_dev->channel_step[i];
+			/* +1 for the charger */
+			return 1 << (step + 1);
+		}
+	}
+	WARN_ON(1);
+	return 0;
+}
+
 static u32 get_adc_step_bit(struct tiadc_device *adc_dev, int chan)
 {
 	return 1 << adc_dev->channel_step[chan];
@@ -329,34 +347,43 @@ static int tiadc_read_raw(struct iio_dev *indio_dev,
 	unsigned int fifo1count, read, stepid;
 	bool found = false;
 	u32 step_en;
-	unsigned long timeout = jiffies + usecs_to_jiffies
-				(IDLE_TIMEOUT * adc_dev->channels);
+	unsigned long timeout;
 
 	if (iio_buffer_enabled(indio_dev))
 		return -EBUSY;
 
-	step_en = get_adc_step_mask(adc_dev);
+	step_en = get_adc_chan_step_mask(adc_dev, chan);
+	if (!step_en)
+		return -EINVAL;
+
+	fifo1count = tiadc_readl(adc_dev, REG_FIFO1CNT);
+	while (fifo1count--)
+		tiadc_readl(adc_dev, REG_FIFO1);
+
 	am335x_tsc_se_set_once(adc_dev->mfd_tscadc, step_en);
 
-	/* Wait for ADC sequencer to complete sampling */
-	while (tiadc_readl(adc_dev, REG_ADCFSM) & SEQ_STATUS) {
-		if (time_after(jiffies, timeout))
+	timeout = jiffies + usecs_to_jiffies
+				(IDLE_TIMEOUT * adc_dev->channels);
+	/* Wait for Fifo threshold interrupt */
+	while (1) {
+		fifo1count = tiadc_readl(adc_dev, REG_FIFO1CNT);
+		if (fifo1count)
+			break;
+
+		if (time_after(jiffies, timeout)) {
+			am335x_tsc_se_adc_done(adc_dev->mfd_tscadc);
 			return -EAGAIN;
+		}
 	}
 	map_val = chan->channel + TOTAL_CHANNELS;
 
 	/*
-	 * When the sub-system is first enabled,
-	 * the sequencer will always start with the
-	 * lowest step (1) and continue until step (16).
-	 * For ex: If we have enabled 4 ADC channels and
-	 * currently use only 1 out of them, the
-	 * sequencer still configures all the 4 steps,
-	 * leading to 3 unwanted data.
-	 * Hence we need to flush out this data.
+	 * We check the complete FIFO. We programmed just one entry but in case
+	 * something went wrong we left empty handed (-EAGAIN previously) and
+	 * then the value apeared somehow in the FIFO we would have two entries.
+	 * Therefore we read every item and keep only the latest version of the
+	 * requested channel.
 	 */
-
-	fifo1count = tiadc_readl(adc_dev, REG_FIFO1CNT);
 	for (i = 0; i < fifo1count; i++) {
 		read = tiadc_readl(adc_dev, REG_FIFO1);
 		stepid = read & FIFOREAD_CHNLID_MASK;
@@ -368,6 +395,7 @@ static int tiadc_read_raw(struct iio_dev *indio_dev,
 			*val = (u16) read;
 		}
 	}
+	am335x_tsc_se_adc_done(adc_dev->mfd_tscadc);
 
 	if (found == false)
 		return -EBUSY;
@@ -495,8 +523,8 @@ static int tiadc_resume(struct device *dev)
 	tiadc_writel(adc_dev, REG_CTRL, restore);
 
 	tiadc_step_config(indio_dev);
-	am335x_tsc_se_set(adc_dev->mfd_tscadc, adc_dev->buffer_en_ch_steps);
-
+	am335x_tsc_se_set_cache(adc_dev->mfd_tscadc,
+			adc_dev->buffer_en_ch_steps);
 	return 0;
 }
 
diff --git a/drivers/mfd/ti_am335x_tscadc.c b/drivers/mfd/ti_am335x_tscadc.c
index 157f569..d4e8604 100644
--- a/drivers/mfd/ti_am335x_tscadc.c
+++ b/drivers/mfd/ti_am335x_tscadc.c
@@ -24,6 +24,7 @@
 #include <linux/pm_runtime.h>
 #include <linux/of.h>
 #include <linux/of_device.h>
+#include <linux/sched.h>
 
 #include <linux/mfd/ti_am335x_tscadc.h>
 
@@ -48,31 +49,71 @@ static const struct regmap_config tscadc_regmap_config = {
 	.val_bits = 32,
 };
 
-static void am335x_tsc_se_update(struct ti_tscadc_dev *tsadc)
-{
-	tscadc_writel(tsadc, REG_SE, tsadc->reg_se_cache);
-}
-
 void am335x_tsc_se_set_cache(struct ti_tscadc_dev *tsadc, u32 val)
 {
 	unsigned long flags;
 
 	spin_lock_irqsave(&tsadc->reg_lock, flags);
-	tsadc->reg_se_cache |= val;
-	am335x_tsc_se_update(tsadc);
+	tsadc->reg_se_cache = val;
+	if (tsadc->adc_waiting)
+		wake_up(&tsadc->reg_se_wait);
+	else if (!tsadc->adc_in_use)
+		tscadc_writel(tsadc, REG_SE, val);
+
 	spin_unlock_irqrestore(&tsadc->reg_lock, flags);
 }
 EXPORT_SYMBOL_GPL(am335x_tsc_se_set_cache);
 
+static void am335x_tscadc_need_adc(struct ti_tscadc_dev *tsadc)
+{
+	DEFINE_WAIT(wait);
+	u32 reg;
+
+	/*
+	 * disable TSC steps so it does not run while the ADC is using it. If
+	 * write 0 while it is running (it just started or was already running)
+	 * then it completes all steps that were enabled and stops then.
+	 */
+	tscadc_writel(tsadc, REG_SE, 0);
+	reg = tscadc_readl(tsadc, REG_ADCFSM);
+	if (reg & SEQ_STATUS) {
+		tsadc->adc_waiting = true;
+		prepare_to_wait(&tsadc->reg_se_wait, &wait,
+				TASK_UNINTERRUPTIBLE);
+		spin_unlock_irq(&tsadc->reg_lock);
+
+		schedule();
+
+		spin_lock_irq(&tsadc->reg_lock);
+		finish_wait(&tsadc->reg_se_wait, &wait);
+
+		reg = tscadc_readl(tsadc, REG_ADCFSM);
+		WARN_ON(reg & SEQ_STATUS);
+		tsadc->adc_waiting = false;
+	}
+	tsadc->adc_in_use = true;
+}
+
 void am335x_tsc_se_set_once(struct ti_tscadc_dev *tsadc, u32 val)
 {
+	spin_lock_irq(&tsadc->reg_lock);
+	am335x_tscadc_need_adc(tsadc);
+
+	tscadc_writel(tsadc, REG_SE, val);
+	spin_unlock_irq(&tsadc->reg_lock);
+}
+EXPORT_SYMBOL_GPL(am335x_tsc_se_set_once);
+
+void am335x_tsc_se_adc_done(struct ti_tscadc_dev *tsadc)
+{
 	unsigned long flags;
 
 	spin_lock_irqsave(&tsadc->reg_lock, flags);
-	tscadc_writel(tsadc, REG_SE, tsadc->reg_se_cache | val);
+	tsadc->adc_in_use = false;
+	tscadc_writel(tsadc, REG_SE, tsadc->reg_se_cache);
 	spin_unlock_irqrestore(&tsadc->reg_lock, flags);
 }
-EXPORT_SYMBOL_GPL(am335x_tsc_se_set_once);
+EXPORT_SYMBOL_GPL(am335x_tsc_se_adc_done);
 
 void am335x_tsc_se_clr(struct ti_tscadc_dev *tsadc, u32 val)
 {
@@ -80,7 +121,7 @@ void am335x_tsc_se_clr(struct ti_tscadc_dev *tsadc, u32 val)
 
 	spin_lock_irqsave(&tsadc->reg_lock, flags);
 	tsadc->reg_se_cache &= ~val;
-	am335x_tsc_se_update(tsadc);
+	tscadc_writel(tsadc, REG_SE, tsadc->reg_se_cache);
 	spin_unlock_irqrestore(&tsadc->reg_lock, flags);
 }
 EXPORT_SYMBOL_GPL(am335x_tsc_se_clr);
@@ -188,6 +229,8 @@ static	int ti_tscadc_probe(struct platform_device *pdev)
 	}
 
 	spin_lock_init(&tscadc->reg_lock);
+	init_waitqueue_head(&tscadc->reg_se_wait);
+
 	pm_runtime_enable(&pdev->dev);
 	pm_runtime_get_sync(&pdev->dev);
 
diff --git a/include/linux/mfd/ti_am335x_tscadc.h b/include/linux/mfd/ti_am335x_tscadc.h
index 2fa9c06..fb96c84 100644
--- a/include/linux/mfd/ti_am335x_tscadc.h
+++ b/include/linux/mfd/ti_am335x_tscadc.h
@@ -159,6 +159,9 @@ struct ti_tscadc_dev {
 	int adc_cell;	/* -1 if not used */
 	struct mfd_cell cells[TSCADC_CELLS];
 	u32 reg_se_cache;
+	bool adc_waiting;
+	bool adc_in_use;
+	wait_queue_head_t reg_se_wait;
 	spinlock_t reg_lock;
 	unsigned int clk_div;
 
@@ -179,5 +182,6 @@ static inline struct ti_tscadc_dev *ti_tscadc_dev_get(struct platform_device *p)
 void am335x_tsc_se_set_cache(struct ti_tscadc_dev *tsadc, u32 val);
 void am335x_tsc_se_set_once(struct ti_tscadc_dev *tsadc, u32 val);
 void am335x_tsc_se_clr(struct ti_tscadc_dev *tsadc, u32 val);
+void am335x_tsc_se_adc_done(struct ti_tscadc_dev *tsadc);
 
 #endif
-- 
1.8.5.1

