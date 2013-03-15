Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755291Ab3CON3L (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Mar 2013 09:29:11 -0400
Received: from devils.ext.ti.com ([198.47.26.153]:60973 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754714Ab3CON3E (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Mar 2013 09:29:04 -0400
From: Kishon Vijay Abraham I <kishon@ti.com>
To: <balbi@ti.com>, <gregkh@linuxfoundation.org>, <linux-usb@vger.kernel.org>,
        <linux-omap@vger.kernel.org>, <linux-kernel@vger.kernel.org>
CC: <tony@atomide.com>, <notasas@gmail.com>,
        Kishon Vijay Abraham I <kishon@ti.com>
Subject: [PATCH 2/4] usb: musb: gadget: do *unmap_dma_buffer* only for valid DMA addr
Date: Fri, 15 Mar 2013 18:58:50 +0530
Message-ID: <1363354132-27523-2-git-send-email-kishon@ti.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1363354132-27523-1-git-send-email-kishon@ti.com>
References: <1363354132-27523-1-git-send-email-kishon@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

musb does not use DMA buffer for ep0 but it uses the same giveback
function *musb_g_giveback* for all endpoints (*musb_g_ep0_giveback* calls
*musb_g_giveback*). So for ep0 case request.dma will be '0'
and will result in kernel OOPS if tried to *unmap_dma_buffer* for requests in
ep0. Fixed it by doing *unmap_dma_buffer* only for valid DMA addr.

Signed-off-by: Kishon Vijay Abraham I <kishon@ti.com>
---
 drivers/usb/musb/musb_gadget.c |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/usb/musb/musb_gadget.c b/drivers/usb/musb/musb_gadget.c
index c454375..ec3cf29 100644
--- a/drivers/usb/musb/musb_gadget.c
+++ b/drivers/usb/musb/musb_gadget.c
@@ -107,7 +107,10 @@ __acquires(ep->musb->lock)
 
 	ep->busy = 1;
 	spin_unlock(&musb->lock);
-	unmap_dma_buffer(req, musb);
+
+	if (request->dma)
+		unmap_dma_buffer(req, musb);
+
 	if (request->status == 0)
 		dev_dbg(musb->controller, "%s done request %p,  %d/%d\n",
 				ep->end_point.name, request,
-- 
1.7.10.4

