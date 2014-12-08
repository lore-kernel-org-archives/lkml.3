Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754676AbaLHUMf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Dec 2014 15:12:35 -0500
Received: from foss-mx-na.foss.arm.com ([217.140.108.86]:46530 "EHLO
	foss-mx-na.foss.arm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751405AbaLHUMc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Dec 2014 15:12:32 -0500
From: Marc Zyngier <marc.zyngier@arm.com>
To: Bjorn Helgaas <bhelgaas@google.com>, Thomas Gleixner <tglx@linutronix.de>,
        Jiang Liu <jiang.liu@linux.intel.com>
Cc: <linux-arm-kernel@lists.infradead.org>, <linux-pci@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, Will Deacon <Will.Deacon@arm.com>,
        Yijing Wang <wangyijing@huawei.com>,
        Suravee Suthikulpanit <Suravee.Suthikulpanit@amd.com>
Subject: [PATCH 0/6] Introducing per-device MSI domain
Date: Mon,  8 Dec 2014 20:12:17 +0000
Message-Id: <1418069543-21969-1-git-send-email-marc.zyngier@arm.com>
X-Mailer: git-send-email 2.1.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

MSI-like interrupts are starting to creep out of the PCI world, and
can now be seen into a number of "platform"-type busses. The MSI
domain patches recognise that fact, and start providing a way to
implement this.

Another problem we have to solve is to identify which MSI domain a
device is "connected" to. Currently, PCI gets away with a mixture of
arch-specific callbacks, and a msi_controller structure that can
optionally carry a pointer to an MSI domain. As we add new bus types
and start dealing with topologies that do not map to what PCI does,
this doesn't scale anymore.

This patch series tries to address some of it by providing a basic
link between 'struct device' and an MSI domain. It also adds (yet
another) way for PCI to propagate the domain pointer through the PCI
device hierarchy, provides a method for OF to kickstart the
propagation process, and finally allows the PCI/MSI layer to use that
information. Hopefully this can serve as a model to implement support
for different but types.

Additionally, the last two patches use all the above to remove any
trace of the msi_controller structure from the two GIC interrupt
controllers we use on arm64, so that they solely rely on the above
infrastructure.

This has been tested on arm64 with GICv2m (AMD Seattle) and GICv3 ITS
(FVP model).

Patches are on top of 3.18-rc7 + tip/irq/irq-domain-arm, and available at:

git://git.kernel.org/pub/scm/linux/kernel/git/maz/arm-platforms.git irq/msi_domain

As always, comments most welcome.

	M.

Marc Zyngier (6):
  device core: Introduce per-device MSI domain pointer
  PCI/MSI: add hooks to populate the msi_domain field
  PCI/MSI: of: add support for OF-provided msi_domain
  PCI/MSI: Let pci_msi_get_domain use struct device's msi_domain
  irqchip: GICv2m: Get rid of struct msi_controller
  irqchip: gicv3-its: Get rid of struct msi_controller

 drivers/irqchip/irq-gic-v2m.c    | 26 +++++++++-----------------
 drivers/irqchip/irq-gic-v3-its.c | 29 ++++++++++++-----------------
 drivers/pci/msi.c                |  3 ++-
 drivers/pci/of.c                 | 15 +++++++++++++++
 drivers/pci/probe.c              | 25 +++++++++++++++++++++++++
 include/linux/device.h           | 20 ++++++++++++++++++++
 include/linux/pci.h              |  3 +++
 7 files changed, 86 insertions(+), 35 deletions(-)

-- 
2.1.3

