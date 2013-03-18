Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933312Ab3CRVb3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Mar 2013 17:31:29 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:45855 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932121Ab3CRVHy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Mar 2013 17:07:54 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Guenter Roeck <linux@roeck-us.net>, Jean Delvare <khali@linux-fr.org>
Subject: [ 19/48] hwmon: (pmbus/ltc2978) Fix temperature reporting
Date: Mon, 18 Mar 2013 14:08:27 -0700
Message-Id: <20130318210811.610633553@linuxfoundation.org>
X-Mailer: git-send-email 1.8.1.2.434.g9a6c84e.dirty
In-Reply-To: <20130318210810.247845918@linuxfoundation.org>
References: <20130318210810.247845918@linuxfoundation.org>
User-Agent: quilt/0.60-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.4-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

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
@@ -323,7 +324,8 @@ static int ltc2978_probe(struct i2c_clie
 	data->vin_min = 0x7bff;
 	data->vin_max = 0x7c00;
 	data->temp_min = 0x7bff;
-	data->temp_max = 0x7c00;
+	for (i = 0; i < ARRAY_SIZE(data->temp_max); i++)
+		data->temp_max[i] = 0x7c00;
 	data->temp2_max = 0x7c00;
 
 	switch (data->id) {


