Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754762AbaKYL5k (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Nov 2014 06:57:40 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:58153 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752774AbaKYKko (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Nov 2014 05:40:44 -0500
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Oussama Ghorbel <ghorbel@pivasoftware.com>,
        Kishon Vijay Abraham I <kishon@ti.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.16.y-ckt 037/254] phy: omap-usb2: Enable runtime PM of omap-usb2 phy properly
Date: Tue, 25 Nov 2014 10:36:27 +0000
Message-Id: <1416912004-5928-38-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <1416912004-5928-1-git-send-email-luis.henriques@canonical.com>
References: <1416912004-5928-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.16
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.16.7-ckt2 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Oussama Ghorbel <ghorbel@pivasoftware.com>

commit f20531a9aae0c7378d9fa75b4b5d99b7eecab066 upstream.

The USB OTG port does not work since v3.16 on omap platform.
This is a regression introduced by the commit
eb82a3d846fa (phy: omap-usb2: Balance pm_runtime_enable() on probe failure
 and remove).
This because the call to pm_runtime_enable() function is moved after the
call to devm_phy_create() function, which has side effect since later in
the subsequent calls of devm_phy_create() there is a check with
pm_runtime_enabled() to configure few things.

Fixes: eb82a3d846fa
Signed-off-by: Oussama Ghorbel <ghorbel@pivasoftware.com>
Tested-by: Rabin Vincent <rabin@rab.in>
Signed-off-by: Kishon Vijay Abraham I <kishon@ti.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
[ luis: backported to 3.16: adjusted context ]
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 drivers/phy/phy-omap-usb2.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/phy/phy-omap-usb2.c b/drivers/phy/phy-omap-usb2.c
index 34b396146c8a..3fb92937f29b 100644
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
2.1.0

