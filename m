Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757947Ab3JJP72 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Oct 2013 11:59:28 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:52923 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757395Ab3JJPtL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Oct 2013 11:49:11 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Alan Stern <stern@rowland.harvard.edu>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 068/104] USB: UHCI: accept very late isochronous URBs
Date: Thu, 10 Oct 2013 08:41:56 -0700
Message-Id: <1381419752-29733-69-git-send-email-kamal@canonical.com>
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
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 drivers/usb/host/uhci-q.c | 12 ++++++++----
 1 file changed, 8 insertions(+), 4 deletions(-)

diff --git a/drivers/usb/host/uhci-q.c b/drivers/usb/host/uhci-q.c
index 3b08519..3232578 100644
--- a/drivers/usb/host/uhci-q.c
+++ b/drivers/usb/host/uhci-q.c
@@ -1303,7 +1303,7 @@ static int uhci_submit_isochronous(struct uhci_hcd *uhci, struct urb *urb,
 		}
 
 		/* Fell behind? */
-		if (uhci_frame_before_eq(frame, next)) {
+		if (!uhci_frame_before_eq(next, frame)) {
 
 			/* USB_ISO_ASAP: Round up to the first available slot */
 			if (urb->transfer_flags & URB_ISO_ASAP)
@@ -1311,13 +1311,17 @@ static int uhci_submit_isochronous(struct uhci_hcd *uhci, struct urb *urb,
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
 
-- 
1.8.1.2

