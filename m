Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753212Ab3JANKG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Oct 2013 09:10:06 -0400
Received: from mga09.intel.com ([134.134.136.24]:3347 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752802Ab3JANKD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Oct 2013 09:10:03 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.90,1013,1371106800"; 
   d="scan'208";a="403641975"
From: Mika Westerberg <mika.westerberg@linux.intel.com>
To: linux-i2c@vger.kernel.org
Cc: Wolfram Sang <wsa@the-dreams.de>, rjw@rjwysocki.net,
        Aaron Lu <aaron.lu@intel.com>, Lv Zheng <lv.zheng@intel.com>,
        Mark Brown <broonie@kernel.org>, Kevin Hilman <khilman@linaro.org>,
        Sylwester Nawrocki <s.nawrocki@samsung.com>,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-acpi@vger.kernel.org,
        Mika Westerberg <mika.westerberg@linux.intel.com>
Subject: [PATCH v4] i2c: enable runtime PM for I2C adapter devices enumerated from ACPI
Date: Tue,  1 Oct 2013 16:09:42 +0300
Message-Id: <1380632982-10709-1-git-send-email-mika.westerberg@linux.intel.com>
X-Mailer: git-send-email 1.8.4.rc3
In-Reply-To: <1380552228-23329-2-git-send-email-mika.westerberg@linux.intel.com>
References: <1380552228-23329-2-git-send-email-mika.westerberg@linux.intel.com>
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
Changes to v3:
 * Check only client ACPI_HANDLE().
 * Fixed bug where we attach the device to ACPI power domain multiple
   times.
 * Functions are renamed to _get_attach/_put_attach to make it clear that
   we do attach/detach as well.

 drivers/i2c/i2c-core.c | 47 ++++++++++++++++++++++++++++++++++++++++++++++-
 1 file changed, 46 insertions(+), 1 deletion(-)

diff --git a/drivers/i2c/i2c-core.c b/drivers/i2c/i2c-core.c
index 29d3f04..e289b1d 100644
--- a/drivers/i2c/i2c-core.c
+++ b/drivers/i2c/i2c-core.c
@@ -236,6 +236,27 @@ int i2c_recover_bus(struct i2c_adapter *adap)
 	return adap->bus_recovery_info->recover_bus(adap);
 }
 
+static void acpi_i2c_device_pm_get_attach(struct i2c_client *client,
+					  bool attach)
+{
+	if (ACPI_HANDLE(&client->dev)) {
+		/* Make sure the adapter is active */
+		pm_runtime_get_sync(&client->adapter->dev);
+		if (attach)
+			acpi_dev_pm_attach(&client->dev, true);
+	}
+}
+
+static void acpi_i2c_device_pm_put_detach(struct i2c_client *client,
+					  bool detach)
+{
+	if (ACPI_HANDLE(&client->dev)) {
+		if (detach)
+			acpi_dev_pm_detach(&client->dev, true);
+		pm_runtime_put(&client->adapter->dev);
+	}
+}
+
 static int i2c_device_probe(struct device *dev)
 {
 	struct i2c_client	*client = i2c_verify_client(dev);
@@ -254,11 +275,15 @@ static int i2c_device_probe(struct device *dev)
 					client->flags & I2C_CLIENT_WAKE);
 	dev_dbg(dev, "probe\n");
 
+	acpi_i2c_device_pm_get_attach(client, true);
+
 	status = driver->probe(client, i2c_match_id(driver->id_table, client));
 	if (status) {
 		client->driver = NULL;
 		i2c_set_clientdata(client, NULL);
 	}
+
+	acpi_i2c_device_pm_put_detach(client, !!status);
 	return status;
 }
 
@@ -271,6 +296,8 @@ static int i2c_device_remove(struct device *dev)
 	if (!client || !dev->driver)
 		return 0;
 
+	acpi_i2c_device_pm_get_attach(client, false);
+
 	driver = to_i2c_driver(dev->driver);
 	if (driver->remove) {
 		dev_dbg(dev, "remove\n");
@@ -283,6 +310,8 @@ static int i2c_device_remove(struct device *dev)
 		client->driver = NULL;
 		i2c_set_clientdata(client, NULL);
 	}
+
+	acpi_i2c_device_pm_put_detach(client, true);
 	return status;
 }
 
@@ -294,8 +323,11 @@ static void i2c_device_shutdown(struct device *dev)
 	if (!client || !dev->driver)
 		return;
 	driver = to_i2c_driver(dev->driver);
-	if (driver->shutdown)
+	if (driver->shutdown) {
+		acpi_i2c_device_pm_get_attach(client, false);
 		driver->shutdown(client);
+		acpi_i2c_device_pm_put_detach(client, false);
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

