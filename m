Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752537Ab3CREgI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Mar 2013 00:36:08 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:33704 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752288Ab3CREbL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Mar 2013 00:31:11 -0400
Message-Id: <20130318042146.472232541@decadent.org.uk>
User-Agent: quilt/0.60-1
Date: Mon, 18 Mar 2013 04:22:06 +0000
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: akpm@linux-foundation.org, Guenter Roeck <linux@roeck-us.net>,
        Jean Delvare <khali@linux-fr.org>
Subject: [ 22/82] hwmon: (pmbus/ltc2978) Fix peak attribute handling
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

commit dbd712c2272764a536e29ad6841dba74989a39d9 upstream.

Peak attributes were not initialized and cleared correctly.
Also, temp2_max is only supported on page 0 and thus does not need to be
an array.

Signed-off-by: Guenter Roeck <linux@roeck-us.net>
Acked-by: Jean Delvare <khali@linux-fr.org>
[bwh: Backported to 3.2: adjust context]
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/hwmon/pmbus/ltc2978.c |   28 +++++++++++++++-------------
 1 file changed, 15 insertions(+), 13 deletions(-)

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
 
@@ -204,10 +204,9 @@ static int ltc3880_read_word_data(struct
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
@@ -248,11 +247,11 @@ static int ltc2978_write_word_data(struc
 
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
@@ -262,12 +261,12 @@ static int ltc2978_write_word_data(struc
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
@@ -323,10 +322,11 @@ static int ltc2978_probe(struct i2c_clie
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
@@ -338,7 +338,6 @@ static int ltc2978_probe(struct i2c_clie
 		for (i = 1; i < 8; i++) {
 			info->func[i] = PMBUS_HAVE_VOUT
 			  | PMBUS_HAVE_STATUS_VOUT;
-			data->vout_min[i] = 0xffff;
 		}
 		break;
 	case ltc3880:
@@ -354,12 +353,15 @@ static int ltc2978_probe(struct i2c_clie
 		  | PMBUS_HAVE_IOUT | PMBUS_HAVE_STATUS_IOUT
 		  | PMBUS_HAVE_POUT
 		  | PMBUS_HAVE_TEMP | PMBUS_HAVE_STATUS_TEMP;
-		data->vout_min[1] = 0xffff;
+		data->iout_max[0] = 0x7c00;
+		data->iout_max[1] = 0x7c00;
 		break;
 	default:
 		ret = -ENODEV;
 		goto err_mem;
 	}
+	for (i = 0; i < info->pages; i++)
+		data->vout_min[i] = 0xffff;
 
 	ret = pmbus_do_probe(client, id, info);
 	if (ret)


