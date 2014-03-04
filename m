Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755723AbaCDTZU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Mar 2014 14:25:20 -0500
Received: from mail-ea0-f172.google.com ([209.85.215.172]:64291 "EHLO
	mail-ea0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755518AbaCDTZQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Mar 2014 14:25:16 -0500
From: Valentina Manea <valentina.manea.m@gmail.com>
To: gregkh@linuxfoundation.org
Cc: ly80toro@cip.cs.fau.de, ke42caxa@cip.cs.fau.de, eladwexler77@yahoo.com,
        oat.elena@gmail.com, josh@joshtriplett.org, himangi774@gmail.com,
        linux-usb@vger.kernel.org, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org, andy.grover@gmail.com,
        firefly@lists.rosedu.org,
        Valentina Manea <valentina.manea.m@gmail.com>
Subject: [PATCH] staging: usbip: claim ports used by shared devices
Date: Tue,  4 Mar 2014 21:25:04 +0200
Message-Id: <1393961104-21856-1-git-send-email-valentina.manea.m@gmail.com>
X-Mailer: git-send-email 1.7.2.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Valentina Manea <valentina.manea.m@gmail.com>
---
 drivers/staging/usbip/stub_dev.c | 22 ++++++++++++++++++++++
 drivers/usb/core/devio.c         | 17 -----------------
 drivers/usb/core/hub.c           |  2 ++
 drivers/usb/core/usb.h           |  6 +-----
 include/linux/usb.h              | 23 +++++++++++++++++++++++
 5 files changed, 48 insertions(+), 22 deletions(-)

diff --git a/drivers/staging/usbip/stub_dev.c b/drivers/staging/usbip/stub_dev.c
index ee899f0..952743c 100644
--- a/drivers/staging/usbip/stub_dev.c
+++ b/drivers/staging/usbip/stub_dev.c
@@ -339,6 +339,7 @@ static int stub_probe(struct usb_device *udev)
 	const char *udev_busid = dev_name(&udev->dev);
 	int err = 0;
 	struct bus_id_priv *busid_priv;
+	int rc;
 
 	dev_dbg(&udev->dev, "Enter\n");
 
@@ -388,6 +389,18 @@ static int stub_probe(struct usb_device *udev)
 	busid_priv->sdev = sdev;
 	busid_priv->udev = udev;
 
+	/*
+	 * Claim this hub port.
+	 * It doesn't matter what value we pass as owner
+	 * (struct dev_state) as long as it is unique.
+	 */
+	rc = usb_hub_claim_port(udev->parent, udev->portnum,
+			(struct dev_state *) udev);
+	if (rc) {
+		dev_dbg(&udev->dev, "unable to claim port\n");
+		return rc;
+	}
+
 	err = stub_add_files(&udev->dev);
 	if (err) {
 		dev_err(&udev->dev, "stub_add_files for %s\n", udev_busid);
@@ -424,6 +437,7 @@ static void stub_disconnect(struct usb_device *udev)
 	struct stub_device *sdev;
 	const char *udev_busid = dev_name(&udev->dev);
 	struct bus_id_priv *busid_priv;
+	int rc;
 
 	dev_dbg(&udev->dev, "Enter\n");
 
@@ -448,6 +462,14 @@ static void stub_disconnect(struct usb_device *udev)
 	 */
 	stub_remove_files(&udev->dev);
 
+	/* release port */
+	rc = usb_hub_release_port(udev->parent, udev->portnum,
+				  (struct dev_state *) udev);
+	if (rc) {
+		dev_dbg(&udev->dev, "unable to release port\n");
+		return;
+	}
+
 	/* If usb reset is called from event handler */
 	if (busid_priv->sdev->ud.eh == current)
 		return;
diff --git a/drivers/usb/core/devio.c b/drivers/usb/core/devio.c
index 90e18f6..a91dc1f 100644
--- a/drivers/usb/core/devio.c
+++ b/drivers/usb/core/devio.c
@@ -62,23 +62,6 @@
 /* Mutual exclusion for removal, open, and release */
 DEFINE_MUTEX(usbfs_mutex);
 
-struct dev_state {
-	struct list_head list;      /* state list */
-	struct usb_device *dev;
-	struct file *file;
-	spinlock_t lock;            /* protects the async urb lists */
-	struct list_head async_pending;
-	struct list_head async_completed;
-	wait_queue_head_t wait;     /* wake up if a request completed */
-	unsigned int discsignr;
-	struct pid *disc_pid;
-	const struct cred *cred;
-	void __user *disccontext;
-	unsigned long ifclaimed;
-	u32 secid;
-	u32 disabled_bulk_eps;
-};
-
 struct async {
 	struct list_head asynclist;
 	struct dev_state *ps;
diff --git a/drivers/usb/core/hub.c b/drivers/usb/core/hub.c
index 64ea219..e484933 100644
--- a/drivers/usb/core/hub.c
+++ b/drivers/usb/core/hub.c
@@ -1819,6 +1819,7 @@ int usb_hub_claim_port(struct usb_device *hdev, unsigned port1,
 	*powner = owner;
 	return rc;
 }
+EXPORT_SYMBOL_GPL(usb_hub_claim_port);
 
 int usb_hub_release_port(struct usb_device *hdev, unsigned port1,
 			 struct dev_state *owner)
@@ -1834,6 +1835,7 @@ int usb_hub_release_port(struct usb_device *hdev, unsigned port1,
 	*powner = NULL;
 	return rc;
 }
+EXPORT_SYMBOL_GPL(usb_hub_release_port);
 
 void usb_hub_release_all_ports(struct usb_device *hdev, struct dev_state *owner)
 {
diff --git a/drivers/usb/core/usb.h b/drivers/usb/core/usb.h
index 8238577..79a5e76 100644
--- a/drivers/usb/core/usb.h
+++ b/drivers/usb/core/usb.h
@@ -1,8 +1,8 @@
 #include <linux/pm.h>
 #include <linux/acpi.h>
+#include <linux/usb.h>
 
 struct usb_hub_descriptor;
-struct dev_state;
 
 /* Functions local to drivers/usb/core/ */
 
@@ -57,10 +57,6 @@ extern int usb_match_device(struct usb_device *dev,
 extern void usb_forced_unbind_intf(struct usb_interface *intf);
 extern void usb_rebind_intf(struct usb_interface *intf);
 
-extern int usb_hub_claim_port(struct usb_device *hdev, unsigned port,
-		struct dev_state *owner);
-extern int usb_hub_release_port(struct usb_device *hdev, unsigned port,
-		struct dev_state *owner);
 extern void usb_hub_release_all_ports(struct usb_device *hdev,
 		struct dev_state *owner);
 extern bool usb_device_is_owned(struct usb_device *udev);
diff --git a/include/linux/usb.h b/include/linux/usb.h
index 22de4af..e0843a4 100644
--- a/include/linux/usb.h
+++ b/include/linux/usb.h
@@ -366,6 +366,24 @@ struct usb_bus {
 #endif
 };
 
+struct dev_state {
+	struct list_head list;      /* state list */
+	struct usb_device *dev;
+	struct file *file;
+	spinlock_t lock;            /* protects the async urb lists */
+	struct list_head async_pending;
+	struct list_head async_completed;
+	wait_queue_head_t wait;     /* wake up if a request completed */
+	unsigned int discsignr;
+	struct pid *disc_pid;
+	const struct cred *cred;
+	void __user *disccontext;
+	unsigned long ifclaimed;
+	u32 secid;
+	u32 disabled_bulk_eps;
+};
+
+
 /* ----------------------------------------------------------------------- */
 
 struct usb_tt;
@@ -749,6 +767,11 @@ extern struct usb_host_interface *usb_find_alt_setting(
 		unsigned int iface_num,
 		unsigned int alt_num);
 
+/* port claiming functions */
+int usb_hub_claim_port(struct usb_device *hdev, unsigned port1,
+		struct dev_state *owner);
+int usb_hub_release_port(struct usb_device *hdev, unsigned port1,
+		struct dev_state *owner);
 
 /**
  * usb_make_path - returns stable device path in the usb tree
-- 
1.8.1.2

