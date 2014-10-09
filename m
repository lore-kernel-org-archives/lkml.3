Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758027AbaJIV3e (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Oct 2014 17:29:34 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:59361 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932574AbaJIVJV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Oct 2014 17:09:21 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Ludovic Desroches <ludovic.desroches@atmel.com>,
        Jonathan Cameron <jic23@kernel.org>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.13 092/163] iio: adc: at91: don't use the last converted data register
Date: Thu,  9 Oct 2014 14:01:57 -0700
Message-Id: <1412888588-26755-93-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1412888588-26755-1-git-send-email-kamal@canonical.com>
References: <1412888588-26755-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.13
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.13.11.9 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ludovic Desroches <ludovic.desroches@atmel.com>

commit d4f51956ac8ad302db9b0c4e4232775b1baa7b44 upstream.

If touchscreen mode is enabled and a conversion is requested on another
channel, the result in the last converted data register can be a
touchscreen relative value. Starting a conversion involves to do a
conversion for all active channel. It starts with ADC channels and ends
with touchscreen channels. Then if ADC_LCD register is not read quickly,
its content may be a touchscreen conversion.
To remove this temporal constraint, the conversion value is taken from
the channel data register.

Signed-off-by: Ludovic Desroches <ludovic.desroches@atmel.com>
Acked-by: Alexandre Belloni <alexandre.belloni@free-electrons.com>
Acked-by: Nicolas Ferre <nicolas.ferre@atmel.com>
Signed-off-by: Jonathan Cameron <jic23@kernel.org>
[ kamal: backport to 3.13-stable: no _9x5_interrupt handler ]
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 drivers/iio/adc/at91_adc.c | 10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)

diff --git a/drivers/iio/adc/at91_adc.c b/drivers/iio/adc/at91_adc.c
index e6bf77d..059946e 100644
--- a/drivers/iio/adc/at91_adc.c
+++ b/drivers/iio/adc/at91_adc.c
@@ -78,6 +78,7 @@ struct at91_adc_state {
 	bool			done;
 	int			irq;
 	u16			last_value;
+	int			chnb;
 	struct mutex		lock;
 	u8			num_channels;
 	void __iomem		*reg_base;
@@ -151,7 +152,7 @@ void handle_adc_eoc_trigger(int irq, struct iio_dev *idev)
 		disable_irq_nosync(irq);
 		iio_trigger_poll(idev->trig, iio_get_time_ns());
 	} else {
-		st->last_value = at91_adc_readl(st, AT91_ADC_LCDR);
+		st->last_value = at91_adc_readl(st, AT91_ADC_CHAN(st, st->chnb));
 		st->done = true;
 		wake_up_interruptible(&st->wq_data_avail);
 	}
@@ -230,7 +231,7 @@ static irqreturn_t at91_adc_interrupt(int irq, void *private)
 		AT91_ADC_IER_YRDY |
 		AT91_ADC_IER_PRDY;
 
-	if (status & st->registers->drdy_mask)
+	if (status & GENMASK(st->num_channels - 1, 0))
 		handle_adc_eoc_trigger(irq, idev);
 
 	if (status & AT91_ADC_IER_PEN) {
@@ -501,9 +502,10 @@ static int at91_adc_read_raw(struct iio_dev *idev,
 	case IIO_CHAN_INFO_RAW:
 		mutex_lock(&st->lock);
 
+		st->chnb = chan->channel;
 		at91_adc_writel(st, AT91_ADC_CHER,
 				AT91_ADC_CH(chan->channel));
-		at91_adc_writel(st, AT91_ADC_IER, st->registers->drdy_mask);
+		at91_adc_writel(st, AT91_ADC_IER, BIT(chan->channel));
 		at91_adc_writel(st, AT91_ADC_CR, AT91_ADC_START);
 
 		ret = wait_event_interruptible_timeout(st->wq_data_avail,
@@ -520,7 +522,7 @@ static int at91_adc_read_raw(struct iio_dev *idev,
 
 		at91_adc_writel(st, AT91_ADC_CHDR,
 				AT91_ADC_CH(chan->channel));
-		at91_adc_writel(st, AT91_ADC_IDR, st->registers->drdy_mask);
+		at91_adc_writel(st, AT91_ADC_IDR, BIT(chan->channel));
 
 		st->last_value = 0;
 		st->done = false;
-- 
1.9.1

