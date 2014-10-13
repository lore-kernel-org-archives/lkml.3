Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753483AbaJMJua (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Oct 2014 05:50:30 -0400
Received: from hqemgate15.nvidia.com ([216.228.121.64]:8220 "EHLO
	hqemgate15.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752903AbaJMJu2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Oct 2014 05:50:28 -0400
X-PGP-Universal: processed;
	by hqnvupgp08.nvidia.com on Mon, 13 Oct 2014 02:50:08 -0700
From: Vidya Sagar <vidyas@nvidia.com>
To: <vidyas@nvidia.com>
CC: <thierry.reding@gmail.com>, <swarren@wwwdotorg.org>, <kthota@nvidia.com>,
        <bhelgaas@google.com>, <linux-tegra@vger.kernel.org>,
        <linux-pci@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: [PATCH v4] PCI: tegra: add PM-ops support
Date: Mon, 13 Oct 2014 15:20:03 +0530
Message-ID: <1413193803-21718-1-git-send-email-vidyas@nvidia.com>
X-Mailer: git-send-email 1.8.1.5
X-NVConfidentiality: public
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

adds support for suspend_noirq and resume_noirq hooks
of PM framework. Enables powergating of PCIe partition during
suspend.
It also separates allocation part from
tegra_pcie_enable_msi() to make a new API tegra_pcie_alloc_msi()
to avoid passing extra param in the original API

Signed-off-by: Vidya Sagar <vidyas@nvidia.com>
---
v4:
 changed type of num_ports from int to unsigned int in tegra_pcie_check_ports()
 took care of indentation issues

v3:
 Modified commit message according to review comments
 powering off PCIe in resume if no devices are found instead of
 	putting the resources
 removed unnecessary whitespace changes
 modified tegra_pcie_check_ports to return number of ports active

v2:
 separated alloc_msi from enable_msi
 changed tegra_pcie_check_ports to a static function
 removed irrelevant comments

NOTE:
 This patch currently uses suspend_noirq, resume_noirq calls as
 the PCI subsystem (in its own _noirq call) tries to save config registers
 of connected PCIe devices.
 In the platform that I'm working on, there is a dependency of PCIe drive's working
 on I2C controller (because of the way PCIe power rails are controlled) and hence,
 by the time suspend_noirq() is called, I2C would have been disabled, hence I'm not
 supposed to use _noirq calls in this patch.

 Here is the call flow on how PCI_PM _noirq() call is invoked

[<c02a4338>] (pci_bus_read_config_dword+0x88/0x90) from [<c02aa8a0>] (pci_save_state+0x30/0x174)
[<c02aa8a0>] (pci_save_state+0x30/0x174) from [<c02ad020>] (pci_pm_suspend_noirq+0x23c/0x258)
[<c02ad020>] (pci_pm_suspend_noirq+0x23c/0x258) from [<c03f85d0>] (dpm_run_callback+0x34/0x54)
[<c03f85d0>] (dpm_run_callback+0x34/0x54) from [<c03f8e74>] (dpm_suspend_end+0x29c/0x694)
[<c03f8e74>] (dpm_suspend_end+0x29c/0x694) from [<c0084b04>] (suspend_devices_and_enter+0x150/0x420)
[<c0084b04>] (suspend_devices_and_enter+0x150/0x420) from [<c0084fac>] (pm_suspend+0x1d8/0x2a4)
[<c0084fac>] (pm_suspend+0x1d8/0x2a4) from [<c0083b6c>] (state_store+0x74/0xc4)
[<c0083b6c>] (state_store+0x74/0xc4) from [<c026ecf0>] (kobj_attr_store+0x14/0x20)
[<c026ecf0>] (kobj_attr_store+0x14/0x20) from [<c0177334>] (sysfs_write_file+0x170/0x1a0)
[<c0177334>] (sysfs_write_file+0x170/0x1a0) from [<c0118afc>] (vfs_write+0xbc/0x198)
[<c0118afc>] (vfs_write+0xbc/0x198) from [<c0118fe8>] (SyS_write+0x5c/0x16c)
[<c0118fe8>] (SyS_write+0x5c/0x16c) from [<c000f140>] (ret_fast_syscall+0x0/0x30)

 Can someone help me understand why does PCI subsystem use suspend_noirq calls
 (pci_pm_suspend_noirq()) instead of normal suspend ?

 drivers/pci/host/pci-tegra.c | 111 ++++++++++++++++++++++++++++++++++++-------
 1 file changed, 93 insertions(+), 18 deletions(-)

diff --git a/drivers/pci/host/pci-tegra.c b/drivers/pci/host/pci-tegra.c
index 5ac9f06..0875a78 100644
--- a/drivers/pci/host/pci-tegra.c
+++ b/drivers/pci/host/pci-tegra.c
@@ -985,14 +985,21 @@ static void tegra_pcie_power_off(struct tegra_pcie *pcie)
 {
 	int err;

-	/* TODO: disable and unprepare clocks? */
-
 	err = phy_power_off(pcie->phy);
 	if (err < 0)
 		dev_warn(pcie->dev, "failed to power off PHY: %d\n", err);

 	reset_control_assert(pcie->pcie_xrst);
+
+	clk_disable_unprepare(pcie->pll_e);
+
+	if (pcie->soc_data->has_cml_clk)
+		clk_disable_unprepare(pcie->cml_clk);
+
+	clk_disable_unprepare(pcie->afi_clk);
 	reset_control_assert(pcie->afi_rst);
+
+	clk_disable_unprepare(pcie->pex_clk);
 	reset_control_assert(pcie->pex_rst);

 	tegra_powergate_power_off(TEGRA_POWERGATE_PCIE);
@@ -1126,7 +1133,7 @@ static int tegra_pcie_get_resources(struct tegra_pcie *pcie)
 	}

 	err = tegra_pcie_power_on(pcie);
-	if (err) {
+	if (err < 0) {
 		dev_err(&pdev->dev, "failed to power up: %d\n", err);
 		return err;
 	}
@@ -1329,14 +1336,11 @@ static const struct irq_domain_ops msi_domain_ops = {
 	.map = tegra_msi_map,
 };

-static int tegra_pcie_enable_msi(struct tegra_pcie *pcie)
+static int tegra_pcie_alloc_msi(struct tegra_pcie *pcie)
 {
 	struct platform_device *pdev = to_platform_device(pcie->dev);
-	const struct tegra_pcie_soc_data *soc = pcie->soc_data;
 	struct tegra_msi *msi = &pcie->msi;
-	unsigned long base;
 	int err;
-	u32 reg;

 	mutex_init(&msi->lock);

@@ -1368,6 +1372,21 @@ static int tegra_pcie_enable_msi(struct tegra_pcie *pcie)

 	/* setup AFI/FPCI range */
 	msi->pages = __get_free_pages(GFP_KERNEL, 0);
+
+	return 0;
+
+err:
+	irq_domain_remove(msi->domain);
+	return err;
+}
+
+static void tegra_pcie_enable_msi(struct tegra_pcie *pcie)
+{
+	const struct tegra_pcie_soc_data *soc = pcie->soc_data;
+	struct tegra_msi *msi = &pcie->msi;
+	unsigned long base;
+	u32 reg;
+
 	base = virt_to_phys((void *)msi->pages);

 	afi_writel(pcie, base >> soc->msi_base_shift, AFI_MSI_FPCI_BAR_ST);
@@ -1389,12 +1408,6 @@ static int tegra_pcie_enable_msi(struct tegra_pcie *pcie)
 	reg = afi_readl(pcie, AFI_INTR_MASK);
 	reg |= AFI_INTR_MASK_MSI_MASK;
 	afi_writel(pcie, reg, AFI_INTR_MASK);
-
-	return 0;
-
-err:
-	irq_domain_remove(msi->domain);
-	return err;
 }

 static int tegra_pcie_disable_msi(struct tegra_pcie *pcie)
@@ -1765,10 +1778,10 @@ retry:
 	return false;
 }

-static int tegra_pcie_enable(struct tegra_pcie *pcie)
+static int tegra_pcie_check_ports(struct tegra_pcie *pcie)
 {
 	struct tegra_pcie_port *port, *tmp;
-	struct hw_pci hw;
+	unsigned int num_ports = 0;

 	list_for_each_entry_safe(port, tmp, &pcie->ports, list) {
 		dev_info(pcie->dev, "probing port %u, using %u lanes\n",
@@ -1776,8 +1789,10 @@ static int tegra_pcie_enable(struct tegra_pcie *pcie)

 		tegra_pcie_port_enable(port);

-		if (tegra_pcie_port_check_link(port))
+		if (tegra_pcie_port_check_link(port)) {
+			num_ports++;
 			continue;
+		}

 		dev_info(pcie->dev, "link %u down, ignoring\n", port->index);

@@ -1785,6 +1800,16 @@ static int tegra_pcie_enable(struct tegra_pcie *pcie)
 		tegra_pcie_port_free(port);
 	}

+	return num_ports;
+}
+
+static int tegra_pcie_enable(struct tegra_pcie *pcie)
+{
+	struct hw_pci hw;
+
+	if (!tegra_pcie_check_ports(pcie))
+		return -ENODEV;
+
 	memset(&hw, 0, sizeof(hw));

 	hw.nr_controllers = 1;
@@ -2000,13 +2025,15 @@ static int tegra_pcie_probe(struct platform_device *pdev)
 	tegra_pcie_setup_translations(pcie);

 	if (IS_ENABLED(CONFIG_PCI_MSI)) {
-		err = tegra_pcie_enable_msi(pcie);
+		err = tegra_pcie_alloc_msi(pcie);
 		if (err < 0) {
 			dev_err(&pdev->dev,
-				"failed to enable MSI support: %d\n",
+				"failed to allocate MSI resources: %d\n",
 				err);
 			goto put_resources;
 		}
+
+		tegra_pcie_enable_msi(pcie);
 	}

 	err = tegra_pcie_enable(pcie);
@@ -2062,10 +2089,58 @@ static int tegra_pcie_remove(struct platform_device *pdev)
 	return 0;
 }

+#ifdef CONFIG_PM
+static int tegra_pcie_suspend_noirq(struct device *dev)
+{
+	struct tegra_pcie *pcie = dev_get_drvdata(dev);
+
+	tegra_pcie_power_off(pcie);
+
+	return 0;
+}
+
+static int tegra_pcie_resume_noirq(struct device *dev)
+{
+	struct tegra_pcie *pcie = dev_get_drvdata(dev);
+	int err;
+
+	err = tegra_pcie_power_on(pcie);
+	if (err < 0) {
+		dev_err(dev, "failed to power on: %d\n", err);
+		return err;
+	}
+
+	err = tegra_pcie_enable_controller(pcie);
+	if (err < 0)
+		goto poweroff;
+
+	tegra_pcie_setup_translations(pcie);
+
+	tegra_pcie_enable_msi(pcie);
+
+	if (!tegra_pcie_check_ports(pcie))
+		goto poweroff;
+
+	return 0;
+
+poweroff:
+	tegra_pcie_power_off(pcie);
+	return err;
+}
+
+static const struct dev_pm_ops tegra_pcie_pm_ops = {
+	.suspend_noirq  = tegra_pcie_suspend_noirq,
+	.resume_noirq = tegra_pcie_resume_noirq,
+};
+#else
+#define tegra_pcie_pm_ops NULL
+#endif /* CONFIG_PM */
+
 static struct platform_driver tegra_pcie_driver = {
 	.driver = {
 		.name = "tegra-pcie",
 		.owner = THIS_MODULE,
+		.pm = &tegra_pcie_pm_ops,
 		.of_match_table = tegra_pcie_of_match,
 	},
 	.probe = tegra_pcie_probe,
--
1.8.1.5

