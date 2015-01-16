Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755359AbbAPMHO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Jan 2015 07:07:14 -0500
Received: from bes.se.axis.com ([195.60.68.10]:58256 "EHLO bes.se.axis.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755277AbbAPMHL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Jan 2015 07:07:11 -0500
From: Robert Rosengren <robert.rosengren@axis.com>
To: Jean Delvare <jdelvare@suse.de>, Guenter Roeck <linux@roeck-us.net>,
        <lm-sensors@lm-sensors.org>
CC: <linux-kernel@vger.kernel.org>, Robert Rosengren <robertr@axis.com>,
        Johan Adolfsson <johana@axis.com>
Subject: [PATCH] hwmon: (ads7828) Make sample interval configurable
Date: Fri, 16 Jan 2015 13:05:22 +0100
Message-ID: <1421409922-28299-1-git-send-email-robert.rosengren@axis.com>
X-Mailer: git-send-email 2.1.4
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The default sample interval may be too slow for certain clients. This
patch makes it configurable via the platform_data.

Signed-off-by: Robert Rosengren <robert.rosengren@axis.com>
Signed-off-by: Johan Adolfsson <johan.adolfsson@axis.com>
---
 drivers/hwmon/ads7828.c               | 11 ++++++++++-
 include/linux/platform_data/ads7828.h |  2 ++
 2 files changed, 12 insertions(+), 1 deletion(-)

diff --git a/drivers/hwmon/ads7828.c b/drivers/hwmon/ads7828.c
index a622d40..fd5eabf7 100644
--- a/drivers/hwmon/ads7828.c
+++ b/drivers/hwmon/ads7828.c
@@ -45,6 +45,9 @@
 #define ADS7828_EXT_VREF_MV_MIN	50	/* External vref min value 0.05V */
 #define ADS7828_EXT_VREF_MV_MAX	5250	/* External vref max value 5.25V */
 
+/* Default sample interval */
+#define ADS7828_SAMPLE_INTERVAL (HZ + HZ / 2)
+
 /* List of supported devices */
 enum ads7828_chips { ads7828, ads7830 };
 
@@ -58,6 +61,7 @@ struct ads7828_data {
 	bool diff_input;		/* Differential input */
 	bool ext_vref;			/* External voltage reference */
 	unsigned int vref_mv;		/* voltage reference value */
+	unsigned int sample_interval;   /* sample interval */
 	u8 cmd_byte;			/* Command byte without channel bits */
 	unsigned int lsb_resol;		/* Resolution of the ADC sample LSB */
 	s32 (*read_channel)(const struct i2c_client *client, u8 command);
@@ -77,7 +81,7 @@ static struct ads7828_data *ads7828_update_device(struct device *dev)
 
 	mutex_lock(&data->update_lock);
 
-	if (time_after(jiffies, data->last_updated + HZ + HZ / 2)
+	if (time_after(jiffies, data->last_updated + data->sample_interval)
 			|| !data->valid) {
 		unsigned int ch;
 		dev_dbg(&client->dev, "Starting ads7828 update\n");
@@ -147,6 +151,8 @@ static int ads7828_probe(struct i2c_client *client,
 		data->ext_vref = pdata->ext_vref;
 		if (data->ext_vref)
 			data->vref_mv = pdata->vref_mv;
+		if (pdata->sample_interval)
+			data->sample_interval = pdata->sample_interval;
 	}
 
 	/* Bound Vref with min/max values if it was provided */
@@ -157,6 +163,9 @@ static int ads7828_probe(struct i2c_client *client,
 	else
 		data->vref_mv = ADS7828_INT_VREF_MV;
 
+	if (!data->sample_interval)
+		data->sample_interval = ADS7828_SAMPLE_INTERVAL;
+
 	/* ADS7828 uses 12-bit samples, while ADS7830 is 8-bit */
 	if (id->driver_data == ads7828) {
 		data->lsb_resol = DIV_ROUND_CLOSEST(data->vref_mv * 1000, 4096);
diff --git a/include/linux/platform_data/ads7828.h b/include/linux/platform_data/ads7828.h
index 3245f45..bdae0bb 100644
--- a/include/linux/platform_data/ads7828.h
+++ b/include/linux/platform_data/ads7828.h
@@ -19,11 +19,13 @@
  * @diff_input:		Differential input mode.
  * @ext_vref:		Use an external voltage reference.
  * @vref_mv:		Voltage reference value, if external.
+ * @sample_interval:	Sample interval.
  */
 struct ads7828_platform_data {
 	bool diff_input;
 	bool ext_vref;
 	unsigned int vref_mv;
+	unsigned int sample_interval;
 };
 
 #endif /* _PDATA_ADS7828_H */
-- 
2.1.4

