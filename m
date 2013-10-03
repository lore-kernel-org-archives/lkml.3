Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756088Ab3JCETP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Oct 2013 00:19:15 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:47198 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754224Ab3JCETN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Oct 2013 00:19:13 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Alan Stern <stern@rowland.harvard.edu>
Subject: [ 34/57] USB: UHCI: accept very late isochronous URBs
Date: Wed,  2 Oct 2013 21:09:00 -0700
Message-Id: <20131003040638.935871481@linuxfoundation.org>
X-Mailer: git-send-email 1.8.4.6.g82e253f.dirty
In-Reply-To: <20131003040636.600441214@linuxfoundation.org>
References: <20131003040636.600441214@linuxfoundation.org>
User-Agent: quilt/0.60-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.11-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alan Stern <stern@rowland.harvard.edu>

commit bef073b067a7b1874a6b381e0035bb0516d71a77 upstream.

Commit 24f531371de1 (USB: EHCI: accept very late isochronous URBs)
changed the isochronous API provided by ehci-hcd.  URBs submitted too
late, so that the time slots for all their packets have already
expired, are no longer rejected outright.  Instead the submission is
accepted, and the URB completes normally with a -EXDEV error for each
packet.  This is what client drivers expect.

This patch implements the same policy in uhci-hcd.  It should be
applied to all kernels containing commit c44b225077bb (UHCI: implement
new semantics for URB_ISO_ASAP).

Signed-off-by: Alan Stern <stern@rowland.harvard.edu>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/usb/host/uhci-q.c |   12 ++++++++----
 1 file changed, 8 insertions(+), 4 deletions(-)

--- a/drivers/usb/host/uhci-q.c
+++ b/drivers/usb/host/uhci-q.c
@@ -1303,7 +1303,7 @@ static int uhci_submit_isochronous(struc
 		}
 
 		/* Fell behind? */
-		if (uhci_frame_before_eq(frame, next)) {
+		if (!uhci_frame_before_eq(next, frame)) {
 
 			/* USB_ISO_ASAP: Round up to the first available slot */
 			if (urb->transfer_flags & URB_ISO_ASAP)
@@ -1311,13 +1311,17 @@ static int uhci_submit_isochronous(struc
 						-qh->period;
 
 			/*
-			 * Not ASAP: Use the next slot in the stream.  If
-			 * the entire URB falls before the threshold, fail.
+			 * Not ASAP: Use the next slot in the stream,
+			 * no matter what.
 			 */
 			else if (!uhci_frame_before_eq(next,
 					frame + (urb->number_of_packets - 1) *
 						qh->period))
-				return -EXDEV;
+				dev_dbg(uhci_dev(uhci), "iso underrun %p (%u+%u < %u)\n",
+						urb, frame,
+						(urb->number_of_packets - 1) *
+							qh->period,
+						next);
 		}
 	}
 


