Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752252Ab3LKLM6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Dec 2013 06:12:58 -0500
Received: from lmv.inov.pt ([146.193.64.2]:47708 "EHLO lmv.inov.pt"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751932Ab3LKLMy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Dec 2013 06:12:54 -0500
From: =?UTF-8?q?Jos=C3=A9=20Miguel=20Gon=C3=A7alves?= 
	<jose.goncalves@inov.pt>
To: Jean Delvare <khali@linux-fr.org>, Guenter Roeck <linux@roeck-us.net>,
        lm-sensors@lm-sensors.org, linux-kernel@vger.kernel.org
Cc: =?UTF-8?q?Jos=C3=A9=20Miguel=20Gon=C3=A7alves?= 
	<jose.goncalves@inov.pt>
Subject: [PATCH] hwmon: HIH-6130: Support I2C bus drivers without I2C_FUNC_SMBUS_QUICK
Date: Wed, 11 Dec 2013 11:11:13 +0000
Message-Id: <1386760273-7703-1-git-send-email-jose.goncalves@inov.pt>
X-Mailer: git-send-email 1.7.10.4
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.0.1 (lmv.inov.pt [146.193.64.2]); Wed, 11 Dec 2013 11:11:28 +0000 (WET)
X-INOV-EmailServer-Information: Please contact the Email service provider for more information
X-INOV-EmailServer: Found to be clean
X-INOV-EmailServer-From: jose.goncalves@inov.pt
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Some I2C bus drivers do not allow zero-length data transfers which are
required to start a measurement with the HIH6130/1 sensor. Nevertheless,
we can overcome this limitation by writing a zero dummy byte. This byte
is ignored by the sensor and was verified to be working with the OMAP
I2C bus driver in a BeagleBone board.

Signed-off-by: José Miguel Gonçalves <jose.goncalves@inov.pt>
---
v2: Use a field in struct hih6130 to store the measurement request's 
    write length when probing.

 drivers/hwmon/hih6130.c |   16 ++++++++++++++--
 1 file changed, 14 insertions(+), 2 deletions(-)

diff --git a/drivers/hwmon/hih6130.c b/drivers/hwmon/hih6130.c
index 2dc37c7..8e46265 100644
--- a/drivers/hwmon/hih6130.c
+++ b/drivers/hwmon/hih6130.c
@@ -43,6 +43,7 @@
  * @last_update: time of last update (jiffies)
  * @temperature: cached temperature measurement value
  * @humidity: cached humidity measurement value
+ * @write_length: length for I2C measurement request
  */
 struct hih6130 {
 	struct device *hwmon_dev;
@@ -51,6 +52,7 @@ struct hih6130 {
 	unsigned long last_update;
 	int temperature;
 	int humidity;
+	size_t write_length;
 };
 
 /**
@@ -121,8 +123,15 @@ static int hih6130_update_measurements(struct i2c_client *client)
 	 */
 	if (time_after(jiffies, hih6130->last_update + HZ) || !hih6130->valid) {
 
-		/* write to slave address, no data, to request a measurement */
-		ret = i2c_master_send(client, tmp, 0);
+		/*
+		 * Write to slave address to request a measurement.
+		 * According with the datasheet it should be with no data, but
+		 * for systems with I2C bus drivers that do not allow zero
+		 * length packets we write one dummy byte to allow sensor
+		 * measurements on them.
+		 */
+		tmp[0] = 0;
+		ret = i2c_master_send(client, tmp, hih6130->write_length);
 		if (ret < 0)
 			goto out;
 
@@ -252,6 +261,9 @@ static int hih6130_probe(struct i2c_client *client,
 		goto fail_remove_sysfs;
 	}
 
+	hih6130->write_length = (i2c_get_functionality(client->adapter) &
+				 I2C_FUNC_SMBUS_QUICK ? 0 : 1);
+
 	return 0;
 
 fail_remove_sysfs:
-- 
1.7.10.4

