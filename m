Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932660Ab3KIGvs (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 Nov 2013 01:51:48 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:33229 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758551Ab3KIGvl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 Nov 2013 01:51:41 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Sarah Sharp <sarah.a.sharp@linux.intel.com>
Subject: [PATCH 3.11 07/94] xhci: Dont enable/disable RWE on bus suspend/resume.
Date: Fri,  8 Nov 2013 22:51:13 -0800
Message-Id: <20131109065204.784495908@linuxfoundation.org>
X-Mailer: git-send-email 1.8.5.rc0.dirty
In-Reply-To: <20131109065204.252462489@linuxfoundation.org>
References: <20131109065204.252462489@linuxfoundation.org>
User-Agent: quilt/0.60-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.11-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sarah Sharp <sarah.a.sharp@linux.intel.com>

commit f217c980ca980e3a645b7485ea5eae9a747f4945 upstream.

The RWE bit of the USB 2.0 PORTPMSC register is supposed to enable
remote wakeup for devices in the lower power link state L1.  It has
nothing to do with the device suspend remote wakeup from L2.  The RWE
bit is designed to be set once (when USB 2.0 LPM is enabled for the
port) and cleared only when USB 2.0 LPM is disabled for the port.

The xHCI bus suspend method was setting the RWE bit erroneously, and the
bus resume method was clearing it.  The xHCI 1.0 specification with
errata up to Aug 12, 2012 says in section 4.23.5.1.1.1 "Hardware
Controlled LPM":

"While Hardware USB2 LPM is enabled, software shall not modify the
HIRDBESL or RWE fields of the USB2 PORTPMSC register..."

If we have previously enabled USB 2.0 LPM for a device, that means when
the USB 2.0 bus is resumed, we violate the xHCI specification by
clearing RWE.  It also means that after a bus resume, the host would
think remote wakeup is disabled from L1 for ports with USB 2.0 Link PM
enabled, which is not what we want.

This patch should be backported to kernels as old as 3.2, that
contain the commit 65580b4321eb36f16ae8b5987bfa1bb948fc5112 "xHCI: set
USB2 hardware LPM".  That was the first kernel that supported USB 2.0
Link PM.

Signed-off-by: Sarah Sharp <sarah.a.sharp@linux.intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/usb/host/xhci-hub.c |   26 --------------------------
 1 file changed, 26 deletions(-)

--- a/drivers/usb/host/xhci-hub.c
+++ b/drivers/usb/host/xhci-hub.c
@@ -1092,18 +1092,6 @@ int xhci_bus_suspend(struct usb_hcd *hcd
 		t1 = xhci_port_state_to_neutral(t1);
 		if (t1 != t2)
 			xhci_writel(xhci, t2, port_array[port_index]);
-
-		if (hcd->speed != HCD_USB3) {
-			/* enable remote wake up for USB 2.0 */
-			__le32 __iomem *addr;
-			u32 tmp;
-
-			/* Get the port power control register address. */
-			addr = port_array[port_index] + PORTPMSC;
-			tmp = xhci_readl(xhci, addr);
-			tmp |= PORT_RWE;
-			xhci_writel(xhci, tmp, addr);
-		}
 	}
 	hcd->state = HC_STATE_SUSPENDED;
 	bus_state->next_statechange = jiffies + msecs_to_jiffies(10);
@@ -1182,20 +1170,6 @@ int xhci_bus_resume(struct usb_hcd *hcd)
 				xhci_ring_device(xhci, slot_id);
 		} else
 			xhci_writel(xhci, temp, port_array[port_index]);
-
-		if (hcd->speed != HCD_USB3) {
-			/* disable remote wake up for USB 2.0 */
-			__le32 __iomem *addr;
-			u32 tmp;
-
-			/* Add one to the port status register address to get
-			 * the port power control register address.
-			 */
-			addr = port_array[port_index] + PORTPMSC;
-			tmp = xhci_readl(xhci, addr);
-			tmp &= ~PORT_RWE;
-			xhci_writel(xhci, tmp, addr);
-		}
 	}
 
 	(void) xhci_readl(xhci, &xhci->op_regs->command);


