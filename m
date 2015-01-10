Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758448AbbAJCgm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Jan 2015 21:36:42 -0500
Received: from mail-oi0-f46.google.com ([209.85.218.46]:58054 "EHLO
	mail-oi0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756348AbbAJCfy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Jan 2015 21:35:54 -0500
From: Rob Herring <robh@kernel.org>
To: linux-kernel@vger.kernel.org
Cc: Arnd Bergmann <arnd@arndb.de>, linux-pci@vger.kernel.org,
        Bjorn Helgaas <bhelgaas@google.com>, Rob Herring <robh@kernel.org>,
        Thierry Reding <thierry.reding@gmail.com>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Alexandre Courbot <gnurou@gmail.com>, linux-tegra@vger.kernel.org
Subject: [PATCH 14/16] pci/host: tegra: convert to use generic config accesses
Date: Fri,  9 Jan 2015 20:34:48 -0600
Message-Id: <1420857290-8373-15-git-send-email-robh@kernel.org>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <1420857290-8373-1-git-send-email-robh@kernel.org>
References: <1420857290-8373-1-git-send-email-robh@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Convert the tegra host PCI driver to use the generic config access
functions.

Signed-off-by: Rob Herring <robh@kernel.org>
Cc: Thierry Reding <thierry.reding@gmail.com>
Cc: Bjorn Helgaas <bhelgaas@google.com>
Cc: Stephen Warren <swarren@wwwdotorg.org>
Cc: Alexandre Courbot <gnurou@gmail.com>
Cc: linux-tegra@vger.kernel.org
Cc: linux-pci@vger.kernel.org
---
 drivers/pci/host/pci-tegra.c | 55 +++-----------------------------------------
 1 file changed, 3 insertions(+), 52 deletions(-)

diff --git a/drivers/pci/host/pci-tegra.c b/drivers/pci/host/pci-tegra.c
index a800ae9..44fd31b 100644
--- a/drivers/pci/host/pci-tegra.c
+++ b/drivers/pci/host/pci-tegra.c
@@ -480,59 +480,10 @@ static void __iomem *tegra_pcie_conf_address(struct pci_bus *bus,
 	return addr;
 }
 
-static int tegra_pcie_read_conf(struct pci_bus *bus, unsigned int devfn,
-				int where, int size, u32 *value)
-{
-	void __iomem *addr;
-
-	addr = tegra_pcie_conf_address(bus, devfn, where);
-	if (!addr) {
-		*value = 0xffffffff;
-		return PCIBIOS_DEVICE_NOT_FOUND;
-	}
-
-	*value = readl(addr);
-
-	if (size == 1)
-		*value = (*value >> (8 * (where & 3))) & 0xff;
-	else if (size == 2)
-		*value = (*value >> (8 * (where & 3))) & 0xffff;
-
-	return PCIBIOS_SUCCESSFUL;
-}
-
-static int tegra_pcie_write_conf(struct pci_bus *bus, unsigned int devfn,
-				 int where, int size, u32 value)
-{
-	void __iomem *addr;
-	u32 mask, tmp;
-
-	addr = tegra_pcie_conf_address(bus, devfn, where);
-	if (!addr)
-		return PCIBIOS_DEVICE_NOT_FOUND;
-
-	if (size == 4) {
-		writel(value, addr);
-		return PCIBIOS_SUCCESSFUL;
-	}
-
-	if (size == 2)
-		mask = ~(0xffff << ((where & 0x3) * 8));
-	else if (size == 1)
-		mask = ~(0xff << ((where & 0x3) * 8));
-	else
-		return PCIBIOS_BAD_REGISTER_NUMBER;
-
-	tmp = readl(addr) & mask;
-	tmp |= value << ((where & 0x3) * 8);
-	writel(tmp, addr);
-
-	return PCIBIOS_SUCCESSFUL;
-}
-
 static struct pci_ops tegra_pcie_ops = {
-	.read = tegra_pcie_read_conf,
-	.write = tegra_pcie_write_conf,
+	.map_bus = tegra_pcie_conf_address,
+	.read = pci_generic_config_read32,
+	.write = pci_generic_config_write32,
 };
 
 static unsigned long tegra_pcie_port_get_pex_ctrl(struct tegra_pcie_port *port)
-- 
2.1.0

