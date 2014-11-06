Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751334AbaKFOKG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Nov 2014 09:10:06 -0500
Received: from gw.hale.at ([83.64.51.210]:35664 "EHLO gw.hale.at"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751295AbaKFOKD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Nov 2014 09:10:03 -0500
X-Greylist: delayed 591 seconds by postgrey-1.27 at vger.kernel.org; Thu, 06 Nov 2014 09:10:02 EST
X-HALE-Mailborder-Watermark: 1415887239.02722@g6qnt+oodUWo3fbszNeing
X-HALE-Mailborder-From: michael.thalmeier@hale.at
X-HALE-Mailborder-SpamCheck: not spam, SpamAssassin (not cached,
	score=-2.899, required 3, autolearn=not spam, ALL_TRUSTED -1.00,
	BAYES_00 -1.90, URIBL_BLOCKED 0.00)
X-HALE-Mailborder-IP-Protocol: IPv4
X-HALE-Mailborder: Found to be clean
X-HALE-Mailborder-ID: 33FA62C072B.AE9F9
X-HALE-Mailborder-Information: Please contact your admin for more information
From: Michael Thalmeier <michael.thalmeier@hale.at>
To: linux@roeck-us.net, jdelvare@suse.de
Cc: lm-sensors@lm-sensors.org, linux-kernel@vger.kernel.org
Subject: [PATCH] hwmon: (lm75) put chip into shutdown mode on shutdown
Date: Thu,  6 Nov 2014 15:00:32 +0100
Message-Id: <1415282432-3256-1-git-send-email-michael.thalmeier@hale.at>
X-Mailer: git-send-email 1.9.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In addition to going into shutdown mode on suspend also go into shutdown mode
on system shutdown. This way we can save a few mA when the main CPU is powered
off and the lm75 is still powered but not used any more.

Signed-off-by: Michael Thalmeier <michael.thalmeier@hale.at>
---
 drivers/hwmon/lm75.c | 19 +++++++++++++++++--
 1 file changed, 17 insertions(+), 2 deletions(-)

diff --git a/drivers/hwmon/lm75.c b/drivers/hwmon/lm75.c
index 7ec5ccd..d860af9 100644
--- a/drivers/hwmon/lm75.c
+++ b/drivers/hwmon/lm75.c
@@ -433,10 +433,10 @@ static int lm75_detect(struct i2c_client *new_client,
 }
 
 #ifdef CONFIG_PM
-static int lm75_suspend(struct device *dev)
+
+static int _lm75_shutdown(struct i2c_client *client)
 {
 	int status;
-	struct i2c_client *client = to_i2c_client(dev);
 	status = lm75_read_value(client, LM75_REG_CONF);
 	if (status < 0) {
 		dev_dbg(&client->dev, "Can't read config? %d\n", status);
@@ -447,6 +447,18 @@ static int lm75_suspend(struct device *dev)
 	return 0;
 }
 
+static void lm75_shutdown(struct i2c_client *client)
+{
+	_lm75_shutdown(client);
+}
+
+static int lm75_suspend(struct device *dev)
+{
+	struct i2c_client *client = to_i2c_client(dev);
+
+	return _lm75_shutdown(client);
+}
+
 static int lm75_resume(struct device *dev)
 {
 	int status;
@@ -466,8 +478,10 @@ static const struct dev_pm_ops lm75_dev_pm_ops = {
 	.resume		= lm75_resume,
 };
 #define LM75_DEV_PM_OPS (&lm75_dev_pm_ops)
+#define LM75_SHUTDOWN_OP lm75_shutdown
 #else
 #define LM75_DEV_PM_OPS NULL
+#define LM75_SHUTDOWN_OP NULL
 #endif /* CONFIG_PM */
 
 static struct i2c_driver lm75_driver = {
@@ -478,6 +492,7 @@ static struct i2c_driver lm75_driver = {
 	},
 	.probe		= lm75_probe,
 	.remove		= lm75_remove,
+	.shutdown	= LM75_SHUTDOWN_OP,
 	.id_table	= lm75_ids,
 	.detect		= lm75_detect,
 	.address_list	= normal_i2c,
-- 
1.9.3

