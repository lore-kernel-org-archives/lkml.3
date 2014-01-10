Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757124AbaAJBUy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Jan 2014 20:20:54 -0500
Received: from exprod5og102.obsmtp.com ([64.18.0.143]:50702 "HELO
	exprod5og102.obsmtp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751745AbaAJBUv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Jan 2014 20:20:51 -0500
MIME-Version: 1.0
In-Reply-To: <201401071028.00225.arnd@arndb.de>
References: <1387785725-24262-1-git-send-email-tinamdar@apm.com>
	<201401031307.50312.arnd@arndb.de>
	<CACoXjck9KvQjB-8t3GYa95pZ6AwAyhyRKVg=5CYog_nFAfCiAQ@mail.gmail.com>
	<201401071028.00225.arnd@arndb.de>
Date: Thu, 9 Jan 2014 17:20:50 -0800
Message-ID: <CACoXjc=GCXSKuQBohf8-6vCsxxM3EJf72mriBaS0iaKhiCAuoQ@mail.gmail.com>
Subject: Re: [RFC PATCH 1/3] pci: APM X-Gene PCIe controller driver
From: Tanmay Inamdar <tinamdar@apm.com>
To: Arnd Bergmann <arnd@arndb.de>
Cc: "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Grant Likely <grant.likely@linaro.org>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Rob Landley <rob@landley.net>, devicetree@vger.kernel.org,
        linux-doc@vger.kernel.org, linux-pci@vger.kernel.org,
        patches <patches@apm.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Jon Masters <jcm@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 7, 2014 at 1:27 AM, Arnd Bergmann <arnd@arndb.de> wrote:
> On Tuesday 07 January 2014, Tanmay Inamdar wrote:
>> > Also, the implementation is wrong since the I/O port range already needs
>> > to be ioremapped in order for inb/outb to work. There is already a
>> > generic implementation of this in include/asm-generic/iomap.h, which
>> > correctly calls ioport_map. Make sure that arm64 uses this implementation
>> > and provides an ioport_map() function like
>> >
>> > static inline void __iomem *ioport_map(unsigned long port, unsigned int nr)
>> > {
>> >         return PCI_IOBASE + port;
>> > }
>>
>> For X-Gene, IO regions are memory mapped IO regions. So I am not sure
>> if 'ioport_map'
>> would work.
>
> It should. In fact all ARM and ARM64 platforms I have seen (and most powerpc
> ones) have their IO region memory mapped. The way we handle this in Linux
> is to map the IO space to a fixed virtual address at the time the host
> controller is initialized, and all accesses to an IO port translate to
> a access in this virtual address. See the inb()/outb() implementation on
> arm and arm64, as well as the arm pci_ioremap_io() function for more
> details.
>

Yes. arm64 has to support pci_ioremap_io and pci_iomap in order to
support IO regions. Thanks.

>> >> +static void xgene_pcie_setup_lanes(struct xgene_pcie_port *port)
>> >> +{
>> >> +     void *csr_base = port->csr_base;
>> >> +     u32 val;
>> >> +
>> > ...
>> >> +static void xgene_pcie_setup_link(struct xgene_pcie_port *port)
>> >> +{
>> >> +     void *csr_base = port->csr_base;
>> >> +     u32 val;
>> >> +
>> >
>> > Don't these belong into the PHY driver? Can the setup be done in the
>> > firmware instead so we don't have to bother with it in Linux?
>> > Presumably you already need PCI support at boot time already if
>> > you want to boot from a PCI device.
>>
>> They do look like phy setup functions but they are part of PCIe core
>> register space.
>
> Ok.
>
>> >> +static void xgene_pcie_config_pims(void *csr_base, u32 addr,
>> >> +                                u64 pim, resource_size_t size)
>> >> +{
>> >> +     u32 val;
>> >> +
>> >> +     xgene_pcie_out32(csr_base + addr, lower_32_bits(pim));
>> >> +     val = upper_32_bits(pim) | EN_COHERENCY;
>> >> +     xgene_pcie_out32(csr_base + addr + 0x04, val);
>> >> +     xgene_pcie_out32(csr_base + addr + 0x08, 0x0);
>> >> +     xgene_pcie_out32(csr_base + addr + 0x0c, 0x0);
>> >> +     val = lower_32_bits(size);
>> >> +     xgene_pcie_out32(csr_base + addr + 0x10, val);
>> >> +     val = upper_32_bits(size);
>> >> +     xgene_pcie_out32(csr_base + addr + 0x14, val);
>> >> +}
>> >
>> > I suspect this is for programming the inbound translation window for
>> > DMA transactions (maybe add a comment?), and the second 64-bit word is
>> > for the bus-side address. Are you sure you want a translation starting
>> > at zero, rather than an identity-mapping like this?
>>
>> Actually it is an unused sub-region. I will remove setting to 0. It
>> defaults to 0 anyways.
>
> Is it always an identity-mapping then?
>
Yes.

>> >> +struct device_node *pcibios_get_phb_of_node(struct pci_bus *bus)
>> >> +{
>> >> +     struct xgene_pcie_port *port = xgene_pcie_bus_to_port(bus);
>> >> +
>> >> +     return of_node_get(port->node);
>> >> +}
>> >
>> > Another pointless wrapper to remove.
>>
>> If I remove this, then we get a failure while parsing irqs
>> "pci 0000:00:00.0: of_irq_parse_pci() failed with rc=-22"
>
> I mean it would be just as easy to open-code the function in the
> callers, and more readable.
>
>> >> +static int xgene_pcie_populate_inbound_regions(struct xgene_pcie_port *port)
>> >> +{
>> >> +     struct resource *msi_res = &port->res[XGENE_MSI];
>> >> +     phys_addr_t ddr_size = memblock_phys_mem_size();
>> >> +     phys_addr_t ddr_base = memblock_start_of_DRAM();
>> >
>> > This looks fragile. What about discontiguous memory? It's probably better to
>> > leave this setup to the firmware, which already has to do it.
>>
>> Idea is to map whole RAM. The memory controller in X-Gene does not
>> allow holes or discontinuity in RAM.
>
> There might be holes in the memory map for other reasons, e.g. some part of
> memory could be reserved for use by a particular piece of software.
> There is actually a definition for a "dma-ranges" property that is normally
> use to communicate this information, i.e. which bus addresses for DMA
> translate into which parent bus (or memory) addresses. I think it would
> be more logical to use that property.

Yes. You are right. We will get more flexibility with this.

>
>         Arnd
