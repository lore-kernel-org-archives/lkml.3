Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934630AbaHZO6j (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Aug 2014 10:58:39 -0400
Received: from mail-we0-f174.google.com ([74.125.82.174]:58000 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934497AbaHZO6A (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Aug 2014 10:58:00 -0400
From: Thierry Reding <thierry.reding@gmail.com>
To: Bjorn Helgaas <bhelgaas@google.com>
Cc: Stephen Warren <swarren@wwwdotorg.org>, linux-pci@vger.kernel.org,
        linux-tegra@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH v2 5/6] PCI: tegra: Make sure the PCIe PLL is really reset
Date: Tue, 26 Aug 2014 16:57:43 +0200
Message-Id: <1409065064-17617-6-git-send-email-thierry.reding@gmail.com>
X-Mailer: git-send-email 2.0.4
In-Reply-To: <1409065064-17617-1-git-send-email-thierry.reding@gmail.com>
References: <1409065064-17617-1-git-send-email-thierry.reding@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Eric Yuen <eyuen@nvidia.com>

Depending on the prior state of the controller, the PLL reset may not be
pulsed. Clear the register bit and set it after a small delay to ensure
that the PLL is really reset.

Signed-off-by: Eric Yuen <eyuen@nvidia.com>
Signed-off-by: Thierry Reding <treding@nvidia.com>
---
 drivers/pci/host/pci-tegra.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/drivers/pci/host/pci-tegra.c b/drivers/pci/host/pci-tegra.c
index 8264bce77750..0ce43764dd36 100644
--- a/drivers/pci/host/pci-tegra.c
+++ b/drivers/pci/host/pci-tegra.c
@@ -849,6 +849,13 @@ static int tegra_pcie_enable_controller(struct tegra_pcie *pcie)
 	value |= PADS_PLL_CTL_REFCLK_INTERNAL_CML | soc->tx_ref_sel;
 	pads_writel(pcie, value, soc->pads_pll_ctl);
 
+	/* reset PLL */
+	value = pads_readl(pcie, soc->pads_pll_ctl);
+	value &= ~PADS_PLL_CTL_RST_B4SM;
+	pads_writel(pcie, value, soc->pads_pll_ctl);
+
+	usleep_range(20, 100);
+
 	/* take PLL out of reset  */
 	value = pads_readl(pcie, soc->pads_pll_ctl);
 	value |= PADS_PLL_CTL_RST_B4SM;
-- 
2.0.4

