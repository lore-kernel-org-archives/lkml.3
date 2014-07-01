Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756429AbaGAVJ2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Jul 2014 17:09:28 -0400
Received: from hqemgate14.nvidia.com ([216.228.121.143]:1770 "EHLO
	hqemgate14.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756003AbaGAVJG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Jul 2014 17:09:06 -0400
X-PGP-Universal: processed;
	by hqnvupgp08.nvidia.com on Tue, 01 Jul 2014 14:02:35 -0700
From: Tuomas Tynkkynen <ttynkkynen@nvidia.com>
To: Alan Stern <stern@rowland.harvard.edu>
CC: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Stephen Warren <swarren@wwwdotorg.org>, Felipe Balbi <balbi@ti.com>,
        Philipp Zabel <p.zabel@pengutronix.de>, <linux-usb@vger.kernel.org>,
        <linux-tegra@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <tuomas.tynkkynen@iki.fi>, Tuomas Tynkkynen <ttynkkynen@nvidia.com>
Subject: [PATCH 3/3] USB: PHY: tegra: Call tegra_usb_phy_close only on device removal
Date: Wed, 2 Jul 2014 00:08:43 +0300
Message-ID: <1404248923-21086-4-git-send-email-ttynkkynen@nvidia.com>
X-Mailer: git-send-email 1.8.1.5
In-Reply-To: <1404248923-21086-1-git-send-email-ttynkkynen@nvidia.com>
References: <1404248923-21086-1-git-send-email-ttynkkynen@nvidia.com>
X-NVConfidentiality: public
MIME-Version: 1.0
Content-Type: text/plain
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
 drivers/usb/phy/phy-tegra-usb.c | 8 +++-----
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
1.8.1.5

