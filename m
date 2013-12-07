Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759431Ab3LGAYY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Dec 2013 19:24:24 -0500
Received: from top.free-electrons.com ([176.31.233.9]:56240 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753798Ab3LGAYW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Dec 2013 19:24:22 -0500
From: Alexandre Belloni <alexandre.belloni@free-electrons.com>
To: Jonathan Cameron <jic23@kernel.org>
Cc: lars@metafoo.de, Marek Vasut <marex@denx.de>, harald@ccbib.org,
        hector.palacios@digi.com, linux-iio@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Alexandre Belloni <alexandre.belloni@free-electrons.com>
Subject: [PATCHv4 1/3] iio: mxs-lradc: add scale attribute to channels
Date: Sat,  7 Dec 2013 01:23:58 +0100
Message-Id: <1386375840-24984-2-git-send-email-alexandre.belloni@free-electrons.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1386375840-24984-1-git-send-email-alexandre.belloni@free-electrons.com>
References: <1386375840-24984-1-git-send-email-alexandre.belloni@free-electrons.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Hector Palacios <hector.palacios@digi.com>

Some LRADC channels have fixed pre-dividers and all have an optional
divider by two which allows a maximum input voltage of VDDIO - 50mV.

This patch
 - adds the scaling info flag to all channels
 - grabs the max reference voltage per channel
   (where the fixed pre-dividers apply)
 - allows to read the scaling attribute (computed from the Vref)

Signed-off-by: Hector Palacios <hector.palacios@digi.com>.
Signed-off-by: Alexandre Belloni <alexandre.belloni@free-electrons.com>
---
 drivers/staging/iio/adc/mxs-lradc.c | 56 +++++++++++++++++++++++++++++++++++--
 1 file changed, 54 insertions(+), 2 deletions(-)

diff --git a/drivers/staging/iio/adc/mxs-lradc.c b/drivers/staging/iio/adc/mxs-lradc.c
index 5a4499c3d22a..22fef0a408db 100644
--- a/drivers/staging/iio/adc/mxs-lradc.c
+++ b/drivers/staging/iio/adc/mxs-lradc.c
@@ -111,16 +111,59 @@ static const char * const mx28_lradc_irq_names[] = {
 struct mxs_lradc_of_config {
 	const int		irq_count;
 	const char * const	*irq_name;
+	const uint32_t		*vref_mv;
+};
+
+#define VREF_MV_BASE 1850
+
+static const uint32_t mx23_vref_mv[LRADC_MAX_TOTAL_CHANS] = {
+	VREF_MV_BASE,		/* CH0 */
+	VREF_MV_BASE,		/* CH1 */
+	VREF_MV_BASE,		/* CH2 */
+	VREF_MV_BASE,		/* CH3 */
+	VREF_MV_BASE,		/* CH4 */
+	VREF_MV_BASE,		/* CH5 */
+	VREF_MV_BASE * 2,	/* CH6 VDDIO */
+	VREF_MV_BASE * 4,	/* CH7 VBATT */
+	VREF_MV_BASE,		/* CH8 Temp sense 0 */
+	VREF_MV_BASE,		/* CH9 Temp sense 1 */
+	VREF_MV_BASE,		/* CH10 */
+	VREF_MV_BASE,		/* CH11 */
+	VREF_MV_BASE,		/* CH12 USB_DP */
+	VREF_MV_BASE,		/* CH13 USB_DN */
+	VREF_MV_BASE,		/* CH14 VBG */
+	VREF_MV_BASE * 4,	/* CH15 VDD5V */
+};
+
+static const uint32_t mx28_vref_mv[LRADC_MAX_TOTAL_CHANS] = {
+	VREF_MV_BASE,		/* CH0 */
+	VREF_MV_BASE,		/* CH1 */
+	VREF_MV_BASE,		/* CH2 */
+	VREF_MV_BASE,		/* CH3 */
+	VREF_MV_BASE,		/* CH4 */
+	VREF_MV_BASE,		/* CH5 */
+	VREF_MV_BASE,		/* CH6 */
+	VREF_MV_BASE * 4,	/* CH7 VBATT */
+	VREF_MV_BASE,		/* CH8 Temp sense 0 */
+	VREF_MV_BASE,		/* CH9 Temp sense 1 */
+	VREF_MV_BASE * 2,	/* CH10 VDDIO */
+	VREF_MV_BASE,		/* CH11 VTH */
+	VREF_MV_BASE * 2,	/* CH12 VDDA */
+	VREF_MV_BASE,		/* CH13 VDDD */
+	VREF_MV_BASE,		/* CH14 VBG */
+	VREF_MV_BASE * 4,	/* CH15 VDD5V */
 };
 
 static const struct mxs_lradc_of_config mxs_lradc_of_config[] = {
 	[IMX23_LRADC] = {
 		.irq_count	= ARRAY_SIZE(mx23_lradc_irq_names),
 		.irq_name	= mx23_lradc_irq_names,
+		.vref_mv	= mx23_vref_mv,
 	},
 	[IMX28_LRADC] = {
 		.irq_count	= ARRAY_SIZE(mx28_lradc_irq_names),
 		.irq_name	= mx28_lradc_irq_names,
+		.vref_mv	= mx28_vref_mv,
 	},
 };
 
@@ -155,6 +198,8 @@ struct mxs_lradc {
 
 	struct completion	completion;
 
+	const uint32_t		*vref_mv;
+
 	/*
 	 * Touchscreen LRADC channels receives a private slot in the CTRL4
 	 * register, the slot #7. Therefore only 7 slots instead of 8 in the
@@ -836,6 +881,8 @@ static int mxs_lradc_read_raw(struct iio_dev *iio_dev,
 			const struct iio_chan_spec *chan,
 			int *val, int *val2, long m)
 {
+	struct mxs_lradc *lradc = iio_priv(iio_dev);
+
 	/* Check for invalid channel */
 	if (chan->channel > LRADC_MAX_TOTAL_CHANS)
 		return -EINVAL;
@@ -857,7 +904,9 @@ static int mxs_lradc_read_raw(struct iio_dev *iio_dev,
 			return IIO_VAL_INT_PLUS_MICRO;
 		}
 
-		return -EINVAL;
+		*val = lradc->vref_mv[chan->channel];
+		*val2 = chan->scan_type.realbits;
+		return IIO_VAL_FRACTIONAL_LOG2;
 
 	case IIO_CHAN_INFO_OFFSET:
 		if (chan->type == IIO_TEMP) {
@@ -1189,7 +1238,8 @@ static const struct iio_buffer_setup_ops mxs_lradc_buffer_ops = {
 	.type = (chan_type),					\
 	.indexed = 1,						\
 	.scan_index = (idx),					\
-	.info_mask_separate = BIT(IIO_CHAN_INFO_RAW),		\
+	.info_mask_separate = BIT(IIO_CHAN_INFO_RAW) |		\
+			      BIT(IIO_CHAN_INFO_SCALE),		\
 	.channel = (idx),					\
 	.scan_type = {						\
 		.sign = 'u',					\
@@ -1381,6 +1431,8 @@ static int mxs_lradc_probe(struct platform_device *pdev)
 			return ret;
 	}
 
+	lradc->vref_mv = of_cfg->vref_mv;
+
 	platform_set_drvdata(pdev, iio);
 
 	init_completion(&lradc->completion);
-- 
1.8.3.2

