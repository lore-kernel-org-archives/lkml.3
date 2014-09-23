Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932126AbaIWP4n (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Sep 2014 11:56:43 -0400
Received: from mail-qg0-f52.google.com ([209.85.192.52]:51665 "EHLO
	mail-qg0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752169AbaIWP4l (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Sep 2014 11:56:41 -0400
MIME-Version: 1.0
In-Reply-To: <20140923150407.GJ5982@ulmo>
References: <1410085687-11273-1-git-send-email-vidyas@nvidia.com>
 <CAErSpo7CX3XiuNZO8tXYVN2tUJudObFKVBthHfxf9mPS6hE6Cg@mail.gmail.com>
 <20140923140635.GR5182@n2100.arm.linux.org.uk> <20140923150407.GJ5982@ulmo>
From: Bjorn Helgaas <bhelgaas@google.com>
Date: Tue, 23 Sep 2014 09:56:21 -0600
Message-ID: <CAErSpo7_7n2TLuFPVaf7P4wR+zK0B55gsdsJRbGdAZOzJfC4dw@mail.gmail.com>
Subject: Re: [PATCH v4] ARM: fix debug prints relevant to PCI devices
To: Thierry Reding <thierry.reding@gmail.com>
Cc: Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Vidya Sagar <sagar.tv@gmail.com>, Yijing Wang <wangyijing@huawei.com>,
        Jason Cooper <jason@lakedaemon.net>, Will Deacon <will.deacon@arm.com>,
        Stephen Warren <swarren@nvidia.com>, Krishna Thota <kthota@nvidia.com>,
        linux-arm <linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 23, 2014 at 9:04 AM, Thierry Reding
<thierry.reding@gmail.com> wrote:
> On Tue, Sep 23, 2014 at 03:06:35PM +0100, Russell King - ARM Linux wrote:
>> On Tue, Sep 23, 2014 at 07:56:01AM -0600, Bjorn Helgaas wrote:
>> > This doesn't require any coordination with the PCI core, so I was just
>> > leaving this up to the arch.  But I guess I can at least give you my
>> > opinion :)
>>
>> However, PCI core people have more knowledge of the issues here than I do.
>>
>> > > diff --git a/arch/arm/kernel/bios32.c b/arch/arm/kernel/bios32.c
>> > > index 17a26c1..03c56ba 100644
>> > > --- a/arch/arm/kernel/bios32.c
>> > > +++ b/arch/arm/kernel/bios32.c
>> > > @@ -290,6 +290,7 @@ void pcibios_fixup_bus(struct pci_bus *bus)
>> > >  {
>> > >         struct pci_dev *dev;
>> > >         u16 features = PCI_COMMAND_SERR | PCI_COMMAND_PARITY | PCI_COMMAND_FAST_BACK;
>> > > +       bool has_pcie_dev = false;
>> > >
>> > >         /*
>> > >          * Walk the devices on this bus, working out what we can
>> > > @@ -298,6 +299,8 @@ void pcibios_fixup_bus(struct pci_bus *bus)
>> > >         list_for_each_entry(dev, &bus->devices, bus_list) {
>> > >                 u16 status;
>> > >
>> > > +               if (!has_pcie_dev)
>> > > +                       has_pcie_dev = pci_is_pcie(dev);
>> > >                 pci_read_config_word(dev, PCI_STATUS, &status);
>> > >
>> > >                 /*
>> > > @@ -354,9 +357,11 @@ void pcibios_fixup_bus(struct pci_bus *bus)
>> > >
>> > >         /*
>> > >          * Report what we did for this bus
>> > > +        * (only if the bus doesn't have any PCIe devices)
>> > >          */
>> > > -       printk(KERN_INFO "PCI: bus%d: Fast back to back transfers %sabled\n",
>> > > -               bus->number, (features & PCI_COMMAND_FAST_BACK) ? "en" : "dis");
>> > > +       if (!has_pcie_dev)
>> > > +               pr_info("PCI: bus%d: Fast back to back transfers %sabled\n",
>> > > +                       bus->number, (features & PCI_COMMAND_FAST_BACK) ? "en" : "dis");
>> >
>> > My first choice would be to just drop the printk altogether.
>>
>> It can be useful information.
>>
>> > If we want to keep the printk, it should be enough to test "bus->self
>> > && !pci_is_pcie(bus->self)" to see whether Fast Back-to-Back can be
>> > enabled.
>>
>> This is exactly the kind of issue that needs to be picked up by core
>> PCI people.
>
> I agree. Wouldn't it be more useful to move this into the core?
> Disabling fast back-to-back transfers hardly seems like an ARM-
> specific "fixup" to me.

I would definitely support moving this into the core.
