Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757588Ab3HMLM4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Aug 2013 07:12:56 -0400
Received: from mail-bk0-f50.google.com ([209.85.214.50]:33068 "EHLO
	mail-bk0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757522Ab3HMLMn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Aug 2013 07:12:43 -0400
From: Thierry Reding <thierry.reding@gmail.com>
To: Russell King <linux@arm.linux.org.uk>, Bjorn Helgaas <bhelgaas@google.com>
Cc: Stephen Warren <swarren@wwwdotorg.org>,
        Thomas Petazzoni <thomas.petazzoni@free-electrons.com>,
        Jason Cooper <jason@lakedaemon.net>,
        Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>,
        linux-arm-kernel@lists.infradead.org, linux-pci@vger.kernel.org,
        linux-tegra@vger.kernel.org, linux-kernel@vger.kernel.org,
        Thierry Reding <treding@nvidia.com>
Subject: [RFC 3/3] PCI: tegra: Support driver unbinding
Date: Tue, 13 Aug 2013 13:12:26 +0200
Message-Id: <1376392346-14127-4-git-send-email-treding@nvidia.com>
X-Mailer: git-send-email 1.8.3.4
In-Reply-To: <1376392346-14127-1-git-send-email-treding@nvidia.com>
References: <1376392346-14127-1-git-send-email-treding@nvidia.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Implement the platform driver's .remove() callback to free all resources
allocated during driver setup and call pci_common_exit() to cleanup ARM
specific datastructures. Unmap the fixed PCI I/O mapping by calling the
new pci_iounmap_io() function in the new .teardown() callback.

Finally, no longer set the .suppress_bind_attrs field to true to allow
the driver to unbind from a device.

Signed-off-by: Thierry Reding <treding@nvidia.com>
---
 drivers/pci/host/pci-tegra.c | 37 ++++++++++++++++++++++++++++++++++++-
 1 file changed, 36 insertions(+), 1 deletion(-)

diff --git a/drivers/pci/host/pci-tegra.c b/drivers/pci/host/pci-tegra.c
index 7356741..396f352 100644
--- a/drivers/pci/host/pci-tegra.c
+++ b/drivers/pci/host/pci-tegra.c
@@ -250,6 +250,7 @@ struct tegra_pcie {
 	int irq;
 
 	struct list_head busses;
+	struct list_head sys;
 	struct resource *cs;
 
 	struct resource io;
@@ -666,6 +667,11 @@ static struct pci_bus *tegra_pcie_scan_bus(int nr, struct pci_sys_data *sys)
 	return bus;
 }
 
+static void tegra_pcie_teardown(int nr, struct pci_sys_data *sys)
+{
+	pci_iounmap_io(nr * SZ_64K);
+}
+
 static irqreturn_t tegra_pcie_isr(int irq, void *arg)
 {
 	const char *err_msg[] = {
@@ -1583,7 +1589,9 @@ static int tegra_pcie_enable(struct tegra_pcie *pcie)
 	hw.map_irq = tegra_pcie_map_irq;
 	hw.add_bus = tegra_pcie_add_bus;
 	hw.scan = tegra_pcie_scan_bus;
+	hw.teardown = tegra_pcie_teardown;
 	hw.ops = &tegra_pcie_ops;
+	hw.sys = &pcie->sys;
 
 	pci_common_init_dev(pcie->dev, &hw);
 
@@ -1637,6 +1645,7 @@ static int tegra_pcie_probe(struct platform_device *pdev)
 
 	INIT_LIST_HEAD(&pcie->busses);
 	INIT_LIST_HEAD(&pcie->ports);
+	INIT_LIST_HEAD(&pcie->sys);
 	pcie->soc_data = match->data;
 	pcie->dev = &pdev->dev;
 
@@ -1686,14 +1695,40 @@ put_resources:
 	return err;
 }
 
+static int tegra_pcie_remove(struct platform_device *pdev)
+{
+	struct tegra_pcie *pcie = platform_get_drvdata(pdev);
+	struct tegra_pcie_bus *bus, *tmp;
+	int err;
+
+	pci_common_exit(&pcie->sys);
+
+	list_for_each_entry_safe(bus, tmp, &pcie->busses, list) {
+		vunmap(bus->area->addr);
+		kfree(bus);
+	}
+
+	if (IS_ENABLED(CONFIG_PCI_MSI)) {
+		err = tegra_pcie_disable_msi(pcie);
+		if (err < 0)
+			return err;
+	}
+
+	err = tegra_pcie_put_resources(pcie);
+	if (err < 0)
+		return err;
+
+	return 0;
+}
+
 static struct platform_driver tegra_pcie_driver = {
 	.driver = {
 		.name = "tegra-pcie",
 		.owner = THIS_MODULE,
 		.of_match_table = tegra_pcie_of_match,
-		.suppress_bind_attrs = true,
 	},
 	.probe = tegra_pcie_probe,
+	.remove = tegra_pcie_remove,
 };
 module_platform_driver(tegra_pcie_driver);
 
-- 
1.8.3.4

