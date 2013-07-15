Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757027Ab3GOT4X (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Jul 2013 15:56:23 -0400
Received: from hqemgate04.nvidia.com ([216.228.121.35]:11129 "EHLO
	hqemgate04.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754841Ab3GOTyN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Jul 2013 15:54:13 -0400
X-PGP-Universal: processed;
	by hqnvupgp08.nvidia.com on Mon, 15 Jul 2013 12:53:24 -0700
From: Tuomas Tynkkynen <ttynkkynen@nvidia.com>
To: <balbi@ti.com>
CC: <linux-tegra@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-usb@vger.kernel.org>, <swarren@wwwdotorg.org>,
        <gregkh@linuxfoundation.org>, Tuomas Tynkkynen <ttynkkynen@nvidia.com>
Subject: [PATCH v2 5/9] usb: phy: tegra: Register as an USB PHY.
Date: Mon, 15 Jul 2013 22:53:45 +0300
Message-ID: <1373918029-28977-6-git-send-email-ttynkkynen@nvidia.com>
X-Mailer: git-send-email 1.8.1.5
In-Reply-To: <1373918029-28977-1-git-send-email-ttynkkynen@nvidia.com>
References: <1373918029-28977-1-git-send-email-ttynkkynen@nvidia.com>
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
 drivers/usb/phy/phy-tegra-usb.c | 17 +++++++++++++++++
 1 file changed, 17 insertions(+)

diff --git a/drivers/usb/phy/phy-tegra-usb.c b/drivers/usb/phy/phy-tegra-usb.c
index ddcac0b..8397206 100644
--- a/drivers/usb/phy/phy-tegra-usb.c
+++ b/drivers/usb/phy/phy-tegra-usb.c
@@ -931,6 +931,22 @@ static int tegra_usb_phy_probe(struct platform_device *pdev)
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
 
@@ -942,6 +958,7 @@ MODULE_DEVICE_TABLE(of, tegra_usb_phy_id_table);
 
 static struct platform_driver tegra_usb_phy_driver = {
 	.probe		= tegra_usb_phy_probe,
+	.remove		= tegra_usb_phy_remove,
 	.driver		= {
 		.name	= "tegra-phy",
 		.owner	= THIS_MODULE,
-- 
1.8.1.5

