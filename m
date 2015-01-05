Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754681AbbAEW3N (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Jan 2015 17:29:13 -0500
Received: from mail-wg0-f53.google.com ([74.125.82.53]:35649 "EHLO
	mail-wg0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754383AbbAEW3K (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Jan 2015 17:29:10 -0500
MIME-Version: 1.0
In-Reply-To: <1758416.ZHsvLP471N@wuerfel>
References: <1420424374-32412-1-git-send-email-robh@kernel.org>
 <2224125.SvyFyDvrch@wuerfel> <CAL_JsqLGh-e2epUdtK07xM_2nwrRO_qcebD-zdCQjRGh9xnsAw@mail.gmail.com>
 <1758416.ZHsvLP471N@wuerfel>
From: Rob Herring <robh@kernel.org>
Date: Mon, 5 Jan 2015 16:28:48 -0600
X-Google-Sender-Auth: 9o7CjOeoVL3g9tPUaj2sE_SbNfQ
Message-ID: <CAL_JsqLOJSjE6MUgFe8Biz+MhdGUiZD+kAOWYTvnF1G5saa2wA@mail.gmail.com>
Subject: Re: [PATCH] pci: introduce common pci config space accessors
To: Arnd Bergmann <arnd@arndb.de>
Cc: "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Bjorn Helgaas <bhelgaas@google.com>, Will Deacon <will.deacon@arm.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 5, 2015 at 2:01 PM, Arnd Bergmann <arnd@arndb.de> wrote:
> On Monday 05 January 2015 08:46:09 Rob Herring wrote:
>>
>> >> diff --git a/include/linux/pci.h b/include/linux/pci.h
>> >> index 360a966..e7fd519 100644
>> >> --- a/include/linux/pci.h
>> >> +++ b/include/linux/pci.h
>> >> @@ -560,6 +560,7 @@ static inline int pcibios_err_to_errno(int err)
>> >>  /* Low-level architecture-dependent routines */
>> >>
>> >>  struct pci_ops {
>> >> +     void __iomem *(*map_bus)(struct pci_bus *bus, unsigned int devfn, int where);
>> >>       int (*read)(struct pci_bus *bus, unsigned int devfn, int where, int size, u32 *val);
>> >>       int (*write)(struct pci_bus *bus, unsigned int devfn, int where, int size, u32 val);
>> >>  };
>> >
>> > In various other contexts, we have recently discussed adding new callbacks
>> > to struct pci_host_bridge, or an operations structure below it. I don't see
>> > a strong reason for one place or the other, but maybe someone else does.
>> > If we put it into pci_host_bridge_ops, the first argument would need to
>> > be the pci_host_bridge pointer of course.
>>
>> I think it makes sense to keep map_bus together with read/write. Given
>> they are all host specific functions being part of pci_host_bridge
>> would make some sense. However, that would be a pretty painful change
>> across the tree (Have you seen how many PCI host implementations MIPS
>> has?).
>
> We could go wild and do both: if the bus has pci_ops, we use those,
> otherwise we fall back to the map_bus/read/write from pci_host_bridge_ops.

True. I'll leave it for Bjorn to weigh in.

>> > For the common map_bus implementations, it would also be nice to put them
>> > into the same file as your new access functions, but then we need a common
>> > location to store at least one __iomem pointer. I guess that place could
>> > either be struct pci_host_bridge or struct pci_bus. In theory, struct pci_ops
>> > would work too, but then we could no longer mark it 'const' in host bridge
>> > drivers.
>> >
>> > If we have a common set of map_bus functions, we can even export the
>> > pci_ops structures from drivers/pci/access.c:
>> >
>> > const struct pci_ops pci_generic_ecam_ops = {
>> >         .map_bus        = ecam_map_bus,
>> >         .read           = pci_generic_config_read,
>> >         .write          = pci_generic_config_write,
>> > };
>> > EXPORT_SYMBOL_GPL(pci_generic_ecam_ops);
>> >
>> > That could of course be done in a follow-up patch, it doesn't have to be
>> > part of your patch, but it would be good to be prepared.
>>
>> Right, this is what I had in mind for CAM/ECAM. I didn't go this far
>> because a lot of the map_bus functions do various checks to prevent
>> certain accesses. Of what I've found, I think only generic host and
>> Xilinx drivers could be converted to a generic ECAM map_bus. Others
>> check bus number and/or device number or link-up status or have a
>> fixup for certain registers, for example. I'm not sure how much of it
>> is unnecessary or could be common.
>
> How do you want to deal with the overrides? I don't see a way to
> do that in map_bus (with the current definition) if the idea is that
> for certain registers we return hardcoded values instead of accessing
> mmio registers.

It is not done in map_bus unless you want all FFs by returning NULL,
but by simply by wrapping the generic call with a host specific read
or write function. Here's one example that modifies one field in a
register. This means you can do any pre or post processing you need.
Even the crazy stuff Integrator PCI does.

static int cns3xxx_pci_read_config(struct pci_bus *bus, unsigned int devfn,
                                   int where, int size, u32 *val)
{
        u32 mask = (0x1ull << (size * 8)) - 1;
        int shift = (where % 4) * 8;

        ret = pci_generic_config_read32(bus, devfn, where, size, val);

        if (ret == PCIBIOS_SUCCESSFUL && bus->number == 0 && devfn == 0 &&
            (where & 0xffc) == PCI_CLASS_REVISION)
                /*
                 * RC's class is 0xb, but Linux PCI driver needs 0x604
                 * for a PCIe bridge. So we must fixup the class code
                 * to 0x604 here.
                 */
                *val = ((*val << shift) & 0xff) | (0x604 << 16)) >>
shift) & mask;

        return ret;
}

Rob
