Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753652AbbAEOqd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Jan 2015 09:46:33 -0500
Received: from mail-wg0-f41.google.com ([74.125.82.41]:62359 "EHLO
	mail-wg0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753268AbbAEOqb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Jan 2015 09:46:31 -0500
MIME-Version: 1.0
In-Reply-To: <2224125.SvyFyDvrch@wuerfel>
References: <1420424374-32412-1-git-send-email-robh@kernel.org> <2224125.SvyFyDvrch@wuerfel>
From: Rob Herring <robh@kernel.org>
Date: Mon, 5 Jan 2015 08:46:09 -0600
X-Google-Sender-Auth: QlXDk8fCAnxJ8m3cGnNe0OIksBk
Message-ID: <CAL_JsqLGh-e2epUdtK07xM_2nwrRO_qcebD-zdCQjRGh9xnsAw@mail.gmail.com>
Subject: Re: [PATCH] pci: introduce common pci config space accessors
To: Arnd Bergmann <arnd@arndb.de>
Cc: "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Bjorn Helgaas <bhelgaas@google.com>, Will Deacon <will.deacon@arm.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 5, 2015 at 3:16 AM, Arnd Bergmann <arnd@arndb.de> wrote:
> On Sunday 04 January 2015 20:19:34 Rob Herring wrote:
>> Many PCI controllers' configuration space accesses are memory mapped
>> varying only in address calculation and access checks. There are 2 main
>> access methods: a decoded address space such as ECAM or a single address
>> and data register similar to x86. This implementation can support both
>> cases as well as be used in cases that need additional pre or post access
>> handling.
>>
>> A new pci_ops member map_bus is introduced which can do access checks and
>> any necessary setup. It returns the address to use for the configuration
>> space access. The access types supported are 32-bit only accesses or
>> correct byte, word, or dword sized accesses.
>>
>> Signed-off-by: Rob Herring <robh@kernel.org>
>
> I think this looks very nice, and I don't mind using it as-is, but I'd
> like to put up some variations for discussions so we get the best
> implementation -- we should try not to change it again soon if someone
> comes up with a slightly better way later ;-)
>
>> I've converted a few drivers already. I'll send patches for them after
>> some feedback on this. Most already have some function similar to what is
>> needed for map_bus, so the conversion is pretty simple. This certainly
>> isn't a complete list of possible users. The diffstat so far looks like
>> this:
>>
>>  arch/arm/mach-cns3xxx/pcie.c          |  46 +++-------------------
>>  arch/arm/mach-integrator/pci_v3.c     |  61 +++---------------------------
>>  arch/arm/mach-ks8695/pci.c            |  75 +++---------------------------------
>>  arch/arm/mach-sa1100/pci-nanoengine.c |  94 ++++-----------------------------------------
>>  arch/powerpc/platforms/powermac/pci.c | 206 +++++++++++++++++++--------------------------------------------------------------------------------
>>  arch/powerpc/sysdev/fsl_pci.c         |  46 ++--------------------
>>  drivers/pci/host/pci-host-generic.c   |  51 ++-----------------------
>>  drivers/pci/host/pci-rcar-gen2.c      |  51 ++-----------------------
>>  drivers/pci/host/pci-tegra.c          |  55 ++-------------------------
>>  drivers/pci/host/pci-xgene.c          | 150 +++++-------------------------------------------------------------------
>>  drivers/pci/host/pcie-xilinx.c        |  88 +++++-------------------------------------
>>  11 files changed, 93 insertions(+), 830 deletions(-)
>
> Awesome!
>
>> +int pci_generic_config_read(struct pci_bus *bus, unsigned int devfn,
>> +                         int where, int size, u32 *val)
>> +{
>> +     void __iomem *addr;
>> +
>> +     addr = bus->ops->map_bus(bus, devfn, where);
>> +     if (!addr) {
>> +             *val = ~0;
>> +             return PCIBIOS_DEVICE_NOT_FOUND;
>> +     }
>> +
>> +     if (size == 1)
>> +             *val = readb(addr);
>> +     else if (size == 2)
>> +             *val = readw(addr);
>> +     else
>> +             *val = readl(addr);
>> +
>> +     return PCIBIOS_SUCCESSFUL;
>> +}
>
> PCI host controller drivers can be loadable modules these days, so
> the functions clearly need to be exported.

Ah, yes.

>> diff --git a/include/linux/pci.h b/include/linux/pci.h
>> index 360a966..e7fd519 100644
>> --- a/include/linux/pci.h
>> +++ b/include/linux/pci.h
>> @@ -560,6 +560,7 @@ static inline int pcibios_err_to_errno(int err)
>>  /* Low-level architecture-dependent routines */
>>
>>  struct pci_ops {
>> +     void __iomem *(*map_bus)(struct pci_bus *bus, unsigned int devfn, int where);
>>       int (*read)(struct pci_bus *bus, unsigned int devfn, int where, int size, u32 *val);
>>       int (*write)(struct pci_bus *bus, unsigned int devfn, int where, int size, u32 val);
>>  };
>
> In various other contexts, we have recently discussed adding new callbacks
> to struct pci_host_bridge, or an operations structure below it. I don't see
> a strong reason for one place or the other, but maybe someone else does.
> If we put it into pci_host_bridge_ops, the first argument would need to
> be the pci_host_bridge pointer of course.

I think it makes sense to keep map_bus together with read/write. Given
they are all host specific functions being part of pci_host_bridge
would make some sense. However, that would be a pretty painful change
across the tree (Have you seen how many PCI host implementations MIPS
has?).

> For the common map_bus implementations, it would also be nice to put them
> into the same file as your new access functions, but then we need a common
> location to store at least one __iomem pointer. I guess that place could
> either be struct pci_host_bridge or struct pci_bus. In theory, struct pci_ops
> would work too, but then we could no longer mark it 'const' in host bridge
> drivers.
>
> If we have a common set of map_bus functions, we can even export the
> pci_ops structures from drivers/pci/access.c:
>
> const struct pci_ops pci_generic_ecam_ops = {
>         .map_bus        = ecam_map_bus,
>         .read           = pci_generic_config_read,
>         .write          = pci_generic_config_write,
> };
> EXPORT_SYMBOL_GPL(pci_generic_ecam_ops);
>
> That could of course be done in a follow-up patch, it doesn't have to be
> part of your patch, but it would be good to be prepared.

Right, this is what I had in mind for CAM/ECAM. I didn't go this far
because a lot of the map_bus functions do various checks to prevent
certain accesses. Of what I've found, I think only generic host and
Xilinx drivers could be converted to a generic ECAM map_bus. Others
check bus number and/or device number or link-up status or have a
fixup for certain registers, for example. I'm not sure how much of it
is unnecessary or could be common.

Rob
