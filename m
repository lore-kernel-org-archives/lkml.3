Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753073AbaEZPVF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 May 2014 11:21:05 -0400
Received: from isis.lip6.fr ([132.227.60.2]:57278 "EHLO isis.lip6.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753030AbaEZPVA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 May 2014 11:21:00 -0400
X-pt: isis.lip6.fr
From: Benoit Taine <benoit.taine@lip6.fr>
To: Felipe Balbi <balbi@ti.com>
Cc: benoit.taine@lip6.fr, Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org,
        kernel-janitors@vger.kernel.org
Subject: [PATCH 11/18] usb: gadget: Use kmemdup instead of kmalloc + memcpy
Date: Mon, 26 May 2014 17:21:20 +0200
Message-Id: <1401117687-28911-12-git-send-email-benoit.taine@lip6.fr>
X-Mailer: git-send-email 1.9.3
In-Reply-To: <1401117687-28911-1-git-send-email-benoit.taine@lip6.fr>
References: <1401117687-28911-1-git-send-email-benoit.taine@lip6.fr>
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.4.3 (isis.lip6.fr [132.227.60.2]); Mon, 26 May 2014 17:20:42 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This issue was reported by coccicheck using the semantic patch 
at scripts/coccinelle/api/memdup.cocci

Signed-off-by: Benoit Taine <benoit.taine@lip6.fr>
---
Tested by compilation without errors.

 drivers/usb/gadget/configfs.c    |    4 +---
 drivers/usb/gadget/lpc32xx_udc.c |    3 +--
 2 files changed, 2 insertions(+), 5 deletions(-)

diff --git a/drivers/usb/gadget/configfs.c b/drivers/usb/gadget/configfs.c
index 2ddcd63..bcc2a62 100644
--- a/drivers/usb/gadget/configfs.c
+++ b/drivers/usb/gadget/configfs.c
@@ -1021,12 +1021,10 @@ static ssize_t ext_prop_data_store(struct usb_os_desc_ext_prop *ext_prop,
 
 	if (page[len - 1] == '\n' || page[len - 1] == '\0')
 		--len;
-	new_data = kzalloc(len, GFP_KERNEL);
+	new_data = kmemdup(page, len, GFP_KERNEL);
 	if (!new_data)
 		return -ENOMEM;
 
-	memcpy(new_data, page, len);
-
 	if (desc->opts_mutex)
 		mutex_lock(desc->opts_mutex);
 	kfree(ext_prop->data);
diff --git a/drivers/usb/gadget/lpc32xx_udc.c b/drivers/usb/gadget/lpc32xx_udc.c
index e471580..0588231 100644
--- a/drivers/usb/gadget/lpc32xx_udc.c
+++ b/drivers/usb/gadget/lpc32xx_udc.c
@@ -3045,11 +3045,10 @@ static int __init lpc32xx_udc_probe(struct platform_device *pdev)
 	dma_addr_t dma_handle;
 	struct device_node *isp1301_node;
 
-	udc = kzalloc(sizeof(*udc), GFP_KERNEL);
+	udc = kmemdup(&controller_template, sizeof(*udc), GFP_KERNEL);
 	if (!udc)
 		return -ENOMEM;
 
-	memcpy(udc, &controller_template, sizeof(*udc));
 	for (i = 0; i <= 15; i++)
 		udc->ep[i].udc = udc;
 	udc->gadget.ep0 = &udc->ep[0].ep;

