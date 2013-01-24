Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753685Ab3AXDob (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jan 2013 22:44:31 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:44158 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753019Ab3AXD2U (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jan 2013 22:28:20 -0500
From: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Sarah Sharp <sarah.a.sharp@linux.intel.com>,
        Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
Subject: [PATCH 11/74] USB: Allow USB 3.0 ports to be disabled.
Date: Thu, 24 Jan 2013 01:26:23 -0200
Message-Id: <1358998046-613-12-git-send-email-herton.krzesinski@canonical.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1358998046-613-1-git-send-email-herton.krzesinski@canonical.com>
References: <1358998046-613-1-git-send-email-herton.krzesinski@canonical.com>
X-Extended-Stable: 3.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.4 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sarah Sharp <sarah.a.sharp@linux.intel.com>

commit 41e7e056cdc662f704fa9262e5c6e213b4ab45dd upstream.

If hot and warm reset fails, or a port remains in the Compliance Mode,
the USB core needs to be able to disable a USB 3.0 port.  Unlike USB 2.0
ports, once the port is placed into the Disabled link state, it will not
report any new device connects.  To get device connect notifications, we
need to put the link into the Disabled state, and then the RxDetect
state.

The xHCI driver needs to atomically clear all change bits on USB 3.0
port disable, so that we get Port Status Change Events for future port
changes.  We could technically do this in the USB core instead of in the
xHCI roothub code, since the port state machine can't advance out of the
disabled state until we set the link state to RxDetect.  However,
external USB 3.0 hubs don't need this code.  They are level-triggered,
not edge-triggered like xHCI, so they will continue to send interrupt
events when any change bit is set.  Therefore it doesn't make sense to
put this code in the USB core.

This patch is part of a series to fix several reports of infinite loops
on device enumeration failure.  This includes John, when he boots with
a USB 3.0 device (Roseweil eusb3 enclosure) attached to his NEC 0.96
host controller.  The fix requires warm reset support, so it does not
make sense to backport this patch to stable kernels without warm reset
support.

This patch should be backported to kernels as old as 3.2, contain the
commit ID 75d7cf72ab9fa01dc70877aa5c68e8ef477229dc "usbcore: refine warm
reset logic"

Signed-off-by: Sarah Sharp <sarah.a.sharp@linux.intel.com>
Acked-by: Alan Stern <stern@rowland.harvard.edu>
Reported-by: John Covici <covici@ccs.covici.com>
[ herton: adjust context ]
Signed-off-by: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
---
 drivers/usb/core/hub.c      |   63 +++++++++++++++++++++++++++++++++++++++++--
 drivers/usb/host/xhci-hub.c |   31 +++++++++++++++++++--
 2 files changed, 90 insertions(+), 4 deletions(-)

diff --git a/drivers/usb/core/hub.c b/drivers/usb/core/hub.c
index 03af701..ba01327 100644
--- a/drivers/usb/core/hub.c
+++ b/drivers/usb/core/hub.c
@@ -866,6 +866,60 @@ static int hub_hub_status(struct usb_hub *hub,
 	return ret;
 }
 
+static int hub_set_port_link_state(struct usb_hub *hub, int port1,
+			unsigned int link_status)
+{
+	return set_port_feature(hub->hdev,
+			port1 | (link_status << 3),
+			USB_PORT_FEAT_LINK_STATE);
+}
+
+/*
+ * If USB 3.0 ports are placed into the Disabled state, they will no longer
+ * detect any device connects or disconnects.  This is generally not what the
+ * USB core wants, since it expects a disabled port to produce a port status
+ * change event when a new device connects.
+ *
+ * Instead, set the link state to Disabled, wait for the link to settle into
+ * that state, clear any change bits, and then put the port into the RxDetect
+ * state.
+ */
+static int hub_usb3_port_disable(struct usb_hub *hub, int port1)
+{
+	int ret;
+	int total_time;
+	u16 portchange, portstatus;
+
+	if (!hub_is_superspeed(hub->hdev))
+		return -EINVAL;
+
+	ret = hub_set_port_link_state(hub, port1, USB_SS_PORT_LS_SS_DISABLED);
+	if (ret) {
+		dev_err(hub->intfdev, "cannot disable port %d (err = %d)\n",
+				port1, ret);
+		return ret;
+	}
+
+	/* Wait for the link to enter the disabled state. */
+	for (total_time = 0; ; total_time += HUB_DEBOUNCE_STEP) {
+		ret = hub_port_status(hub, port1, &portstatus, &portchange);
+		if (ret < 0)
+			return ret;
+
+		if ((portstatus & USB_PORT_STAT_LINK_STATE) ==
+				USB_SS_PORT_LS_SS_DISABLED)
+			break;
+		if (total_time >= HUB_DEBOUNCE_TIMEOUT)
+			break;
+		msleep(HUB_DEBOUNCE_STEP);
+	}
+	if (total_time >= HUB_DEBOUNCE_TIMEOUT)
+		dev_warn(hub->intfdev, "Could not disable port %d after %d ms\n",
+				port1, total_time);
+
+	return hub_set_port_link_state(hub, port1, USB_SS_PORT_LS_RX_DETECT);
+}
+
 static int hub_port_disable(struct usb_hub *hub, int port1, int set_state)
 {
 	struct usb_device *hdev = hub->hdev;
@@ -874,8 +928,13 @@ static int hub_port_disable(struct usb_hub *hub, int port1, int set_state)
 	if (hdev->children[port1-1] && set_state)
 		usb_set_device_state(hdev->children[port1-1],
 				USB_STATE_NOTATTACHED);
-	if (!hub->error && !hub_is_superspeed(hub->hdev))
-		ret = clear_port_feature(hdev, port1, USB_PORT_FEAT_ENABLE);
+	if (!hub->error) {
+		if (hub_is_superspeed(hub->hdev))
+			ret = hub_usb3_port_disable(hub, port1);
+		else
+			ret = clear_port_feature(hdev, port1,
+					USB_PORT_FEAT_ENABLE);
+	}
 	if (ret)
 		dev_err(hub->intfdev, "cannot disable port %d (err = %d)\n",
 				port1, ret);
diff --git a/drivers/usb/host/xhci-hub.c b/drivers/usb/host/xhci-hub.c
index 32ca289..4b07826 100644
--- a/drivers/usb/host/xhci-hub.c
+++ b/drivers/usb/host/xhci-hub.c
@@ -756,12 +756,39 @@ int xhci_hub_control(struct usb_hcd *hcd, u16 typeReq, u16 wValue,
 			break;
 		case USB_PORT_FEAT_LINK_STATE:
 			temp = xhci_readl(xhci, port_array[wIndex]);
+
+			/* Disable port */
+			if (link_state == USB_SS_PORT_LS_SS_DISABLED) {
+				xhci_dbg(xhci, "Disable port %d\n", wIndex);
+				temp = xhci_port_state_to_neutral(temp);
+				/*
+				 * Clear all change bits, so that we get a new
+				 * connection event.
+				 */
+				temp |= PORT_CSC | PORT_PEC | PORT_WRC |
+					PORT_OCC | PORT_RC | PORT_PLC |
+					PORT_CEC;
+				xhci_writel(xhci, temp | PORT_PE,
+					port_array[wIndex]);
+				temp = xhci_readl(xhci, port_array[wIndex]);
+				break;
+			}
+
+			/* Put link in RxDetect (enable port) */
+			if (link_state == USB_SS_PORT_LS_RX_DETECT) {
+				xhci_dbg(xhci, "Enable port %d\n", wIndex);
+				xhci_set_link_state(xhci, port_array, wIndex,
+						link_state);
+				temp = xhci_readl(xhci, port_array[wIndex]);
+				break;
+			}
+
 			/* Software should not attempt to set
-			 * port link state above '5' (Rx.Detect) and the port
+			 * port link state above '3' (U3) and the port
 			 * must be enabled.
 			 */
 			if ((temp & PORT_PE) == 0 ||
-				(link_state > USB_SS_PORT_LS_RX_DETECT)) {
+				(link_state > USB_SS_PORT_LS_U3)) {
 				xhci_warn(xhci, "Cannot set link state.\n");
 				goto error;
 			}
-- 
1.7.9.5

