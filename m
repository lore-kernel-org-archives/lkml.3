Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753034AbaFML2w (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Jun 2014 07:28:52 -0400
Received: from mailout3.samsung.com ([203.254.224.33]:51498 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751056AbaFML2u (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Jun 2014 07:28:50 -0400
X-AuditID: cbfee61a-b7fef6d00000200b-06-539ae070b506
From: Robert Baldyga <r.baldyga@samsung.com>
To: balbi@ti.com
Cc: gregkh@linuxfoundation.org, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org, m.szyprowski@samsung.com,
        andrzej.p@samsung.com, Robert Baldyga <r.baldyga@samsung.com>
Subject: [PATCH] usb: gadget: composite: unlock spinlock before
 usb_gadget_disconnect()
Date: Fri, 13 Jun 2014 13:28:13 +0200
Message-id: <1402658893-4809-1-git-send-email-r.baldyga@samsung.com>
X-Mailer: git-send-email 1.9.1
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrKJMWRmVeSWpSXmKPExsVy+t9jQd2CB7OCDVrfKFvMetnOYnHwfr1F
	8+L1bBaXd81hs1i0rJXZYu2Ru+wWDw7vZHdg99g/dw27R9+WVYwex29sZ/L4vEkugCWKyyYl
	NSezLLVI3y6BK+PDA7eCFRwV604tZG1g7GHvYuTkkBAwkVhxrYENwhaTuHBvPZDNxSEkMJ1R
	oq/1CwuE084ksfvcH1aQKjYBHYkt3ycwgtgiAgIS619cYgcpYhbYwijR/AiiSFggUmL1qc9M
	XYwcHCwCqhIrOtxAwrwCLhIP93yD2iYncfLYZNYJjNwLGBlWMYqmFiQXFCel5xrqFSfmFpfm
	pesl5+duYgQHxjOpHYwrGywOMQpwMCrx8K74ODNYiDWxrLgy9xCjBAezkgjvvYZZwUK8KYmV
	ValF+fFFpTmpxYcYpTlYlMR5D7RaBwoJpCeWpGanphakFsFkmTg4pRoYd05T37t9Y7F8bOff
	V0cEc9Yxm0ioPrbz2s5oGmbs19ExZ8bsLWUFVRZR9kdPRH8uvD9h+7ndntKPPk/XD/0cv6Ol
	WHfuSv6lS7w5z7OsuSyuWe3Q2vjxozhfwUOOPf/ezO9/ljt3Q7vqtnkM0scT1Q/v2u3bEf3S
	dvUC1n3mKp9fM7V53AkOVWIpzkg01GIuKk4EACwCWXAIAgAA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

usb_gadget_disconnect() shouldn't be called under spinlock to avoid
spinlock recursion. Function usb_gadget_disconnect() calls pullup(),
which is callback from UDC driver, usually calling composite_disconnect().
This function wants to lock spinlock used in usb_function_deactivate()
causing spinlock recursion.

Signed-off-by: Robert Baldyga <r.baldyga@samsung.com>
---
 drivers/usb/gadget/composite.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/usb/gadget/composite.c b/drivers/usb/gadget/composite.c
index d41103e..77cae4b 100644
--- a/drivers/usb/gadget/composite.c
+++ b/drivers/usb/gadget/composite.c
@@ -260,8 +260,11 @@ int usb_function_deactivate(struct usb_function *function)
 
 	spin_lock_irqsave(&cdev->lock, flags);
 
-	if (cdev->deactivations == 0)
+	if (cdev->deactivations == 0) {
+		spin_unlock_irqrestore(&cdev->lock, flags);
 		status = usb_gadget_disconnect(cdev->gadget);
+		spin_lock_irqsave(&cdev->lock, flags);
+	}
 	if (status == 0)
 		cdev->deactivations++;
 
-- 
1.9.1

