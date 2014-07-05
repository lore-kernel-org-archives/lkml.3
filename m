Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760657AbaGEFq7 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 Jul 2014 01:46:59 -0400
Received: from seketeli.net ([94.23.218.202]:45919 "EHLO ms.seketeli.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760579AbaGEFq5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 Jul 2014 01:46:57 -0400
From: Apelete Seketeli <apelete@seketeli.net>
To: Felipe Balbi <balbi@ti.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-usb@vger.kernel.org
Cc: Lars-Peter Clausen <lars@metafoo.de>, linux-kernel@vger.kernel.org
Subject: [PATCH] usb: musb: register nop transceiver driver for jz4740
Date: Sat,  5 Jul 2014 07:47:25 +0200
Message-Id: <1404539245-9211-2-git-send-email-apelete@seketeli.net>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1404539245-9211-1-git-send-email-apelete@seketeli.net>
References: <1404539245-9211-1-git-send-email-apelete@seketeli.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Following the name change of the nop transceiver driver in commit
4525bee, make sure to register the transceiver driver before calling
usb_get_phy() to avoid issues related to accessing its data structure
while it was not registered.

Signed-off-by: Apelete Seketeli <apelete@seketeli.net>
---
 drivers/usb/musb/jz4740.c |    3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/usb/musb/jz4740.c b/drivers/usb/musb/jz4740.c
index 5f30537..d118729 100644
--- a/drivers/usb/musb/jz4740.c
+++ b/drivers/usb/musb/jz4740.c
@@ -19,6 +19,7 @@
 #include <linux/kernel.h>
 #include <linux/module.h>
 #include <linux/platform_device.h>
+#include <linux/usb/usb_phy_generic.h>
 
 #include "musb_core.h"
 
@@ -80,6 +81,7 @@ static struct musb_hdrc_platform_data jz4740_musb_platform_data = {
 
 static int jz4740_musb_init(struct musb *musb)
 {
+	usb_phy_generic_register();
 	musb->xceiv = usb_get_phy(USB_PHY_TYPE_USB2);
 	if (!musb->xceiv) {
 		pr_err("HS UDC: no transceiver configured\n");
@@ -182,6 +184,7 @@ static int jz4740_remove(struct platform_device *pdev)
 	struct jz4740_glue	*glue = platform_get_drvdata(pdev);
 
 	platform_device_unregister(glue->musb);
+	usb_phy_generic_unregister(pdev);
 	clk_disable_unprepare(glue->clk);
 
 	return 0;
-- 
1.7.10.4

