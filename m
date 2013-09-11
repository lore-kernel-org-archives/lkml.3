Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755199Ab3IKPdA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Sep 2013 11:33:00 -0400
Received: from mga03.intel.com ([143.182.124.21]:16861 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755092Ab3IKPcx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Sep 2013 11:32:53 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.90,885,1371106800"; 
   d="scan'208";a="394206319"
From: Mika Westerberg <mika.westerberg@linux.intel.com>
To: linux-i2c@vger.kernel.org
Cc: Wolfram Sang <wsa@the-dreams.de>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org,
        Lv Zheng <lv.zheng@intel.com>, Aaron Lu <aaron.lu@intel.com>,
        linux-arm-kernel@lists.infradead.org, Mark Brown <broonie@kernel.org>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Mauro Carvalho Chehab <m.chehab@samsung.com>,
        Samuel Ortiz <sameo@linux.intel.com>, Lee Jones <lee.jones@linaro.org>,
        Arnd Bergmann <arnd@arndb.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Liam Girdwood <lgirdwood@gmail.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Mika Westerberg <mika.westerberg@linux.intel.com>
Subject: [PATCH v2 1/9] i2c: prepare runtime PM support for I2C client devices
Date: Wed, 11 Sep 2013 18:32:32 +0300
Message-Id: <1378913560-2752-2-git-send-email-mika.westerberg@linux.intel.com>
X-Mailer: git-send-email 1.8.4.rc3
In-Reply-To: <1378913560-2752-1-git-send-email-mika.westerberg@linux.intel.com>
References: <1378913560-2752-1-git-send-email-mika.westerberg@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Aaron Lu <aaron.lu@intel.com>

This patch adds runtime PM support for the I2C bus in a similar way that
has been done for PCI bus already. This means that the I2C bus core
prepares runtime PM for a client device just before a driver is about to be
bound to it. Devices that are not bound to any driver are not prepared for
runtime PM.

In order to take advantage of this runtime PM support, the client device
driver needs drop the device runtime PM reference count by calling
pm_runtime_put() in its ->probe() callback and possibly implement rest of
the runtime PM callbacks.

If the driver doesn't support runtime PM (like most of the existing I2C
client drivers), the device in question is regarded as being runtime PM
active and powered on.

The patch adds also runtime PM support for the adapter device because it is
needed to be able to runtime power manage the I2C controller device. The
adapter device is handled along with the I2C controller device (it uses
pm_runtime_no_callbacks()).

Signed-off-by: Aaron Lu <aaron.lu@intel.com>
Signed-off-by: Mika Westerberg <mika.westerberg@linux.intel.com>
---
 drivers/i2c/i2c-core.c | 44 +++++++++++++++++++++++++++++++++++++++++++-
 1 file changed, 43 insertions(+), 1 deletion(-)

diff --git a/drivers/i2c/i2c-core.c b/drivers/i2c/i2c-core.c
index f32ca29..44374b4 100644
--- a/drivers/i2c/i2c-core.c
+++ b/drivers/i2c/i2c-core.c
@@ -248,11 +248,30 @@ static int i2c_device_probe(struct device *dev)
 					client->flags & I2C_CLIENT_WAKE);
 	dev_dbg(dev, "probe\n");
 
+	/* Make sure the adapter is active */
+	pm_runtime_get_sync(&client->adapter->dev);
+
+	/*
+	 * Enable runtime PM for the client device. If the client wants to
+	 * participate on runtime PM it should call pm_runtime_put() in its
+	 * probe() callback.
+	 */
+	pm_runtime_get_noresume(&client->dev);
+	pm_runtime_set_active(&client->dev);
+	pm_runtime_enable(&client->dev);
+
 	status = driver->probe(client, i2c_match_id(driver->id_table, client));
 	if (status) {
 		client->driver = NULL;
 		i2c_set_clientdata(client, NULL);
+
+		pm_runtime_disable(&client->dev);
+		pm_runtime_set_suspended(&client->dev);
+		pm_runtime_put_noidle(&client->dev);
 	}
+
+	pm_runtime_put(&client->adapter->dev);
+
 	return status;
 }
 
@@ -265,6 +284,8 @@ static int i2c_device_remove(struct device *dev)
 	if (!client || !dev->driver)
 		return 0;
 
+	pm_runtime_get_sync(&client->adapter->dev);
+
 	driver = to_i2c_driver(dev->driver);
 	if (driver->remove) {
 		dev_dbg(dev, "remove\n");
@@ -277,6 +298,13 @@ static int i2c_device_remove(struct device *dev)
 		client->driver = NULL;
 		i2c_set_clientdata(client, NULL);
 	}
+
+	/* Undo the runtime PM done in i2c_probe() */
+	pm_runtime_disable(&client->dev);
+	pm_runtime_set_suspended(&client->dev);
+	pm_runtime_put_noidle(&client->dev);
+
+	pm_runtime_put(&client->adapter->dev);
 	return status;
 }
 
@@ -288,8 +316,11 @@ static void i2c_device_shutdown(struct device *dev)
 	if (!client || !dev->driver)
 		return;
 	driver = to_i2c_driver(dev->driver);
-	if (driver->shutdown)
+	if (driver->shutdown) {
+		pm_runtime_get_sync(&client->adapter->dev);
 		driver->shutdown(client);
+		pm_runtime_put(&client->adapter->dev);
+	}
 }
 
 #ifdef CONFIG_PM_SLEEP
@@ -1066,6 +1097,15 @@ exit_recovery:
 	bus_for_each_drv(&i2c_bus_type, NULL, adap, __process_new_adapter);
 	mutex_unlock(&core_lock);
 
+	/*
+	 * Make sure the adapter runtime PM follows the parent device (the
+	 * host controller) so that we can suspend it once there aren't any
+	 * active clients anymore.
+	 */
+	pm_runtime_set_active(&adap->dev);
+	pm_runtime_no_callbacks(&adap->dev);
+	pm_runtime_enable(&adap->dev);
+
 	return 0;
 
 out_list:
@@ -1230,6 +1270,8 @@ void i2c_del_adapter(struct i2c_adapter *adap)
 		return;
 	}
 
+	pm_runtime_disable(&adap->dev);
+
 	/* Tell drivers about this removal */
 	mutex_lock(&core_lock);
 	bus_for_each_drv(&i2c_bus_type, NULL, adap,
-- 
1.8.4.rc3

