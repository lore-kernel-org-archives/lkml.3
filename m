Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752784AbaABVJl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Jan 2014 16:09:41 -0500
Received: from mail-ie0-f175.google.com ([209.85.223.175]:32945 "EHLO
	mail-ie0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752647AbaABVJg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Jan 2014 16:09:36 -0500
MIME-Version: 1.0
In-Reply-To: <1387785725-24262-2-git-send-email-tinamdar@apm.com>
References: <1387785725-24262-1-git-send-email-tinamdar@apm.com> <1387785725-24262-2-git-send-email-tinamdar@apm.com>
From: Bjorn Helgaas <bhelgaas@google.com>
Date: Thu, 2 Jan 2014 14:08:55 -0700
Message-ID: <CAErSpo7_RZvG9NUiORvp38hjY-F9q_Q-=uYVvNb1N1vjV=eijw@mail.gmail.com>
Subject: Re: [RFC PATCH 1/3] pci: APM X-Gene PCIe controller driver
To: Tanmay Inamdar <tinamdar@apm.com>
Cc: Grant Likely <grant.likely@linaro.org>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Rob Landley <rob@landley.net>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        linux-arm <linux-arm-kernel@lists.infradead.org>,
        linux-doc@vger.kernel.org,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        patches@apm.com, jcm@redhat.com
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 23, 2013 at 1:02 AM, Tanmay Inamdar <tinamdar@apm.com> wrote:
> This patch adds the AppliedMicro X-gene SOC PCIe controller driver.
> APM X-Gene PCIe controller supports maximum upto 8 lanes and
> GEN3 speed. X-Gene has maximum 5 PCIe ports supported.
>
> Signed-off-by: Tanmay Inamdar <tinamdar@apm.com>

Since Jason requested "lspci" output, I'm waiting for him to review
these before applying them.

Also, please include a MAINTAINERS update showing who should approve
future changes to this file.

Bjorn

> ---
>  drivers/pci/host/Kconfig      |    5 +
>  drivers/pci/host/Makefile     |    1 +
>  drivers/pci/host/pcie-xgene.c | 1017 +++++++++++++++++++++++++++++++++++++++++
>  3 files changed, 1023 insertions(+)
>  create mode 100644 drivers/pci/host/pcie-xgene.c
>
> diff --git a/drivers/pci/host/Kconfig b/drivers/pci/host/Kconfig
> index 47d46c6..6d8fcbc 100644
> --- a/drivers/pci/host/Kconfig
> +++ b/drivers/pci/host/Kconfig
> @@ -33,4 +33,9 @@ config PCI_RCAR_GEN2
>           There are 3 internal PCI controllers available with a single
>           built-in EHCI/OHCI host controller present on each one.
>
> +config PCI_XGENE
> +       bool "X-Gene PCIe controller"
> +       depends on ARCH_XGENE
> +       depends on OF
> +
>  endmenu
> diff --git a/drivers/pci/host/Makefile b/drivers/pci/host/Makefile
> index 13fb333..a0bdfa7 100644
> --- a/drivers/pci/host/Makefile
> +++ b/drivers/pci/host/Makefile
> @@ -4,3 +4,4 @@ obj-$(CONFIG_PCI_IMX6) += pci-imx6.o
>  obj-$(CONFIG_PCI_MVEBU) += pci-mvebu.o
>  obj-$(CONFIG_PCI_TEGRA) += pci-tegra.o
>  obj-$(CONFIG_PCI_RCAR_GEN2) += pci-rcar-gen2.o
> +obj-$(CONFIG_PCI_XGENE) += pcie-xgene.o
> diff --git a/drivers/pci/host/pcie-xgene.c b/drivers/pci/host/pcie-xgene.c
> new file mode 100644
> index 0000000..c9403c3
> --- /dev/null
> +++ b/drivers/pci/host/pcie-xgene.c
> @@ -0,0 +1,1017 @@
> +/**
> + * APM X-Gene PCIe Driver
> + *
> + * Copyright (c) 2013 Applied Micro Circuits Corporation.
> + *
> + * Author: Tanmay Inamdar <tinamdar@apm.com>.
> + *
> + * This program is free software; you can redistribute  it and/or modify it
> + * under  the terms of  the GNU General  Public License as published by the
> + * Free Software Foundation;  either version 2 of the  License, or (at your
> + * option) any later version.
> + *
> + * This program is distributed in the hope that it will be useful,
> + * but WITHOUT ANY WARRANTY; without even the implied warranty of
> + * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> + * GNU General Public License for more details.
> + *
> + */
> +#include <linux/module.h>
> +#include <linux/delay.h>
> +#include <linux/pci.h>
> +#include <linux/slab.h>
> +#include <linux/memblock.h>
> +#include <linux/io.h>
> +#include <linux/platform_device.h>
> +#include <linux/of.h>
> +#include <linux/of_address.h>
> +#include <linux/of_irq.h>
> +#include <linux/of_pci.h>
> +#include <linux/jiffies.h>
> +#include <linux/clk-private.h>
> +#ifdef CONFIG_ARM64
> +#include <asm/pcibios.h>
> +#else
> +#include <asm/mach/pci.h>
> +#endif
> +
> +#define PCIECORE_LTSSM                 0x4c
> +#define PCIECORE_CTLANDSTATUS          0x50
> +#define PIPE_PHY_RATE_RD(src)          ((0xc000 & (u32)(src)) >> 0xe)
> +#define INTXSTATUSMASK                 0x6c
> +#define PIM1_1L                                0x80
> +#define IBAR2                          0x98
> +#define IR2MSK                         0x9c
> +#define PIM2_1L                                0xa0
> +#define OMR1BARL                       0x100
> +#define OMR2BARL                       0x118
> +#define CFGBARL                                0x154
> +#define CFGBARH                                0x158
> +#define CFGCTL                         0x15c
> +#define RTDID                          0x160
> +#define CFG_CONSTANTS_31_00            0x2000
> +#define CFG_CONSTANTS_63_32            0x2004
> +#define CFG_CONSTANTS_159_128          0x2010
> +#define CFG_CONSTANTS_415_384           0x2030
> +#define ENABLE_L1S_POWER_MGMT_SET(dst, src)     (((dst) & ~0x02000000) | \
> +                                               (((u32)(src) << 0x19) & \
> +                                               0x02000000))
> +#define CFG_CONSTANTS_479_448          0x2038
> +#define CFG_8G_CONSTANTS_31_0          0x2100
> +#define MGMT_US_PORT_TX_PRESET_SET(dst, src)    (((dst) & ~0xf00)| \
> +                                               (((u32)(src) << 0x8) & 0xf00))
> +#define MGMT_DS_PORT_TX_PRESET_SET(dst, src)    (((dst) & ~0xf) | \
> +                                               (((u32)(src)) & 0xf))
> +
> +#define CFG_8G_CONSTANTS_159_128        0x2110
> +#define EQ_UPDN_POST_STEP_SET(dst, src)                (((dst) & ~0x30) | \
> +                                               (((u32)(src) << 0x4) & \
> +                                               0x30))
> +#define CFG_8G_CONSTANTS_287_256        0x2120
> +#define CFG_8G_CONSTANTS_319_288        0x2124
> +#define CFG_8G_CONSTANTS_351_320        0x2128
> +#define CFG_8G_CONSTANTS_383_352        0x212c
> +#define EQ_PRE_CURSOR_LANE0_SET(dst, src)      (((dst) & ~0xff) | \
> +                                               (((u32)(src)) & 0xff))
> +#define EQ_PRE_CURSOR_LANE1_SET(dst, src)      (((dst) & ~0x00ff0000) | \
> +                                               (((u32)(src) << 0x10) & \
> +                                               0x00ff0000))
> +
> +#define CFG_CONTROL_63_32              0x2204
> +#define CFG_CONTROL_95_64               0x2208
> +#define CFG_CONTROL_191_160            0x2214
> +#define PCIE_STATUS_31_0               0x2600
> +#define MEM_RAM_SHUTDOWN                0xd070
> +#define BLOCK_MEM_RDY                   0xd074
> +
> +#define PCI_PRIMARY_BUS_MASK           0x00ffffff
> +#define REVISION_ID_MASK               0x000000ff
> +#define SLOT_IMPLEMENTED_MASK          0x04000000
> +#define DEVICE_PORT_TYPE_MASK          0x03c00000
> +#define ADVT_INFINITE_CREDITS          0x00000200
> +#define PM_FORCE_RP_MODE_MASK          0x00000400
> +#define SWITCH_PORT_MODE_MASK          0x00000800
> +#define CLASS_CODE_MASK                        0xffffff00
> +#define LINK_UP_MASK                   0x00000100
> +#define AER_OPTIONAL_ERROR_EN          0xffc00000
> +#define DWNSTRM_EQ_SKP_PHS_2_3         0x00010000
> +#define DIRECT_TO_5GTS_MASK            0x00020000
> +#define SUPPORT_5GTS_MASK              0x00010000
> +#define DIRECT_TO_8GTS_MASK            0x00008000
> +#define SUPPORT_8GTS_MASK              0x00004000
> +#define XGENE_PCIE_DEV_CTRL            0x2f0f
> +#define AXI_EP_CFG_ACCESS              0x10000
> +#define ENABLE_ASPM                    0x08000000
> +#define XGENE_PORT_TYPE_RC             0x05000000
> +#define BLOCK_MEM_RDY_VAL               0xFFFFFFFF
> +#define EN_COHERENCY                   0xF0000000
> +#define EN_REG                         0x00000001
> +#define OB_LO_IO                       0x00000002
> +#define XGENE_PCIE_VENDORID            0x19AA
> +#define XGENE_PCIE_BRIDGE_DEVICEID     0xE008
> +#define XGENE_PCIE_DEVICEID            0xCAFE
> +#define XGENE_PCIE_TIMEOUT             (500*1000) /* us */
> +#define XGENE_PCIE_MAX_REGIONS         3
> +#define XGENE_LTSSM_DETECT_WAIT                20
> +#define XGENE_LTSSM_L0_WAIT            4
> +#define XGENE_PCIE_PHY_DRV             "pcie-8g"
> +#define XGENE_PCIE_CLK_DRV             "pcieclk"
> +#define XGENE_PCIE_MAX_PORTS           5
> +#define XGENE_PCIE_EP_MEM_SIZE         0x100000
> +
> +enum {
> +       PTYPE_ENDPOINT = 0x0,
> +       PTYPE_LEGACY_ENDPOINT = 0x1,
> +       PTYPE_ROOT_PORT = 0x4,
> +
> +       LNKW_X1 = 0x1,
> +       LNKW_X4 = 0x4,
> +       LNKW_X8 = 0x8,
> +
> +       PCIE_GEN1 = 0x0,        /* 2.5G */
> +       PCIE_GEN2 = 0x1,        /* 5.0G */
> +       PCIE_GEN3 = 0x2,        /* 8.0G */
> +};
> +
> +enum {
> +       XGENE_MEM,
> +       XGENE_MSI,
> +       XGENE_IO,
> +       XGENE_RES       /* termination */
> +};
> +
> +struct xgene_pcie_ep_info {
> +       void            *reg_virt;      /* maps to outbound space of RC */
> +       dma_addr_t      reg_phys;       /* Physical address of reg space */
> +};
> +
> +struct xgene_pcie_port {
> +       struct device_node              *node;
> +       struct resource                 res[XGENE_RES];
> +       u8                              type;
> +       u8                              link_up;
> +       u8                              link_speed;
> +       u32                             first_busno;
> +       void                            *csr_base;
> +       void                            *cfg_base;
> +       struct device                   *dev;
> +       struct xgene_pcie_ep_info       ep_info;
> +       struct clk                      *clk;
> +};
> +
> +#ifdef CONFIG_64BIT
> +#define pci_io_offset(s)               (s & 0xff00000000)
> +#else
> +#define pci_io_offset(s)               (s & 0x00000000)
> +#endif /* CONFIG_64BIT */
> +
> +static inline struct xgene_pcie_port *
> +xgene_pcie_sys_to_port(struct pci_sys_data *sys)
> +{
> +       return (struct xgene_pcie_port *)sys->private_data;
> +}
> +
> +static inline struct xgene_pcie_port *
> +xgene_pcie_bus_to_port(struct pci_bus *bus)
> +{
> +       struct pci_sys_data *sys = bus->sysdata;
> +       return xgene_pcie_sys_to_port(sys);
> +}
> +
> +/* IO ports are memory mapped */
> +void __iomem *__pci_ioport_map(struct pci_dev *dev, unsigned long port,
> +                              unsigned int nr)
> +{
> +       return devm_ioremap_nocache(&dev->dev, port, nr);
> +}
> +
> +/* PCIE Out/In to CSR */
> +static inline void xgene_pcie_out32(void *addr, u32 val)
> +{
> +       pr_debug("pcie csr wr: 0x%llx 0x%08x\n", (phys_addr_t)addr, val);
> +       writel(val, addr);
> +}
> +
> +static inline void xgene_pcie_in32(void *addr, u32 *val)
> +{
> +       *val = readl(addr);
> +       pr_debug("pcie csr rd: 0x%llx 0x%08x\n", (phys_addr_t)addr, *val);
> +}
> +
> +/* PCIE Configuration Out/In */
> +static inline void xgene_pcie_cfg_out32(void *addr, u32 val)
> +{
> +       writel(val, addr);
> +}
> +
> +static inline void xgene_pcie_cfg_out16(void *addr, u16 val)
> +{
> +       phys_addr_t temp_addr = (phys_addr_t) addr & ~0x3;
> +       u32 val32 = readl((void *)temp_addr);
> +
> +       switch ((phys_addr_t) addr & 0x3) {
> +       case 2:
> +               val32 &= ~0xFFFF0000;
> +               val32 |= (u32) val << 16;
> +               break;
> +       case 0:
> +       default:
> +               val32 &= ~0xFFFF;
> +               val32 |= val;
> +               break;
> +       }
> +       writel(val32, (void *)temp_addr);
> +}
> +
> +static inline void xgene_pcie_cfg_out8(void *addr, u8 val)
> +{
> +       phys_addr_t temp_addr = (phys_addr_t) addr & ~0x3;
> +       u32 val32 = readl((void *)temp_addr);
> +
> +       switch ((phys_addr_t) addr & 0x3) {
> +       case 0:
> +               val32 &= ~0xFF;
> +               val32 |= val;
> +               break;
> +       case 1:
> +               val32 &= ~0xFF00;
> +               val32 |= (u32) val << 8;
> +               break;
> +       case 2:
> +               val32 &= ~0xFF0000;
> +               val32 |= (u32) val << 16;
> +               break;
> +       case 3:
> +       default:
> +               val32 &= ~0xFF000000;
> +               val32 |= (u32) val << 24;
> +               break;
> +       }
> +       writel(val32, (void *)temp_addr);
> +}
> +
> +static inline void xgene_pcie_cfg_in32(void *addr, u32 *val)
> +{
> +       *val = readl(addr);
> +}
> +
> +static inline void xgene_pcie_cfg_in16(void *addr, u16 *val)
> +{
> +       phys_addr_t temp_addr = (phys_addr_t) addr & ~0x3;
> +       u32 val32;
> +
> +       val32 = readl((void *)temp_addr);
> +
> +       switch ((phys_addr_t) addr & 0x3) {
> +       case 2:
> +               *val = val32 >> 16;
> +               break;
> +       case 0:
> +       default:
> +               *val = val32;
> +               break;
> +       }
> +}
> +
> +static inline void xgene_pcie_cfg_in8(void *addr, u8 *val)
> +{
> +       phys_addr_t temp_addr = (phys_addr_t) addr & ~0x3;
> +       u32 val32;
> +
> +       val32 = readl((void *)temp_addr);
> +
> +       switch ((phys_addr_t) addr & 0x3) {
> +       case 3:
> +               *val = val32 >> 24;
> +               break;
> +       case 2:
> +               *val = val32 >> 16;
> +               break;
> +       case 1:
> +               *val = val32 >> 8;
> +               break;
> +       case 0:
> +       default:
> +               *val = val32;
> +               break;
> +       }
> +}
> +
> +static void __iomem *xgene_pcie_get_cfg_base(struct pci_bus *bus)
> +{
> +       struct xgene_pcie_port *port = xgene_pcie_bus_to_port(bus);
> +       phys_addr_t addr = (phys_addr_t) port->cfg_base;
> +
> +       if (bus->number >= (port->first_busno + 1))
> +               addr |= AXI_EP_CFG_ACCESS;
> +
> +       return (void *)addr;
> +}
> +
> +static void xgene_pcie_set_rtdid_reg(struct pci_bus *bus, uint devfn)
> +{
> +       struct xgene_pcie_port *port = xgene_pcie_bus_to_port(bus);
> +       unsigned int b, d, f;
> +       u32 rtdid_val = 0;
> +
> +       b = bus->number;
> +       d = PCI_SLOT(devfn);
> +       f = PCI_FUNC(devfn);
> +
> +       if (bus->number == port->first_busno)
> +               rtdid_val = (b << 24) | (d << 19) | (f << 16);
> +       else if (bus->number >= (port->first_busno + 1))
> +               rtdid_val = (port->first_busno << 24) |
> +               (b << 8) | (d << 3) | f;
> +
> +       xgene_pcie_out32(port->csr_base + RTDID, rtdid_val);
> +       /* read the register back to ensure flush */
> +       xgene_pcie_in32(port->csr_base + RTDID, &rtdid_val);
> +}
> +
> +static int xgene_pcie_read_config(struct pci_bus *bus, unsigned int devfn,
> +                                 int offset, int len, u32 *val)
> +{
> +       void __iomem *addr;
> +       u8 val8;
> +       u16 val16;
> +
> +       if (pci_is_root_bus(bus) && devfn != 0)
> +               return PCIBIOS_DEVICE_NOT_FOUND;
> +
> +       xgene_pcie_set_rtdid_reg(bus, devfn);
> +       addr = xgene_pcie_get_cfg_base(bus);
> +       switch (len) {
> +       case 1:
> +               xgene_pcie_cfg_in8(addr + offset, &val8);
> +               *val = val8;
> +               break;
> +       case 2:
> +               xgene_pcie_cfg_in16(addr + offset, &val16);
> +               *val = val16;
> +               break;
> +       default:
> +               xgene_pcie_cfg_in32(addr + offset, val);
> +               break;
> +       }
> +       return PCIBIOS_SUCCESSFUL;
> +}
> +
> +static int xgene_pcie_write_config(struct pci_bus *bus, unsigned int devfn,
> +                                  int offset, int len, u32 val)
> +{
> +       void __iomem *addr;
> +
> +       if (pci_is_root_bus(bus) && devfn != 0)
> +               return PCIBIOS_DEVICE_NOT_FOUND;
> +
> +       xgene_pcie_set_rtdid_reg(bus, devfn);
> +       addr = xgene_pcie_get_cfg_base(bus);
> +       switch (len) {
> +       case 1:
> +               xgene_pcie_cfg_out8(addr + offset, (u8) val);
> +               break;
> +       case 2:
> +               xgene_pcie_cfg_out16(addr + offset, (u16) val);
> +               break;
> +       default:
> +               xgene_pcie_cfg_out32(addr + offset, val);
> +               break;
> +       }
> +       return PCIBIOS_SUCCESSFUL;
> +}
> +
> +static struct pci_ops xgene_pcie_ops = {
> +       .read = xgene_pcie_read_config,
> +       .write = xgene_pcie_write_config
> +};
> +
> +static void xgene_pcie_setup_lanes(struct xgene_pcie_port *port)
> +{
> +       void *csr_base = port->csr_base;
> +       u32 val;
> +
> +       xgene_pcie_in32(csr_base + CFG_8G_CONSTANTS_287_256, &val);
> +       val = EQ_PRE_CURSOR_LANE0_SET(val, 0x7);
> +       val = EQ_PRE_CURSOR_LANE1_SET(val, 0x7);
> +       xgene_pcie_out32(csr_base + CFG_8G_CONSTANTS_287_256, val);
> +
> +       xgene_pcie_in32(csr_base + CFG_8G_CONSTANTS_319_288, &val);
> +       val = EQ_PRE_CURSOR_LANE0_SET(val, 0x7);
> +       val = EQ_PRE_CURSOR_LANE1_SET(val, 0x7);
> +       xgene_pcie_out32(csr_base + CFG_8G_CONSTANTS_319_288, val);
> +
> +       xgene_pcie_in32(csr_base + CFG_8G_CONSTANTS_351_320, &val);
> +       val = EQ_PRE_CURSOR_LANE0_SET(val, 0x7);
> +       val = EQ_PRE_CURSOR_LANE1_SET(val, 0x7);
> +       xgene_pcie_out32(csr_base + CFG_8G_CONSTANTS_351_320, val);
> +
> +       xgene_pcie_in32(csr_base + CFG_8G_CONSTANTS_383_352, &val);
> +       val = EQ_PRE_CURSOR_LANE0_SET(val, 0x7);
> +       val = EQ_PRE_CURSOR_LANE1_SET(val, 0x7);
> +       xgene_pcie_out32(csr_base + CFG_8G_CONSTANTS_383_352, val);
> +
> +       xgene_pcie_in32(csr_base + CFG_8G_CONSTANTS_159_128, &val);
> +       val = EQ_UPDN_POST_STEP_SET(val, 0x1);
> +       val = EQ_UPDN_POST_STEP_SET(val, 0x1);
> +       xgene_pcie_out32(csr_base + CFG_8G_CONSTANTS_159_128, val);
> +}
> +
> +static void xgene_pcie_setup_link(struct xgene_pcie_port *port)
> +{
> +       void *csr_base = port->csr_base;
> +       u32 val;
> +
> +       xgene_pcie_in32(csr_base + CFG_CONSTANTS_479_448, &val);
> +       switch (port->link_speed) {
> +       case PCIE_GEN1:
> +               val &= ~SUPPORT_5GTS_MASK;
> +               val &= ~SUPPORT_8GTS_MASK;
> +               break;
> +       case PCIE_GEN2:
> +               val |= SUPPORT_5GTS_MASK;
> +               val |= DIRECT_TO_5GTS_MASK;
> +               val &= ~SUPPORT_8GTS_MASK;
> +               val &= ~DIRECT_TO_8GTS_MASK;
> +               break;
> +       case PCIE_GEN3:
> +               val |= DIRECT_TO_8GTS_MASK;
> +               val |= SUPPORT_5GTS_MASK;
> +               val |= SUPPORT_8GTS_MASK;
> +               val |= DIRECT_TO_5GTS_MASK;
> +               break;
> +       }
> +       xgene_pcie_out32(csr_base + CFG_CONSTANTS_479_448, val);
> +
> +       xgene_pcie_in32(csr_base + CFG_CONSTANTS_479_448, &val);
> +       val &= ~ADVT_INFINITE_CREDITS;
> +       xgene_pcie_out32(csr_base + CFG_CONSTANTS_479_448, val);
> +
> +       xgene_pcie_in32(csr_base + CFG_8G_CONSTANTS_31_0, &val);
> +       val |= MGMT_DS_PORT_TX_PRESET_SET(val, 0x7);
> +       val |= MGMT_US_PORT_TX_PRESET_SET(val, 0x7);
> +       xgene_pcie_out32(csr_base + CFG_8G_CONSTANTS_31_0, val);
> +
> +       if (port->link_speed == PCIE_GEN3) {
> +               xgene_pcie_in32(csr_base + CFG_8G_CONSTANTS_31_0, &val);
> +               val |= DWNSTRM_EQ_SKP_PHS_2_3;
> +               xgene_pcie_out32(csr_base + CFG_8G_CONSTANTS_31_0, val);
> +       }
> +}
> +
> +static void xgene_pcie_program_core(void *csr_base)
> +{
> +       u32 val;
> +
> +       xgene_pcie_in32(csr_base + CFG_CONSTANTS_31_00, &val);
> +       val |= AER_OPTIONAL_ERROR_EN;
> +       xgene_pcie_out32(csr_base + CFG_CONSTANTS_31_00, val);
> +       xgene_pcie_out32(csr_base + INTXSTATUSMASK, 0x0);
> +       xgene_pcie_in32(csr_base + CFG_CONTROL_63_32, &val);
> +       val = (val & ~0xffff) | XGENE_PCIE_DEV_CTRL;
> +       xgene_pcie_out32(csr_base + CFG_CONTROL_63_32, val);
> +}
> +
> +static u64 xgene_pcie_set_ib_mask(void *csr_base, u32 addr, u32 flags,
> +                                 resource_size_t size)
> +{
> +       u64 val64 = 0;
> +       u32 val32 = 0;
> +       u32 val;
> +
> +       if (size >= SZ_1K)
> +               val64 = (~(size - 1) & PCI_BASE_ADDRESS_MEM_MASK) | flags;
> +
> +       xgene_pcie_in32(csr_base + addr, &val32);
> +       val = (val32 & 0x0000ffff) | (lower_32_bits(val64) << 16);
> +       xgene_pcie_out32(csr_base + addr, val);
> +
> +       xgene_pcie_in32(csr_base + addr + 0x04, &val32);
> +       val = (val32 & 0xffff0000) | (lower_32_bits(val64) >> 16);
> +       xgene_pcie_out32(csr_base + addr + 0x04, val);
> +
> +       xgene_pcie_in32(csr_base + addr + 0x04, &val32);
> +       val = (val32 & 0x0000ffff) | (upper_32_bits(val64) << 16);
> +       xgene_pcie_out32(csr_base + addr + 0x04, val);
> +
> +       xgene_pcie_in32(csr_base + addr + 0x08, &val32);
> +       val = (val32 & 0xffff0000) | (upper_32_bits(val64) >> 16);
> +       xgene_pcie_out32(csr_base + addr + 0x08, val);
> +
> +       return val64;
> +}
> +
> +static void xgene_pcie_config_pims(void *csr_base, u32 addr,
> +                                  u64 pim, resource_size_t size)
> +{
> +       u32 val;
> +
> +       xgene_pcie_out32(csr_base + addr, lower_32_bits(pim));
> +       val = upper_32_bits(pim) | EN_COHERENCY;
> +       xgene_pcie_out32(csr_base + addr + 0x04, val);
> +       xgene_pcie_out32(csr_base + addr + 0x08, 0x0);
> +       xgene_pcie_out32(csr_base + addr + 0x0c, 0x0);
> +       val = lower_32_bits(size);
> +       xgene_pcie_out32(csr_base + addr + 0x10, val);
> +       val = upper_32_bits(size);
> +       xgene_pcie_out32(csr_base + addr + 0x14, val);
> +}
> +
> +static void xgene_pcie_poll_linkup(struct xgene_pcie_port *port, u32 *lanes)
> +{
> +       void *csr_base = port->csr_base;
> +       u32 val32;
> +       u64 start_time, time;
> +
> +       /*
> +        * A component enters the LTSSM Detect state within
> +        * 20ms of the end of fundamental core reset.
> +        */
> +       msleep(XGENE_LTSSM_DETECT_WAIT);
> +       port->link_up = 0;
> +       start_time = jiffies;
> +       do {
> +               xgene_pcie_in32(csr_base + PCIECORE_CTLANDSTATUS, &val32);
> +               if (val32 & LINK_UP_MASK) {
> +                       port->link_up = 1;
> +                       port->link_speed = PIPE_PHY_RATE_RD(val32);
> +                       xgene_pcie_in32(csr_base + PCIE_STATUS_31_0, &val32);
> +                       *lanes = val32 >> 26;
> +               }
> +               time = jiffies_to_msecs(jiffies - start_time);
> +       } while ((!port->link_up) || (time <= XGENE_LTSSM_L0_WAIT));
> +}
> +
> +static void xgene_pcie_setup_root_complex(struct xgene_pcie_port *port)
> +{
> +       void *csr_base = port->csr_base;
> +       u32 val;
> +
> +       val = (XGENE_PCIE_BRIDGE_DEVICEID << 16) | XGENE_PCIE_VENDORID;
> +       xgene_pcie_out32(csr_base + CFG_CONSTANTS_31_00, val);
> +
> +       xgene_pcie_in32(csr_base + CFG_CONSTANTS_63_32, &val);
> +       val &= ~CLASS_CODE_MASK;
> +       val |= PCI_CLASS_BRIDGE_PCI << 16;
> +       xgene_pcie_out32(csr_base + CFG_CONSTANTS_63_32, val);
> +
> +       xgene_pcie_in32(csr_base + CFG_CONSTANTS_479_448, &val);
> +       val |= SWITCH_PORT_MODE_MASK;
> +       val &= ~PM_FORCE_RP_MODE_MASK;
> +       xgene_pcie_out32(csr_base + CFG_CONSTANTS_479_448, val);
> +       xgene_pcie_setup_link(port);
> +       xgene_pcie_setup_lanes(port);
> +       xgene_pcie_in32(csr_base + CFG_CONTROL_191_160, &val);
> +       val &= ~DEVICE_PORT_TYPE_MASK;
> +       val |= XGENE_PORT_TYPE_RC;
> +       xgene_pcie_out32(csr_base + CFG_CONTROL_191_160, val);
> +
> +       xgene_pcie_in32(csr_base + CFG_CONTROL_95_64, &val);
> +       val |= ENABLE_ASPM;
> +       xgene_pcie_out32(csr_base + CFG_CONTROL_95_64, val);
> +
> +       xgene_pcie_in32(csr_base + CFG_CONSTANTS_415_384, &val);
> +       val = ENABLE_L1S_POWER_MGMT_SET(val, 1);
> +       xgene_pcie_out32(csr_base + CFG_CONSTANTS_415_384, val);
> +}
> +
> +static void xgene_pcie_setup_endpoint(struct xgene_pcie_port *port)
> +{
> +       void *csr_base = port->csr_base;
> +       u32 val;
> +
> +       xgene_pcie_in32(csr_base + CFG_CONSTANTS_479_448, &val);
> +       val &= ~SWITCH_PORT_MODE_MASK;
> +       val &= ~PM_FORCE_RP_MODE_MASK;
> +       xgene_pcie_out32(csr_base + CFG_CONSTANTS_479_448, val);
> +
> +       xgene_pcie_in32(csr_base + CFG_CONTROL_191_160, &val);
> +       val &= ~DEVICE_PORT_TYPE_MASK;
> +       val &= ~SLOT_IMPLEMENTED_MASK;
> +       xgene_pcie_out32(csr_base + CFG_CONTROL_191_160, val);
> +
> +       xgene_pcie_in32(csr_base + CFG_CONSTANTS_31_00, &val);
> +       val = (XGENE_PCIE_DEVICEID << 16) | XGENE_PCIE_VENDORID;
> +       xgene_pcie_out32(csr_base + CFG_CONSTANTS_31_00, val);
> +
> +       xgene_pcie_in32(csr_base + CFG_CONSTANTS_63_32, &val);
> +       val &= REVISION_ID_MASK;
> +       val |= PCI_CLASS_BRIDGE_OTHER << 16;
> +       xgene_pcie_out32(csr_base + CFG_CONSTANTS_63_32, val);
> +
> +       xgene_pcie_setup_link(port);
> +}
> +
> +static void xgene_pcie_setup_port(struct xgene_pcie_port *port)
> +{
> +       int type = port->type;
> +
> +       xgene_pcie_program_core(port->csr_base);
> +       if (type == PTYPE_ROOT_PORT)
> +               xgene_pcie_setup_root_complex(port);
> +       else
> +               xgene_pcie_setup_endpoint(port);
> +}
> +
> +/* Return 0 on success */
> +static int xgene_pcie_init_ecc(struct xgene_pcie_port *port)
> +{
> +       void *csr_base = port->csr_base;
> +       int timeout = XGENE_PCIE_TIMEOUT;
> +       u32 val;
> +
> +       xgene_pcie_in32(csr_base + MEM_RAM_SHUTDOWN, &val);
> +       if (val == 0)
> +               return 0;
> +       xgene_pcie_out32(csr_base + MEM_RAM_SHUTDOWN, 0x0);
> +       do {
> +               xgene_pcie_in32(csr_base + BLOCK_MEM_RDY, &val);
> +               udelay(1);
> +       } while ((val != BLOCK_MEM_RDY_VAL) && timeout--);
> +
> +       return !(timeout > 0);
> +}
> +
> +static int xgene_pcie_init_port(struct xgene_pcie_port *port)
> +{
> +       int rc;
> +
> +       port->clk = clk_get(port->dev, XGENE_PCIE_CLK_DRV);
> +       if (IS_ERR_OR_NULL(port->clk)) {
> +               dev_err(port->dev, "clock not available\n");
> +               return -ENODEV;
> +       }
> +
> +       rc = clk_prepare_enable(port->clk);
> +       if (rc) {
> +               dev_err(port->dev, "clock enable failed\n");
> +               return rc;
> +       }
> +
> +       rc = xgene_pcie_init_ecc(port);
> +       if (rc) {
> +               dev_err(port->dev, "memory init failed\n");
> +               return rc;
> +       }
> +
> +       return 0;
> +}
> +
> +struct device_node *pcibios_get_phb_of_node(struct pci_bus *bus)
> +{
> +       struct xgene_pcie_port *port = xgene_pcie_bus_to_port(bus);
> +
> +       return of_node_get(port->node);
> +}
> +
> +static void xgene_pcie_fixup_bridge(struct pci_dev *dev)
> +{
> +       int i;
> +
> +       for (i = 0; i < DEVICE_COUNT_RESOURCE; i++) {
> +               dev->resource[i].start = dev->resource[i].end = 0;
> +               dev->resource[i].flags = 0;
> +       }
> +}
> +DECLARE_PCI_FIXUP_HEADER(XGENE_PCIE_VENDORID, XGENE_PCIE_BRIDGE_DEVICEID,
> +                        xgene_pcie_fixup_bridge);
> +
> +static void xgene_pcie_setup_primary_bus(struct xgene_pcie_port *port,
> +                                        u32 first_busno, u32 last_busno)
> +{
> +       u32 val;
> +       void *cfg_addr = port->cfg_base;
> +
> +       xgene_pcie_in32(cfg_addr + PCI_PRIMARY_BUS, &val);
> +       val &= ~PCI_PRIMARY_BUS_MASK;
> +       val |= (last_busno << 16) | ((first_busno + 1) << 8) | (first_busno);
> +       xgene_pcie_out32(cfg_addr + PCI_PRIMARY_BUS, val);
> +}
> +
> +/*
> + * read configuration values from DTS
> + */
> +static int xgene_pcie_read_dts_config(struct xgene_pcie_port *port)
> +{
> +       struct device_node *np = port->node;
> +       struct resource csr_res;
> +       u32 val32;
> +       int ret;
> +       const u8 *val;
> +
> +       val = of_get_property(np, "device_type", NULL);
> +       if ((val != NULL) && !strcmp(val, "ep"))
> +               port->type = PTYPE_ENDPOINT;
> +       else
> +               port->type = PTYPE_ROOT_PORT;
> +
> +       ret = of_property_read_u32(np, "link_speed", &val32);
> +       if (ret == 0)
> +               port->link_speed = val32;
> +       else
> +               port->link_speed = PCIE_GEN3;
> +
> +       /* Get configured CSR space registers address */
> +       if (of_address_to_resource(np, 0, &csr_res))
> +               return -EINVAL;
> +
> +       port->csr_base = devm_ioremap_nocache(port->dev, csr_res.start,
> +                                             resource_size(&csr_res));
> +       if (port->csr_base == NULL)
> +               return -ENOMEM;
> +
> +       return 0;
> +}
> +
> +static int xgene_pcie_alloc_ep_mem(struct xgene_pcie_port *port)
> +{
> +       struct xgene_pcie_ep_info *ep = &port->ep_info;
> +
> +       ep->reg_virt = dma_alloc_coherent(port->dev, XGENE_PCIE_EP_MEM_SIZE,
> +                                         &ep->reg_phys, GFP_KERNEL);
> +       if (ep->reg_virt == NULL)
> +               return -ENOMEM;
> +
> +       dev_info(port->dev, "EP: Virt - %p Phys - 0x%llx Size - 0x%x\n",
> +                ep->reg_virt, (u64) ep->reg_phys, XGENE_PCIE_EP_MEM_SIZE);
> +       return 0;
> +}
> +
> +static int xgene_pcie_populate_inbound_regions(struct xgene_pcie_port *port)
> +{
> +       struct resource *msi_res = &port->res[XGENE_MSI];
> +       phys_addr_t ddr_size = memblock_phys_mem_size();
> +       phys_addr_t ddr_base = memblock_start_of_DRAM();
> +       void *csr_base = port->csr_base;
> +       void *cfg_addr = port->cfg_base;
> +       u64 val64, size;
> +       u32 val, mask_addr;
> +       u32 flags = PCI_BASE_ADDRESS_MEM_PREFETCH |
> +                   PCI_BASE_ADDRESS_MEM_TYPE_64;
> +
> +       if (port->type == PTYPE_ROOT_PORT) {
> +               mask_addr = CFG_CONSTANTS_159_128;
> +               xgene_pcie_set_ib_mask(csr_base, mask_addr, flags, ddr_size);
> +               val = (lower_32_bits(ddr_base) & PCI_BASE_ADDRESS_MEM_MASK) |
> +                       flags;
> +               xgene_pcie_out32(cfg_addr + PCI_BASE_ADDRESS_0, val);
> +               val = upper_32_bits(ddr_base);
> +               xgene_pcie_out32(cfg_addr + PCI_BASE_ADDRESS_1, val);
> +               xgene_pcie_config_pims(csr_base, PIM1_1L, ddr_base, ddr_size);
> +       } else {
> +               struct xgene_pcie_ep_info *ep = &port->ep_info;
> +               if (xgene_pcie_alloc_ep_mem(port))
> +                       return -ENOMEM;
> +               mask_addr = CFG_CONSTANTS_159_128;
> +               size = XGENE_PCIE_EP_MEM_SIZE;
> +               xgene_pcie_set_ib_mask(csr_base, mask_addr, flags, size);
> +               xgene_pcie_config_pims(csr_base, PIM1_1L, ep->reg_phys, size);
> +       }
> +       val64 = 0;
> +       size = resource_size(msi_res);
> +       if (size >= SZ_1M)
> +               val64 = ~(size - 1) | EN_REG;
> +       xgene_pcie_out32(csr_base + IBAR2, msi_res->start);
> +       xgene_pcie_out32(csr_base + IR2MSK, lower_32_bits(val64));
> +       xgene_pcie_config_pims(csr_base, PIM2_1L, msi_res->start, size);
> +       return 0;
> +}
> +
> +static void xgene_pcie_setup_ob_reg(void *csr_base, u32 addr, u32 index,
> +                                   struct resource *res)
> +{
> +       resource_size_t size = resource_size(res);
> +       u64 val64 = 0;
> +       u32 min_size = 0;
> +       u32 flag = EN_REG;
> +
> +       switch (index) {
> +       case XGENE_MEM:
> +               min_size = SZ_128M;
> +               break;
> +       case XGENE_IO:
> +               min_size = 128;
> +               flag |= OB_LO_IO;
> +               break;
> +       }
> +       if (size >= min_size)
> +               val64 = ~(size - 1) | flag;
> +       else
> +               pr_warn("resource size 0x%llx less than minimum 0x%x\n",
> +                        (u64)size, min_size);
> +       xgene_pcie_out32(csr_base + addr, lower_32_bits(res->start));
> +       xgene_pcie_out32(csr_base + addr + 0x04, upper_32_bits(res->start));
> +       xgene_pcie_out32(csr_base + addr + 0x08, lower_32_bits(val64));
> +       xgene_pcie_out32(csr_base + addr + 0x0c, upper_32_bits(val64));
> +       xgene_pcie_out32(csr_base + addr + 0x10, 0x0);
> +       xgene_pcie_out32(csr_base + addr + 0x14, 0x0);
> +}
> +
> +static int xgene_pcie_map_cfg(struct xgene_pcie_port *port,
> +                             struct of_pci_range *range)
> +{
> +       struct device *dev = port->dev;
> +       u64 addr = range->cpu_addr;
> +       resource_size_t size = range->size;
> +       void *csr_base = port->csr_base;
> +
> +       port->cfg_base = devm_ioremap_nocache(dev, addr, size);
> +       if (port->cfg_base == NULL) {
> +               dev_err(dev, "failed to map cfg region!");
> +               return -ENOMEM;
> +       }
> +
> +       xgene_pcie_out32(csr_base + CFGBARL, lower_32_bits(addr));
> +       xgene_pcie_out32(csr_base + CFGBARH, upper_32_bits(addr));
> +       xgene_pcie_out32(csr_base + CFGCTL, EN_REG);
> +
> +       return 0;
> +}
> +
> +static int xgene_pcie_parse_map_ranges(struct xgene_pcie_port *port)
> +{
> +       struct device_node *np = port->node;
> +       struct of_pci_range range;
> +       struct of_pci_range_parser parser;
> +       struct device *dev = port->dev;
> +       u32 cfg_map_done = 0;
> +       int ret;
> +
> +       if (of_pci_range_parser_init(&parser, np)) {
> +               dev_err(dev, "missing ranges property\n");
> +               return -EINVAL;
> +       }
> +
> +       /* Get the I/O, memory, config ranges from DT */
> +       for_each_of_pci_range(&parser, &range) {
> +               struct resource *res = NULL;
> +               u64 restype = range.flags & IORESOURCE_TYPE_BITS;
> +               u64 end = range.cpu_addr + range.size - 1;
> +               dev_dbg(port->dev, "0x%08x 0x%016llx..0x%016llx -> 0x%016llx\n",
> +                       range.flags, range.cpu_addr, end, range.pci_addr);
> +
> +               switch (restype) {
> +               case IORESOURCE_IO:
> +                       res = &port->res[XGENE_IO];
> +                       of_pci_range_to_resource(&range, np, res);
> +                       xgene_pcie_setup_ob_reg(port->csr_base, OMR1BARL,
> +                                               XGENE_IO, res);
> +                       break;
> +               case IORESOURCE_MEM:
> +                       res = &port->res[XGENE_MEM];
> +                       of_pci_range_to_resource(&range, np, res);
> +                       xgene_pcie_setup_ob_reg(port->csr_base, OMR2BARL,
> +                                               XGENE_MEM, res);
> +                       break;
> +               case 0:
> +                       if (!cfg_map_done) {
> +                               /* config region */
> +                               if (port->type == PTYPE_ROOT_PORT) {
> +                                       ret = xgene_pcie_map_cfg(port, &range);
> +                                       if (ret)
> +                                               return ret;
> +                               }
> +                               cfg_map_done = 1;
> +                       } else {
> +                               /* msi region */
> +                               res = &port->res[XGENE_MSI];
> +                               of_pci_range_to_resource(&range, np, res);
> +                       }
> +                       break;
> +               default:
> +                       dev_err(dev, "invalid io resource!");
> +                       return -EINVAL;
> +               }
> +       }
> +
> +       return xgene_pcie_populate_inbound_regions(port);
> +}
> +
> +static int xgene_pcie_setup(int nr, struct pci_sys_data *sys)
> +{
> +       struct xgene_pcie_port *pp = xgene_pcie_sys_to_port(sys);
> +
> +       if (pp == NULL)
> +               return 0;
> +
> +       if (pp->type == PTYPE_ENDPOINT)
> +               return 0;
> +
> +       sys->io_offset = pci_io_offset(pp->res[XGENE_IO].start);
> +       sys->mem_offset = pci_io_offset(pp->res[XGENE_MEM].start);
> +
> +       BUG_ON(request_resource(&iomem_resource, &pp->res[XGENE_IO]) ||
> +              request_resource(&iomem_resource, &pp->res[XGENE_MEM]));
> +
> +       pci_add_resource_offset(&sys->resources, &pp->res[XGENE_MEM],
> +                               sys->mem_offset);
> +       pci_add_resource_offset(&sys->resources, &pp->res[XGENE_IO],
> +                               sys->io_offset);
> +       return 1;
> +}
> +
> +static int xgene_pcie_map_irq(const struct pci_dev *dev, u8 slot, u8 pin)
> +{
> +       return of_irq_parse_and_map_pci(dev, slot, pin);
> +}
> +
> +static struct pci_bus __init *xgene_pcie_scan_bus(int nr,
> +                                                 struct pci_sys_data *sys)
> +{
> +       struct xgene_pcie_port *pp = xgene_pcie_sys_to_port(sys);
> +
> +       pp->first_busno = sys->busnr;
> +       xgene_pcie_setup_primary_bus(pp, sys->busnr, 0xff);
> +       return pci_scan_root_bus(NULL, sys->busnr, &xgene_pcie_ops,
> +                                sys, &sys->resources);
> +}
> +
> +static struct hw_pci xgene_pcie_hw __initdata = {
> +       .nr_controllers = XGENE_PCIE_MAX_PORTS,
> +       .setup = xgene_pcie_setup,
> +       .scan = xgene_pcie_scan_bus,
> +       .map_irq = xgene_pcie_map_irq,
> +};
> +
> +static int __init xgene_pcie_probe_bridge(struct platform_device *pdev)
> +{
> +       struct device_node *np = of_node_get(pdev->dev.of_node);
> +       struct xgene_pcie_port *port;
> +       u32 lanes = 0;
> +       static int index;
> +       int ret;
> +
> +       port = devm_kzalloc(&pdev->dev, sizeof(*port), GFP_KERNEL);
> +       if (port == NULL)
> +               return -ENOMEM;
> +       port->node = np;
> +       port->dev = &pdev->dev;
> +
> +       ret = xgene_pcie_read_dts_config(port);
> +       if (ret)
> +               return ret;
> +
> +       ret = xgene_pcie_init_port(port);
> +       if (ret)
> +               goto skip;
> +
> +       xgene_pcie_setup_port(port);
> +       ret = xgene_pcie_parse_map_ranges(port);
> +       if (ret)
> +               goto skip;
> +
> +       if (port->type == PTYPE_ROOT_PORT)
> +               xgene_pcie_poll_linkup(port, &lanes);
> +skip:
> +       if (port->type == PTYPE_ROOT_PORT) {
> +               if (!port->link_up)
> +                       dev_info(port->dev, "(rc) link down\n");
> +               else
> +                       dev_info(port->dev, "(rc) x%d gen-%d link up\n",
> +                                lanes, port->link_speed + 1);
> +       } else
> +               dev_info(port->dev, "(ep)\n");
> +
> +       xgene_pcie_hw.private_data[index++] = port;
> +       platform_set_drvdata(pdev, port);
> +       return 0;
> +}
> +
> +static const struct of_device_id xgene_pcie_match_table[] __initconst = {
> +       {.compatible = "apm,xgene-pcie",},
> +       {},
> +};
> +
> +static struct platform_driver xgene_pcie_driver = {
> +       .driver = {
> +                  .name = "xgene-pcie",
> +                  .owner = THIS_MODULE,
> +                  .of_match_table = of_match_ptr(xgene_pcie_match_table),
> +                  },
> +};
> +
> +static int __init xgene_pcie_init(void)
> +{
> +       void *private;
> +       int ret;
> +
> +       pr_info("X-Gene: PCIe driver\n");
> +
> +       /* allocate private data to keep xgene_pcie_port information */
> +       private = kzalloc((XGENE_PCIE_MAX_PORTS * sizeof(void *)), GFP_KERNEL);
> +       if (private == NULL)
> +               return -ENOMEM;
> +       xgene_pcie_hw.private_data = private;
> +       ret = platform_driver_probe(&xgene_pcie_driver,
> +                                   xgene_pcie_probe_bridge);
> +       if (ret)
> +               return ret;
> +       pci_common_init(&xgene_pcie_hw);
> +       return 0;
> +}
> +
> +module_init(xgene_pcie_init);
> +
> +MODULE_AUTHOR("Tanmay Inamdar <tinamdar@apm.com>");
> +MODULE_DESCRIPTION("APM X-Gene PCIe driver");
> +MODULE_LICENSE("GPL v2");
> --
> 1.7.9.5
>
