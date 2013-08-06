Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756693Ab3HFSKh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Aug 2013 14:10:37 -0400
Received: from hqemgate16.nvidia.com ([216.228.121.65]:7464 "EHLO
	hqemgate16.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756370Ab3HFSI5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Aug 2013 14:08:57 -0400
X-PGP-Universal: processed;
	by hqnvupgp08.nvidia.com on Tue, 06 Aug 2013 11:07:16 -0700
From: Tuomas Tynkkynen <ttynkkynen@nvidia.com>
To: <balbi@ti.com>
CC: <linux-tegra@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-usb@vger.kernel.org>, <swarren@wwwdotorg.org>,
        <gregkh@linuxfoundation.org>, <stern@rowland.harvard.edu>,
        Tuomas Tynkkynen <ttynkkynen@nvidia.com>
Subject: [PATCH v2 2/6] usb: phy: tegra: Fix wrong PHY parameters
Date: Tue, 6 Aug 2013 21:08:34 +0300
Message-ID: <1375812518-3847-3-git-send-email-ttynkkynen@nvidia.com>
X-Mailer: git-send-email 1.8.1.5
In-Reply-To: <1375812518-3847-1-git-send-email-ttynkkynen@nvidia.com>
References: <1375812518-3847-1-git-send-email-ttynkkynen@nvidia.com>
X-NVConfidentiality: public
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Some of the PHY parameters are not set according to the TRMs:

- UTMIP_FS_PREABMLE_J should be set, not cleared
- UTMIP_XCVR_LSBIAS_SEL should be cleared, not set
- UTMIP_PD_CHRG should be set in host mode and cleared in device mode
- UTMIP_XCVR_SETUP is a two-part field; the upper bits were not set
  properly

Signed-off-by: Tuomas Tynkkynen <ttynkkynen@nvidia.com>
---
v2: Change register bitmasks to not contain shifted-out bits
 drivers/usb/phy/phy-tegra-usb.c | 20 ++++++++++++++------
 1 file changed, 14 insertions(+), 6 deletions(-)

diff --git a/drivers/usb/phy/phy-tegra-usb.c b/drivers/usb/phy/phy-tegra-usb.c
index 49fa2da..ebbf85f 100644
--- a/drivers/usb/phy/phy-tegra-usb.c
+++ b/drivers/usb/phy/phy-tegra-usb.c
@@ -86,11 +86,13 @@
 
 #define UTMIP_XCVR_CFG0		0x808
 #define   UTMIP_XCVR_SETUP(x)			(((x) & 0xf) << 0)
+#define   UTMIP_XCVR_SETUP_MSB(x)		((((x) & 0x70) >> 4) << 22)
 #define   UTMIP_XCVR_LSRSLEW(x)			(((x) & 0x3) << 8)
 #define   UTMIP_XCVR_LSFSLEW(x)			(((x) & 0x3) << 10)
 #define   UTMIP_FORCE_PD_POWERDOWN		(1 << 14)
 #define   UTMIP_FORCE_PD2_POWERDOWN		(1 << 16)
 #define   UTMIP_FORCE_PDZI_POWERDOWN		(1 << 18)
+#define   UTMIP_XCVR_LSBIAS_SEL			(1 << 21)
 #define   UTMIP_XCVR_HSSLEW_MSB(x)		(((x) & 0x7f) << 25)
 
 #define UTMIP_BIAS_CFG0		0x80c
@@ -342,7 +344,7 @@ static int utmi_phy_power_on(struct tegra_usb_phy *phy)
 	}
 
 	val = readl(base + UTMIP_TX_CFG0);
-	val &= ~UTMIP_FS_PREABMLE_J;
+	val |= UTMIP_FS_PREABMLE_J;
 	writel(val, base + UTMIP_TX_CFG0);
 
 	val = readl(base + UTMIP_HSRX_CFG0);
@@ -381,16 +383,26 @@ static int utmi_phy_power_on(struct tegra_usb_phy *phy)
 		val = readl(base + USB_SUSP_CTRL);
 		val &= ~(USB_WAKE_ON_CNNT_EN_DEV | USB_WAKE_ON_DISCON_EN_DEV);
 		writel(val, base + USB_SUSP_CTRL);
+
+		val = readl(base + UTMIP_BAT_CHRG_CFG0);
+		val &= ~UTMIP_PD_CHRG;
+		writel(val, base + UTMIP_BAT_CHRG_CFG0);
+	} else {
+		val = readl(base + UTMIP_BAT_CHRG_CFG0);
+		val |= UTMIP_PD_CHRG;
+		writel(val, base + UTMIP_BAT_CHRG_CFG0);
 	}
 
 	utmip_pad_power_on(phy);
 
 	val = readl(base + UTMIP_XCVR_CFG0);
 	val &= ~(UTMIP_FORCE_PD_POWERDOWN | UTMIP_FORCE_PD2_POWERDOWN |
-		 UTMIP_FORCE_PDZI_POWERDOWN | UTMIP_XCVR_SETUP(~0) |
+		 UTMIP_FORCE_PDZI_POWERDOWN | UTMIP_XCVR_LSBIAS_SEL |
+		 UTMIP_XCVR_SETUP(~0) | UTMIP_XCVR_SETUP_MSB(~0) |
 		 UTMIP_XCVR_LSFSLEW(~0) | UTMIP_XCVR_LSRSLEW(~0) |
 		 UTMIP_XCVR_HSSLEW_MSB(~0));
 	val |= UTMIP_XCVR_SETUP(config->xcvr_setup);
+	val |= UTMIP_XCVR_SETUP_MSB(config->xcvr_setup);
 	val |= UTMIP_XCVR_LSFSLEW(config->xcvr_lsfslew);
 	val |= UTMIP_XCVR_LSRSLEW(config->xcvr_lsrslew);
 	writel(val, base + UTMIP_XCVR_CFG0);
@@ -401,10 +413,6 @@ static int utmi_phy_power_on(struct tegra_usb_phy *phy)
 	val |= UTMIP_XCVR_TERM_RANGE_ADJ(config->term_range_adj);
 	writel(val, base + UTMIP_XCVR_CFG1);
 
-	val = readl(base + UTMIP_BAT_CHRG_CFG0);
-	val &= ~UTMIP_PD_CHRG;
-	writel(val, base + UTMIP_BAT_CHRG_CFG0);
-
 	val = readl(base + UTMIP_BIAS_CFG1);
 	val &= ~UTMIP_BIAS_PDTRK_COUNT(~0);
 	val |= UTMIP_BIAS_PDTRK_COUNT(0x5);
-- 
1.8.1.5

