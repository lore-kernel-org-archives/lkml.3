Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756106Ab3HaWYp (ORCPT <rfc822;w@1wt.eu>);
	Sat, 31 Aug 2013 18:24:45 -0400
Received: from mail-pd0-f171.google.com ([209.85.192.171]:47007 "EHLO
	mail-pd0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753181Ab3HaWYo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 31 Aug 2013 18:24:44 -0400
From: Guenter Roeck <linux@roeck-us.net>
To: devel@driverdev.osuosl.org
Cc: linux-kernel@vger.kernel.org, Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jakub Schmidtke <sjakub@gmail.com>, Guenter Roeck <linux@roeck-us.net>
Subject: [PATCH] staging: asus_oled: Create device attributes automatically
Date: Sat, 31 Aug 2013 15:24:36 -0700
Message-Id: <1377987876-2837-1-git-send-email-linux@roeck-us.net>
X-Mailer: git-send-email 1.7.9.7
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The 'enable' and 'picture' attributes are created for all oled_class devices.
They can be created automatically when creating the oled_class device.
This simplifies the code and ensures that the attributes exist when the
udev event announcing device registration is generated.

Signed-off-by: Guenter Roeck <linux@roeck-us.net>
---
The class 'version' attribute could be created in a similar fashion, but that
would mean not using the existing class ABI defines and function to create
a class attribute displaying a fixed string. Since this is true for pretty much
every driver using CLASS_ATTR_STRING, a more generic solution might be better.

Compile tested only.

 drivers/staging/asus_oled/asus_oled.c |   58 +++++++++++++--------------------
 1 file changed, 23 insertions(+), 35 deletions(-)

diff --git a/drivers/staging/asus_oled/asus_oled.c b/drivers/staging/asus_oled/asus_oled.c
index 3654dc3..afe91b6 100644
--- a/drivers/staging/asus_oled/asus_oled.c
+++ b/drivers/staging/asus_oled/asus_oled.c
@@ -59,7 +59,6 @@ MODULE_DESCRIPTION("Asus OLED Driver");
 MODULE_LICENSE("GPL");
 MODULE_VERSION(ASUS_OLED_VERSION);
 
-static struct class *oled_class;
 static int oled_num;
 
 static uint start_off;
@@ -625,9 +624,18 @@ static DEVICE_ATTR(asus_oled_enabled, S_IWUSR | S_IRUGO,
 		   get_enabled, set_enabled);
 static DEVICE_ATTR(asus_oled_picture, S_IWUSR , NULL, set_picture);
 
-static DEVICE_ATTR(enabled, S_IWUSR | S_IRUGO,
-		   class_get_enabled, class_set_enabled);
-static DEVICE_ATTR(picture, S_IWUSR, NULL, class_set_picture);
+static struct device_attribute oled_dev_attributes[] = {
+	__ATTR(enabled, S_IWUSR | S_IRUGO, class_get_enabled,
+	       class_set_enabled),
+	__ATTR(picture, S_IWUSR, NULL, class_set_picture),
+	{ }
+};
+
+static struct class oled_class = {
+	.owner = THIS_MODULE,
+	.name = ASUS_OLED_UNDERSCORE_NAME,
+	.dev_attrs = oled_dev_attributes,
+};
 
 static int asus_oled_probe(struct usb_interface *interface,
 			   const struct usb_device_id *id)
@@ -693,24 +701,13 @@ static int asus_oled_probe(struct usb_interface *interface,
 	if (retval)
 		goto err_files;
 
-	odev->dev = device_create(oled_class, &interface->dev, MKDEV(0, 0),
-				  NULL, "oled_%d", ++oled_num);
-
+	odev->dev = device_create(&oled_class, &interface->dev, MKDEV(0, 0),
+				  odev, "oled_%d", ++oled_num);
 	if (IS_ERR(odev->dev)) {
 		retval = PTR_ERR(odev->dev);
 		goto err_files;
 	}
 
-	dev_set_drvdata(odev->dev, odev);
-
-	retval = device_create_file(odev->dev, &dev_attr_enabled);
-	if (retval)
-		goto err_class_enabled;
-
-	retval = device_create_file(odev->dev, &dev_attr_picture);
-	if (retval)
-		goto err_class_picture;
-
 	dev_info(&interface->dev,
 		 "Attached Asus OLED device: %s [width %u, pack_mode %d]\n",
 		 desc, odev->dev_width, odev->pack_mode);
@@ -720,13 +717,6 @@ static int asus_oled_probe(struct usb_interface *interface,
 
 	return 0;
 
-err_class_picture:
-	device_remove_file(odev->dev, &dev_attr_picture);
-
-err_class_enabled:
-	device_remove_file(odev->dev, &dev_attr_enabled);
-	device_unregister(odev->dev);
-
 err_files:
 	device_remove_file(&interface->dev, &ASUS_OLED_DEVICE_ATTR(enabled));
 	device_remove_file(&interface->dev, &ASUS_OLED_DEVICE_ATTR(picture));
@@ -745,8 +735,6 @@ static void asus_oled_disconnect(struct usb_interface *interface)
 	odev = usb_get_intfdata(interface);
 	usb_set_intfdata(interface, NULL);
 
-	device_remove_file(odev->dev, &dev_attr_picture);
-	device_remove_file(odev->dev, &dev_attr_enabled);
 	device_unregister(odev->dev);
 
 	device_remove_file(&interface->dev, &ASUS_OLED_DEVICE_ATTR(picture));
@@ -807,15 +795,15 @@ static CLASS_ATTR_STRING(version, S_IRUGO,
 
 static int __init asus_oled_init(void)
 {
-	int retval = 0;
-	oled_class = class_create(THIS_MODULE, ASUS_OLED_UNDERSCORE_NAME);
+	int retval;
 
-	if (IS_ERR(oled_class)) {
-		pr_err("Error creating " ASUS_OLED_UNDERSCORE_NAME " class\n");
-		return PTR_ERR(oled_class);
+	retval = class_register(&oled_class);
+	if (retval) {
+		pr_err("Error registering " ASUS_OLED_UNDERSCORE_NAME " class\n");
+		return retval;
 	}
 
-	retval = class_create_file(oled_class, &class_attr_version.attr);
+	retval = class_create_file(&oled_class, &class_attr_version.attr);
 	if (retval) {
 		pr_err("Error creating class version file\n");
 		goto error;
@@ -831,15 +819,15 @@ static int __init asus_oled_init(void)
 	return retval;
 
 error:
-	class_destroy(oled_class);
+	class_unregister(&oled_class);
 	return retval;
 }
 
 static void __exit asus_oled_exit(void)
 {
 	usb_deregister(&oled_driver);
-	class_remove_file(oled_class, &class_attr_version.attr);
-	class_destroy(oled_class);
+	class_remove_file(&oled_class, &class_attr_version.attr);
+	class_unregister(&oled_class);
 }
 
 module_init(asus_oled_init);
-- 
1.7.9.7

