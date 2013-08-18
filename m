Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755912Ab3HRUkk (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Aug 2013 16:40:40 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:43726 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756419Ab3HRUfM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Aug 2013 16:35:12 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Thomas Pugliese <thomas.pugliese@gmail.com>
Subject: [ 38/45] wusbcore: fix kernel panic when disconnecting a wireless USB->serial device
Date: Sun, 18 Aug 2013 13:36:27 -0700
Message-Id: <20130818203623.640414545@linuxfoundation.org>
X-Mailer: git-send-email 1.8.3.3.825.g36032ce.dirty
In-Reply-To: <20130818203620.996166594@linuxfoundation.org>
References: <20130818203620.996166594@linuxfoundation.org>
User-Agent: quilt/0.60-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Thomas Pugliese <thomas.pugliese@gmail.com>

commit ec58fad1feb76c323ef47efff1d1e8660ed4644c upstream.

This patch fixes a kernel panic that can occur when disconnecting a
wireless USB->serial device.  When the serial device disconnects, the
device cleanup procedure ends up calling usb_hcd_disable_endpoint on the
serial device's endpoints.  The wusbcore uses the ABORT_RPIPE command to
abort all transfers on the given endpoint but it does not properly give
back the URBs when the transfer results return from the HWA.  This patch
prevents the transfer result processing code from bailing out when it sees
a WA_XFER_STATUS_ABORTED result code so that these urbs are flushed
properly by usb_hcd_disable_endpoint.  It also updates wa_urb_dequeue to
handle the case where the endpoint has already been cleaned up when
usb_kill_urb is called which is where the panic originally occurred.

Signed-off-by: Thomas Pugliese <thomas.pugliese@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/usb/wusbcore/wa-xfer.c |    9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

--- a/drivers/usb/wusbcore/wa-xfer.c
+++ b/drivers/usb/wusbcore/wa-xfer.c
@@ -1110,6 +1110,12 @@ int wa_urb_dequeue(struct wahc *wa, stru
 	}
 	spin_lock_irqsave(&xfer->lock, flags);
 	rpipe = xfer->ep->hcpriv;
+	if (rpipe == NULL) {
+		pr_debug("%s: xfer id 0x%08X has no RPIPE.  %s",
+			__func__, wa_xfer_id(xfer),
+			"Probably already aborted.\n" );
+		goto out_unlock;
+	}
 	/* Check the delayed list -> if there, release and complete */
 	spin_lock_irqsave(&wa->xfer_list_lock, flags2);
 	if (!list_empty(&xfer->list_node) && xfer->seg == NULL)
@@ -1493,8 +1499,7 @@ static void wa_xfer_result_cb(struct urb
 			break;
 		}
 		usb_status = xfer_result->bTransferStatus & 0x3f;
-		if (usb_status == WA_XFER_STATUS_ABORTED
-		    || usb_status == WA_XFER_STATUS_NOT_FOUND)
+		if (usb_status == WA_XFER_STATUS_NOT_FOUND)
 			/* taken care of already */
 			break;
 		xfer_id = xfer_result->dwTransferID;


