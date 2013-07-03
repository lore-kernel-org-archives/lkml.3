Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965247Ab3GCTHt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Jul 2013 15:07:49 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:23390 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964999Ab3GCTA2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Jul 2013 15:00:28 -0400
X-Authority-Analysis: v=2.0 cv=Odoa/2vY c=1 sm=0 a=Sro2XwOs0tJUSHxCKfOySw==:17 a=Drc5e87SC40A:10 a=Ciwy3NGCPMMA:10 a=bygFwn_TynUA:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=meVymXHHAAAA:8 a=KGjhK52YXX0A:10 a=d0buGDwfKj0A:10 a=_jlGtV7tAAAA:8 a=VwQbUJbxAAAA:8 a=8HAeRkdQAAAA:8 a=YR-lPSw5Bx-EAoLxiUgA:9 a=L1RTw_NLzc0A:10 a=-4xtSMBTtIIA:10 a=jeBq3FmKZ4MA:10 a=Sro2XwOs0tJUSHxCKfOySw==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 67.255.60.225
Message-Id: <20130703184101.801300814@goodmis.org>
User-Agent: quilt/0.60-1
Date: Wed, 03 Jul 2013 14:40:33 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Guenter Roeck <linux@roeck-us.net>, Jean Delvare <khali@linux-fr.org>
Subject: [096/141] hwmon: (adm1021) Strengthen chip detection for ADM1021, LM84 and
 MAX1617
References: <20130703183857.307196999@goodmis.org>
Content-Disposition: inline; filename=0096-hwmon-adm1021-Strengthen-chip-detection-for-ADM1021-.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.6.11.6 stable review patch.
If anyone has any objections, please let me know.

------------------

From: Guenter Roeck <linux@roeck-us.net>

[ Upstream commit 591bfcfc334a003ba31c0deff03b22e73349939b ]

On a system with both MAX1617 and JC42 sensors, JC42 sensors can be misdetected
as LM84. Strengthen detection sufficiently enough to avoid this misdetection.
Also improve detection for ADM1021.

Modeled after chip detection code in sensors-detect command.

Cc: stable@vger.kernel.org
Signed-off-by: Guenter Roeck <linux@roeck-us.net>
Tested-by: Jean Delvare <khali@linux-fr.org>
Acked-by: Jean Delvare <khali@linux-fr.org>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 drivers/hwmon/adm1021.c |   58 ++++++++++++++++++++++++++++++++++++++++-------
 1 file changed, 50 insertions(+), 8 deletions(-)

diff --git a/drivers/hwmon/adm1021.c b/drivers/hwmon/adm1021.c
index fd1d1b1..f9df316 100644
--- a/drivers/hwmon/adm1021.c
+++ b/drivers/hwmon/adm1021.c
@@ -332,26 +332,68 @@ static int adm1021_detect(struct i2c_client *client,
 	man_id = i2c_smbus_read_byte_data(client, ADM1021_REG_MAN_ID);
 	dev_id = i2c_smbus_read_byte_data(client, ADM1021_REG_DEV_ID);
 
+	if (man_id < 0 || dev_id < 0)
+		return -ENODEV;
+
 	if (man_id == 0x4d && dev_id == 0x01)
 		type_name = "max1617a";
 	else if (man_id == 0x41) {
 		if ((dev_id & 0xF0) == 0x30)
 			type_name = "adm1023";
-		else
+		else if ((dev_id & 0xF0) == 0x00)
 			type_name = "adm1021";
+		else
+			return -ENODEV;
 	} else if (man_id == 0x49)
 		type_name = "thmc10";
 	else if (man_id == 0x23)
 		type_name = "gl523sm";
 	else if (man_id == 0x54)
 		type_name = "mc1066";
-	/* LM84 Mfr ID in a different place, and it has more unused bits */
-	else if (conv_rate == 0x00
-		 && (config & 0x7F) == 0x00
-		 && (status & 0xAB) == 0x00)
-		type_name = "lm84";
-	else
-		type_name = "max1617";
+	else {
+		int lte, rte, lhi, rhi, llo, rlo;
+
+		/* extra checks for LM84 and MAX1617 to avoid misdetections */
+
+		llo = i2c_smbus_read_byte_data(client, ADM1021_REG_THYST_R(0));
+		rlo = i2c_smbus_read_byte_data(client, ADM1021_REG_THYST_R(1));
+
+		/* fail if any of the additional register reads failed */
+		if (llo < 0 || rlo < 0)
+			return -ENODEV;
+
+		lte = i2c_smbus_read_byte_data(client, ADM1021_REG_TEMP(0));
+		rte = i2c_smbus_read_byte_data(client, ADM1021_REG_TEMP(1));
+		lhi = i2c_smbus_read_byte_data(client, ADM1021_REG_TOS_R(0));
+		rhi = i2c_smbus_read_byte_data(client, ADM1021_REG_TOS_R(1));
+
+		/*
+		 * Fail for negative temperatures and negative high limits.
+		 * This check also catches read errors on the tested registers.
+		 */
+		if ((s8)lte < 0 || (s8)rte < 0 || (s8)lhi < 0 || (s8)rhi < 0)
+			return -ENODEV;
+
+		/* fail if all registers hold the same value */
+		if (lte == rte && lte == lhi && lte == rhi && lte == llo
+		    && lte == rlo)
+			return -ENODEV;
+
+		/*
+		 * LM84 Mfr ID is in a different place,
+		 * and it has more unused bits.
+		 */
+		if (conv_rate == 0x00
+		    && (config & 0x7F) == 0x00
+		    && (status & 0xAB) == 0x00) {
+			type_name = "lm84";
+		} else {
+			/* fail if low limits are larger than high limits */
+			if ((s8)llo > lhi || (s8)rlo > rhi)
+				return -ENODEV;
+			type_name = "max1617";
+		}
+	}
 
 	pr_debug("adm1021: Detected chip %s at adapter %d, address 0x%02x.\n",
 		 type_name, i2c_adapter_id(adapter), client->addr);
-- 
1.7.10.4


