Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933004Ab3GVSLG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Jul 2013 14:11:06 -0400
Received: from www.linutronix.de ([62.245.132.108]:41846 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932728Ab3GVSLC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Jul 2013 14:11:02 -0400
From: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
To: linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: balbi@ti.com, george.cherian@ti.com,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Subject: [PATCH 12/16] usb: musb: unmap reqs in musb_gadget_queue()'s error case
Date: Mon, 22 Jul 2013 20:10:03 +0200
Message-Id: <1374516607-2705-13-git-send-email-bigeasy@linutronix.de>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1374516607-2705-1-git-send-email-bigeasy@linutronix.de>
References: <1374516607-2705-1-git-send-email-bigeasy@linutronix.de>
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001,URIBL_BLOCKED=0.001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If the descriptor is missing the reqeust is never unmapped. This patch
changes this and renames the cleanup label to unlock since there is no
cleanup done. The cleanup would revert the allocation of ressource (i.e.
this dma mapping) but it does not, it simply unlocks and returns.

Signed-off-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
---
 drivers/usb/musb/musb_gadget.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/usb/musb/musb_gadget.c b/drivers/usb/musb/musb_gadget.c
index 0414bc1..96632f9 100644
--- a/drivers/usb/musb/musb_gadget.c
+++ b/drivers/usb/musb/musb_gadget.c
@@ -1266,7 +1266,8 @@ static int musb_gadget_queue(struct usb_ep *ep, struct usb_request *req,
 		dev_dbg(musb->controller, "req %p queued to %s while ep %s\n",
 				req, ep->name, "disabled");
 		status = -ESHUTDOWN;
-		goto cleanup;
+		unmap_dma_buffer(request, musb);
+		goto unlock;
 	}
 
 	/* add request to the list */
@@ -1276,7 +1277,7 @@ static int musb_gadget_queue(struct usb_ep *ep, struct usb_request *req,
 	if (!musb_ep->busy && &request->list == musb_ep->req_list.next)
 		musb_ep_restart(musb, request);
 
-cleanup:
+unlock:
 	spin_unlock_irqrestore(&musb->lock, lockflags);
 	return status;
 }
-- 
1.8.3.2

