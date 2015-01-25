Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757185AbbAYSVq (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 Jan 2015 13:21:46 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:58023 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756156AbbAYSKl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 Jan 2015 13:10:41 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Nicolas Ferre <nicolas.ferre@atmel.com>,
        Bo Shen <voice.shen@atmel.com>, Felipe Balbi <balbi@ti.com>
Subject: [PATCH 3.18 149/183] usb: gadget: udc: atmel: fix possible IN hang issue
Date: Sun, 25 Jan 2015 10:07:51 -0800
Message-Id: <20150125180816.654070676@linuxfoundation.org>
X-Mailer: git-send-email 2.2.2
In-Reply-To: <20150125180810.160428929@linuxfoundation.org>
References: <20150125180810.160428929@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.18-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/usb/gadget/udc/atmel_usba_udc.c |    1 -
 1 file changed, 1 deletion(-)

--- a/drivers/usb/gadget/udc/atmel_usba_udc.c
+++ b/drivers/usb/gadget/udc/atmel_usba_udc.c
@@ -1572,7 +1572,6 @@ static void usba_ep_irq(struct usba_udc
 	if ((epstatus & epctrl) & USBA_RX_BK_RDY) {
 		DBG(DBG_BUS, "%s: RX data ready\n", ep->ep.name);
 		receive_data(ep);
-		usba_ep_writel(ep, CLR_STA, USBA_RX_BK_RDY);
 	}
 }
 


