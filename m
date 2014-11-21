Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932559AbaKURUX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Nov 2014 12:20:23 -0500
Received: from mail-ie0-f170.google.com ([209.85.223.170]:40361 "EHLO
	mail-ie0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932493AbaKURUV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Nov 2014 12:20:21 -0500
Date: Fri, 21 Nov 2014 10:20:18 -0700
From: Bjorn Helgaas <bhelgaas@google.com>
To: Yijing Wang <wangyijing@huawei.com>, g@google.com
Cc: linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org,
        Xinwei Hu <huxinwei@huawei.com>, Wuyun <wuyun.wu@huawei.com>,
        linux-arm-kernel@lists.infradead.org,
        Russell King <linux@arm.linux.org.uk>,
        Thomas Gleixner <tglx@linutronix.de>,
        Thierry Reding <thierry.reding@gmail.com>,
        Thomas Petazzoni <thomas.petazzoni@free-electrons.com>,
        Marc Zyngier <marc.zyngier@arm.com>
Subject: Re: [PATCH 00/10] Save MSI chip in pci_sys_data
Message-ID: <20141121172018.GA6578@google.com>
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

[+cc Marc]

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

I reworked this series slightly to:

  - Change pci_msi_controller() and pcibios_msi_controller() from taking a
    pci_bus * to taking a pci_dev *.  This is so the interface allows
    per-device MSI controllers.  I don't think there's any reason to assume
    all devices on a bus have to have the same controller.

  - Drop the last patch ("PCI/MSI: Remove useless bus->msi assignment")
    because it broke Marc's follow-on patches.

I updated pci/msi, but I haven't put it in my "next" branch yet because I
want confirmation from Fengguang's autobuilder that I didn't break
anything.

Current status of my tree:

    6cf00af0ae15 [1] pci/msi (contains this rework)
    149792795d2b [2] next (does *not* contain this rework)

Thomas, if pci/msi looks good to you, feel free to pull it into your tree.
The only change you should need to make is to change the parameters to
pci_msi_controller() and pcibios_msi_controller().

Just FYI, I'm leaving on vacation for a week, so I won't be able to fix any
issues until Dec 1.

Bjorn

[1] https://git.kernel.org/cgit/linux/kernel/git/helgaas/pci.git/log/?h=next&id=6cf00af0ae15
[2] https://git.kernel.org/cgit/linux/kernel/git/helgaas/pci.git/log/?h=next&id=149792795d2b
