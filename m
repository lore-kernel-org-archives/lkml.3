Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759347Ab3E1D4k (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 May 2013 23:56:40 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:52536 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758827Ab3E1DyZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 May 2013 23:54:25 -0400
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC: akpm@linux-foundation.org,
        "Stephen Hemminger" <stephen@networkplumber.org>,
        "Sarah Sharp" <sarah.a.sharp@linux.intel.com>
Date: Tue, 28 May 2013 04:49:53 +0100
Message-ID: <lsq.1369712993.5201233@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
Subject: [70/94] xhci: Don't warn on empty ring for suspended devices.
In-Reply-To: <lsq.1369712992.755341692@decadent.org.uk>
X-SA-Exim-Connect-IP: 192.168.4.101
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2.46-rc1 review patch.  If anyone has any objections, please let me know.

------------------

From: Sarah Sharp <sarah.a.sharp@linux.intel.com>

commit a83d6755814e4614ba77e15d82796af0f695c6b8 upstream.

When a device attached to the roothub is suspended, the endpoint rings
are stopped.  The host may generate a completion event with the
completion code set to 'Stopped' or 'Stopped Invalid' when the ring is
halted.  The current xHCI code prints a warning in that case, which can
be really annoying if the USB device is coming into and out of suspend.

Remove the unnecessary warning.

Signed-off-by: Sarah Sharp <sarah.a.sharp@linux.intel.com>
Tested-by: Stephen Hemminger <stephen@networkplumber.org>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/usb/host/xhci-ring.c |   23 +++++++++++++++--------
 1 file changed, 15 insertions(+), 8 deletions(-)

diff --git a/drivers/usb/host/xhci-ring.c b/drivers/usb/host/xhci-ring.c
index 9652dae..1969c00 100644
--- a/drivers/usb/host/xhci-ring.c
+++ b/drivers/usb/host/xhci-ring.c
@@ -2463,14 +2463,21 @@ static int handle_tx_event(struct xhci_hcd *xhci,
 		 * TD list.
 		 */
 		if (list_empty(&ep_ring->td_list)) {
-			xhci_warn(xhci, "WARN Event TRB for slot %d ep %d "
-					"with no TDs queued?\n",
-				  TRB_TO_SLOT_ID(le32_to_cpu(event->flags)),
-				  ep_index);
-			xhci_dbg(xhci, "Event TRB with TRB type ID %u\n",
-				 (le32_to_cpu(event->flags) &
-				  TRB_TYPE_BITMASK)>>10);
-			xhci_print_trb_offsets(xhci, (union xhci_trb *) event);
+			/*
+			 * A stopped endpoint may generate an extra completion
+			 * event if the device was suspended.  Don't print
+			 * warnings.
+			 */
+			if (!(trb_comp_code == COMP_STOP ||
+						trb_comp_code == COMP_STOP_INVAL)) {
+				xhci_warn(xhci, "WARN Event TRB for slot %d ep %d with no TDs queued?\n",
+						TRB_TO_SLOT_ID(le32_to_cpu(event->flags)),
+						ep_index);
+				xhci_dbg(xhci, "Event TRB with TRB type ID %u\n",
+						(le32_to_cpu(event->flags) &
+						 TRB_TYPE_BITMASK)>>10);
+				xhci_print_trb_offsets(xhci, (union xhci_trb *) event);
+			}
 			if (ep->skip) {
 				ep->skip = false;
 				xhci_dbg(xhci, "td_list is empty while skip "

