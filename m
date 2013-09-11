Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756732Ab3IKE7i (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Sep 2013 00:59:38 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:13847 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754229Ab3IKE46 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Sep 2013 00:56:58 -0400
X-Authority-Analysis: v=2.0 cv=V4T/IJbi c=1 sm=0 a=Sro2XwOs0tJUSHxCKfOySw==:17 a=Drc5e87SC40A:10 a=Ciwy3NGCPMMA:10 a=QGt8pn3mYAIA:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=meVymXHHAAAA:8 a=KGjhK52YXX0A:10 a=_w5-F3P5Qf0A:10 a=pGLkceISAAAA:8 a=ag1SF4gXAAAA:8 a=AMTp1_9230GDt9f3md0A:9 a=MSl-tDqOz04A:10 a=1TSTQ8KKaH4A:10 a=jeBq3FmKZ4MA:10 a=Sro2XwOs0tJUSHxCKfOySw==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 67.255.60.225
Message-Id: <20130911042927.438399713@goodmis.org>
User-Agent: quilt/0.60-1
Date: Wed, 11 Sep 2013 00:30:39 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Thomas Pugliese <thomas.pugliese@gmail.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: [212/251] wusbcore: fix kernel panic when disconnecting a wireless USB->serial
 device
References: <20130911042707.738353451@goodmis.org>
Content-Disposition: inline; filename=0212-wusbcore-fix-kernel-panic-when-disconnecting-a-wirel.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.6.11.9-rc1 stable review patch.
If anyone has any objections, please let me know.

------------------

From: Thomas Pugliese <thomas.pugliese@gmail.com>

[ Upstream commit ec58fad1feb76c323ef47efff1d1e8660ed4644c ]

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
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 drivers/usb/wusbcore/wa-xfer.c |    9 +++++++--
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
1.7.10.4


