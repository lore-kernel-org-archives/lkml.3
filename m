Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752138AbaL3KB0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Dec 2014 05:01:26 -0500
Received: from nasmtp01.atmel.com ([192.199.1.245]:59698 "EHLO
	DVREDG01.corp.atmel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751756AbaL3KBY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Dec 2014 05:01:24 -0500
From: Songjun Wu <songjun.wu@atmel.com>
To: <balbi@ti.com>, <gregkh@linuxfoundation.org>, <linux-usb@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <nicolas.ferre@atmel.com>,
        <linux-arm-kernel@lists.infradead.org>
CC: Songjun Wu <songjun.wu@atmel.com>
Subject: [PATCH] USB: gadget: udc: atmel: fix possible oops when unloading module
Date: Tue, 30 Dec 2014 17:49:27 +0800
Message-ID: <1419932967-2694-1-git-send-email-songjun.wu@atmel.com>
X-Mailer: git-send-email 1.7.9.5
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Executing the 'insmod g_hid.ko', then executing the
'rmmod g_hid.ko', the NULL pointer oops will be triggered.

When unloading the module 'g_hid.ko', the urb request will be
dequeued and the completion routine will be excuted. If no urb
packet, the urb request will not be added to the endpoint queue
and the completion routine pointer in urb request is NULL.
Accessing to the NULL function pointer will cause the oops issue.
Add the code to check the urb request is in the endpoint queue
or not.If the urb request is not in the endpoint queue, a negative
error code will be returned.

This bug was introduced since the file 'atmel_usba_udc.c' was
initialized. Fixes: 914a3f3b3754 (USB: add atmel_usba_udc driver)
Cc: stable@vger.kernel.org # always been there...

oops dump log is shown in the following.
Unable to handle kernel NULL pointer dereference at virtual
address 00000000
pgd = dedf0000
[00000000] *pgd=3ede5831, *pte=00000000, *ppte=00000000
Internal error: Oops: 80000007 [#1] ARM
Modules linked in: g_hid(-) usb_f_hid libcomposite

Signed-off-by: Songjun Wu <songjun.wu@atmel.com>
---
 drivers/usb/gadget/udc/atmel_usba_udc.c |   12 +++++++++++-
 1 file changed, 11 insertions(+), 1 deletion(-)

diff --git a/drivers/usb/gadget/udc/atmel_usba_udc.c b/drivers/usb/gadget/udc/atmel_usba_udc.c
index ce88237..48629cc 100644
--- a/drivers/usb/gadget/udc/atmel_usba_udc.c
+++ b/drivers/usb/gadget/udc/atmel_usba_udc.c
@@ -828,7 +828,7 @@ static int usba_ep_dequeue(struct usb_ep *_ep, struct usb_request *_req)
 {
 	struct usba_ep *ep = to_usba_ep(_ep);
 	struct usba_udc *udc = ep->udc;
-	struct usba_request *req = to_usba_req(_req);
+	struct usba_request *req;
 	unsigned long flags;
 	u32 status;
 
@@ -837,6 +837,16 @@ static int usba_ep_dequeue(struct usb_ep *_ep, struct usb_request *_req)
 
 	spin_lock_irqsave(&udc->lock, flags);
 
+	list_for_each_entry(req, &ep->queue, queue) {
+		if (&req->req == _req)
+			break;
+	}
+
+	if (&req->req != _req) {
+		spin_unlock_irqrestore(&udc->lock, flags);
+		return -EINVAL;
+	}
+
 	if (req->using_dma) {
 		/*
 		 * If this request is currently being transferred,
-- 
1.7.9.5

