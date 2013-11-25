Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755587Ab3KYOC3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Nov 2013 09:02:29 -0500
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:58936 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754210Ab3KYNxu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Nov 2013 08:53:50 -0500
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC: akpm@linux-foundation.org, "Sarah Sharp" <sarah.a.sharp@linux.intel.com>
Date: Mon, 25 Nov 2013 13:44:29 +0000
Message-ID: <lsq.1385387069.939439002@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
Subject: [PATCH 3.2 53/87] xhci: Don't enable/disable RWE on bus
 suspend/resume.
In-Reply-To: <lsq.1385387069.559528559@decadent.org.uk>
X-SA-Exim-Connect-IP: 192.168.4.212
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2.53-rc1 review patch.  If anyone has any objections, please let me know.

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
[bwh: Backported to 3.2: deleted code was cosmetically different]
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
--- a/drivers/usb/host/xhci-hub.c
+++ b/drivers/usb/host/xhci-hub.c
@@ -1007,20 +1007,6 @@ int xhci_bus_suspend(struct usb_hcd *hcd
 		t1 = xhci_port_state_to_neutral(t1);
 		if (t1 != t2)
 			xhci_writel(xhci, t2, port_array[port_index]);
-
-		if (hcd->speed != HCD_USB3) {
-			/* enable remote wake up for USB 2.0 */
-			__le32 __iomem *addr;
-			u32 tmp;
-
-			/* Add one to the port status register address to get
-			 * the port power control register address.
-			 */
-			addr = port_array[port_index] + 1;
-			tmp = xhci_readl(xhci, addr);
-			tmp |= PORT_RWE;
-			xhci_writel(xhci, tmp, addr);
-		}
 	}
 	hcd->state = HC_STATE_SUSPENDED;
 	bus_state->next_statechange = jiffies + msecs_to_jiffies(10);
@@ -1099,20 +1085,6 @@ int xhci_bus_resume(struct usb_hcd *hcd)
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
-			addr = port_array[port_index] + 1;
-			tmp = xhci_readl(xhci, addr);
-			tmp &= ~PORT_RWE;
-			xhci_writel(xhci, tmp, addr);
-		}
 	}
 
 	(void) xhci_readl(xhci, &xhci->op_regs->command);

