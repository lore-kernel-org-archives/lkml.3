Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752340AbaKAWk4 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 1 Nov 2014 18:40:56 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:60346 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751833AbaKAWje (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 1 Nov 2014 18:39:34 -0400
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC: akpm@linux-foundation.org, "Alexis R. Cortes" <alexis.cortes@ti.com>,
        "Felipe Balbi" <balbi@ti.com>,
        "Greg Kroah-Hartman" <gregkh@linuxfoundation.org>,
        "Mathias Nyman" <mathias.nyman@linux.intel.com>
Date: Sat, 01 Nov 2014 22:28:03 +0000
Message-ID: <lsq.1414880883.198434042@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
Subject: [PATCH 3.2 029/102] usb: host: xhci: fix compliance mode workaround
In-Reply-To: <lsq.1414880882.522510247@decadent.org.uk>
X-SA-Exim-Connect-IP: 192.168.4.249
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2.64-rc1 review patch.  If anyone has any objections, please let me know.

------------------

From: Felipe Balbi <balbi@ti.com>

commit 96908589a8b2584b1185f834d365f5cc360e8226 upstream.

Commit 71c731a (usb: host: xhci: Fix Compliance Mode
on SN65LVP3502CP Hardware) implemented a workaround
for a known issue with Texas Instruments' USB 3.0
redriver IC but it left a condition where any xHCI
host would be taken out of reset if port was placed
in compliance mode and there was no device connected
to the port.

That condition would trigger a fake connection to a
non-existent device so that usbcore would trigger a
warm reset of the port, thus taking the link out of
reset.

This has the side-effect of preventing any xHCI host
connected to a Linux machine from starting and running
the USB 3.0 Electrical Compliance Suite because the
port will mysteriously taken out of compliance mode
and, thus, xHCI won't step through the necessary
compliance patterns for link validation.

This patch fixes the issue by just adding a missing
check for XHCI_COMP_MODE_QUIRK inside
xhci_hub_report_usb3_link_state() when PORT_CAS isn't
set.

This patch should be backported to all kernels containing
commit 71c731a.

Fixes: 71c731a (usb: host: xhci: Fix Compliance Mode on SN65LVP3502CP Hardware)
Cc: Alexis R. Cortes <alexis.cortes@ti.com>
Signed-off-by: Felipe Balbi <balbi@ti.com>
Acked-by: Mathias Nyman <mathias.nyman@linux.intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
[bwh: Backported to 3.2:
 - s/xhci_hub_report_usb3_link_state/xhci_hub_report_link_state/
 - s/raw_port_status/temp/
 - Adjust indentation]
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/usb/host/xhci-hub.c | 8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

--- a/drivers/usb/host/xhci-hub.c
+++ b/drivers/usb/host/xhci-hub.c
@@ -440,7 +440,8 @@ void xhci_test_and_clear_bit(struct xhci
 }
 
 /* Updates Link Status for super Speed port */
-static void xhci_hub_report_link_state(u32 *status, u32 status_reg)
+static void xhci_hub_report_link_state(struct xhci_hcd *xhci,
+		u32 *status, u32 status_reg)
 {
 	u32 pls = status_reg & PORT_PLS_MASK;
 
@@ -479,7 +480,8 @@ static void xhci_hub_report_link_state(u
 		 * in which sometimes the port enters compliance mode
 		 * caused by a delay on the host-device negotiation.
 		 */
-		if (pls == USB_SS_PORT_LS_COMP_MOD)
+		if ((xhci->quirks & XHCI_COMP_MODE_QUIRK) &&
+				(pls == USB_SS_PORT_LS_COMP_MOD))
 			pls |= USB_PORT_STAT_CONNECTION;
 	}
 
@@ -655,7 +657,7 @@ int xhci_hub_control(struct usb_hcd *hcd
 		}
 		/* Update Port Link State for super speed ports*/
 		if (hcd->speed == HCD_USB3) {
-			xhci_hub_report_link_state(&status, temp);
+			xhci_hub_report_link_state(xhci, &status, temp);
 			/*
 			 * Verify if all USB3 Ports Have entered U0 already.
 			 * Delete Compliance Mode Timer if so.

