Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753326AbaBCSoX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Feb 2014 13:44:23 -0500
Received: from fw-tnat.cambridge.arm.com ([217.140.96.21]:52858 "EHLO
	cam-smtp0.cambridge.arm.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752309AbaBCSoT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Feb 2014 13:44:19 -0500
From: Liviu Dudau <Liviu.Dudau@arm.com>
To: linux-pci <linux-pci@vger.kernel.org>, Bjorn Helgaas <bhelgaas@google.com>,
        Catalin Marinas <Catalin.Marinas@arm.com>,
        Will Deacon <Will.Deacon@arm.com>
Cc: LKML <linux-kernel@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        LAKML <linux-arm-kernel@lists.infradead.org>,
        linaro-kernel <linaro-kernel@lists.linaro.org>,
        Arnd Bergmann <arnd@arndb.de>
Subject: [PATCH] [RFC] Add AArch64 support for PCI
Date: Mon,  3 Feb 2014 18:43:47 +0000
Message-Id: <1391453028-23191-1-git-send-email-Liviu.Dudau@arm.com>
X-Mailer: git-send-email 1.8.5.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

This patch adds support for PCI to AArch64. It is based on the patch posted
here [1] that adds support for creating generic host bridge structure from
device tree. With that in place, I was able to boot an FPGA platform that
has PCIe host bridge support and use a PCIe network card.

The API used is different from the one used by ARM architecture. There is
no pci_common_init_dev() function and no hw_pci structure, as that is no
longer needed. Once the last signature is added to the legal agreement, I
will post the host bridge driver code that I am using. Meanwhile, here
is an example of what the probe function looks like, posted as an example:

static int myhostbridge_probe(struct platform_device *pdev)
{
	int err;
	struct device_node *dev;
	struct pci_host_bridge *bridge;
	struct resource bus_range;
	struct myhostbridge_port *pp;
	LIST_HEAD(resources);

	dev = pdev->dev.of_node;

	if (!of_device_is_available(dev)) {
		pr_warn("%s: disabled\n", dev->full_name);
		return -ENODEV;
	}

	pp = kzalloc(sizeof(struct myhostbridge_port), GFP_KERNEL);
	if (!pp)
		return -ENOMEM;

	err = of_pci_parse_bus_range(dev, &bus_range);
	if (err) {
		bus_range.start = 0;
		bus_range.end = 255;
		bus_range.flags = IORESOURCE_BUS;
	}
	pci_add_resource(&resources, &bus_range);

	bridge = pci_host_bridge_of_init(&pdev->dev, 0, &myhostbridge_ops, pp, &resources);
	if (!bridge) {
		err = -EINVAL;
		goto bridge_init_fail;
	}

	err = myhostbridge_setup(bridge->bus);
	if (err)
		goto bridge_init_fail;

	/*
	 * Add flags here, this is just an example
	 */
	pci_add_flags(PCI_ENABLE_PROC_DOMAINS | PCI_COMPAT_DOMAIN_0);
	pci_add_flags(PCI_REASSIGN_ALL_BUS | PCI_REASSIGN_ALL_RSRC);

	bus_range.end = pci_scan_child_bus(bridge->bus);
	pci_bus_update_busn_res_end(bridge->bus, bus_range.end);

	pci_assign_unassigned_bus_resources(bridge->bus);

	pci_bus_add_devices(bridge->bus);

	return 0;

bridge_init_fail:
	kfree(pp);
	pci_free_resource_list(&resources);
	return err;
}

Best regards,
Liviu

[1] http://marc.info/?l=linux-pci&m=139145254821334&w=2

Liviu Dudau (1):
  arm64: Add support for PCI

 arch/arm64/Kconfig            |  17 +++++++
 arch/arm64/include/asm/Kbuild |   1 +
 arch/arm64/include/asm/io.h   |   4 ++
 arch/arm64/include/asm/pci.h  |  35 +++++++++++++
 arch/arm64/kernel/Makefile    |   1 +
 arch/arm64/kernel/pci.c       | 112 ++++++++++++++++++++++++++++++++++++++++++
 6 files changed, 170 insertions(+)
 create mode 100644 arch/arm64/include/asm/pci.h
 create mode 100644 arch/arm64/kernel/pci.c

-- 
1.8.5.3

