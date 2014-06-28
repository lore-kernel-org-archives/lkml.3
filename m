Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756144AbaF1S1r (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Jun 2014 14:27:47 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:53948 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755683AbaF1RvG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Jun 2014 13:51:06 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Huang Rui <ray.huang@amd.com>
Subject: [PATCH 3.15 014/139] usb: usbtest: fix unlink write error with pattern 1
Date: Sat, 28 Jun 2014 10:46:15 -0700
Message-Id: <20140628174606.017676389@linuxfoundation.org>
X-Mailer: git-send-email 2.0.1
In-Reply-To: <20140628174605.352098823@linuxfoundation.org>
References: <20140628174605.352098823@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Huang Rui <ray.huang@amd.com>

commit e4d58f5dcb7d7be45df8def31881ebfae99c75da upstream.

TEST 12 and TEST 24 unlinks the URB write request for N times. When
host and gadget both initialize pattern 1 (mod 63) data series to
transfer, the gadget side will complain the wrong data which is not
expected.  Because in host side, usbtest doesn't fill the data buffer
as mod 63 and this patch fixed it.

[20285.488974] dwc3 dwc3.0.auto: ep1out-bulk: Transfer Not Ready
[20285.489181] dwc3 dwc3.0.auto: ep1out-bulk: reason Transfer Not Active
[20285.489423] dwc3 dwc3.0.auto: ep1out-bulk: req ffff8800aa6cb480 dma aeb50800 length 512 last
[20285.489727] dwc3 dwc3.0.auto: ep1out-bulk: cmd 'Start Transfer' params 00000000 a9eaf000 00000000
[20285.490055] dwc3 dwc3.0.auto: Command Complete --> 0
[20285.490281] dwc3 dwc3.0.auto: ep1out-bulk: Transfer Not Ready
[20285.490492] dwc3 dwc3.0.auto: ep1out-bulk: reason Transfer Active
[20285.490713] dwc3 dwc3.0.auto: ep1out-bulk: endpoint busy
[20285.490909] dwc3 dwc3.0.auto: ep1out-bulk: Transfer Complete
[20285.491117] dwc3 dwc3.0.auto: request ffff8800aa6cb480 from ep1out-bulk completed 512/512 ===> 0
[20285.491431] zero gadget: bad OUT byte, buf[1] = 0
[20285.491605] dwc3 dwc3.0.auto: ep1out-bulk: cmd 'Set Stall' params 00000000 00000000 00000000
[20285.491915] dwc3 dwc3.0.auto: Command Complete --> 0
[20285.492099] dwc3 dwc3.0.auto: queing request ffff8800aa6cb480 to ep1out-bulk length 512
[20285.492387] dwc3 dwc3.0.auto: ep1out-bulk: Transfer Not Ready
[20285.492595] dwc3 dwc3.0.auto: ep1out-bulk: reason Transfer Not Active
[20285.492830] dwc3 dwc3.0.auto: ep1out-bulk: req ffff8800aa6cb480 dma aeb51000 length 512 last
[20285.493135] dwc3 dwc3.0.auto: ep1out-bulk: cmd 'Start Transfer' params 00000000 a9eaf000 00000000
[20285.493465] dwc3 dwc3.0.auto: Command Complete --> 0

Signed-off-by: Huang Rui <ray.huang@amd.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/usb/misc/usbtest.c |   10 ++++++++++
 1 file changed, 10 insertions(+)

--- a/drivers/usb/misc/usbtest.c
+++ b/drivers/usb/misc/usbtest.c
@@ -1320,6 +1320,11 @@ static int unlink1(struct usbtest_dev *d
 	urb->context = &completion;
 	urb->complete = unlink1_callback;
 
+	if (usb_pipeout(urb->pipe)) {
+		simple_fill_buf(urb);
+		urb->transfer_flags |= URB_ZERO_PACKET;
+	}
+
 	/* keep the endpoint busy.  there are lots of hc/hcd-internal
 	 * states, and testing should get to all of them over time.
 	 *
@@ -1450,6 +1455,11 @@ static int unlink_queued(struct usbtest_
 				unlink_queued_callback, &ctx);
 		ctx.urbs[i]->transfer_dma = buf_dma;
 		ctx.urbs[i]->transfer_flags = URB_NO_TRANSFER_DMA_MAP;
+
+		if (usb_pipeout(ctx.urbs[i]->pipe)) {
+			simple_fill_buf(ctx.urbs[i]);
+			ctx.urbs[i]->transfer_flags |= URB_ZERO_PACKET;
+		}
 	}
 
 	/* Submit all the URBs and then unlink URBs num - 4 and num - 2. */


