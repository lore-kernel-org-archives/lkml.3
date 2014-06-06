Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752637AbaFFPxF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jun 2014 11:53:05 -0400
Received: from mail-ig0-f172.google.com ([209.85.213.172]:44421 "EHLO
	mail-ig0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752601AbaFFPxB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jun 2014 11:53:01 -0400
From: Lee Jones <lee.jones@linaro.org>
To: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Cc: wsa@the-dreams.de, grant.likely@linaro.org, linus.walleij@linaro.org,
        linux-i2c@vger.kernel.org, devicetree@vger.kernel.org,
        Lee Jones <lee.jones@linaro.org>
Subject: [PATCH 6/9] i2c: Provide a temporary .probe2() call-back type
Date: Fri,  6 Jun 2014 16:52:29 +0100
Message-Id: <1402069952-28022-7-git-send-email-lee.jones@linaro.org>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1402069952-28022-1-git-send-email-lee.jones@linaro.org>
References: <1402069952-28022-1-git-send-email-lee.jones@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This will aid the seamless removal of the current probe()'s, more
commonly unused than used second parameter.  Most I2C drivers can
simply switch over to the new interface, others which have DT
support can use its own matching instead and others can call
i2c_match_id() themselves.  This brings I2C's device probe method
into line with other similar interfaces in the kernel and prevents
the requirement to pass an i2c_device_id table.

Suggested-by: Grant Likely <grant.likely@linaro.org>
Signed-off-by: Lee Jones <lee.jones@linaro.org>
---
 drivers/i2c/i2c-core.c | 12 +++++++++---
 include/linux/i2c.h    |  8 +++++++-
 2 files changed, 16 insertions(+), 4 deletions(-)

diff --git a/drivers/i2c/i2c-core.c b/drivers/i2c/i2c-core.c
index 3fe8232..7047ea9 100644
--- a/drivers/i2c/i2c-core.c
+++ b/drivers/i2c/i2c-core.c
@@ -269,8 +269,6 @@ static int i2c_device_probe(struct device *dev)
 		return 0;
 
 	driver = to_i2c_driver(dev->driver);
-	if (!driver->probe)
-		return -EINVAL;
 
 	/*
 	 * An I2C ID table is not mandatory, if and only if, a suitable Device
@@ -286,7 +284,15 @@ static int i2c_device_probe(struct device *dev)
 	dev_dbg(dev, "probe\n");
 
 	acpi_dev_pm_attach(&client->dev, true);
-	status = driver->probe(client, i2c_match_id(driver->id_table, client));
+
+	/* When there are no more users of probe(), rename probe2 to probe. */
+	if (driver->probe2)
+		status = driver->probe2(client);
+	else if (driver->probe)
+		status = driver->probe(client,
+				       i2c_match_id(driver->id_table, client));
+	else
+		return -EINVAL;
 	if (status)
 		acpi_dev_pm_detach(&client->dev, true);
 
diff --git a/include/linux/i2c.h b/include/linux/i2c.h
index 9d36f86..0a470ea 100644
--- a/include/linux/i2c.h
+++ b/include/linux/i2c.h
@@ -125,7 +125,8 @@ extern s32 i2c_smbus_write_i2c_block_data(const struct i2c_client *client,
  * struct i2c_driver - represent an I2C device driver
  * @class: What kind of i2c device we instantiate (for detect)
  * @attach_adapter: Callback for bus addition (deprecated)
- * @probe: Callback for device binding
+ * @probe: Callback for device binding - soon to be deprecated
+ * @probe2: New callback for device binding
  * @remove: Callback for device unbinding
  * @shutdown: Callback for device shutdown
  * @suspend: Callback for device suspend
@@ -170,6 +171,11 @@ struct i2c_driver {
 	int (*probe)(struct i2c_client *, const struct i2c_device_id *);
 	int (*remove)(struct i2c_client *);
 
+	/* New driver model interface to aid the seamless removal of the
+	 * current probe()'s, more commonly unused than used second parameter.
+	 */
+	int (*probe2)(struct i2c_client *);
+
 	/* driver model interfaces that don't relate to enumeration  */
 	void (*shutdown)(struct i2c_client *);
 	int (*suspend)(struct i2c_client *, pm_message_t mesg);
-- 
1.8.3.2

