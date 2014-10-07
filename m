Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753365AbaJGK2S (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Oct 2014 06:28:18 -0400
Received: from hqemgate16.nvidia.com ([216.228.121.65]:7100 "EHLO
	hqemgate16.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753064AbaJGK2Q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Oct 2014 06:28:16 -0400
X-PGP-Universal: processed;
	by hqnvupgp07.nvidia.com on Tue, 07 Oct 2014 03:26:26 -0700
From: Vidya Sagar <vidyas@nvidia.com>
To: <thierry.reding@gmail.com>, <bhelgaas@google.com>, <swarren@wwwdotorg.org>
CC: <kthota@nvidia.com>, <linux-tegra@vger.kernel.org>,
        <linux-pci@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        Vidya Sagar <vidyas@nvidia.com>
Subject: [PATCH v1] PCI: tegra: Enable root port specific features
Date: Tue, 7 Oct 2014 15:57:58 +0530
Message-ID: <1412677678-12011-1-git-send-email-vidyas@nvidia.com>
X-Mailer: git-send-email 1.8.1.5
X-NVConfidentiality: public
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Enables root port to advertise its ASPM-L1 capability
 resulting in possible link entry to L1 when an ASPM-L1 capable
 device is connected
Enables per-controller & per-TMS clock clamping by default
Enabling above features result in more power saving

It also avoids PM message truncation by waiting for DLLP to finish
before entering into L1 or L2

Also, it adds helper functions to access root port registers

Signed-off-by: Vidya Sagar <vidyas@nvidia.com>
---
 drivers/pci/host/pci-tegra.c | 54 +++++++++++++++++++++++++++++++++++++++++++-
 1 file changed, 53 insertions(+), 1 deletion(-)

diff --git a/drivers/pci/host/pci-tegra.c b/drivers/pci/host/pci-tegra.c
index 3d43874..b192a47 100644
--- a/drivers/pci/host/pci-tegra.c
+++ b/drivers/pci/host/pci-tegra.c
@@ -237,6 +237,18 @@
 		(0xf  << PADS_REFCLK_CFG_DRVI_SHIFT)     \
 	)
 
+#define NV_PCIE2_RP_VEND_XP1			0x00000F04
+#define NV_PCIE2_RP_VEND_XP_LINK_PVT_CTL_L1_ASPM_SUPPORT	(1 << 21)
+
+#define NV_PCIE2_RP_VEND_XP_BIST		0x00000F4C
+#define PCIE2_RP_VEND_XP_BIST_GOTO_L1_L2_AFTER_DLLP_DONE	(1 << 28)
+
+#define NV_PCIE2_RP_PRIV_MISC			0x00000FE0
+#define PCIE2_RP_PRIV_MISC_CTLR_CLK_CLAMP_THRESHOLD	(0xF << 16)
+#define PCIE2_RP_PRIV_MISC_CTLR_CLK_CLAMP_ENABLE	(1 << 23)
+#define PCIE2_RP_PRIV_MISC_TMS_CLK_CLAMP_THRESHOLD	(0xF << 24)
+#define PCIE2_RP_PRIV_MISC_TMS_CLK_CLAMP_ENABLE		(1 << 31)
+
 struct tegra_msi {
 	struct msi_chip chip;
 	DECLARE_BITMAP(used, INT_PCI_MSI_NR);
@@ -346,6 +358,18 @@ static inline u32 pads_readl(struct tegra_pcie *pcie, unsigned long offset)
 	return readl(pcie->pads + offset);
 }
 
+static inline void rp_writel(struct tegra_pcie_port *port, u32 value,
+							 unsigned long offset)
+{
+	writel(value, offset + port->base);
+}
+
+static inline unsigned int rp_readl(struct tegra_pcie_port *port,
+							unsigned long offset)
+{
+	return readl(offset + port->base);
+}
+
 /*
  * The configuration space mapping on Tegra is somewhat similar to the ECAM
  * defined by PCIe. However it deviates a bit in how the 4 bits for extended
@@ -1859,6 +1883,32 @@ retry:
 	return false;
 }
 
+/* Enable various features of root port */
+static void tegra_pcie_enable_rp_features(struct tegra_pcie_port *port)
+{
+	unsigned int data;
+
+	/* Power mangagement settings */
+	/* Enable clock clamping by default */
+	data = rp_readl(port, NV_PCIE2_RP_PRIV_MISC);
+	data |= PCIE2_RP_PRIV_MISC_CTLR_CLK_CLAMP_THRESHOLD |
+		PCIE2_RP_PRIV_MISC_CTLR_CLK_CLAMP_ENABLE |
+		PCIE2_RP_PRIV_MISC_TMS_CLK_CLAMP_THRESHOLD |
+		PCIE2_RP_PRIV_MISC_TMS_CLK_CLAMP_ENABLE;
+	rp_writel(port, data, NV_PCIE2_RP_PRIV_MISC);
+
+	/* Enable rootport to advertise its ASPM - L1 capability */
+	data = rp_readl(port, NV_PCIE2_RP_VEND_XP1);
+	data |= NV_PCIE2_RP_VEND_XP_LINK_PVT_CTL_L1_ASPM_SUPPORT;
+	rp_writel(port, data, NV_PCIE2_RP_VEND_XP1);
+
+	/* LTSSM : wait for DLLP to finish before entering L1 or L2/L3 */
+	/* to avoid truncating PM messages resulting in receiver errors */
+	data = rp_readl(port, NV_PCIE2_RP_VEND_XP_BIST);
+	data |= PCIE2_RP_VEND_XP_BIST_GOTO_L1_L2_AFTER_DLLP_DONE;
+	rp_writel(port, data, NV_PCIE2_RP_VEND_XP_BIST);
+}
+
 static int tegra_pcie_enable(struct tegra_pcie *pcie)
 {
 	struct tegra_pcie_port *port, *tmp;
@@ -1870,8 +1920,10 @@ static int tegra_pcie_enable(struct tegra_pcie *pcie)
 
 		tegra_pcie_port_enable(port);
 
-		if (tegra_pcie_port_check_link(port))
+		if (tegra_pcie_port_check_link(port)) {
+			tegra_pcie_enable_rp_features(port);
 			continue;
+		}
 
 		dev_info(pcie->dev, "link %u down, ignoring\n", port->index);
 
-- 
1.8.1.5

