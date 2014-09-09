Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932257AbaIIJRb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Sep 2014 05:17:31 -0400
Received: from par-mail.meas-spec.com ([198.190.228.178]:50446 "EHLO
	PAR-MAIL.MEAS-SPEC.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756203AbaIIJR2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Sep 2014 05:17:28 -0400
X-Greylist: delayed 386 seconds by postgrey-1.27 at vger.kernel.org; Tue, 09 Sep 2014 05:17:28 EDT
From: "Markezana, William" <William.Markezana@meas-spec.com>
To: Bernhard Walle <bernhard@bwalle.de>,
        "linux@roeck-us.net" <linux@roeck-us.net>
CC: "jdelvare@suse.de" <jdelvare@suse.de>,
        "lm-sensors@lm-sensors.org" <lm-sensors@lm-sensors.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH] hwmon: (htu21) Use the nohold mode to read out values
Thread-Topic: [PATCH] hwmon: (htu21) Use the nohold mode to read out values
Thread-Index: AQHPzAwYagoJ93xgNU24toXXap+sPpv4ghAQ
Date: Tue, 9 Sep 2014 09:10:59 +0000
Message-ID: <8B5E2C57A478A447A3ECC506FBF26C03033832@TLSE-SVR-MAIL01.europe.msiusa.com>
References: <1410253044-2354-1-git-send-email-bernhard@bwalle.de>
In-Reply-To: <1410253044-2354-1-git-send-email-bernhard@bwalle.de>
Accept-Language: fr-FR, en-US
Content-Language: fr-FR
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [172.16.73.14]
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id s899HZCf004839

Hi Bernhard,

This is a well-known issue on the Raspberry Pi whose i2c stretching timeout is too short to allow proper HTU21 conversion.
See this discussion over here which provides a patch to allow hold master mode on the Raspberry Pi: https://github.com/raspberrypi/linux/issues/211 

We will soon publish a new version of the HTU21 driver which provides a lot of new features including both hold master and no hold measurement modes support.

Best regards,

William MARKEZANA
Advanced Development
MEAS France 
Impasse Jeanne Benozzi
CS 83163
31027 Toulouse Cedex 3
DirectÂ : + 33 (0) 582 082 286
Fax : + 33 (0) 582 082 151
william.markezana@meas-spec.com
http://www.meas-spec.com

-----Message d'origine-----
DeÂ : Bernhard Walle [mailto:bernhard@bwalle.de] 
EnvoyÃ©Â : mardi 9 septembre 2014 10:57
Ã€Â : Markezana, William; linux@roeck-us.net
CcÂ : jdelvare@suse.de; lm-sensors@lm-sensors.org; linux-kernel@vger.kernel.org; Bernhard Walle
ObjetÂ : [PATCH] hwmon: (htu21) Use the nohold mode to read out values

On my Raspberry Pi, the driver doesn't work. Every read fails with -EIO.
Reading the data sheet and experimenting a bit made me finding out that using the nohold mode works. The Raspberry Pi IÂ²C chip seems to have problems with slaves blocking the SCK line.

In any case, freeing the bus while performing the measurement seems to be the better way, I think.

Signed-off-by: Bernhard Walle <bernhard@bwalle.de>
---
 drivers/hwmon/htu21.c | 52 +++++++++++++++++++++++++++++++++++++++++++++------
 1 file changed, 46 insertions(+), 6 deletions(-)

diff --git a/drivers/hwmon/htu21.c b/drivers/hwmon/htu21.c index 839086e..7defae2 100644
--- a/drivers/hwmon/htu21.c
+++ b/drivers/hwmon/htu21.c
@@ -25,10 +25,11 @@
 #include <linux/mutex.h>
 #include <linux/device.h>
 #include <linux/jiffies.h>
+#include <linux/delay.h>
 
 /* HTU21 Commands */
-#define HTU21_T_MEASUREMENT_HM	0xE3
-#define HTU21_RH_MEASUREMENT_HM	0xE5
+#define HTU21_T_MEASUREMENT_HM_NOHOLD	0xF3
+#define HTU21_RH_MEASUREMENT_HM_NOHOLD	0xF5
 
 struct htu21 {
 	struct device *hwmon_dev;
@@ -59,6 +60,47 @@ static inline int htu21_rh_ticks_to_per_cent_mille(int ticks)
 	return ((15625 * ticks) >> 13) - 6000;  }
 
+/* retry for one second, then give up */ #define MAX_RETRIES 20
+
+static int htu21_read_word(struct i2c_client *client, u8 command) {
+	char data[2];
+	int ret, i;
+
+	/* start the measurement */
+	ret = i2c_master_send(client, &command, sizeof(command));
+	if (ret < 0) {
+		dev_err(&client->dev, "Unable to send command 0x%hhx: %d\n",
+				command, ret);
+		return ret;
+	}
+
+	/*
+	 * Now poll until we get the data. On I2C level the device sends a NAK
+	 * until it is ready
+	 */
+
+	msleep(50);
+
+	for (i = 0; i < MAX_RETRIES; i++) {
+		ret = i2c_master_recv(client, data, sizeof(data));
+		if (ret == sizeof(data))
+			break;
+
+		msleep(50);
+	}
+
+	if (ret < 0) {
+		dev_err(&client->dev, "Unable to receive result from command 0x%hhx: %d\n",
+				command, ret);
+		return ret;
+	}
+
+	return (data[0] << 8) | data[1];
+}
+
+
 static int htu21_update_measurements(struct i2c_client *client)  {
 	int ret = 0;
@@ -68,13 +110,11 @@ static int htu21_update_measurements(struct i2c_client *client)
 
 	if (time_after(jiffies, htu21->last_update + HZ / 2) ||
 	    !htu21->valid) {
-		ret = i2c_smbus_read_word_swapped(client,
-						  HTU21_T_MEASUREMENT_HM);
+		ret = htu21_read_word(client, HTU21_T_MEASUREMENT_HM_NOHOLD);
 		if (ret < 0)
 			goto out;
 		htu21->temperature = htu21_temp_ticks_to_millicelsius(ret);
-		ret = i2c_smbus_read_word_swapped(client,
-						  HTU21_RH_MEASUREMENT_HM);
+		ret = htu21_read_word(client, HTU21_RH_MEASUREMENT_HM_NOHOLD);
 		if (ret < 0)
 			goto out;
 		htu21->humidity = htu21_rh_ticks_to_per_cent_mille(ret);
--
2.1.0

ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
