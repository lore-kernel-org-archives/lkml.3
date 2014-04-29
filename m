Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753356AbaD2DYA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Apr 2014 23:24:00 -0400
Received: from mail-pa0-f54.google.com ([209.85.220.54]:38229 "EHLO
	mail-pa0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751726AbaD2DX6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Apr 2014 23:23:58 -0400
Date: Mon, 28 Apr 2014 20:23:55 -0700
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: linux-input@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Alexander Shiyan <shc_work@mail.ru>
Subject: [PATCH] Input: implement managed polled input devices
Message-ID: <20140429032354.GA13445@core.coreip.homeip.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Managed resources are becoming more and more popular in drivers. Let's
implement managed polled input devices, to complement managed regular input
devices.

Similarly to managed regular input devices only one new call
devm_input_allocate_polled_device() is added and the rest of APIs is
modified to work with both managed and non-managed devices.

Signed-off-by: Dmitry Torokhov <dmitry.torokhov@gmail.com>
---
 drivers/input/input-polldev.c | 113 +++++++++++++++++++++++++++++++++++++++++-
 include/linux/input-polldev.h |   3 ++
 2 files changed, 115 insertions(+), 1 deletion(-)

diff --git a/drivers/input/input-polldev.c b/drivers/input/input-polldev.c
index 4b19190..27961fc 100644
--- a/drivers/input/input-polldev.c
+++ b/drivers/input/input-polldev.c
@@ -176,6 +176,90 @@ struct input_polled_dev *input_allocate_polled_device(void)
 }
 EXPORT_SYMBOL(input_allocate_polled_device);
 
+struct input_polled_devres {
+	struct input_polled_dev *polldev;
+};
+
+static int devm_input_polldev_match(struct device *dev, void *res, void *data)
+{
+	struct input_polled_devres *devres = res;
+
+	return devres->polldev == data;
+}
+
+static void devm_input_polldev_release(struct device *dev, void *res)
+{
+	struct input_polled_devres *devres = res;
+	struct input_polled_dev *polldev = devres->polldev;
+
+	dev_dbg(dev, "%s: dropping reference/freeing %s\n",
+		__func__, dev_name(&polldev->input->dev));
+
+	input_put_device(polldev->input);
+	kfree(polldev);
+}
+
+static void devm_input_polldev_unregister(struct device *dev, void *res)
+{
+	struct input_polled_devres *devres = res;
+	struct input_polled_dev *polldev = devres->polldev;
+
+	dev_dbg(dev, "%s: unregistering device %s\n",
+		__func__, dev_name(&polldev->input->dev));
+	input_unregister_device(polldev->input);
+
+	/*
+	 * Note that we are still holding extra reference to the input
+	 * device so it will stick around until devm_input_polldev_release()
+	 * is called.
+	 */
+}
+
+/**
+ * devm_input_allocate_polled_device - allocate managed polled device
+ * @dev: device owning the polled device being created
+ *
+ * Returns prepared &struct input_polled_dev or %NULL.
+ *
+ * Managed polled input devices do not need to be explicitly unregistered
+ * or freed as it will be done automatically when owner device unbinds
+ * from * its driver (or binding fails). Once such managed polled device
+ * is allocated, it is ready to be set up and registered in the same
+ * fashion as regular polled input devices (using
+ * input_register_polled_device() function).
+ *
+ * If you want to manually unregister and free such managed polled devices,
+ * it can be still done by calling input_unregister_polled_device() and
+ * input_free_polled_device(), although it is rarely needed.
+ *
+ * NOTE: the owner device is set up as parent of input device and users
+ * should not override it.
+ */
+struct input_polled_dev *devm_input_allocate_polled_device(struct device *dev)
+{
+	struct input_polled_dev *polldev;
+	struct input_polled_devres *devres;
+
+	devres = devres_alloc(devm_input_polldev_release, sizeof(*devres),
+			      GFP_KERNEL);
+	if (!devres)
+		return NULL;
+
+	polldev = input_allocate_polled_device();
+	if (!polldev) {
+		devres_free(devres);
+		return NULL;
+	}
+
+	polldev->input->dev.parent = dev;
+	polldev->devres_managed = true;
+
+	devres->polldev = polldev;
+	devres_add(dev, devres);
+
+	return polldev;
+}
+
 /**
  * input_free_polled_device - free memory allocated for polled device
  * @dev: device to free
@@ -186,7 +270,12 @@ EXPORT_SYMBOL(input_allocate_polled_device);
 void input_free_polled_device(struct input_polled_dev *dev)
 {
 	if (dev) {
-		input_free_device(dev->input);
+		if (dev->devres_managed)
+			WARN_ON(devres_destroy(dev->input->dev.parent,
+						devm_input_polldev_release,
+						devm_input_polldev_match,
+						dev));
+		input_put_device(dev->input);
 		kfree(dev);
 	}
 }
@@ -204,9 +293,19 @@ EXPORT_SYMBOL(input_free_polled_device);
  */
 int input_register_polled_device(struct input_polled_dev *dev)
 {
+	struct input_polled_devres *devres = NULL;
 	struct input_dev *input = dev->input;
 	int error;
 
+	if (dev->devres_managed) {
+		devres = devres_alloc(devm_input_polldev_unregister,
+				      sizeof(*devres), GFP_KERNEL);
+		if (!devres)
+			return -ENOMEM;
+
+		devres->polldev = dev;
+	}
+
 	input_set_drvdata(input, dev);
 	INIT_DELAYED_WORK(&dev->work, input_polled_device_work);
 
@@ -233,6 +332,12 @@ int input_register_polled_device(struct input_polled_dev *dev)
 	 */
 	input_get_device(input);
 
+	if (dev->devres_managed) {
+		dev_dbg(input->dev.parent, "%s: registering %s with devres.\n",
+			__func__, dev_name(&input->dev));
+		devres_add(input->dev.parent, devres);
+	}
+
 	return 0;
 }
 EXPORT_SYMBOL(input_register_polled_device);
@@ -247,6 +352,12 @@ EXPORT_SYMBOL(input_register_polled_device);
  */
 void input_unregister_polled_device(struct input_polled_dev *dev)
 {
+	if (dev->devres_managed)
+		WARN_ON(devres_destroy(dev->input->dev.parent,
+					devm_input_polldev_unregister,
+					devm_input_polldev_match,
+					dev));
+
 	input_unregister_device(dev->input);
 }
 EXPORT_SYMBOL(input_unregister_polled_device);
diff --git a/include/linux/input-polldev.h b/include/linux/input-polldev.h
index ce0b724..2465182 100644
--- a/include/linux/input-polldev.h
+++ b/include/linux/input-polldev.h
@@ -48,9 +48,12 @@ struct input_polled_dev {
 
 /* private: */
 	struct delayed_work work;
+
+	bool devres_managed;
 };
 
 struct input_polled_dev *input_allocate_polled_device(void);
+struct input_polled_dev *devm_input_allocate_polled_device(struct device *dev);
 void input_free_polled_device(struct input_polled_dev *dev);
 int input_register_polled_device(struct input_polled_dev *dev);
 void input_unregister_polled_device(struct input_polled_dev *dev);
-- 
1.9.0


-- 
Dmitry
