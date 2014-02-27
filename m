Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752900AbaB0NH1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Feb 2014 08:07:27 -0500
Received: from fw-tnat.cambridge.arm.com ([217.140.96.21]:52914 "EHLO
	cam-smtp0.cambridge.arm.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751026AbaB0NHS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Feb 2014 08:07:18 -0500
From: Liviu Dudau <Liviu.Dudau@arm.com>
To: linux-pci <linux-pci@vger.kernel.org>, Bjorn Helgaas <bhelgaas@google.com>,
        Catalin Marinas <Catalin.Marinas@arm.com>,
        Will Deacon <Will.Deacon@arm.com>,
        linaro-kernel <linaro-kernel@lists.linaro.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        LAKML <linux-arm-kernel@lists.infradead.org>
Subject: [PATCH v2 0/4] [RFC] Support for creating generic host_bridge from device tree
Date: Thu, 27 Feb 2014 13:06:38 +0000
Message-Id: <1393506402-11474-1-git-send-email-Liviu.Dudau@arm.com>
X-Mailer: git-send-email 1.9.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is v2 of my attempt to add support for a generic pci_host_bridge controller created
from a description passed in the device tree.

Changes from v1:
  - Add patch to fix conversion of IO ranges into IO resources.
  - Added a domain_nr member to pci_host_bridge structure, and a new function
    to create a root bus in a given domain number. In order to facilitate that
    I propose changing the order of initialisation between pci_host_bridge and
    it's related bus in pci_create_root_bus() as sort of a rever of 7b5436635800.
    This is done in patch 1/4 and 2/4.
  - Added a simple allocator of domain numbers in drivers/pci/host-bridge.c. The
    code will first try to get a domain id from of_alias_get_id(..., "pci-domain")
    and if that fails assign the next unallocated domain id.
  - Changed the name of the function that creates the generic host bridge from
    pci_host_bridge_of_init to of_create_pci_host_bridge and exported as GPL symbol.

v1 thread here: https://lkml.org/lkml/2014/2/3/380

The following is an edit of the original blurb:

Following the discussion started here [1], I now have a proposal for tackling
generic support for host bridges described via device tree. It is an initial
stab at it, to try to get feedback and suggestions, but it is functional enough
that I have PCI Express for arm64 working on an FPGA using the patch that I am
also publishing that adds support for PCI for that platform.

Looking at the existing architectures that fit the requirements (use of device
tree and PCI) yields the powerpc and microblaze as generic enough to make them
candidates for conversion. I have a tentative patch for microblaze that I can
only compile test it, unfortunately using qemu-microblaze leads to an early
crash in the kernel.

As Bjorn has mentioned in the previous discussion, the idea is to add to
struct pci_host_bridge enough data to be able to reduce the size or remove the
architecture specific pci_controller structure. arm64 support actually manages
to get rid of all the architecture static data and has no pci_controller structure
defined. For host bridge drivers that means a change of API unless architectures
decide to provide a compatibility layer (comments here please).

In order to initialise a host bridge with the new API, the following example
code is sufficient for a _probe() function:

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

[1] http://thread.gmane.org/gmane.linux.kernel.pci/25946

Best regards,
Liviu


Liviu Dudau (4):
  pci: OF: Fix the conversion of IO ranges into IO resources.
  pci: Create pci_host_bridge before its associated bus in pci_create_root_bus.
  pci: Introduce a domain number for pci_host_bridge.
  pci: Add support for creating a generic host_bridge from device tree

 drivers/of/address.c       |  31 +++++++++++
 drivers/pci/host-bridge.c  | 134 +++++++++++++++++++++++++++++++++++++++++++++
 drivers/pci/probe.c        |  66 ++++++++++++++--------
 include/linux/of_address.h |  13 +----
 include/linux/pci.h        |  17 ++++++
 5 files changed, 227 insertions(+), 34 deletions(-)

-- 
1.9.0

