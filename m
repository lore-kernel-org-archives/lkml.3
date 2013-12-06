Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758244Ab3LFTba (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Dec 2013 14:31:30 -0500
Received: from top.free-electrons.com ([176.31.233.9]:54937 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1757998Ab3LFTb2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Dec 2013 14:31:28 -0500
From: Alexandre Belloni <alexandre.belloni@free-electrons.com>
To: Jonathan Cameron <jic23@cam.ac.uk>
Cc: Maxime Ripard <maxime.ripard@free-electrons.com>, jimwall@q.com,
        brian@crystalfontz.com,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-iio@vger.kernel.org, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org, Lars-Peter Clausen <lars@metafoo.de>,
        Alexandre Belloni <alexandre.belloni@free-electrons.com>
Subject: [PATCHv2] iio: mxs-lradc: compute temperature from channel 8 and 9
Date: Fri,  6 Dec 2013 20:31:19 +0100
Message-Id: <1386358279-25474-1-git-send-email-alexandre.belloni@free-electrons.com>
X-Mailer: git-send-email 1.8.3.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The mxs LRADC is able to read an internal die temperature sensor. The
temperature has to be calculated from the value read on channel 8 and channel 9.
To be able to expose the result to hwmon, implement iio channel 8 as
(channel 9 - channel 8). Then, implement IIO_CHAN_INFO_SCALE and
IIO_CHAN_INFO_OFFSET so that it can be processed by hwmon through the in kernel
provider/consumer mechanism.

Signed-off-by: Alexandre Belloni <alexandre.belloni@free-electrons.com>
Signed-off-by: Maxime Ripard <maxime.ripard@free-electrons.com>
Reviewed-by: Lars-Peter Clausen <lars@metafoo.de>
---
Changes in v2:
  - rebased on v3.13.0-rc3

 drivers/staging/iio/adc/mxs-lradc.c | 91 +++++++++++++++++++++++++++++++------
 1 file changed, 78 insertions(+), 13 deletions(-)

diff --git a/drivers/staging/iio/adc/mxs-lradc.c b/drivers/staging/iio/adc/mxs-lradc.c
index e2dd7830b320..5a4499c3d22a 100644
--- a/drivers/staging/iio/adc/mxs-lradc.c
+++ b/drivers/staging/iio/adc/mxs-lradc.c
@@ -759,20 +759,11 @@ static void mxs_lradc_handle_touch(struct mxs_lradc *lradc)
 /*
  * Raw I/O operations
  */
-static int mxs_lradc_read_raw(struct iio_dev *iio_dev,
-			const struct iio_chan_spec *chan,
-			int *val, int *val2, long m)
+static int mxs_lradc_read_single(struct iio_dev *iio_dev, int chan, int *val)
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
 	/*
 	 * See if there is no buffered operation in progess. If there is, simply
 	 * bail out. This can be improved to support both buffered and raw IO at
@@ -797,7 +788,7 @@ static int mxs_lradc_read_raw(struct iio_dev *iio_dev,
 
 	/* Clean the slot's previous content, then set new one. */
 	mxs_lradc_reg_clear(lradc, LRADC_CTRL4_LRADCSELECT_MASK(0), LRADC_CTRL4);
-	mxs_lradc_reg_set(lradc, chan->channel, LRADC_CTRL4);
+	mxs_lradc_reg_set(lradc, chan, LRADC_CTRL4);
 
 	mxs_lradc_reg_wrt(lradc, 0, LRADC_CH(0));
 
@@ -824,6 +815,71 @@ err:
 	return ret;
 }
 
+static int mxs_lradc_read_temp(struct iio_dev *iio_dev, int *val)
+{
+	int ret, min, max;
+
+	ret = mxs_lradc_read_single(iio_dev, 8, &min);
+	if (ret != IIO_VAL_INT)
+		return ret;
+
+	ret = mxs_lradc_read_single(iio_dev, 9, &max);
+	if (ret != IIO_VAL_INT)
+		return ret;
+
+	*val = max - min;
+
+	return IIO_VAL_INT;
+}
+
+static int mxs_lradc_read_raw(struct iio_dev *iio_dev,
+			const struct iio_chan_spec *chan,
+			int *val, int *val2, long m)
+{
+	/* Check for invalid channel */
+	if (chan->channel > LRADC_MAX_TOTAL_CHANS)
+		return -EINVAL;
+
+	switch (m) {
+	case IIO_CHAN_INFO_RAW:
+		if (chan->type == IIO_TEMP)
+			return mxs_lradc_read_temp(iio_dev, val);
+
+		return mxs_lradc_read_single(iio_dev, chan->channel, val);
+
+	case IIO_CHAN_INFO_SCALE:
+		if (chan->type == IIO_TEMP) {
+			/* From the datasheet, we have to multiply by 1.012 and
+			 * divide by 4
+			 */
+			*val = 0;
+			*val2 = 253000;
+			return IIO_VAL_INT_PLUS_MICRO;
+		}
+
+		return -EINVAL;
+
+	case IIO_CHAN_INFO_OFFSET:
+		if (chan->type == IIO_TEMP) {
+			/* The calculated value from the ADC is in Kelvin, we
+			 * want Celsius for hwmon so the offset is
+			 * -272.15 * scale
+			 */
+			*val = -1075;
+			*val2 = 691699;
+
+			return IIO_VAL_INT_PLUS_MICRO;
+		}
+
+		return -EINVAL;
+
+	default:
+		break;
+	}
+
+	return -EINVAL;
+}
+
 static const struct iio_info mxs_lradc_iio_info = {
 	.driver_module		= THIS_MODULE,
 	.read_raw		= mxs_lradc_read_raw,
@@ -1151,8 +1207,17 @@ static const struct iio_chan_spec mxs_lradc_chan_spec[] = {
 	MXS_ADC_CHAN(5, IIO_VOLTAGE),
 	MXS_ADC_CHAN(6, IIO_VOLTAGE),
 	MXS_ADC_CHAN(7, IIO_VOLTAGE),	/* VBATT */
-	MXS_ADC_CHAN(8, IIO_TEMP),	/* Temp sense 0 */
-	MXS_ADC_CHAN(9, IIO_TEMP),	/* Temp sense 1 */
+	/* Combined Temperature sensors */
+	{
+		.type = IIO_TEMP,
+		.indexed = 1,
+		.scan_index = 8,
+		.info_mask_separate = BIT(IIO_CHAN_INFO_RAW) |
+				      BIT(IIO_CHAN_INFO_OFFSET) |
+				      BIT(IIO_CHAN_INFO_SCALE),
+		.channel = 8,
+		.scan_type = {.sign = 'u', .realbits = 18, .storagebits = 32,},
+	},
 	MXS_ADC_CHAN(10, IIO_VOLTAGE),	/* VDDIO */
 	MXS_ADC_CHAN(11, IIO_VOLTAGE),	/* VTH */
 	MXS_ADC_CHAN(12, IIO_VOLTAGE),	/* VDDA */
-- 
1.8.3.2

