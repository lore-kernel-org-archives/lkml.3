Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762434Ab3DCIsJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Apr 2013 04:48:09 -0400
Received: from mail-ea0-f176.google.com ([209.85.215.176]:40940 "EHLO
	mail-ea0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762384Ab3DCIsH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Apr 2013 04:48:07 -0400
From: Fabio Baltieri <fabio.baltieri@linaro.org>
To: Felipe Balbi <balbi@ti.com>
Cc: Linus Walleij <linus.walleij@linaro.org>,
        Praveena Nadahally <praveen.nadahally@stericsson.com>,
        linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org,
        Fabio Baltieri <fabio.baltieri@linaro.org>
Subject: [PATCH 09/12] usb: phy: ab8500-usb: fix last notifier arguments
Date: Wed,  3 Apr 2013 10:45:10 +0200
Message-Id: <1364978713-19612-10-git-send-email-fabio.baltieri@linaro.org>
X-Mailer: git-send-email 1.8.1.3
In-Reply-To: <1364978713-19612-1-git-send-email-fabio.baltieri@linaro.org>
References: <1364978713-19612-1-git-send-email-fabio.baltieri@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix last ab->phy.notifier call to use vbus_draw as notifier argument, as
that's used in ab8500_charger to control charging current.

Also drop a related TODO comment, and the additional
ux500_musb_set_vbus(musb, 0), as with this patch it was causing an
erratic behaviour of gadget ep0 state machine.

Acked-by: Linus Walleij <linus.walleij@linaro.org>
Signed-off-by: Fabio Baltieri <fabio.baltieri@linaro.org>
---
 drivers/usb/musb/ux500.c         |  1 -
 drivers/usb/phy/phy-ab8500-usb.c | 10 +++-------
 2 files changed, 3 insertions(+), 8 deletions(-)

diff --git a/drivers/usb/musb/ux500.c b/drivers/usb/musb/ux500.c
index 88795f5..2c80004 100644
--- a/drivers/usb/musb/ux500.c
+++ b/drivers/usb/musb/ux500.c
@@ -114,7 +114,6 @@ static int musb_otg_notifications(struct notifier_block *nb,
 		break;
 	case UX500_MUSB_VBUS:
 		dev_dbg(musb->controller, "VBUS Connect\n");
-		ux500_musb_set_vbus(musb, 0);
 		break;
 	case UX500_MUSB_NONE:
 		dev_dbg(musb->controller, "VBUS Disconnect\n");
diff --git a/drivers/usb/phy/phy-ab8500-usb.c b/drivers/usb/phy/phy-ab8500-usb.c
index b7f6639..ff27058 100644
--- a/drivers/usb/phy/phy-ab8500-usb.c
+++ b/drivers/usb/phy/phy-ab8500-usb.c
@@ -577,16 +577,12 @@ static int ab8500_usb_set_power(struct usb_phy *phy, unsigned mA)
 
 	ab->vbus_draw = mA;
 
-	if (mA)
-		atomic_notifier_call_chain(&ab->phy.notifier,
-				UX500_MUSB_ENUMERATED, ab->phy.otg->gadget);
+	atomic_notifier_call_chain(&ab->phy.notifier,
+			UX500_MUSB_VBUS, &ab->vbus_draw);
+
 	return 0;
 }
 
-/* TODO: Implement some way for charging or other drivers to read
- * ab->vbus_draw.
- */
-
 static int ab8500_usb_set_suspend(struct usb_phy *x, int suspend)
 {
 	/* TODO */
-- 
1.8.1.3

