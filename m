Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757468Ab3GYRyl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Jul 2013 13:54:41 -0400
Received: from mail-bk0-f52.google.com ([209.85.214.52]:36270 "EHLO
	mail-bk0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757437Ab3GYRyg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Jul 2013 13:54:36 -0400
From: Thierry Reding <thierry.reding@gmail.com>
To: Bjorn Helgaas <bhelgaas@google.com>,
        Stephen Warren <swarren@wwwdotorg.org>
Cc: Russell King <linux@arm.linux.org.uk>, Jason Cooper <jason@lakedaemon.net>,
        Thomas Petazzoni <thomas.petazzoni@free-electrons.com>,
        Jay Agarwal <jagarwal@nvidia.com>, linux-pci@vger.kernel.org,
        linux-tegra@vger.kernel.org, devicetree@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: [PATCH v5 09/16] PCI: tegra: set up PADS_REFCLK_CFG1
Date: Thu, 25 Jul 2013 10:53:23 -0700
Message-Id: <1374774810-18459-10-git-send-email-thierry.reding@gmail.com>
X-Mailer: git-send-email 1.8.1.5
In-Reply-To: <1374774810-18459-1-git-send-email-thierry.reding@gmail.com>
References: <1374774810-18459-1-git-send-email-thierry.reding@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Stephen Warren <swarren@nvidia.com>

The registers PADS_REFCLK_CFG are an array of 16-bit data, one entry per
PCIe root port. For Tegra30, we therefore need to write a 3rd entry in
this array. Doing so mays the mini-PCIe slot on Beaver operate correctly.

While we're at it, add some #defines to partially document the fields
within these 16-bit values.

Signed-off-by: Stephen Warren <swarren@nvidia.com>
Signed-off-by: Thierry Reding <treding@nvidia.com>
---
 drivers/pci/host/pci-tegra.c | 29 ++++++++++++++++++++++++-----
 1 file changed, 24 insertions(+), 5 deletions(-)

diff --git a/drivers/pci/host/pci-tegra.c b/drivers/pci/host/pci-tegra.c
index 5347d7d..0c84c67 100644
--- a/drivers/pci/host/pci-tegra.c
+++ b/drivers/pci/host/pci-tegra.c
@@ -196,6 +196,25 @@
 #define PADS_REFCLK_CFG0			0x000000C8
 #define PADS_REFCLK_CFG1			0x000000CC
 
+/*
+ * Fields in PADS_REFCLK_CFG*. Those registers form an array of 16-bit
+ * entries, one entry per PCIe port. These field definitions and desired
+ * values aren't in the TRM, but do come from NVIDIA.
+ */
+#define PADS_REFCLK_CFG_TERM_SHIFT		2  /* 6:2 */
+#define PADS_REFCLK_CFG_E_TERM_SHIFT		7
+#define PADS_REFCLK_CFG_PREDI_SHIFT		8  /* 11:8 */
+#define PADS_REFCLK_CFG_DRVI_SHIFT		12 /* 15:12 */
+
+/* Default value provided by HW engineering is 0xfa5c */
+#define PADS_REFCLK_CFG_VALUE \
+	( \
+		(0x17 << PADS_REFCLK_CFG_TERM_SHIFT)   | \
+		(0    << PADS_REFCLK_CFG_E_TERM_SHIFT) | \
+		(0xa  << PADS_REFCLK_CFG_PREDI_SHIFT)  | \
+		(0xf  << PADS_REFCLK_CFG_DRVI_SHIFT)     \
+	)
+
 struct tegra_msi {
 	struct msi_chip chip;
 	DECLARE_BITMAP(used, INT_PCI_MSI_NR);
@@ -809,11 +828,11 @@ static int tegra_pcie_enable_controller(struct tegra_pcie *pcie)
 	value |= PADS_PLL_CTL_RST_B4SM;
 	pads_writel(pcie, value, soc->pads_pll_ctl);
 
-	/*
-	 * Hack, set the clock voltage to the DEFAULT provided by hw folks.
-	 * This doesn't exist in the documentation.
-	 */
-	pads_writel(pcie, 0xfa5cfa5c, PADS_REFCLK_CFG0);
+	/* Configure the reference clock driver */
+	value = PADS_REFCLK_CFG_VALUE | (PADS_REFCLK_CFG_VALUE << 16);
+	pads_writel(pcie, value, PADS_REFCLK_CFG0);
+	if (soc->num_ports > 2)
+		pads_writel(pcie, PADS_REFCLK_CFG_VALUE, PADS_REFCLK_CFG1);
 
 	/* wait for the PLL to lock */
 	timeout = 300;
-- 
1.8.1.5

