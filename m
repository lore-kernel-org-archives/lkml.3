Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758128Ab3GYSlT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Jul 2013 14:41:19 -0400
Received: from hqemgate16.nvidia.com ([216.228.121.65]:11777 "EHLO
	hqemgate16.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757463Ab3GYSib (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Jul 2013 14:38:31 -0400
X-PGP-Universal: processed;
	by hqnvupgp07.nvidia.com on Thu, 25 Jul 2013 11:38:30 -0700
From: Tuomas Tynkkynen <ttynkkynen@nvidia.com>
To: <balbi@ti.com>
CC: <linux-tegra@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-usb@vger.kernel.org>, <swarren@wwwdotorg.org>,
        <gregkh@linuxfoundation.org>, Tuomas Tynkkynen <ttynkkynen@nvidia.com>
Subject: [PATCH v3 5/9] usb: phy: tegra: Register as an USB PHY.
Date: Thu, 25 Jul 2013 21:38:05 +0300
Message-ID: <1374777489-13093-6-git-send-email-ttynkkynen@nvidia.com>
X-Mailer: git-send-email 1.8.1.5
In-Reply-To: <1374777489-13093-1-git-send-email-ttynkkynen@nvidia.com>
References: <1374777489-13093-1-git-send-email-ttynkkynen@nvidia.com>
X-NVConfidentiality: public
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Register the Tegra PHY device instances with the PHY subsystem so that
the Tegra EHCI driver can locate a PHY via the standard APIs.

Signed-off-by: Tuomas Tynkkynen <ttynkkynen@nvidia.com>
Reviewed-by: Stephen Warren <swarren@nvidia.com>
Tested-by: Stephen Warren <swarren@nvidia.com>
---
v2 diff: Do the usb_add_phy_dev as the very last thing in .probe
 drivers/usb/phy/phy-tegra-usb.c | 17 +++++++++++++++++
 1 file changed, 17 insertions(+)

diff --git a/drivers/usb/phy/phy-tegra-usb.c b/drivers/usb/phy/phy-tegra-usb.c
index 311fe03..441c306 100644
--- a/drivers/usb/phy/phy-tegra-usb.c
+++ b/drivers/usb/phy/phy-tegra-usb.c
@@ -932,6 +932,22 @@ static int tegra_usb_phy_probe(struct platform_device *pdev)
 	tegra_phy->u_phy.set_suspend = tegra_usb_phy_suspend;
 
 	dev_set_drvdata(&pdev->dev, tegra_phy);
+
+	err = usb_add_phy_dev(&tegra_phy->u_phy);
+	if (err < 0) {
+		tegra_usb_phy_close(&tegra_phy->u_phy);
+		return err;
+	}
+
+	return 0;
+}
+
+static int tegra_usb_phy_remove(struct platform_device *pdev)
+{
+	struct tegra_usb_phy *tegra_phy = platform_get_drvdata(pdev);
+
+	usb_remove_phy(&tegra_phy->u_phy);
+
 	return 0;
 }
 
@@ -943,6 +959,7 @@ MODULE_DEVICE_TABLE(of, tegra_usb_phy_id_table);
 
 static struct platform_driver tegra_usb_phy_driver = {
 	.probe		= tegra_usb_phy_probe,
+	.remove		= tegra_usb_phy_remove,
 	.driver		= {
 		.name	= "tegra-phy",
 		.owner	= THIS_MODULE,
-- 
1.8.1.5

