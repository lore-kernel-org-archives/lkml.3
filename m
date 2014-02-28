Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752399AbaB1NJS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Feb 2014 08:09:18 -0500
Received: from fw-tnat.cambridge.arm.com ([217.140.96.21]:53727 "EHLO
	cam-smtp0.cambridge.arm.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751750AbaB1NJI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Feb 2014 08:09:08 -0500
From: Liviu Dudau <Liviu.Dudau@arm.com>
To: linux-pci <linux-pci@vger.kernel.org>, Bjorn Helgaas <bhelgaas@google.com>,
        Catalin Marinas <Catalin.Marinas@arm.com>,
        Will Deacon <Will.Deacon@arm.com>,
        linaro-kernel <linaro-kernel@lists.linaro.org>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        LKML <linux-kernel@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        LAKML <linux-arm-kernel@lists.infradead.org>
Subject: [PATCH v3 0/3] [RFC] Add support for PCI in AArch64
Date: Fri, 28 Feb 2014 13:08:30 +0000
Message-Id: <1393592913-24796-1-git-send-email-Liviu.Dudau@arm.com>
X-Mailer: git-send-email 1.9.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

This patch adds support for PCI to AArch64. It is based on my v3 patch
that adds support for creating generic host bridge structure from
device tree. With that in place, I was able to boot a platform that
has PCIe host bridge support and use a PCIe network card.

Changes from v2:
  - Implement an arch specific version of pci_register_io_range() and
    pci_address_to_pio().
  - Return 1 from pci_proc_domain().

Changes from v1:
  - Added Catalin's patch for moving the PCI_IO_BASE location and extend
    its size to 16MB
  - Integrated Arnd's version of pci_ioremap_io that uses a bitmap for
    keeping track of assigned IO space and returns an io_offset. At the
    moment the code is added in arch/arm64 but it can be moved in drivers/pci.
  - Added a fix for the generic ioport_map() function when !CONFIG_GENERIC_IOMAP
    as suggested by Arnd.

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
	struct myhostbridge_port *pp;
	resource_size_t lastbus;

	dev = pdev->dev.of_node;

	if (!of_device_is_available(dev)) {
		pr_warn("%s: disabled\n", dev->full_name);
		return -ENODEV;
	}

	pp = kzalloc(sizeof(struct myhostbridge_port), GFP_KERNEL);
	if (!pp)
		return -ENOMEM;

	bridge = of_create_pci_host_bridge(&pdev->dev, &myhostbridge_ops, pp);
	if (!bridge) {
		err = -EINVAL;
		goto bridge_init_fail;
	}

	err = myhostbridge_setup(bridge->bus);
	if (err)
		goto bridge_init_fail;

	/* We always enable PCI domains and we keep domain 0 backward
	 * compatible in /proc for video cards
	 */
	pci_add_flags(PCI_ENABLE_PROC_DOMAINS | PCI_COMPAT_DOMAIN_0);
	pci_add_flags(PCI_REASSIGN_ALL_BUS | PCI_REASSIGN_ALL_RSRC);

	lastbus = pci_scan_child_bus(bridge->bus);
	pci_bus_update_busn_res_end(bridge->bus, lastbus);

	pci_assign_unassigned_bus_resources(bridge->bus);

	pci_bus_add_devices(bridge->bus);

	return 0;

bridge_init_fail:
	kfree(pp);
	return err;
}


Best regards,
Liviu


Catalin Marinas (1):
  arm64: Extend the PCI I/O space to 16MB

Liviu Dudau (2):
  Fix ioport_map() for !CONFIG_GENERIC_IOMAP cases.
  arm64: Add architecture support for PCI

 Documentation/arm64/memory.txt |  16 ++--
 arch/arm64/Kconfig             |  19 ++++-
 arch/arm64/include/asm/Kbuild  |   1 +
 arch/arm64/include/asm/io.h    |   5 +-
 arch/arm64/include/asm/pci.h   |  47 +++++++++++
 arch/arm64/kernel/Makefile     |   1 +
 arch/arm64/kernel/pci.c        | 178 +++++++++++++++++++++++++++++++++++++++++
 include/asm-generic/io.h       |   2 +-
 8 files changed, 259 insertions(+), 10 deletions(-)
 create mode 100644 arch/arm64/include/asm/pci.h
 create mode 100644 arch/arm64/kernel/pci.c

-- 
1.9.0

