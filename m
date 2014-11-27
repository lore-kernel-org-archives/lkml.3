Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754709AbaK0IrA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Nov 2014 03:47:00 -0500
Received: from mail.kernel.org ([198.145.19.201]:41484 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754685AbaK0Iq5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Nov 2014 03:46:57 -0500
From: lizf@kernel.org
To: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Felipe Balbi <balbi@ti.com>,
        "Alexis R. Cortes" <alexis.cortes@ti.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Zefan Li <lizefan@huawei.com>
Subject: [PATCH 3.4 24/91] usb: host: xhci: fix compliance mode workaround
Date: Thu, 27 Nov 2014 16:42:07 +0800
Message-Id: <1417077794-9299-24-git-send-email-lizf@kernel.org>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1417077368-9217-1-git-send-email-lizf@kernel.org>
References: <1417077368-9217-1-git-send-email-lizf@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Felipe Balbi <balbi@ti.com>

3.4.105-rc1 review patch.  If anyone has any objections, please let me know.

------------------


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
[lizf: Backported to 3.4:
 - s/xhci_hub_report_usb3_link_state/xhci_hub_report_link_state/]
Signed-off-by: Zefan Li <lizefan@huawei.com>
---
 drivers/usb/host/xhci-hub.c | 8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff --git a/drivers/usb/host/xhci-hub.c b/drivers/usb/host/xhci-hub.c
index a94eabd..56ec28b 100644
--- a/drivers/usb/host/xhci-hub.c
+++ b/drivers/usb/host/xhci-hub.c
@@ -463,7 +463,8 @@ void xhci_test_and_clear_bit(struct xhci_hcd *xhci, __le32 __iomem **port_array,
 }
 
 /* Updates Link Status for super Speed port */
-static void xhci_hub_report_link_state(u32 *status, u32 status_reg)
+static void xhci_hub_report_link_state(struct xhci_hcd *xhci,
+		u32 *status, u32 status_reg)
 {
 	u32 pls = status_reg & PORT_PLS_MASK;
 
@@ -502,7 +503,8 @@ static void xhci_hub_report_link_state(u32 *status, u32 status_reg)
 		 * in which sometimes the port enters compliance mode
 		 * caused by a delay on the host-device negotiation.
 		 */
-		if (pls == USB_SS_PORT_LS_COMP_MOD)
+		if ((xhci->quirks & XHCI_COMP_MODE_QUIRK) &&
+				(pls == USB_SS_PORT_LS_COMP_MOD))
 			pls |= USB_PORT_STAT_CONNECTION;
 	}
 
@@ -680,7 +682,7 @@ int xhci_hub_control(struct usb_hcd *hcd, u16 typeReq, u16 wValue,
 		}
 		/* Update Port Link State for super speed ports*/
 		if (hcd->speed == HCD_USB3) {
-			xhci_hub_report_link_state(&status, temp);
+			xhci_hub_report_link_state(xhci, &status, temp);
 			/*
 			 * Verify if all USB3 Ports Have entered U0 already.
 			 * Delete Compliance Mode Timer if so.
-- 
1.9.1

