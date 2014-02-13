Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752026AbaBMWjq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Feb 2014 17:39:46 -0500
Received: from mail-oa0-f73.google.com ([209.85.219.73]:43748 "EHLO
	mail-oa0-f73.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750932AbaBMWjp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Feb 2014 17:39:45 -0500
From: Doug Anderson <dianders@chromium.org>
To: Guenter Roeck <linux@roeck-us.net>, Jean Delvare <jdelvare@suse.de>
Cc: Doug Anderson <dianders@chromium.org>, lm-sensors@lm-sensors.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] hwmon: (ntc_thermistor): Avoid overflow
Date: Thu, 13 Feb 2014 14:39:34 -0800
Message-Id: <1392331174-12271-1-git-send-email-dianders@chromium.org>
X-Mailer: git-send-email 1.9.0.rc1.175.g0b1dcb5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The ntc thermistor code was doing math whose temporary result might
have overflowed 32-bits.  We need some casts in there to make it safe.

In one example I found:
- pullup_uV: 1800000
- result of iio_read_channel_raw: 3226
- 1800000 * 3226 => 0x15a1cbc80

Signed-off-by: Doug Anderson <dianders@chromium.org>
---
 drivers/hwmon/ntc_thermistor.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/hwmon/ntc_thermistor.c b/drivers/hwmon/ntc_thermistor.c
index 8c23203..8a17f01 100644
--- a/drivers/hwmon/ntc_thermistor.c
+++ b/drivers/hwmon/ntc_thermistor.c
@@ -145,7 +145,7 @@ struct ntc_data {
 static int ntc_adc_iio_read(struct ntc_thermistor_platform_data *pdata)
 {
 	struct iio_channel *channel = pdata->chan;
-	unsigned int result;
+	s64 result;
 	int val, ret;
 
 	ret = iio_read_channel_raw(channel, &val);
@@ -155,10 +155,10 @@ static int ntc_adc_iio_read(struct ntc_thermistor_platform_data *pdata)
 	}
 
 	/* unit: mV */
-	result = pdata->pullup_uv * val;
+	result = pdata->pullup_uv * (s64) val;
 	result >>= 12;
 
-	return result;
+	return (int)result;
 }
 
 static const struct of_device_id ntc_match[] = {
-- 
1.9.0.rc1.175.g0b1dcb5

