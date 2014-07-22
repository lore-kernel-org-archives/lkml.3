Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751986AbaGVFK4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jul 2014 01:10:56 -0400
Received: from mail-lb0-f180.google.com ([209.85.217.180]:43935 "EHLO
	mail-lb0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751260AbaGVFKx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jul 2014 01:10:53 -0400
MIME-Version: 1.0
In-Reply-To: <20140716173824.GA24357@google.com>
References: <1404361654-2894-1-git-send-email-sthokal@xilinx.com>
	<20140716173824.GA24357@google.com>
Date: Tue, 22 Jul 2014 10:40:48 +0530
X-Google-Sender-Auth: 9myUkNdb5S-lMTXzyWKi09hTL1Y
Message-ID: <CA+mB=1JupzQy+R14kKAk7mTJR2FcZ+cQv-uXQSB6jEVBW95aGQ@mail.gmail.com>
Subject: Re: [PATCH v4] pcie: Add Xilinx PCIe Host Bridge IP driver
From: Srikanth Thokala <sthokal@xilinx.com>
To: Bjorn Helgaas <bhelgaas@google.com>
Cc: Srikanth Thokala <sthokal@xilinx.com>,
        Michal Simek <michal.simek@xilinx.com>,
        Grant Likely <grant.likely@linaro.org>,
        Rob Herring <robh+dt@kernel.org>, Arnd Bergmann <arnd@arndb.de>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        devicetree@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Bjorn,


On Wed, Jul 16, 2014 at 11:08 PM, Bjorn Helgaas <bhelgaas@google.com> wrote:
> On Thu, Jul 03, 2014 at 09:57:34AM +0530, Srikanth Thokala wrote:
>> This is the driver for Xilinx AXI PCIe Host Bridge Soft IP
>>
>> Signed-off-by: Srikanth Thokala <sthokal@xilinx.com>
>> ---
>> Changes in v4:
>> - Regarding the comments to separate ECAM functionality,
>>   I have sent a separate patch and it is decided to implement
>>   it later. The patch is here,
>>   https://lkml.org/lkml/2014/5/18/54
>> - Fixed issue with adding configuration bus resource.
>> - Moved the logic for setting up bus resources to probe() from
>>   pcie_setup().
>> - Instead of mapping all the MSI interrupts in the probe, changed
>>   to map only when a MSI is requested.
>> - Earlier, the implementation of legacy and MSI interrupts init-
>>   is mutually exclusive, now changed to have the legacy interrupts
>>   init always and MSI interrupt init based on CONFIG_PCI_MSI flag.
>> - Regarding the MSI generic implementation comment, I will plan to
>>   do on top of this driver patch.
>> - Rebased on 3.16-rc2.
>> - Fixed other minor comments.
>> - Thanks Arnd and Bjorn for the review.
>>
>> Changes in v3:
>> - Rebased on v3.15.0-rc1
>> - Added support for interrupt-map DT functionality.
>> - Removed map_irq() wrapper, instead using of_irq_parse_and_map_pci().
>> - Modified resource mapping logic as per the series
>>   "PCI: ARM: add support for generic PCI host controller"
>> - Modified devicetree binding documentation to update with interrupt-
>>   map properties.
>> - Use devm calls wherever applicable.
>> - Fixed minor comments from Jason
>> - Thanks Jason for the review and suggestions.
>>
>> Changes in v2:
>> - Rebased on v3.14.0-rc8
>> - Removed IP specific DT properties like include-rc, axibar-num etc.,
>>   as suggested by Jason and Bjorn, Thanks
>> ---
>>  .../devicetree/bindings/pci/xilinx-pcie.txt        |   62 ++
>>  drivers/pci/host/Kconfig                           |    7 +
>>  drivers/pci/host/Makefile                          |    1 +
>>  drivers/pci/host/pci-xilinx.c                      | 1027 ++++++++++++++++++++
>>  4 files changed, 1097 insertions(+)
>>  create mode 100644 Documentation/devicetree/bindings/pci/xilinx-pcie.txt
>>  create mode 100644 drivers/pci/host/pci-xilinx.c
>
> I see I forgot to ask for a MAINTAINERS entry for this driver.  Can
> you add one?

There was a discussion on this earlier and Michal mentioned it is not
required as it is
handled by our Xilinx record.

Here is the reply from Michal to the MAINTAINERS update comment,

< Reply from Michal >

> Please also include a MAINTAINERS update for drivers/pci/host/pci-xilinx.c.

This should be handle by our record that's why MAINTAINERS update is
not necessary.
(N: xilinx below)

ARM/ZYNQ ARCHITECTURE
M:      Michal Simek <michal.simek@xilinx.com>
L:      linux-arm-kernel@lists.infradead.org (moderated for non-subscribers)
W:      http://wiki.xilinx.com
T:      git git://git.xilinx.com/linux-xlnx.git
S:      Supported
F:      arch/arm/mach-zynq/
F:      drivers/cpuidle/cpuidle-zynq.c
N:      zynq
N:      xilinx
F:      drivers/clocksource/cadence_ttc_timer.c
F:      drivers/mmc/host/sdhci-of-arasan.c

Thanks,
Michal

< Reply from Michal >

>
> I'd also like an ack from Arnd or another devicetree person for the
> binding.

Sure, I will request them.

>
> I have a few minor comments below.

Sure.

>
>> diff --git a/Documentation/devicetree/bindings/pci/xilinx-pcie.txt b/Documentation/devicetree/bindings/pci/xilinx-pcie.txt
>> new file mode 100644
>> index 0000000..3e2c88d
>> --- /dev/null
>> +++ b/Documentation/devicetree/bindings/pci/xilinx-pcie.txt
>> @@ -0,0 +1,62 @@
>> +* Xilinx AXI PCIe Root Port Bridge DT description
>> +
>> +Required properties:
>> +- #address-cells: Address representation for root ports, set to <3>
>> +- #size-cells: Size representation for root ports, set to <2>
>> +- #interrupt-cells: specifies the number of cells needed to encode an
>> +     interrupt source. The value must be 1.
>> +- compatible: Should contain "xlnx,axi-pcie-host-1.00.a"
>> +- reg: Should contain AXI PCIe registers location and length
>> +- device_type: must be "pci"
>> +- interrupts: Should contain AXI PCIe interrupt
>> +- interrupt-map-mask,
>> +  interrupt-map: standard PCI properties to define the mapping of the
>> +     PCI interface to interrupt numbers.
>> +- ranges: ranges for the PCI memory regions (I/O space region is not
>> +     supported by hardware)
>> +     Please refer to the standard PCI bus binding document for a more
>> +     detailed explanation
>> +
>> +Optional properties:
>> +- bus-range: PCI bus numbers covered
>> +
>> +Interrupt controller child node
>> ++++++++++++++++++++++++++++++++
>> +Required properties:
>> +- interrupt-controller: identifies the node as an interrupt controller
>> +- #address-cells: specifies the number of cells needed to encode an
>> +     address. The value must be 0.
>> +- #interrupt-cells: specifies the number of cells needed to encode an
>> +     interrupt source. The value must be 1.
>> +
>> +NOTE:
>> +The core provides a single interrupt for both INTx/MSI messages. So,
>> +created a interrupt controller node to support 'interrupt-map' DT
>> +functionality.  The driver will create an IRQ domain for this map, decode
>> +the four INTx interrupts in ISR and route them to this domain.
>> +
>> +
>> +Example:
>> +++++++++
>> +
>> +     pci_express: axi-pcie@50000000 {
>> +             #address-cells = <3>;
>> +             #size-cells = <2>;
>> +             #interrupt-cells = <1>;
>> +             compatible = "xlnx,axi-pcie-host-1.00.a";
>> +             reg = < 0x50000000 0x10000000 >;
>> +             device_type = "pci";
>> +             interrupts = < 0 52 4 >;
>> +             interrupt-map-mask = <0 0 0 7>;
>> +             interrupt-map = <0 0 0 1 &pcie_intc 1>,
>> +                             <0 0 0 2 &pcie_intc 2>,
>> +                             <0 0 0 3 &pcie_intc 3>,
>> +                             <0 0 0 4 &pcie_intc 4>;
>> +             ranges = < 0x02000000 0 0x60000000 0x60000000 0 0x10000000 >;
>> +
>> +             pcie_intc: interrupt-controller {
>> +                     interrupt-controller;
>> +                     #address-cells = <0>;
>> +                     #interrupt-cells = <1>;
>> +             }
>> +     };
>> diff --git a/drivers/pci/host/Kconfig b/drivers/pci/host/Kconfig
>> index 21df477..afedcde 100644
>> --- a/drivers/pci/host/Kconfig
>> +++ b/drivers/pci/host/Kconfig
>> @@ -46,4 +46,11 @@ config PCI_HOST_GENERIC
>>         Say Y here if you want to support a simple generic PCI host
>>         controller, such as the one emulated by kvmtool.
>>
>> +config PCI_XILINX
>> +     bool "Xilinx AXI PCIe host bridge support"
>> +     depends on ARCH_ZYNQ
>> +     help
>> +       Say 'Y' here if you want kernel to support the Xilinx AXI PCIe
>> +       Host Bridge driver.
>> +
>>  endmenu
>> diff --git a/drivers/pci/host/Makefile b/drivers/pci/host/Makefile
>> index 611ba4b..68dfd06 100644
>> --- a/drivers/pci/host/Makefile
>> +++ b/drivers/pci/host/Makefile
>> @@ -6,3 +6,4 @@ obj-$(CONFIG_PCI_TEGRA) += pci-tegra.o
>>  obj-$(CONFIG_PCI_RCAR_GEN2) += pci-rcar-gen2.o
>>  obj-$(CONFIG_PCI_RCAR_GEN2_PCIE) += pcie-rcar.o
>>  obj-$(CONFIG_PCI_HOST_GENERIC) += pci-host-generic.o
>> +obj-$(CONFIG_PCI_XILINX) += pci-xilinx.o
>> diff --git a/drivers/pci/host/pci-xilinx.c b/drivers/pci/host/pci-xilinx.c
>> new file mode 100644
>> index 0000000..57d59e7
>> --- /dev/null
>> +++ b/drivers/pci/host/pci-xilinx.c
>> @@ -0,0 +1,1027 @@
>> +/*
>> + * PCIe host controller driver for Xilinx AXI PCIe Bridge
>> + *
>> + * Copyright (c) 2012 - 2014 Xilinx, Inc.
>> + *
>> + * Based on the Tegra PCIe driver
>> + *
>> + * Bits taken from Synopsys Designware Host controller driver and
>> + * ARM PCI Host generic driver.
>> + *
>> + * This program is free software: you can redistribute it and/or modify
>> + * it under the terms of the GNU General Public License as published by
>> + * the Free Software Foundation, either version 2 of the License, or
>> + * (at your option) any later version.
>> + */
>> +
>> +#include <linux/interrupt.h>
>> +#include <linux/irq.h>
>> +#include <linux/irqdomain.h>
>> +#include <linux/kernel.h>
>> +#include <linux/module.h>
>> +#include <linux/msi.h>
>> +#include <linux/of_address.h>
>> +#include <linux/of_pci.h>
>> +#include <linux/of_platform.h>
>> +#include <linux/of_irq.h>
>> +#include <linux/pci.h>
>> +#include <linux/platform_device.h>
>> +
>> +/* Register definitions */
>> +#define XILINX_PCIE_REG_VSECC                0x00000128
>> +#define XILINX_PCIE_REG_VSECH                0x0000012c
>> +#define XILINX_PCIE_REG_BIR          0x00000130
>> +#define XILINX_PCIE_REG_BSCR         0x00000134
>> +#define XILINX_PCIE_REG_IDR          0x00000138
>> +#define XILINX_PCIE_REG_IMR          0x0000013c
>> +#define XILINX_PCIE_REG_BLR          0x00000140
>> +#define XILINX_PCIE_REG_PSCR         0x00000144
>> +#define XILINX_PCIE_REG_RPSC         0x00000148
>> +#define XILINX_PCIE_REG_MSIBASE1     0x0000014c
>> +#define XILINX_PCIE_REG_MSIBASE2     0x00000150
>> +#define XILINX_PCIE_REG_RPEFR                0x00000154
>> +#define XILINX_PCIE_REG_RPIFR1               0x00000158
>> +#define XILINX_PCIE_REG_RPIFR2               0x0000015c
>> +#define XILINX_PCIE_REG_VSECC2               0x00000200
>> +#define XILINX_PCIE_REG_VSECH2               0x00000204
>> +
>> +/* Interrupt registers definitions */
>> +#define XILINX_PCIE_INTR_LINK_DOWN   BIT(0)
>> +#define XILINX_PCIE_INTR_ECRC_ERR    BIT(1)
>> +#define XILINX_PCIE_INTR_STR_ERR     BIT(2)
>> +#define XILINX_PCIE_INTR_HOT_RESET   BIT(3)
>> +#define XILINX_PCIE_INTR_CFG_COMPL   GENMASK(7, 5)
>> +#define XILINX_PCIE_INTR_CFG_TIMEOUT BIT(8)
>> +#define XILINX_PCIE_INTR_CORRECTABLE BIT(9)
>> +#define XILINX_PCIE_INTR_NONFATAL    BIT(10)
>> +#define XILINX_PCIE_INTR_FATAL               BIT(11)
>> +#define XILINX_PCIE_INTR_INTX                BIT(16)
>> +#define XILINX_PCIE_INTR_MSI         BIT(17)
>> +#define XILINX_PCIE_INTR_SLV_UNSUPP  BIT(20)
>> +#define XILINX_PCIE_INTR_SLV_UNEXP   BIT(21)
>> +#define XILINX_PCIE_INTR_SLV_COMPL   BIT(22)
>> +#define XILINX_PCIE_INTR_SLV_ERRP    BIT(23)
>> +#define XILINX_PCIE_INTR_SLV_CMPABT  BIT(24)
>> +#define XILINX_PCIE_INTR_SLV_ILLBUR  BIT(25)
>> +#define XILINX_PCIE_INTR_MST_DECERR  BIT(26)
>> +#define XILINX_PCIE_INTR_MST_SLVERR  BIT(27)
>> +#define XILINX_PCIE_INTR_MST_ERRP    BIT(28)
>> +#define XILINX_PCIE_IMR_ALL_MASK     0x1FF30FED
>> +#define XILINX_PCIE_IDR_ALL_MASK     0xFFFFFFFF
>> +
>> +/* Root Port Error FIFO Read Register definitions */
>> +#define XILINX_PCIE_RPEFR_ERR_VALID  BIT(18)
>> +#define XILINX_PCIE_RPEFR_REQ_ID     GENMASK(15, 0)
>> +#define XILINX_PCIE_RPEFR_ALL_MASK   0xFFFFFFFF
>> +
>> +/* Root Port Interrupt FIFO Read Register 1 definitions */
>> +#define XILINX_PCIE_RPIFR1_INTR_VALID        BIT(31)
>> +#define XILINX_PCIE_RPIFR1_MSI_INTR  BIT(30)
>> +#define XILINX_PCIE_RPIFR1_INTR_ASSRT        BIT(29)
>> +#define XILINX_PCIE_RPIFR1_INTR_MASK GENMASK(28, 27)
>> +#define XILINX_PCIE_RPIFR1_MSI_ADR_MASK      GENMASK(26, 16)
>> +#define XILINX_PCIE_RPIFR1_ALL_MASK  0xFFFFFFFF
>> +#define XILINX_PCIE_RPIFR1_INTR_SHIFT                27
>> +#define XILINX_PCIE_RPIFR1_MSI_ADR_SHIFT     16
>> +
>> +/* Bridge Info Register definitions */
>> +#define XILINX_PCIE_BIR_ECAM_SZ_MASK GENMASK(18, 16)
>> +#define XILINX_PCIE_BIR_ECAM_SZ_SHIFT        16
>> +
>> +/* Root Port Interrupt FIFO Read Register 2 definitions */
>> +#define XILINX_PCIE_RPIFR2_MSG_DATA  GENMASK(15, 0)
>> +
>> +/* Root Port Status/control Register definitions */
>> +#define XILINX_PCIE_REG_RPSC_BEN     BIT(0)
>> +
>> +/* Phy Status/Control Register definitions */
>> +#define XILINX_PCIE_REG_PSCR_LNKUP   BIT(11)
>> +
>> +/* ECAM definitions */
>> +#define ECAM_BUS_NUM_SHIFT           20
>> +#define ECAM_DEV_NUM_SHIFT           12
>> +
>> +/* PCI Configuration space Bus Number Register definitions */
>> +#define PCI_SECONDARY_BUS_NUM_SHIFT  8
>> +#define PCI_SUBORDINATE_BUS_NUM_SHIFT        16
>> +#define PCI_LATENCY_TIMER_MASK               GENMASK(31, 24)
>
> These three #defines aren't used; can you remove them?  (If you need
> them someday, you should either try to use generic definitions from
> include/uapi/linux/pci_regs.h, or if they're Xilinx-specific, rename
> them so they look Xilinx-specific rather than generic.

Ok.

>
>> +
>> +/* Number of MSI IRQs */
>> +#define XILINX_NUM_MSI_IRQS          128
>> +
>> +/* Number of Memory Resources */
>> +#define XILINX_MAX_NUM_RESOURCES     3
>> +
>> +/**
>> + * struct xilinx_pcie_port - PCIe port information
>> + * @reg_base: IO Mapped Register Base
>> + * @irq: Interrupt number
>> + * @msi_pages: MSI pages
>> + * @root_busno: Root Bus number
>> + * @link_up: Link status flag
>> + * @dev: Device pointer
>> + * @irq_domain: IRQ domain pointer
>> + * @bus_range: Bus range
>> + * @resources: Bus Resources
>> + */
>> +struct xilinx_pcie_port {
>> +     void __iomem *reg_base;
>> +     u32 irq;
>> +     unsigned long msi_pages;
>> +     u8 root_busno;
>> +     bool link_up;
>> +     struct device *dev;
>> +     struct irq_domain *irq_domain;
>> +     struct resource bus_range;
>> +     struct list_head resources;
>> +};
>> +
>> +static DECLARE_BITMAP(msi_irq_in_use, XILINX_NUM_MSI_IRQS);
>> +
>> +static inline struct xilinx_pcie_port *sys_to_pcie(struct pci_sys_data *sys)
>> +{
>> +     return sys->private_data;
>> +}
>> +
>> +static inline u32 pcie_read(struct xilinx_pcie_port *port, u32 reg)
>> +{
>> +     return readl(port->reg_base + reg);
>> +}
>> +
>> +static inline void pcie_write(struct xilinx_pcie_port *port,
>> +                           u32 val, u32 reg)
>> +{
>> +     writel(val, port->reg_base + reg);
>> +}
>> +
>> +static inline bool xilinx_pcie_is_link_up(struct xilinx_pcie_port *port)
>
> Bool function names should be statements or properties, not questions,
> since a statement can be true or false but a question cannot.  For
> example, in this case, "xilinx_pcie_link_up()" or
> "xilinx_pcie_link_is_up()" would read better.

Ok.

>
>> +{
>> +     return (pcie_read(port, XILINX_PCIE_REG_PSCR) &
>> +             XILINX_PCIE_REG_PSCR_LNKUP) ? 1 : 0;
>> +}
>> +
>> +/**
>> + * xilinx_pcie_clear_err_interrupts - Clear Error Interrupts
>> + * @port: PCIe port information
>> + */
>> +static inline void
>> +xilinx_pcie_clear_err_interrupts(struct xilinx_pcie_port *port)
>
> Put the signature all on one line.  It probably doesn't need to be
> inline (we're making a couple register accesses, so speed isn't a
> concern), and removing that will make it fit.

Ok.

>
>> +{
>> +     u32 val = pcie_read(port, XILINX_PCIE_REG_RPEFR);
>> +
>> +     if (val & XILINX_PCIE_RPEFR_ERR_VALID) {
>> +             dev_dbg(port->dev, "Requester ID %d\n",
>> +                     val & XILINX_PCIE_RPEFR_REQ_ID);
>> +             pcie_write(port, XILINX_PCIE_RPEFR_ALL_MASK,
>> +                        XILINX_PCIE_REG_RPEFR);
>> +     }
>> +}
>> +
>> +/**
>> + * xilinx_pcie_verify_config - Verify configuration
>> + * @bus: PCI Bus structure
>> + * @devfn: device/function
>> + *
>> + * Return: 0 on success and error value for invalid configuration
>> + */
>> +static int xilinx_pcie_verify_config(struct pci_bus *bus,
>> +                                  unsigned int devfn)
>
> "verify_config" is not a great function name because it doesn't give a
> good clue about what the return value is.  If you make it boolean and
> name it, e.g., xilinx_pcie_valid_device(), then it's obvious.

Ok.

>
>> +{
>> +     struct xilinx_pcie_port *port = sys_to_pcie(bus->sysdata);
>> +
>> +     /* Check if link is up when trying to access downstream ports */
>> +     if (bus->number != port->root_busno)
>> +             if (!xilinx_pcie_is_link_up(port))
>> +                     return -EINVAL;
>> +
>> +     /* Only one device down on each root port */
>> +     if (bus->number == port->root_busno && devfn > 0)
>> +             return -EINVAL;
>> +
>> +     /*
>> +      * Do not read more than one device on the bus directly attached
>> +      * to RC.
>> +      */
>> +     if (bus->primary == port->root_busno && devfn > 0)
>> +             return -EINVAL;
>> +
>> +     return 0;
>> +}
>> +
>> +/**
>> + * xilinx_pcie_get_config_base - Get configuration base
>> + * @bus: PCI Bus structure
>> + * @devfn: Device/function
>> + * @where: Offset from base
>> + *
>> + * Return: Base address of the configuration space needed to be
>> + *      accessed.
>> + */
>> +static void __iomem *xilinx_pcie_get_config_base(struct pci_bus *bus,
>> +                                              unsigned int devfn,
>> +                                              int where)
>
> "xilinx_pcie_config_base()" would be sufficient.  We use "get" as a
> clue that we're acquiring a reference (obviously not an issue here,
> but I think the "get" in this function name is still a bit redundant.)

Ok.

>
>> +{
>> +     struct xilinx_pcie_port *port = sys_to_pcie(bus->sysdata);
>> +     int relbus;
>> +
>> +     relbus = (bus->number << ECAM_BUS_NUM_SHIFT) |
>> +              (devfn << ECAM_DEV_NUM_SHIFT);
>> +
>> +     return port->reg_base + relbus + where;
>> +}
>> +
>> +/**
>> + * xilinx_pcie_read_config - Read configuration space
>> + * @bus: PCI Bus structure
>> + * @devfn: Device/function
>> + * @where: Offset from base
>> + * @size: Byte/word/dword
>> + * @val: Value to be read
>> + *
>> + * Return: PCIBIOS_SUCCESSFUL on success
>> + *      EINVAL/PCIBIOS_DEVICE_NOT_FOUND/PCIBIOS_BAD_REGISTER_NUMBER
>> + *      on failure.
>> + */
>> +static int xilinx_pcie_read_config(struct pci_bus *bus,
>> +                                unsigned int devfn, int where,
>> +                                int size, u32 *val)
>> +{
>> +     struct xilinx_pcie_port *port = sys_to_pcie(bus->sysdata);
>> +     void __iomem *addr;
>> +
>> +     if (!port) {
>> +             BUG();
>> +             return -EINVAL;
>> +     }
>
> I don't think you need to test "port" for NULL here.  And I don't
> think callers will be prepared for -EINVAL anyway; they'll be
> expecting PCIBIOS_* values.

Ok, I will fix in all the suggested places.

>
>> +     if (xilinx_pcie_verify_config(bus, devfn)) {
>> +             *val = 0xFFFFFFFF;
>> +             return PCIBIOS_DEVICE_NOT_FOUND;
>> +     }

<snip>

>> + */
>> +static void xilinx_pcie_add_bus(struct pci_bus *bus)
>> +{
>> +     if (IS_ENABLED(CONFIG_PCI_MSI)) {
>
> Did you verify that this builds with both CONFIG_PCI_MSI=y and with it
> unset?

Yes, I have tested.

< snip >

>> +{
>> +     port->link_up = xilinx_pcie_is_link_up(port);
>> +     if (!port->link_up)
>
> I'd use "if (port->link_up)" and reorder the dev_info() to avoid the
> negation (trivial, I know, but why use the negative when the positive
> works just as well?)

Ok.

>
>> +             dev_info(port->dev, "PCIe Link is DOWN\n");
>> +     else
>> +             dev_info(port->dev, "PCIe Link is UP\n");
>> +
>> +     /* Disable all interrupts*/
>> +     pcie_write(port, ~XILINX_PCIE_IDR_ALL_MASK,
>> +                XILINX_PCIE_REG_IMR);
>> +
>> +     /* Clear pending interrupts */
>> +     pcie_write(port, pcie_read(port, XILINX_PCIE_REG_IDR) &
>> +                      XILINX_PCIE_IMR_ALL_MASK,
>> +                XILINX_PCIE_REG_IDR);
>> +
>> +     /* Enable all interrupts*/
>
> Missing space before "*/" (also on "Disable all interrupts" comment).

Ok.

>
>> +     pcie_write(port, XILINX_PCIE_IMR_ALL_MASK, XILINX_PCIE_REG_IMR);
>> +
>> +     /* Enable the Bridge enable bit */
>> +     pcie_write(port, pcie_read(port, XILINX_PCIE_REG_RPSC) |
>> +                      XILINX_PCIE_REG_RPSC_BEN,
>> +                XILINX_PCIE_REG_RPSC);
>> +}
>> +
>> +/**
>> + * xilinx_pcie_setup - Setup memory resources
>> + * @nr: Bus number
>> + * @sys: Per controller structure
>> + *
>> + * Return: '1' on success and error value on failure
>
> Incorrect.  No point in a comment that explains obvious code anyway.
> But maybe DocBook requires it, and I guess it's OK then.
>

Ok.

>> + */
>> +static int xilinx_pcie_setup(int nr, struct pci_sys_data *sys)
>> +{
>> +     struct xilinx_pcie_port *port = sys_to_pcie(sys);
>> +
>> +     list_splice_init(&port->resources, &sys->resources);
>> +
>> +     return 1;
>> +}
>> +
>> +/**
>> + * xilinx_pcie_scan_bus - Scan PCIe bus for devices
>> + * @nr: Bus number
>> + * @sys: Per controller structure
>> + *
>> + * Return: Valid Bus pointer on success and NULL on failure
>> + */
>> +static struct pci_bus __init *xilinx_pcie_scan_bus(int nr,
>> +                                                struct pci_sys_data *sys)
>> +{
>> +     struct xilinx_pcie_port *port = sys_to_pcie(sys);
>> +     struct pci_bus *bus;
>> +
>> +     if (port) {
>
> I think this test (and the BUG()) is superfluous.  I don't think it's
> possible to get here with sys->private_data == NULL.  And if we do,
> we'll take a null pointer fault and get a nice backtrace anyway.

Ok.

>
>> +             port->root_busno = sys->busnr;
>> +             bus = pci_scan_root_bus(port->dev, sys->busnr, &xilinx_pcie_ops,
>> +                                     sys, &sys->resources);
>> +     } else {
>> +             bus = NULL;
>> +             BUG();
>> +     }

< snip >

>> +MODULE_AUTHOR("Xilinx Inc");
>> +MODULE_DESCRIPTION("Xilinx AXI PCIe driver");
>> +MODULE_LICENSE("GPLv2");
>
> I think you want "GPL v2" here (with the space; see
> license_is_gpl_compatible()).

I will fix them in my v5.

Thanks for the review,
Srikanth.

> --
> To unsubscribe from this list: send the line "unsubscribe linux-pci" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
