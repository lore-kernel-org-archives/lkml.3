Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755359Ab3LRQxk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Dec 2013 11:53:40 -0500
Received: from www.linutronix.de ([62.245.132.108]:46200 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755089Ab3LRQxX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Dec 2013 11:53:23 -0500
From: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
To: Jonathan Cameron <jic23@kernel.org>
Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Samuel Ortiz <sameo@linux.intel.com>, Lee Jones <lee.jones@linaro.org>,
        Zubair Lutfullah <zubair.lutfullah@gmail.com>,
        Felipe Balbi <balbi@ti.com>, linux-iio@vger.kernel.org,
        linux-input@vger.kernel.org, linux-kernel@vger.kernel.org,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Subject: [PATCH 5/5] mfd: input: iio: ti_amm335x: rework TSC/ADC synchronisation
Date: Wed, 18 Dec 2013 17:52:57 +0100
Message-Id: <1387385577-24447-6-git-send-email-bigeasy@linutronix.de>
X-Mailer: git-send-email 1.8.5.1
In-Reply-To: <1387385577-24447-1-git-send-email-bigeasy@linutronix.de>
References: <1387385577-24447-1-git-send-email-bigeasy@linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001,URIBL_BLOCKED=0.001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The ADC driver always programms all possible ADC values and discards
them except for the value IIO asked for. On the am335x-evm the driver
programs four values and it takes 500us to gather them. Reducing the number
of coversations down to (required) one also reduces the busy loop down to
125us.
This leads to another error, namely the FIFOCOUNT register is sometimes
(like one out of 10 attempts) not updated in time leading to timeouts.
The next read has the fifocount register updated.
Checking for the ADCStatus status register for beeing idle isn't a good
choice either. The problem is that it often times out if the TSC is used
at the same time. The problem is that the HW compelted the conversaton for
the ADC *and* before the driver noticed it, the HW began to perfom a
TSC conversation and so the driver never seen the HW idle. The next time
we would have two values in the fifo but since the driver reads
everything we always see the current one.
So instead of polling for the IDLE bit, we check for the fifocount. It
should be one instead of zero because we request one value.
This change in turn lead to another error :) Sometimes if TSC & ADC are
used together the TSC starts becomming interrupts even if nobody
actually touched the touchscreen. The interrupts are valid because TSC's
fifo is filled with values. This condition stops after a few ADC reads but
will occur once TSC & ADC are used at the same time. So not good.

On top of this (even without the changes I just mentioned) there is a ADC
& TSC lockup condition which was reported to my Jeff Lance including a test
case:
A busyloop of loop of "cat /sys/bus/iio/devices/iio\:device0/in_voltage4_raw"
and a mug on touch screen. Whith this setup, the hardware will lockup after
something between 20min and it could take up to a couple of hours. During that
lockup, the ADCSTAT says 0x30 (or 0x70) which means STEP_ID = IDLE and
FSM_BUSY = yes. That means it says that it is idle and busy at the same
time which is an invalid condition.

For all this reasons I decided to rework this TSC/ADC part and add a
handshake / synchronisation here:
First the ADC signals that it needs the HW and writes a 0 mask into the
SE register. The HW (if active) will complete the current conversation
and become idle. The TSC driver will gather the values from the FIFO
(woken up by an interrupt) and won't "enable" another conversation.
Instead it will wake up the ADC driver which is already waiting. The ADC
driver will start "its" converstation and once it is done, it will
enable the TSC events so the TSC will work again.

After this rework I haven't observed the lockup so far. Plus the busy
loop has been reduced from 500us to 125us.

The continues-read mode remains unchanged.

Signed-off-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
---
 drivers/iio/adc/ti_am335x_adc.c           | 60 +++++++++++++++++++-------
 drivers/input/touchscreen/ti_am335x_tsc.c |  4 +-
 drivers/mfd/ti_am335x_tscadc.c            | 71 +++++++++++++++++++++++++++----
 include/linux/mfd/ti_am335x_tscadc.h      |  5 +++
 4 files changed, 114 insertions(+), 26 deletions(-)

diff --git a/drivers/iio/adc/ti_am335x_adc.c b/drivers/iio/adc/ti_am335x_adc.c
index e737eef..252a2b5 100644
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
 	am335x_tsc_se_adc_set(adc_dev->mfd_tscadc, step_en);
 
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
diff --git a/drivers/input/touchscreen/ti_am335x_tsc.c b/drivers/input/touchscreen/ti_am335x_tsc.c
index 68beada..5d46fff 100644
--- a/drivers/input/touchscreen/ti_am335x_tsc.c
+++ b/drivers/input/touchscreen/ti_am335x_tsc.c
@@ -198,7 +198,7 @@ static void titsc_step_config(struct titsc *ts_dev)
 	/* The steps1 … end and bit 0 for TS_Charge */
 	stepenable = (1 << (end_step + 2)) - 1;
 	ts_dev->step_mask = stepenable;
-	am335x_tsc_se_set(ts_dev->mfd_tscadc, ts_dev->step_mask);
+	am335x_tsc_se_tsc_set(ts_dev->mfd_tscadc, ts_dev->step_mask);
 }
 
 static void titsc_read_coordinates(struct titsc *ts_dev,
@@ -322,7 +322,7 @@ static irqreturn_t titsc_irq(int irq, void *dev)
 
 	if (irqclr) {
 		titsc_writel(ts_dev, REG_IRQSTATUS, irqclr);
-		am335x_tsc_se_set(ts_dev->mfd_tscadc, ts_dev->step_mask);
+		am335x_tsc_se_tsc_set(ts_dev->mfd_tscadc, ts_dev->step_mask);
 		return IRQ_HANDLED;
 	}
 	return IRQ_NONE;
diff --git a/drivers/mfd/ti_am335x_tscadc.c b/drivers/mfd/ti_am335x_tscadc.c
index ad560c6..dd950ec 100644
--- a/drivers/mfd/ti_am335x_tscadc.c
+++ b/drivers/mfd/ti_am335x_tscadc.c
@@ -24,6 +24,7 @@
 #include <linux/pm_runtime.h>
 #include <linux/of.h>
 #include <linux/of_device.h>
+#include <linux/sched.h>
 
 #include <linux/mfd/ti_am335x_tscadc.h>
 
@@ -48,31 +49,83 @@ static const struct regmap_config tscadc_regmap_config = {
 	.val_bits = 32,
 };
 
-static void am335x_tsc_se_update(struct ti_tscadc_dev *tsadc)
+void am335x_tsc_se_set(struct ti_tscadc_dev *tsadc, u32 val)
 {
+	unsigned long flags;
+
+	spin_lock_irqsave(&tsadc->reg_lock, flags);
+	tsadc->reg_se_cache |= val;
 	tscadc_writel(tsadc, REG_SE, tsadc->reg_se_cache);
+	spin_unlock_irqrestore(&tsadc->reg_lock, flags);
 }
+EXPORT_SYMBOL_GPL(am335x_tsc_se_set);
 
-void am335x_tsc_se_set(struct ti_tscadc_dev *tsadc, u32 val)
+void am335x_tsc_se_tsc_set(struct ti_tscadc_dev *tsadc, u32 val)
 {
 	unsigned long flags;
 
 	spin_lock_irqsave(&tsadc->reg_lock, flags);
-	tsadc->reg_se_cache |= val;
-	am335x_tsc_se_update(tsadc);
+	tsadc->reg_se_cache = val;
+	if (tsadc->adc_in_use || tsadc->adc_waiting) {
+		if (tsadc->adc_waiting)
+			wake_up(&tsadc->reg_se_wait);
+	} else {
+		tscadc_writel(tsadc, REG_SE, val);
+	}
 	spin_unlock_irqrestore(&tsadc->reg_lock, flags);
 }
-EXPORT_SYMBOL_GPL(am335x_tsc_se_set);
+EXPORT_SYMBOL_GPL(am335x_tsc_se_tsc_set);
+
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
 
 void am335x_tsc_se_adc_set(struct ti_tscadc_dev *tsadc, u32 val)
 {
+	spin_lock_irq(&tsadc->reg_lock);
+	am335x_tscadc_need_adc(tsadc);
+
+	tscadc_writel(tsadc, REG_SE, val);
+	spin_unlock_irq(&tsadc->reg_lock);
+}
+EXPORT_SYMBOL_GPL(am335x_tsc_se_adc_set);
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
-EXPORT_SYMBOL_GPL(am335x_tsc_se_adc_set);
+EXPORT_SYMBOL_GPL(am335x_tsc_se_adc_done);
 
 void am335x_tsc_se_clr(struct ti_tscadc_dev *tsadc, u32 val)
 {
@@ -80,7 +133,7 @@ void am335x_tsc_se_clr(struct ti_tscadc_dev *tsadc, u32 val)
 
 	spin_lock_irqsave(&tsadc->reg_lock, flags);
 	tsadc->reg_se_cache &= ~val;
-	am335x_tsc_se_update(tsadc);
+	tscadc_writel(tsadc, REG_SE, tsadc->reg_se_cache);
 	spin_unlock_irqrestore(&tsadc->reg_lock, flags);
 }
 EXPORT_SYMBOL_GPL(am335x_tsc_se_clr);
@@ -188,6 +241,8 @@ static	int ti_tscadc_probe(struct platform_device *pdev)
 	}
 
 	spin_lock_init(&tscadc->reg_lock);
+	init_waitqueue_head(&tscadc->reg_se_wait);
+
 	pm_runtime_enable(&pdev->dev);
 	pm_runtime_get_sync(&pdev->dev);
 
diff --git a/include/linux/mfd/ti_am335x_tscadc.h b/include/linux/mfd/ti_am335x_tscadc.h
index be44a66..3cd4f3d3 100644
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
 
@@ -177,7 +180,9 @@ static inline struct ti_tscadc_dev *ti_tscadc_dev_get(struct platform_device *p)
 }
 
 void am335x_tsc_se_set(struct ti_tscadc_dev *tsadc, u32 val);
+void am335x_tsc_se_tsc_set(struct ti_tscadc_dev *tsadc, u32 val);
 void am335x_tsc_se_adc_set(struct ti_tscadc_dev *tsadc, u32 val);
 void am335x_tsc_se_clr(struct ti_tscadc_dev *tsadc, u32 val);
+void am335x_tsc_se_adc_done(struct ti_tscadc_dev *tsadc);
 
 #endif
-- 
1.8.5.1

