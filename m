Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756192Ab3GVOF6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Jul 2013 10:05:58 -0400
Received: from mail1.bemta8.messagelabs.com ([216.82.243.208]:37870 "EHLO
	mail1.bemta8.messagelabs.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755305Ab3GVOF0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Jul 2013 10:05:26 -0400
X-Env-Sender: Hector.Palacios@digi.com
X-Msg-Ref: server-2.tower-46.messagelabs.com!1374501920!29057169!2
X-Originating-IP: [66.77.174.14]
X-StarScan-Received: 
X-StarScan-Version: 6.9.11; banners=-,-,-
X-VirusChecked: Checked
From: Hector Palacios <hector.palacios@digi.com>
To: <linux-iio@vger.kernel.org>
CC: <linux-kernel@vger.kernel.org>, <devicetree-discuss@lists.ozlabs.org>,
        <alexandre.belloni@free-electrons.com>, <jic23@kernel.org>,
        <lars@metafoo.de>, <fabio.estevam@freescale.com>, <marex@denx.de>,
        <hector.palacios@digi.com>
Subject: [PATCH v3 3/5] iio: mxs-lradc: add scale attribute to channels
Date: Mon, 22 Jul 2013 16:04:01 +0200
Message-ID: <1374501843-19651-4-git-send-email-hector.palacios@digi.com>
X-Mailer: git-send-email 1.8.3
In-Reply-To: <1374501843-19651-1-git-send-email-hector.palacios@digi.com>
References: <1374501843-19651-1-git-send-email-hector.palacios@digi.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Some LRADC channels have fixed pre-dividers and all have an optional
divider by two which allows a maximum input voltage of VDDIO - 50mV.

This patch
 - adds the scaling info flag to all channels
 - grabs the max reference voltage per channel from DT
   (where the fixed pre-dividers apply)
 - allows to read the scaling attribute (computed from the Vref)

Signed-off-by: Hector Palacios <hector.palacios@digi.com>.
Acked-by: Marek Vasut <marex@denx.de>
---
 drivers/staging/iio/adc/mxs-lradc.c | 77 +++++++++++++++++++++++++------------
 1 file changed, 53 insertions(+), 24 deletions(-)

diff --git a/drivers/staging/iio/adc/mxs-lradc.c b/drivers/staging/iio/adc/mxs-lradc.c
index 56667da..5037577 100644
--- a/drivers/staging/iio/adc/mxs-lradc.c
+++ b/drivers/staging/iio/adc/mxs-lradc.c
@@ -141,6 +141,8 @@ struct mxs_lradc {
 
 	struct completion	completion;
 
+	uint32_t		vref_mv[LRADC_MAX_TOTAL_CHANS];
+
 	/*
 	 * Touchscreen LRADC channels receives a private slot in the CTRL4
 	 * register, the slot #7. Therefore only 7 slots instead of 8 in the
@@ -228,33 +230,12 @@ struct mxs_lradc {
 #define LRADC_RESOLUTION			12
 #define LRADC_SINGLE_SAMPLE_MASK		((1 << LRADC_RESOLUTION) - 1)
 
-/*
- * Raw I/O operations
- */
-static int mxs_lradc_read_raw(struct iio_dev *iio_dev,
-			const struct iio_chan_spec *chan,
-			int *val, int *val2, long m)
+static int mxs_lradc_read_single(struct iio_dev *iio_dev,
+				 const struct iio_chan_spec *chan, int *val)
 {
 	struct mxs_lradc *lradc = iio_priv(iio_dev);
 	int ret;
 
-	if (m != IIO_CHAN_INFO_RAW)
-		return -EINVAL;
-
-	/* Check for invalid channel */
-	if (chan->channel > LRADC_MAX_TOTAL_CHANS)
-		return -EINVAL;
-
-	/*
-	 * See if there is no buffered operation in progess. If there is, simply
-	 * bail out. This can be improved to support both buffered and raw IO at
-	 * the same time, yet the code becomes horribly complicated. Therefore I
-	 * applied KISS principle here.
-	 */
-	ret = mutex_trylock(&lradc->lock);
-	if (!ret)
-		return -EBUSY;
-
 	INIT_COMPLETION(lradc->completion);
 
 	/*
@@ -293,6 +274,47 @@ err:
 	writel(LRADC_CTRL1_LRADC_IRQ_EN(0),
 		lradc->base + LRADC_CTRL1 + STMP_OFFSET_REG_CLR);
 
+	return ret;
+}
+
+/*
+ * Raw I/O operations
+ */
+static int mxs_lradc_read_raw(struct iio_dev *iio_dev,
+			const struct iio_chan_spec *chan,
+			int *val, int *val2, long m)
+{
+	struct mxs_lradc *lradc = iio_priv(iio_dev);
+	int ret;
+
+	/*
+	 * See if there is no buffered operation in progress. If there is, simply
+	 * bail out. This can be improved to support both buffered and raw IO at
+	 * the same time, yet the code becomes horribly complicated. Therefore I
+	 * applied KISS principle here.
+	 */
+	ret = mutex_trylock(&lradc->lock);
+	if (!ret)
+		return -EBUSY;
+
+	/* Check for invalid channel */
+	if (chan->channel > LRADC_MAX_TOTAL_CHANS)
+		ret = -EINVAL;
+
+	switch (m) {
+	case IIO_CHAN_INFO_RAW:
+		ret = mxs_lradc_read_single(iio_dev, chan, val);
+		break;
+	case IIO_CHAN_INFO_SCALE:
+		*val = lradc->vref_mv[chan->channel];
+		*val2 = chan->scan_type.realbits;
+		ret = IIO_VAL_FRACTIONAL_LOG2;
+		break;
+	default:
+		ret = -EINVAL;
+		break;
+	}
+
 	mutex_unlock(&lradc->lock);
 
 	return ret;
@@ -817,7 +839,8 @@ static const struct iio_buffer_setup_ops mxs_lradc_buffer_ops = {
 	.type = (chan_type),					\
 	.indexed = 1,						\
 	.scan_index = (idx),					\
-	.info_mask_separate = BIT(IIO_CHAN_INFO_RAW),		\
+	.info_mask_separate = BIT(IIO_CHAN_INFO_RAW) |		\
+			      BIT(IIO_CHAN_INFO_SCALE),		\
 	.channel = (idx),					\
 	.scan_type = {						\
 		.sign = 'u',					\
@@ -956,6 +979,12 @@ static int mxs_lradc_probe(struct platform_device *pdev)
 			goto err_addr;
 	}
 
+	/* Grab Vref array from DT */
+	ret = of_property_read_u32_array(node, "fsl,vref", lradc->vref_mv,
+					 LRADC_MAX_TOTAL_CHANS);
+	if (ret)
+		goto err_addr;
+
 	platform_set_drvdata(pdev, iio);
 
 	init_completion(&lradc->completion);
