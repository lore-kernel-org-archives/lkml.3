Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752139AbaLQJTG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Dec 2014 04:19:06 -0500
Received: from nasmtp01.atmel.com ([192.199.1.246]:12920 "EHLO
	DVREDG02.corp.atmel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750904AbaLQJTD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Dec 2014 04:19:03 -0500
From: Bo Shen <voice.shen@atmel.com>
To: <balbi@ti.com>, <nicolas.ferre@atmel.com>
CC: <linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>,
        <linux-usb@vger.kernel.org>, Bo Shen <voice.shen@atmel.com>
Subject: [PATCH 2/2] USB: gadget: udc: atmel: fix possible IN hang issue
Date: Wed, 17 Dec 2014 17:18:49 +0800
Message-ID: <1418807929-31952-2-git-send-email-voice.shen@atmel.com>
X-Mailer: git-send-email 2.1.0.24.g4109c28
In-Reply-To: <1418807929-31952-1-git-send-email-voice.shen@atmel.com>
References: <1418807929-31952-1-git-send-email-voice.shen@atmel.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When receive data, the RXRDY in status register set by hardware
after a new packet has been stored in the endpoint FIFO. When it
is copied from FIFO, this bit is cleared which make the FIFO can
be accessed again.

In the receive_data() function, this bit RXRDY has been cleared.
So, after the receive_data() function return, this bit should
not be cleared again, or else it may cause the accessing FIFO
corrupt, which will make the data loss.

Signed-off-by: Bo Shen <voice.shen@atmel.com>
---

 drivers/usb/gadget/udc/atmel_usba_udc.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/usb/gadget/udc/atmel_usba_udc.c b/drivers/usb/gadget/udc/atmel_usba_udc.c
index 63e90f5..93328ea 100644
--- a/drivers/usb/gadget/udc/atmel_usba_udc.c
+++ b/drivers/usb/gadget/udc/atmel_usba_udc.c
@@ -1563,7 +1563,6 @@ static void usba_ep_irq(struct usba_udc *udc, struct usba_ep *ep)
 	if ((epstatus & epctrl) & USBA_RX_BK_RDY) {
 		DBG(DBG_BUS, "%s: RX data ready\n", ep->ep.name);
 		receive_data(ep);
-		usba_ep_writel(ep, CLR_STA, USBA_RX_BK_RDY);
 	}
 }
 
-- 
2.1.0.24.g4109c28

