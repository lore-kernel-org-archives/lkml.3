Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752043Ab3BQSCJ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Feb 2013 13:02:09 -0500
Received: from mail-bk0-f43.google.com ([209.85.214.43]:41485 "EHLO
	mail-bk0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751705Ab3BQR7x (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Feb 2013 12:59:53 -0500
From: David Herrmann <dh.herrmann@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Florian Tobias Schandinat <FlorianSchandinat@gmx.de>,
        linux-fbdev@vger.kernel.org, David Airlie <airlied@linux.ie>,
        dri-devel@lists.freedesktop.org,
        David Herrmann <dh.herrmann@googlemail.com>
Subject: [PATCH 2/9] video: sysfb: new vbefb device type
Date: Sun, 17 Feb 2013 18:59:04 +0100
Message-Id: <1361123951-587-3-git-send-email-dh.herrmann@gmail.com>
X-Mailer: git-send-email 1.8.1.3
In-Reply-To: <1361123951-587-1-git-send-email-dh.herrmann@gmail.com>
References: <1361123951-587-1-git-send-email-dh.herrmann@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: David Herrmann <dh.herrmann@googlemail.com>

This adds the VESA BIOS Extension (VBE) device type. Platform code needs
to provide the "vbefb" platform-device with a screen_info structure as
platform code.

All drivers that depend on VBE can now register as bus drivers and bind
to SYSFB_VBE devices. There is no distinction between graphics
framebuffers or plain text VGA. Drivers ought to inspect the screen_info
and return -ENODEV during probe() is they cannot make use of the device.

Only one framebuffer of type SYSFB_VBE is available on a system at a time.

Signed-off-by: David Herrmann <dh.herrmann@googlemail.com>
---
 drivers/video/sysfb.c | 77 +++++++++++++++++++++++++++++++++++++++++++++++++++
 include/linux/sysfb.h |  5 +++-
 2 files changed, 81 insertions(+), 1 deletion(-)

diff --git a/drivers/video/sysfb.c b/drivers/video/sysfb.c
index 8249006..5b47a9a 100644
--- a/drivers/video/sysfb.c
+++ b/drivers/video/sysfb.c
@@ -205,6 +205,72 @@ void sysfb_taint(struct sysfb_device *sdev, bool set)
 }
 EXPORT_SYMBOL(sysfb_taint);
 
+static void sysfb_dev_release(struct device *dev)
+{
+	struct sysfb_device *sdev = to_sysfb_device(dev);
+
+	kfree(sdev);
+}
+
+static struct sysfb_device *sysfb_dev_new(struct device *parent)
+{
+	struct sysfb_device *sdev;
+
+	sdev = kzalloc(sizeof(*sdev), GFP_KERNEL);
+	if (!sdev)
+		return NULL;
+
+	device_initialize(&sdev->dev);
+	sdev->dev.release = sysfb_dev_release;
+	sdev->dev.bus = &sysfb_bus_type;
+	sdev->dev.parent = parent;
+
+	return sdev;
+}
+
+static int sysfb_vbe_probe(struct platform_device *pdev)
+{
+	int ret;
+	struct sysfb_device *sdev;
+
+	sdev = sysfb_dev_new(&pdev->dev);
+	if (!sdev)
+		return -ENOMEM;
+
+	dev_set_name(&sdev->dev, "vbefb");
+	sdev->type = SYSFB_VBE;
+	sdev->screen = pdev->dev.platform_data;
+
+	ret = device_add(&sdev->dev);
+	if (ret)
+		goto err_free;
+
+	platform_set_drvdata(pdev, sdev);
+	return 0;
+
+err_free:
+	put_device(&sdev->dev);
+	return ret;
+}
+
+static int sysfb_vbe_remove(struct platform_device *pdev)
+{
+	struct sysfb_device *sdev = platform_get_drvdata(pdev);
+
+	device_del(&sdev->dev);
+	put_device(&sdev->dev);
+	return 0;
+}
+
+static struct platform_driver sysfb_vbe_driver = {
+	.driver = {
+		.name = "vbefb",
+		.owner = THIS_MODULE,
+	},
+	.probe = sysfb_vbe_probe,
+	.remove = sysfb_vbe_remove,
+};
+
 static int __init sysfb_init(void)
 {
 	int ret;
@@ -215,11 +281,22 @@ static int __init sysfb_init(void)
 		return ret;
 	}
 
+	ret = platform_driver_register(&sysfb_vbe_driver);
+	if (ret) {
+		pr_err("cannot register VBE framebuffer driver\n");
+		goto err_bus;
+	}
+
 	return 0;
+
+err_bus:
+	bus_unregister(&sysfb_bus_type);
+	return ret;
 }
 
 static void __exit sysfb_exit(void)
 {
+	platform_driver_unregister(&sysfb_vbe_driver);
 	bus_unregister(&sysfb_bus_type);
 }
 
diff --git a/include/linux/sysfb.h b/include/linux/sysfb.h
index 6cd3c24..1796c1e 100644
--- a/include/linux/sysfb.h
+++ b/include/linux/sysfb.h
@@ -20,6 +20,7 @@
 
 /**
  * sysfb_type
+ * @SYSFB_VBE: VESA BIOS Extension compatible device (includes VGA devices)
  *
  * Different types of available framebuffer devices. Only one device of each
  * type can be available at a time. In most systems there even is only one
@@ -29,7 +30,9 @@
  * devices.
  */
 enum sysfb_type {
-	SYSFB_TYPES = 0,
+	SYSFB_VBE = 0x01,
+
+	SYSFB_TYPES = SYSFB_VBE,
 };
 
 /**
-- 
1.8.1.3

