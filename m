Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753968AbaIRLxt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Sep 2014 07:53:49 -0400
Received: from mail-pa0-f52.google.com ([209.85.220.52]:49060 "EHLO
	mail-pa0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752198AbaIRLxq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Sep 2014 07:53:46 -0400
From: Sanchayan Maity <maitysanchayan@gmail.com>
To: shawn.guo@freescale.com
Cc: stefan@agner.ch, jic23@kernel.org, B38611@freescale.com,
        linux-iio@vger.kernel.org, linux-kernel@vger.kernel.org,
        Sanchayan Maity <maitysanchayan@gmail.com>
Subject: =?UTF-8?q?=5BPATCH=20v2=5D=20ARM=3A=20imx=3A=20vf610-adc=3A=20Add=20temperature=20sensor=20support?=
Date: Thu, 18 Sep 2014 17:23:23 +0530
Message-Id: <c5c79290b29e416c4afffe298d9a2a25b00a1f75.1411039381.git.maitysanchayan@gmail.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <cover.1411039381.git.maitysanchayan@gmail.com>
References: <cover.1411039381.git.maitysanchayan@gmail.com>
In-Reply-To: <cover.1411039381.git.maitysanchayan@gmail.com>
References: <cover.1411039381.git.maitysanchayan@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Vybrid ADC peripheral includes a temperature sensor
which is connected to channel number 26. This patch
adds support for the sensor. The raw value is read
and the temperature calculated in milli degree Celsius,
which is returned using IIO_CHAN_INFO_PROCESSED option.

Signed-off-by: Sanchayan Maity <maitysanchayan@gmail.com>
---
 drivers/iio/adc/vf610_adc.c |   28 ++++++++++++++++++++++++++--
 1 file changed, 26 insertions(+), 2 deletions(-)

diff --git a/drivers/iio/adc/vf610_adc.c b/drivers/iio/adc/vf610_adc.c
index 44799eb5..cec257d 100644
--- a/drivers/iio/adc/vf610_adc.c
+++ b/drivers/iio/adc/vf610_adc.c
@@ -91,7 +91,7 @@
 #define VF610_ADC_CAL			0x80
 
 /* Other field define */
-#define VF610_ADC_ADCHC(x)		((x) & 0xF)
+#define VF610_ADC_ADCHC(x)		((x) & 0x1F)
 #define VF610_ADC_AIEN			(0x1 << 7)
 #define VF610_ADC_CONV_DISABLE		0x1F
 #define VF610_ADC_HS_COCO0		0x1
@@ -153,6 +153,12 @@ struct vf610_adc {
 				BIT(IIO_CHAN_INFO_SAMP_FREQ),	\
 }
 
+#define VF610_ADC_TEMPERATURE_CHAN(_idx, _chan_type) {	\
+	.type = (_chan_type),			\
+	.channel = (_idx),				\
+	.info_mask_separate = BIT(IIO_CHAN_INFO_PROCESSED),	\
+}
+
 static const struct iio_chan_spec vf610_adc_iio_channels[] = {
 	VF610_ADC_CHAN(0, IIO_VOLTAGE),
 	VF610_ADC_CHAN(1, IIO_VOLTAGE),
@@ -170,6 +176,7 @@ static const struct iio_chan_spec vf610_adc_iio_channels[] = {
 	VF610_ADC_CHAN(13, IIO_VOLTAGE),
 	VF610_ADC_CHAN(14, IIO_VOLTAGE),
 	VF610_ADC_CHAN(15, IIO_VOLTAGE),
+	VF610_ADC_TEMPERATURE_CHAN(26, IIO_TEMP),
 	/* sentinel */
 };
 
@@ -451,6 +458,7 @@ static int vf610_read_raw(struct iio_dev *indio_dev,
 
 	switch (mask) {
 	case IIO_CHAN_INFO_RAW:
+	case IIO_CHAN_INFO_PROCESSED:
 		mutex_lock(&indio_dev->mlock);
 		reinit_completion(&info->completion);
 
@@ -468,7 +476,23 @@ static int vf610_read_raw(struct iio_dev *indio_dev,
 			return ret;
 		}
 
-		*val = info->value;
+		switch (chan->type)	{
+		case IIO_VOLTAGE:
+			*val = info->value;
+			break;
+		case IIO_TEMP:
+			/*
+			* Calculate in degree Celsius times 1000
+			* Using sensor slope of 1.84 mV/°C and
+			* V at 25°C of 696mv
+			*/
+			*val = 25000 - ((int)info->value - 864) * 1000000 / 1840;
+			break;
+		default:
+			mutex_unlock(&indio_dev->mlock);
+			return -EINVAL;
+		}
+
 		mutex_unlock(&indio_dev->mlock);
 		return IIO_VAL_INT;
 
-- 
1.7.9.5

