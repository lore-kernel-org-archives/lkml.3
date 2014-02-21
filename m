Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932855AbaBUM4Q (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Feb 2014 07:56:16 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:47289 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932618AbaBUMvn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Feb 2014 07:51:43 -0500
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Doug Anderson <dianders@chromium.org>, Guenter Roeck <linux@roeck-us.net>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.11 110/121] hwmon: (ntc_thermistor) Avoid math overflow
Date: Fri, 21 Feb 2014 12:48:54 +0000
Message-Id: <1392986945-9693-111-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.9.0
In-Reply-To: <1392986945-9693-1-git-send-email-luis.henriques@canonical.com>
References: <1392986945-9693-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.11.10.5 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Doug Anderson <dianders@chromium.org>

commit d3d89c468ceebbcf9423d1a3d66c5bf91f569570 upstream.

The ntc thermistor code was doing math whose temporary result might
have overflowed 32-bits.  We need some casts in there to make it safe.

In one example I found:
- pullup_uV: 1800000
- result of iio_read_channel_raw: 3226
- 1800000 * 3226 => 0x15a1cbc80

Signed-off-by: Doug Anderson <dianders@chromium.org>
Signed-off-by: Guenter Roeck <linux@roeck-us.net>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 drivers/hwmon/ntc_thermistor.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/hwmon/ntc_thermistor.c b/drivers/hwmon/ntc_thermistor.c
index 830a842..4a80a54 100644
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
1.9.0

