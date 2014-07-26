Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760524AbaGZCoB (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jul 2014 22:44:01 -0400
Received: from szxga03-in.huawei.com ([119.145.14.66]:21120 "EHLO
	szxga03-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751858AbaGZCnm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jul 2014 22:43:42 -0400
From: Yijing Wang <wangyijing@huawei.com>
To: <linux-kernel@vger.kernel.org>
CC: Xinwei Hu <huxinwei@huawei.com>, Wuyun <wuyun.wu@huawei.com>,
        "Bjorn Helgaas" <bhelgaas@google.com>, <linux-pci@vger.kernel.org>,
        <Paul.Mundt@huawei.com>,
        "James E.J. Bottomley" <jejb@parisc-linux.org>,
        "Marc Zyngier" <marc.zyngier@arm.com>,
        <linux-arm-kernel@lists.infradead.org>,
        Russell King <linux@arm.linux.org.uk>, <linux-arch@vger.kernel.org>,
        <arnab.basu@freescale.com>,
        <virtualization@lists.linux-foundation.org>,
        Hanjun Guo <guohanjun@huawei.com>, Yijing Wang <wangyijing@huawei.com>
Subject: [RFC PATCH 00/11] Refactor MSI to support Non-PCI device
Date: Sat, 26 Jul 2014 11:08:37 +0800
Message-ID: <1406344128-27055-1-git-send-email-wangyijing@huawei.com>
X-Mailer: git-send-email 1.7.1
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.175.100.166]
X-CFilter-Loop: Reflected
X-Mirapoint-Virus-RAPID-Raw: score=unknown(0),
	refid=str=0001.0A020207.53D315DB.00AC,ss=1,re=0.000,fgs=0,
	ip=0.0.0.0,
	so=2013-05-26 15:14:31,
	dmn=2011-05-27 18:58:46
X-Mirapoint-Loop-Id: 39b909d89e996b4d6425cf1f836028ba
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all,
	The series is a draft of generic MSI driver that supports PCI
and Non-PCI device which have MSI capability. If you're not interested
it, sorry for the noise.

The series is based on Linux-3.16-rc1.

MSI was introduced in PCI Spec 2.2. Currently, kernel MSI 
driver codes are bonding with PCI device. Because MSI has a lot
advantages in design. More and more non-PCI devices want to
use MSI as their default interrupt. The existing MSI device
include HPET. HPET driver provide its own MSI code to initialize
and process MSI interrupts. In the latest GIC v3 spec, legacy device
can deliver MSI by the help of a relay device named consolidator.
Consolidator can translate the legacy interrupts connected to it
to MSI/MSI-X. And new non-PCI device will be designed to 
support MSI in future. So make the MSI driver code be generic will 
help the non-PCI device use MSI more simply.

The new data struct for generic MSI driver.
struct msi_irqs {
	u8 msi_enabled:1; /* Enable flag */
	u8 msix_enabled:1;
	struct list_head msi_list; /* MSI desc list */
	void *data;	/* help to find the MSI device */
	struct msi_ops *ops; /* MSI device specific hook */
};
struct msi_irqs is used to manage MSI related informations. Every device supports
MSI should contain this data struct and allocate it.

struct msi_ops {
	struct msi_desc *(*msi_setup_entry)(struct msi_irqs *msi, struct msi_desc *entry);
	int msix_setup_entries(struct msi_irqs *msi, struct msix_entry *entries);
	u32 (*msi_mask_irq)(struct msi_desc *desc, u32 mask, u32 flag);
	u32 (*msix_mask_irq)(struct msi_desc *desc, u32 flag);
	void (*msi_read_message)(struct msi_desc *desc, struct msi_msg *msg);
	void (*msi_write_message)(struct msi_desc *desc, struct msi_msg *msg);
	void (*msi_set_intx)(struct msi_irqs *msi, int enable);
};
struct msi_ops provides several hook functions, generic MSI driver will call
the hook functions to access device specific registers. PCI devices will share
the same msi_ops, because they have the same way to access MSI hardware registers.

Generic MSI layer export msi_capability_init() and msix_capability_init() functions
to drivers. msi/x_capability_init() will initialize MSI capability data struct msi_desc
and alloc the irq, then write the msi address/data value to hardware registers.

This series only did compile test, we will test it in x86 and arm platform later.

Any comments are welcome.

Thanks!
Yijing.




Yijing Wang (11):
  PCI/MSI: Use pci_dev->msi_cap instead of msi_desc->msi_attrib.pos
  PCI/MSI: Use new MSI type macro instead of PCI MSI flags
  PCI/MSI: Refactor pci_dev_msi_enabled()
  PCI/MSI: Move MSIX table address mapping out of msix_capability_init
  PCI/MSI: Move populate_msi_sysfs() out of msi_capability_init()
  PCI/MSI: Save MSI irq in PCI MSI layer
  PCI/MSI: Mask MSI-X entry in msix_setup_entries()
  PCI/MSI: Introduce new struct msi_irqs and struct msi_ops
  PCI/MSI: refactor PCI MSI driver
  PCI/MSI: Split the generic MSI code into new file
  x86/MSI: Refactor x86 MSI code

 arch/cris/arch-v32/drivers/pci/bios.c     |    2 +-
 arch/frv/mb93090-mb00/pci-vdk.c           |    2 +-
 arch/ia64/pci/pci.c                       |    4 +-
 arch/mips/pci/msi-octeon.c                |    8 +-
 arch/powerpc/kernel/eeh_driver.c          |    2 +-
 arch/powerpc/kernel/msi.c                 |    2 +-
 arch/powerpc/platforms/pseries/msi.c      |    8 +-
 arch/s390/pci/pci.c                       |    2 +-
 arch/x86/include/asm/io_apic.h            |    2 +-
 arch/x86/include/asm/irq_remapping.h      |    4 +-
 arch/x86/include/asm/pci.h                |    6 +-
 arch/x86/include/asm/x86_init.h           |   10 +-
 arch/x86/kernel/apic/io_apic.c            |   25 +-
 arch/x86/kernel/x86_init.c                |   12 +-
 arch/x86/pci/common.c                     |    5 +-
 arch/x86/pci/xen.c                        |   24 +-
 drivers/Kconfig                           |    1 +
 drivers/Makefile                          |    1 +
 drivers/block/nvme-core.c                 |    4 +-
 drivers/dma/ioat/dma.c                    |    2 +-
 drivers/firewire/ohci.c                   |    2 +-
 drivers/gpu/drm/i915/i915_dma.c           |    4 +-
 drivers/iommu/amd_iommu.c                 |   16 +-
 drivers/iommu/intel_irq_remapping.c       |    9 +-
 drivers/iommu/irq_remapping.c             |   53 ++--
 drivers/iommu/irq_remapping.h             |    6 +-
 drivers/irqchip/irq-armada-370-xp.c       |    2 +-
 drivers/misc/mei/hw-me.c                  |    2 +-
 drivers/misc/mei/hw-txe.c                 |    2 +-
 drivers/misc/mei/pci-me.c                 |    4 +-
 drivers/misc/mei/pci-txe.c                |    4 +-
 drivers/misc/mic/host/mic_debugfs.c       |    4 +-
 drivers/misc/mic/host/mic_intr.c          |    8 +-
 drivers/msi/Kconfig                       |    8 +
 drivers/msi/Makefile                      |    1 +
 drivers/msi/msi.c                         |  539 +++++++++++++++++++++++
 drivers/ntb/ntb_hw.c                      |    2 +-
 drivers/pci/Kconfig                       |    6 +-
 drivers/pci/host/pcie-designware.c        |    2 +-
 drivers/pci/irq.c                         |    4 +-
 drivers/pci/msi.c                         |  660 +++++++----------------------
 drivers/pci/pci.c                         |    6 +-
 drivers/pci/pcie/portdrv_core.c           |    4 +-
 drivers/scsi/esas2r/esas2r_init.c         |    4 +-
 drivers/scsi/esas2r/esas2r_ioctl.c        |    4 +-
 drivers/scsi/hpsa.c                       |    4 +-
 drivers/staging/crystalhd/crystalhd_lnx.c |    2 +-
 drivers/xen/xen-pciback/pciback_ops.c     |   12 +-
 include/linux/msi.h                       |   73 +++-
 include/linux/pci.h                       |   24 +-
 virt/kvm/assigned-dev.c                   |    2 +-
 51 files changed, 929 insertions(+), 670 deletions(-)
 create mode 100644 drivers/msi/Kconfig
 create mode 100644 drivers/msi/Makefile
 create mode 100644 drivers/msi/msi.c

