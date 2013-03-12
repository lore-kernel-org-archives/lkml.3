Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932616Ab3CLLZX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Mar 2013 07:25:23 -0400
Received: from comal.ext.ti.com ([198.47.26.152]:52465 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932228Ab3CLLZT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Mar 2013 07:25:19 -0400
From: Roger Quadros <rogerq@ti.com>
To: <balbi@ti.com>
CC: <tony@atomide.com>, <mark.rutland@arm.com>, <mkl@pengutronix.de>,
        <linux-kernel@vger.kernel.org>, <linux-usb@vger.kernel.org>,
        <linux-omap@vger.kernel.org>, <devicetree-discuss@lists.ozlabs.org>,
        <rogerq@ti.com>
Subject: [PATCH 2/8] usb: phy: nop: use devm_kzalloc()
Date: Tue, 12 Mar 2013 13:24:20 +0200
Message-ID: <1363087466-32444-3-git-send-email-rogerq@ti.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1363087466-32444-1-git-send-email-rogerq@ti.com>
References: <1363087466-32444-1-git-send-email-rogerq@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use resource managed kzalloc.

Signed-off-by: Roger Quadros <rogerq@ti.com>
Acked-by: Felipe Balbi <balbi@ti.com>
---
 drivers/usb/otg/nop-usb-xceiv.c |   17 +++++------------
 1 files changed, 5 insertions(+), 12 deletions(-)

diff --git a/drivers/usb/otg/nop-usb-xceiv.c b/drivers/usb/otg/nop-usb-xceiv.c
index a3ce24b..af52870 100644
--- a/drivers/usb/otg/nop-usb-xceiv.c
+++ b/drivers/usb/otg/nop-usb-xceiv.c
@@ -100,15 +100,14 @@ static int nop_usb_xceiv_probe(struct platform_device *pdev)
 	enum usb_phy_type	type = USB_PHY_TYPE_USB2;
 	int err;
 
-	nop = kzalloc(sizeof *nop, GFP_KERNEL);
+	nop = devm_kzalloc(&pdev->dev, sizeof(*nop), GFP_KERNEL);
 	if (!nop)
 		return -ENOMEM;
 
-	nop->phy.otg = kzalloc(sizeof *nop->phy.otg, GFP_KERNEL);
-	if (!nop->phy.otg) {
-		kfree(nop);
+	nop->phy.otg = devm_kzalloc(&pdev->dev, sizeof(*nop->phy.otg),
+							GFP_KERNEL);
+	if (!nop->phy.otg)
 		return -ENOMEM;
-	}
 
 	if (pdata)
 		type = pdata->type;
@@ -127,7 +126,7 @@ static int nop_usb_xceiv_probe(struct platform_device *pdev)
 	if (err) {
 		dev_err(&pdev->dev, "can't register transceiver, err: %d\n",
 			err);
-		goto exit;
+		return err;
 	}
 
 	platform_set_drvdata(pdev, nop);
@@ -135,10 +134,6 @@ static int nop_usb_xceiv_probe(struct platform_device *pdev)
 	ATOMIC_INIT_NOTIFIER_HEAD(&nop->phy.notifier);
 
 	return 0;
-exit:
-	kfree(nop->phy.otg);
-	kfree(nop);
-	return err;
 }
 
 static int nop_usb_xceiv_remove(struct platform_device *pdev)
@@ -148,8 +143,6 @@ static int nop_usb_xceiv_remove(struct platform_device *pdev)
 	usb_remove_phy(&nop->phy);
 
 	platform_set_drvdata(pdev, NULL);
-	kfree(nop->phy.otg);
-	kfree(nop);
 
 	return 0;
 }
-- 
1.7.4.1

