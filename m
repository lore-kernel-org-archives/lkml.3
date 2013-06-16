Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756117Ab3FPWQh (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Jun 2013 18:16:37 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:46416 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755709Ab3FPWJG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Jun 2013 18:09:06 -0400
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC: akpm@linux-foundation.org, "Guenter Roeck" <linux@roeck-us.net>,
        "Jean Delvare" <khali@linux-fr.org>
Date: Sun, 16 Jun 2013 23:01:38 +0100
Message-ID: <lsq.1371420098.848835385@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
Subject: [63/83] hwmon: (adm1021) Strengthen chip detection for ADM1021,
 LM84 and MAX1617
In-Reply-To: <lsq.1371420097.958132574@decadent.org.uk>
X-SA-Exim-Connect-IP: 192.168.4.101
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2.47-rc1 review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/hwmon/adm1021.c |   58 ++++++++++++++++++++++++++++++++++++++++-------
 1 file changed, 50 insertions(+), 8 deletions(-)

--- a/drivers/hwmon/adm1021.c
+++ b/drivers/hwmon/adm1021.c
@@ -311,26 +311,68 @@ static int adm1021_detect(struct i2c_cli
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

