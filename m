Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754863Ab3FKLoK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Jun 2013 07:44:10 -0400
Received: from www.linutronix.de ([62.245.132.108]:33593 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755362Ab3FKLlY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Jun 2013 07:41:24 -0400
From: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
To: Lee Jones <lee.jones@linaro.org>, Samuel Ortiz <sameo@linux.intel.com>
Cc: =?UTF-8?q?Beno=C3=AEt=20Cousson?= <b-cousson@ti.com>,
        Tony Lindgren <tony@atomide.com>, Jonathan Cameron <jic23@cam.ac.uk>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Felipe Balbi <balbi@ti.com>, linux-kernel@vger.kernel.org,
        linux-omap@vger.kernel.org, linux-iio@vger.kernel.org,
        linux-input@vger.kernel.org,
        Pantelis Antoniou <panto@antoniou-consulting.com>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Subject: [PATCH 12/22] iio/ti_tscadc: provide datasheet_name and scan_type
Date: Tue, 11 Jun 2013 13:30:58 +0200
Message-Id: <1370950268-7224-13-git-send-email-bigeasy@linutronix.de>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1370950268-7224-1-git-send-email-bigeasy@linutronix.de>
References: <1370950268-7224-1-git-send-email-bigeasy@linutronix.de>
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Pantelis Antoniou <panto@antoniou-consulting.com>

This patch provides the members "datasheet_name" and scan_type. This is
the remaining part of the earlier patch where I (bigeasy) removed iio_map
because it is now supplied by the device tree.

Acked-by: Jonathan Cameron <jic23@kernel.org>
Signed-off-by: Pantelis Antoniou <panto@antoniou-consulting.com>
Signed-off-by: Felipe Balbi <balbi@ti.com>
[bigeasy: use static AIN[0-8] names, use kcalloc(), removed iio_map,
	patch description]
Signed-off-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
---
 drivers/iio/adc/ti_am335x_adc.c |   29 ++++++++++++++++++++++++-----
 1 file changed, 24 insertions(+), 5 deletions(-)

diff --git a/drivers/iio/adc/ti_am335x_adc.c b/drivers/iio/adc/ti_am335x_adc.c
index 2868c0c..9939810 100644
--- a/drivers/iio/adc/ti_am335x_adc.c
+++ b/drivers/iio/adc/ti_am335x_adc.c
@@ -24,6 +24,8 @@
 #include <linux/iio/iio.h>
 #include <linux/of.h>
 #include <linux/of_device.h>
+#include <linux/iio/machine.h>
+#include <linux/iio/driver.h>
 
 #include <linux/mfd/ti_am335x_tscadc.h>
 
@@ -84,29 +86,46 @@ static void tiadc_step_config(struct tiadc_device *adc_dev)
 	am335x_tsc_se_set(adc_dev->mfd_tscadc, step_en);
 }
 
+static const char * const chan_name_ain[] = {
+	"AIN0",
+	"AIN1",
+	"AIN2",
+	"AIN3",
+	"AIN4",
+	"AIN5",
+	"AIN6",
+	"AIN7",
+};
+
 static int tiadc_channel_init(struct iio_dev *indio_dev, int channels)
 {
+	struct tiadc_device *adc_dev = iio_priv(indio_dev);
 	struct iio_chan_spec *chan_array;
+	struct iio_chan_spec *chan;
 	int i;
 
 	indio_dev->num_channels = channels;
-	chan_array = kcalloc(indio_dev->num_channels,
+	chan_array = kcalloc(channels,
 			sizeof(struct iio_chan_spec), GFP_KERNEL);
-
 	if (chan_array == NULL)
 		return -ENOMEM;
 
-	for (i = 0; i < (indio_dev->num_channels); i++) {
-		struct iio_chan_spec *chan = chan_array + i;
+	chan = chan_array;
+	for (i = 0; i < channels; i++, chan++) {
+
 		chan->type = IIO_VOLTAGE;
 		chan->indexed = 1;
 		chan->channel = i;
 		chan->info_mask_separate = BIT(IIO_CHAN_INFO_RAW);
+		chan->datasheet_name = chan_name_ain[i];
+		chan->scan_type.sign = 'u';
+		chan->scan_type.realbits = 12;
+		chan->scan_type.storagebits = 32;
 	}
 
 	indio_dev->channels = chan_array;
 
-	return indio_dev->num_channels;
+	return 0;
 }
 
 static void tiadc_channels_remove(struct iio_dev *indio_dev)
-- 
1.7.10.4

