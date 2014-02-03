Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753340AbaBCSfN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Feb 2014 13:35:13 -0500
Received: from fw-tnat.cambridge.arm.com ([217.140.96.21]:54652 "EHLO
	cam-smtp0.cambridge.arm.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753092AbaBCSfK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Feb 2014 13:35:10 -0500
From: Liviu Dudau <Liviu.Dudau@arm.com>
To: linux-pci <linux-pci@vger.kernel.org>, Bjorn Helgaas <bhelgaas@google.com>,
        Catalin Marinas <Catalin.Marinas@arm.com>,
        Will Deacon <Will.Deacon@arm.com>
Cc: LKML <linux-kernel@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        LAKML <linux-arm-kernel@lists.infradead.org>,
        linaro-kernel <linaro-kernel@lists.linaro.org>
Subject: [PATCH] [RFC] Support for creating generic host_bridge from device tree
Date: Mon,  3 Feb 2014 18:33:47 +0000
Message-Id: <1391452428-22917-1-git-send-email-Liviu.Dudau@arm.com>
X-Mailer: git-send-email 1.8.5.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

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
Liviu Dudau

[1] http://thread.gmane.org/gmane.linux.kernel.pci/25946

Liviu Dudau (1):
  pci: Add support for creating a generic host_bridge from device tree

 drivers/pci/host-bridge.c | 92 +++++++++++++++++++++++++++++++++++++++++++++++
 drivers/pci/probe.c       | 11 ++++++
 include/linux/pci.h       | 14 ++++++++
 3 files changed, 117 insertions(+)

-- 
1.8.5.3

