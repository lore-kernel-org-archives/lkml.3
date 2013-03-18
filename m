Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752348Ab3CREpc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Mar 2013 00:45:32 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:33450 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751723Ab3CREaY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Mar 2013 00:30:24 -0400
Message-Id: <20130318042150.751715103@decadent.org.uk>
User-Agent: quilt/0.60-1
Date: Mon, 18 Mar 2013 04:22:51 +0000
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: akpm@linux-foundation.org, Guenter Roeck <linux@roeck-us.net>,
        Jean Delvare <khali@linux-fr.org>
Subject: [ 67/82] hwmon: (pmbus/ltc2978) Fix temperature reporting
In-Reply-To: <20130318042144.234468645@decadent.org.uk>
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:d98f:da4e:f620:7bea
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/hwmon/pmbus/ltc2978.c |   14 ++++++++------
 1 file changed, 8 insertions(+), 6 deletions(-)

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
@@ -113,9 +113,10 @@ static int ltc2978_read_word_data_common
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
@@ -266,7 +267,7 @@ static int ltc2978_write_word_data(struc
 		break;
 	case PMBUS_VIRT_RESET_TEMP_HISTORY:
 		data->temp_min = 0x7bff;
-		data->temp_max = 0x7c00;
+		data->temp_max[page] = 0x7c00;
 		ret = ltc2978_clear_peaks(client, page, data->id);
 		break;
 	default:
@@ -325,7 +326,8 @@ static int ltc2978_probe(struct i2c_clie
 	data->vin_min = 0x7bff;
 	data->vin_max = 0x7c00;
 	data->temp_min = 0x7bff;
-	data->temp_max = 0x7c00;
+	for (i = 0; i < ARRAY_SIZE(data->temp_max); i++)
+		data->temp_max[i] = 0x7c00;
 	data->temp2_max = 0x7c00;
 
 	switch (data->id) {


