Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762559Ab3DCIsf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Apr 2013 04:48:35 -0400
Received: from mail-ee0-f44.google.com ([74.125.83.44]:34070 "EHLO
	mail-ee0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762515Ab3DCIsa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Apr 2013 04:48:30 -0400
From: Fabio Baltieri <fabio.baltieri@linaro.org>
To: Felipe Balbi <balbi@ti.com>
Cc: Linus Walleij <linus.walleij@linaro.org>,
        Praveena Nadahally <praveen.nadahally@stericsson.com>,
        linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org,
        Sakethram Bommisetti <sakethram.bommisetti@stericsson.com>,
        Fabio Baltieri <fabio.baltieri@linaro.org>
Subject: [PATCH 11/12] usb: phy: ab8500-usb: drop link status delayed work
Date: Wed,  3 Apr 2013 10:45:12 +0200
Message-Id: <1364978713-19612-12-git-send-email-fabio.baltieri@linaro.org>
X-Mailer: git-send-email 1.8.1.3
In-Reply-To: <1364978713-19612-1-git-send-email-fabio.baltieri@linaro.org>
References: <1364978713-19612-1-git-send-email-fabio.baltieri@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Sakethram Bommisetti <sakethram.bommisetti@stericsson.com>

ab8500_usb_delayed_work was implemented as a workaroud for the internal
only and now unsupported v1.0 version of AB850.  This patch removes the
delayed work and just leave a link status update call at probe time.

Signed-off-by: Sakethram Bommisetti <sakethram.bommisetti@stericsson.com>
Acked-by: Linus Walleij <linus.walleij@linaro.org>
Signed-off-by: Fabio Baltieri <fabio.baltieri@linaro.org>
---
 drivers/usb/phy/phy-ab8500-usb.c | 30 ++----------------------------
 1 file changed, 2 insertions(+), 28 deletions(-)

diff --git a/drivers/usb/phy/phy-ab8500-usb.c b/drivers/usb/phy/phy-ab8500-usb.c
index 0875e2b..30adfee 100644
--- a/drivers/usb/phy/phy-ab8500-usb.c
+++ b/drivers/usb/phy/phy-ab8500-usb.c
@@ -124,9 +124,7 @@ struct ab8500_usb {
 	struct device *dev;
 	struct ab8500 *ab8500;
 	unsigned vbus_draw;
-	struct delayed_work dwork;
 	struct work_struct phy_dis_work;
-	unsigned long link_status_wait;
 	enum ab8500_usb_mode mode;
 	struct regulator *v_ape;
 	struct regulator *v_musb;
@@ -556,14 +554,6 @@ static irqreturn_t ab8500_usb_link_status_irq(int irq, void *data)
 	return IRQ_HANDLED;
 }
 
-static void ab8500_usb_delayed_work(struct work_struct *work)
-{
-	struct ab8500_usb *ab = container_of(work, struct ab8500_usb,
-						dwork.work);
-
-	abx500_usb_link_status_update(ab);
-}
-
 static void ab8500_usb_phy_disable_work(struct work_struct *work)
 {
 	struct ab8500_usb *ab = container_of(work, struct ab8500_usb,
@@ -634,12 +624,6 @@ static int ab8500_usb_set_peripheral(struct usb_otg *otg,
 	} else {
 		otg->gadget = gadget;
 		otg->phy->state = OTG_STATE_B_IDLE;
-
-		/* Phy will not be enabled if cable is already
-		 * plugged-in. Schedule to enable phy.
-		 * Use same delay to avoid any race condition.
-		 */
-		schedule_delayed_work(&ab->dwork, ab->link_status_wait);
 	}
 
 	return 0;
@@ -664,11 +648,6 @@ static int ab8500_usb_set_host(struct usb_otg *otg, struct usb_bus *host)
 		schedule_work(&ab->phy_dis_work);
 	} else {
 		otg->host = host;
-		/* Phy will not be enabled if cable is already
-		 * plugged-in. Schedule to enable phy.
-		 * Use same delay to avoid any race condition.
-		 */
-		schedule_delayed_work(&ab->dwork, ab->link_status_wait);
 	}
 
 	return 0;
@@ -791,11 +770,6 @@ static int ab8500_usb_probe(struct platform_device *pdev)
 
 	ATOMIC_INIT_NOTIFIER_HEAD(&ab->phy.notifier);
 
-	/* v1: Wait for link status to become stable.
-	 * all: Updates form set_host and set_peripheral as they are atomic.
-	 */
-	INIT_DELAYED_WORK(&ab->dwork, ab8500_usb_delayed_work);
-
 	/* all: Disable phy when called from set_host and set_peripheral */
 	INIT_WORK(&ab->phy_dis_work, ab8500_usb_phy_disable_work);
 
@@ -892,6 +866,8 @@ static int ab8500_usb_probe(struct platform_device *pdev)
 	/* Needed to enable ID detection. */
 	ab8500_usb_wd_workaround(ab);
 
+	abx500_usb_link_status_update(ab);
+
 	dev_info(&pdev->dev, "revision 0x%2x driver initialized\n", rev);
 
 	return 0;
@@ -901,8 +877,6 @@ static int ab8500_usb_remove(struct platform_device *pdev)
 {
 	struct ab8500_usb *ab = platform_get_drvdata(pdev);
 
-	cancel_delayed_work_sync(&ab->dwork);
-
 	cancel_work_sync(&ab->phy_dis_work);
 
 	usb_remove_phy(&ab->phy);
-- 
1.8.1.3

