Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753250AbaCFO25 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Mar 2014 09:28:57 -0500
Received: from devils.ext.ti.com ([198.47.26.153]:58153 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752216AbaCFOYA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Mar 2014 09:24:00 -0500
From: Roger Quadros <rogerq@ti.com>
To: <kishon@ti.comg>, <tony@atomide.com>, <balbi@ti.com>
CC: <george.cherian@ti.com>, <balajitk@ti.com>, <hdegoede@redhat.com>,
        <linux-omap@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        <linux-kernel@vger.kernel.org>, <devicetree@vger.kernel.org>,
        <linux-usb@vger.kernel.org>, <linux-ide@vger.kernel.org>,
        <rogerq@ti.com>
Subject: [PATCH v2 06/13] phy: ti-pipe3: Don't get 'wkupclk' and 'refclk' for SATA PHY
Date: Thu, 6 Mar 2014 16:22:58 +0200
Message-ID: <1394115785-28301-7-git-send-email-rogerq@ti.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1394115785-28301-1-git-send-email-rogerq@ti.com>
References: <1394115785-28301-1-git-send-email-rogerq@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

SATA PHY doesn't need 'wkupclk; and 'refclk' so don't
try to get them for SATA PHY.

Signed-off-by: Roger Quadros <rogerq@ti.com>
---
 drivers/phy/phy-ti-pipe3.c | 24 +++++++++++++++---------
 1 file changed, 15 insertions(+), 9 deletions(-)

diff --git a/drivers/phy/phy-ti-pipe3.c b/drivers/phy/phy-ti-pipe3.c
index f141237..baa3f78d 100644
--- a/drivers/phy/phy-ti-pipe3.c
+++ b/drivers/phy/phy-ti-pipe3.c
@@ -294,16 +294,22 @@ static int ti_pipe3_probe(struct platform_device *pdev)
 
 	phy->dev		= &pdev->dev;
 
-	phy->wkupclk = devm_clk_get(phy->dev, "wkupclk");
-	if (IS_ERR(phy->wkupclk)) {
-		dev_err(&pdev->dev, "unable to get wkupclk\n");
-		return PTR_ERR(phy->wkupclk);
-	}
+	if (!of_device_is_compatible(node, "ti,phy-pipe3-sata")) {
+
+		phy->wkupclk = devm_clk_get(phy->dev, "wkupclk");
+		if (IS_ERR(phy->wkupclk)) {
+			dev_err(&pdev->dev, "unable to get wkupclk\n");
+			return PTR_ERR(phy->wkupclk);
+		}
 
-	phy->refclk = devm_clk_get(phy->dev, "refclk");
-	if (IS_ERR(phy->refclk)) {
-		dev_err(&pdev->dev, "unable to get refclk\n");
-		return PTR_ERR(phy->refclk);
+		phy->refclk = devm_clk_get(phy->dev, "refclk");
+		if (IS_ERR(phy->refclk)) {
+			dev_err(&pdev->dev, "unable to get refclk\n");
+			return PTR_ERR(phy->refclk);
+		}
+	} else {
+		phy->wkupclk = ERR_PTR(-ENODEV);
+		phy->refclk = ERR_PTR(-ENODEV);
 	}
 
 	phy->sys_clk = devm_clk_get(phy->dev, "sysclk");
-- 
1.8.3.2

