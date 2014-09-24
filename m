Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753740AbaIXQQ0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Sep 2014 12:16:26 -0400
Received: from mout.kundenserver.de ([212.227.17.10]:51618 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750802AbaIXQQZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Sep 2014 12:16:25 -0400
From: Oussama Ghorbel <ghorbel@pivasoftware.com>
To: Kishon Vijay Abraham I <kishon@ti.com>
Cc: linux-kernel@vger.kernel.org, Oussama Ghorbel <ghorbel@pivasoftware.com>
Subject: [PATCH] phy: omap-usb2: Enable runtime PM of omap-usb2 phy properly
Date: Wed, 24 Sep 2014 17:15:03 +0100
Message-Id: <1411575303-18858-1-git-send-email-ghorbel@pivasoftware.com>
X-Mailer: git-send-email 1.8.3.2
X-Provags-ID: V02:K0:qwpPepcFOa/UQ4VqilUexgkNo9wNu/80Sfj5bZw/hQ9
 +a+iR/1v+habJGDiXBSehAgNjHenvhcpAsnq+LT2bxWQiluJpn
 vgAqHBVmF3QSiK8clDP1bGYjqIsx9tdFFPluMzAg1nL34UXF1Y
 TcGnRZh+mNS9NgvaUjFshUpCgYHpV1vHhJdlGtqSEGkRWdNnMx
 z4zpy/s5rzpGmEY5cjsx2sf4yQd3XT92JgjdLJmfL7rV6DCPP3
 Jc886ISS6REwchT+cVI3O52M4lS+czCIm1YxbhJMpWhjojvVTx
 hfZ/LZql7sOyV0K1Bvzu/r77DPo/u2Z2tDWuB5vJ+ILy2bpWRH
 NSLSWg3Jt6bb2XDyuFlrl1+sfFrYCOEEsBoXMHAMxRhlOogNdE
 B0UdQY5+5HdGRDPQetceVjGFIVaR7+xmYs3ZIIbTGuIu1p95OJ
 wTUuw
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
index 34b3961..3fb9293 100644
--- a/drivers/phy/phy-omap-usb2.c
+++ b/drivers/phy/phy-omap-usb2.c
@@ -262,14 +262,16 @@ static int omap_usb2_probe(struct platform_device *pdev)
 	otg->phy		= &phy->phy;
 
 	platform_set_drvdata(pdev, phy);
+	pm_runtime_enable(phy->dev);
 
 	generic_phy = devm_phy_create(phy->dev, &ops, NULL);
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

