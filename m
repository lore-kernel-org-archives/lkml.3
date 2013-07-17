Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933374Ab3GQRcg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Jul 2013 13:32:36 -0400
Received: from mail-ea0-f171.google.com ([209.85.215.171]:53429 "EHLO
	mail-ea0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756713Ab3GQR1A (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Jul 2013 13:27:00 -0400
From: Zubair Lutfullah <zubair.lutfullah@gmail.com>
To: jic23@cam.ac.uk
Cc: linux-iio@vger.kernel.org, gregkh@linuxfoundation.org,
        linux-kernel@vger.kernel.org, koen@dominion.thruhere.net,
        zubair.lutfullah@gmail.com
Subject: [PATCH 03/21] iio: ti_am335x_adc: Added iio_voltageX_scale
Date: Wed, 17 Jul 2013 18:26:32 +0100
Message-Id: <1374082010-28095-4-git-send-email-zubair.lutfullah@gmail.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1374082010-28095-1-git-send-email-zubair.lutfullah@gmail.com>
References: <1374082010-28095-1-git-send-email-zubair.lutfullah@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

in_voltageX_scale is supposed to give scaled voltages. This was
missing in the driver and has been added.
Current patch is fixed to scale for 1.8V AVDD.

Signed-off-by: Zubair Lutfullah <zubair.lutfullah@gmail.com>
---
 drivers/iio/adc/ti_am335x_adc.c |   17 +++++++++++++++--
 1 file changed, 15 insertions(+), 2 deletions(-)

diff --git a/drivers/iio/adc/ti_am335x_adc.c b/drivers/iio/adc/ti_am335x_adc.c
index 1f83cf7..8a63203 100644
--- a/drivers/iio/adc/ti_am335x_adc.c
+++ b/drivers/iio/adc/ti_am335x_adc.c
@@ -26,7 +26,7 @@
 #include <linux/of_device.h>
 #include <linux/iio/machine.h>
 #include <linux/iio/driver.h>
-
+#include <linux/math64.h>
 #include <linux/mfd/ti_am335x_tscadc.h>
 
 struct tiadc_device {
@@ -118,7 +118,8 @@ static int tiadc_channel_init(struct iio_dev *indio_dev, int channels)
 		chan->type = IIO_VOLTAGE;
 		chan->indexed = 1;
 		chan->channel = adc_dev->channel_line[i];
-		chan->info_mask_separate = BIT(IIO_CHAN_INFO_RAW);
+		chan->info_mask_separate = BIT(IIO_CHAN_INFO_RAW) |
+						BIT(IIO_CHAN_INFO_SCALE);
 		chan->datasheet_name = chan_name_ain[chan->channel];
 		chan->scan_type.sign = 'u';
 		chan->scan_type.realbits = 12;
@@ -190,6 +191,18 @@ static int tiadc_read_raw(struct iio_dev *indio_dev,
 		}
 	}
 
+	switch (mask){
+		case IIO_CHAN_INFO_RAW : /*Do nothing. Above code works fine.*/
+					break;
+		case IIO_CHAN_INFO_SCALE : {
+			/*12 Bit adc. Scale value for 1800mV AVDD. Ideally
+			AVDD should come from DT.*/
+			*val = div_u64( (u64)(*val) * 1800 , 4096);
+			break;
+		}
+		default: break;
+	}
+
 	if (found == false)
 		return -EBUSY;
 	return IIO_VAL_INT;
-- 
1.7.9.5

