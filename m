Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756018AbaBTXxa (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Feb 2014 18:53:30 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:46074 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755981AbaBTXxY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Feb 2014 18:53:24 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Doug Anderson <dianders@chromium.org>,
        Guenter Roeck <linux@roeck-us.net>
Subject: [PATCH 3.13 32/99] hwmon: (ntc_thermistor) Avoid math overflow
Date: Thu, 20 Feb 2014 15:52:27 -0800
Message-Id: <20140220235119.154025023@linuxfoundation.org>
X-Mailer: git-send-email 1.9.0
In-Reply-To: <20140220235118.191692546@linuxfoundation.org>
References: <20140220235118.191692546@linuxfoundation.org>
User-Agent: quilt/0.61-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.13-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/hwmon/ntc_thermistor.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

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
@@ -155,10 +155,10 @@ static int ntc_adc_iio_read(struct ntc_t
 	}
 
 	/* unit: mV */
-	result = pdata->pullup_uv * val;
+	result = pdata->pullup_uv * (s64) val;
 	result >>= 12;
 
-	return result;
+	return (int)result;
 }
 
 static const struct of_device_id ntc_match[] = {


