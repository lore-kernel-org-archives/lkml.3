Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754311Ab3BCP01 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Feb 2013 10:26:27 -0500
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:34067 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753380Ab3BCOyp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Feb 2013 09:54:45 -0500
Message-Id: <20130203144645.108407475@decadent.org.uk>
User-Agent: quilt/0.60-1
Date: Sun, 03 Feb 2013 15:46:56 +0100
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: akpm@linux-foundation.org, Sarah Sharp <sarah.a.sharp@linux.intel.com>,
        Alan Stern <stern@rowland.harvard.edu>
Subject: [ 012/128] xhci: Avoid "dead ports", add roothub port polling.
In-Reply-To: <20130203144644.035172954@decadent.org.uk>
X-SA-Exim-Connect-IP: 151.216.67.5
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sarah Sharp <sarah.a.sharp@linux.intel.com>

commit c52804a472649b2e5005342308739434cbd51119 upstream.

The USB core hub thread (khubd) is designed with external USB hubs in
mind.  It expects that if a port status change bit is set, the hub will
continue to send a notification through the hub status data transfer.
Basically, it expects hub notifications to be level-triggered.

The xHCI host controller is designed to be edge-triggered on the logical
'OR' of all the port status change bits.  When all port status change
bits are clear, and a new change bit is set, the xHC will generate a
Port Status Change Event.  If another change bit is set in the same port
status register before the first bit is cleared, it will not send
another event.

This means that the hub code may lose port status changes because of
race conditions between clearing change bits.  The user sees this as a
"dead port" that doesn't react to device connects.

The fix is to turn on port polling whenever a new change bit is set.
Once the USB core issues a hub status request that shows that no change
bits are set in any USB ports, turn off port polling.

We can't allow the USB core to poll the roothub for port events during
host suspend because if the PCI host is in D3cold, the port registers
will be all f's.  Instead, stop the port polling timer, and
unconditionally restart it when the host resumes.  If there are no port
change bits set after the resume, the first call to hub_status_data will
disable polling.

This patch should be backported to stable kernels with the first xHCI
support, 2.6.31 and newer, that include the commit
0f2a79300a1471cf92ab43af165ea13555c8b0a5 "USB: xhci: Root hub support."
There will be merge conflicts because the check for HC_STATE_SUSPENDED
was moved into xhci_suspend in 3.8.

Signed-off-by: Sarah Sharp <sarah.a.sharp@linux.intel.com>
Acked-by: Alan Stern <stern@rowland.harvard.edu>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/usb/host/xhci-hub.c  |    7 +++++++
 drivers/usb/host/xhci-ring.c |    9 +++++++++
 drivers/usb/host/xhci.c      |   10 ++++++++++
 3 files changed, 26 insertions(+)

--- a/drivers/usb/host/xhci-hub.c
+++ b/drivers/usb/host/xhci-hub.c
@@ -904,6 +904,7 @@ int xhci_hub_status_data(struct usb_hcd
 	int max_ports;
 	__le32 __iomem **port_array;
 	struct xhci_bus_state *bus_state;
+	bool reset_change = false;
 
 	max_ports = xhci_get_ports(hcd, &port_array);
 	bus_state = &xhci->bus_state[hcd_index(hcd)];
@@ -930,6 +931,12 @@ int xhci_hub_status_data(struct usb_hcd
 			buf[(i + 1) / 8] |= 1 << (i + 1) % 8;
 			status = 1;
 		}
+		if ((temp & PORT_RC))
+			reset_change = true;
+	}
+	if (!status && !reset_change) {
+		xhci_dbg(xhci, "%s: stopping port polling.\n", __func__);
+		clear_bit(HCD_FLAG_POLL_RH, &hcd->flags);
 	}
 	spin_unlock_irqrestore(&xhci->lock, flags);
 	return status ? retval : 0;
--- a/drivers/usb/host/xhci-ring.c
+++ b/drivers/usb/host/xhci-ring.c
@@ -1661,6 +1661,15 @@ cleanup:
 	if (bogus_port_status)
 		return;
 
+	/*
+	 * xHCI port-status-change events occur when the "or" of all the
+	 * status-change bits in the portsc register changes from 0 to 1.
+	 * New status changes won't cause an event if any other change
+	 * bits are still set.  When an event occurs, switch over to
+	 * polling to avoid losing status changes.
+	 */
+	xhci_dbg(xhci, "%s: starting port polling.\n", __func__);
+	set_bit(HCD_FLAG_POLL_RH, &hcd->flags);
 	spin_unlock(&xhci->lock);
 	/* Pass this up to the core */
 	usb_hcd_poll_rh_status(hcd);
--- a/drivers/usb/host/xhci.c
+++ b/drivers/usb/host/xhci.c
@@ -871,6 +871,11 @@ int xhci_suspend(struct xhci_hcd *xhci)
 	struct usb_hcd		*hcd = xhci_to_hcd(xhci);
 	u32			command;
 
+	/* Don't poll the roothubs on bus suspend. */
+	xhci_dbg(xhci, "%s: stopping port polling.\n", __func__);
+	clear_bit(HCD_FLAG_POLL_RH, &hcd->flags);
+	del_timer_sync(&hcd->rh_timer);
+
 	spin_lock_irq(&xhci->lock);
 	clear_bit(HCD_FLAG_HW_ACCESSIBLE, &hcd->flags);
 	clear_bit(HCD_FLAG_HW_ACCESSIBLE, &xhci->shared_hcd->flags);
@@ -1055,6 +1060,11 @@ int xhci_resume(struct xhci_hcd *xhci, b
 	if (xhci->quirks & XHCI_COMP_MODE_QUIRK)
 		compliance_mode_recovery_timer_init(xhci);
 
+	/* Re-enable port polling. */
+	xhci_dbg(xhci, "%s: starting port polling.\n", __func__);
+	set_bit(HCD_FLAG_POLL_RH, &hcd->flags);
+	usb_hcd_poll_rh_status(hcd);
+
 	return retval;
 }
 #endif	/* CONFIG_PM */


