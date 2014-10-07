Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753863AbaJGLEX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Oct 2014 07:04:23 -0400
Received: from mout.kundenserver.de ([212.227.17.24]:60757 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753395AbaJGLET (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Oct 2014 07:04:19 -0400
From: Oussama Ghorbel <ghorbel@pivasoftware.com>
To: Kishon Vijay Abraham I <kishon@ti.com>
Cc: Rabin Vincent <rabin@rab.in>, rogerq@ti.com, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Oussama Ghorbel <ghorbel@pivasoftware.com>
Subject: [PATCHv2] phy: omap-usb2: Enable runtime PM of omap-usb2 phy properly
Date: Tue,  7 Oct 2014 12:02:51 +0100
Message-Id: <1412679771-8293-1-git-send-email-ghorbel@pivasoftware.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <20141006194418.GA399@debian>
References: <20141006194418.GA399@debian>
X-Provags-ID: V02:K0:Fl4rCf9lH+fQwjX6O1UKWDYO/NEk2sBDKUjA/YuMNyl
 G6IsiHBxy150+Dd2Jqm5vAJJW5eBFy2yDaKKO7LDVvr1SPplXj
 5/Mhn+xJyUOwVakMDnOdKUQt2ulV0oD11INIZW/gPqPEk647Ia
 BSzwFs0vGzbgo1S07VKEoMqBIRkBTeNt/5sYhBLg8bdujCBVic
 ++CwgRvLCV4tDSOVdfFFV9kfdWQAjp13oSkifhG9bR7QKedfsT
 53BP1unuojK/QEP1zs2CQkGy7s6s6+nO7NVqe9PSnLtVg37VAM
 P2M/7PHiYPSAwirHh9ZcDoGP+0A9DdA/dq1AkJBFhlshP4U6P9
 iv6NSX3iSRYAsG+k7JQZjSB9InB/NDi/oJiMhf5iQkz0dr7GB4
 Yf2rzKg/vNPFKlTURiupXx0+lJyIfiEHNWvAB7m9SBe6stS6mB
 IfFt+
X-UI-Out-Filterresults: notjunk:1;
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The USB OTG port does not work since v3.16 on omap platform.
This is a regression introduced by the commit
eb82a3d846fa (phy: omap-usb2: Balance pm_runtime_enable() on probe failure
 and remove).
This because the call to pm_runtime_enable() function is moved after the
call to devm_phy_create() function, which has side effect since later in
the subsequent calls of devm_phy_create() there is a check with
pm_runtime_enabled() to configure few things.

Signed-off-by: Oussama Ghorbel <ghorbel@pivasoftware.com>
---
 drivers/phy/phy-omap-usb2.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/phy/phy-omap-usb2.c b/drivers/phy/phy-omap-usb2.c
index 93d7835..acc13f8 100644
--- a/drivers/phy/phy-omap-usb2.c
+++ b/drivers/phy/phy-omap-usb2.c
@@ -262,14 +262,16 @@ static int omap_usb2_probe(struct platform_device *pdev)
 	otg->phy		= &phy->phy;
 
 	platform_set_drvdata(pdev, phy);
+	pm_runtime_enable(phy->dev);
 
 	generic_phy = devm_phy_create(phy->dev, NULL, &ops, NULL);
-	if (IS_ERR(generic_phy))
+	if (IS_ERR(generic_phy)) {
+		pm_runtime_disable(phy->dev);
 		return PTR_ERR(generic_phy);
+	}
 
 	phy_set_drvdata(generic_phy, phy);
 
-	pm_runtime_enable(phy->dev);
 	phy_provider = devm_of_phy_provider_register(phy->dev,
 			of_phy_simple_xlate);
 	if (IS_ERR(phy_provider)) {
-- 
1.8.3.2

