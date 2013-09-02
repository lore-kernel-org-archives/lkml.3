Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758904Ab3IBJHH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Sep 2013 05:07:07 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:37762 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758431Ab3IBIzW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Sep 2013 04:55:22 -0400
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Thomas Pugliese <thomas.pugliese@gmail.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 31/58] wusbcore: fix kernel panic when disconnecting a wireless USB->serial device
Date: Mon,  2 Sep 2013 09:54:16 +0100
Message-Id: <1378112083-9475-32-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1378112083-9475-1-git-send-email-luis.henriques@canonical.com>
References: <1378112083-9475-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.21 -stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 drivers/usb/wusbcore/wa-xfer.c | 9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

diff --git a/drivers/usb/wusbcore/wa-xfer.c b/drivers/usb/wusbcore/wa-xfer.c
index 57c01ab..1ebc17e 100644
--- a/drivers/usb/wusbcore/wa-xfer.c
+++ b/drivers/usb/wusbcore/wa-xfer.c
@@ -1110,6 +1110,12 @@ int wa_urb_dequeue(struct wahc *wa, struct urb *urb)
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
@@ -1493,8 +1499,7 @@ static void wa_xfer_result_cb(struct urb *urb)
 			break;
 		}
 		usb_status = xfer_result->bTransferStatus & 0x3f;
-		if (usb_status == WA_XFER_STATUS_ABORTED
-		    || usb_status == WA_XFER_STATUS_NOT_FOUND)
+		if (usb_status == WA_XFER_STATUS_NOT_FOUND)
 			/* taken care of already */
 			break;
 		xfer_id = xfer_result->dwTransferID;
-- 
1.8.3.2

