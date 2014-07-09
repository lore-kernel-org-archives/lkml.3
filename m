Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754669AbaGIGZu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jul 2014 02:25:50 -0400
Received: from mout.kundenserver.de ([212.227.126.131]:60179 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751054AbaGIGZs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jul 2014 02:25:48 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Bjorn Helgaas <bhelgaas@google.com>
Subject: Re: [PATCH v8 3/9] pci: Introduce pci_register_io_range() helper function.
Date: Wed, 9 Jul 2014 08:20:49 +0200
User-Agent: KMail/1.12.2 (Linux/3.8.0-35-generic; KDE/4.3.2; x86_64; ; )
Cc: Liviu Dudau <Liviu.Dudau@arm.com>, "linux-pci" <linux-pci@vger.kernel.org>,
        Catalin Marinas <Catalin.Marinas@arm.com>,
        Will Deacon <Will.Deacon@arm.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        "linaro-kernel" <linaro-kernel@lists.linaro.org>,
        Tanmay Inamdar <tinamdar@apm.com>,
        Grant Likely <grant.likely@secretlab.ca>,
        Sinan Kaya <okaya@codeaurora.org>, Jingoo Han <jg1.han@samsung.com>,
        Kukjin Kim <kgene.kim@samsung.com>,
        Suravee Suthikulanit <suravee.suthikulpanit@amd.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Device Tree ML <devicetree@vger.kernel.org>,
        LAKML <linux-arm-kernel@lists.infradead.org>
References: <1404240214-9804-1-git-send-email-Liviu.Dudau@arm.com> <201407080900.44882.arnd@arndb.de> <20140708212951.GA4555@google.com>
In-Reply-To: <20140708212951.GA4555@google.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201407090820.49418.arnd@arndb.de>
X-Provags-ID: V02:K0:QC/MYrZopAj400aHxtl7Ov78GaS9oLI047mQ0zguQrP
 hiduURBtyRWhWs4h9sJR6q0ij8F0NLZr6arEtQI6FEzrB0kxdF
 Rx3Rpz/rOYjs2C6czFUt121g7yLLc6tqGz+idHSTvCqz4OPWWQ
 S4hpFaKgxMGiA19ky7UoKG/2lB+QtNR0KgL559pdUQpLuSdWhM
 vSgJHYTVMrrbly40MokN8578z6bMSWV6xYO8R152U1HV6Ee53U
 4vX40TD7KtsupFJ2nCbyKbO1OCZ99CWAJ3CMldlNezP4f5LJR0
 hLxvUM1+xquxm9iV7sC3zFL7Uq3bGTMA2oMJRXL9Cc3spKwY4o
 OOp4kmSBPNV4GHwT6Yo6u+qsdShnUGWEKCyJ4BdfD
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 08 July 2014, Bjorn Helgaas wrote:
> On Tue, Jul 8, 2014 at 1:00 AM, Arnd Bergmann <arnd@arndb.de> wrote:
> > On Tuesday 08 July 2014, Bjorn Helgaas wrote:
> >> On Tue, Jul 01, 2014 at 07:43:28PM +0100, Liviu Dudau wrote:
> >> > +static LIST_HEAD(io_range_list);
> >> > +
> >> > +/*
> >> > + * Record the PCI IO range (expressed as CPU physical address + size).
> >> > + * Return a negative value if an error has occured, zero otherwise
> >> > + */
> >> > +int __weak pci_register_io_range(phys_addr_t addr, resource_size_t size)
> >>
> >> I don't understand the interface here.  What's the mapping from CPU
> >> physical address to bus I/O port?  For example, I have the following
> >> machine in mind:
> >>
> >>   HWP0002:00: PCI Root Bridge (domain 0000 [bus 00-1b])
> >>   HWP0002:00: memory-mapped IO port space [mem 0xf8010000000-0xf8010000fff]
> >>   HWP0002:00: host bridge window [io  0x0000-0x0fff]
> >>
> >>   HWP0002:09: PCI Root Bridge (domain 0001 [bus 00-1b])
> >>   HWP0002:09: memory-mapped IO port space [mem 0xf8110000000-0xf8110000fff]
> >>   HWP0002:09: host bridge window [io  0x1000000-0x1000fff] (PCI address [0x0-0xfff])
> >>
> >> The CPU physical memory [mem 0xf8010000000-0xf8010000fff] is translated by
> >> the bridge to I/O ports 0x0000-0x0fff on PCI bus 0000:00.  Drivers use,
> >> e.g., "inb(0)" to access it.
> >>
> >> Similarly, [mem 0xf8110000000-0xf8110000fff] is translated by the second
> >> bridge to I/O ports 0x0000-0x0fff on PCI bus 0001:00.  Drivers use
> >> "inb(0x1000000)" to access it.
> >
> > I guess you are thinking of the IA64 model here where you keep the virtual
> > I/O port numbers in a per-bus lookup table that gets accessed for each
> > inb() call. I've thought about this some more, and I believe there are good
> > reasons for sticking with the model used on arm32 and powerpc for the
> > generic OF implementation.
> >
> > The idea is that there is a single virtual memory range for all I/O port
> > mappings and we use the MMU to do the translation rather than computing
> > it manually in the inb() implemnetation. The main advantage is that all
> > functions used in device drivers to (potentially) access I/O ports
> > become trivial this way, which helps for code size and in some cases
> > (e.g. SoC-internal registers with a low latency) it may even be performance
> > relevant.
> 
> My example is from ia64, but I'm not advocating for the lookup table.
> The point is that the hardware works similarly (at least for dense ia64
> I/O port spaces) in terms of mapping CPU physical addresses to PCI I/O
> space.
> 
> I think my confusion is because your pci_register_io_range() and
> pci_addess_to_pci() implementations assume that every io_range starts at
> I/O port 0 on PCI (correct me if I'm wrong).  I suspect that's why you
> don't save the I/O port number in struct io_range.

I think you are just misreading the code, but I agree it's hard to
understand and I made the same mistake in my initial reply to the
first version.

pci_register_io_range and pci_address_to_pci only worry about the mapping
between CPU physical and Linux I/O address, they do not care which PCI
port numbers are behind that. The mapping between PCI port numbers and
Linux port numbers is done correctly in patch 8/9 in the
pci_host_bridge_of_get_ranges() function.

> Maybe that assumption is guaranteed by OF, but it doesn't hold for ACPI;
> ACPI can describe several I/O port apertures for a single bridge, each
> associated with a different CPU physical memory region.

DT can have the same, although the common case is that each PCI host
bridge has 64KB of I/O ports starting at address 0. Most driver writers
get it wrong for the case where it starts at a different address, so
I really want to have a generic implementation that gets it right.

> If my speculation here is correct, a comment to the effect that each
> io_range corresponds to a PCI I/O space range that starts at 0 might be
> enough.
> 
> If you did add a PCI I/O port number argument to pci_register_io_range(),
> we might be able to make an ACPI-based implementation of it.  But I guess
> that could be done if/when anybody ever wants to do that.

I think we shoulnd't worry about it before we actually need it. As far as
I understand, the only user of that code (unless someone wants to convert
ia64) would be ARM64 with ACPI, but that uses the SBSA hardware model that
recommends having no I/O space at all.

 	Arnd
