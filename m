Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756859Ab3DWVuI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Apr 2013 17:50:08 -0400
Received: from mail-da0-f46.google.com ([209.85.210.46]:64518 "EHLO
	mail-da0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755949Ab3DWVuF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Apr 2013 17:50:05 -0400
From: Julius Werner <jwerner@chromium.org>
To: linux-kernel@vger.kernel.org
Cc: Alan Stern <stern@rowland.harvard.edu>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-usb@vger.kernel.org, Vincent Palatin <vpalatin@chromium.org>,
        Sameer Nanda <snanda@chromium.org>,
        Julius Werner <jwerner@chromium.org>
Subject: [PATCH] usb: ehci: Only sleep for post-resume handover if devices use persist
Date: Tue, 23 Apr 2013 14:49:22 -0700
Message-Id: <1366753762-6194-1-git-send-email-jwerner@chromium.org>
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

Signed-off-by: Julius Werner <jwerner@chromium.org>
---
 drivers/usb/host/ehci-hub.c | 21 +++++++++++++++++++++
 1 file changed, 21 insertions(+)

diff --git a/drivers/usb/host/ehci-hub.c b/drivers/usb/host/ehci-hub.c
index 7d06e77..2507afb 100644
--- a/drivers/usb/host/ehci-hub.c
+++ b/drivers/usb/host/ehci-hub.c
@@ -29,6 +29,8 @@
 /*-------------------------------------------------------------------------*/
 #include <linux/usb/otg.h>
 
+#include "../core/usb.h"
+
 #define	PORT_WAKE_BITS	(PORT_WKOC_E|PORT_WKDISC_E|PORT_WKCONN_E)
 
 #ifdef	CONFIG_PM
@@ -42,6 +44,18 @@ static int ehci_hub_control(
 	u16		wLength
 );
 
+
+static int companion_persist(struct device *dev, void *unused)
+{
+	struct usb_device *udev = container_of(dev, struct usb_device, dev);
+
+	if (!is_usb_device(dev))
+		return 0;  /* Filter out struct usb_interface on the same bus */
+
+	return !udev->maxchild && udev->persist_enabled &&
+		udev->bus->root_hub->speed < USB_SPEED_HIGH;
+}
+
 /* After a power loss, ports that were owned by the companion must be
  * reset so that the companion can still own them.
  */
@@ -56,6 +70,13 @@ static void ehci_handover_companion_ports(struct ehci_hcd *ehci)
 	if (!ehci->owned_ports)
 		return;
 
+	/* Check if any USB 1.1 controller in the system uses a non-hub device
+	 * with persist enabled. If they don't, the device will get reenumerated
+	 * anyway and there is no need to slow resume down to wait for it.
+	 */
+	if (!bus_for_each_dev(&usb_bus_type, NULL, NULL, companion_persist))
+		return;
+
 	/* Make sure the ports are powered */
 	port = HCS_N_PORTS(ehci->hcs_params);
 	while (port--) {
-- 
1.8.2.1

