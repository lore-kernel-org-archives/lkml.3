Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758341AbaIOWT4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Sep 2014 18:19:56 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:51246 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758309AbaIOWTu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Sep 2014 18:19:50 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Axel Lin <axel.lin@ingics.com>, Guenter Roeck <linux@roeck-us.net>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.13 123/187] hwmon: (amc6821) Fix possible race condition bug
Date: Mon, 15 Sep 2014 15:08:53 -0700
Message-Id: <1410818997-9432-124-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1410818997-9432-1-git-send-email-kamal@canonical.com>
References: <1410818997-9432-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.13
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.13.11.7 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Axel Lin <axel.lin@ingics.com>

commit cf44819c98db11163f58f08b822d626c7a8f5188 upstream.

Ensure mutex lock protects the read-modify-write period to prevent possible
race condition bug.
In additional, update data->valid should also be protected by the mutex lock.

Signed-off-by: Axel Lin <axel.lin@ingics.com>
Signed-off-by: Guenter Roeck <linux@roeck-us.net>
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 drivers/hwmon/amc6821.c | 17 +++++++++++------
 1 file changed, 11 insertions(+), 6 deletions(-)

diff --git a/drivers/hwmon/amc6821.c b/drivers/hwmon/amc6821.c
index 9f2be3d..8a67ec6 100644
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
@@ -493,8 +496,9 @@ static ssize_t set_temp_auto_point_temp(
 		return -EINVAL;
 	}
 
-	data->valid = 0;
 	mutex_lock(&data->update_lock);
+	data->valid = 0;
+
 	switch (ix) {
 	case 0:
 		ptemp[0] = clamp_val(val / 1000, 0,
@@ -658,13 +662,14 @@ static ssize_t set_fan1_div(
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
-- 
1.9.1

