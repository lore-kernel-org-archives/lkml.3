Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754095AbaIHUEb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Sep 2014 16:04:31 -0400
Received: from quartz.orcorp.ca ([184.70.90.242]:53514 "EHLO quartz.orcorp.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752665AbaIHUEa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Sep 2014 16:04:30 -0400
Date: Mon, 8 Sep 2014 14:04:22 -0600
From: Jason Gunthorpe <jgunthorpe@obsidianresearch.com>
To: Bjorn Helgaas <bhelgaas@google.com>
Cc: Rostislav Lisovy <lisovy@gmail.com>, Russell King <linux@arm.linux.org.uk>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Murali Karicheri <m-karicheri2@ti.com>,
        Yijing Wang <wangyijing@huawei.com>,
        linux-arm <linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH RESEND] ARM: PCI: Use PCI_CLASS_* defines for PCI class
Message-ID: <20140908200422.GA6204@obsidianresearch.com>
References: <1410163532-31057-1-git-send-email-lisovy@gmail.com>
 <CAErSpo7sOc72V3g5tOov8Yj4nKiuJupaUTKEEecHMcqEUrzh_g@mail.gmail.com>
 <20140908180357.GA6159@obsidianresearch.com>
 <CAErSpo7QQMRFKSk4vQCkDeEQQXX87Gq5YAKR+P4bxxcqMSJeDw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAErSpo7QQMRFKSk4vQCkDeEQQXX87Gq5YAKR+P4bxxcqMSJeDw@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Broken-Reverse-DNS: no host name found for IP address 10.0.0.161
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 08, 2014 at 01:39:40PM -0600, Bjorn Helgaas wrote:

> > Essentially for that case the mvebu HW is a repurposed end port core,
> > so when working as a root port it presents an end port config space
> > (not a root port bridge config space). The BAR in that config space is
> > not relevant, so the old mvebu used code like this to hide it from the
> > PCI core. Otherwise the core will try to program it from the aperture,
> > and the default BAR size is really big, so it runs out of space.
> 
> How does mvebu deal with this now?  I don't see anything similar in
> pci-mvebu.c.

The new driver doesn't allow the core directly access to the end point
config space registers, the entire config space is managed by the
driver directly, exactly how the HW requires it to be set for root
port operation. The core sees the config space of a root port bridge
that is created by the driver.

> If the BAR is still a functioning PCI BAR, i.e., it decodes address
> space and potentially responds to accesses there, we really should pay
> attention to it.  That doesn't mean we have to assign space to it, but
> for example, we might want to make sure we have PCI_COMMAND_MEM turned
> off.  If we just clear out the resource start/end/flags, the PCI core
> doesn't have enough information to do that.

In mvebu land, the BAR does need to have a proper value. IIRC, with
the old driver the bootloader was expected to configure PCI to an
operational state, and the kernel was expected not to touch that BAR
register at all.

For mvebu the new driver explicitly sets that BAR properly like this:

        /* Setup BAR[1] to all DRAM banks. */
        mvebu_writel(port, dram->cs[0].base, PCIE_BAR_LO_OFF(1));
        mvebu_writel(port, 0, PCIE_BAR_HI_OFF(1));
        mvebu_writel(port, ((size - 1) & 0xffff0000) | 1,
                     PCIE_BAR_CTRL_OFF(1));

[Note: mvebu has a memory mapped alias for the end port config space,
 which is what PCIE_BAR_LO_OFF is referencing.]

Eg, it is matching the DRAM. This is because in an end port the BAR
claims incoming MemRd/MemWr TLPs, and for root port operation you want
the HW to claim all TLPs related to system memory.

The old driver (linux/arch/arm/mach-orion5x/pci.c) did this:

static void rc_pci_fixup(struct pci_dev *dev)
{
        /*
         * Prevent enumeration of root complex.
         */
        if (dev->bus->parent == NULL && dev->devfn == 0) {
                int i;

                for (i = 0; i < DEVICE_COUNT_RESOURCE; i++) {
                        dev->resource[i].start = 0;
                        dev->resource[i].end   = 0;
                        dev->resource[i].flags = 0;
                }
        }
}
DECLARE_PCI_FIXUP_HEADER(PCI_VENDOR_ID_MARVELL, PCI_ANY_ID, rc_pci_fixup);

Which seems very similar to what you quoted?

Jason
