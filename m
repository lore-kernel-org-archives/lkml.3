Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760591AbaJCXnE (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Oct 2014 19:43:04 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:46292 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757297AbaJCWDg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Oct 2014 18:03:36 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        "Alexis R. Cortes" <alexis.cortes@ti.com>, Felipe Balbi <balbi@ti.com>,
        Mathias Nyman <mathias.nyman@linux.intel.com>
Subject: [PATCH 3.14 093/238] usb: host: xhci: fix compliance mode workaround
Date: Fri,  3 Oct 2014 14:30:08 -0700
Message-Id: <20141003212916.651360406@linuxfoundation.org>
X-Mailer: git-send-email 2.1.2
In-Reply-To: <20141003212913.680985295@linuxfoundation.org>
References: <20141003212913.680985295@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.14-stable review patch.  If anyone has any objections, please let me know.

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

---
 drivers/usb/host/xhci-hub.c |    8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

--- a/drivers/usb/host/xhci-hub.c
+++ b/drivers/usb/host/xhci-hub.c
@@ -470,7 +470,8 @@ static void xhci_hub_report_usb2_link_st
 }
 
 /* Updates Link Status for super Speed port */
-static void xhci_hub_report_usb3_link_state(u32 *status, u32 status_reg)
+static void xhci_hub_report_usb3_link_state(struct xhci_hcd *xhci,
+		u32 *status, u32 status_reg)
 {
 	u32 pls = status_reg & PORT_PLS_MASK;
 
@@ -509,7 +510,8 @@ static void xhci_hub_report_usb3_link_st
 		 * in which sometimes the port enters compliance mode
 		 * caused by a delay on the host-device negotiation.
 		 */
-		if (pls == USB_SS_PORT_LS_COMP_MOD)
+		if ((xhci->quirks & XHCI_COMP_MODE_QUIRK) &&
+				(pls == USB_SS_PORT_LS_COMP_MOD))
 			pls |= USB_PORT_STAT_CONNECTION;
 	}
 
@@ -668,7 +670,7 @@ static u32 xhci_get_port_status(struct u
 	}
 	/* Update Port Link State */
 	if (hcd->speed == HCD_USB3) {
-		xhci_hub_report_usb3_link_state(&status, raw_port_status);
+		xhci_hub_report_usb3_link_state(xhci, &status, raw_port_status);
 		/*
 		 * Verify if all USB3 Ports Have entered U0 already.
 		 * Delete Compliance Mode Timer if so.


