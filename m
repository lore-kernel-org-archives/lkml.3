Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762605Ab3DCIsr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Apr 2013 04:48:47 -0400
Received: from mail-ea0-f169.google.com ([209.85.215.169]:33190 "EHLO
	mail-ea0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762574Ab3DCIsm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Apr 2013 04:48:42 -0400
From: Fabio Baltieri <fabio.baltieri@linaro.org>
To: Felipe Balbi <balbi@ti.com>
Cc: Linus Walleij <linus.walleij@linaro.org>,
        Praveena Nadahally <praveen.nadahally@stericsson.com>,
        linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org,
        Sakethram Bommisetti <sakethram.bommisetti@stericsson.com>,
        Fabio Baltieri <fabio.baltieri@linaro.org>
Subject: [PATCH 12/12] usb: phy: ab8500-usb: call phy_dis_work only when necessary
Date: Wed,  3 Apr 2013 10:45:13 +0200
Message-Id: <1364978713-19612-13-git-send-email-fabio.baltieri@linaro.org>
X-Mailer: git-send-email 1.8.1.3
In-Reply-To: <1364978713-19612-1-git-send-email-fabio.baltieri@linaro.org>
References: <1364978713-19612-1-git-send-email-fabio.baltieri@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Sakethram Bommisetti <sakethram.bommisetti@stericsson.com>

Modify ab8500_usb_set_peripheral() and ab8500_usb_set_host() code to
schedule phy_dis_work only when necessary in order to prevent regulator
count mismatch during reboot/shutdown.

Signed-off-by: Sakethram Bommisetti <sakethram.bommisetti@stericsson.com>
Acked-by: Linus Walleij <linus.walleij@linaro.org>
Signed-off-by: Fabio Baltieri <fabio.baltieri@linaro.org>
---
 drivers/usb/phy/phy-ab8500-usb.c | 17 ++++++++---------
 1 file changed, 8 insertions(+), 9 deletions(-)

diff --git a/drivers/usb/phy/phy-ab8500-usb.c b/drivers/usb/phy/phy-ab8500-usb.c
index 30adfee..81d1a5a 100644
--- a/drivers/usb/phy/phy-ab8500-usb.c
+++ b/drivers/usb/phy/phy-ab8500-usb.c
@@ -613,17 +613,16 @@ static int ab8500_usb_set_peripheral(struct usb_otg *otg,
 
 	ab = phy_to_ab(otg->phy);
 
+	ab->phy.otg->gadget = gadget;
+
 	/* Some drivers call this function in atomic context.
 	 * Do not update ab8500 registers directly till this
 	 * is fixed.
 	 */
 
-	if (!gadget) {
-		otg->gadget = NULL;
+	if ((ab->mode != USB_IDLE) && (!gadget)) {
+		ab->mode = USB_IDLE;
 		schedule_work(&ab->phy_dis_work);
-	} else {
-		otg->gadget = gadget;
-		otg->phy->state = OTG_STATE_B_IDLE;
 	}
 
 	return 0;
@@ -638,16 +637,16 @@ static int ab8500_usb_set_host(struct usb_otg *otg, struct usb_bus *host)
 
 	ab = phy_to_ab(otg->phy);
 
+	ab->phy.otg->host = host;
+
 	/* Some drivers call this function in atomic context.
 	 * Do not update ab8500 registers directly till this
 	 * is fixed.
 	 */
 
-	if (!host) {
-		otg->host = NULL;
+	if ((ab->mode != USB_IDLE) && (!host)) {
+		ab->mode = USB_IDLE;
 		schedule_work(&ab->phy_dis_work);
-	} else {
-		otg->host = host;
 	}
 
 	return 0;
-- 
1.8.1.3

