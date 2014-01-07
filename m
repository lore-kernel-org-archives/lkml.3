Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756883AbaAGClj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Jan 2014 21:41:39 -0500
Received: from exprod5og109.obsmtp.com ([64.18.0.188]:37156 "HELO
	exprod5og109.obsmtp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1756731AbaAGClg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Jan 2014 21:41:36 -0500
MIME-Version: 1.0
In-Reply-To: <201401031307.50312.arnd@arndb.de>
References: <1387785725-24262-1-git-send-email-tinamdar@apm.com>
	<1387785725-24262-2-git-send-email-tinamdar@apm.com>
	<201401031307.50312.arnd@arndb.de>
Date: Mon, 6 Jan 2014 18:41:34 -0800
Message-ID: <CACoXjck9KvQjB-8t3GYa95pZ6AwAyhyRKVg=5CYog_nFAfCiAQ@mail.gmail.com>
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

Thanks for your comments. Please see some inline replies.

On Fri, Jan 3, 2014 at 4:07 AM, Arnd Bergmann <arnd@arndb.de> wrote:
> On Monday 23 December 2013, Tanmay Inamdar wrote:
>> This patch adds the AppliedMicro X-gene SOC PCIe controller driver.
>> APM X-Gene PCIe controller supports maximum upto 8 lanes and
>> GEN3 speed. X-Gene has maximum 5 PCIe ports supported.
>>
>> Signed-off-by: Tanmay Inamdar <tinamdar@apm.com>
>> ---
>>  drivers/pci/host/Kconfig      |    5 +
>>  drivers/pci/host/Makefile     |    1 +
>>  drivers/pci/host/pcie-xgene.c | 1017 +++++++++++++++++++++++++++++++++++++++++
>>  3 files changed, 1023 insertions(+)
>>  create mode 100644 drivers/pci/host/pcie-xgene.c
>>
>> diff --git a/drivers/pci/host/Kconfig b/drivers/pci/host/Kconfig
>> index 47d46c6..6d8fcbc 100644
>> --- a/drivers/pci/host/Kconfig
>> +++ b/drivers/pci/host/Kconfig
>> @@ -33,4 +33,9 @@ config PCI_RCAR_GEN2
>>         There are 3 internal PCI controllers available with a single
>>         built-in EHCI/OHCI host controller present on each one.
>>
>> +config PCI_XGENE
>> +     bool "X-Gene PCIe controller"
>> +     depends on ARCH_XGENE
>> +     depends on OF
>
> Please add a help text here.

ok

>
>> +#ifdef CONFIG_ARM64
>> +#include <asm/pcibios.h>
>> +#else
>> +#include <asm/mach/pci.h>
>> +#endif
>
> What is !ARM64 case? Is this for PowerPC or ARM? Since you depend on
> ARCH_XGENE in Kconfig I guess neither case can actually happen,
> so you can remove the #ifdef.

ok

>
>> +#define CFG_CONSTANTS_31_00          0x2000
>> +#define CFG_CONSTANTS_63_32          0x2004
>> +#define CFG_CONSTANTS_159_128                0x2010
>> +#define CFG_CONSTANTS_415_384           0x2030
>
> These macros do not seem helpful. If you don't have meaningful register
> names, just don't provide any and address the registers by index.

ok

>
>> +#define ENABLE_L1S_POWER_MGMT_SET(dst, src)     (((dst) & ~0x02000000) | \
>> +                                             (((u32)(src) << 0x19) & \
>> +                                             0x02000000))
>
> Makes this an inline function, or open-code it in the caller if there
> is only one.
>

ok

>> +#ifdef CONFIG_64BIT
>> +#define pci_io_offset(s)             (s & 0xff00000000)
>> +#else
>> +#define pci_io_offset(s)             (s & 0x00000000)
>> +#endif /* CONFIG_64BIT */
>
> Why is this needed? The I/O space can never be over 0xffffffff,
> or in practice 0xffff. My best guess is that you have a bug in the
> function parsing your ranges property, or in the property value.

I will recheck the logic.

>
>> +static inline struct xgene_pcie_port *
>> +xgene_pcie_sys_to_port(struct pci_sys_data *sys)
>> +{
>> +     return (struct xgene_pcie_port *)sys->private_data;
>> +}
>
> You shouldn't need the cast, or the accessor function, since private_data
> is already a void pointer.

got it.

>
>> +/* IO ports are memory mapped */
>> +void __iomem *__pci_ioport_map(struct pci_dev *dev, unsigned long port,
>> +                            unsigned int nr)
>> +{
>> +     return devm_ioremap_nocache(&dev->dev, port, nr);
>> +}
>
> This can't be in the host driver, since you can have only one instance
> of the function in the system, but you probably want multiple host
> drivers in a multiplatform kernel on ARM64.

You are right. It will fail multiplatform kernel.

>
> Also, the implementation is wrong since the I/O port range already needs
> to be ioremapped in order for inb/outb to work. There is already a
> generic implementation of this in include/asm-generic/iomap.h, which
> correctly calls ioport_map. Make sure that arm64 uses this implementation
> and provides an ioport_map() function like
>
> static inline void __iomem *ioport_map(unsigned long port, unsigned int nr)
> {
>         return PCI_IOBASE + port;
> }

For X-Gene, IO regions are memory mapped IO regions. So I am not sure
if 'ioport_map'
would work.

>
>> +/* PCIE Out/In to CSR */
>> +static inline void xgene_pcie_out32(void *addr, u32 val)
>> +{
>> +     pr_debug("pcie csr wr: 0x%llx 0x%08x\n", (phys_addr_t)addr, val);
>> +     writel(val, addr);
>> +}
>> +
>> +static inline void xgene_pcie_in32(void *addr, u32 *val)
>> +{
>> +     *val = readl(addr);
>> +     pr_debug("pcie csr rd: 0x%llx 0x%08x\n", (phys_addr_t)addr, *val);
>> +}
>
> These add no value, just remove them. If your code is so buggy that
> you need to print every register access to the debug log, we don't
> want it ;-)

Yep. I will remove it.

>
>> +static inline void xgene_pcie_cfg_out16(void *addr, u16 val)
>> +{
>> +     phys_addr_t temp_addr = (phys_addr_t) addr & ~0x3;
>> +     u32 val32 = readl((void *)temp_addr);
>> +
>> +     switch ((phys_addr_t) addr & 0x3) {
>> +     case 2:
>> +             val32 &= ~0xFFFF0000;
>> +             val32 |= (u32) val << 16;
>> +             break;
>> +     case 0:
>> +     default:
>> +             val32 &= ~0xFFFF;
>> +             val32 |= val;
>> +             break;
>> +     }
>> +     writel(val32, (void *)temp_addr);
>> +}
>
> Isn't there a generic version of this? If not, should there be one?
> Maybe Bjorn can comment.
>
> Also, all the typecasts are wrong. Please think about what types
> you really want and fix them.

ok

>
>> +static void xgene_pcie_set_rtdid_reg(struct pci_bus *bus, uint devfn)
>> +{
>> +     struct xgene_pcie_port *port = xgene_pcie_bus_to_port(bus);
>> +     unsigned int b, d, f;
>> +     u32 rtdid_val = 0;
>> +
>> +     b = bus->number;
>> +     d = PCI_SLOT(devfn);
>> +     f = PCI_FUNC(devfn);
>> +
>> +     if (bus->number == port->first_busno)
>> +             rtdid_val = (b << 24) | (d << 19) | (f << 16);
>> +     else if (bus->number >= (port->first_busno + 1))
>> +             rtdid_val = (port->first_busno << 24) |
>> +             (b << 8) | (d << 3) | f;
>> +
>> +     xgene_pcie_out32(port->csr_base + RTDID, rtdid_val);
>> +     /* read the register back to ensure flush */
>> +     xgene_pcie_in32(port->csr_base + RTDID, &rtdid_val);
>> +}
>
> What is an 'rtdid'? Maybe add some comments

RTDID should be set with correct bdf to access the EP config space. I
will add comments.

>
>> +static void xgene_pcie_setup_lanes(struct xgene_pcie_port *port)
>> +{
>> +     void *csr_base = port->csr_base;
>> +     u32 val;
>> +
> ...
>> +static void xgene_pcie_setup_link(struct xgene_pcie_port *port)
>> +{
>> +     void *csr_base = port->csr_base;
>> +     u32 val;
>> +
>
> Don't these belong into the PHY driver? Can the setup be done in the
> firmware instead so we don't have to bother with it in Linux?
> Presumably you already need PCI support at boot time already if
> you want to boot from a PCI device.

They do look like phy setup functions but they are part of PCIe core
register space.

>
>> +static void xgene_pcie_config_pims(void *csr_base, u32 addr,
>> +                                u64 pim, resource_size_t size)
>> +{
>> +     u32 val;
>> +
>> +     xgene_pcie_out32(csr_base + addr, lower_32_bits(pim));
>> +     val = upper_32_bits(pim) | EN_COHERENCY;
>> +     xgene_pcie_out32(csr_base + addr + 0x04, val);
>> +     xgene_pcie_out32(csr_base + addr + 0x08, 0x0);
>> +     xgene_pcie_out32(csr_base + addr + 0x0c, 0x0);
>> +     val = lower_32_bits(size);
>> +     xgene_pcie_out32(csr_base + addr + 0x10, val);
>> +     val = upper_32_bits(size);
>> +     xgene_pcie_out32(csr_base + addr + 0x14, val);
>> +}
>
> I suspect this is for programming the inbound translation window for
> DMA transactions (maybe add a comment?), and the second 64-bit word is
> for the bus-side address. Are you sure you want a translation starting
> at zero, rather than an identity-mapping like this?

Actually it is an unused sub-region. I will remove setting to 0. It
defaults to 0 anyways.

>
>         xgene_pcie_out32(csr_base + addr, lower_32_bits(pim));
>         val = upper_32_bits(pim) | EN_COHERENCY;
>         xgene_pcie_out32(csr_base + addr + 0x04, val);
>         xgene_pcie_out32(csr_base + addr + 0x08, pim & 0xffffffff);
>         xgene_pcie_out32(csr_base + addr + 0x0c, pim >> 32);
>
>> +static void xgene_pcie_setup_port(struct xgene_pcie_port *port)
>> +{
>> +     int type = port->type;
>> +
>> +     xgene_pcie_program_core(port->csr_base);
>> +     if (type == PTYPE_ROOT_PORT)
>> +             xgene_pcie_setup_root_complex(port);
>> +     else
>> +             xgene_pcie_setup_endpoint(port);
>> +}
>
> We don't really have infrastructure for PCIe endpoint devices in Linux,
> or in the generic DT binding for PCI hosts. We probably really want to
> add that in the future, but until we have decided on how to do this,
> please remove all code related to endpoint mode.

ok.

>
>> +struct device_node *pcibios_get_phb_of_node(struct pci_bus *bus)
>> +{
>> +     struct xgene_pcie_port *port = xgene_pcie_bus_to_port(bus);
>> +
>> +     return of_node_get(port->node);
>> +}
>
> Another pointless wrapper to remove.

If I remove this, then we get a failure while parsing irqs
"pci 0000:00:00.0: of_irq_parse_pci() failed with rc=-22"

>
>> +static void xgene_pcie_fixup_bridge(struct pci_dev *dev)
>> +{
>> +     int i;
>> +
>> +     for (i = 0; i < DEVICE_COUNT_RESOURCE; i++) {
>> +             dev->resource[i].start = dev->resource[i].end = 0;
>> +             dev->resource[i].flags = 0;
>> +     }
>> +}
>> +DECLARE_PCI_FIXUP_HEADER(XGENE_PCIE_VENDORID, XGENE_PCIE_BRIDGE_DEVICEID,
>> +                      xgene_pcie_fixup_bridge);
>
> Please add a comment to describe exactly what bug you are working around,
> and what devices are affected.

ok

>
>> +/*
>> + * read configuration values from DTS
>> + */
>> +static int xgene_pcie_read_dts_config(struct xgene_pcie_port *port)
>> +{
>> +     struct device_node *np = port->node;
>> +     struct resource csr_res;
>> +     u32 val32;
>> +     int ret;
>> +     const u8 *val;
>> +
>> +     val = of_get_property(np, "device_type", NULL);
>> +     if ((val != NULL) && !strcmp(val, "ep"))
>> +             port->type = PTYPE_ENDPOINT;
>> +     else
>> +             port->type = PTYPE_ROOT_PORT;
>
> "ep" is not a valid device_type for all I know.

Will remove all EP stuff.

>
>> +     ret = of_property_read_u32(np, "link_speed", &val32);
>> +     if (ret == 0)
>> +             port->link_speed = val32;
>> +     else
>> +             port->link_speed = PCIE_GEN3;
>
> I guess this should be an argument to the phy node. Isn't it the phy
> that needs to know the link speed rather than the host?

yes. some part of it still resides in the core. However I will make it
to GEN3 by default.

>
>> +static int xgene_pcie_alloc_ep_mem(struct xgene_pcie_port *port)
>> +{
>> +     struct xgene_pcie_ep_info *ep = &port->ep_info;
>> +
>> +     ep->reg_virt = dma_alloc_coherent(port->dev, XGENE_PCIE_EP_MEM_SIZE,
>> +                                       &ep->reg_phys, GFP_KERNEL);
>> +     if (ep->reg_virt == NULL)
>> +             return -ENOMEM;
>> +
>> +     dev_info(port->dev, "EP: Virt - %p Phys - 0x%llx Size - 0x%x\n",
>> +              ep->reg_virt, (u64) ep->reg_phys, XGENE_PCIE_EP_MEM_SIZE);
>> +     return 0;
>> +}
>
> remove endpoint stuff for now.

ok

>
>> +static int xgene_pcie_populate_inbound_regions(struct xgene_pcie_port *port)
>> +{
>> +     struct resource *msi_res = &port->res[XGENE_MSI];
>> +     phys_addr_t ddr_size = memblock_phys_mem_size();
>> +     phys_addr_t ddr_base = memblock_start_of_DRAM();
>
> This looks fragile. What about discontiguous memory? It's probably better to
> leave this setup to the firmware, which already has to do it.

Idea is to map whole RAM. The memory controller in X-Gene does not
allow holes or
discontinuity in RAM.

>
>> +static int xgene_pcie_parse_map_ranges(struct xgene_pcie_port *port)
>> +{
>> +     struct device_node *np = port->node;
>> +     struct of_pci_range range;
>> +     struct of_pci_range_parser parser;
>> +     struct device *dev = port->dev;
>> +     u32 cfg_map_done = 0;
>> +     int ret;
>> +
>> +     if (of_pci_range_parser_init(&parser, np)) {
>> +             dev_err(dev, "missing ranges property\n");
>> +             return -EINVAL;
>> +     }
>> +
>> +     /* Get the I/O, memory, config ranges from DT */
>> +     for_each_of_pci_range(&parser, &range) {
>> +             struct resource *res = NULL;
>> +             u64 restype = range.flags & IORESOURCE_TYPE_BITS;
>> +             u64 end = range.cpu_addr + range.size - 1;
>> +             dev_dbg(port->dev, "0x%08x 0x%016llx..0x%016llx -> 0x%016llx\n",
>> +                     range.flags, range.cpu_addr, end, range.pci_addr);
>> +
>> +             switch (restype) {
>> +             case IORESOURCE_IO:
>> +                     res = &port->res[XGENE_IO];
>> +                     of_pci_range_to_resource(&range, np, res);
>> +                     xgene_pcie_setup_ob_reg(port->csr_base, OMR1BARL,
>> +                                             XGENE_IO, res);
>> +                     break;
>> +             case IORESOURCE_MEM:
>> +                     res = &port->res[XGENE_MEM];
>> +                     of_pci_range_to_resource(&range, np, res);
>> +                     xgene_pcie_setup_ob_reg(port->csr_base, OMR2BARL,
>> +                                             XGENE_MEM, res);
>> +                     break;
>
> You also need to read out the pci_addr field from the range struct in order
> to set up the io_offset and mem_offset and the translation windows.
> Don't assume that they start at zero.

ok.

>
>> +             case 0:
>> +                     if (!cfg_map_done) {
>> +                             /* config region */
>> +                             if (port->type == PTYPE_ROOT_PORT) {
>> +                                     ret = xgene_pcie_map_cfg(port, &range);
>> +                                     if (ret)
>> +                                             return ret;
>> +                             }
>> +                             cfg_map_done = 1;
>> +                     } else {
>> +                             /* msi region */
>> +                             res = &port->res[XGENE_MSI];
>> +                             of_pci_range_to_resource(&range, np, res);
>> +                     }
>> +                     break;
>
> Don't make assumptions about the order of the ranges property. Also, neither
> the MSI register nor the config space should be in the ranges.

ok.
>
>> +static int xgene_pcie_setup(int nr, struct pci_sys_data *sys)
>> +{
>> +     struct xgene_pcie_port *pp = xgene_pcie_sys_to_port(sys);
>> +
>> +     if (pp == NULL)
>> +             return 0;
>> +
>> +     if (pp->type == PTYPE_ENDPOINT)
>> +             return 0;
>> +
>> +     sys->io_offset = pci_io_offset(pp->res[XGENE_IO].start);
>
> Normally we want io_offset to be zero, i.e. have every Bus I/O space
> window get translated to the same Linux I/O space address, i.e.
> the number you pass into pci_ioremap_io(). The code here assumes
> that the Bus I/O address is zero instead and the io_offset adjusts
> for that, which is a bit confusing. Please change it to read
> the actual values from the ranges property.

I will recheck the logic.

>
>> +     sys->mem_offset = pci_io_offset(pp->res[XGENE_MEM].start);
>> +
>> +     BUG_ON(request_resource(&iomem_resource, &pp->res[XGENE_IO]) ||
>> +            request_resource(&iomem_resource, &pp->res[XGENE_MEM]));
>> +
>> +     pci_add_resource_offset(&sys->resources, &pp->res[XGENE_MEM],
>> +                             sys->mem_offset);
>> +     pci_add_resource_offset(&sys->resources, &pp->res[XGENE_IO],
>> +                             sys->io_offset);
>
> &pp->res[XGENE_IO] is in memory space, while the argument you want here
> is in I/O space.
>
>> +static int xgene_pcie_map_irq(const struct pci_dev *dev, u8 slot, u8 pin)
>> +{
>> +     return of_irq_parse_and_map_pci(dev, slot, pin);
>> +}
>
> Just use the function directly and remove the wrapper.

got it.

>
>         Arnd
