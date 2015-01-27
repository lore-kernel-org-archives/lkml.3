Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932781AbbA0Mdu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Jan 2015 07:33:50 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:35257 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932363AbbA0MTD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Jan 2015 07:19:03 -0500
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Bo Shen <voice.shen@atmel.com>, Felipe Balbi <balbi@ti.com>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.16.y-ckt 078/126] [PATCH] usb: gadget: udc: atmel: fix possible IN hang issue
Date: Tue, 27 Jan 2015 12:16:23 +0000
Message-Id: <1422361031-19364-79-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 2.1.4
In-Reply-To: <1422361031-19364-1-git-send-email-luis.henriques@canonical.com>
References: <1422361031-19364-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.16
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.16.7-ckt5 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Bo Shen <voice.shen@atmel.com>

commit 6785a1034461c2d2c205215f63a50a740896e55b upstream.

When receive data, the RXRDY in status register set by hardware
after a new packet has been stored in the endpoint FIFO. When it
is copied from FIFO, this bit is cleared which make the FIFO can
be accessed again.

In the receive_data() function, this bit RXRDY has been cleared.
So, after the receive_data() function return, this bit should
not be cleared again, or else it may cause the accessing FIFO
corrupt, which will make the data loss.

Fixes: 914a3f3b3754 (USB: add atmel_usba_udc driver)
Acked-by: Nicolas Ferre <nicolas.ferre@atmel.com>
Signed-off-by: Bo Shen <voice.shen@atmel.com>
Signed-off-by: Felipe Balbi <balbi@ti.com>
[ luis: backported to 3.16:
  - file rename: drivers/usb/gadget/udc/atmel_usba_udc.c ->
    drivers/usb/gadget/atmel_usba_udc.c ]
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 drivers/usb/gadget/atmel_usba_udc.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/usb/gadget/atmel_usba_udc.c b/drivers/usb/gadget/atmel_usba_udc.c
index 9fff23fa1519..f34157a8dc22 100644
--- a/drivers/usb/gadget/atmel_usba_udc.c
+++ b/drivers/usb/gadget/atmel_usba_udc.c
@@ -1572,7 +1572,6 @@ static void usba_ep_irq(struct usba_udc *udc, struct usba_ep *ep)
 	if ((epstatus & epctrl) & USBA_RX_BK_RDY) {
 		DBG(DBG_BUS, "%s: RX data ready\n", ep->ep.name);
 		receive_data(ep);
-		usba_ep_writel(ep, CLR_STA, USBA_RX_BK_RDY);
 	}
 }
 
-- 
2.1.4

