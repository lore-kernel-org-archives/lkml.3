Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935578Ab3DHJvl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Apr 2013 05:51:41 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:42719 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935542Ab3DHJvg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Apr 2013 05:51:36 -0400
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Vivek gautam <gautam.vivek@samsung.com>,
        Sarah Sharp <sarah.a.sharp@linux.intel.com>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 027/102] usb: xhci: Fix TRB transfer length macro used for Event TRB.
Date: Mon,  8 Apr 2013 10:49:42 +0100
Message-Id: <1365414657-29191-28-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1365414657-29191-1-git-send-email-luis.henriques@canonical.com>
References: <1365414657-29191-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.10 -stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 drivers/usb/host/xhci-ring.c | 24 ++++++++++++------------
 drivers/usb/host/xhci.h      |  4 ++++
 2 files changed, 16 insertions(+), 12 deletions(-)

diff --git a/drivers/usb/host/xhci-ring.c b/drivers/usb/host/xhci-ring.c
index 6f3043f..848d0bc 100644
--- a/drivers/usb/host/xhci-ring.c
+++ b/drivers/usb/host/xhci-ring.c
@@ -2027,8 +2027,8 @@ static int process_ctrl_td(struct xhci_hcd *xhci, struct xhci_td *td,
 		if (event_trb != ep_ring->dequeue &&
 				event_trb != td->last_trb)
 			td->urb->actual_length =
-				td->urb->transfer_buffer_length
-				- TRB_LEN(le32_to_cpu(event->transfer_len));
+				td->urb->transfer_buffer_length -
+				EVENT_TRB_LEN(le32_to_cpu(event->transfer_len));
 		else
 			td->urb->actual_length = 0;
 
@@ -2060,7 +2060,7 @@ static int process_ctrl_td(struct xhci_hcd *xhci, struct xhci_td *td,
 		/* Maybe the event was for the data stage? */
 			td->urb->actual_length =
 				td->urb->transfer_buffer_length -
-				TRB_LEN(le32_to_cpu(event->transfer_len));
+				EVENT_TRB_LEN(le32_to_cpu(event->transfer_len));
 			xhci_dbg(xhci, "Waiting for status "
 					"stage event\n");
 			return 0;
@@ -2096,7 +2096,7 @@ static int process_isoc_td(struct xhci_hcd *xhci, struct xhci_td *td,
 	/* handle completion code */
 	switch (trb_comp_code) {
 	case COMP_SUCCESS:
-		if (TRB_LEN(le32_to_cpu(event->transfer_len)) == 0) {
+		if (EVENT_TRB_LEN(le32_to_cpu(event->transfer_len)) == 0) {
 			frame->status = 0;
 			break;
 		}
@@ -2141,7 +2141,7 @@ static int process_isoc_td(struct xhci_hcd *xhci, struct xhci_td *td,
 				len += TRB_LEN(le32_to_cpu(cur_trb->generic.field[2]));
 		}
 		len += TRB_LEN(le32_to_cpu(cur_trb->generic.field[2])) -
-			TRB_LEN(le32_to_cpu(event->transfer_len));
+			EVENT_TRB_LEN(le32_to_cpu(event->transfer_len));
 
 		if (trb_comp_code != COMP_STOP_INVAL) {
 			frame->actual_length = len;
@@ -2199,7 +2199,7 @@ static int process_bulk_intr_td(struct xhci_hcd *xhci, struct xhci_td *td,
 	case COMP_SUCCESS:
 		/* Double check that the HW transferred everything. */
 		if (event_trb != td->last_trb ||
-				TRB_LEN(le32_to_cpu(event->transfer_len)) != 0) {
+		    EVENT_TRB_LEN(le32_to_cpu(event->transfer_len)) != 0) {
 			xhci_warn(xhci, "WARN Successful completion "
 					"on short TX\n");
 			if (td->urb->transfer_flags & URB_SHORT_NOT_OK)
@@ -2227,18 +2227,18 @@ static int process_bulk_intr_td(struct xhci_hcd *xhci, struct xhci_td *td,
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
@@ -2280,7 +2280,7 @@ static int process_bulk_intr_td(struct xhci_hcd *xhci, struct xhci_td *td,
 		if (trb_comp_code != COMP_STOP_INVAL)
 			td->urb->actual_length +=
 				TRB_LEN(le32_to_cpu(cur_trb->generic.field[2])) -
-				TRB_LEN(le32_to_cpu(event->transfer_len));
+				EVENT_TRB_LEN(le32_to_cpu(event->transfer_len));
 	}
 
 	return finish_td(xhci, td, event_trb, event, ep, status, false);
@@ -2366,7 +2366,7 @@ static int handle_tx_event(struct xhci_hcd *xhci,
 	 * transfer type
 	 */
 	case COMP_SUCCESS:
-		if (TRB_LEN(le32_to_cpu(event->transfer_len)) == 0)
+		if (EVENT_TRB_LEN(le32_to_cpu(event->transfer_len)) == 0)
 			break;
 		if (xhci->quirks & XHCI_TRUST_TX_LENGTH)
 			trb_comp_code = COMP_SHORT_TX;
diff --git a/drivers/usb/host/xhci.h b/drivers/usb/host/xhci.h
index b35bbbe..3e8bf2d 100644
--- a/drivers/usb/host/xhci.h
+++ b/drivers/usb/host/xhci.h
@@ -972,6 +972,10 @@ struct xhci_transfer_event {
 	__le32	flags;
 };
 
+/* Transfer event TRB length bit mask */
+/* bits 0:23 */
+#define	EVENT_TRB_LEN(p)		((p) & 0xffffff)
+
 /** Transfer Event bit fields **/
 #define	TRB_TO_EP_ID(p)	(((p) >> 16) & 0x1f)
 
-- 
1.8.1.2

