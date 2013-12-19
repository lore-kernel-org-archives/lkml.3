Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756093Ab3LSL7v (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Dec 2013 06:59:51 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:45325 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753184Ab3LSL7p (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Dec 2013 06:59:45 -0500
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: =?UTF-8?q?Jos=C3=A9=20Miguel=20Gon=C3=A7alves?= 
	<jose.goncalves@inov.pt>,
        Guenter Roeck <linux@roeck-us.net>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.11 185/208] hwmon: HIH-6130: Support I2C bus drivers without I2C_FUNC_SMBUS_QUICK
Date: Thu, 19 Dec 2013 11:54:43 +0000
Message-Id: <1387454106-19326-186-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1387454106-19326-1-git-send-email-luis.henriques@canonical.com>
References: <1387454106-19326-1-git-send-email-luis.henriques@canonical.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Extended-Stable: 3.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.11.10.2 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: =?UTF-8?q?Jos=C3=A9=20Miguel=20Gon=C3=A7alves?=

commit efabcc2123f0ed47870033b8d6fc73b50d76d635 upstream.

Some I2C bus drivers do not allow zero-length data transfers which are
required to start a measurement with the HIH6130/1 sensor. Nevertheless,
we can overcome this limitation by writing a zero dummy byte. This byte
is ignored by the sensor and was verified to be working with the OMAP
I2C bus driver in a BeagleBone board.

Signed-off-by: José Miguel Gonçalves <jose.goncalves@inov.pt>
[Guenter Roeck: Simplified complexity of write_length initialization]
Signed-off-by: Guenter Roeck <linux@roeck-us.net>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 drivers/hwmon/hih6130.c | 16 ++++++++++++++--
 1 file changed, 14 insertions(+), 2 deletions(-)

diff --git a/drivers/hwmon/hih6130.c b/drivers/hwmon/hih6130.c
index 2dc37c7..7d68a08 100644
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
 
+	if (!i2c_check_functionality(client->adapter, I2C_FUNC_SMBUS_QUICK))
+		hih6130->write_length = 1;
+
 	return 0;
 
 fail_remove_sysfs:
-- 
1.8.3.2

