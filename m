Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932509AbaGASqx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Jul 2014 14:46:53 -0400
Received: from fw-tnat.cambridge.arm.com ([217.140.96.21]:50633 "EHLO
	cam-smtp0.cambridge.arm.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S932431AbaGASqt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Jul 2014 14:46:49 -0400
From: Liviu Dudau <Liviu.Dudau@arm.com>
To: linux-pci <linux-pci@vger.kernel.org>, Bjorn Helgaas <bhelgaas@google.com>,
        Catalin Marinas <Catalin.Marinas@arm.com>,
        Will Deacon <Will.Deacon@arm.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Arnd Bergmann <arnd@arndb.de>,
        linaro-kernel <linaro-kernel@lists.linaro.org>,
        Tanmay Inamdar <tinamdar@apm.com>,
        Grant Likely <grant.likely@secretlab.ca>,
        Sinan Kaya <okaya@codeaurora.org>, Jingoo Han <jg1.han@samsung.com>,
        Kukjin Kim <kgene.kim@samsung.com>,
        Suravee Suthikulanit <suravee.suthikulpanit@amd.com>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Device Tree ML <devicetree@vger.kernel.org>,
        LAKML <linux-arm-kernel@lists.infradead.org>
Subject: [PATCH] Add support for PCI in AArch64
Date: Tue,  1 Jul 2014 19:43:59 +0100
Message-Id: <1404240240-9856-1-git-send-email-Liviu.Dudau@arm.com>
X-Mailer: git-send-email 2.0.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

This patch adds support for PCI to AArch64. It is based on my v8 patch
that adds support for creating generic host bridge structure from
device tree. With that in place, I was able to boot a platform that
has PCIe host bridge support and use a PCIe network card.

Changes from v7:
  - Rebased to v3.16-rc3
  - Removed pci_ioremap_io() function as it is provided by my v8 generic
    PCI host bridge patches under a different name.

Changes from v6:
  - Guard the pci_domain_nr() inline implementation with #ifdef CONFIG_PCI as
    to avoid conflict with default empty version present in include/linux/pci.h.
    Thanks to Jingoo Han for catching this.

Changes from v5:
  - Removed pcibios_fixup_bridge_ranges() as the week default version is fine.
  - Removed the ALIGN() call in pcibios_align_resource()
  - Stopped exporting pcibios_align_resource()

Changes from v4:
  - Fixed the pci_domain_nr() implementation for arm64. Now we use
    find_pci_host_bride() to find the host bridge before we retrieve
    the domain number.

Changes from v3:
  - Added Acks accumulated so far ;)
  - Still carrying Catalin's patch for moving the PCI_IO_BASE until it
    lands in linux-next or mainline, in order to ease applying the series

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

v7 thread here: https://lkml.org/lkml/2014/3/14/320
v6 thread here: https://lkml.org/lkml/2014/3/5/41
v5 thread here: https://lkml.org/lkml/2014/3/4/307
v4 thread here: https://lkml.org/lkml/2014/3/3/298
v3 thread here: https://lkml.org/lkml/2014/2/28/211
v2 thread here: https://lkml.org/lkml/2014/2/27/255
v1 thread here: https://lkml.org/lkml/2014/2/3/389

The API used is different from the one used by ARM architecture. There is
no pci_common_init_dev() function and no hw_pci structure, as that is no
longer needed. Here is an example of what the probe function of a generic
host bridge could look like:


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
	if (IS_ERR(bridge)) {
		err = PTR_ERR(bridge);
		goto bridge_create_fail;
	}

	err = myhostbridge_setup(bridge->bus);
	if (err)
		goto bridge_setup_fail;

	/* We always enable PCI domains and we keep domain 0 backward
	 * compatible in /proc for video cards
	 */
	pci_add_flags(PCI_ENABLE_PROC_DOMAINS);
	pci_add_flags(PCI_REASSIGN_ALL_BUS | PCI_REASSIGN_ALL_RSRC);

	lastbus = pci_scan_child_bus(bridge->bus);
	pci_bus_update_busn_res_end(bridge->bus, lastbus);

	pci_assign_unassigned_bus_resources(bridge->bus);

	pci_bus_add_devices(bridge->bus);

	return 0;

bridge_setup_fail:
	put_device(&bridge->dev);
	device_unregister(&bridge->dev);
bridge_create_fail:
	kfree(pp);
	return err;
}


Liviu Dudau (1):
  arm64: Add architectural support for PCI

 arch/arm64/Kconfig            | 19 ++++++++++++++++-
 arch/arm64/include/asm/Kbuild |  1 +
 arch/arm64/include/asm/io.h   |  3 ++-
 arch/arm64/include/asm/pci.h  | 49 +++++++++++++++++++++++++++++++++++++++++++
 arch/arm64/kernel/Makefile    |  1 +
 arch/arm64/kernel/pci.c       | 38 +++++++++++++++++++++++++++++++++
 6 files changed, 109 insertions(+), 2 deletions(-)
 create mode 100644 arch/arm64/include/asm/pci.h
 create mode 100644 arch/arm64/kernel/pci.c

-- 
2.0.0

