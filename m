Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932200Ab3DCIqp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Apr 2013 04:46:45 -0400
Received: from mail-ea0-f171.google.com ([209.85.215.171]:51859 "EHLO
	mail-ea0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762277Ab3DCIqk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Apr 2013 04:46:40 -0400
From: Fabio Baltieri <fabio.baltieri@linaro.org>
To: Felipe Balbi <balbi@ti.com>
Cc: Linus Walleij <linus.walleij@linaro.org>,
        Praveena Nadahally <praveen.nadahally@stericsson.com>,
        linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org,
        Fabio Baltieri <fabio.baltieri@linaro.org>
Subject: [PATCH 02/12] usb: phy: ab8500-usb: convert to devm_kzalloc
Date: Wed,  3 Apr 2013 10:45:03 +0200
Message-Id: <1364978713-19612-3-git-send-email-fabio.baltieri@linaro.org>
X-Mailer: git-send-email 1.8.1.3
In-Reply-To: <1364978713-19612-1-git-send-email-fabio.baltieri@linaro.org>
References: <1364978713-19612-1-git-send-email-fabio.baltieri@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Convert local data allocation to devm_kzalloc and drop unnecessary fail
path code.

Acked-by: Linus Walleij <linus.walleij@linaro.org>
Signed-off-by: Fabio Baltieri <fabio.baltieri@linaro.org>
---
 drivers/usb/phy/phy-ab8500-usb.c | 19 +++++--------------
 1 file changed, 5 insertions(+), 14 deletions(-)

diff --git a/drivers/usb/phy/phy-ab8500-usb.c b/drivers/usb/phy/phy-ab8500-usb.c
index 351b036..ab6dd07 100644
--- a/drivers/usb/phy/phy-ab8500-usb.c
+++ b/drivers/usb/phy/phy-ab8500-usb.c
@@ -628,15 +628,13 @@ static int ab8500_usb_probe(struct platform_device *pdev)
 		return -ENODEV;
 	}
 
-	ab = kzalloc(sizeof *ab, GFP_KERNEL);
+	ab = devm_kzalloc(&pdev->dev, sizeof(*ab), GFP_KERNEL);
 	if (!ab)
 		return -ENOMEM;
 
-	otg = kzalloc(sizeof *otg, GFP_KERNEL);
-	if (!otg) {
-		kfree(ab);
+	otg = devm_kzalloc(&pdev->dev, sizeof(*otg), GFP_KERNEL);
+	if (!otg)
 		return -ENOMEM;
-	}
 
 	ab->dev			= &pdev->dev;
 	ab->ab8500		= ab8500;
@@ -665,12 +663,12 @@ static int ab8500_usb_probe(struct platform_device *pdev)
 
 	err = ab8500_usb_irq_setup(pdev, ab);
 	if (err < 0)
-		goto fail;
+		return err;
 
 	err = usb_add_phy(&ab->phy, USB_PHY_TYPE_USB2);
 	if (err) {
 		dev_err(&pdev->dev, "Can't register transceiver\n");
-		goto fail;
+		return err;
 	}
 
 	/* Needed to enable ID detection. */
@@ -679,10 +677,6 @@ static int ab8500_usb_probe(struct platform_device *pdev)
 	dev_info(&pdev->dev, "revision 0x%2x driver initialized\n", rev);
 
 	return 0;
-fail:
-	kfree(otg);
-	kfree(ab);
-	return err;
 }
 
 static int ab8500_usb_remove(struct platform_device *pdev)
@@ -700,9 +694,6 @@ static int ab8500_usb_remove(struct platform_device *pdev)
 
 	platform_set_drvdata(pdev, NULL);
 
-	kfree(ab->phy.otg);
-	kfree(ab);
-
 	return 0;
 }
 
-- 
1.8.1.3

