Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933897AbaHZPLv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Aug 2014 11:11:51 -0400
Received: from mail-wg0-f50.google.com ([74.125.82.50]:35504 "EHLO
	mail-wg0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758522AbaHZPLr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Aug 2014 11:11:47 -0400
From: Thierry Reding <thierry.reding@gmail.com>
To: Bjorn Helgaas <bhelgaas@google.com>
Cc: Stephen Warren <swarren@wwwdotorg.org>, linux-pci@vger.kernel.org,
        linux-tegra@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH v3 3/6] PCI: tegra: Clear CLKREQ# enable on port disable
Date: Tue, 26 Aug 2014 17:11:35 +0200
Message-Id: <1409065898-26887-4-git-send-email-thierry.reding@gmail.com>
X-Mailer: git-send-email 2.0.4
In-Reply-To: <1409065898-26887-1-git-send-email-thierry.reding@gmail.com>
References: <1409065898-26887-1-git-send-email-thierry.reding@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Thierry Reding <treding@nvidia.com>

When a root port is disabled, disable the CLKREQ# signal if available.

Signed-off-by: Thierry Reding <treding@nvidia.com>
---
 drivers/pci/host/pci-tegra.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/drivers/pci/host/pci-tegra.c b/drivers/pci/host/pci-tegra.c
index 83fa33e16650..bd53b123218b 100644
--- a/drivers/pci/host/pci-tegra.c
+++ b/drivers/pci/host/pci-tegra.c
@@ -569,6 +569,7 @@ static void tegra_pcie_port_enable(struct tegra_pcie_port *port)
 
 static void tegra_pcie_port_disable(struct tegra_pcie_port *port)
 {
+	const struct tegra_pcie_soc_data *soc = port->pcie->soc_data;
 	unsigned long ctrl = tegra_pcie_port_get_pex_ctrl(port);
 	unsigned long value;
 
@@ -579,6 +580,10 @@ static void tegra_pcie_port_disable(struct tegra_pcie_port *port)
 
 	/* disable reference clock */
 	value = afi_readl(port->pcie, ctrl);
+
+	if (soc->has_pex_clkreq_en)
+		value &= ~AFI_PEX_CTRL_CLKREQ_EN;
+
 	value &= ~AFI_PEX_CTRL_REFCLK_EN;
 	afi_writel(port->pcie, value, ctrl);
 }
-- 
2.0.4

