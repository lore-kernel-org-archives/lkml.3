Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751824AbaIITcL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Sep 2014 15:32:11 -0400
Received: from mail-qc0-f172.google.com ([209.85.216.172]:36486 "EHLO
	mail-qc0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751692AbaIITcI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Sep 2014 15:32:08 -0400
MIME-Version: 1.0
In-Reply-To: <20140908200422.GA6204@obsidianresearch.com>
References: <1410163532-31057-1-git-send-email-lisovy@gmail.com>
 <CAErSpo7sOc72V3g5tOov8Yj4nKiuJupaUTKEEecHMcqEUrzh_g@mail.gmail.com>
 <20140908180357.GA6159@obsidianresearch.com> <CAErSpo7QQMRFKSk4vQCkDeEQQXX87Gq5YAKR+P4bxxcqMSJeDw@mail.gmail.com>
 <20140908200422.GA6204@obsidianresearch.com>
From: Bjorn Helgaas <bhelgaas@google.com>
Date: Tue, 9 Sep 2014 13:31:46 -0600
Message-ID: <CAErSpo56jB1Bf2JtYCGKXZBZqRF1jXFxGmeewPX_e6vSXueGyA@mail.gmail.com>
Subject: Re: [PATCH RESEND] ARM: PCI: Use PCI_CLASS_* defines for PCI class
To: Jason Gunthorpe <jgunthorpe@obsidianresearch.com>
Cc: Rostislav Lisovy <lisovy@gmail.com>, Russell King <linux@arm.linux.org.uk>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Murali Karicheri <m-karicheri2@ti.com>,
        Yijing Wang <wangyijing@huawei.com>,
        linux-arm <linux-arm-kernel@lists.infradead.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 8, 2014 at 2:04 PM, Jason Gunthorpe
<jgunthorpe@obsidianresearch.com> wrote:
> On Mon, Sep 08, 2014 at 01:39:40PM -0600, Bjorn Helgaas wrote:
>
>> > Essentially for that case the mvebu HW is a repurposed end port core,
>> > so when working as a root port it presents an end port config space
>> > (not a root port bridge config space). The BAR in that config space is
>> > not relevant, so the old mvebu used code like this to hide it from the
>> > PCI core. Otherwise the core will try to program it from the aperture,
>> > and the default BAR size is really big, so it runs out of space.

This is a bit of a tangent, but an endpoint has a type 0 config
header, while a root port is a bridge and has a type 1 config header.
I don't understand how the PCI core can operate a root port correctly
if that port has a type 0 config header.

>> How does mvebu deal with this now?  I don't see anything similar in
>> pci-mvebu.c.
>
> The new driver doesn't allow the core directly access to the end point
> config space registers, the entire config space is managed by the
> driver directly, exactly how the HW requires it to be set for root
> port operation. The core sees the config space of a root port bridge
> that is created by the driver.
>
>> If the BAR is still a functioning PCI BAR, i.e., it decodes address
>> space and potentially responds to accesses there, we really should pay
>> attention to it.  That doesn't mean we have to assign space to it, but
>> for example, we might want to make sure we have PCI_COMMAND_MEM turned
>> off.  If we just clear out the resource start/end/flags, the PCI core
>> doesn't have enough information to do that.
>
> In mvebu land, the BAR does need to have a proper value. IIRC, with
> the old driver the bootloader was expected to configure PCI to an
> operational state, and the kernel was expected not to touch that BAR
> register at all.
>
> For mvebu the new driver explicitly sets that BAR properly like this:
>
>         /* Setup BAR[1] to all DRAM banks. */
>         mvebu_writel(port, dram->cs[0].base, PCIE_BAR_LO_OFF(1));
>         mvebu_writel(port, 0, PCIE_BAR_HI_OFF(1));
>         mvebu_writel(port, ((size - 1) & 0xffff0000) | 1,
>                      PCIE_BAR_CTRL_OFF(1));
>
> [Note: mvebu has a memory mapped alias for the end port config space,
>  which is what PCIE_BAR_LO_OFF is referencing.]
>
> Eg, it is matching the DRAM. This is because in an end port the BAR
> claims incoming MemRd/MemWr TLPs, and for root port operation you want
> the HW to claim all TLPs related to system memory.
>
> The old driver (linux/arch/arm/mach-orion5x/pci.c) did this:
>
> static void rc_pci_fixup(struct pci_dev *dev)
> {
>         /*
>          * Prevent enumeration of root complex.
>          */
>         if (dev->bus->parent == NULL && dev->devfn == 0) {
>                 int i;
>
>                 for (i = 0; i < DEVICE_COUNT_RESOURCE; i++) {
>                         dev->resource[i].start = 0;
>                         dev->resource[i].end   = 0;
>                         dev->resource[i].flags = 0;
>                 }
>         }
> }
> DECLARE_PCI_FIXUP_HEADER(PCI_VENDOR_ID_MARVELL, PCI_ANY_ID, rc_pci_fixup);
>
> Which seems very similar to what you quoted?

I haven't worked with devices like this before, so pardon my ignorance.

It sounds like when these devices are configured as root ports, they
have BARs visible to the host, which is how dev->resource[] would get
filled in to begin with.  We manage normal BARs so the CPU can perform
MMIO accesses to the device.  In this case, it sounds like the BARs
are more for the benefit of devices below the bridge that want to
perform DMA.  The PCI core certainly wouldn't know what to do about
something like that, so I agree the best thing to do is to clear out
the resource completely and pretend it doesn't exist.  I guess a new
(not repurposed) design would probably put stuff like this in
device-specific config space, not in architected BARs.

Bjorn
