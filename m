Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752716AbaCSRxQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Mar 2014 13:53:16 -0400
Received: from mail-vc0-f169.google.com ([209.85.220.169]:49355 "EHLO
	mail-vc0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751152AbaCSRxN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Mar 2014 13:53:13 -0400
MIME-Version: 1.0
In-Reply-To: <20140319172140.GA16328@e106497-lin.cambridge.arm.com>
References: <1394811258-1500-1-git-send-email-Liviu.Dudau@arm.com>
	<1394811258-1500-4-git-send-email-Liviu.Dudau@arm.com>
	<20140314171457.GK18126@arm.com>
	<201403141838.08900.arnd@arndb.de>
	<20140314180527.GZ6457@e106497-lin.cambridge.arm.com>
	<20140317173821.GJ24070@arm.com>
	<20140317180525.GL6457@e106497-lin.cambridge.arm.com>
	<20140319135619.GC6231@localhost>
	<20140319172140.GA16328@e106497-lin.cambridge.arm.com>
Date: Wed, 19 Mar 2014 12:53:11 -0500
Message-ID: <CAL_JsqJCa6kz8H_W7vz4YW5eOrOZ43kwxQq9Uh-M0qpCtW_pQQ@mail.gmail.com>
Subject: Re: [PATCH v7 3/3] arm64: Add architecture support for PCI
From: Rob Herring <robherring2@gmail.com>
To: Catalin Marinas <catalin.marinas@arm.com>, Arnd Bergmann <arnd@arndb.de>,
        linux-pci <linux-pci@vger.kernel.org>,
        Bjorn Helgaas <bhelgaas@google.com>, Will Deacon <Will.Deacon@arm.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        linaro-kernel <linaro-kernel@lists.linaro.org>,
        LKML <linux-kernel@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        LAKML <linux-arm-kernel@lists.infradead.org>,
        Tanmay Inamdar <tinamdar@apm.com>,
        Grant Likely <grant.likely@secretlab.ca>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 19, 2014 at 12:21 PM, Liviu Dudau <Liviu.Dudau@arm.com> wrote:
> On Wed, Mar 19, 2014 at 01:56:19PM +0000, Catalin Marinas wrote:
>> On Mon, Mar 17, 2014 at 06:05:25PM +0000, Liviu Dudau wrote:
>> > On Mon, Mar 17, 2014 at 05:38:21PM +0000, Catalin Marinas wrote:
>> > > On Fri, Mar 14, 2014 at 06:05:27PM +0000, Liviu Dudau wrote:
>> > > > On Fri, Mar 14, 2014 at 05:38:08PM +0000, Arnd Bergmann wrote:
>> > > > > On Friday 14 March 2014, Catalin Marinas wrote:
>> > > > > > On Fri, Mar 14, 2014 at 03:34:18PM +0000, Liviu Dudau wrote:
>> > > > > > > --- /dev/null
>> > > > > > > +++ b/arch/arm64/kernel/pci.c
>> > > > > > [...]
>> > > > > > > +int pci_register_io_range(phys_addr_t address, resource_size_t size)
>> > > > > > [...]
>> > > > > > > +unsigned long pci_address_to_pio(phys_addr_t address)
>> > > > > > [...]
>> > > > > > > +void pcibios_fixup_bus(struct pci_bus *bus)
>> > > > > > [ actually most of this file ]
>> > > > > >
>> > > > > > Maybe it was raised before already but can we have __weak generic
>> > > > > > definitions of these functions? They don't seem to be arm64 specific in
>> > > > > > any way.
>> > > [...]
>> > > > Catalin, if you are happy to ask for ACKs from all arch maintainers that might get
>> > > > affected by our custom version of pci_address_to_pio() before you can pull PCI support
>> > > > for arm64 then I can propose a new patchset.
>> > >
>> > > You don't need to change the other architectures, that's the point of a
>> > > __weak definition, it will be automatically overridden. If you want, you
>> > > can even place a GENERIC_PCI or whatever config option that is only
>> > > selected by arm64 for the time being.
>> >
>> > pci_address_to_pio() is alread __weak. My patch was adding the arm64 version of it. Adding
>> > an #ifdef GENERIC_PCI to the __weak implementation is not just a temporary solution.
>>
>> Ah, I start to understand what you mean, pci_address_to_pio() is already
>> defined as __weak in drivers/of/address.c. So the reason we redefine it
>> on arm64 is that it uses the io_list resources which are populated by
>> pci_register_io_range(). Do you see any other architecture using a
>> similar logic (that could be shared)?
>
> All architectures that memory map the PCI IO range should be supported by my version of
> pci_address_to_pio(). But that still leaves the x86 and those architectures that have
> separate IO space or map it 1:1 into CPU address space to carry a different version (which
> the current "generic" weak version catters for).
>
>>
>> Any other functions in this file that could be shared (and are not
>> __weak already)?
>
> A version of the pci_register_io_range() that uses part of pci_ioremap_io() (the calculation
> of io_offset part).
>
> My ultimate point is that no matter how long we argue about the shape of the functions that
> I've added into arch/arm64/kernel/pci.c I don't think we can get away without having that
> file, or at least not in the first phase if we want speedy integration into mainline.

"Speedy integration into mainline" is another way to say "leave it for
others to deal with and clean up later."

I've successfully used the preceeding series on ARM converting the
Versatile PCI support to use it. The main part of the process was just
copying this arm64 code to arm which tells me the code is in the wrong
place. There are still some differences in pcibios_fixup_bus, and it
is not clear to me whether the arm version should be doing all the
things the arm64 version does and vice-versa. Certainly that should be
sorted out. The other issues I see is pci_ioremap_io still has to be
called by the driver and is not aligned at least for the prototype as
I pointed out. Seems all these issues could be fixed with a simple
CONFIG_ARCH_HAS_MMIO_IOSPACE kconfig option.

Rob
