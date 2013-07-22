Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755986Ab3GVOFE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Jul 2013 10:05:04 -0400
Received: from mail1.bemta7.messagelabs.com ([216.82.254.101]:6627 "EHLO
	mail1.bemta7.messagelabs.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753868Ab3GVOE7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Jul 2013 10:04:59 -0400
X-Env-Sender: Hector.Palacios@digi.com
X-Msg-Ref: server-2.tower-200.messagelabs.com!1374501894!11361230!6
X-Originating-IP: [66.77.174.13]
X-StarScan-Received: 
X-StarScan-Version: 6.9.11; banners=-,-,-
X-VirusChecked: Checked
From: Hector Palacios <hector.palacios@digi.com>
To: <linux-iio@vger.kernel.org>
CC: <linux-kernel@vger.kernel.org>, <devicetree-discuss@lists.ozlabs.org>,
        <alexandre.belloni@free-electrons.com>, <jic23@kernel.org>,
        <lars@metafoo.de>, <fabio.estevam@freescale.com>, <marex@denx.de>,
        <hector.palacios@digi.com>
Subject: [PATCH v3 4/5] iio: mxs-lradc: add scale_available file to channels
Date: Mon, 22 Jul 2013 16:04:02 +0200
Message-ID: <1374501843-19651-5-git-send-email-hector.palacios@digi.com>
X-Mailer: git-send-email 1.8.3
In-Reply-To: <1374501843-19651-1-git-send-email-hector.palacios@digi.com>
References: <1374501843-19651-1-git-send-email-hector.palacios@digi.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Adds in_voltageX_scale_available file for every channel to read
the different available scales.
There are two scales per channel:
 [0] = divider_by_two disabled (default)
 [1] = divider_by_two enabled
The scale is a struct made of integer and nano parts to build
a long decimal number.

Signed-off-by: Hector Palacios <hector.palacios@digi.com>
---
 drivers/staging/iio/adc/mxs-lradc.c | 112 +++++++++++++++++++++++++++++++++++-
 1 file changed, 111 insertions(+), 1 deletion(-)

diff --git a/drivers/staging/iio/adc/mxs-lradc.c b/drivers/staging/iio/adc/mxs-lradc.c
index 5037577..5d332b1 100644
--- a/drivers/staging/iio/adc/mxs-lradc.c
+++ b/drivers/staging/iio/adc/mxs-lradc.c
@@ -37,6 +37,7 @@
 #include <linux/input.h>
 
 #include <linux/iio/iio.h>
+#include <linux/iio/sysfs.h>
 #include <linux/iio/buffer.h>
 #include <linux/iio/trigger.h>
 #include <linux/iio/trigger_consumer.h>
@@ -129,6 +130,16 @@ enum mxs_lradc_ts {
 	MXS_LRADC_TOUCHSCREEN_5WIRE,
 };
 
+enum mxs_lradc_divbytwo {
+	MXS_LRADC_DIV_DISABLED = 0,
+	MXS_LRADC_DIV_ENABLED,
+};
+
+struct mxs_lradc_scale {
+	unsigned int		integer;
+	unsigned int		nano;
+};
+
 struct mxs_lradc {
 	struct device		*dev;
 	void __iomem		*base;
@@ -142,6 +153,8 @@ struct mxs_lradc {
 	struct completion	completion;
 
 	uint32_t		vref_mv[LRADC_MAX_TOTAL_CHANS];
+	struct mxs_lradc_scale	scale_avail[LRADC_MAX_TOTAL_CHANS][2];
+	unsigned int		is_divided[LRADC_MAX_TOTAL_CHANS];
 
 	/*
 	 * Touchscreen LRADC channels receives a private slot in the CTRL4
@@ -320,9 +333,84 @@ static int mxs_lradc_read_raw(struct iio_dev *iio_dev,
 	return ret;
 }
 
+static ssize_t mxs_lradc_show_scale_available_ch(struct device *dev,
+		struct device_attribute *attr,
+		char *buf,
+		int ch)
+{
+	struct iio_dev *iio = dev_to_iio_dev(dev);
+	struct mxs_lradc *lradc = iio_priv(iio);
+	int i, len = 0;
+
+	for (i = 0; i < ARRAY_SIZE(lradc->scale_avail[ch]); i++)
+		len += sprintf(buf + len, "%d.%09u ",
+			       lradc->scale_avail[ch][i].integer,
+			       lradc->scale_avail[ch][i].nano);
+
+	len += sprintf(buf + len, "\n");
+
+	return len;
+}
+
+static ssize_t mxs_lradc_show_scale_available(struct device *dev,
+		struct device_attribute *attr,
+		char *buf)
+{
+	struct iio_dev_attr *iio_attr = to_iio_dev_attr(attr);
+
+	return mxs_lradc_show_scale_available_ch(dev, attr, buf,
+						 iio_attr->address);
+}
+
+#define SHOW_SCALE_AVAILABLE_ATTR(ch)					\
+static IIO_DEVICE_ATTR(in_voltage##ch##_scale_available, S_IRUGO,	\
+		       mxs_lradc_show_scale_available, NULL, ch)
+
+SHOW_SCALE_AVAILABLE_ATTR(0);
+SHOW_SCALE_AVAILABLE_ATTR(1);
+SHOW_SCALE_AVAILABLE_ATTR(2);
+SHOW_SCALE_AVAILABLE_ATTR(3);
+SHOW_SCALE_AVAILABLE_ATTR(4);
+SHOW_SCALE_AVAILABLE_ATTR(5);
+SHOW_SCALE_AVAILABLE_ATTR(6);
+SHOW_SCALE_AVAILABLE_ATTR(7);
+SHOW_SCALE_AVAILABLE_ATTR(8);
+SHOW_SCALE_AVAILABLE_ATTR(9);
+SHOW_SCALE_AVAILABLE_ATTR(10);
+SHOW_SCALE_AVAILABLE_ATTR(11);
+SHOW_SCALE_AVAILABLE_ATTR(12);
+SHOW_SCALE_AVAILABLE_ATTR(13);
+SHOW_SCALE_AVAILABLE_ATTR(14);
+SHOW_SCALE_AVAILABLE_ATTR(15);
+
+static struct attribute *mxs_lradc_attributes[] = {
+	&iio_dev_attr_in_voltage0_scale_available.dev_attr.attr,
+	&iio_dev_attr_in_voltage1_scale_available.dev_attr.attr,
+	&iio_dev_attr_in_voltage2_scale_available.dev_attr.attr,
+	&iio_dev_attr_in_voltage3_scale_available.dev_attr.attr,
+	&iio_dev_attr_in_voltage4_scale_available.dev_attr.attr,
+	&iio_dev_attr_in_voltage5_scale_available.dev_attr.attr,
+	&iio_dev_attr_in_voltage6_scale_available.dev_attr.attr,
+	&iio_dev_attr_in_voltage7_scale_available.dev_attr.attr,
+	&iio_dev_attr_in_voltage8_scale_available.dev_attr.attr,
+	&iio_dev_attr_in_voltage9_scale_available.dev_attr.attr,
+	&iio_dev_attr_in_voltage10_scale_available.dev_attr.attr,
+	&iio_dev_attr_in_voltage11_scale_available.dev_attr.attr,
+	&iio_dev_attr_in_voltage12_scale_available.dev_attr.attr,
+	&iio_dev_attr_in_voltage13_scale_available.dev_attr.attr,
+	&iio_dev_attr_in_voltage14_scale_available.dev_attr.attr,
+	&iio_dev_attr_in_voltage15_scale_available.dev_attr.attr,
+	NULL
+};
+
+static const struct attribute_group mxs_lradc_attribute_group = {
+	.attrs = mxs_lradc_attributes,
+};
+
 static const struct iio_info mxs_lradc_iio_info = {
 	.driver_module		= THIS_MODULE,
 	.read_raw		= mxs_lradc_read_raw,
+	.attrs			= &mxs_lradc_attribute_group,
 };
 
 /*
@@ -842,6 +930,7 @@ static const struct iio_buffer_setup_ops mxs_lradc_buffer_ops = {
 	.info_mask_separate = BIT(IIO_CHAN_INFO_RAW) |		\
 			      BIT(IIO_CHAN_INFO_SCALE),		\
 	.channel = (idx),					\
+	.address = (idx),					\
 	.scan_type = {						\
 		.sign = 'u',					\
 		.realbits = LRADC_RESOLUTION,			\
@@ -929,7 +1018,8 @@ static int mxs_lradc_probe(struct platform_device *pdev)
 	struct resource *iores;
 	uint32_t ts_wires = 0;
 	int ret = 0;
-	int i;
+	int i, s;
+	unsigned int scale_uv;
 
 	/* Allocate the IIO device. */
 	iio = iio_device_alloc(sizeof(*lradc));
@@ -1008,6 +1098,26 @@ static int mxs_lradc_probe(struct platform_device *pdev)
 	if (ret)
 		goto err_trig;
 
+	/* Populate available ADC input ranges */
+	for (i = 0; i < LRADC_MAX_TOTAL_CHANS; i++) {
+		for (s = 0; s < ARRAY_SIZE(lradc->scale_avail[i]); s++) {
+			/*
+			 * [s=0] = optional divider by two disabled (default)
+			 * [s=1] = optional divider by two enabled
+			 *
+			 * The scale is calculated by doing:
+			 *   Vref >> (realbits - s)
+			 * which multiplies by two on the second component
+			 * of the array.
+			 */
+			scale_uv = ((u64)lradc->vref_mv[i] * 100000000) >>
+				   (iio->channels[i].scan_type.realbits - s);
+			lradc->scale_avail[i][s].nano =
+					do_div(scale_uv, 100000000) * 10;
+			lradc->scale_avail[i][s].integer = scale_uv;
+		}
+	}
+
 	/* Configure the hardware. */
 	mxs_lradc_hw_init(lradc);
 
