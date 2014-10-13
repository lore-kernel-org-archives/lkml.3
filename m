Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755116AbaJMCdA (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Oct 2014 22:33:00 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:46231 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754834AbaJMCan (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Oct 2014 22:30:43 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Li Jun <b47624@freescale.com>, Felipe Balbi <balbi@ti.com>
Subject: [PATCH 3.17 18/25] Revert "usb: gadget: composite: dequeue cdev->req before free it in composite_dev_cleanup"
Date: Mon, 13 Oct 2014 04:25:11 +0200
Message-Id: <20141013022455.072752737@linuxfoundation.org>
X-Mailer: git-send-email 2.1.2
In-Reply-To: <20141013022454.289398272@linuxfoundation.org>
References: <20141013022454.289398272@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.17-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Felipe Balbi <balbi@ti.com>

commit bf17eba7ae1e813b0ad67cb1078dcbd7083b906e upstream.

This reverts commit f2267089ea17fa97b796b1b4247e3f8957655df3.

That commit causes more problem than fixes. Firstly, kfree()
should be called after usb_ep_dequeue() and secondly, the way
things are, we will try to dequeue a request that has already
completed much more frequently than one which is pending.

Cc: Li Jun <b47624@freescale.com>
Signed-off-by: Felipe Balbi <balbi@ti.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/usb/gadget/composite.c |    1 -
 1 file changed, 1 deletion(-)

--- a/drivers/usb/gadget/composite.c
+++ b/drivers/usb/gadget/composite.c
@@ -1956,7 +1956,6 @@ void composite_dev_cleanup(struct usb_co
 	}
 	if (cdev->req) {
 		kfree(cdev->req->buf);
-		usb_ep_dequeue(cdev->gadget->ep0, cdev->req);
 		usb_ep_free_request(cdev->gadget->ep0, cdev->req);
 	}
 	cdev->next_string_id = 0;


