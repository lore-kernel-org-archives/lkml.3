Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754663Ab3EPOXK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 May 2013 10:23:10 -0400
Received: from hqemgate04.nvidia.com ([216.228.121.35]:2059 "EHLO
	hqemgate04.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751619Ab3EPOW3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 May 2013 10:22:29 -0400
X-PGP-Universal: processed;
	by hqnvupgp07.nvidia.com on Thu, 16 May 2013 07:18:39 -0700
From: Venu Byravarasu <vbyravarasu@nvidia.com>
To: <gregkh@linuxfoundation.org>, <stern@rowland.harvard.edu>, <balbi@ti.com>,
        <swarren@wwwdotorg.org>
CC: <linux-usb@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-tegra@vger.kernel.org>,
        Venu Byravarasu <vbyravarasu@nvidia.com>
Subject: [PATCH v4 6/8] usb: phy: tegra: get ULPI reset GPIO info using DT.
Date: Thu, 16 May 2013 19:43:00 +0530
Message-ID: <1368713582-29038-7-git-send-email-vbyravarasu@nvidia.com>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <1368713582-29038-1-git-send-email-vbyravarasu@nvidia.com>
References: <1368713582-29038-1-git-send-email-vbyravarasu@nvidia.com>
X-NVConfidentiality: public
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

As GPIO information is avail through DT, used it to get Tegra ULPI
reset GPIO number. Added a new member to tegra_usb_phy structure to
store this number.

Signed-off-by: Venu Byravarasu <vbyravarasu@nvidia.com>
---
delta from v1, v2 & v3: no change.

 drivers/usb/phy/phy-tegra-usb.c   |   25 +++++++++++--------------
 include/linux/usb/tegra_usb_phy.h |    1 +
 2 files changed, 12 insertions(+), 14 deletions(-)

diff --git a/drivers/usb/phy/phy-tegra-usb.c b/drivers/usb/phy/phy-tegra-usb.c
index 0ff1f3e..b8c688a 100644
--- a/drivers/usb/phy/phy-tegra-usb.c
+++ b/drivers/usb/phy/phy-tegra-usb.c
@@ -541,11 +541,10 @@ static int ulpi_phy_power_on(struct tegra_usb_phy *phy)
 	int ret;
 	unsigned long val;
 	void __iomem *base = phy->regs;
-	struct tegra_ulpi_config *config = phy->config;
 
-	gpio_direction_output(config->reset_gpio, 0);
+	gpio_direction_output(phy->reset_gpio, 0);
 	msleep(5);
-	gpio_direction_output(config->reset_gpio, 1);
+	gpio_direction_output(phy->reset_gpio, 1);
 
 	clk_prepare_enable(phy->clk);
 	msleep(1);
@@ -603,10 +602,8 @@ static int ulpi_phy_power_on(struct tegra_usb_phy *phy)
 
 static int ulpi_phy_power_off(struct tegra_usb_phy *phy)
 {
-	struct tegra_ulpi_config *config = phy->config;
-
 	clk_disable(phy->clk);
-	return gpio_direction_output(config->reset_gpio, 0);
+	return gpio_direction_output(phy->reset_gpio, 0);
 }
 
 static int	tegra_phy_init(struct usb_phy *x)
@@ -622,18 +619,18 @@ static int	tegra_phy_init(struct usb_phy *x)
 			pr_err("%s: can't get ulpi clock\n", __func__);
 			return PTR_ERR(phy->clk);
 		}
-		if (!gpio_is_valid(ulpi_config->reset_gpio))
-			ulpi_config->reset_gpio =
-				of_get_named_gpio(phy->dev->of_node,
-						  "nvidia,phy-reset-gpio", 0);
-		if (!gpio_is_valid(ulpi_config->reset_gpio)) {
+
+		phy->reset_gpio =
+			of_get_named_gpio(phy->dev->of_node,
+					  "nvidia,phy-reset-gpio", 0);
+		if (!gpio_is_valid(phy->reset_gpio)) {
 			pr_err("%s: invalid reset gpio: %d\n", __func__,
-			       ulpi_config->reset_gpio);
+			       phy->reset_gpio);
 			err = -EINVAL;
 			goto err1;
 		}
-		gpio_request(ulpi_config->reset_gpio, "ulpi_phy_reset_b");
-		gpio_direction_output(ulpi_config->reset_gpio, 0);
+		gpio_request(phy->reset_gpio, "ulpi_phy_reset_b");
+		gpio_direction_output(phy->reset_gpio, 0);
 		phy->ulpi = otg_ulpi_create(&ulpi_viewport_access_ops, 0);
 		phy->ulpi->io_priv = phy->regs + ULPI_VIEWPORT;
 	} else {
diff --git a/include/linux/usb/tegra_usb_phy.h b/include/linux/usb/tegra_usb_phy.h
index ff2d959..97d123c 100644
--- a/include/linux/usb/tegra_usb_phy.h
+++ b/include/linux/usb/tegra_usb_phy.h
@@ -62,6 +62,7 @@ struct tegra_usb_phy {
 	struct device *dev;
 	bool is_legacy_phy;
 	bool is_ulpi_phy;
+	int reset_gpio;
 	void (*set_pts)(struct usb_phy *x, u8 pts_val);
 	void (*set_phcd)(struct usb_phy *x, bool enable);
 };
-- 
1.7.0.4

