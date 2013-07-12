Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757201Ab3GLHtj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Jul 2013 03:49:39 -0400
Received: from hqemgate03.nvidia.com ([216.228.121.140]:1898 "EHLO
	hqemgate03.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755798Ab3GLHti (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Jul 2013 03:49:38 -0400
X-PGP-Universal: processed;
	by hqnvupgp07.nvidia.com on Fri, 12 Jul 2013 00:48:29 -0700
From: Wei Ni <wni@nvidia.com>
To: <khali@linux-fr.org>, <linux@roeck-us.net>, <thierry.reding@gmail.com>
CC: <lm-sensors@lm-sensors.org>, <linux-kernel@vger.kernel.org>,
        <linux-tegra@vger.kernel.org>, Wei Ni <wni@nvidia.com>
Subject: [PATCH v3 2/4] hwmon: (lm90) use macro defines for the status bit
Date: Fri, 12 Jul 2013 15:48:05 +0800
Message-ID: <1373615287-18502-3-git-send-email-wni@nvidia.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1373615287-18502-1-git-send-email-wni@nvidia.com>
References: <1373615287-18502-1-git-send-email-wni@nvidia.com>
X-NVConfidentiality: public
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add bit defines for the status register.

Signed-off-by: Wei Ni <wni@nvidia.com>
---
 drivers/hwmon/lm90.c |   72 ++++++++++++++++++++++++++++++++++----------------
 1 file changed, 49 insertions(+), 23 deletions(-)

diff --git a/drivers/hwmon/lm90.c b/drivers/hwmon/lm90.c
index 5f30f90..c90037f 100644
--- a/drivers/hwmon/lm90.c
+++ b/drivers/hwmon/lm90.c
@@ -179,6 +179,19 @@ enum chips { lm90, adm1032, lm99, lm86, max6657, max6659, adt7461, max6680,
 #define LM90_HAVE_TEMP3		(1 << 6) /* 3rd temperature sensor	*/
 #define LM90_HAVE_BROKEN_ALERT	(1 << 7) /* Broken alert		*/
 
+/* LM90 status */
+#define LM90_STATUS_LTHRM	(1 << 0) /* local THERM limit tripped */
+#define LM90_STATUS_RTHRM	(1 << 1) /* remote THERM limit tripped */
+#define LM90_STATUS_OPEN	(1 << 2) /* remote is an open circuit */
+#define LM90_STATUS_RLOW	(1 << 3) /* remote low temp limit tripped */
+#define LM90_STATUS_RHIGH	(1 << 4) /* remote high temp limit tripped */
+#define LM90_STATUS_LLOW	(1 << 5) /* local low temp limit tripped */
+#define LM90_STATUS_LHIGH	(1 << 6) /* local high temp limit tripped */
+#define LM90_STATUS_BUSY	(1 << 7) /* ADC is converting */
+
+#define MAX6696_STATUS2_RLOW	(1 << 3) /* remote2 low temp limit tripped */
+#define MAX6696_STATUS2_RHIGH	(1 << 4) /* remote2 high temp limit tripped */
+
 /*
  * Driver data (common to all clients)
  */
@@ -1417,6 +1430,36 @@ static void lm90_init_client(struct i2c_client *client)
 		i2c_smbus_write_byte_data(client, LM90_REG_W_CONFIG1, config);
 }
 
+static bool lm90_is_tripped(struct i2c_client *client)
+{
+	struct lm90_data *data = i2c_get_clientdata(client);
+	u8 status, status2 = 0;
+
+	lm90_read_reg(client, LM90_REG_R_STATUS, &status);
+
+	if (data->kind == max6696)
+		lm90_read_reg(client, MAX6696_REG_R_STATUS2, &status2);
+
+	if ((status & 0x7f) == 0 && (status2 & 0xfe) == 0)
+		return false;
+
+	if (status & (LM90_STATUS_LLOW | LM90_STATUS_LHIGH | LM90_STATUS_LTHRM))
+		dev_warn(&client->dev,
+			 "temp%d out of range, please check!\n", 1);
+	if (status & (LM90_STATUS_RLOW | LM90_STATUS_RHIGH | LM90_STATUS_RTHRM))
+		dev_warn(&client->dev,
+			 "temp%d out of range, please check!\n", 2);
+	if (status & LM90_STATUS_OPEN)
+		dev_warn(&client->dev,
+			 "temp%d diode open, please check!\n", 2);
+
+	if (status2 & (MAX6696_STATUS2_RLOW | MAX6696_STATUS2_RHIGH))
+		dev_warn(&client->dev,
+			 "temp%d out of range, please check!\n", 3);
+
+	return true;
+}
+
 static int lm90_probe(struct i2c_client *client,
 		      const struct i2c_device_id *id)
 {
@@ -1515,36 +1558,19 @@ static int lm90_remove(struct i2c_client *client)
 
 static void lm90_alert(struct i2c_client *client, unsigned int flag)
 {
-	struct lm90_data *data = i2c_get_clientdata(client);
-	u8 config, alarms, alarms2 = 0;
-
-	lm90_read_reg(client, LM90_REG_R_STATUS, &alarms);
-
-	if (data->kind == max6696)
-		lm90_read_reg(client, MAX6696_REG_R_STATUS2, &alarms2);
-
-	if ((alarms & 0x7f) == 0 && (alarms2 & 0xfe) == 0) {
+	if (!lm90_is_tripped(client)) {
 		dev_info(&client->dev, "Everything OK\n");
 	} else {
-		if (alarms & 0x61)
-			dev_warn(&client->dev,
-				 "temp%d out of range, please check!\n", 1);
-		if (alarms & 0x1a)
-			dev_warn(&client->dev,
-				 "temp%d out of range, please check!\n", 2);
-		if (alarms & 0x04)
-			dev_warn(&client->dev,
-				 "temp%d diode open, please check!\n", 2);
-
-		if (alarms2 & 0x18)
-			dev_warn(&client->dev,
-				 "temp%d out of range, please check!\n", 3);
-
 		/*
 		 * Disable ALERT# output, because these chips don't implement
 		 * SMBus alert correctly; they should only hold the alert line
 		 * low briefly.
 		 */
+		struct lm90_data *data = i2c_get_clientdata(client);
+		u8 config, alarms;
+
+		lm90_read_reg(client, LM90_REG_R_STATUS, &alarms);
+
 		if ((data->flags & LM90_HAVE_BROKEN_ALERT)
 		 && (alarms & data->alert_alarms)) {
 			dev_dbg(&client->dev, "Disabling ALERT#\n");
-- 
1.7.9.5

