Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752913Ab3F1Vid (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Jun 2013 17:38:33 -0400
Received: from hqemgate04.nvidia.com ([216.228.121.35]:13554 "EHLO
	hqemgate04.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752720Ab3F1ViI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Jun 2013 17:38:08 -0400
X-PGP-Universal: processed;
	by hqnvupgp08.nvidia.com on Fri, 28 Jun 2013 14:37:57 -0700
From: Tuomas Tynkkynen <ttynkkynen@nvidia.com>
To: <balbi@ti.com>
CC: <linux-tegra@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-usb@vger.kernel.org>, <swarren@wwwdotorg.org>,
        <gregkh@linuxfoundation.org>, Tuomas Tynkkynen <ttynkkynen@nvidia.com>
Subject: [PATCH 5/9] usb: phy: tegra: Register as an USB PHY.
Date: Sat, 29 Jun 2013 00:37:03 +0300
Message-ID: <1372455427-20898-6-git-send-email-ttynkkynen@nvidia.com>
X-Mailer: git-send-email 1.8.1.5
In-Reply-To: <1372455427-20898-1-git-send-email-ttynkkynen@nvidia.com>
References: <1372455427-20898-1-git-send-email-ttynkkynen@nvidia.com>
X-NVConfidentiality: public
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Register the Tegra PHY device instances with the PHY subsystem so that
the Tegra EHCI driver can locate a PHY via the standard APIs.

Signed-off-by: Tuomas Tynkkynen <ttynkkynen@nvidia.com>
---
 drivers/usb/phy/phy-tegra-usb.c | 15 +++++++++++++++
 1 file changed, 15 insertions(+)

diff --git a/drivers/usb/phy/phy-tegra-usb.c b/drivers/usb/phy/phy-tegra-usb.c
index ddcac0b..b81310d 100644
--- a/drivers/usb/phy/phy-tegra-usb.c
+++ b/drivers/usb/phy/phy-tegra-usb.c
@@ -927,6 +927,12 @@ static int tegra_usb_phy_probe(struct platform_device *pdev)
 	if (err < 0)
 		return err;
 
+	err = usb_add_phy_dev(&tegra_phy->u_phy);
+	if (err < 0) {
+		tegra_usb_phy_close(&tegra_phy->u_phy);
+		return err;
+	}
+
 	tegra_phy->u_phy.shutdown = tegra_usb_phy_close;
 	tegra_phy->u_phy.set_suspend = tegra_usb_phy_suspend;
 
@@ -934,6 +940,14 @@ static int tegra_usb_phy_probe(struct platform_device *pdev)
 	return 0;
 }
 
+static int tegra_usb_phy_remove(struct platform_device *pdev)
+{
+	struct tegra_usb_phy *tegra_phy = platform_get_drvdata(pdev);
+
+	usb_remove_phy(&tegra_phy->u_phy);
+	return 0;
+}
+
 static struct of_device_id tegra_usb_phy_id_table[] = {
 	{ .compatible = "nvidia,tegra20-usb-phy", },
 	{ },
@@ -942,6 +956,7 @@ MODULE_DEVICE_TABLE(of, tegra_usb_phy_id_table);
 
 static struct platform_driver tegra_usb_phy_driver = {
 	.probe		= tegra_usb_phy_probe,
+	.remove		= tegra_usb_phy_remove,
 	.driver		= {
 		.name	= "tegra-phy",
 		.owner	= THIS_MODULE,
-- 
1.8.1.5

