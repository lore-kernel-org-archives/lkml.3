Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753565AbaBGLyv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Feb 2014 06:54:51 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:42566 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755469AbaBGLwz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Feb 2014 06:52:55 -0500
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Thomas Pugliese <thomas.pugliese@gmail.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.11 228/233] usb: core: get config and string descriptors for unauthorized devices
Date: Fri,  7 Feb 2014 11:47:27 +0000
Message-Id: <1391773652-25214-229-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1391773652-25214-1-git-send-email-luis.henriques@canonical.com>
References: <1391773652-25214-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.11.10.4 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Thomas Pugliese <thomas.pugliese@gmail.com>

commit 83e83ecb79a8225e79bc8e54e9aff3e0e27658a2 upstream.

There is no need to skip querying the config and string descriptors for
unauthorized WUSB devices when usb_new_device is called.  It is allowed
by WUSB spec.  The only action that needs to be delayed until
authorization time is the set config.  This change allows user mode
tools to see the config and string descriptors earlier in enumeration
which is needed for some WUSB devices to function properly on Android
systems.  It also reduces the amount of divergent code paths needed
for WUSB devices.

Signed-off-by: Thomas Pugliese <thomas.pugliese@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
[ luis: backported to 3.11: adjusted context ]
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 drivers/usb/core/config.c |  7 -------
 drivers/usb/core/hub.c    | 40 +++++++---------------------------------
 2 files changed, 7 insertions(+), 40 deletions(-)

diff --git a/drivers/usb/core/config.c b/drivers/usb/core/config.c
index a6b2cab..548d199 100644
--- a/drivers/usb/core/config.c
+++ b/drivers/usb/core/config.c
@@ -651,10 +651,6 @@ void usb_destroy_configuration(struct usb_device *dev)
  *
  * hub-only!! ... and only in reset path, or usb_new_device()
  * (used by real hubs and virtual root hubs)
- *
- * NOTE: if this is a WUSB device and is not authorized, we skip the
- *       whole thing. A non-authorized USB device has no
- *       configurations.
  */
 int usb_get_configuration(struct usb_device *dev)
 {
@@ -666,8 +662,6 @@ int usb_get_configuration(struct usb_device *dev)
 	struct usb_config_descriptor *desc;
 
 	cfgno = 0;
-	if (dev->authorized == 0)	/* Not really an error */
-		goto out_not_authorized;
 	result = -ENOMEM;
 	if (ncfg > USB_MAXCONFIG) {
 		dev_warn(ddev, "too many configurations: %d, "
@@ -751,7 +745,6 @@ int usb_get_configuration(struct usb_device *dev)
 
 err:
 	kfree(desc);
-out_not_authorized:
 	dev->descriptor.bNumConfigurations = cfgno;
 err2:
 	if (result == -ENOMEM)
diff --git a/drivers/usb/core/hub.c b/drivers/usb/core/hub.c
index 8b8eec8..0e72571 100644
--- a/drivers/usb/core/hub.c
+++ b/drivers/usb/core/hub.c
@@ -2233,18 +2233,13 @@ static int usb_enumerate_device(struct usb_device *udev)
 			return err;
 		}
 	}
-	if (udev->wusb == 1 && udev->authorized == 0) {
-		udev->product = kstrdup("n/a (unauthorized)", GFP_KERNEL);
-		udev->manufacturer = kstrdup("n/a (unauthorized)", GFP_KERNEL);
-		udev->serial = kstrdup("n/a (unauthorized)", GFP_KERNEL);
-	}
-	else {
-		/* read the standard strings and cache them if present */
-		udev->product = usb_cache_string(udev, udev->descriptor.iProduct);
-		udev->manufacturer = usb_cache_string(udev,
-						      udev->descriptor.iManufacturer);
-		udev->serial = usb_cache_string(udev, udev->descriptor.iSerialNumber);
-	}
+
+	/* read the standard strings and cache them if present */
+	udev->product = usb_cache_string(udev, udev->descriptor.iProduct);
+	udev->manufacturer = usb_cache_string(udev,
+					      udev->descriptor.iManufacturer);
+	udev->serial = usb_cache_string(udev, udev->descriptor.iSerialNumber);
+
 	err = usb_enumerate_device_otg(udev);
 	if (err < 0)
 		return err;
@@ -2423,16 +2418,6 @@ int usb_deauthorize_device(struct usb_device *usb_dev)
 	usb_dev->authorized = 0;
 	usb_set_configuration(usb_dev, -1);
 
-	kfree(usb_dev->product);
-	usb_dev->product = kstrdup("n/a (unauthorized)", GFP_KERNEL);
-	kfree(usb_dev->manufacturer);
-	usb_dev->manufacturer = kstrdup("n/a (unauthorized)", GFP_KERNEL);
-	kfree(usb_dev->serial);
-	usb_dev->serial = kstrdup("n/a (unauthorized)", GFP_KERNEL);
-
-	usb_destroy_configuration(usb_dev);
-	usb_dev->descriptor.bNumConfigurations = 0;
-
 out_unauthorized:
 	usb_unlock_device(usb_dev);
 	return 0;
@@ -2460,17 +2445,7 @@ int usb_authorize_device(struct usb_device *usb_dev)
 		goto error_device_descriptor;
 	}
 
-	kfree(usb_dev->product);
-	usb_dev->product = NULL;
-	kfree(usb_dev->manufacturer);
-	usb_dev->manufacturer = NULL;
-	kfree(usb_dev->serial);
-	usb_dev->serial = NULL;
-
 	usb_dev->authorized = 1;
-	result = usb_enumerate_device(usb_dev);
-	if (result < 0)
-		goto error_enumerate;
 	/* Choose and set the configuration.  This registers the interfaces
 	 * with the driver core and lets interface drivers bind to them.
 	 */
@@ -2486,7 +2461,6 @@ int usb_authorize_device(struct usb_device *usb_dev)
 	}
 	dev_info(&usb_dev->dev, "authorized to connect\n");
 
-error_enumerate:
 error_device_descriptor:
 	usb_autosuspend_device(usb_dev);
 error_autoresume:
-- 
1.8.3.2

