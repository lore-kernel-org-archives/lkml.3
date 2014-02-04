Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935077AbaBDVzd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Feb 2014 16:55:33 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:57017 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933593AbaBDVLG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Feb 2014 16:11:06 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Michael Grzeschik <m.grzeschik@pengutronix.de>,
        Matthieu Vanin <b47495@freescale.com>,
        Peter Chen <peter.chen@freescale.com>
Subject: [PATCH 3.13 013/140] usb: chipidea: udc: using MultO at TD as real mult value for ISO-TX
Date: Tue,  4 Feb 2014 13:10:00 -0800
Message-Id: <20140204211037.347700799@linuxfoundation.org>
X-Mailer: git-send-email 1.8.5.1.163.gd7aced9
In-Reply-To: <20140204211036.967663852@linuxfoundation.org>
References: <20140204211036.967663852@linuxfoundation.org>
User-Agent: quilt/0.61-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.13-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Peter Chen <peter.chen@freescale.com>

commit 2fc5a7dace3c43e62402ab4e8800a8f1834ffe2a upstream.

We have met a bug that the high bandwidth ISO-TX transfer has failed
at the last packet if it is less than 1024, the TD status shows it
is "Transaction Error".

The root cause of this problem is: the mult value at qh is not correct
for current TD's transfer length. We use TD list to queue un-transfer
TDs, and change mult for new adding TDs. If new adding TDs transfer length
less than 1024, but the queued un-transfer TDs transfer length is larger
than 1024, the transfer error will occur, and vice versa.
Usually, this problem occurs at the last packet, and the first packet for
new frame.

We fixed this problem by setting Mult at QH as the largest value (3), and
set MultO (Multiplier Override) at TD according to every transfer length.
It can cover both hardware version less than 2.3 (the real mult is MultO
if it is not 0) and 2.3+ (the real mult is min(qh.mult, td.multo)).

Since the MultO bits are only existed at TX TD, we keep the ISO-RX behavior
unchanged.

For stable tree: 3.11+.

Cc: Michael Grzeschik <m.grzeschik@pengutronix.de>
Reported-by: Matthieu Vanin <b47495@freescale.com>
Tested-by: Matthieu Vanin <b47495@freescale.com>
Signed-off-by: Peter Chen <peter.chen@freescale.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/usb/chipidea/udc.c |   19 +++++++++++++++++--
 1 file changed, 17 insertions(+), 2 deletions(-)

--- a/drivers/usb/chipidea/udc.c
+++ b/drivers/usb/chipidea/udc.c
@@ -393,6 +393,14 @@ static int add_td_to_list(struct ci_hw_e
 	node->ptr->token = cpu_to_le32(length << __ffs(TD_TOTAL_BYTES));
 	node->ptr->token &= cpu_to_le32(TD_TOTAL_BYTES);
 	node->ptr->token |= cpu_to_le32(TD_STATUS_ACTIVE);
+	if (hwep->type == USB_ENDPOINT_XFER_ISOC && hwep->dir == TX) {
+		u32 mul = hwreq->req.length / hwep->ep.maxpacket;
+
+		if (hwreq->req.length == 0
+				|| hwreq->req.length % hwep->ep.maxpacket)
+			mul++;
+		node->ptr->token |= mul << __ffs(TD_MULTO);
+	}
 
 	temp = (u32) (hwreq->req.dma + hwreq->req.actual);
 	if (length) {
@@ -515,10 +523,11 @@ static int _hardware_enqueue(struct ci_h
 	hwep->qh.ptr->td.token &=
 		cpu_to_le32(~(TD_STATUS_HALTED|TD_STATUS_ACTIVE));
 
-	if (hwep->type == USB_ENDPOINT_XFER_ISOC) {
+	if (hwep->type == USB_ENDPOINT_XFER_ISOC && hwep->dir == RX) {
 		u32 mul = hwreq->req.length / hwep->ep.maxpacket;
 
-		if (hwreq->req.length % hwep->ep.maxpacket)
+		if (hwreq->req.length == 0
+				|| hwreq->req.length % hwep->ep.maxpacket)
 			mul++;
 		hwep->qh.ptr->cap |= mul << __ffs(QH_MULT);
 	}
@@ -1173,6 +1182,12 @@ static int ep_enable(struct usb_ep *ep,
 	if (hwep->num)
 		cap |= QH_ZLT;
 	cap |= (hwep->ep.maxpacket << __ffs(QH_MAX_PKT)) & QH_MAX_PKT;
+	/*
+	 * For ISO-TX, we set mult at QH as the largest value, and use
+	 * MultO at TD as real mult value.
+	 */
+	if (hwep->type == USB_ENDPOINT_XFER_ISOC && hwep->dir == TX)
+		cap |= 3 << __ffs(QH_MULT);
 
 	hwep->qh.ptr->cap = cpu_to_le32(cap);
 


