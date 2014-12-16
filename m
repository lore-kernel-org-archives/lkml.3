Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751238AbaLPCLj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Dec 2014 21:11:39 -0500
Received: from mail-pa0-f67.google.com ([209.85.220.67]:40688 "EHLO
	mail-pa0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751000AbaLPCLf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Dec 2014 21:11:35 -0500
From: Sneeker Yeh <sneeker.yeh@gmail.com>
X-Google-Original-From: Sneeker Yeh <Sneeker.Yeh@tw.fujitsu.com>
To: Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>, Felipe Balbi <balbi@ti.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Mathias Nyman <mathias.nyman@intel.com>,
        Grant Likely <grant.likely@linaro.org>,
        Alan Stern <stern@rowland.harvard.edu>, Arnd Bergmann <arnd@arndb.de>,
        Paul Bolle <pebolle@tiscali.nl>, Hans de Goede <hdegoede@redhat.com>,
        Thomas Pugliese <thomas.pugliese@gmail.com>,
        David Mosberger <davidm@egauge.net>,
        Peter Griffin <peter.griffin@linaro.org>,
        Sylwester Nawrocki <s.nawrocki@samsung.com>,
        Andrew Bresticker <abrestic@chromium.org>,
        Gregory CLEMENT <gregory.clement@free-electrons.com>,
        Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-usb@vger.kernel.org, linux-omap@vger.kernel.org
Cc: Andy Green <andy.green@linaro.org>,
        Jassi Brar <jaswinder.singh@linaro.org>,
        Sneeker Yeh <Sneeker.Yeh@tw.fujitsu.com>
Subject: [PATCH 3/3] usb: dwc3: add a quirk for device disconnection issue in Synopsis dwc3 core
Date: Tue, 16 Dec 2014 10:10:28 +0800
Message-Id: <1418695828-605-4-git-send-email-Sneeker.Yeh@tw.fujitsu.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1418695828-605-1-git-send-email-Sneeker.Yeh@tw.fujitsu.com>
References: <1418695828-605-1-git-send-email-Sneeker.Yeh@tw.fujitsu.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Synopsis DesignWare USB3 IP Core integrated with a config-free
phy needs special handling during device disconnection to avoid
the host controller dying.

This quirk makes sure PORT_CSC is cleared after the disable slot
command when usb device is disconnected from internal root hub,
otherwise, Synopsis core would fall into a state that cannot use
any endpoint command. Consequently, device disconnection procedure
might not be finished because sometimes endpoint need to be stop
by endpoint stop command issuing.

Symptom usually happens when disconnected device is keyboard,
mouse, and hub.

Signed-off-by: Sneeker Yeh <Sneeker.Yeh@tw.fujitsu.com>
---
 drivers/usb/host/xhci-hub.c  |    4 ++++
 drivers/usb/host/xhci-plat.c |    5 +++++
 drivers/usb/host/xhci.c      |   29 +++++++++++++++++++++++++++++
 drivers/usb/host/xhci.h      |    7 +++++++
 4 files changed, 45 insertions(+)

diff --git a/drivers/usb/host/xhci-hub.c b/drivers/usb/host/xhci-hub.c
index a7865c4..3b8f7fc 100644
--- a/drivers/usb/host/xhci-hub.c
+++ b/drivers/usb/host/xhci-hub.c
@@ -368,6 +368,10 @@ static void xhci_clear_port_change_bit(struct xhci_hcd *xhci, u16 wValue,
 		port_change_bit = "warm(BH) reset";
 		break;
 	case USB_PORT_FEAT_C_CONNECTION:
+		if ((xhci->quirks & XHCI_DISCONNECT_QUIRK) &&
+		    !(readl(addr) & PORT_CONNECT))
+			return;
+
 		status = PORT_CSC;
 		port_change_bit = "connect";
 		break;
diff --git a/drivers/usb/host/xhci-plat.c b/drivers/usb/host/xhci-plat.c
index 08d402b..3ede6b4 100644
--- a/drivers/usb/host/xhci-plat.c
+++ b/drivers/usb/host/xhci-plat.c
@@ -33,6 +33,11 @@ static void xhci_plat_quirks(struct device *dev, struct xhci_hcd *xhci)
 	 * dev struct in order to setup MSI
 	 */
 	xhci->quirks |= XHCI_PLAT;
+
+	if (dev->parent && dev->parent->parent &&
+	    of_device_is_compatible(dev->parent->parent->of_node,
+				    "fujitsu,mb86s70-dwc3"))
+		xhci->quirks |= XHCI_DISCONNECT_QUIRK;
 }
 
 /* called during probe() after chip reset completes */
diff --git a/drivers/usb/host/xhci.c b/drivers/usb/host/xhci.c
index 01fcbb5..50d757b 100644
--- a/drivers/usb/host/xhci.c
+++ b/drivers/usb/host/xhci.c
@@ -3584,6 +3584,33 @@ command_cleanup:
 	return ret;
 }
 
+static void xhci_try_to_clear_csc(struct usb_hcd *hcd, int dev_port_num)
+{
+	int max_ports;
+	struct xhci_hcd	*xhci = hcd_to_xhci(hcd);
+	__le32 __iomem **port_array;
+	u32 status;
+
+	/* print debug info */
+	if (hcd->speed == HCD_USB3) {
+		max_ports = xhci->num_usb3_ports;
+		port_array = xhci->usb3_ports;
+	} else {
+		max_ports = xhci->num_usb2_ports;
+		port_array = xhci->usb2_ports;
+	}
+
+	if (dev_port_num > max_ports) {
+		xhci_err(xhci, "%s() port number invalid", __func__);
+		return;
+	}
+	status = readl(port_array[dev_port_num - 1]);
+
+	/* write 1 to clear */
+	if (!(status & PORT_CONNECT) && (status & PORT_CSC))
+		writel(status & PORT_CSC, port_array[0]);
+}
+
 /*
  * At this point, the struct usb_device is about to go away, the device has
  * disconnected, and all traffic has been stopped and the endpoints have been
@@ -3649,6 +3676,8 @@ void xhci_free_dev(struct usb_hcd *hcd, struct usb_device *udev)
 	xhci_ring_cmd_db(xhci);
 	spin_unlock_irqrestore(&xhci->lock, flags);
 
+	if (xhci->quirks & XHCI_DISCONNECT_QUIRK)
+		xhci_try_to_clear_csc(hcd, udev->portnum);
 	/*
 	 * Event command completion handler will free any data structures
 	 * associated with the slot.  XXX Can free sleep?
diff --git a/drivers/usb/host/xhci.h b/drivers/usb/host/xhci.h
index cc7c5bb..e6c820c 100644
--- a/drivers/usb/host/xhci.h
+++ b/drivers/usb/host/xhci.h
@@ -1560,6 +1560,13 @@ struct xhci_hcd {
 #define XHCI_SPURIOUS_WAKEUP	(1 << 18)
 /* For controllers with a broken beyond repair streams implementation */
 #define XHCI_BROKEN_STREAMS	(1 << 19)
+/*
+ * Synopsis dwc3 core integrated with a config-free phy needs special
+ * handling during device disconnection to avoid the host controller
+ * dying. This quirk makes sure PORT_CSC is cleared after the disable
+ * slot command.
+ */
+#define XHCI_DISCONNECT_QUIRK	(1 << 20)
 	unsigned int		num_active_eps;
 	unsigned int		limit_active_eps;
 	/* There are two roothubs to keep track of bus suspend info for */
-- 
1.7.9.5

