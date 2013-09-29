Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754999Ab3I2IuI (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Sep 2013 04:50:08 -0400
Received: from smtp-out-220.synserver.de ([212.40.185.220]:1410 "EHLO
	smtp-out-220.synserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754783Ab3I2Itv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Sep 2013 04:49:51 -0400
X-SynServer-TrustedSrc: 1
X-SynServer-AuthUser: lars@metafoo.de
X-SynServer-PPID: 1782
From: Lars-Peter Clausen <lars@metafoo.de>
To: Wolfram Sang <wsa@the-dreams.de>, David Airlie <airlied@linux.ie>,
        Mauro Carvalho Chehab <m.chehab@samsung.com>,
        Jaroslav Kysela <perex@perex.cz>, Takashi Iwai <tiwai@suse.de>,
        Liam Girdwood <lgirdwood@gmail.com>, Mark Brown <broonie@kernel.org>
Cc: linux-kernel@vger.kernel.org, linux-i2c@vger.kernel.org,
        dri-devel@lists.freedesktop.org, linux-media@vger.kernel.org,
        alsa-devel@alsa-project.org, Lars-Peter Clausen <lars@metafoo.de>
Subject: [PATCH 8/8] i2c: Remove redundant 'driver' field from the i2c_client struct
Date: Sun, 29 Sep 2013 10:51:06 +0200
Message-Id: <1380444666-12019-9-git-send-email-lars@metafoo.de>
X-Mailer: git-send-email 1.8.0
In-Reply-To: <1380444666-12019-1-git-send-email-lars@metafoo.de>
References: <1380444666-12019-1-git-send-email-lars@metafoo.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The 'driver' field of the i2c_client struct is redundant. The same data can be
accessed through to_i2c_driver(client->dev.driver). The generated code for both
approaches in more or less the same.

E.g. on ARM the expression client->driver->command(...) generates

		...
		ldr     r3, [r0, #28]
		ldr     r3, [r3, #32]
		blx     r3
		...

and the expression to_i2c_driver(client->dev.driver)->command(...) generates

		...
		ldr     r3, [r0, #160]
    	ldr     r3, [r3, #-4]
    	blx     r3
		...

Other architectures will generate similar code.

All users of the 'driver' field outside of the I2C core have already been
converted. So this only leaves the core itself. This patch converts the
remaining few users in the I2C core and then removes the 'driver' field from the
i2c_client struct.

Signed-off-by: Lars-Peter Clausen <lars@metafoo.de>
---
 drivers/i2c/i2c-core.c  | 21 ++++++++++++---------
 drivers/i2c/i2c-smbus.c | 10 ++++++----
 include/linux/i2c.h     |  2 --
 3 files changed, 18 insertions(+), 15 deletions(-)

diff --git a/drivers/i2c/i2c-core.c b/drivers/i2c/i2c-core.c
index 29d3f04..430c001 100644
--- a/drivers/i2c/i2c-core.c
+++ b/drivers/i2c/i2c-core.c
@@ -248,17 +248,16 @@ static int i2c_device_probe(struct device *dev)
 	driver = to_i2c_driver(dev->driver);
 	if (!driver->probe || !driver->id_table)
 		return -ENODEV;
-	client->driver = driver;
+
 	if (!device_can_wakeup(&client->dev))
 		device_init_wakeup(&client->dev,
 					client->flags & I2C_CLIENT_WAKE);
 	dev_dbg(dev, "probe\n");
 
 	status = driver->probe(client, i2c_match_id(driver->id_table, client));
-	if (status) {
-		client->driver = NULL;
+	if (status)
 		i2c_set_clientdata(client, NULL);
-	}
+
 	return status;
 }
 
@@ -279,10 +278,9 @@ static int i2c_device_remove(struct device *dev)
 		dev->driver = NULL;
 		status = 0;
 	}
-	if (status == 0) {
-		client->driver = NULL;
+	if (status == 0)
 		i2c_set_clientdata(client, NULL);
-	}
+
 	return status;
 }
 
@@ -1606,9 +1604,14 @@ static int i2c_cmd(struct device *dev, void *_arg)
 {
 	struct i2c_client	*client = i2c_verify_client(dev);
 	struct i2c_cmd_arg	*arg = _arg;
+	struct i2c_driver	*driver;
+
+	if (!client || !client->dev.driver)
+		return 0;
 
-	if (client && client->driver && client->driver->command)
-		client->driver->command(client, arg->cmd, arg->arg);
+	driver = to_i2c_driver(client->dev.driver);
+	if (driver->command)
+		driver->command(client, arg->cmd, arg->arg);
 	return 0;
 }
 
diff --git a/drivers/i2c/i2c-smbus.c b/drivers/i2c/i2c-smbus.c
index 44d4c60..c99b229 100644
--- a/drivers/i2c/i2c-smbus.c
+++ b/drivers/i2c/i2c-smbus.c
@@ -46,6 +46,7 @@ static int smbus_do_alert(struct device *dev, void *addrp)
 {
 	struct i2c_client *client = i2c_verify_client(dev);
 	struct alert_data *data = addrp;
+	struct i2c_driver *driver;
 
 	if (!client || client->addr != data->addr)
 		return 0;
@@ -54,12 +55,13 @@ static int smbus_do_alert(struct device *dev, void *addrp)
 
 	/*
 	 * Drivers should either disable alerts, or provide at least
-	 * a minimal handler.  Lock so client->driver won't change.
+	 * a minimal handler.  Lock so the driver won't change.
 	 */
 	device_lock(dev);
-	if (client->driver) {
-		if (client->driver->alert)
-			client->driver->alert(client, data->flag);
+	if (client->dev.driver) {
+		driver = to_i2c_driver(client->dev.driver);
+		if (driver->alert)
+			driver->alert(client, data->flag);
 		else
 			dev_warn(&client->dev, "no driver alert()!\n");
 	} else
diff --git a/include/linux/i2c.h b/include/linux/i2c.h
index 2ab11dc..eff50e0 100644
--- a/include/linux/i2c.h
+++ b/include/linux/i2c.h
@@ -205,7 +205,6 @@ struct i2c_driver {
  * @name: Indicates the type of the device, usually a chip name that's
  *	generic enough to hide second-sourcing and compatible revisions.
  * @adapter: manages the bus segment hosting this I2C device
- * @driver: device's driver, hence pointer to access routines
  * @dev: Driver model device node for the slave.
  * @irq: indicates the IRQ generated by this device (if any)
  * @detected: member of an i2c_driver.clients list or i2c-core's
@@ -222,7 +221,6 @@ struct i2c_client {
 					/* _LOWER_ 7 bits		*/
 	char name[I2C_NAME_SIZE];
 	struct i2c_adapter *adapter;	/* the adapter we sit on	*/
-	struct i2c_driver *driver;	/* and our access routines	*/
 	struct device dev;		/* the device structure		*/
 	int irq;			/* irq issued by device		*/
 	struct list_head detected;
-- 
1.8.0

