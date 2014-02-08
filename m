Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751501AbaBHLEM (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 Feb 2014 06:04:12 -0500
Received: from [125.89.61.122] ([125.89.61.122]:11988 "EHLO
	mz-mail03.meizu.com" rhost-flags-FAIL-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751063AbaBHLEK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 Feb 2014 06:04:10 -0500
From: <falcon@meizu.com>
To: <linux-kernel@vger.kernel.org>
CC: <gregkh@linuxfoundation.org>
Subject: [PATCH 1/2] async: async device driver probing
Date: Sat, 8 Feb 2014 19:05:38 +0800
Message-ID: <1391857539-27782-1-git-send-email-falcon@meizu.com>
X-Mailer: git-send-email 1.7.10.4
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [172.16.11.179]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Wu Zhangjin <wuzhangjin@gmail.com>

[*Note*: NOT applicable, only for comments.]

To async the slow driver probing function of some devices, the device probing
support is modified to support async scheduling.

In order to async your driver probing function, please mask the async_probe
flag to 1, and to make sure one asynced probing is executed before an specified
point, please call async_synchronize_full() in that point..

Usage:

	static struct i2c_driver test_driver = {
		.driver = {
			.name   = TEST_DEV_NAME,
			.owner  = THIS_MODULE,
	+               .async_probe = 1,
		},

Signed-off-by: Wu Zhangjin <falcon@meizu.com>
---
 drivers/base/dd.c      |   36 +++++++++++++++++++++++++++++++++---
 include/linux/device.h |    2 ++
 2 files changed, 35 insertions(+), 3 deletions(-)

diff --git a/drivers/base/dd.c b/drivers/base/dd.c
index 0605176..357f36e 100644
--- a/drivers/base/dd.c
+++ b/drivers/base/dd.c
@@ -23,6 +23,7 @@
 #include <linux/kthread.h>
 #include <linux/wait.h>
 #include <linux/async.h>
+#include <linux/slab.h>
 #include <linux/pm_runtime.h>
 #include <linux/pinctrl/devinfo.h>
 
@@ -357,6 +358,11 @@ void wait_for_device_probe(void)
 }
 EXPORT_SYMBOL_GPL(wait_for_device_probe);
 
+struct stupid_thread_structure {
+	struct device_driver *drv;
+	struct device *dev;
+};
+
 /**
  * driver_probe_device - attempt to bind device & driver together
  * @drv: driver to bind a device to
@@ -368,8 +374,23 @@ EXPORT_SYMBOL_GPL(wait_for_device_probe);
  * This function must be called with @dev lock held.  When called for a
  * USB interface, @dev->parent lock must be held as well.
  */
+static void __driver_probe_device(void *void_data, async_cookie_t cookie)
+{
+	struct stupid_thread_structure *data = void_data;
+	struct device_driver *drv = data->drv;
+	struct device *dev = data->dev;
+
+	pm_runtime_barrier(dev);
+	really_probe(dev, drv);
+	pm_request_idle(dev);
+
+	kfree(data);
+}
+
 int driver_probe_device(struct device_driver *drv, struct device *dev)
 {
+	struct stupid_thread_structure *data;
+	async_cookie_t cookie;
 	int ret = 0;
 
 	if (!device_is_registered(dev))
@@ -378,9 +399,18 @@ int driver_probe_device(struct device_driver *drv, struct device *dev)
 	pr_debug("bus: '%s': %s: matched device %s with driver %s\n",
 		 drv->bus->name, __func__, dev_name(dev), drv->name);
 
-	pm_runtime_barrier(dev);
-	ret = really_probe(dev, drv);
-	pm_request_idle(dev);
+	if (drv->async_probe) {
+		data = kmalloc(sizeof(*data), GFP_KERNEL);
+		data->drv = drv;
+		data->dev = dev;
+
+		cookie = async_schedule(__driver_probe_device, data);
+		pr_info("%s: async call %s driver, cookie is %llu\n", __func__, drv->name, cookie);
+	} else {
+		pm_runtime_barrier(dev);
+		ret = really_probe(dev, drv);
+		pm_request_idle(dev);
+	}
 
 	return ret;
 }
diff --git a/include/linux/device.h b/include/linux/device.h
index 952b010..f39ee48 100644
--- a/include/linux/device.h
+++ b/include/linux/device.h
@@ -247,6 +247,8 @@ struct device_driver {
 	const struct dev_pm_ops *pm;
 
 	struct driver_private *p;
+
+	unsigned int async_probe:1;
 };
 
 
-- 
1.7.10.4

