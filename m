Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751338Ab3CISPL (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 Mar 2013 13:15:11 -0500
Received: from smtp-out-195.synserver.de ([212.40.185.195]:1104 "EHLO
	smtp-out-193.synserver.de" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1750840Ab3CISPI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 Mar 2013 13:15:08 -0500
X-SynServer-TrustedSrc: 1
X-SynServer-AuthUser: lars@metafoo.de
X-SynServer-PPID: 31737
From: Lars-Peter Clausen <lars@metafoo.de>
To: Wolfram Sang <wsa@the-dreams.de>, Ben Dooks <ben-linux@fluff.org>
Cc: linux-i2c@vger.kernel.org, linux-kernel@vger.kernel.org,
        Lars-Peter Clausen <lars@metafoo.de>
Subject: [PATCH 1/6] i2c: Remove detach_adapter
Date: Sat,  9 Mar 2013 19:16:44 +0100
Message-Id: <1362853009-20789-2-git-send-email-lars@metafoo.de>
X-Mailer: git-send-email 1.8.0
In-Reply-To: <1362853009-20789-1-git-send-email-lars@metafoo.de>
References: <1362853009-20789-1-git-send-email-lars@metafoo.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The detach_adapter callback has been deprecated for quite some time and has no
user left. Keeping it alive blocks other cleanups, so remove it.

Signed-off-by: Lars-Peter Clausen <lars@metafoo.de>
---
 drivers/i2c/i2c-core.c | 33 ++++++++++-----------------------
 include/linux/i2c.h    |  7 ++-----
 2 files changed, 12 insertions(+), 28 deletions(-)

diff --git a/drivers/i2c/i2c-core.c b/drivers/i2c/i2c-core.c
index f7dfe87..a853cb3 100644
--- a/drivers/i2c/i2c-core.c
+++ b/drivers/i2c/i2c-core.c
@@ -47,7 +47,7 @@
 
 /* core_lock protects i2c_adapter_idr, and guarantees
    that device detection, deletion of detected devices, and attach_adapter
-   and detach_adapter calls are serialized */
+   calls are serialized */
 static DEFINE_MUTEX(core_lock);
 static DEFINE_IDR(i2c_adapter_idr);
 
@@ -1013,11 +1013,10 @@ int i2c_add_numbered_adapter(struct i2c_adapter *adap)
 }
 EXPORT_SYMBOL_GPL(i2c_add_numbered_adapter);
 
-static int i2c_do_del_adapter(struct i2c_driver *driver,
+static void i2c_do_del_adapter(struct i2c_driver *driver,
 			      struct i2c_adapter *adapter)
 {
 	struct i2c_client *client, *_n;
-	int res;
 
 	/* Remove the devices we created ourselves as the result of hardware
 	 * probing (using a driver's detect method) */
@@ -1029,16 +1028,6 @@ static int i2c_do_del_adapter(struct i2c_driver *driver,
 			i2c_unregister_device(client);
 		}
 	}
-
-	if (!driver->detach_adapter)
-		return 0;
-	dev_warn(&adapter->dev, "%s: detach_adapter method is deprecated\n",
-		 driver->driver.name);
-	res = driver->detach_adapter(adapter);
-	if (res)
-		dev_err(&adapter->dev, "detach_adapter failed (%d) "
-			"for driver [%s]\n", res, driver->driver.name);
-	return res;
 }
 
 static int __unregister_client(struct device *dev, void *dummy)
@@ -1059,7 +1048,8 @@ static int __unregister_dummy(struct device *dev, void *dummy)
 
 static int __process_removed_adapter(struct device_driver *d, void *data)
 {
-	return i2c_do_del_adapter(to_i2c_driver(d), data);
+	i2c_do_del_adapter(to_i2c_driver(d), data);
+	return 0;
 }
 
 /**
@@ -1072,7 +1062,6 @@ static int __process_removed_adapter(struct device_driver *d, void *data)
  */
 int i2c_del_adapter(struct i2c_adapter *adap)
 {
-	int res = 0;
 	struct i2c_adapter *found;
 	struct i2c_client *client, *next;
 
@@ -1088,11 +1077,9 @@ int i2c_del_adapter(struct i2c_adapter *adap)
 
 	/* Tell drivers about this removal */
 	mutex_lock(&core_lock);
-	res = bus_for_each_drv(&i2c_bus_type, NULL, adap,
+	bus_for_each_drv(&i2c_bus_type, NULL, adap,
 			       __process_removed_adapter);
 	mutex_unlock(&core_lock);
-	if (res)
-		return res;
 
 	/* Remove devices instantiated from sysfs */
 	mutex_lock_nested(&adap->userspace_clients_lock,
@@ -1111,8 +1098,8 @@ int i2c_del_adapter(struct i2c_adapter *adap)
 	 * we can't remove the dummy devices during the first pass: they
 	 * could have been instantiated by real devices wishing to clean
 	 * them up properly, so we give them a chance to do that first. */
-	res = device_for_each_child(&adap->dev, NULL, __unregister_client);
-	res = device_for_each_child(&adap->dev, NULL, __unregister_dummy);
+	device_for_each_child(&adap->dev, NULL, __unregister_client);
+	device_for_each_child(&adap->dev, NULL, __unregister_dummy);
 
 #ifdef CONFIG_I2C_COMPAT
 	class_compat_remove_link(i2c_adapter_compat_class, &adap->dev,
@@ -1208,9 +1195,9 @@ EXPORT_SYMBOL(i2c_register_driver);
 
 static int __process_removed_driver(struct device *dev, void *data)
 {
-	if (dev->type != &i2c_adapter_type)
-		return 0;
-	return i2c_do_del_adapter(data, to_i2c_adapter(dev));
+	if (dev->type == &i2c_adapter_type)
+		i2c_do_del_adapter(data, to_i2c_adapter(dev));
+	return 0;
 }
 
 /**
diff --git a/include/linux/i2c.h b/include/linux/i2c.h
index d0c4db7..8ffab3f 100644
--- a/include/linux/i2c.h
+++ b/include/linux/i2c.h
@@ -125,7 +125,6 @@ extern s32 i2c_smbus_write_i2c_block_data(const struct i2c_client *client,
  * struct i2c_driver - represent an I2C device driver
  * @class: What kind of i2c device we instantiate (for detect)
  * @attach_adapter: Callback for bus addition (deprecated)
- * @detach_adapter: Callback for bus removal (deprecated)
  * @probe: Callback for device binding
  * @remove: Callback for device unbinding
  * @shutdown: Callback for device shutdown
@@ -162,12 +161,10 @@ extern s32 i2c_smbus_write_i2c_block_data(const struct i2c_client *client,
 struct i2c_driver {
 	unsigned int class;
 
-	/* Notifies the driver that a new bus has appeared or is about to be
-	 * removed. You should avoid using this, it will be removed in a
-	 * near future.
+	/* Notifies the driver that a new bus has appeared. You should avoid
+	 * using this, it will be removed in a near future.
 	 */
 	int (*attach_adapter)(struct i2c_adapter *) __deprecated;
-	int (*detach_adapter)(struct i2c_adapter *) __deprecated;
 
 	/* Standard driver model interfaces */
 	int (*probe)(struct i2c_client *, const struct i2c_device_id *);
-- 
1.8.0

