Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752352AbaCFGJb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Mar 2014 01:09:31 -0500
Received: from mail-ea0-f171.google.com ([209.85.215.171]:62421 "EHLO
	mail-ea0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750986AbaCFGJ3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Mar 2014 01:09:29 -0500
From: Valentina Manea <valentina.manea.m@gmail.com>
To: gregkh@linuxfoundation.org
Cc: ly80toro@cip.cs.fau.de, ke42caxa@cip.cs.fau.de, eladwexler77@yahoo.com,
        oat.elena@gmail.com, josh@joshtriplett.org, himangi774@gmail.com,
        linux-usb@vger.kernel.org, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org, andy.grover@gmail.com,
        firefly@lists.rosedu.org,
        Valentina Manea <valentina.manea.m@gmail.com>
Subject: [PATCH v2] staging: usbip: claim ports used by shared devices
Date: Thu,  6 Mar 2014 08:09:04 +0200
Message-Id: <1394086144-13864-1-git-send-email-valentina.manea.m@gmail.com>
X-Mailer: git-send-email 1.7.2.5
In-Reply-To: <1393961104-21856-1-git-send-email-valentina.manea.m@gmail.com>
References: <1393961104-21856-1-git-send-email-valentina.manea.m@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

A device should not be able to be used concurrently both by
the server and the client. Claiming the port used by the
shared device ensures no interface drivers bind to it and
that it is not usable from the server.

Signed-off-by: Valentina Manea <valentina.manea.m@gmail.com>
---
Changes since v1:
* add commit description
* move struct dev_state definition back to usb/core/devio.c

 drivers/staging/usbip/stub_dev.c | 22 ++++++++++++++++++++++
 drivers/usb/core/hub.c           |  2 ++
 drivers/usb/core/usb.h           |  4 ----
 include/linux/usb.h              |  7 +++++++
 4 files changed, 31 insertions(+), 4 deletions(-)

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
index 8238577..222bbd2 100644
--- a/drivers/usb/core/usb.h
+++ b/drivers/usb/core/usb.h
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
index 22de4af..140a6a3 100644
--- a/include/linux/usb.h
+++ b/include/linux/usb.h
@@ -366,6 +366,8 @@ struct usb_bus {
 #endif
 };
 
+struct dev_state;
+
 /* ----------------------------------------------------------------------- */
 
 struct usb_tt;
@@ -749,6 +751,11 @@ extern struct usb_host_interface *usb_find_alt_setting(
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

