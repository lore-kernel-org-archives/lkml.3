Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754502AbaEDPmN (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 May 2014 11:42:13 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:36328 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754372AbaEDPmE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 May 2014 11:42:04 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Alan Stern <stern@rowland.harvard.edu>
Subject: [PATCH 3.14 129/158] USB: unbind all interfaces before rebinding any
Date: Sun,  4 May 2014 11:40:38 -0400
Message-Id: <20140504154047.545635346@linuxfoundation.org>
X-Mailer: git-send-email 1.9.0
In-Reply-To: <20140504154029.975081050@linuxfoundation.org>
References: <20140504154029.975081050@linuxfoundation.org>
User-Agent: quilt/0.60-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alan Stern <stern@rowland.harvard.edu>

commit 6aec044cc2f5670cf3b143c151c8be846499bd15 upstream.

When a driver doesn't have pre_reset, post_reset, or reset_resume
methods, the USB core unbinds that driver when its device undergoes a
reset or a reset-resume, and then rebinds it afterward.

The existing straightforward implementation can lead to problems,
because each interface gets unbound and rebound before the next
interface is handled.  If a driver claims additional interfaces, the
claim may fail because the old binding instance may still own the
additional interface when the new instance tries to claim it.

This patch fixes the problem by first unbinding all the interfaces
that are marked (i.e., their needs_binding flag is set) and then
rebinding all of them.

The patch also makes the helper functions in driver.c a little more
uniform and adjusts some out-of-date comments.

Signed-off-by: Alan Stern <stern@rowland.harvard.edu>
Reported-and-tested-by: "Poulain, Loic" <loic.poulain@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/usb/core/driver.c |   94 +++++++++++++++++++++++++++-------------------
 drivers/usb/core/hub.c    |    5 +-
 drivers/usb/core/usb.h    |    2 
 3 files changed, 60 insertions(+), 41 deletions(-)

--- a/drivers/usb/core/driver.c
+++ b/drivers/usb/core/driver.c
@@ -990,8 +990,7 @@ EXPORT_SYMBOL_GPL(usb_deregister);
  * it doesn't support pre_reset/post_reset/reset_resume or
  * because it doesn't support suspend/resume.
  *
- * The caller must hold @intf's device's lock, but not its pm_mutex
- * and not @intf->dev.sem.
+ * The caller must hold @intf's device's lock, but not @intf's lock.
  */
 void usb_forced_unbind_intf(struct usb_interface *intf)
 {
@@ -1004,16 +1003,37 @@ void usb_forced_unbind_intf(struct usb_i
 	intf->needs_binding = 1;
 }
 
+/*
+ * Unbind drivers for @udev's marked interfaces.  These interfaces have
+ * the needs_binding flag set, for example by usb_resume_interface().
+ *
+ * The caller must hold @udev's device lock.
+ */
+static void unbind_marked_interfaces(struct usb_device *udev)
+{
+	struct usb_host_config	*config;
+	int			i;
+	struct usb_interface	*intf;
+
+	config = udev->actconfig;
+	if (config) {
+		for (i = 0; i < config->desc.bNumInterfaces; ++i) {
+			intf = config->interface[i];
+			if (intf->dev.driver && intf->needs_binding)
+				usb_forced_unbind_intf(intf);
+		}
+	}
+}
+
 /* Delayed forced unbinding of a USB interface driver and scan
  * for rebinding.
  *
- * The caller must hold @intf's device's lock, but not its pm_mutex
- * and not @intf->dev.sem.
+ * The caller must hold @intf's device's lock, but not @intf's lock.
  *
  * Note: Rebinds will be skipped if a system sleep transition is in
  * progress and the PM "complete" callback hasn't occurred yet.
  */
-void usb_rebind_intf(struct usb_interface *intf)
+static void usb_rebind_intf(struct usb_interface *intf)
 {
 	int rc;
 
@@ -1030,68 +1050,66 @@ void usb_rebind_intf(struct usb_interfac
 	}
 }
 
-#ifdef CONFIG_PM
-
-/* Unbind drivers for @udev's interfaces that don't support suspend/resume
- * There is no check for reset_resume here because it can be determined
- * only during resume whether reset_resume is needed.
+/*
+ * Rebind drivers to @udev's marked interfaces.  These interfaces have
+ * the needs_binding flag set.
  *
  * The caller must hold @udev's device lock.
  */
-static void unbind_no_pm_drivers_interfaces(struct usb_device *udev)
+static void rebind_marked_interfaces(struct usb_device *udev)
 {
 	struct usb_host_config	*config;
 	int			i;
 	struct usb_interface	*intf;
-	struct usb_driver	*drv;
 
 	config = udev->actconfig;
 	if (config) {
 		for (i = 0; i < config->desc.bNumInterfaces; ++i) {
 			intf = config->interface[i];
-
-			if (intf->dev.driver) {
-				drv = to_usb_driver(intf->dev.driver);
-				if (!drv->suspend || !drv->resume)
-					usb_forced_unbind_intf(intf);
-			}
+			if (intf->needs_binding)
+				usb_rebind_intf(intf);
 		}
 	}
 }
 
-/* Unbind drivers for @udev's interfaces that failed to support reset-resume.
- * These interfaces have the needs_binding flag set by usb_resume_interface().
+/*
+ * Unbind all of @udev's marked interfaces and then rebind all of them.
+ * This ordering is necessary because some drivers claim several interfaces
+ * when they are first probed.
  *
  * The caller must hold @udev's device lock.
  */
-static void unbind_no_reset_resume_drivers_interfaces(struct usb_device *udev)
+void usb_unbind_and_rebind_marked_interfaces(struct usb_device *udev)
 {
-	struct usb_host_config	*config;
-	int			i;
-	struct usb_interface	*intf;
-
-	config = udev->actconfig;
-	if (config) {
-		for (i = 0; i < config->desc.bNumInterfaces; ++i) {
-			intf = config->interface[i];
-			if (intf->dev.driver && intf->needs_binding)
-				usb_forced_unbind_intf(intf);
-		}
-	}
+	unbind_marked_interfaces(udev);
+	rebind_marked_interfaces(udev);
 }
 
-static void do_rebind_interfaces(struct usb_device *udev)
+#ifdef CONFIG_PM
+
+/* Unbind drivers for @udev's interfaces that don't support suspend/resume
+ * There is no check for reset_resume here because it can be determined
+ * only during resume whether reset_resume is needed.
+ *
+ * The caller must hold @udev's device lock.
+ */
+static void unbind_no_pm_drivers_interfaces(struct usb_device *udev)
 {
 	struct usb_host_config	*config;
 	int			i;
 	struct usb_interface	*intf;
+	struct usb_driver	*drv;
 
 	config = udev->actconfig;
 	if (config) {
 		for (i = 0; i < config->desc.bNumInterfaces; ++i) {
 			intf = config->interface[i];
-			if (intf->needs_binding)
-				usb_rebind_intf(intf);
+
+			if (intf->dev.driver) {
+				drv = to_usb_driver(intf->dev.driver);
+				if (!drv->suspend || !drv->resume)
+					usb_forced_unbind_intf(intf);
+			}
 		}
 	}
 }
@@ -1420,7 +1438,7 @@ int usb_resume_complete(struct device *d
 	 * whose needs_binding flag is set
 	 */
 	if (udev->state != USB_STATE_NOTATTACHED)
-		do_rebind_interfaces(udev);
+		rebind_marked_interfaces(udev);
 	return 0;
 }
 
@@ -1442,7 +1460,7 @@ int usb_resume(struct device *dev, pm_me
 		pm_runtime_disable(dev);
 		pm_runtime_set_active(dev);
 		pm_runtime_enable(dev);
-		unbind_no_reset_resume_drivers_interfaces(udev);
+		unbind_marked_interfaces(udev);
 	}
 
 	/* Avoid PM error messages for devices disconnected while suspended
--- a/drivers/usb/core/hub.c
+++ b/drivers/usb/core/hub.c
@@ -5340,10 +5340,11 @@ int usb_reset_device(struct usb_device *
 				else if (cintf->condition ==
 						USB_INTERFACE_BOUND)
 					rebind = 1;
+				if (rebind)
+					cintf->needs_binding = 1;
 			}
-			if (ret == 0 && rebind)
-				usb_rebind_intf(cintf);
 		}
+		usb_unbind_and_rebind_marked_interfaces(udev);
 	}
 
 	usb_autosuspend_device(udev);
--- a/drivers/usb/core/usb.h
+++ b/drivers/usb/core/usb.h
@@ -55,7 +55,7 @@ extern int usb_match_one_id_intf(struct
 extern int usb_match_device(struct usb_device *dev,
 			    const struct usb_device_id *id);
 extern void usb_forced_unbind_intf(struct usb_interface *intf);
-extern void usb_rebind_intf(struct usb_interface *intf);
+extern void usb_unbind_and_rebind_marked_interfaces(struct usb_device *udev);
 
 extern int usb_hub_claim_port(struct usb_device *hdev, unsigned port,
 		struct dev_state *owner);


