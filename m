Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757252Ab3FDOZ0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Jun 2013 10:25:26 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:46663 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755370Ab3FDOHp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Jun 2013 10:07:45 -0400
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Alan Stern <stern@rowland.harvard.edu>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 11/70] USB: xHCI: override bogus bulk wMaxPacketSize values
Date: Tue,  4 Jun 2013 15:06:27 +0100
Message-Id: <1370354846-14213-12-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1370354846-14213-1-git-send-email-luis.henriques@canonical.com>
References: <1370354846-14213-1-git-send-email-luis.henriques@canonical.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Extended-Stable: 3.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.14 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alan Stern <stern@rowland.harvard.edu>

commit e4f47e3675e6f1f40906b785b934ce963e9f2eb3 upstream.

This patch shortens the logic in xhci_endpoint_init() by moving common
calculations involving max_packet and max_burst outside the switch
statement, rather than repeating the same code in multiple
case-specific statements.  It also replaces two usages of max_packet
which were clearly intended to be max_burst all along.

More importantly, it compensates for a common bug in high-speed bulk
endpoint descriptors.  In many devices there is a bulk endpoint having
a wMaxPacketSize value smaller than 512, which is forbidden by the USB
spec.  Some xHCI controllers can't handle this and refuse to accept
the endpoint.  This patch changes the max_packet value to 512, which
allows the controller to use the endpoint properly.

In practice the bogus maxpacket size doesn't matter, because none of
the transfers sent via these endpoints are longer than the maxpacket
value anyway.

Signed-off-by: Alan Stern <stern@rowland.harvard.edu>
Reported-and-tested-by: "Aurélien Leblond" <blablack@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 drivers/usb/host/xhci-mem.c | 17 +++++++++--------
 1 file changed, 9 insertions(+), 8 deletions(-)

diff --git a/drivers/usb/host/xhci-mem.c b/drivers/usb/host/xhci-mem.c
index 35616ff..90ce33b 100644
--- a/drivers/usb/host/xhci-mem.c
+++ b/drivers/usb/host/xhci-mem.c
@@ -1443,15 +1443,17 @@ int xhci_endpoint_init(struct xhci_hcd *xhci,
 	ep_ctx->ep_info2 |= cpu_to_le32(xhci_get_endpoint_type(udev, ep));
 
 	/* Set the max packet size and max burst */
+	max_packet = GET_MAX_PACKET(usb_endpoint_maxp(&ep->desc));
+	max_burst = 0;
 	switch (udev->speed) {
 	case USB_SPEED_SUPER:
-		max_packet = usb_endpoint_maxp(&ep->desc);
-		ep_ctx->ep_info2 |= cpu_to_le32(MAX_PACKET(max_packet));
 		/* dig out max burst from ep companion desc */
-		max_packet = ep->ss_ep_comp.bMaxBurst;
-		ep_ctx->ep_info2 |= cpu_to_le32(MAX_BURST(max_packet));
+		max_burst = ep->ss_ep_comp.bMaxBurst;
 		break;
 	case USB_SPEED_HIGH:
+		/* Some devices get this wrong */
+		if (usb_endpoint_xfer_bulk(&ep->desc))
+			max_packet = 512;
 		/* bits 11:12 specify the number of additional transaction
 		 * opportunities per microframe (USB 2.0, section 9.6.6)
 		 */
@@ -1459,17 +1461,16 @@ int xhci_endpoint_init(struct xhci_hcd *xhci,
 				usb_endpoint_xfer_int(&ep->desc)) {
 			max_burst = (usb_endpoint_maxp(&ep->desc)
 				     & 0x1800) >> 11;
-			ep_ctx->ep_info2 |= cpu_to_le32(MAX_BURST(max_burst));
 		}
-		/* Fall through */
+		break;
 	case USB_SPEED_FULL:
 	case USB_SPEED_LOW:
-		max_packet = GET_MAX_PACKET(usb_endpoint_maxp(&ep->desc));
-		ep_ctx->ep_info2 |= cpu_to_le32(MAX_PACKET(max_packet));
 		break;
 	default:
 		BUG();
 	}
+	ep_ctx->ep_info2 |= cpu_to_le32(MAX_PACKET(max_packet) |
+			MAX_BURST(max_burst));
 	max_esit_payload = xhci_get_max_esit_payload(xhci, udev, ep);
 	ep_ctx->tx_info = cpu_to_le32(MAX_ESIT_PAYLOAD_FOR_EP(max_esit_payload));
 
-- 
1.8.1.2

