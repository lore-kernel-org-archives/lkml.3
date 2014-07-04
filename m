Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759950AbaGDBP2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jul 2014 21:15:28 -0400
Received: from script.cs.helsinki.fi ([128.214.11.1]:54227 "EHLO
	script.cs.helsinki.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756228AbaGDBPW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jul 2014 21:15:22 -0400
X-DKIM: Courier DKIM Filter v0.50+pk-2014-03-23 mail.cs.helsinki.fi Fri, 04 Jul 2014 04:09:53 +0300
From: Tuomas Tynkkynen <ttynkkynen@nvidia.com>
To: Alan Stern <stern@rowland.harvard.edu>
Cc: Stephen Warren <swarren@wwwdotorg.org>,
        Thierry Reding <thierry.reding@gmail.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Felipe Balbi <balbi@ti.com>, linux-tegra@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-usb@vger.kernel.org, devicetree@vger.kernel.org,
        Tuomas Tynkkynen <ttynkkynen@nvidia.com>
Subject: [PATCH v2 4/4] USB: PHY: tegra: Call tegra_usb_phy_close only on device removal
Date: Fri,  4 Jul 2014 04:09:39 +0300
Message-Id: <1404436179-10745-5-git-send-email-ttynkkynen@nvidia.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1404436179-10745-1-git-send-email-ttynkkynen@nvidia.com>
References: <1404436179-10745-1-git-send-email-ttynkkynen@nvidia.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

tegra_usb_phy_close() is supposed to undo the effects of
tegra_usb_phy_init(). It is also currently added as the USB PHY shutdown
callback, which is wrong, since tegra_usb_phy_init() is only called
during probing wheras the shutdown callback can get called multiple
times. This then leads to warnings about unbalanced regulator_disable if
the EHCI driver is unbound and bound again at runtime.

Signed-off-by: Tuomas Tynkkynen <ttynkkynen@nvidia.com>
---
v2 changes: none
 drivers/usb/phy/phy-tegra-usb.c |    8 +++-----
 1 file changed, 3 insertions(+), 5 deletions(-)

diff --git a/drivers/usb/phy/phy-tegra-usb.c b/drivers/usb/phy/phy-tegra-usb.c
index bbe4f8e..72e04a9 100644
--- a/drivers/usb/phy/phy-tegra-usb.c
+++ b/drivers/usb/phy/phy-tegra-usb.c
@@ -686,10 +686,8 @@ static int ulpi_phy_power_off(struct tegra_usb_phy *phy)
 	return gpio_direction_output(phy->reset_gpio, 0);
 }
 
-static void tegra_usb_phy_close(struct usb_phy *x)
+static void tegra_usb_phy_close(struct tegra_usb_phy *phy)
 {
-	struct tegra_usb_phy *phy = container_of(x, struct tegra_usb_phy, u_phy);
-
 	if (!IS_ERR(phy->vbus))
 		regulator_disable(phy->vbus);
 
@@ -1061,14 +1059,13 @@ static int tegra_usb_phy_probe(struct platform_device *pdev)
 	if (err < 0)
 		return err;
 
-	tegra_phy->u_phy.shutdown = tegra_usb_phy_close;
 	tegra_phy->u_phy.set_suspend = tegra_usb_phy_suspend;
 
 	platform_set_drvdata(pdev, tegra_phy);
 
 	err = usb_add_phy_dev(&tegra_phy->u_phy);
 	if (err < 0) {
-		tegra_usb_phy_close(&tegra_phy->u_phy);
+		tegra_usb_phy_close(tegra_phy);
 		return err;
 	}
 
@@ -1080,6 +1077,7 @@ static int tegra_usb_phy_remove(struct platform_device *pdev)
 	struct tegra_usb_phy *tegra_phy = platform_get_drvdata(pdev);
 
 	usb_remove_phy(&tegra_phy->u_phy);
+	tegra_usb_phy_close(tegra_phy);
 
 	return 0;
 }
-- 
1.7.9.5

