Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758859Ab3DYQIi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Apr 2013 12:08:38 -0400
Received: from mail-pa0-f44.google.com ([209.85.220.44]:47430 "EHLO
	mail-pa0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757061Ab3DYQIg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Apr 2013 12:08:36 -0400
From: Julius Werner <jwerner@chromium.org>
To: linux-kernel@vger.kernel.org
Cc: Alan Stern <stern@rowland.harvard.edu>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-usb@vger.kernel.org, Vincent Palatin <vpalatin@chromium.org>,
        Sameer Nanda <snanda@chromium.org>,
        Julius Werner <jwerner@chromium.org>
Subject: [PATCH v3] usb: ehci: Only sleep for post-resume handover if devices use persist
Date: Thu, 25 Apr 2013 09:08:27 -0700
Message-Id: <1366906107-22669-1-git-send-email-jwerner@chromium.org>
X-Mailer: git-send-email 1.8.2.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The current EHCI code sleeps a flat 110ms in the resume path if there
was a USB 1.1 device connected to its companion controller during
suspend, waiting for the device to reappear and reset so that it can be
handed back to the companion. This is necessary if the device uses
persist, so that the companion controller can actually see it during its
own resume path.

However, if the device doesn't use persist, this is entirely
unnecessary. We might just as well ignore it and have the normal device
detection/reset/handoff code handle it asynchronously when it eventually
shows up. As USB 1.1 devices are almost exclusively HIDs these days (for
which persist has no value), this can allow distros to shave another
tenth of a second off their resume time.

In order to enable this optimization, the patch also adds a new
usb_for_each_dev() iterator that is exported by the USB core and wraps
bus_for_each_dev() with the logic to differentiate between struct
usb_device and struct usb_interface on the usb_bus_type bus.

Signed-off-by: Julius Werner <jwerner@chromium.org>
Acked-by: Alan Stern <stern@rowland.harvard.edu>
---
 drivers/usb/core/usb.c      | 33 +++++++++++++++++++++++++++++++++
 drivers/usb/host/ehci-hub.c | 17 +++++++++++++++++
 include/linux/usb.h         |  1 +
 3 files changed, 51 insertions(+)

diff --git a/drivers/usb/core/usb.c b/drivers/usb/core/usb.c
index f81b925..eaf09e6 100644
--- a/drivers/usb/core/usb.c
+++ b/drivers/usb/core/usb.c
@@ -209,6 +209,39 @@ struct usb_interface *usb_find_interface(struct usb_driver *drv, int minor)
 }
 EXPORT_SYMBOL_GPL(usb_find_interface);
 
+struct each_dev_arg {
+	void *data;
+	int (*fn)(struct usb_device *, void *);
+};
+
+static int __each_dev(struct device *dev, void *data)
+{
+	struct each_dev_arg *arg = (struct each_dev_arg *)data;
+
+	/* There are struct usb_interface on the same bus, filter them out */
+	if (!is_usb_device(dev))
+		return 0;
+
+	return arg->fn(container_of(dev, struct usb_device, dev), arg->data);
+}
+
+/**
+ * usb_for_each_dev - iterate over all USB devices in the system
+ * @data: data pointer that will be handed to the callback function
+ * @fn: callback function to be called for each USB device
+ *
+ * Iterate over all USB devices and call @fn for each, passing it @data. If it
+ * returns anything other than 0, we break the iteration prematurely and return
+ * that value.
+ */
+int usb_for_each_dev(void *data, int (*fn)(struct usb_device *, void *))
+{
+	struct each_dev_arg arg = {data, fn};
+
+	return bus_for_each_dev(&usb_bus_type, NULL, &arg, __each_dev);
+}
+EXPORT_SYMBOL_GPL(usb_for_each_dev);
+
 /**
  * usb_release_dev - free a usb device structure when all users of it are finished.
  * @dev: device that's been disconnected
diff --git a/drivers/usb/host/ehci-hub.c b/drivers/usb/host/ehci-hub.c
index 7d06e77..a46452d 100644
--- a/drivers/usb/host/ehci-hub.c
+++ b/drivers/usb/host/ehci-hub.c
@@ -42,6 +42,13 @@ static int ehci_hub_control(
 	u16		wLength
 );
 
+static int persist_enabled_on_companion(struct usb_device *udev, void *unused)
+{
+	return !udev->maxchild && udev->persist_enabled &&
+		udev->bus->root_hub->speed < USB_SPEED_HIGH;
+}
+
 /* After a power loss, ports that were owned by the companion must be
  * reset so that the companion can still own them.
  */
@@ -56,6 +63,16 @@ static void ehci_handover_companion_ports(struct ehci_hcd *ehci)
 	if (!ehci->owned_ports)
 		return;
 
+	/*
+	 * USB 1.1 devices are mostly HIDs, which don't need to persist across
+	 * suspends. If we ensure that none of our companion's devices have
+	 * persist_enabled (by looking through all USB 1.1 buses in the system),
+	 * we can skip this and avoid slowing resume down. Devices without
+	 * persist will just get reenumerated shortly after resume anyway.
+	 */
+	if (!usb_for_each_dev(NULL, persist_enabled_on_companion))
+		return;
+
 	/* Make sure the ports are powered */
 	port = HCS_N_PORTS(ehci->hcs_params);
 	while (port--) {
diff --git a/include/linux/usb.h b/include/linux/usb.h
index 4d22d0f..559cb39 100644
--- a/include/linux/usb.h
+++ b/include/linux/usb.h
@@ -719,6 +719,7 @@ const struct usb_device_id *usb_match_id(struct usb_interface *interface,
 extern int usb_match_one_id(struct usb_interface *interface,
 			    const struct usb_device_id *id);
 
+extern int usb_for_each_dev(void *data, int (*fn)(struct usb_device *, void *));
 extern struct usb_interface *usb_find_interface(struct usb_driver *drv,
 		int minor);
 extern struct usb_interface *usb_ifnum_to_if(const struct usb_device *dev,
-- 
1.7.12.4

