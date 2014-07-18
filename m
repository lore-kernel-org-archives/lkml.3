Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934357AbaGRJcN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jul 2014 05:32:13 -0400
Received: from mail.karo-electronics.de ([81.173.242.67]:56589 "EHLO
	mail.karo-electronics.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934026AbaGRJcJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jul 2014 05:32:09 -0400
From: =?UTF-8?q?Lothar=20Wa=C3=9Fmann?= <LW@KARO-electronics.de>
To: Felipe Balbi <balbi@ti.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        <linux-kernel@vger.kernel.org>, <linux-usb@vger.kernel.org>,
        Ezequiel Garcia <ezequiel@vanguardiasur.com.ar>,
        George Cherian <george.cherian@ti.com>,
        <linux-arm-kernel@lists.infradead.org>, Roger Quadros <rogerq@ti.com>
Cc: =?UTF-8?q?Lothar=20Wa=C3=9Fmann?= <LW@KARO-electronics.de>
Subject: [PATCH 6/9] usb: musb: core: properly setup the HW before registering it to the USB core
Date: Fri, 18 Jul 2014 11:31:27 +0200
Message-Id: <1405675890-8802-7-git-send-email-LW@KARO-electronics.de>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1405675890-8802-6-git-send-email-LW@KARO-electronics.de>
References: <1405675890-8802-1-git-send-email-LW@KARO-electronics.de>
 <1405675890-8802-2-git-send-email-LW@KARO-electronics.de>
 <1405675890-8802-3-git-send-email-LW@KARO-electronics.de>
 <1405675890-8802-4-git-send-email-LW@KARO-electronics.de>
 <1405675890-8802-5-git-send-email-LW@KARO-electronics.de>
 <1405675890-8802-6-git-send-email-LW@KARO-electronics.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Without this patch overriding the USBOTG_ID pin by setting the iddig
bit in the USB_MODE register doesn't work because it happens too late
to be recognized correctly.

Signed-off-by: Lothar Waßmann <LW@KARO-electronics.de>
---
 drivers/usb/musb/musb_core.c |   12 +++++++-----
 1 file changed, 7 insertions(+), 5 deletions(-)

diff --git a/drivers/usb/musb/musb_core.c b/drivers/usb/musb/musb_core.c
index f867b44..bbf2aefb 100644
--- a/drivers/usb/musb/musb_core.c
+++ b/drivers/usb/musb/musb_core.c
@@ -1988,18 +1988,21 @@ musb_init_controller(struct device *dev, int nIrq, void __iomem *ctrl)
 
 	switch (musb->port_mode) {
 	case MUSB_PORT_MODE_HOST:
-		status = musb_host_setup(musb, plat->power);
+		status = musb_platform_set_mode(musb, MUSB_HOST);
 		if (status < 0)
 			goto fail3;
-		status = musb_platform_set_mode(musb, MUSB_HOST);
+		status = musb_host_setup(musb, plat->power);
 		break;
 	case MUSB_PORT_MODE_GADGET:
-		status = musb_gadget_setup(musb);
+		status = musb_platform_set_mode(musb, MUSB_PERIPHERAL);
 		if (status < 0)
 			goto fail3;
-		status = musb_platform_set_mode(musb, MUSB_PERIPHERAL);
+		status = musb_gadget_setup(musb);
 		break;
 	case MUSB_PORT_MODE_DUAL_ROLE:
+		status = musb_platform_set_mode(musb, MUSB_OTG);
+		if (status < 0)
+			goto fail3;
 		status = musb_host_setup(musb, plat->power);
 		if (status < 0)
 			goto fail3;
@@ -2008,7 +2011,6 @@ musb_init_controller(struct device *dev, int nIrq, void __iomem *ctrl)
 			musb_host_cleanup(musb);
 			goto fail3;
 		}
-		status = musb_platform_set_mode(musb, MUSB_OTG);
 		break;
 	default:
 		dev_err(dev, "unsupported port mode %d\n", musb->port_mode);
-- 
1.7.10.4

