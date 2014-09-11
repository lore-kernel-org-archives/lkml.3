Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755884AbaIKMj4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Sep 2014 08:39:56 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:51685 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755463AbaIKMeI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Sep 2014 08:34:08 -0400
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC: akpm@linux-foundation.org, "Guenter Roeck" <linux@roeck-us.net>,
        "Axel Lin" <axel.lin@ingics.com>
Date: Thu, 11 Sep 2014 13:32:13 +0100
Message-ID: <lsq.1410438733.694692714@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
Subject: [PATCH 3.2 038/131] hwmon: (amc6821) Fix possible race condition bug
In-Reply-To: <lsq.1410438733.176537304@decadent.org.uk>
X-SA-Exim-Connect-IP: 192.168.4.249
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2.63-rc1 review patch.  If anyone has any objections, please let me know.

------------------

From: Axel Lin <axel.lin@ingics.com>

commit cf44819c98db11163f58f08b822d626c7a8f5188 upstream.

Ensure mutex lock protects the read-modify-write period to prevent possible
race condition bug.
In additional, update data->valid should also be protected by the mutex lock.

Signed-off-by: Axel Lin <axel.lin@ingics.com>
Signed-off-by: Guenter Roeck <linux@roeck-us.net>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/hwmon/amc6821.c | 17 +++++++++++------
 1 file changed, 11 insertions(+), 6 deletions(-)

--- a/drivers/hwmon/amc6821.c
+++ b/drivers/hwmon/amc6821.c
@@ -360,11 +360,13 @@ static ssize_t set_pwm1_enable(
 	if (config)
 		return config;
 
+	mutex_lock(&data->update_lock);
 	config = i2c_smbus_read_byte_data(client, AMC6821_REG_CONF1);
 	if (config < 0) {
 			dev_err(&client->dev,
 			"Error reading configuration register, aborting.\n");
-			return config;
+			count = config;
+			goto unlock;
 	}
 
 	switch (val) {
@@ -381,14 +383,15 @@ static ssize_t set_pwm1_enable(
 		config |= AMC6821_CONF1_FDRC1;
 		break;
 	default:
-		return -EINVAL;
+		count = -EINVAL;
+		goto unlock;
 	}
-	mutex_lock(&data->update_lock);
 	if (i2c_smbus_write_byte_data(client, AMC6821_REG_CONF1, config)) {
 			dev_err(&client->dev,
 			"Configuration register write error, aborting.\n");
 			count = -EIO;
 	}
+unlock:
 	mutex_unlock(&data->update_lock);
 	return count;
 }
@@ -495,8 +498,9 @@ static ssize_t set_temp_auto_point_temp(
 		return -EINVAL;
 	}
 
-	data->valid = 0;
 	mutex_lock(&data->update_lock);
+	data->valid = 0;
+
 	switch (ix) {
 	case 0:
 		ptemp[0] = SENSORS_LIMIT(val / 1000, 0,
@@ -669,13 +673,14 @@ static ssize_t set_fan1_div(
 	if (config)
 		return config;
 
+	mutex_lock(&data->update_lock);
 	config = i2c_smbus_read_byte_data(client, AMC6821_REG_CONF4);
 	if (config < 0) {
 		dev_err(&client->dev,
 			"Error reading configuration register, aborting.\n");
-		return config;
+		count = config;
+		goto EXIT;
 	}
-	mutex_lock(&data->update_lock);
 	switch (val) {
 	case 2:
 		config &= ~AMC6821_CONF4_PSPR;

