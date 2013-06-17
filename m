Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754722Ab3FQRgD (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Jun 2013 13:36:03 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:50676 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754654Ab3FQRf6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Jun 2013 13:35:58 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Guenter Roeck <linux@roeck-us.net>, Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 54/84] hwmon: (adm1021) Strengthen chip detection for ADM1021, LM84 and MAX1617
Date: Mon, 17 Jun 2013 10:30:58 -0700
Message-Id: <1371490288-23167-55-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1371490288-23167-1-git-send-email-kamal@canonical.com>
References: <1371490288-23167-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.8.13.3 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Guenter Roeck <linux@roeck-us.net>

commit 591bfcfc334a003ba31c0deff03b22e73349939b upstream.

On a system with both MAX1617 and JC42 sensors, JC42 sensors can be misdetected
as LM84. Strengthen detection sufficiently enough to avoid this misdetection.
Also improve detection for ADM1021.

Modeled after chip detection code in sensors-detect command.

Signed-off-by: Guenter Roeck <linux@roeck-us.net>
Tested-by: Jean Delvare <khali@linux-fr.org>
Acked-by: Jean Delvare <khali@linux-fr.org>
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 drivers/hwmon/adm1021.c | 58 ++++++++++++++++++++++++++++++++++++++++++-------
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
1.8.1.2

