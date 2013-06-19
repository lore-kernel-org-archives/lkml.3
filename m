Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934427Ab3FSL1A (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Jun 2013 07:27:00 -0400
Received: from moutng.kundenserver.de ([212.227.126.171]:51974 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934141Ab3FSL07 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Jun 2013 07:26:59 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Nicolas Ferre <nicolas.ferre@atmel.com>
Cc: Felipe Balbi <balbi@ti.com>, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-usb@vger.kernel.org
Subject: [PATCH] usb: gadget: at91_udc: call at91udc_of_init only when needed
Date: Wed, 19 Jun 2013 13:27:27 +0200
Message-ID: <6194333.jEShKk4GmN@wuerfel>
User-Agent: KMail/4.10.3 (Linux/3.9.0-2-generic; KDE/4.10.4; x86_64; ; )
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Provags-ID: V02:K0:tkrQmEwYRLw8e0g91BxmEkptIw2M5Y4Jeo7VZmf5L4P
 ELvj45sHHrR2+hu3RSEG6Hg/M9+5P6+8O1KsiYV481tPyfmSnQ
 37xPAcowqZD78Yg+WIp05QWqOxR0NG+cnZikHyydQkmv/Fqz+8
 uELfjpwRj8LTTWkpIalW3/QJNUckAlXYKtL98Epcdfv3imjsYk
 +A3WsVV/IUh5GckM+sIvsFlAaFEg+DeNkMnPBvK0RkiambGLST
 bSHP1OXhJEsBwbV0PbrArYG8EtDPTskLcheid0y6C0fbIhM0mg
 XN9gA6fnGIA2dhLhX1o41FWunpukRcGIZojfc1sxOgRLtWQ+l0
 X75DcWnZm/SutLkC02uU=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This avoids a build error in at91sam9261_9g10_defconfig:

drivers/usb/gadget/at91_udc.c: In function 'at91udc_probe':
drivers/usb/gadget/at91_udc.c:1685:34: warning: 'flags' may be used uninitialized in this
function [-Wmaybe-uninitialized]
  board->vbus_active_low = (flags & OF_GPIO_ACTIVE_LOW) ? 1 : 0;
                                  ^
drivers/usb/gadget/at91_udc.c:1678:21: note: 'flags' was declared here
  enum of_gpio_flags flags;
                     ^

Making the call to at91udc_of_init conditinal also reduces
the object code size without sacrificing build coverage.

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Cc: Felipe Balbi <balbi@ti.com>
Cc: Nicolas Ferre <nicolas.ferre@atmel.com>

diff --git a/drivers/usb/gadget/at91_udc.c b/drivers/usb/gadget/at91_udc.c
index 073b938..2cbab1c 100644
--- a/drivers/usb/gadget/at91_udc.c
+++ b/drivers/usb/gadget/at91_udc.c
@@ -1725,7 +1725,7 @@ static int at91udc_probe(struct platform_device *pdev)
 	/* init software state */
 	udc = &controller;
 	udc->gadget.dev.parent = dev;
-	if (pdev->dev.of_node)
+	if (IS_ENABLED(CONFIG_OF) && pdev->dev.of_node)
 		at91udc_of_init(udc, pdev->dev.of_node);
 	else
 		memcpy(&udc->board, dev->platform_data,

