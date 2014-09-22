Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755075AbaIVVdm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Sep 2014 17:33:42 -0400
Received: from exprod5og118.obsmtp.com ([64.18.0.160]:58095 "HELO
	exprod5og118.obsmtp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1754807AbaIVVdj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Sep 2014 17:33:39 -0400
MIME-Version: 1.0
In-Reply-To: <20140919223258.GA32208@google.com>
References: <1410906824-9321-1-git-send-email-tinamdar@apm.com>
	<1410906824-9321-2-git-send-email-tinamdar@apm.com>
	<20140919223258.GA32208@google.com>
Date: Mon, 22 Sep 2014 14:33:37 -0700
Message-ID: <CACoXjcnVU3+fQHQ0-zEVRjoedrrod-aua6AVybj7UuSHO9HBaw@mail.gmail.com>
Subject: Re: [PATCH v9 1/4] pci:host: APM X-Gene PCIe host controller driver
From: Tanmay Inamdar <tinamdar@apm.com>
To: Bjorn Helgaas <bhelgaas@google.com>
Cc: Arnd Bergmann <arnd@arndb.de>,
        Jason Gunthorpe <jgunthorpe@obsidianresearch.com>,
        Grant Likely <grant.likely@linaro.org>,
        Rob Herring <robh+dt@kernel.org>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Rob Landley <rob@landley.net>, Liviu Dudau <liviu.dudau@arm.com>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        linux-arm-kernel@lists.infradead.org,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        linux-kernel@vger.kernel.org, patches <patches@apm.com>,
        Jon Masters <jcm@redhat.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Bjorn,

Thanks for the review and comments. Please see my inline replies.

Thanks,
Tanmay

On Fri, Sep 19, 2014 at 3:32 PM, Bjorn Helgaas <bhelgaas@google.com> wrote:
> On Tue, Sep 16, 2014 at 03:33:41PM -0700, Tanmay Inamdar wrote:
>> This patch adds the AppliedMicro X-Gene SOC PCIe host controller driver.
>> X-Gene PCIe controller supports maximum up to 8 lanes and GEN3 speed.
>> X-Gene SOC supports maximum 5 PCIe ports.
>>
>> Reviewed-by: Liviu Dudau <Liviu.Dudau@arm.com>
>> Signed-off-by: Tanmay Inamdar <tinamdar@apm.com>
>> ---
>>  drivers/pci/host/Kconfig     |  10 +
>>  drivers/pci/host/Makefile    |   1 +
>>  drivers/pci/host/pci-xgene.c | 646 +++++++++++++++++++++++++++++++++++++++++++
>>  3 files changed, 657 insertions(+)
>>  create mode 100644 drivers/pci/host/pci-xgene.c
>> ...
>
>> +static inline void
>> +xgene_pcie_cfg_in16(void __iomem *addr, int offset, u32 *val)
>
> Whitespace - can fit on one line.  Also others below.

Thanks. Will fix it.
>
>> +{
>> +     *val = readl(addr + (offset & ~0x3));
>> +
>> +     switch (offset & 0x3) {
>> +     case 2:
>> +             *val >>= 16;
>> +             break;
>> +     }
>> +
>> +     *val &= 0xFFFF;
>> +}
>> +
>> +static inline void
>> +xgene_pcie_cfg_in8(void __iomem *addr, int offset, u32 *val)
>> +{
>> +     *val = readl(addr + (offset & ~0x3));
>> +
>> +     switch (offset & 0x3) {
>> +     case 3:
>> +             *val = *val >> 24;
>> +             break;
>> +     case 2:
>> +             *val = *val >> 16;
>> +             break;
>> +     case 1:
>> +             *val = *val >> 8;
>> +             break;
>> +     }
>> +     *val &= 0xFF;
>> +}
>> +
>> +/* When the address bit [17:16] is 2'b01, the Configuration access will be
>> + * treated as Type 1 and it will be forwarded to external PCIe device.
>> + */
>
> Follow usual block comment style:
>
>     /*
>      * text
>      */
>

Thanks. Will fix it.

>> ...
>> +static void xgene_pcie_fixup_bridge(struct pci_dev *dev)
>> +{
>> +     int i;
>> +
>> +     /* Hide the PCI host BARs from the kernel as their content doesn't
>> +      * fit well in the resource management
>> +      */
>
> This needs a better explanation than "doesn't fit well."
>
> I *think* you're probably talking about something similar to the MVEBU
> devices mentioned here:
> http://lkml.kernel.org/r/CAErSpo56jB1Bf2JtYCGKXZBZqRF1jXFxGmeewPX_e6vSXueGyA@mail.gmail.com
>
> where the device can be configured as either an endpoint or a root port,
> and the endpoint BARs are still visible when configured as a root port.
>

It is true that X-Gene PCIe port can be configured as EP, however the
the FIXUP is required not because of the BARs are still visible when
configured as EP in past. X-Gene PCIe port, when configured as RC,
uses BAR0-BAR1 of RC's configuration space as inbound BARs. Entire DDR
region is mapped in these BARs so that it is accessible for EP devices
for DMA. So if the fixup is not done during enumeration, whole
outbound memory resource space gets assigned to RC and nothing is left
EP devices.

> In any event, I'd like a description of exactly what these BARs are and wha
> the problem is.

Is it ok to put above description in comment to explain the fixup?

> Presumably the BARs exist and were sized by the PCI core
> in __pci_read_base().  That will generate some log messages and possibly
> some warnings, depending on how the host bridge windows are set up.
>

xgene-pcie 1f2b0000.pcie: PCI host bridge to bus 0000:00
pci_bus 0000:00: root bus resource [bus 00-ff]
pci_bus 0000:00: root bus resource [io  0x0000-0xffff]
pci_bus 0000:00: root bus resource [mem 0xe180000000-0xe1ffffffff]
(bus address [0x80000000-0xffffffff])
pci_bus 0000:00: scanning bus
pci 0000:00:00.0: [10e8:e004] type 01 class 0x060400
pci 0000:00:00.0: reg 0x10: [mem 0x8000000000-0x807fffffff 64bit pref]
pci 0000:00:00.0: supports D1 D2
pci_bus 0000:00: fixups for bus
pci 0000:00:00.0: scanning [bus 01-01] behind bridge, pass 0
pci_bus 0000:01: scanning bus
pci 0000:01:00.0: [15b3:1003] type 00 class 0x020000
pci 0000:01:00.0: reg 0x10: [mem 0x00100000-0x001fffff 64bit]
pci 0000:01:00.0: reg 0x18: [mem 0x00800000-0x00ffffff 64bit pref]
pci 0000:01:00.0: reg 0x30: [mem 0x01000000-0x010fffff pref]
pci_bus 0000:01: fixups for bus
pci_bus 0000:01: bus scan returning with max=01
pci 0000:00:00.0: scanning [bus 01-01] behind bridge, pass 1
pci_bus 0000:00: bus scan returning with max=01
pci 0000:00:00.0: BAR 0: assigned [mem 0xe180000000-0xe1ffffffff 64bit pref]
pci 0000:00:00.0: BAR 9: no space for [mem size 0x00800000 64bit pref]
pci 0000:00:00.0: BAR 9: failed to assign [mem size 0x00800000 64bit pref]
pci 0000:00:00.0: BAR 8: no space for [mem size 0x00200000]
pci 0000:00:00.0: BAR 8: failed to assign [mem size 0x00200000]
pci 0000:01:00.0: BAR 2: no space for [mem size 0x00800000 64bit pref]
pci 0000:01:00.0: BAR 2: failed to assign [mem size 0x00800000 64bit pref]
pci 0000:01:00.0: BAR 0: no space for [mem size 0x00100000 64bit]
pci 0000:01:00.0: BAR 0: failed to assign [mem size 0x00100000 64bit]
pci 0000:01:00.0: BAR 6: no space for [mem size 0x00100000 pref]
pci 0000:01:00.0: BAR 6: failed to assign [mem size 0x00100000 pref]


> We might eventually need a way to skip BARs like that altogether so we
> don't even try to size them.
>
>> +     for (i = 0; i < DEVICE_COUNT_RESOURCE; i++) {
>> +             dev->resource[i].start = dev->resource[i].end = 0;
>> +             dev->resource[i].flags = 0;
>> +     }
>> +     dev_info(&dev->dev, "Hiding X-Gene pci host bridge resources %s\n",
>> +              pci_name(dev));
>> +}
>> +DECLARE_PCI_FIXUP_HEADER(XGENE_PCIE_VENDORID, XGENE_PCIE_DEVICEID,
>> +                      xgene_pcie_fixup_bridge);
>> +
>> ...
>
>> +static void xgene_pcie_setup_ob_reg(struct xgene_pcie_port *port,
>> +                                 struct resource *res, u32 offset,
>> +                                 u64 cpu_addr, u64 pci_addr)
>> +{
>> +     void __iomem *base = port->csr_base + offset;
>> +     resource_size_t size = resource_size(res);
>> +     u64 restype = resource_type(res);
>> +     u64 mask = 0;
>> +     u32 min_size;
>> +     u32 flag = EN_REG;
>> +
>> +     if (restype == IORESOURCE_MEM) {
>> +             min_size = SZ_128M;
>> +     } else {
>> +             min_size = 128;
>> +             flag |= OB_LO_IO;
>> +     }
>> +
>> +     if (size >= min_size)
>> +             mask = ~(size - 1) | flag;
>> +     else
>> +             dev_warn(port->dev, "res size 0x%llx less than minimum 0x%x\n",
>> +                      (u64)size, min_size);
>
> I'd include a %pR here to help identify the offending resource.
>

Will change it in next revision.

>> +static int xgene_pcie_map_ranges(struct xgene_pcie_port *port,
>> +                              struct list_head *res,
>> +                              resource_size_t io_base)
>> +{
>> +     struct pci_host_bridge_window *window;
>> +     struct device *dev = port->dev;
>> +     int ret;
>> +
>> +     list_for_each_entry(window, res, list) {
>> +             struct resource *res = window->res;
>> +             u64 restype = resource_type(res);
>> +
>> +             dev_dbg(port->dev, "0x%08lx 0x%016llx...0x%016llx\n",
>> +                     res->flags, res->start, res->end);
>
> Use %pR here.
>
Will change it in next revision.

>> +
>> +             switch (restype) {
>> +             case IORESOURCE_IO:
>> +                     xgene_pcie_setup_ob_reg(port, res, OMR3BARL, io_base,
>> +                                             res->start - window->offset);
>> +                     ret = pci_remap_iospace(res, io_base);
>> +                     if (ret < 0)
>> +                             return ret;
>> +                     break;
>> +             case IORESOURCE_MEM:
>> +                     xgene_pcie_setup_ob_reg(port, res, OMR1BARL, res->start,
>> +                                             res->start - window->offset);
>> +                     break;
>> +             case IORESOURCE_BUS:
>> +                     break;
>> +             default:
>> +                     dev_err(dev, "invalid io resource!");
>
> If you're going to print something here, you might as well include the type
> that seems invalid.  If you use %pR, I think it will do that automatically.
>

Will change it in next revision.

>> +                     return -EINVAL;
>> +             }
>> +     }
>> +     xgene_pcie_setup_cfg_reg(port->csr_base, port->cfg_addr);
>> +
>> +     return 0;
>> +}
>
> Bjorn
