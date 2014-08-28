Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752009AbaH1Ogt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Aug 2014 10:36:49 -0400
Received: from mail-qc0-f182.google.com ([209.85.216.182]:50508 "EHLO
	mail-qc0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751816AbaH1OgF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Aug 2014 10:36:05 -0400
From: Lee Jones <lee.jones@linaro.org>
To: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Cc: lee.jones@linaro.org, kernel@stlinux.com, wsa@the-dreams.de,
        grant.likely@linaro.org, linux-i2c@vger.kernel.org,
        devicetree@vger.kernel.org, linus.walleij@linaro.org
Subject: [PATCH 6/8] i2c: Provide a temporary .probe2() call-back type
Date: Thu, 28 Aug 2014 15:35:36 +0100
Message-Id: <1409236538-21274-7-git-send-email-lee.jones@linaro.org>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1409236538-21274-1-git-send-email-lee.jones@linaro.org>
References: <1409236538-21274-1-git-send-email-lee.jones@linaro.org>
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
index 7c21f49..5c74bd0 100644
--- a/drivers/i2c/i2c-core.c
+++ b/drivers/i2c/i2c-core.c
@@ -270,8 +270,6 @@ static int i2c_device_probe(struct device *dev)
 		return 0;
 
 	driver = to_i2c_driver(dev->driver);
-	if (!driver->probe)
-		return -EINVAL;
 
 	/*
 	 * An I2C ID table is not mandatory, if and only if, a suitable Device
@@ -291,7 +289,15 @@ static int i2c_device_probe(struct device *dev)
 		return status;
 
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
index 79b674d..c8240e5 100644
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
1.9.1

