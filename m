Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753595AbaKQC7X (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Nov 2014 21:59:23 -0500
Received: from mail-ie0-f170.google.com ([209.85.223.170]:44418 "EHLO
	mail-ie0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751998AbaKQC7V (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Nov 2014 21:59:21 -0500
Date: Sun, 16 Nov 2014 19:59:14 -0700
From: Bjorn Helgaas <bhelgaas@google.com>
To: Yijing Wang <wangyijing@huawei.com>, g@google.com
Cc: linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org,
        Xinwei Hu <huxinwei@huawei.com>, Wuyun <wuyun.wu@huawei.com>,
        linux-arm-kernel@lists.infradead.org,
        Russell King <linux@arm.linux.org.uk>,
        Thomas Gleixner <tglx@linutronix.de>,
        Thierry Reding <thierry.reding@gmail.com>,
        Thomas Petazzoni <thomas.petazzoni@free-electrons.com>,
        Marc Zyngier <marc.zyngier@arm.com>,
        Yingjoe Chen <yingjoe.chen@mediatek.com>
Subject: Re: [PATCH 00/10] Save MSI chip in pci_sys_data
Message-ID: <20141117025914.GC4280@google.com>
References: <1414396127-30023-1-git-send-email-wangyijing@huawei.com>
 <20141112042359.GK28161@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20141112042359.GK28161@google.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[+cc Marc, Yingjoe]

On Tue, Nov 11, 2014 at 09:23:59PM -0700, Bjorn Helgaas wrote:
> On Mon, Oct 27, 2014 at 03:48:37PM +0800, Yijing Wang wrote:
> > Now PCI host bridge drivers in arm associate MSI chip and
> > PCI bus by adding .add_bus(), and assign MSI chip pointer
> > to every PCI bus. Associating MSI chip and every PCI bus
> > is not necessary. All PCI busses under same PCI host brdige
> > share the same MSI chip. So saving MSI chip in pci_sys_data
> > is a better solution, it make PCI host bridge drivers clean.
> > Because we still need to provide arch spec pcibios_msi_controller()
> > to extract MSI controller pointer, a better solution is to
> > refactor PCI host bridge, make a generic pci_host_bridge, and
> > save common info like PCI domain number, MSI chip, resources
> > in it. We will do that work in another series as soon.
> > 
> > To Bjorn: Because struct msi_chip defined in struct hw_pci and pci_sys_data
> > is under the #ifdef CONFIG_PCI_MSI, if we use if(IS_ENABLED(CONFIG_PCI_MSI))
> > in PCI host bridge drivers, it will cause build errors when the CONFIG_PCI_MSI
> > is off. So I keep #ifdef CONFIG_PCI_MSI in this series.
> > 
> > Yijing Wang (10):
> >   MSI: Rename msi_chip to msi_controller for better readability
> >   PCI/MSI: Introduce weak pcibios_msi_controller()
> >   arm/MSI: Save MSI controller in pci_sys_data
> >   PCI: tegra: Save MSI controller in pci_sys_data
> >   PCI: designware: Save MSI controller in pci_sys_data
> >   PCI: rcar: Save MSI controller in pci_sys_data
> >   PCI: mvebu: Save MSI controller in pci_sys_data
> >   PCI: xilinx: Save MSI controller in pci_sys_data
> >   arm/PCI: Clean unused pcibios_add_bus() and pcibios_remove_bus()
> >   PCI/MSI: Remove useless bus->msi assignment
> > 
> >  arch/arm/include/asm/mach/pci.h     |   10 +++++---
> >  arch/arm/kernel/bios32.c            |   28 ++++++++++--------------
> >  drivers/irqchip/irq-armada-370-xp.c |   22 +++++++++---------
> >  drivers/of/of_pci.c                 |   40 +++++++++++++++++-----------------
> >  drivers/pci/host/pci-keystone-dw.c  |    4 +-
> >  drivers/pci/host/pci-keystone.h     |    2 +-
> >  drivers/pci/host/pci-mvebu.c        |   14 ++++-------
> >  drivers/pci/host/pci-tegra.c        |   37 +++++++++++++-------------------
> >  drivers/pci/host/pcie-designware.c  |   25 +++++++--------------
> >  drivers/pci/host/pcie-designware.h  |    2 +-
> >  drivers/pci/host/pcie-rcar.c        |   37 +++++++++++++-------------------
> >  drivers/pci/host/pcie-xilinx.c      |   27 +++++++----------------
> >  drivers/pci/msi.c                   |   22 ++++++++++++++-----
> >  drivers/pci/probe.c                 |    1 -
> >  include/linux/msi.h                 |    6 ++--
> >  include/linux/of_pci.h              |   14 ++++++------
> >  include/linux/pci.h                 |    2 +-
> >  17 files changed, 132 insertions(+), 161 deletions(-)
> > 
> 
> Applied to pci/msi for v3.19, thanks.

This series is currently in the pci "next" branch, but the fact that there
are so many MSI-related changes from so many people makes me worry that
we're heading for a merge problem.

Here are the outstanding IRQ- and MSI-related things I've seen:

  Marc   10/25 [00/03] genirq: Add support for "split-EOI" irqchips
  Yijing 10/27 [00/10] Save MSI chip in pci_sys_data
  Yijing 10/27 [00/16] Use MSI controller framework to configure MSI/MSI-X
  Jiang  10/27 [Part1 v3 00/20] Prepare for enabling hierarchy irqdomain on x86
  Jiang  11/02 [v8 00/18] Enable support of IOAPIC hotplug on x86 platforms
  Jiang  11/06 [Part2 v5 00/31] Enable hierarchy irqdomian on x86 platforms
  Jiang  11/09 [Part3 v3 00/38] Enable hierarchy irqdomian on x86 platforms
  Marc   11/11 [00/15] arm64: PCI/MSI: GICv3 ITS support (stacked domain edition)
  Thomas 11/12 [00/16] genirq: Hierarchical irq domains and generic MSI interrupt code
  Jiang  11/15 [V2 00/09] Refine generic/PCI MSI irqodmian interfaces
  Marc   11/15 [00/02] Stacked domains and MSI improvements

PCI is only a minor participant, and I certainly don't have the expertise
to deal with all this, so I suspect that I should just drop these from the
PCI tree and let Thomas deal with them.  It seems like it would make more
sense to get all this stuff merged together in a single tree rather than
having some come via PCI and others come from via other trees.

Bjorn
