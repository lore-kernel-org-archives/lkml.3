Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753484Ab3CRMeA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Mar 2013 08:34:00 -0400
Received: from hqemgate03.nvidia.com ([216.228.121.140]:6477 "EHLO
	hqemgate03.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753341Ab3CRMdy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Mar 2013 08:33:54 -0400
X-PGP-Universal: processed;
	by hqnvupgp07.nvidia.com on Mon, 18 Mar 2013 05:33:45 -0700
From: Venu Byravarasu <vbyravarasu@nvidia.com>
To: <gregkh@linuxfoundation.org>, <stern@rowland.harvard.edu>, <balbi@ti.com>
CC: <linux-usb@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <swarren@wwwdotorg.org>, <linux-tegra@vger.kernel.org>,
        <devicetree-discuss@lists.ozlabs.org>,
        Venu Byravarasu <vbyravarasu@nvidia.com>
Subject: [PATCH 6/7] usb: phy: tegra: Add error handling & clean up.
Date: Mon, 18 Mar 2013 17:59:40 +0530
Message-ID: <1363609781-4045-7-git-send-email-vbyravarasu@nvidia.com>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <1363609781-4045-1-git-send-email-vbyravarasu@nvidia.com>
References: <1363609781-4045-1-git-send-email-vbyravarasu@nvidia.com>
X-NVConfidentiality: public
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Check return values from all GPIO APIs and handle errors accordingly.
Remove clk_disable_unprepare which is no more needed.

Signed-off-by: Venu Byravarasu <vbyravarasu@nvidia.com>
---
 drivers/usb/phy/tegra_usb_phy.c |   50 ++++++++++++++++++++++++++++++--------
 1 files changed, 39 insertions(+), 11 deletions(-)

diff --git a/drivers/usb/phy/tegra_usb_phy.c b/drivers/usb/phy/tegra_usb_phy.c
index 29c5ac4..7ead114 100644
--- a/drivers/usb/phy/tegra_usb_phy.c
+++ b/drivers/usb/phy/tegra_usb_phy.c
@@ -542,9 +542,17 @@ static int ulpi_phy_power_on(struct tegra_usb_phy *phy)
 	unsigned long val;
 	void __iomem *base = phy->regs;
 
-	gpio_direction_output(phy->reset_gpio, 0);
+	ret = gpio_direction_output(phy->reset_gpio, 0);
+	if (ret < 0) {
+		dev_err(phy->dev, "gpio %d direction not set\n", phy->reset_gpio);
+		return ret;
+	}
 	msleep(5);
-	gpio_direction_output(phy->reset_gpio, 1);
+	ret = gpio_direction_output(phy->reset_gpio, 1);
+	if (ret < 0) {
+		dev_err(phy->dev, "gpio %d direction not set\n", phy->reset_gpio);
+		return ret;
+	}
 
 	clk_prepare_enable(phy->clk);
 	msleep(1);
@@ -624,24 +632,44 @@ static int	tegra_phy_init(struct usb_phy *x)
 			of_get_named_gpio(phy->dev->of_node,
 					  "nvidia,phy-reset-gpio", 0);
 		if (!gpio_is_valid(phy->reset_gpio)) {
-			pr_err("%s: invalid reset gpio: %d\n", __func__,
+			dev_err(phy->dev, "invalid gpio: %d\n",
+				phy->reset_gpio);
+			err = phy->reset_gpio;
+			goto cleanup_clk_get;
+		}
+
+		err = gpio_request(phy->reset_gpio, "ulpi_phy_reset_b");
+		if (err < 0) {
+			dev_err(phy->dev, "request failed for gpio: %d\n",
 			       phy->reset_gpio);
-			err = -EINVAL;
-			goto err1;
+			goto cleanup_clk_get;
+		}
+
+		err = gpio_direction_output(phy->reset_gpio, 0);
+		if (err < 0) {
+			dev_err(phy->dev, "gpio %d direction not set to output\n",
+			       phy->reset_gpio);
+			goto cleanup_gpio_req;
 		}
-		gpio_request(phy->reset_gpio, "ulpi_phy_reset_b");
-		gpio_direction_output(phy->reset_gpio, 0);
+
 		phy->ulpi = otg_ulpi_create(&ulpi_viewport_access_ops, 0);
+		if (!phy->ulpi) {
+			dev_err(phy->dev, "otg_ulpi_create returned err\n");
+			err = -ENOMEM;
+			goto cleanup_gpio_req;
+		}
+
 		phy->ulpi->io_priv = phy->regs + ULPI_VIEWPORT;
 	} else {
 		err = utmip_pad_open(phy);
 		if (err < 0)
-			goto err1;
+			return err;
 	}
 	return 0;
-err1:
-	clk_disable_unprepare(phy->pll_u);
-	clk_put(phy->pll_u);
+cleanup_gpio_req:
+	gpio_free(phy->reset_gpio);
+cleanup_clk_get:
+	clk_put(phy->clk);
 	return err;
 }
 
-- 
1.7.0.4

