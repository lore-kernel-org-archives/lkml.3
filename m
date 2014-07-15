Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934322AbaGOXPJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jul 2014 19:15:09 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:45334 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933825AbaGOXOC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jul 2014 19:14:02 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Guenter Roeck <linux@roeck-us.net>, Axel Lin <axel.lin@ingics.com>
Subject: [PATCH 3.15 21/84] hwmon: (adm1021) Fix cache problem when writing temperature limits
Date: Tue, 15 Jul 2014 16:17:18 -0700
Message-Id: <20140715231713.833139607@linuxfoundation.org>
X-Mailer: git-send-email 2.0.0.254.g50f84e3
In-Reply-To: <20140715231713.193785557@linuxfoundation.org>
References: <20140715231713.193785557@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Axel Lin <axel.lin@ingics.com>

commit c024044d4da2c9c3b32933b4235df1e409293b84 upstream.

The module test script for the adm1021 driver exposes a cache problem
when writing temperature limits. temp_min and temp_max are expected
to be stored in milli-degrees C but are stored in degrees C.

Reported-by: Guenter Roeck <linux@roeck-us.net>
Signed-off-by: Axel Lin <axel.lin@ingics.com>
Signed-off-by: Guenter Roeck <linux@roeck-us.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/hwmon/adm1021.c |   14 ++++++++------
 1 file changed, 8 insertions(+), 6 deletions(-)

--- a/drivers/hwmon/adm1021.c
+++ b/drivers/hwmon/adm1021.c
@@ -185,7 +185,7 @@ static ssize_t set_temp_max(struct devic
 	struct adm1021_data *data = dev_get_drvdata(dev);
 	struct i2c_client *client = data->client;
 	long temp;
-	int err;
+	int reg_val, err;
 
 	err = kstrtol(buf, 10, &temp);
 	if (err)
@@ -193,10 +193,11 @@ static ssize_t set_temp_max(struct devic
 	temp /= 1000;
 
 	mutex_lock(&data->update_lock);
-	data->temp_max[index] = clamp_val(temp, -128, 127);
+	reg_val = clamp_val(temp, -128, 127);
+	data->temp_max[index] = reg_val * 1000;
 	if (!read_only)
 		i2c_smbus_write_byte_data(client, ADM1021_REG_TOS_W(index),
-					  data->temp_max[index]);
+					  reg_val);
 	mutex_unlock(&data->update_lock);
 
 	return count;
@@ -210,7 +211,7 @@ static ssize_t set_temp_min(struct devic
 	struct adm1021_data *data = dev_get_drvdata(dev);
 	struct i2c_client *client = data->client;
 	long temp;
-	int err;
+	int reg_val, err;
 
 	err = kstrtol(buf, 10, &temp);
 	if (err)
@@ -218,10 +219,11 @@ static ssize_t set_temp_min(struct devic
 	temp /= 1000;
 
 	mutex_lock(&data->update_lock);
-	data->temp_min[index] = clamp_val(temp, -128, 127);
+	reg_val = clamp_val(temp, -128, 127);
+	data->temp_min[index] = reg_val * 1000;
 	if (!read_only)
 		i2c_smbus_write_byte_data(client, ADM1021_REG_THYST_W(index),
-					  data->temp_min[index]);
+					  reg_val);
 	mutex_unlock(&data->update_lock);
 
 	return count;


