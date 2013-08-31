Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755057Ab3HaSdM (ORCPT <rfc822;w@1wt.eu>);
	Sat, 31 Aug 2013 14:33:12 -0400
Received: from mail-pd0-f178.google.com ([209.85.192.178]:56825 "EHLO
	mail-pd0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753501Ab3HaSdK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 31 Aug 2013 14:33:10 -0400
From: Guenter Roeck <linux@roeck-us.net>
To: devel@driverdev.osuosl.org
Cc: linux-kernel@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Kees Cook <keescook@chromium.org>, Guenter Roeck <linux@roeck-us.net>
Subject: [PATCH] staging: android/timed_output: Create 'enable' attribute automatically
Date: Sat, 31 Aug 2013 11:32:58 -0700
Message-Id: <1377973978-25625-1-git-send-email-linux@roeck-us.net>
X-Mailer: git-send-email 1.7.9.7
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The 'enable' attribute is needed for all timed_output_class devices.
It can thus be created automatically when creating the timed_output device.
This simplifies the code and ensures that the attribute exists when the
udev event announcing device registration is generated.

Signed-off-by: Guenter Roeck <linux@roeck-us.net>
---
Compile tested only.

 drivers/staging/android/timed_output.c |   54 +++++++++-----------------------
 1 file changed, 15 insertions(+), 39 deletions(-)

diff --git a/drivers/staging/android/timed_output.c b/drivers/staging/android/timed_output.c
index ee3a57f..99cdb8f 100644
--- a/drivers/staging/android/timed_output.c
+++ b/drivers/staging/android/timed_output.c
@@ -24,7 +24,6 @@
 
 #include "timed_output.h"
 
-static struct class *timed_output_class;
 static atomic_t device_count;
 
 static ssize_t enable_show(struct device *dev, struct device_attribute *attr,
@@ -51,71 +50,48 @@ static ssize_t enable_store(
 	return size;
 }
 
-static DEVICE_ATTR(enable, S_IRUGO | S_IWUSR, enable_show, enable_store);
+static struct device_attribute timed_output_attrs[] = {
+	__ATTR(enable, S_IRUGO | S_IWUSR, enable_show, enable_store),
+	{ }
+};
 
-static int create_timed_output_class(void)
-{
-	if (!timed_output_class) {
-		timed_output_class = class_create(THIS_MODULE, "timed_output");
-		if (IS_ERR(timed_output_class))
-			return PTR_ERR(timed_output_class);
-		atomic_set(&device_count, 0);
-	}
-
-	return 0;
-}
+static struct class timed_output_class = {
+	.owner = THIS_MODULE,
+	.name = "timed_output",
+	.dev_attrs = timed_output_attrs,
+};
 
 int timed_output_dev_register(struct timed_output_dev *tdev)
 {
-	int ret;
-
 	if (!tdev || !tdev->name || !tdev->enable || !tdev->get_time)
 		return -EINVAL;
 
-	ret = create_timed_output_class();
-	if (ret < 0)
-		return ret;
-
+	tdev->state = 0;
 	tdev->index = atomic_inc_return(&device_count);
-	tdev->dev = device_create(timed_output_class, NULL,
-		MKDEV(0, tdev->index), NULL, "%s", tdev->name);
+	tdev->dev = device_create(&timed_output_class, NULL,
+		MKDEV(0, tdev->index), tdev, "%s", tdev->name);
 	if (IS_ERR(tdev->dev))
 		return PTR_ERR(tdev->dev);
 
-	ret = device_create_file(tdev->dev, &dev_attr_enable);
-	if (ret < 0)
-		goto err_create_file;
-
-	dev_set_drvdata(tdev->dev, tdev);
-	tdev->state = 0;
 	return 0;
-
-err_create_file:
-	device_destroy(timed_output_class, MKDEV(0, tdev->index));
-	pr_err("failed to register driver %s\n",
-			tdev->name);
-
-	return ret;
 }
 EXPORT_SYMBOL_GPL(timed_output_dev_register);
 
 void timed_output_dev_unregister(struct timed_output_dev *tdev)
 {
 	tdev->enable(tdev, 0);
-	device_remove_file(tdev->dev, &dev_attr_enable);
-	device_destroy(timed_output_class, MKDEV(0, tdev->index));
-	dev_set_drvdata(tdev->dev, NULL);
+	device_destroy(&timed_output_class, MKDEV(0, tdev->index));
 }
 EXPORT_SYMBOL_GPL(timed_output_dev_unregister);
 
 static int __init timed_output_init(void)
 {
-	return create_timed_output_class();
+	return class_register(&timed_output_class);
 }
 
 static void __exit timed_output_exit(void)
 {
-	class_destroy(timed_output_class);
+	class_unregister(&timed_output_class);
 }
 
 module_init(timed_output_init);
-- 
1.7.9.7

