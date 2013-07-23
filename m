Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934294Ab3GWUUh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Jul 2013 16:20:37 -0400
Received: from mail.ispras.ru ([83.149.199.45]:47747 "EHLO mail.ispras.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934277Ab3GWUUe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Jul 2013 16:20:34 -0400
From: Alexey Khoroshilov <khoroshilov@ispras.ru>
To: Felipe Balbi <balbi@ti.com>
Cc: Alexey Khoroshilov <khoroshilov@ispras.ru>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org,
        ldv-project@linuxtesting.org
Subject: [PATCH] usb: gadget: mv_u3d_core: fix violation of locking discipline in mv_u3d_ep_disable()
Date: Wed, 24 Jul 2013 00:20:17 +0400
Message-Id: <1374610817-14894-1-git-send-email-khoroshilov@ispras.ru>
X-Mailer: git-send-email 1.8.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

mv_u3d_nuke() expects to be calles with ep->u3d->lock held,
because mv_u3d_done() does. But mv_u3d_ep_disable() calls it
without lock that can lead to unpleasant consequences.

Found by Linux Driver Verification project (linuxtesting.org).

Signed-off-by: Alexey Khoroshilov <khoroshilov@ispras.ru>
---
 drivers/usb/gadget/mv_u3d_core.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/usb/gadget/mv_u3d_core.c b/drivers/usb/gadget/mv_u3d_core.c
index 07fdb3e..650847d 100644
--- a/drivers/usb/gadget/mv_u3d_core.c
+++ b/drivers/usb/gadget/mv_u3d_core.c
@@ -645,6 +645,7 @@ static int  mv_u3d_ep_disable(struct usb_ep *_ep)
 	struct mv_u3d_ep *ep;
 	struct mv_u3d_ep_context *ep_context;
 	u32 epxcr, direction;
+	unsigned long flags;
 
 	if (!_ep)
 		return -EINVAL;
@@ -661,7 +662,9 @@ static int  mv_u3d_ep_disable(struct usb_ep *_ep)
 	direction = mv_u3d_ep_dir(ep);
 
 	/* nuke all pending requests (does flush) */
+	spin_lock_irqsave(&u3d->lock, flags);
 	mv_u3d_nuke(ep, -ESHUTDOWN);
+	spin_unlock_irqrestore(&u3d->lock, flags);
 
 	/* Disable the endpoint for Rx or Tx and reset the endpoint type */
 	if (direction == MV_U3D_EP_DIR_OUT) {
-- 
1.8.1.2

