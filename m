Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751528Ab3ARJ40 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jan 2013 04:56:26 -0500
Received: from service87.mimecast.com ([91.220.42.44]:59926 "EHLO
	service87.mimecast.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751156Ab3ARJ4X convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jan 2013 04:56:23 -0500
Date: Fri, 18 Jan 2013 09:56:20 +0000
From: Andrew Murray <andrew.murray@arm.com>
To: Thierry Reding <thierry.reding@avionic-design.de>
Cc: "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        Grant Likely <grant.likely@secretlab.ca>,
        "rob.herring@calxeda.com" <rob.herring@calxeda.com>,
        Russell King <linux@arm.linux.org.uk>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Jason Gunthorpe <jgunthorpe@obsidianresearch.com>,
        Arnd Bergmann <arnd@arndb.de>,
        Thomas Petazzoni <thomas.petazzoni@free-electrons.com>,
        "devicetree-discuss@lists.ozlabs.org" 
	<devicetree-discuss@lists.ozlabs.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>
Subject: Re: [PATCH 10/14] PCI: tegra: Move PCIe driver to drivers/pci/host
Message-ID: <20130118095620.GA7552@arm.com>
References: <1357764194-12677-1-git-send-email-thierry.reding@avionic-design.de>
 <1357764194-12677-11-git-send-email-thierry.reding@avionic-design.de>
MIME-Version: 1.0
In-Reply-To: <1357764194-12677-11-git-send-email-thierry.reding@avionic-design.de>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-OriginalArrivalTime: 18 Jan 2013 09:56:21.0377 (UTC) FILETIME=[118E9710:01CDF562]
X-MC-Unique: 113011809562203901
Content-Type: text/plain; charset=WINDOWS-1252
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 09, 2013 at 08:43:10PM +0000, Thierry Reding wrote:
> Move the PCIe driver from arch/arm/mach-tegra into the drivers/pci/host
> directory. The motivation is to collect various host controller drivers
> in the same location in order to facilitate refactoring.
> 
> The Tegra PCIe driver has been largely rewritten, both in order to turn
> it into a proper platform driver and to add MSI (based on code by
> Krishna Kishore <kthota@nvidia.com>) as well as device tree support.
> 
> Signed-off-by: Thierry Reding <thierry.reding@avionic-design.de>

[snip]

> +static int tegra_pcie_enable(struct tegra_pcie *pcie)
> +{
> +       struct hw_pci hw;
> +
> +       memset(&hw, 0, sizeof(hw));
> +
> +       hw.nr_controllers = 1;
> +       hw.private_data = (void **)&pcie;
> +       hw.setup = tegra_pcie_setup;
> +       hw.scan = tegra_pcie_scan_bus;
> +       hw.map_irq = tegra_pcie_map_irq;
> +
> +       pci_common_init(&hw);
> +
> +       return 0;
> +}

[snip]

> +static int tegra_pcie_probe(struct platform_device *pdev)
> +{
> +       struct device_node *port;
> +       struct tegra_pcie *pcie;
> +       int err;
> +
> +       pcie = devm_kzalloc(&pdev->dev, sizeof(*pcie), GFP_KERNEL);
> +       if (!pcie)
> +               return -ENOMEM;
> +
> +       INIT_LIST_HEAD(&pcie->ports);
> +       pcie->dev = &pdev->dev;
> +
> +       err = tegra_pcie_parse_dt(pcie);
> +       if (err < 0)
> +               return err;
> +
> +       pcibios_min_mem = 0;
> +
> +       err = tegra_pcie_get_resources(pcie);
> +       if (err < 0) {
> +               dev_err(&pdev->dev, "failed to request resources: %d\n", err);
> +               return err;
> +       }
> +
> +       err = tegra_pcie_enable_controller(pcie);
> +       if (err)
> +               goto put_resources;
> +
> +       /* probe root ports */
> +       for_each_child_of_node(pdev->dev.of_node, port) {
> +               if (!of_device_is_available(port))
> +                       continue;
> +
> +               err = tegra_pcie_add_port(pcie, port);
> +               if (err < 0) {
> +                       dev_err(&pdev->dev, "failed to add port %s: %d\n",
> +                               port->name, err);
> +               }
> +       }
> +
> +       /* setup the AFI address translations */
> +       tegra_pcie_setup_translations(pcie);
> +
> +       if (IS_ENABLED(CONFIG_PCI_MSI)) {
> +               err = tegra_pcie_enable_msi(pcie);
> +               if (err < 0) {
> +                       dev_err(&pdev->dev,
> +                               "failed to enable MSI support: %d\n",
> +                               err);
> +                       goto put_resources;
> +               }
> +       }
> +
> +       err = tegra_pcie_enable(pcie);
> +       if (err < 0) {
> +               dev_err(&pdev->dev, "failed to enable PCIe ports: %d\n", err);
> +               goto disable_msi;
> +       }
> +
> +       platform_set_drvdata(pdev, pcie);
> +       return 0;
> +
> +disable_msi:
> +       if (IS_ENABLED(CONFIG_PCI_MSI))
> +               tegra_pcie_disable_msi(pcie);
> +put_resources:
> +       tegra_pcie_put_resources(pcie);
> +       return err;
> +}
> +

[snip]

> +
> +static const struct of_device_id tegra_pcie_of_match[] = {
> +       { .compatible = "nvidia,tegra20-pcie", },
> +       { },
> +};
> +
> +static struct platform_driver tegra_pcie_driver = {
> +       .driver = {
> +               .name = "tegra-pcie",
> +               .owner = THIS_MODULE,
> +               .of_match_table = tegra_pcie_of_match,
> +       },
> +       .probe = tegra_pcie_probe,
> +       .remove = tegra_pcie_remove,
> +};
> +module_platform_driver(tegra_pcie_driver);

If you have multiple 'nvidia,tegra20-pcie's in your DT then you will end up
with multiple calls to tegra_pcie_probe/tegra_pcie_enable/pci_common_init.

However pci_common_init/pcibios_init_hw assumes it will only ever be called
once, and will thus result in trying to create multiple busses with the same
bus number. (The first root bus it creates is always zero provided you haven't
implemented hw->scan).

I have a patch for this if you want to fold it into your series? (I see you've
made changes to bios32 for per-controller data).

Andrew Murray

