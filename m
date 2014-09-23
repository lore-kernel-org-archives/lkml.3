Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755821AbaIWOHA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Sep 2014 10:07:00 -0400
Received: from gw-1.arm.linux.org.uk ([78.32.30.217]:38982 "EHLO
	pandora.arm.linux.org.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753321AbaIWOG7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Sep 2014 10:06:59 -0400
Date: Tue, 23 Sep 2014 15:06:35 +0100
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Bjorn Helgaas <bhelgaas@google.com>
Cc: Vidya Sagar <sagar.tv@gmail.com>, Yijing Wang <wangyijing@huawei.com>,
        Thierry Reding <thierry.reding@gmail.com>,
        Jason Cooper <jason@lakedaemon.net>, Will Deacon <will.deacon@arm.com>,
        Stephen Warren <swarren@nvidia.com>, Krishna Thota <kthota@nvidia.com>,
        linux-arm <linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v4] ARM: fix debug prints relevant to PCI devices
Message-ID: <20140923140635.GR5182@n2100.arm.linux.org.uk>
References: <1410085687-11273-1-git-send-email-vidyas@nvidia.com> <CAErSpo7CX3XiuNZO8tXYVN2tUJudObFKVBthHfxf9mPS6hE6Cg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAErSpo7CX3XiuNZO8tXYVN2tUJudObFKVBthHfxf9mPS6hE6Cg@mail.gmail.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 23, 2014 at 07:56:01AM -0600, Bjorn Helgaas wrote:
> This doesn't require any coordination with the PCI core, so I was just
> leaving this up to the arch.  But I guess I can at least give you my
> opinion :)

However, PCI core people have more knowledge of the issues here than I do.

> > diff --git a/arch/arm/kernel/bios32.c b/arch/arm/kernel/bios32.c
> > index 17a26c1..03c56ba 100644
> > --- a/arch/arm/kernel/bios32.c
> > +++ b/arch/arm/kernel/bios32.c
> > @@ -290,6 +290,7 @@ void pcibios_fixup_bus(struct pci_bus *bus)
> >  {
> >         struct pci_dev *dev;
> >         u16 features = PCI_COMMAND_SERR | PCI_COMMAND_PARITY | PCI_COMMAND_FAST_BACK;
> > +       bool has_pcie_dev = false;
> >
> >         /*
> >          * Walk the devices on this bus, working out what we can
> > @@ -298,6 +299,8 @@ void pcibios_fixup_bus(struct pci_bus *bus)
> >         list_for_each_entry(dev, &bus->devices, bus_list) {
> >                 u16 status;
> >
> > +               if (!has_pcie_dev)
> > +                       has_pcie_dev = pci_is_pcie(dev);
> >                 pci_read_config_word(dev, PCI_STATUS, &status);
> >
> >                 /*
> > @@ -354,9 +357,11 @@ void pcibios_fixup_bus(struct pci_bus *bus)
> >
> >         /*
> >          * Report what we did for this bus
> > +        * (only if the bus doesn't have any PCIe devices)
> >          */
> > -       printk(KERN_INFO "PCI: bus%d: Fast back to back transfers %sabled\n",
> > -               bus->number, (features & PCI_COMMAND_FAST_BACK) ? "en" : "dis");
> > +       if (!has_pcie_dev)
> > +               pr_info("PCI: bus%d: Fast back to back transfers %sabled\n",
> > +                       bus->number, (features & PCI_COMMAND_FAST_BACK) ? "en" : "dis");
> 
> My first choice would be to just drop the printk altogether.

It can be useful information.

> If we want to keep the printk, it should be enough to test "bus->self
> && !pci_is_pcie(bus->self)" to see whether Fast Back-to-Back can be
> enabled.

This is exactly the kind of issue that needs to be picked up by core
PCI people.  I've not looked at PCI stuff for a long time, because PCI
isn't that relevent to me anymore, so I'm not up to speed with any PCI
API changes since about 2.6.xx days, and I'm certainly not knowledgable
of PCIe.  To a certain extent, that can be blamed on ARM's eval boards
either having fundamentally fscked and unusable PCIe, or ARM not
bothering to supply me PCI backplanes to be able to use them.

Isn't bus->self NULL for the PCI root bus, which would be one of the
buses which we /do/ want to print this information for.  So, wouldn't:

	!bus->self || !pci_is_pcie(bus->self)

be more correct?
 
> Personally, I would like to see everything in the file converted to
> use dev_printk so it's consistent with the PCI core.  That would be a
> separate patch, and there might be other instances under arch/arm,
> too.

It /was/ consistent with the PCI core, because the PCI core used to use
this formatting.  If you wish to keep it consistent, please submit a
patch to make it consistent /again/ with the core code.

-- 
FTTC broadband for 0.8mile line: currently at 9.5Mbps down 400kbps up
according to speedtest.net.
