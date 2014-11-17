Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752217AbaKQJlF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Nov 2014 04:41:05 -0500
Received: from szxga03-in.huawei.com ([119.145.14.66]:22682 "EHLO
	szxga03-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752055AbaKQJkz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Nov 2014 04:40:55 -0500
From: Yijing Wang <wangyijing@huawei.com>
To: Bjorn Helgaas <bhelgaas@google.com>
CC: <linux-pci@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        Xinwei Hu <huxinwei@huawei.com>, Wuyun <wuyun.wu@huawei.com>,
        <linux-arm-kernel@lists.infradead.org>,
        Russell King <linux@arm.linux.org.uk>, <x86@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        <linuxppc-dev@lists.ozlabs.org>, Tony Luck <tony.luck@intel.com>,
        <linux-ia64@vger.kernel.org>,
        Thierry Reding <thierry.reding@gmail.com>,
        Liviu Dudau <liviu@dudau.co.uk>, <Suravee.Suthikulpanit@amd.com>,
        Yijing Wang <wangyijing@huawei.com>
Subject: [RFC PATCH 00/16] Refine PCI host bridge scan interfaces
Date: Mon, 17 Nov 2014 18:21:34 +0800
Message-ID: <1416219710-26088-1-git-send-email-wangyijing@huawei.com>
X-Mailer: git-send-email 1.7.1
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.175.100.166]
X-CFilter-Loop: Reflected
X-Mirapoint-Virus-RAPID-Raw: score=unknown(0),
	refid=str=0001.0A020209.5469C298.00EB,ss=1,re=0.001,recu=0.000,reip=0.000,cl=1,cld=1,fgs=0,
	ip=0.0.0.0,
	so=2013-05-26 15:14:31,
	dmn=2013-03-21 17:37:32
X-Mirapoint-Loop-Id: 2c58b73ae81d965aa4798307a5c18f28
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This series is based Linux 3.18-rc1 and Lorenzo Pieralisi's
arm PCI domain cleanup patches, link: 
https://patchwork.ozlabs.org/patch/407585/

Current pci scan interfaces like pci_scan_root_bus() and directly
call pci_create_root_bus()/pci_scan_child_bus() lack flexiblity.
Some platform infos like PCI domain and msi_chip have to be
associated to PCI bus by some arch specific function.
We want to make a generic pci_host_bridge, and make it hold
the platform infos or hook. Then we could eliminate the lots
of arch pci_domain_nr, also we could associate some platform 
ops something like pci_get_msi_chip(struct pci_dev *dev)
with pci_host_bridge to avoid introduce arch weak functions.

This RFC version not for all platforms, just applied the new
scan interface in x86/arm/powerpc/ia64, I will refresh other
platforms after the core pci scan interfaces are ok.

Only test in x86.

Thanks!
Yijing.

Yijing Wang (16):
  PCI: Enhance pci_scan_root_bus() to support default IO/MEM resources
  PCI: Use pci_scan_root_bus() instead of pci_scan_bus()
  PCI: Clean up pci_scan_bus()
  PCI: Rip out pci_bus_add_devices() from pci_scan_root_bus()
  PCI: Use pci_scan_root_bus() instead of pci_scan_bus_parented()
  PCI: Use u32 type to combine PCI domain and bus number
  PCI: Separate pci_host_bridge creation out of pci_create_root_bus()
  PCI: Introduce pci_scan_host_bridge() and pci_host_info
  PCI: Associate .get_msi_ctrl() with pci_host_bridge
  PCI: Add of_scan_bus() to pci_host_info
  x86/PCI: Use pci_scan_host_bridge() instead of pci_create_root_bus()
  ia64/PCI: Remove the redundant bus variable
  ia64/PCI: Use pci_scan_host_bridge() to refactor pci_acpi_scan_root()
  arm/PCI: Introduce pci_get_domain_nr()
  arm/PCI: Use pci_scan_host_bridge() instead of pci_scan_root_bus()
  powerpc/PCI: Use pci_scan_host_bridge() to scan PCI bus

 arch/alpha/include/asm/pci.h      |    2 +-
 arch/alpha/kernel/pci.c           |    1 +
 arch/alpha/kernel/sys_nautilus.c  |    3 +-
 arch/arm/include/asm/mach/pci.h   |   10 ++
 arch/arm/kernel/bios32.c          |   60 +++++++----
 arch/cris/include/asm/pci.h       |    2 +-
 arch/frv/mb93090-mb00/pci-vdk.c   |    8 +-
 arch/ia64/include/asm/pci.h       |    2 +-
 arch/ia64/pci/pci.c               |   85 +++++++--------
 arch/ia64/sn/kernel/io_init.c     |    2 +
 arch/m68k/coldfire/pci.c          |    3 +-
 arch/microblaze/pci/pci-common.c  |    2 +-
 arch/mips/include/asm/pci.h       |    2 +-
 arch/mips/pci/pci.c               |    1 +
 arch/mn10300/include/asm/pci.h    |    2 +-
 arch/mn10300/unit-asb2305/pci.c   |    7 +-
 arch/powerpc/kernel/pci-common.c  |   81 ++++++++------
 arch/s390/pci/pci.c               |    2 +-
 arch/sh/drivers/pci/pci.c         |    1 +
 arch/sh/include/asm/pci.h         |    2 +-
 arch/sparc/include/asm/pci_32.h   |    2 +-
 arch/sparc/include/asm/pci_64.h   |    2 +-
 arch/sparc/kernel/leon_pci.c      |    1 +
 arch/sparc/kernel/pcic.c          |    5 +-
 arch/tile/kernel/pci.c            |    3 +-
 arch/tile/kernel/pci_gx.c         |    3 +-
 arch/unicore32/kernel/pci.c       |    4 +-
 arch/x86/include/asm/pci.h        |    2 +-
 arch/x86/pci/acpi.c               |   65 +++++++-----
 arch/x86/pci/amd_bus.c            |    2 +-
 arch/x86/pci/common.c             |   27 ++++--
 arch/xtensa/include/asm/pci.h     |    2 +-
 arch/xtensa/kernel/pci.c          |    1 +
 drivers/parisc/dino.c             |    4 +-
 drivers/pci/host-bridge.c         |  104 ++++++++++++++++++
 drivers/pci/host/pci-xgene.c      |    2 +-
 drivers/pci/hotplug/ibmphp_core.c |    6 +-
 drivers/pci/probe.c               |  214 +++++++++++++++++++------------------
 drivers/pci/xen-pcifront.c        |    6 +-
 include/linux/pci.h               |   41 ++++++-
 include/uapi/linux/pci.h          |    3 +
 41 files changed, 497 insertions(+), 280 deletions(-)

