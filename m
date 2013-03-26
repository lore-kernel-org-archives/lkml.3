Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934761Ab3CZPVt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Mar 2013 11:21:49 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:53537 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934671Ab3CZPVq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Mar 2013 11:21:46 -0400
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Guenter Roeck <linux@roeck-us.net>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 018/150] hwmon: (pmbus/ltc2978) Fix temperature reporting
Date: Tue, 26 Mar 2013 15:18:37 +0000
Message-Id: <1364311249-14454-19-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1364311249-14454-1-git-send-email-luis.henriques@canonical.com>
References: <1364311249-14454-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.9 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Guenter Roeck <linux@roeck-us.net>

commit 8c958c703ef8804093437959221951eaf0e1e664 upstream.

On LTC2978, only READ_TEMPERATURE is supported. It reports
the internal junction temperature. This register is unpaged.

On LTC3880, READ_TEMPERATURE and READ_TEMPERATURE2 are supported.
READ_TEMPERATURE is paged and reports external temperatures.
READ_TEMPERATURE2 is unpaged and reports the internal junction
temperature.

Signed-off-by: Guenter Roeck <linux@roeck-us.net>
Acked-by: Jean Delvare <khali@linux-fr.org>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 drivers/hwmon/pmbus/ltc2978.c | 14 ++++++++------
 1 file changed, 8 insertions(+), 6 deletions(-)

diff --git a/drivers/hwmon/pmbus/ltc2978.c b/drivers/hwmon/pmbus/ltc2978.c
index a58de38..6d61307 100644
--- a/drivers/hwmon/pmbus/ltc2978.c
+++ b/drivers/hwmon/pmbus/ltc2978.c
@@ -59,7 +59,7 @@ enum chips { ltc2978, ltc3880 };
 struct ltc2978_data {
 	enum chips id;
 	int vin_min, vin_max;
-	int temp_min, temp_max;
+	int temp_min, temp_max[2];
 	int vout_min[8], vout_max[8];
 	int iout_max[2];
 	int temp2_max;
@@ -113,9 +113,10 @@ static int ltc2978_read_word_data_common(struct i2c_client *client, int page,
 		ret = pmbus_read_word_data(client, page,
 					   LTC2978_MFR_TEMPERATURE_PEAK);
 		if (ret >= 0) {
-			if (lin11_to_val(ret) > lin11_to_val(data->temp_max))
-				data->temp_max = ret;
-			ret = data->temp_max;
+			if (lin11_to_val(ret)
+			    > lin11_to_val(data->temp_max[page]))
+				data->temp_max[page] = ret;
+			ret = data->temp_max[page];
 		}
 		break;
 	case PMBUS_VIRT_RESET_VOUT_HISTORY:
@@ -266,7 +267,7 @@ static int ltc2978_write_word_data(struct i2c_client *client, int page,
 		break;
 	case PMBUS_VIRT_RESET_TEMP_HISTORY:
 		data->temp_min = 0x7bff;
-		data->temp_max = 0x7c00;
+		data->temp_max[page] = 0x7c00;
 		ret = ltc2978_clear_peaks(client, page, data->id);
 		break;
 	default:
@@ -323,7 +324,8 @@ static int ltc2978_probe(struct i2c_client *client,
 	data->vin_min = 0x7bff;
 	data->vin_max = 0x7c00;
 	data->temp_min = 0x7bff;
-	data->temp_max = 0x7c00;
+	for (i = 0; i < ARRAY_SIZE(data->temp_max); i++)
+		data->temp_max[i] = 0x7c00;
 	data->temp2_max = 0x7c00;
 
 	switch (data->id) {
-- 
1.8.1.2

