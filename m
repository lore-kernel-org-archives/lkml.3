Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757389Ab3JJPtH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Oct 2013 11:49:07 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:52908 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757374Ab3JJPtD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Oct 2013 11:49:03 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Alan Stern <stern@rowland.harvard.edu>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 069/104] USB: OHCI: accept very late isochronous URBs
Date: Thu, 10 Oct 2013 08:41:57 -0700
Message-Id: <1381419752-29733-70-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1381419752-29733-1-git-send-email-kamal@canonical.com>
References: <1381419752-29733-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.8.13.11 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alan Stern <stern@rowland.harvard.edu>

commit a8693424c751b8247ee19bd8b857f1d4f432b972 upstream.

Commit 24f531371de1 (USB: EHCI: accept very late isochronous URBs)
changed the isochronous API provided by ehci-hcd.  URBs submitted too
late, so that the time slots for all their packets have already
expired, are no longer rejected outright.  Instead the submission is
accepted, and the URB completes normally with a -EXDEV error for each
packet.  This is what client drivers expect.

This patch implements the same policy in ohci-hcd.  The change is more
complicated than it was in ehci-hcd, because ohci-hcd doesn't scan for
isochronous completions in the same way as ehci-hcd does.  Rather, it
depends on the hardware adding completed TDs to a "done queue".  Some
OHCI controller don't handle this properly when a TD's time slot has
already expired, so we have to avoid adding such TDs to the schedule
in the first place.  As a result, if the URB was submitted too late
then none of its TDs will get put on the schedule, so none of them
will end up on the done queue, so the driver will never realize that
the URB should be completed.

To solve this problem, the patch adds one to urb_priv->td_cnt for such
URBs, making it larger than urb_priv->length (td_cnt already gets set
to the number of TD's that had to be skipped because their slots have
expired).  Each time an URB is given back, the finish_urb() routine
looks to see if urb_priv->td_cnt for the next URB on the same endpoint
is marked in this way.  If so, it gives back the next URB right away.

This should be applied to all kernels containing commit 815fa7b91761
(USB: OHCI: fix logic for scheduling isochronous URBs).

Signed-off-by: Alan Stern <stern@rowland.harvard.edu>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
[ kamal: backport to 3.8 (context) ]
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 drivers/usb/host/ohci-hcd.c | 22 ++++++++++++----------
 drivers/usb/host/ohci-q.c   | 24 +++++++++++++++++++++---
 2 files changed, 33 insertions(+), 13 deletions(-)

diff --git a/drivers/usb/host/ohci-hcd.c b/drivers/usb/host/ohci-hcd.c
index 007137f..0757a54 100644
--- a/drivers/usb/host/ohci-hcd.c
+++ b/drivers/usb/host/ohci-hcd.c
@@ -231,31 +231,26 @@ static int ohci_urb_enqueue (
 			frame &= ~(ed->interval - 1);
 			frame |= ed->branch;
 			urb->start_frame = frame;
+			ed->last_iso = frame + ed->interval * (size - 1);
 		}
 	} else if (ed->type == PIPE_ISOCHRONOUS) {
 		u16	next = ohci_frame_no(ohci) + 1;
 		u16	frame = ed->last_iso + ed->interval;
+		u16	length = ed->interval * (size - 1);
 
 		/* Behind the scheduling threshold? */
 		if (unlikely(tick_before(frame, next))) {
 
-			/* USB_ISO_ASAP: Round up to the first available slot */
+			/* URB_ISO_ASAP: Round up to the first available slot */
 			if (urb->transfer_flags & URB_ISO_ASAP) {
 				frame += (next - frame + ed->interval - 1) &
 						-ed->interval;
 
 			/*
-			 * Not ASAP: Use the next slot in the stream.  If
-			 * the entire URB falls before the threshold, fail.
+			 * Not ASAP: Use the next slot in the stream,
+			 * no matter what.
 			 */
 			} else {
-				if (tick_before(frame + ed->interval *
-					(urb->number_of_packets - 1), next)) {
-					retval = -EXDEV;
-					usb_hcd_unlink_urb_from_ep(hcd, urb);
-					goto fail;
-				}
-
 				/*
 				 * Some OHCI hardware doesn't handle late TDs
 				 * correctly.  After retiring them it proceeds
@@ -266,9 +261,16 @@ static int ohci_urb_enqueue (
 				urb_priv->td_cnt = DIV_ROUND_UP(
 						(u16) (next - frame),
 						ed->interval);
+				if (urb_priv->td_cnt >= urb_priv->length) {
+					++urb_priv->td_cnt;	/* Mark it */
+					ohci_dbg(ohci, "iso underrun %p (%u+%u < %u)\n",
+							urb, frame, length,
+							next);
+				}
 			}
 		}
 		urb->start_frame = frame;
+		ed->last_iso = frame + length;
 	}
 
 	/* fill the TDs and link them to the ed; and
diff --git a/drivers/usb/host/ohci-q.c b/drivers/usb/host/ohci-q.c
index 7482cfb..89883c8 100644
--- a/drivers/usb/host/ohci-q.c
+++ b/drivers/usb/host/ohci-q.c
@@ -41,8 +41,12 @@ finish_urb(struct ohci_hcd *ohci, struct urb *urb, int status)
 __releases(ohci->lock)
 __acquires(ohci->lock)
 {
+	struct usb_host_endpoint *ep = urb->ep;
+	struct urb_priv *urb_priv;
+
 	// ASSERT (urb->hcpriv != 0);
 
+ restart:
 	urb_free_priv (ohci, urb->hcpriv);
 	if (likely(status == -EINPROGRESS))
 		status = 0;
@@ -78,6 +82,21 @@ __acquires(ohci->lock)
 		ohci->hc_control &= ~(OHCI_CTRL_PLE|OHCI_CTRL_IE);
 		ohci_writel (ohci, ohci->hc_control, &ohci->regs->control);
 	}
+
+	/*
+	 * An isochronous URB that is sumitted too late won't have any TDs
+	 * (marked by the fact that the td_cnt value is larger than the
+	 * actual number of TDs).  If the next URB on this endpoint is like
+	 * that, give it back now.
+	 */
+	if (!list_empty(&ep->urb_list)) {
+		urb = list_first_entry(&ep->urb_list, struct urb, urb_list);
+		urb_priv = urb->hcpriv;
+		if (urb_priv->td_cnt > urb_priv->length) {
+			status = 0;
+			goto restart;
+		}
+	}
 }
 
 
@@ -544,7 +563,6 @@ td_fill (struct ohci_hcd *ohci, u32 info,
 		td->hwCBP = cpu_to_hc32 (ohci, data & 0xFFFFF000);
 		*ohci_hwPSWp(ohci, td, 0) = cpu_to_hc16 (ohci,
 						(data & 0x0FFF) | 0xE000);
-		td->ed->last_iso = info & 0xffff;
 	} else {
 		td->hwCBP = cpu_to_hc32 (ohci, data);
 	}
@@ -993,7 +1011,7 @@ rescan_this:
 			urb_priv->td_cnt++;
 
 			/* if URB is done, clean up */
-			if (urb_priv->td_cnt == urb_priv->length) {
+			if (urb_priv->td_cnt >= urb_priv->length) {
 				modified = completed = 1;
 				finish_urb(ohci, urb, 0);
 			}
@@ -1083,7 +1101,7 @@ static void takeback_td(struct ohci_hcd *ohci, struct td *td)
 	urb_priv->td_cnt++;
 
 	/* If all this urb's TDs are done, call complete() */
-	if (urb_priv->td_cnt == urb_priv->length)
+	if (urb_priv->td_cnt >= urb_priv->length)
 		finish_urb(ohci, urb, status);
 
 	/* clean schedule:  unlink EDs that are no longer busy */
-- 
1.8.1.2

