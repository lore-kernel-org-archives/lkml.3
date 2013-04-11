Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936487Ab3DKVIG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Apr 2013 17:08:06 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:22974 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935684Ab3DKUtN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Apr 2013 16:49:13 -0400
X-Authority-Analysis: v=2.0 cv=F+XVh9dN c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=Ciwy3NGCPMMA:10 a=ithkbDxYIh8A:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=meVymXHHAAAA:8 a=QmoTEQiJDncA:10 a=hD80L64hAAAA:8 a=QyXUC8HyAAAA:8 a=VwQbUJbxAAAA:8 a=LefUIxA5NsMO4DLSpB8A:9 a=v3rLFGiuRE8A:10 a=jeBq3FmKZ4MA:10 a=0_WhMQEHSv1VMwpu:21 a=DKaIW5CIIKUVHF0X:21 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 74.67.115.198
Message-Id: <20130411202604.031137903@goodmis.org>
User-Agent: quilt/0.60-1
Date: Thu, 11 Apr 2013 16:26:51 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Vivek gautam <gautam.vivek@samsung.com>,
        Sarah Sharp <sarah.a.sharp@linux.intel.com>
Subject: [ 108/171 ] usb: xhci: Fix TRB transfer length macro used for Event TRB.
References: <20130411202503.783159048@goodmis.org>
Content-Disposition: inline; filename=0108-usb-xhci-Fix-TRB-transfer-length-macro-used-for-Even.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.6.11.2 stable review patch.
If anyone has any objections, please let me know.

------------------

From: Vivek Gautam <gautam.vivek@samsung.com>

[ Upstream commit 1c11a172cb30492f5f6a82c6e118fdcd9946c34f ]

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
Cc: stable@vger.kernel.org
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 drivers/usb/host/xhci-ring.c |   24 ++++++++++++------------
 drivers/usb/host/xhci.h      |    4 ++++
 2 files changed, 16 insertions(+), 12 deletions(-)

diff --git a/drivers/usb/host/xhci-ring.c b/drivers/usb/host/xhci-ring.c
index 4f1e265..b9ade46 100644
--- a/drivers/usb/host/xhci-ring.c
+++ b/drivers/usb/host/xhci-ring.c
@@ -2018,8 +2018,8 @@ static int process_ctrl_td(struct xhci_hcd *xhci, struct xhci_td *td,
 		if (event_trb != ep_ring->dequeue &&
 				event_trb != td->last_trb)
 			td->urb->actual_length =
-				td->urb->transfer_buffer_length
-				- TRB_LEN(le32_to_cpu(event->transfer_len));
+				td->urb->transfer_buffer_length -
+				EVENT_TRB_LEN(le32_to_cpu(event->transfer_len));
 		else
 			td->urb->actual_length = 0;
 
@@ -2051,7 +2051,7 @@ static int process_ctrl_td(struct xhci_hcd *xhci, struct xhci_td *td,
 		/* Maybe the event was for the data stage? */
 			td->urb->actual_length =
 				td->urb->transfer_buffer_length -
-				TRB_LEN(le32_to_cpu(event->transfer_len));
+				EVENT_TRB_LEN(le32_to_cpu(event->transfer_len));
 			xhci_dbg(xhci, "Waiting for status "
 					"stage event\n");
 			return 0;
@@ -2087,7 +2087,7 @@ static int process_isoc_td(struct xhci_hcd *xhci, struct xhci_td *td,
 	/* handle completion code */
 	switch (trb_comp_code) {
 	case COMP_SUCCESS:
-		if (TRB_LEN(le32_to_cpu(event->transfer_len)) == 0) {
+		if (EVENT_TRB_LEN(le32_to_cpu(event->transfer_len)) == 0) {
 			frame->status = 0;
 			break;
 		}
@@ -2132,7 +2132,7 @@ static int process_isoc_td(struct xhci_hcd *xhci, struct xhci_td *td,
 				len += TRB_LEN(le32_to_cpu(cur_trb->generic.field[2]));
 		}
 		len += TRB_LEN(le32_to_cpu(cur_trb->generic.field[2])) -
-			TRB_LEN(le32_to_cpu(event->transfer_len));
+			EVENT_TRB_LEN(le32_to_cpu(event->transfer_len));
 
 		if (trb_comp_code != COMP_STOP_INVAL) {
 			frame->actual_length = len;
@@ -2190,7 +2190,7 @@ static int process_bulk_intr_td(struct xhci_hcd *xhci, struct xhci_td *td,
 	case COMP_SUCCESS:
 		/* Double check that the HW transferred everything. */
 		if (event_trb != td->last_trb ||
-				TRB_LEN(le32_to_cpu(event->transfer_len)) != 0) {
+		    EVENT_TRB_LEN(le32_to_cpu(event->transfer_len)) != 0) {
 			xhci_warn(xhci, "WARN Successful completion "
 					"on short TX\n");
 			if (td->urb->transfer_flags & URB_SHORT_NOT_OK)
@@ -2218,18 +2218,18 @@ static int process_bulk_intr_td(struct xhci_hcd *xhci, struct xhci_td *td,
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
@@ -2271,7 +2271,7 @@ static int process_bulk_intr_td(struct xhci_hcd *xhci, struct xhci_td *td,
 		if (trb_comp_code != COMP_STOP_INVAL)
 			td->urb->actual_length +=
 				TRB_LEN(le32_to_cpu(cur_trb->generic.field[2])) -
-				TRB_LEN(le32_to_cpu(event->transfer_len));
+				EVENT_TRB_LEN(le32_to_cpu(event->transfer_len));
 	}
 
 	return finish_td(xhci, td, event_trb, event, ep, status, false);
@@ -2357,7 +2357,7 @@ static int handle_tx_event(struct xhci_hcd *xhci,
 	 * transfer type
 	 */
 	case COMP_SUCCESS:
-		if (TRB_LEN(le32_to_cpu(event->transfer_len)) == 0)
+		if (EVENT_TRB_LEN(le32_to_cpu(event->transfer_len)) == 0)
 			break;
 		if (xhci->quirks & XHCI_TRUST_TX_LENGTH)
 			trb_comp_code = COMP_SHORT_TX;
diff --git a/drivers/usb/host/xhci.h b/drivers/usb/host/xhci.h
index 7c75bfe..212d408 100644
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
1.7.10.4


