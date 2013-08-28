Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753607Ab3H1NB2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Aug 2013 09:01:28 -0400
Received: from www.linutronix.de ([62.245.132.108]:43844 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752124Ab3H1NB1 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Aug 2013 09:01:27 -0400
Date: Wed, 28 Aug 2013 15:01:24 +0200
From: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
To: Zubair Lutfullah <zubair.lutfullah@gmail.com>
Cc: jic23@cam.ac.uk, lee.jones@linaro.org, linux-iio@vger.kernel.org,
        linux-input@vger.kernel.org, linux-kernel@vger.kernel.org,
        gregkh@linuxfoundation.org
Subject: Re: [PATCH 2/2] iio: ti_am335x_adc: Add continuous sampling support
Message-ID: <20130828130124.GC14111@linutronix.de>
References: <1377470724-15710-1-git-send-email-zubair.lutfullah@gmail.com>
 <1377470724-15710-3-git-send-email-zubair.lutfullah@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8BIT
In-Reply-To: <1377470724-15710-3-git-send-email-zubair.lutfullah@gmail.com>
X-Key-Id: 97C4700B
X-Key-Fingerprint: 09E2 D1F3 9A3A FF13 C3D3  961C 0688 1C1E 97C4 700B
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Zubair Lutfullah | 2013-08-25 23:45:24 [+0100]:

I am mostly happy with it. There are just two things I pointed out.
Besides that, it looks good from my side.

>diff --git a/drivers/iio/adc/ti_am335x_adc.c b/drivers/iio/adc/ti_am335x_adc.c
>index a952538..ae2202b 100644
>--- a/drivers/iio/adc/ti_am335x_adc.c
>+++ b/drivers/iio/adc/ti_am335x_adc.c
>@@ -85,7 +96,175 @@ static void tiadc_step_config(struct tiadc_device *adc_dev)
> 		adc_dev->channel_step[i] = steps;
> 		steps++;
> 	}
>+}
>+
>+static irqreturn_t tiadc_irq(int irq, void *private)
>+{
>+	struct iio_dev *indio_dev = private;
>+	struct tiadc_device *adc_dev = iio_priv(indio_dev);
>+	unsigned int status, config;
>+	status = tiadc_readl(adc_dev, REG_IRQSTATUS);
>+
>+	/*
>+	 * ADC and touchscreen share the IRQ line.
>+	 * FIFO0 interrupts are used by TSC. Handle FIFO1 IRQs here only
>+	 */
>+	if (status & IRQENB_FIFO1OVRRUN) {
>+		/* FIFO Overrun. Clear flag. Disable/Enable ADC to recover */
>+		config = tiadc_readl(adc_dev, REG_CTRL);
>+		config &= ~(CNTRLREG_TSCSSENB);
>+		tiadc_writel(adc_dev, REG_CTRL, config);
>+		tiadc_writel(adc_dev, REG_IRQSTATUS, IRQENB_FIFO1OVRRUN
>+				| IRQENB_FIFO1UNDRFLW | IRQENB_FIFO1THRES);
>+		tiadc_writel(adc_dev, REG_CTRL, (config | CNTRLREG_TSCSSENB));
>+	} else if (status & IRQENB_FIFO1THRES) {
>+		/* Trigger to push FIFO data to iio buffer */
>+		tiadc_writel(adc_dev, REG_IRQCLR, IRQENB_FIFO1THRES);
>+		iio_trigger_poll(indio_dev->trig, iio_get_time_ns());
>+	} else
>+		return IRQ_NONE;
>+
>+	/* If any IRQ flags left, return none. So TSC can handle its IRQs */
>+	status = tiadc_readl(adc_dev, REG_IRQSTATUS);
>+	if (status == false)
>+		return IRQ_HANDLED;
>+	else
>+		return IRQ_NONE;

As I said in 1/2 of this series, you shouldn't do this. Both handlers of a
shared line are invoked once an interrupt is detected.

…

>+static int tiadc_buffer_postenable(struct iio_dev *indio_dev)
>+{
>+	struct tiadc_device *adc_dev = iio_priv(indio_dev);
>+	struct iio_buffer *buffer = indio_dev->buffer;
>+	unsigned int enb = 0, stepnum;
>+	u8 bit;
>+
>+	adc_dev->data = kmalloc(indio_dev->scan_bytes, GFP_KERNEL);
>+	if (adc_dev->data == NULL)
>+		return -ENOMEM;
>+
>+	tiadc_step_config(indio_dev);
>+	for_each_set_bit(bit, buffer->scan_mask,
>+			adc_dev->channels) {
>+		struct iio_chan_spec const *chan = indio_dev->channels + bit;
>+		/*
>+		 * There are a total of 16 steps available
>+		 * that are shared between ADC and touchscreen.
>+		 * We start configuring from step 16 to 0 incase of
>+		 * ADC. Hence the relation between input channel
>+		 * and step for ADC would be as below.
>+		 */
>+		stepnum = chan->channel + 9;
>+		enb |= (1 << stepnum);

Hmm. This looks odd.
 
In tiadc_step_config() we do:
| steps = TOTAL_STEPS - adc_dev->channels;
|…
| for (i = 0; i < adc_dev->channels; i++) {
|         chan = adc_dev->channel_line[i];
|         tiadc_writel(adc_dev,
|                         REG_STEPCONFIG(steps),
|                         stepconfig
|                         |
|                         STEPCONFIG_INP(chan));
|         tiadc_writel(adc_dev,
|                         REG_STEPDELAY(steps),
|                         STEPCONFIG_OPENDLY);
|         adc_dev->channel_step[i]
|                 =
|                 steps;
|         steps++;
| }

That means if we have only one channel we enable the last step bit /
topmost that is bit 16. For the "default" four channels we get 0x1e000
as mask which means bit 13 to 16. 
If you do have only one channel with the number 4 you then
get_adc_step_mask() will compute the correct step mask but here enable
step 14 instead of step 16.

What about the following as replacement?

index 08681d3..3bfcf1b 100644
--- a/drivers/iio/adc/ti_am335x_adc.c
+++ b/drivers/iio/adc/ti_am335x_adc.c
@@ -65,6 +65,11 @@ static u32 get_adc_step_mask(struct tiadc_device *adc_dev)
 	return step_en;
 }
 
+static u32 get_adc_step_bit(struct tiadc_device *adc_dev, int chan)
+{
+	return 1 << adc_dev->channel_step[chan];
+}
+
 static void tiadc_step_config(struct iio_dev *indio_dev)
 {
 	struct tiadc_device *adc_dev = iio_priv(indio_dev);
@@ -179,7 +187,7 @@ static int tiadc_buffer_postenable(struct iio_dev *indio_dev)
 {
 	struct tiadc_device *adc_dev = iio_priv(indio_dev);
 	struct iio_buffer *buffer = indio_dev->buffer;
-	unsigned int enb = 0, stepnum;
+	unsigned int enb = 0;
 	u8 bit;
 
 	adc_dev->data = kmalloc(indio_dev->scan_bytes, GFP_KERNEL);
@@ -187,19 +195,8 @@ static int tiadc_buffer_postenable(struct iio_dev *indio_dev)
 		return -ENOMEM;
 
 	tiadc_step_config(indio_dev);
-	for_each_set_bit(bit, buffer->scan_mask,
-			adc_dev->channels) {
-		struct iio_chan_spec const *chan = indio_dev->channels + bit;
-		/*
-		 * There are a total of 16 steps available
-		 * that are shared between ADC and touchscreen.
-		 * We start configuring from step 16 to 0 incase of
-		 * ADC. Hence the relation between input channel
-		 * and step for ADC would be as below.
-		 */
-		stepnum = chan->channel + 9;
-		enb |= (1 << stepnum);
-	}
+	for_each_set_bit(bit, buffer->scan_mask, adc_dev->channels)
+		enb |= get_adc_step_bit(adc_dev, bit);
 
 	adc_dev->buffer_en_ch_steps = enb;
 	am335x_tsc_se_set(adc_dev->mfd_tscadc, enb);


Would it work? This is untested but it could work :)

Sebastian
