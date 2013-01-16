Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757613Ab3APNan (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jan 2013 08:30:43 -0500
Received: from hqemgate04.nvidia.com ([216.228.121.35]:12910 "EHLO
	hqemgate04.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757550Ab3APNaf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jan 2013 08:30:35 -0500
X-PGP-Universal: processed;
	by hqnvupgp07.nvidia.com on Wed, 16 Jan 2013 05:30:26 -0800
From: Venu Byravarasu <vbyravarasu@nvidia.com>
To: <gregkh@linuxfoundation.org>, <balbi@ti.com>, <stern@rowland.harvard.edu>
CC: <linux-usb@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <swarren@wwwdotorg.org>, <linux-doc@vger.kernel.org>,
        <linux-tegra@vger.kernel.org>,
        Venu Byravarasu <vbyravarasu@nvidia.com>
Subject: [PATCH 3/4] USB: PHY: Tegra: Get rid of instance number to differentiate PHY type
Date: Wed, 16 Jan 2013 19:00:21 +0530
Message-ID: <1358343022-28919-4-git-send-email-vbyravarasu@nvidia.com>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <1358343022-28919-1-git-send-email-vbyravarasu@nvidia.com>
References: <1358343022-28919-1-git-send-email-vbyravarasu@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Tegra20 USB has 3 PHY instances:
Instance 1 and 3 are UTMI. Instance 2 is ULPI.

As instance number was used to differentiate ULPI from UTMI,
used DT param to get this info and processed accordingly.

Signed-off-by: Venu Byravarasu <vbyravarasu@nvidia.com>
---
 drivers/usb/phy/tegra_usb_phy.c   |   23 +++++++++--------------
 include/linux/usb/tegra_usb_phy.h |    1 +
 2 files changed, 10 insertions(+), 14 deletions(-)

diff --git a/drivers/usb/phy/tegra_usb_phy.c b/drivers/usb/phy/tegra_usb_phy.c
index 79280fe..ce1ff2a 100644
--- a/drivers/usb/phy/tegra_usb_phy.c
+++ b/drivers/usb/phy/tegra_usb_phy.c
@@ -209,11 +209,6 @@ static struct tegra_utmip_config utmip_default[] = {
 	},
 };
 
-static inline bool phy_is_ulpi(struct tegra_usb_phy *phy)
-{
-	return (phy->instance == 1);
-}
-
 static int utmip_pad_open(struct tegra_usb_phy *phy)
 {
 	phy->pad_clk = clk_get_sys("utmip-pad", NULL);
@@ -655,7 +650,7 @@ static int	tegra_phy_init(struct usb_phy *x)
 	struct tegra_ulpi_config *ulpi_config;
 	int err;
 
-	if (phy_is_ulpi(phy)) {
+	if (phy->is_ulpi_phy) {
 		ulpi_config = phy->config;
 		phy->clk = clk_get_sys(NULL, ulpi_config->clk);
 		if (IS_ERR(phy->clk)) {
@@ -693,7 +688,7 @@ static void tegra_usb_phy_close(struct usb_phy *x)
 {
 	struct tegra_usb_phy *phy = container_of(x, struct tegra_usb_phy, u_phy);
 
-	if (phy_is_ulpi(phy))
+	if (phy->is_ulpi_phy)
 		clk_put(phy->clk);
 	else
 		utmip_pad_close(phy);
@@ -704,7 +699,7 @@ static void tegra_usb_phy_close(struct usb_phy *x)
 
 static int tegra_usb_phy_power_on(struct tegra_usb_phy *phy)
 {
-	if (phy_is_ulpi(phy))
+	if (phy->is_ulpi_phy)
 		return ulpi_phy_power_on(phy);
 	else
 		return utmi_phy_power_on(phy);
@@ -712,7 +707,7 @@ static int tegra_usb_phy_power_on(struct tegra_usb_phy *phy)
 
 static int tegra_usb_phy_power_off(struct tegra_usb_phy *phy)
 {
-	if (phy_is_ulpi(phy))
+	if (phy->is_ulpi_phy)
 		return ulpi_phy_power_off(phy);
 	else
 		return utmi_phy_power_off(phy);
@@ -749,7 +744,7 @@ struct tegra_usb_phy *tegra_usb_phy_open(struct device *dev, int instance,
 		of_property_read_bool(np, "nvidia,has-legacy-mode");
 
 	if (!phy->config) {
-		if (phy_is_ulpi(phy)) {
+		if (phy->is_ulpi_phy) {
 			pr_err("%s: ulpi phy configuration missing", __func__);
 			err = -EINVAL;
 			goto err0;
@@ -796,14 +791,14 @@ EXPORT_SYMBOL_GPL(tegra_usb_phy_open);
 
 void tegra_usb_phy_preresume(struct tegra_usb_phy *phy)
 {
-	if (!phy_is_ulpi(phy))
+	if (!phy->is_ulpi_phy)
 		utmi_phy_preresume(phy);
 }
 EXPORT_SYMBOL_GPL(tegra_usb_phy_preresume);
 
 void tegra_usb_phy_postresume(struct tegra_usb_phy *phy)
 {
-	if (!phy_is_ulpi(phy))
+	if (!phy->is_ulpi_phy)
 		utmi_phy_postresume(phy);
 }
 EXPORT_SYMBOL_GPL(tegra_usb_phy_postresume);
@@ -811,14 +806,14 @@ EXPORT_SYMBOL_GPL(tegra_usb_phy_postresume);
 void tegra_ehci_phy_restore_start(struct tegra_usb_phy *phy,
 				 enum tegra_usb_phy_port_speed port_speed)
 {
-	if (!phy_is_ulpi(phy))
+	if (!phy->is_ulpi_phy)
 		utmi_phy_restore_start(phy, port_speed);
 }
 EXPORT_SYMBOL_GPL(tegra_ehci_phy_restore_start);
 
 void tegra_ehci_phy_restore_end(struct tegra_usb_phy *phy)
 {
-	if (!phy_is_ulpi(phy))
+	if (!phy->is_ulpi_phy)
 		utmi_phy_restore_end(phy);
 }
 EXPORT_SYMBOL_GPL(tegra_ehci_phy_restore_end);
diff --git a/include/linux/usb/tegra_usb_phy.h b/include/linux/usb/tegra_usb_phy.h
index f03e157..a6a89d4 100644
--- a/include/linux/usb/tegra_usb_phy.h
+++ b/include/linux/usb/tegra_usb_phy.h
@@ -60,6 +60,7 @@ struct tegra_usb_phy {
 	struct usb_phy u_phy;
 	struct device *dev;
 	bool is_legacy_phy;
+	bool is_ulpi_phy;
 };
 
 struct tegra_usb_phy *tegra_usb_phy_open(struct device *dev, int instance,
-- 
1.7.0.4

