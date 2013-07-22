Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756164Ab3GVOF0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Jul 2013 10:05:26 -0400
Received: from mail1.bemta8.messagelabs.com ([216.82.243.204]:34325 "EHLO
	mail1.bemta8.messagelabs.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754132Ab3GVOFY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Jul 2013 10:05:24 -0400
X-Env-Sender: Hector.Palacios@digi.com
X-Msg-Ref: server-2.tower-46.messagelabs.com!1374501920!29057169!3
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
Subject: [PATCH v3 5/5] iio: mxs-lradc: add write_raw function to modify scale
Date: Mon, 22 Jul 2013 16:04:03 +0200
Message-ID: <1374501843-19651-6-git-send-email-hector.palacios@digi.com>
X-Mailer: git-send-email 1.8.3
In-Reply-To: <1374501843-19651-1-git-send-email-hector.palacios@digi.com>
References: <1374501843-19651-1-git-send-email-hector.palacios@digi.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Added write_raw function to manipulate the optional divider_by_two
through the scaling attribute out of the available scales.

Signed-off-by: Hector Palacios <hector.palacios@digi.com>
---
 drivers/staging/iio/adc/mxs-lradc.c | 56 ++++++++++++++++++++++++++++++++++++-
 1 file changed, 55 insertions(+), 1 deletion(-)

diff --git a/drivers/staging/iio/adc/mxs-lradc.c b/drivers/staging/iio/adc/mxs-lradc.c
index 5d332b1..4d3c7f5 100644
--- a/drivers/staging/iio/adc/mxs-lradc.c
+++ b/drivers/staging/iio/adc/mxs-lradc.c
@@ -213,6 +213,7 @@ struct mxs_lradc {
 #define	LRADC_CTRL1_LRADC_IRQ_OFFSET		0
 
 #define	LRADC_CTRL2				0x20
+#define	LRADC_CTRL2_DIVIDE_BY_TWO_OFFSET	24
 #define	LRADC_CTRL2_TEMPSENSE_PWD		(1 << 15)
 
 #define	LRADC_STATUS				0x40
@@ -320,7 +321,8 @@ static int mxs_lradc_read_raw(struct iio_dev *iio_dev,
 		break;
 	case IIO_CHAN_INFO_SCALE:
 		*val = lradc->vref_mv[chan->channel];
-		*val2 = chan->scan_type.realbits;
+		*val2 = chan->scan_type.realbits -
+			lradc->is_divided[chan->channel];
 		ret = IIO_VAL_FRACTIONAL_LOG2;
 		break;
 	default:
@@ -333,6 +335,56 @@ static int mxs_lradc_read_raw(struct iio_dev *iio_dev,
 	return ret;
 }
 
+static int mxs_lradc_write_raw(struct iio_dev *iio_dev,
+			       const struct iio_chan_spec *chan,
+			       int val, int val2, long m)
+{
+	struct mxs_lradc *lradc = iio_priv(iio_dev);
+	struct mxs_lradc_scale *scale_avail =
+			lradc->scale_avail[chan->channel];
+	int ret;
+
+	ret = mutex_trylock(&lradc->lock);
+	if (!ret)
+		return -EBUSY;
+
+	switch (m) {
+	case IIO_CHAN_INFO_SCALE:
+		ret = -EINVAL;
+		if (val == scale_avail[MXS_LRADC_DIV_DISABLED].integer &&
+		    val2 == scale_avail[MXS_LRADC_DIV_DISABLED].nano) {
+			/* divider by two disabled */
+			writel(1 << LRADC_CTRL2_DIVIDE_BY_TWO_OFFSET,
+			       lradc->base + LRADC_CTRL2 + STMP_OFFSET_REG_CLR);
+			lradc->is_divided[chan->channel] = 0;
+			ret = 0;
+		} else if (val == scale_avail[MXS_LRADC_DIV_ENABLED].integer &&
+			   val2 == scale_avail[MXS_LRADC_DIV_ENABLED].nano) {
+			/* divider by two enabled */
+			writel(1 << LRADC_CTRL2_DIVIDE_BY_TWO_OFFSET,
+			       lradc->base + LRADC_CTRL2 + STMP_OFFSET_REG_SET);
+			lradc->is_divided[chan->channel] = 1;
+			ret = 0;
+		}
+
+		break;
+	default:
+		ret = -EINVAL;
+		break;
+	}
+
+	mutex_unlock(&lradc->lock);
+
+	return ret;
+}
+
+static int mxs_lradc_write_raw_get_fmt(struct iio_dev *iio_dev,
+				       const struct iio_chan_spec *chan,
+				       long m)
+{
+	return IIO_VAL_INT_PLUS_NANO;
+}
+
 static ssize_t mxs_lradc_show_scale_available_ch(struct device *dev,
 		struct device_attribute *attr,
 		char *buf,
@@ -410,6 +462,8 @@ static const struct attribute_group mxs_lradc_attribute_group = {
 static const struct iio_info mxs_lradc_iio_info = {
 	.driver_module		= THIS_MODULE,
 	.read_raw		= mxs_lradc_read_raw,
+	.write_raw		= mxs_lradc_write_raw,
+	.write_raw_get_fmt	= mxs_lradc_write_raw_get_fmt,
 	.attrs			= &mxs_lradc_attribute_group,
 };
 
