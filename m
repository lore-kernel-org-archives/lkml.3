Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756235Ab3ETLNr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 May 2013 07:13:47 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:56124 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756012Ab3ETKw7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 May 2013 06:52:59 -0400
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Sarah Sharp <sarah.a.sharp@linux.intel.com>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 047/115] xhci: Don't warn on empty ring for suspended devices.
Date: Mon, 20 May 2013 11:50:47 +0100
Message-Id: <1369047116-9378-48-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1369047116-9378-1-git-send-email-luis.henriques@canonical.com>
References: <1369047116-9378-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.13 -stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 drivers/usb/host/xhci-ring.c | 23 +++++++++++++++--------
 1 file changed, 15 insertions(+), 8 deletions(-)

diff --git a/drivers/usb/host/xhci-ring.c b/drivers/usb/host/xhci-ring.c
index 848d0bc..8d0b1e8 100644
--- a/drivers/usb/host/xhci-ring.c
+++ b/drivers/usb/host/xhci-ring.c
@@ -2459,14 +2459,21 @@ static int handle_tx_event(struct xhci_hcd *xhci,
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
-- 
1.8.1.2

