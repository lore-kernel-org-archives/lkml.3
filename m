Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753319AbbALNrc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Jan 2015 08:47:32 -0500
Received: from mail-wi0-f170.google.com ([209.85.212.170]:52999 "EHLO
	mail-wi0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753219AbbALNrb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Jan 2015 08:47:31 -0500
From: Bartosz Golaszewski <bgolaszewski@baylibre.com>
To: Guenter Roeck <linux@roeck-us.net>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Benoit Cousson <bcousson@baylibre.com>,
        Patrick Titiano <ptitiano@baylibre.com>,
        LM Sensors <lm-sensors@lm-sensors.org>,
        Bartosz Golaszewski <bgolaszewski@baylibre.com>
Subject: [PATCH 2/2] hwmon: (ina2xx) use DIV_ROUND_CLOSEST() to avoid rounding errors
Date: Mon, 12 Jan 2015 14:47:22 +0100
Message-Id: <1421070442-9635-3-git-send-email-bgolaszewski@baylibre.com>
X-Mailer: git-send-email 2.1.3
In-Reply-To: <1421070442-9635-1-git-send-email-bgolaszewski@baylibre.com>
References: <1421070442-9635-1-git-send-email-bgolaszewski@baylibre.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use DIV_ROUND_CLOSEST() when dealing with the calibration values to make the
calculations less error prone.

Signed-off-by: Bartosz Golaszewski <bgolaszewski@baylibre.com>
---
 drivers/hwmon/ina2xx.c | 10 +++++++---
 1 file changed, 7 insertions(+), 3 deletions(-)

diff --git a/drivers/hwmon/ina2xx.c b/drivers/hwmon/ina2xx.c
index ae110c5..611ec4e 100644
--- a/drivers/hwmon/ina2xx.c
+++ b/drivers/hwmon/ina2xx.c
@@ -186,8 +186,11 @@ static void ina226_set_update_interval(struct ina2xx_data *data)
 
 static int ina2xx_calibrate(struct ina2xx_data *data)
 {
-	return i2c_smbus_write_word_swapped(data->client, INA2XX_CALIBRATION,
-			data->config->calibration_factor / data->rshunt);
+	u16 val = DIV_ROUND_CLOSEST(data->config->calibration_factor,
+				    data->rshunt);
+
+	return i2c_smbus_write_word_swapped(data->client,
+					    INA2XX_CALIBRATION, val);
 }
 
 /*
@@ -307,7 +310,8 @@ static int ina2xx_get_value(struct ina2xx_data *data, u8 reg)
 		val = (s16)data->regs[reg];
 		break;
 	case INA2XX_CALIBRATION:
-		val = data->config->calibration_factor / data->regs[reg];
+		val = DIV_ROUND_CLOSEST(data->config->calibration_factor,
+					data->regs[reg]);
 		break;
 	default:
 		/* programmer goofed */
-- 
2.1.3

