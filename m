Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932154AbaGULhn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jul 2014 07:37:43 -0400
Received: from mail-we0-f179.google.com ([74.125.82.179]:41714 "EHLO
	mail-we0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754157AbaGULhl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jul 2014 07:37:41 -0400
From: Thierry Reding <thierry.reding@gmail.com>
To: Felipe Balbi <balbi@ti.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, linux-usb@vger.kernel.org,
        linux-tegra@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] usb: phy: tegra: Avoid use of sizeof(void)
Date: Mon, 21 Jul 2014 13:37:37 +0200
Message-Id: <1405942657-2080-1-git-send-email-thierry.reding@gmail.com>
X-Mailer: git-send-email 2.0.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Thierry Reding <treding@nvidia.com>

The PHY configuration is stored in an opaque "config" field, but when
allocating the structure, its proper size needs to be known. In the case
of UTMI, the proper structure is tegra_utmip_config of which a local
variable already exists, so we can use that to obtain the size from.

Fixes the following warning from the sparse checker:

	drivers/usb/phy/phy-tegra-usb.c:882:17: warning: expression using sizeof(void)

Fixes: 81d5dfe6d8b3 (usb: phy: tegra: Read UTMIP parameters from device tree)
Cc: stable@vger.kernel.org
Signed-off-by: Thierry Reding <treding@nvidia.com>
---
 drivers/usb/phy/phy-tegra-usb.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/usb/phy/phy-tegra-usb.c b/drivers/usb/phy/phy-tegra-usb.c
index 13b4fa287da8..886f1807a67b 100644
--- a/drivers/usb/phy/phy-tegra-usb.c
+++ b/drivers/usb/phy/phy-tegra-usb.c
@@ -878,8 +878,8 @@ static int utmi_phy_probe(struct tegra_usb_phy *tegra_phy,
 		return -ENOMEM;
 	}
 
-	tegra_phy->config = devm_kzalloc(&pdev->dev,
-		sizeof(*tegra_phy->config), GFP_KERNEL);
+	tegra_phy->config = devm_kzalloc(&pdev->dev, sizeof(*config),
+					 GFP_KERNEL);
 	if (!tegra_phy->config) {
 		dev_err(&pdev->dev,
 			"unable to allocate memory for USB UTMIP config\n");
-- 
2.0.1

