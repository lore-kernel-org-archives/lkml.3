Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935099Ab3DGXeY (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Apr 2013 19:34:24 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:46894 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S934697Ab3DGXeU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Apr 2013 19:34:20 -0400
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC: akpm@linux-foundation.org, "Sarah Sharp" <sarah.a.sharp@linux.intel.com>,
        "Vivek Gautam" <gautam.vivek@samsung.com>
Date: Sun, 07 Apr 2013 23:45:42 +0100
Message-ID: <lsq.1365374742.373564978@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
Subject: [28/74] usb: xhci: Fix TRB transfer length macro used for Event TRB.
In-Reply-To: <lsq.1365374742.214522651@decadent.org.uk>
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:b4b3:7e2a:e2d0:3478
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2.43-rc1 review patch.  If anyone has any objections, please let me know.

------------------

From: Vivek Gautam <gautam.vivek@samsung.com>

commit 1c11a172cb30492f5f6a82c6e118fdcd9946c34f upstream.

Use proper macro while extracting TRB transfer length from
Transfer event TRBs. Adding a macro EVENT_TRB_LEN (bits 0:23)
for the same, and use it instead of TRB_LEN (bits 0:16) in
case of event TRBs.

This patch should be backported to kernels as old as 2.6.31, that
contain the commit b10de142119a676552df3f0d2e3a9d647036c26a "USB: xhci:
Bulk transfer support".  This patch will have issues applying to older
kernels.

Signed-off-by: Vivek gautam <gautam.vivek@samsung.com>
Signed-off-by: Sarah Sharp <sarah.a.sharp@linux.intel.com>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/usb/host/xhci-ring.c |   24 ++++++++++++------------
 drivers/usb/host/xhci.h      |    4 ++++
 2 files changed, 16 insertions(+), 12 deletions(-)

--- a/drivers/usb/host/xhci-ring.c
+++ b/drivers/usb/host/xhci-ring.c
@@ -1964,8 +1964,8 @@ static int process_ctrl_td(struct xhci_h
 		if (event_trb != ep_ring->dequeue &&
 				event_trb != td->last_trb)
 			td->urb->actual_length =
-				td->urb->transfer_buffer_length
-				- TRB_LEN(le32_to_cpu(event->transfer_len));
+				td->urb->transfer_buffer_length -
+				EVENT_TRB_LEN(le32_to_cpu(event->transfer_len));
 		else
 			td->urb->actual_length = 0;
 
@@ -1997,7 +1997,7 @@ static int process_ctrl_td(struct xhci_h
 		/* Maybe the event was for the data stage? */
 			td->urb->actual_length =
 				td->urb->transfer_buffer_length -
-				TRB_LEN(le32_to_cpu(event->transfer_len));
+				EVENT_TRB_LEN(le32_to_cpu(event->transfer_len));
 			xhci_dbg(xhci, "Waiting for status "
 					"stage event\n");
 			return 0;
@@ -2033,7 +2033,7 @@ static int process_isoc_td(struct xhci_h
 	/* handle completion code */
 	switch (trb_comp_code) {
 	case COMP_SUCCESS:
-		if (TRB_LEN(le32_to_cpu(event->transfer_len)) == 0) {
+		if (EVENT_TRB_LEN(le32_to_cpu(event->transfer_len)) == 0) {
 			frame->status = 0;
 			break;
 		}
@@ -2078,7 +2078,7 @@ static int process_isoc_td(struct xhci_h
 				len += TRB_LEN(le32_to_cpu(cur_trb->generic.field[2]));
 		}
 		len += TRB_LEN(le32_to_cpu(cur_trb->generic.field[2])) -
-			TRB_LEN(le32_to_cpu(event->transfer_len));
+			EVENT_TRB_LEN(le32_to_cpu(event->transfer_len));
 
 		if (trb_comp_code != COMP_STOP_INVAL) {
 			frame->actual_length = len;
@@ -2136,7 +2136,7 @@ static int process_bulk_intr_td(struct x
 	case COMP_SUCCESS:
 		/* Double check that the HW transferred everything. */
 		if (event_trb != td->last_trb ||
-				TRB_LEN(le32_to_cpu(event->transfer_len)) != 0) {
+		    EVENT_TRB_LEN(le32_to_cpu(event->transfer_len)) != 0) {
 			xhci_warn(xhci, "WARN Successful completion "
 					"on short TX\n");
 			if (td->urb->transfer_flags & URB_SHORT_NOT_OK)
@@ -2164,18 +2164,18 @@ static int process_bulk_intr_td(struct x
 				"%d bytes untransferred\n",
 				td->urb->ep->desc.bEndpointAddress,
 				td->urb->transfer_buffer_length,
-				TRB_LEN(le32_to_cpu(event->transfer_len)));
+				EVENT_TRB_LEN(le32_to_cpu(event->transfer_len)));
 	/* Fast path - was this the last TRB in the TD for this URB? */
 	if (event_trb == td->last_trb) {
-		if (TRB_LEN(le32_to_cpu(event->transfer_len)) != 0) {
+		if (EVENT_TRB_LEN(le32_to_cpu(event->transfer_len)) != 0) {
 			td->urb->actual_length =
 				td->urb->transfer_buffer_length -
-				TRB_LEN(le32_to_cpu(event->transfer_len));
+				EVENT_TRB_LEN(le32_to_cpu(event->transfer_len));
 			if (td->urb->transfer_buffer_length <
 					td->urb->actual_length) {
 				xhci_warn(xhci, "HC gave bad length "
 						"of %d bytes left\n",
-					  TRB_LEN(le32_to_cpu(event->transfer_len)));
+					  EVENT_TRB_LEN(le32_to_cpu(event->transfer_len)));
 				td->urb->actual_length = 0;
 				if (td->urb->transfer_flags & URB_SHORT_NOT_OK)
 					*status = -EREMOTEIO;
@@ -2217,7 +2217,7 @@ static int process_bulk_intr_td(struct x
 		if (trb_comp_code != COMP_STOP_INVAL)
 			td->urb->actual_length +=
 				TRB_LEN(le32_to_cpu(cur_trb->generic.field[2])) -
-				TRB_LEN(le32_to_cpu(event->transfer_len));
+				EVENT_TRB_LEN(le32_to_cpu(event->transfer_len));
 	}
 
 	return finish_td(xhci, td, event_trb, event, ep, status, false);
@@ -2283,7 +2283,7 @@ static int handle_tx_event(struct xhci_h
 	 * transfer type
 	 */
 	case COMP_SUCCESS:
-		if (TRB_LEN(le32_to_cpu(event->transfer_len)) == 0)
+		if (EVENT_TRB_LEN(le32_to_cpu(event->transfer_len)) == 0)
 			break;
 		if (xhci->quirks & XHCI_TRUST_TX_LENGTH)
 			trb_comp_code = COMP_SHORT_TX;
--- a/drivers/usb/host/xhci.h
+++ b/drivers/usb/host/xhci.h
@@ -968,6 +968,10 @@ struct xhci_transfer_event {
 	__le32	flags;
 };
 
+/* Transfer event TRB length bit mask */
+/* bits 0:23 */
+#define	EVENT_TRB_LEN(p)		((p) & 0xffffff)
+
 /** Transfer Event bit fields **/
 #define	TRB_TO_EP_ID(p)	(((p) >> 16) & 0x1f)
 

