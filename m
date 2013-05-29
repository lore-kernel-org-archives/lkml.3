Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S967045Ab3E2UwD (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 May 2013 16:52:03 -0400
Received: from mail.ispras.ru ([83.149.199.45]:40530 "EHLO mail.ispras.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S966896Ab3E2Uv4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 May 2013 16:51:56 -0400
From: Alexey Khoroshilov <khoroshilov@ispras.ru>
To: Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>,
        Felipe Balbi <balbi@ti.com>
Cc: Alexey Khoroshilov <khoroshilov@ispras.ru>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org,
        ldv-project@linuxtesting.org
Subject: [PATCH] usb: gadget: r8a66597-udc: do not unlock unheld spinlock in r8a66597_sudmac_irq()
Date: Thu, 30 May 2013 00:51:37 +0400
Message-Id: <1369860697-17362-1-git-send-email-khoroshilov@ispras.ru>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

r8a66597_irq() processes sudmac part (r8a66597_sudmac_irq()) before locking r8a66597->lock.
But transfer_complete(), that is called inside (r8a66597_sudmac_irq()->sudmac_finish()->transfer_complete()),
expects r8a66597->lock is locked. As a result unheld spinlock can be unlocked.

The patch just moves locking before calling r8a66597_sudmac_irq().

Found by Linux Driver Verification project (linuxtesting.org).

Signed-off-by: Alexey Khoroshilov <khoroshilov@ispras.ru>
---
 drivers/usb/gadget/r8a66597-udc.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/usb/gadget/r8a66597-udc.c b/drivers/usb/gadget/r8a66597-udc.c
index 7ff7d9c..2dd213c 100644
--- a/drivers/usb/gadget/r8a66597-udc.c
+++ b/drivers/usb/gadget/r8a66597-udc.c
@@ -1469,11 +1469,11 @@ static irqreturn_t r8a66597_irq(int irq, void *_r8a66597)
 	u16 savepipe;
 	u16 mask0;
 
+	spin_lock(&r8a66597->lock);
+
 	if (r8a66597_is_sudmac(r8a66597))
 		r8a66597_sudmac_irq(r8a66597);
 
-	spin_lock(&r8a66597->lock);
-
 	intsts0 = r8a66597_read(r8a66597, INTSTS0);
 	intenb0 = r8a66597_read(r8a66597, INTENB0);
 
-- 
1.7.9.5

