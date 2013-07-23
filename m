Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933937Ab3GWSzX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Jul 2013 14:55:23 -0400
Received: from mail-pd0-f179.google.com ([209.85.192.179]:56619 "EHLO
	mail-pd0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933293Ab3GWSzW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Jul 2013 14:55:22 -0400
From: Olof Johansson <olof@lixom.net>
To: Felipe Balbi <balbi@ti.com>
Cc: linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org,
        Olof Johansson <olof@lixom.net>
Subject: [PATCH] usb: gadget: at91_udc: Check gpio lookup results
Date: Tue, 23 Jul 2013 11:55:50 -0700
Message-Id: <1374605750-29565-1-git-send-email-olof@lixom.net>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This resolves the following valid build warning:

drivers/usb/gadget/at91_udc.c:1685:34: warning: 'flags' may be used uninitialized in this function [-Wmaybe-uninitialized]

I switched from ? : to !! mostly to save from wrapping the lines while
I was at it.

Signed-off-by: Olof Johansson <olof@lixom.net>
---

Felipe, this would be nice to see fixed for 3.11 but I'd argue that it's
been here long enough to not really be needed for -stable.

 drivers/usb/gadget/at91_udc.c |   12 ++++++++++--
 1 file changed, 10 insertions(+), 2 deletions(-)

diff --git a/drivers/usb/gadget/at91_udc.c b/drivers/usb/gadget/at91_udc.c
index 073b938..f3dbcd0 100644
--- a/drivers/usb/gadget/at91_udc.c
+++ b/drivers/usb/gadget/at91_udc.c
@@ -1682,12 +1682,20 @@ static void at91udc_of_init(struct at91_udc *udc,
 
 	board->vbus_pin = of_get_named_gpio_flags(np, "atmel,vbus-gpio", 0,
 						  &flags);
-	board->vbus_active_low = (flags & OF_GPIO_ACTIVE_LOW) ? 1 : 0;
+	if (board->vbus_pin < 0)
+		pr_err("%s: Failed to get atmel,vbus-gpio property\n",
+		       np->full_name);
+	else
+		board->vbus_active_low = !!(flags & OF_GPIO_ACTIVE_LOW);
 
 	board->pullup_pin = of_get_named_gpio_flags(np, "atmel,pullup-gpio", 0,
 						  &flags);
 
-	board->pullup_active_low = (flags & OF_GPIO_ACTIVE_LOW) ? 1 : 0;
+	if (board->pullup_pin < 0)
+		pr_err("%s: Failed to get atmel,pullup-gpio property\n",
+		       np->full_name);
+	else
+		board->pullup_active_low = !!(flags & OF_GPIO_ACTIVE_LOW);
 }
 
 static int at91udc_probe(struct platform_device *pdev)
-- 
1.7.10.4

