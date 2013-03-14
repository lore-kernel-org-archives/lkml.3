Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757321Ab3CNKiH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Mar 2013 06:38:07 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:52021 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756852Ab3CNKiA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Mar 2013 06:38:00 -0400
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Guenter Roeck <linux@roeck-us.net>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 64/88] hwmon: (pmbus/ltc2978) Fix peak attribute handling
Date: Thu, 14 Mar 2013 10:35:57 +0000
Message-Id: <1363257381-15900-65-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1363257381-15900-1-git-send-email-luis.henriques@canonical.com>
References: <1363257381-15900-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.8 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Guenter Roeck <linux@roeck-us.net>

commit dbd712c2272764a536e29ad6841dba74989a39d9 upstream.

Peak attributes were not initialized and cleared correctly.
Also, temp2_max is only supported on page 0 and thus does not need to be
an array.

Signed-off-by: Guenter Roeck <linux@roeck-us.net>
Acked-by: Jean Delvare <khali@linux-fr.org>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 drivers/hwmon/pmbus/ltc2978.c | 28 +++++++++++++++-------------
 1 file changed, 15 insertions(+), 13 deletions(-)

diff --git a/drivers/hwmon/pmbus/ltc2978.c b/drivers/hwmon/pmbus/ltc2978.c
index 9652a2c..cc29a7e 100644
--- a/drivers/hwmon/pmbus/ltc2978.c
+++ b/drivers/hwmon/pmbus/ltc2978.c
@@ -62,7 +62,7 @@ struct ltc2978_data {
 	int temp_min, temp_max;
 	int vout_min[8], vout_max[8];
 	int iout_max[2];
-	int temp2_max[2];
+	int temp2_max;
 	struct pmbus_driver_info info;
 };
 
@@ -204,10 +204,9 @@ static int ltc3880_read_word_data(struct i2c_client *client, int page, int reg)
 		ret = pmbus_read_word_data(client, page,
 					   LTC3880_MFR_TEMPERATURE2_PEAK);
 		if (ret >= 0) {
-			if (lin11_to_val(ret)
-			    > lin11_to_val(data->temp2_max[page]))
-				data->temp2_max[page] = ret;
-			ret = data->temp2_max[page];
+			if (lin11_to_val(ret) > lin11_to_val(data->temp2_max))
+				data->temp2_max = ret;
+			ret = data->temp2_max;
 		}
 		break;
 	case PMBUS_VIRT_READ_VIN_MIN:
@@ -248,11 +247,11 @@ static int ltc2978_write_word_data(struct i2c_client *client, int page,
 
 	switch (reg) {
 	case PMBUS_VIRT_RESET_IOUT_HISTORY:
-		data->iout_max[page] = 0x7fff;
+		data->iout_max[page] = 0x7c00;
 		ret = ltc2978_clear_peaks(client, page, data->id);
 		break;
 	case PMBUS_VIRT_RESET_TEMP2_HISTORY:
-		data->temp2_max[page] = 0x7fff;
+		data->temp2_max = 0x7c00;
 		ret = ltc2978_clear_peaks(client, page, data->id);
 		break;
 	case PMBUS_VIRT_RESET_VOUT_HISTORY:
@@ -262,12 +261,12 @@ static int ltc2978_write_word_data(struct i2c_client *client, int page,
 		break;
 	case PMBUS_VIRT_RESET_VIN_HISTORY:
 		data->vin_min = 0x7bff;
-		data->vin_max = 0;
+		data->vin_max = 0x7c00;
 		ret = ltc2978_clear_peaks(client, page, data->id);
 		break;
 	case PMBUS_VIRT_RESET_TEMP_HISTORY:
 		data->temp_min = 0x7bff;
-		data->temp_max = 0x7fff;
+		data->temp_max = 0x7c00;
 		ret = ltc2978_clear_peaks(client, page, data->id);
 		break;
 	default:
@@ -321,10 +320,11 @@ static int ltc2978_probe(struct i2c_client *client,
 	info = &data->info;
 	info->write_word_data = ltc2978_write_word_data;
 
-	data->vout_min[0] = 0xffff;
 	data->vin_min = 0x7bff;
+	data->vin_max = 0x7c00;
 	data->temp_min = 0x7bff;
-	data->temp_max = 0x7fff;
+	data->temp_max = 0x7c00;
+	data->temp2_max = 0x7c00;
 
 	switch (id->driver_data) {
 	case ltc2978:
@@ -336,7 +336,6 @@ static int ltc2978_probe(struct i2c_client *client,
 		for (i = 1; i < 8; i++) {
 			info->func[i] = PMBUS_HAVE_VOUT
 			  | PMBUS_HAVE_STATUS_VOUT;
-			data->vout_min[i] = 0xffff;
 		}
 		break;
 	case ltc3880:
@@ -352,11 +351,14 @@ static int ltc2978_probe(struct i2c_client *client,
 		  | PMBUS_HAVE_IOUT | PMBUS_HAVE_STATUS_IOUT
 		  | PMBUS_HAVE_POUT
 		  | PMBUS_HAVE_TEMP | PMBUS_HAVE_STATUS_TEMP;
-		data->vout_min[1] = 0xffff;
+		data->iout_max[0] = 0x7c00;
+		data->iout_max[1] = 0x7c00;
 		break;
 	default:
 		return -ENODEV;
 	}
+	for (i = 0; i < info->pages; i++)
+		data->vout_min[i] = 0xffff;
 
 	return pmbus_do_probe(client, id, info);
 }
-- 
1.8.1.2

