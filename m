Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756722Ab3HYWps (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 Aug 2013 18:45:48 -0400
Received: from mail-ee0-f54.google.com ([74.125.83.54]:54790 "EHLO
	mail-ee0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756688Ab3HYWpc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 Aug 2013 18:45:32 -0400
From: Zubair Lutfullah <zubair.lutfullah@gmail.com>
To: jic23@cam.ac.uk, lee.jones@linaro.org
Cc: bigeasy@linutronix.de, linux-iio@vger.kernel.org,
        linux-input@vger.kernel.org, linux-kernel@vger.kernel.org,
        gregkh@linuxfoundation.org
Subject: [PATCH 2/2] iio: ti_am335x_adc: Add continuous sampling support
Date: Sun, 25 Aug 2013 23:45:24 +0100
Message-Id: <1377470724-15710-3-git-send-email-zubair.lutfullah@gmail.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1377470724-15710-1-git-send-email-zubair.lutfullah@gmail.com>
References: <1377470724-15710-1-git-send-email-zubair.lutfullah@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Previously the driver had only one-shot reading functionality.
This patch adds triggered buffer support to the driver.

Continuous sampling starts when buffer is enabled.
And samples are pushed to userpace by the trigger which
triggers automatically at every hardware interrupt
of FIFO1 filling with samples upto threshold value.

Userspace responsibility to stop sampling by writing zero
in the buffer enable file.

Patil Rachna (TI) laid the ground work for ADC HW register access.
Russ Dill (TI) fixed bugs in the driver relevant to FIFOs and IRQs.

I fixed channel scanning so multiple ADC channels can be read
simultaneously and pushed to userspace.
Restructured the driver to fit IIO ABI.
And added trigger support.

Signed-off-by: Zubair Lutfullah <zubair.lutfullah@gmail.com>
Acked-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Russ Dill <Russ.Dill@ti.com>
---
 drivers/iio/adc/ti_am335x_adc.c      |  254 +++++++++++++++++++++++++++++++---
 include/linux/mfd/ti_am335x_tscadc.h |   13 ++
 2 files changed, 246 insertions(+), 21 deletions(-)

diff --git a/drivers/iio/adc/ti_am335x_adc.c b/drivers/iio/adc/ti_am335x_adc.c
index a952538..ae2202b 100644
--- a/drivers/iio/adc/ti_am335x_adc.c
+++ b/drivers/iio/adc/ti_am335x_adc.c
@@ -28,12 +28,20 @@
 #include <linux/iio/driver.h>
 
 #include <linux/mfd/ti_am335x_tscadc.h>
+#include <linux/iio/buffer.h>
+#include <linux/iio/trigger.h>
+#include <linux/iio/trigger_consumer.h>
+#include <linux/iio/triggered_buffer.h>
 
 struct tiadc_device {
 	struct ti_tscadc_dev *mfd_tscadc;
 	int channels;
 	u8 channel_line[8];
 	u8 channel_step[8];
+	int irq;
+	int buffer_en_ch_steps;
+	struct iio_trigger *trig;
+	u32 *data;
 };
 
 static unsigned int tiadc_readl(struct tiadc_device *adc, unsigned int reg)
@@ -56,10 +64,11 @@ static u32 get_adc_step_mask(struct tiadc_device *adc_dev)
 	return step_en;
 }
 
-static void tiadc_step_config(struct tiadc_device *adc_dev)
+static void tiadc_step_config(struct iio_dev *indio_dev)
 {
+	struct tiadc_device *adc_dev = iio_priv(indio_dev);
 	unsigned int stepconfig;
-	int i, steps;
+	int i, steps, chan;
 
 	/*
 	 * There are 16 configurable steps and 8 analog input
@@ -72,11 +81,13 @@ static void tiadc_step_config(struct tiadc_device *adc_dev)
 	 */
 
 	steps = TOTAL_STEPS - adc_dev->channels;
-	stepconfig = STEPCONFIG_AVG_16 | STEPCONFIG_FIFO1;
+	if (iio_buffer_enabled(indio_dev))
+		stepconfig = STEPCONFIG_AVG_16 | STEPCONFIG_FIFO1
+					| STEPCONFIG_MODE_SWCNT;
+	else
+		stepconfig = STEPCONFIG_AVG_16 | STEPCONFIG_FIFO1;
 
 	for (i = 0; i < adc_dev->channels; i++) {
-		int chan;
-
 		chan = adc_dev->channel_line[i];
 		tiadc_writel(adc_dev, REG_STEPCONFIG(steps),
 				stepconfig | STEPCONFIG_INP(chan));
@@ -85,7 +96,175 @@ static void tiadc_step_config(struct tiadc_device *adc_dev)
 		adc_dev->channel_step[i] = steps;
 		steps++;
 	}
+}
+
+static irqreturn_t tiadc_irq(int irq, void *private)
+{
+	struct iio_dev *indio_dev = private;
+	struct tiadc_device *adc_dev = iio_priv(indio_dev);
+	unsigned int status, config;
+	status = tiadc_readl(adc_dev, REG_IRQSTATUS);
+
+	/*
+	 * ADC and touchscreen share the IRQ line.
+	 * FIFO0 interrupts are used by TSC. Handle FIFO1 IRQs here only
+	 */
+	if (status & IRQENB_FIFO1OVRRUN) {
+		/* FIFO Overrun. Clear flag. Disable/Enable ADC to recover */
+		config = tiadc_readl(adc_dev, REG_CTRL);
+		config &= ~(CNTRLREG_TSCSSENB);
+		tiadc_writel(adc_dev, REG_CTRL, config);
+		tiadc_writel(adc_dev, REG_IRQSTATUS, IRQENB_FIFO1OVRRUN
+				| IRQENB_FIFO1UNDRFLW | IRQENB_FIFO1THRES);
+		tiadc_writel(adc_dev, REG_CTRL, (config | CNTRLREG_TSCSSENB));
+	} else if (status & IRQENB_FIFO1THRES) {
+		/* Trigger to push FIFO data to iio buffer */
+		tiadc_writel(adc_dev, REG_IRQCLR, IRQENB_FIFO1THRES);
+		iio_trigger_poll(indio_dev->trig, iio_get_time_ns());
+	} else
+		return IRQ_NONE;
+
+	/* If any IRQ flags left, return none. So TSC can handle its IRQs */
+	status = tiadc_readl(adc_dev, REG_IRQSTATUS);
+	if (status == false)
+		return IRQ_HANDLED;
+	else
+		return IRQ_NONE;
+}
+
+static irqreturn_t tiadc_trigger_h(int irq, void *p)
+{
+	struct iio_poll_func *pf = p;
+	struct iio_dev *indio_dev = pf->indio_dev;
+	struct tiadc_device *adc_dev = iio_priv(indio_dev);
+	int i, k, fifo1count, read;
+	u32 *data = adc_dev->data;
+
+	fifo1count = tiadc_readl(adc_dev, REG_FIFO1CNT);
+	for (k = 0; k < fifo1count; k = k + i) {
+		for (i = 0; i < (indio_dev->scan_bytes)/4; i++) {
+			read = tiadc_readl(adc_dev, REG_FIFO1);
+			data[i] = read & FIFOREAD_DATA_MASK;
+		}
+		iio_push_to_buffers(indio_dev, (u8 *) data);
+	}
 
+	tiadc_writel(adc_dev, REG_IRQSTATUS, IRQENB_FIFO1THRES);
+	tiadc_writel(adc_dev, REG_IRQENABLE, IRQENB_FIFO1THRES);
+
+	iio_trigger_notify_done(indio_dev->trig);
+
+	return IRQ_HANDLED;
+}
+
+static int tiadc_buffer_preenable(struct iio_dev *indio_dev)
+{
+	struct tiadc_device *adc_dev = iio_priv(indio_dev);
+	int i, fifo1count, read;
+
+	tiadc_writel(adc_dev, REG_IRQCLR, (IRQENB_FIFO1THRES |
+				IRQENB_FIFO1OVRRUN |
+				IRQENB_FIFO1UNDRFLW));
+
+	/* Flush FIFO before starting sampling */
+	fifo1count = tiadc_readl(adc_dev, REG_FIFO1CNT);
+	for (i = 0; i < fifo1count; i++)
+		read = tiadc_readl(adc_dev, REG_FIFO1);
+
+	return iio_sw_buffer_preenable(indio_dev);
+}
+
+static int tiadc_buffer_postenable(struct iio_dev *indio_dev)
+{
+	struct tiadc_device *adc_dev = iio_priv(indio_dev);
+	struct iio_buffer *buffer = indio_dev->buffer;
+	unsigned int enb = 0, stepnum;
+	u8 bit;
+
+	adc_dev->data = kmalloc(indio_dev->scan_bytes, GFP_KERNEL);
+	if (adc_dev->data == NULL)
+		return -ENOMEM;
+
+	tiadc_step_config(indio_dev);
+	for_each_set_bit(bit, buffer->scan_mask,
+			adc_dev->channels) {
+		struct iio_chan_spec const *chan = indio_dev->channels + bit;
+		/*
+		 * There are a total of 16 steps available
+		 * that are shared between ADC and touchscreen.
+		 * We start configuring from step 16 to 0 incase of
+		 * ADC. Hence the relation between input channel
+		 * and step for ADC would be as below.
+		 */
+		stepnum = chan->channel + 9;
+		enb |= (1 << stepnum);
+	}
+
+	adc_dev->buffer_en_ch_steps = enb;
+	am335x_tsc_se_set(adc_dev->mfd_tscadc, enb);
+	tiadc_writel(adc_dev,  REG_IRQSTATUS, IRQENB_FIFO1THRES
+				| IRQENB_FIFO1OVRRUN | IRQENB_FIFO1UNDRFLW);
+	tiadc_writel(adc_dev,  REG_IRQENABLE, IRQENB_FIFO1THRES
+				| IRQENB_FIFO1OVRRUN);
+
+	return iio_triggered_buffer_postenable(indio_dev);
+}
+
+static int tiadc_buffer_predisable(struct iio_dev *indio_dev)
+{
+	struct tiadc_device *adc_dev = iio_priv(indio_dev);
+	int fifo1count, i, read;
+
+	tiadc_writel(adc_dev, REG_IRQCLR, (IRQENB_FIFO1THRES |
+				IRQENB_FIFO1OVRRUN | IRQENB_FIFO1UNDRFLW));
+	am335x_tsc_se_clr(adc_dev->mfd_tscadc, adc_dev->buffer_en_ch_steps);
+
+	/* Flush FIFO of any leftover data */
+	fifo1count = tiadc_readl(adc_dev, REG_FIFO1CNT);
+	for (i = 0; i < fifo1count; i++)
+		read = tiadc_readl(adc_dev, REG_FIFO1);
+
+	return iio_triggered_buffer_predisable(indio_dev);
+}
+
+static int tiadc_buffer_postdisable(struct iio_dev *indio_dev)
+{
+	struct tiadc_device *adc_dev = iio_priv(indio_dev);
+
+	tiadc_step_config(indio_dev);
+	kfree(adc_dev->data);
+	return 0;
+}
+
+static const struct iio_buffer_setup_ops tiadc_buffer_setup_ops = {
+	.preenable = &tiadc_buffer_preenable,
+	.postenable = &tiadc_buffer_postenable,
+	.predisable = &tiadc_buffer_predisable,
+	.postdisable = &tiadc_buffer_postdisable,
+};
+
+static const struct iio_trigger_ops tiadc_trigger_ops = {
+	.owner = THIS_MODULE,
+};
+
+static struct iio_trigger *tiadc_iio_allocate_trigger(struct iio_dev *indio_dev)
+{
+	struct iio_trigger *trig;
+	int ret;
+
+	trig = iio_trigger_alloc("%s-dev%d", indio_dev->name, indio_dev->id);
+	if (trig == NULL)
+		return NULL;
+
+	trig->dev.parent = indio_dev->dev.parent;
+	trig->ops = &tiadc_trigger_ops;
+	iio_trigger_set_drvdata(trig, indio_dev);
+
+	ret = iio_trigger_register(trig);
+	if (ret)
+		return NULL;
+
+	return trig;
 }
 
 static const char * const chan_name_ain[] = {
@@ -120,6 +299,7 @@ static int tiadc_channel_init(struct iio_dev *indio_dev, int channels)
 		chan->channel = adc_dev->channel_line[i];
 		chan->info_mask_separate = BIT(IIO_CHAN_INFO_RAW);
 		chan->datasheet_name = chan_name_ain[chan->channel];
+		chan->scan_index = i;
 		chan->scan_type.sign = 'u';
 		chan->scan_type.realbits = 12;
 		chan->scan_type.storagebits = 32;
@@ -142,11 +322,14 @@ static int tiadc_read_raw(struct iio_dev *indio_dev,
 	struct tiadc_device *adc_dev = iio_priv(indio_dev);
 	int i, map_val;
 	unsigned int fifo1count, read, stepid;
-	u32 step = UINT_MAX;
 	bool found = false;
 	u32 step_en;
 	unsigned long timeout = jiffies + usecs_to_jiffies
 				(IDLE_TIMEOUT * adc_dev->channels);
+
+	if (iio_buffer_enabled(indio_dev))
+		return -EBUSY;
+
 	step_en = get_adc_step_mask(adc_dev);
 	am335x_tsc_se_set(adc_dev->mfd_tscadc, step_en);
 
@@ -168,15 +351,6 @@ static int tiadc_read_raw(struct iio_dev *indio_dev,
 	 * Hence we need to flush out this data.
 	 */
 
-	for (i = 0; i < ARRAY_SIZE(adc_dev->channel_step); i++) {
-		if (chan->channel == adc_dev->channel_line[i]) {
-			step = adc_dev->channel_step[i];
-			break;
-		}
-	}
-	if (WARN_ON_ONCE(step == UINT_MAX))
-		return -EINVAL;
-
 	fifo1count = tiadc_readl(adc_dev, REG_FIFO1CNT);
 	for (i = 0; i < fifo1count; i++) {
 		read = tiadc_readl(adc_dev, REG_FIFO1);
@@ -220,7 +394,8 @@ static int tiadc_probe(struct platform_device *pdev)
 					  sizeof(struct tiadc_device));
 	if (indio_dev == NULL) {
 		dev_err(&pdev->dev, "failed to allocate iio device\n");
-		return -ENOMEM;
+		err = -ENOMEM;
+		goto err_ret;
 	}
 	adc_dev = iio_priv(indio_dev);
 
@@ -231,28 +406,56 @@ static int tiadc_probe(struct platform_device *pdev)
 		channels++;
 	}
 	adc_dev->channels = channels;
+	adc_dev->irq = adc_dev->mfd_tscadc->irq;
 
 	indio_dev->dev.parent = &pdev->dev;
 	indio_dev->name = dev_name(&pdev->dev);
 	indio_dev->modes = INDIO_DIRECT_MODE;
 	indio_dev->info = &tiadc_info;
 
-	tiadc_step_config(adc_dev);
+	tiadc_step_config(indio_dev);
+	tiadc_writel(adc_dev, REG_FIFO1THR, FIFO1_THRESHOLD);
 
 	err = tiadc_channel_init(indio_dev, adc_dev->channels);
 	if (err < 0)
-		return err;
+		goto err_free_device;
+
+	adc_dev->trig = tiadc_iio_allocate_trigger(indio_dev);
+	if (adc_dev->trig == NULL) {
+		err = -ENOMEM;
+		goto err_free_channels;
+	}
+
+	err = request_irq(adc_dev->irq, tiadc_irq, IRQF_SHARED,
+		indio_dev->name, indio_dev);
+	if (err)
+		goto err_free_trigger;
+
+	err = iio_triggered_buffer_setup(indio_dev, NULL,
+			&tiadc_trigger_h, &tiadc_buffer_setup_ops);
+	if (err)
+		goto err_free_irq;
 
 	err = iio_device_register(indio_dev);
 	if (err)
-		goto err_free_channels;
+		goto err_buffer_unregister;
 
 	platform_set_drvdata(pdev, indio_dev);
 
 	return 0;
 
+err_buffer_unregister:
+	iio_buffer_unregister(indio_dev);
+err_free_irq:
+	free_irq(adc_dev->irq, indio_dev);
+err_free_trigger:
+	iio_trigger_unregister(adc_dev->trig);
+	iio_trigger_free(adc_dev->trig);
 err_free_channels:
 	tiadc_channels_remove(indio_dev);
+err_free_device:
+	iio_device_free(indio_dev);
+err_ret:
 	return err;
 }
 
@@ -262,11 +465,14 @@ static int tiadc_remove(struct platform_device *pdev)
 	struct tiadc_device *adc_dev = iio_priv(indio_dev);
 	u32 step_en;
 
+	free_irq(adc_dev->irq, indio_dev);
 	iio_device_unregister(indio_dev);
+	iio_buffer_unregister(indio_dev);
 	tiadc_channels_remove(indio_dev);
 
 	step_en = get_adc_step_mask(adc_dev);
 	am335x_tsc_se_clr(adc_dev->mfd_tscadc, step_en);
+	iio_device_free(indio_dev);
 
 	return 0;
 }
@@ -298,10 +504,16 @@ static int tiadc_resume(struct device *dev)
 
 	/* Make sure ADC is powered up */
 	restore = tiadc_readl(adc_dev, REG_CTRL);
-	restore &= ~(CNTRLREG_POWERDOWN);
+	restore &= ~(CNTRLREG_TSCSSENB);
 	tiadc_writel(adc_dev, REG_CTRL, restore);
 
-	tiadc_step_config(adc_dev);
+	tiadc_writel(adc_dev, REG_FIFO1THR, FIFO1_THRESHOLD);
+	tiadc_step_config(indio_dev);
+
+	/* Make sure ADC is powered up */
+	restore &= ~(CNTRLREG_POWERDOWN);
+	restore |= CNTRLREG_TSCSSENB;
+	tiadc_writel(adc_dev, REG_CTRL, restore);
 
 	return 0;
 }
diff --git a/include/linux/mfd/ti_am335x_tscadc.h b/include/linux/mfd/ti_am335x_tscadc.h
index db1791b..a372ebf 100644
--- a/include/linux/mfd/ti_am335x_tscadc.h
+++ b/include/linux/mfd/ti_am335x_tscadc.h
@@ -46,17 +46,25 @@
 /* Step Enable */
 #define STEPENB_MASK		(0x1FFFF << 0)
 #define STEPENB(val)		((val) << 0)
+#define ENB(val)			(1 << (val))
+#define STPENB_STEPENB		STEPENB(0x1FFFF)
+#define STPENB_STEPENB_TC	STEPENB(0x1FFF)
 
 /* IRQ enable */
 #define IRQENB_HW_PEN		BIT(0)
 #define IRQENB_FIFO0THRES	BIT(2)
+#define IRQENB_FIFO0OVRRUN	BIT(3)
+#define IRQENB_FIFO0UNDRFLW	BIT(4)
 #define IRQENB_FIFO1THRES	BIT(5)
+#define IRQENB_FIFO1OVRRUN	BIT(6)
+#define IRQENB_FIFO1UNDRFLW	BIT(7)
 #define IRQENB_PENUP		BIT(9)
 
 /* Step Configuration */
 #define STEPCONFIG_MODE_MASK	(3 << 0)
 #define STEPCONFIG_MODE(val)	((val) << 0)
 #define STEPCONFIG_MODE_HWSYNC	STEPCONFIG_MODE(2)
+#define STEPCONFIG_MODE_SWCNT	STEPCONFIG_MODE(1)
 #define STEPCONFIG_AVG_MASK	(7 << 2)
 #define STEPCONFIG_AVG(val)	((val) << 2)
 #define STEPCONFIG_AVG_16	STEPCONFIG_AVG(4)
@@ -124,6 +132,7 @@
 #define	MAX_CLK_DIV		7
 #define TOTAL_STEPS		16
 #define TOTAL_CHANNELS		8
+#define FIFO1_THRESHOLD		19
 
 /*
 * ADC runs at 3MHz, and it takes
@@ -153,6 +162,10 @@ struct ti_tscadc_dev {
 
 	/* adc device */
 	struct adc_device *adc;
+
+	/* Context save */
+	unsigned int irqstat;
+	unsigned int ctrl;
 };
 
 static inline struct ti_tscadc_dev *ti_tscadc_dev_get(struct platform_device *p)
-- 
1.7.9.5

