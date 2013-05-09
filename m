Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932568Ab3EIW4e (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 May 2013 18:56:34 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:46067 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757724Ab3EIWc6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 May 2013 18:32:58 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Sarah Sharp <sarah.a.sharp@linux.intel.com>,
        Stephen Hemminger <stephen@networkplumber.org>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [ 16/73] xhci: Dont warn on empty ring for suspended devices.
Date: Thu,  9 May 2013 15:31:39 -0700
Message-Id: <20130509222759.720519701@linuxfoundation.org>
X-Mailer: git-send-email 1.8.3.rc0.20.gb99dd2e
In-Reply-To: <20130509222757.917088509@linuxfoundation.org>
References: <20130509222757.917088509@linuxfoundation.org>
User-Agent: quilt/0.60-5.1.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.8-stable review patch.  If anyone has any objections, please let me know.

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
Cc: Luis Henriques <luis.henriques@canonical.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/usb/host/xhci-ring.c |   23 +++++++++++++++--------
 1 file changed, 15 insertions(+), 8 deletions(-)

--- a/drivers/usb/host/xhci-ring.c
+++ b/drivers/usb/host/xhci-ring.c
@@ -2461,14 +2461,21 @@ static int handle_tx_event(struct xhci_h
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


