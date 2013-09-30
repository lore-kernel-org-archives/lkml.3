Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755657Ab3I3On7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Sep 2013 10:43:59 -0400
Received: from mga14.intel.com ([143.182.124.37]:17578 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754343Ab3I3On5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Sep 2013 10:43:57 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.90,1008,1371106800"; 
   d="scan'208";a="403182556"
From: Mika Westerberg <mika.westerberg@linux.intel.com>
To: linux-i2c@vger.kernel.org
Cc: Wolfram Sang <wsa@the-dreams.de>, rjw@rjwysocki.net,
        Aaron Lu <aaron.lu@intel.com>, Lv Zheng <lv.zheng@intel.com>,
        Mark Brown <broonie@kernel.org>, Kevin Hilman <khilman@linaro.org>,
        Sylwester Nawrocki <s.nawrocki@samsung.com>,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-acpi@vger.kernel.org,
        Mika Westerberg <mika.westerberg@linux.intel.com>
Subject: [PATCH v3] i2c: enable runtime PM for I2C adapter devices enumerated from ACPI
Date: Mon, 30 Sep 2013 17:43:48 +0300
Message-Id: <1380552228-23329-2-git-send-email-mika.westerberg@linux.intel.com>
X-Mailer: git-send-email 1.8.4.rc3
In-Reply-To: <1380552228-23329-1-git-send-email-mika.westerberg@linux.intel.com>
References: <1380552228-23329-1-git-send-email-mika.westerberg@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The ACPI specification requires the parent device to be powered on before
any of its children. It can be only powered off when all the children are
already off.

Currently whenever there is no I2C traffic going on, the I2C controller
driver can put the device into low power state transparently to its
children (the I2C client devices). This violates the ACPI specification
because now the parent device is in lower power state than its children.

In order to keep ACPI happy we enable runtime PM for the I2C adapter device
if we find out that the I2C controller was in fact an ACPI device. In
addition to that we attach the I2C client devices to the ACPI power domain
and make sure that they are powered on when the driver ->probe() is called.

Non-ACPI devices are not affected by this change.

This patch is based on the work by Aaron Lu and Lv Zheng.

Signed-off-by: Mika Westerberg <mika.westerberg@linux.intel.com>
---
 drivers/i2c/i2c-core.c | 47 ++++++++++++++++++++++++++++++++++++++++++++++-
 1 file changed, 46 insertions(+), 1 deletion(-)

diff --git a/drivers/i2c/i2c-core.c b/drivers/i2c/i2c-core.c
index 29d3f04..fa861ad 100644
--- a/drivers/i2c/i2c-core.c
+++ b/drivers/i2c/i2c-core.c
@@ -236,6 +236,27 @@ int i2c_recover_bus(struct i2c_adapter *adap)
 	return adap->bus_recovery_info->recover_bus(adap);
 }
 
+static void acpi_i2c_device_pm_get(struct i2c_client *client)
+{
+	struct i2c_adapter *adap = client->adapter;
+
+	/* Make sure the adapter is active */
+	if (ACPI_HANDLE(adap->dev.parent))
+		pm_runtime_get_sync(&adap->dev);
+	if (ACPI_HANDLE(&client->dev))
+		acpi_dev_pm_attach(&client->dev, true);
+}
+
+static void acpi_i2c_device_pm_put(struct i2c_client *client, bool detach)
+{
+	struct i2c_adapter *adap = client->adapter;
+
+	if (ACPI_HANDLE(&client->dev) && detach)
+		acpi_dev_pm_detach(&client->dev, true);
+	if (ACPI_HANDLE(adap->dev.parent))
+		pm_runtime_put(&adap->dev);
+}
+
 static int i2c_device_probe(struct device *dev)
 {
 	struct i2c_client	*client = i2c_verify_client(dev);
@@ -254,11 +275,15 @@ static int i2c_device_probe(struct device *dev)
 					client->flags & I2C_CLIENT_WAKE);
 	dev_dbg(dev, "probe\n");
 
+	acpi_i2c_device_pm_get(client);
+
 	status = driver->probe(client, i2c_match_id(driver->id_table, client));
 	if (status) {
 		client->driver = NULL;
 		i2c_set_clientdata(client, NULL);
 	}
+
+	acpi_i2c_device_pm_put(client, !!status);
 	return status;
 }
 
@@ -271,6 +296,8 @@ static int i2c_device_remove(struct device *dev)
 	if (!client || !dev->driver)
 		return 0;
 
+	acpi_i2c_device_pm_get(client);
+
 	driver = to_i2c_driver(dev->driver);
 	if (driver->remove) {
 		dev_dbg(dev, "remove\n");
@@ -283,6 +310,8 @@ static int i2c_device_remove(struct device *dev)
 		client->driver = NULL;
 		i2c_set_clientdata(client, NULL);
 	}
+
+	acpi_i2c_device_pm_put(client, true);
 	return status;
 }
 
@@ -294,8 +323,11 @@ static void i2c_device_shutdown(struct device *dev)
 	if (!client || !dev->driver)
 		return;
 	driver = to_i2c_driver(dev->driver);
-	if (driver->shutdown)
+	if (driver->shutdown) {
+		acpi_i2c_device_pm_get(client);
 		driver->shutdown(client);
+		acpi_i2c_device_pm_put(client, false);
+	}
 }
 
 #ifdef CONFIG_PM_SLEEP
@@ -1263,6 +1295,16 @@ exit_recovery:
 	bus_for_each_drv(&i2c_bus_type, NULL, adap, __process_new_adapter);
 	mutex_unlock(&core_lock);
 
+	/*
+	 * For ACPI enumerated controllers we must make sure that the
+	 * controller is powered on before its children. Runtime PM handles
+	 * this for us once we have enabled it for the adapter device.
+	 */
+	if (ACPI_HANDLE(adap->dev.parent)) {
+		pm_runtime_no_callbacks(&adap->dev);
+		pm_runtime_enable(&adap->dev);
+	}
+
 	return 0;
 
 out_list:
@@ -1427,6 +1469,9 @@ void i2c_del_adapter(struct i2c_adapter *adap)
 		return;
 	}
 
+	if (ACPI_HANDLE(adap->dev.parent))
+		pm_runtime_disable(&adap->dev);
+
 	/* Tell drivers about this removal */
 	mutex_lock(&core_lock);
 	bus_for_each_drv(&i2c_bus_type, NULL, adap,
-- 
1.8.4.rc3

