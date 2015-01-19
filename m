Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751374AbbASNGb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Jan 2015 08:06:31 -0500
Received: from mail-ob0-f182.google.com ([209.85.214.182]:39478 "EHLO
	mail-ob0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751226AbbASNG3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Jan 2015 08:06:29 -0500
MIME-Version: 1.0
In-Reply-To: <000f01d01a88$60405e50$20c11af0$%han@samsung.com>
References: <1418812486-12394-1-git-send-email-gabriel.fernandez@linaro.org>
	<1418812486-12394-4-git-send-email-gabriel.fernandez@linaro.org>
	<000f01d01a88$60405e50$20c11af0$%han@samsung.com>
Date: Mon, 19 Jan 2015 14:06:28 +0100
Message-ID: <CAG374jB9AaEr4rAwCT_19eySgP5paGke_ms_cJO7i8E7-oqr9g@mail.gmail.com>
Subject: Re: [PATCH 3/5] PCI: st: Provide support for the sti PCIe controller
From: Gabriel Fernandez <gabriel.fernandez@linaro.org>
To: Jingoo Han <jg1.han@samsung.com>
Cc: Gabriel FERNANDEZ <gabriel.fernandez@st.com>,
        Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        Srinivas Kandagatla <srinivas.kandagatla@gmail.com>,
        Maxime Coquelin <maxime.coquelin@st.com>,
        Patrice Chotard <patrice.chotard@st.com>,
        Russell King <linux@arm.linux.org.uk>,
        Bjorn Helgaas <bhelgaas@google.com>, Mohit Kumar <mohit.kumar@st.com>,
        Grant Likely <grant.likely@linaro.org>,
        Fabrice Gasnier <fabrice.gasnier@st.com>,
        Arnd Bergmann <arnd@arndb.de>, Viresh Kumar <viresh.kumar@linaro.org>,
        Thierry Reding <treding@nvidia.com>,
        Minghuan Lian <Minghuan.Lian@freescale.com>,
        Magnus Damm <damm@opensource.se>, Will Deacon <will.deacon@arm.com>,
        Tanmay Inamdar <tinamdar@apm.com>,
        Murali Karicheri <m-karicheri2@ti.com>,
        Kishon Vijay Abraham I <kishon@ti.com>,
        Pratyush Anand <pratyush.anand@st.com>,
        Sachin Kamat <sachin.kamat@samsung.com>, Andrew Lunn <andrew@lunn.ch>,
        Liviu Dudau <Liviu.Dudau@arm.com>,
        Srikanth Thokala <sthokal@xilinx.com>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "kernel@stlinux.com" <kernel@stlinux.com>, linux-pci@vger.kernel.org,
        Lee Jones <lee.jones@linaro.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Jingoo,

Thanks for reviewing

On 18 December 2014 at 07:03, Jingoo Han <jg1.han@samsung.com> wrote:
> On Wednesday, December 17, 2014 7:35 PM, Gabriel FERNANDEZ wrote:
>>
>> sti pcie is built around a Synopsis Designware PCIe IP.
>>
>> Signed-off-by: Fabrice Gasnier <fabrice.gasnier@st.com>
>> Signed-off-by: Gabriel Fernandez <gabriel.fernandez@linaro.org>
>> ---
>>  drivers/pci/host/Kconfig  |   5 +
>>  drivers/pci/host/Makefile |   1 +
>>  drivers/pci/host/pci-st.c | 713 ++++++++++++++++++++++++++++++++++++++++++++++
>>  3 files changed, 719 insertions(+)
>>  create mode 100644 drivers/pci/host/pci-st.c
>>
>> diff --git a/drivers/pci/host/Kconfig b/drivers/pci/host/Kconfig
>> index c4b6568..999d2b9 100644
>> --- a/drivers/pci/host/Kconfig
>> +++ b/drivers/pci/host/Kconfig
>> @@ -102,4 +102,9 @@ config PCI_LAYERSCAPE
>>       help
>>         Say Y here if you want PCIe controller support on Layerscape SoCs.
>>
>> +config PCI_ST
>> +     bool "ST STiH41x PCIe controller"
>> +     depends on ARCH_STI
>> +     select PCIE_DW
>> +
>>  endmenu
>> diff --git a/drivers/pci/host/Makefile b/drivers/pci/host/Makefile
>> index 44c2699..ca14829 100644
>> --- a/drivers/pci/host/Makefile
>> +++ b/drivers/pci/host/Makefile
>> @@ -12,3 +12,4 @@ obj-$(CONFIG_PCI_KEYSTONE) += pci-keystone-dw.o pci-keystone.o
>>  obj-$(CONFIG_PCIE_XILINX) += pcie-xilinx.o
>>  obj-$(CONFIG_PCI_XGENE) += pci-xgene.o
>>  obj-$(CONFIG_PCI_LAYERSCAPE) += pci-layerscape.o
>> +obj-$(CONFIG_PCI_ST) += pci-st.o
>> diff --git a/drivers/pci/host/pci-st.c b/drivers/pci/host/pci-st.c
>> new file mode 100644
>> index 0000000..bd3d32d
>> --- /dev/null
>> +++ b/drivers/pci/host/pci-st.c
>> @@ -0,0 +1,713 @@
>> +/*
>> + * Copyright (C) 2014 STMicroelectronics
>> + *
>> + * STMicroelectronics PCI express Driver for sti SoCs.
>> + * ST PCIe IPs are built around a Synopsys IP Core.
>> + *
>> + * Author: Fabrice Gasnier <fabrice.gasnier@st.com>
>> + *
>> + * This program is free software; you can redistribute it and/or modify
>> + * it under the terms of the GNU General Public License version 2, as
>> + * published by the Free Software Foundation.
>> + *
>> + */
>> +
>> +#include <linux/module.h>
>> +#include <linux/interrupt.h>
>> +#include <linux/of_address.h>
>> +#include <linux/of_pci.h>
>> +#include <linux/of_platform.h>
>> +#include <linux/of_gpio.h>
>> +#include <linux/regmap.h>
>> +#include <linux/mfd/syscon.h>
>> +#include <linux/delay.h>
>> +#include <linux/reset.h>
>> +#include <linux/phy/phy.h>
>
> Please, re-order these headers alphabetically.
> It enhances the readability.
>

sure

>> +
>> +#include "pcie-designware.h"
>> +
>> +#define TRANSLATION_CONTROL          0x900
>> +/* Controls if area is inclusive or exclusive */
>> +#define RC_PASS_ADDR_RANGE           BIT(1)
>> +
>> +/* Base of area reserved for config accesses. Fixed size of 64K. */
>> +#define CFG_BASE_ADDRESS             0x92c
>> +#define CFG_REGION_SIZE                      65536
>> +
>> +/* First 4K of config space has this BDF (bus,device,function) */
>> +#define FUNC0_BDF_NUM                        0x930
>> +
>> +/* Mem regions */
>> +#define IN0_MEM_ADDR_START           0x964
>> +#define IN0_MEM_ADDR_LIMIT           0x968
>> +#define IN1_MEM_ADDR_START           0x974
>> +#define IN1_MEM_ADDR_LIMIT           0x978
>> +
>> +/* This actually contains the LTSSM state machine state */
>> +#define PORT_LOGIC_DEBUG_REG_0               0x728
>> +
>> +/* LTSSM state machine values        */
>> +#define DEBUG_REG_0_LTSSM_MASK               0x1f
>> +#define S_DETECT_QUIET                       0x00
>> +#define S_DETECT_ACT                 0x01
>> +#define S_POLL_ACTIVE                        0x02
>> +#define S_POLL_COMPLIANCE            0x03
>> +#define S_POLL_CONFIG                        0x04
>> +#define S_PRE_DETECT_QUIET           0x05
>> +#define S_DETECT_WAIT                        0x06
>> +#define S_CFG_LINKWD_START           0x07
>> +#define S_CFG_LINKWD_ACEPT           0x08
>> +#define S_CFG_LANENUM_WAIT           0x09
>> +#define S_CFG_LANENUM_ACEPT          0x0A
>> +#define S_CFG_COMPLETE                       0x0B
>> +#define S_CFG_IDLE                   0x0C
>> +#define S_RCVRY_LOCK                 0x0D
>> +#define S_RCVRY_SPEED                        0x0E
>> +#define S_RCVRY_RCVRCFG                      0x0F
>> +#define S_RCVRY_IDLE                 0x10
>> +#define S_L0                         0x11
>> +#define S_L0S                                0x12
>> +#define S_L123_SEND_EIDLE            0x13
>> +#define S_L1_IDLE                    0x14
>> +#define S_L2_IDLE                    0x15
>> +#define S_L2_WAKE                    0x16
>> +#define S_DISABLED_ENTRY             0x17
>> +#define S_DISABLED_IDLE                      0x18
>> +#define S_DISABLED                   0x19
>> +#define S_LPBK_ENTRY                 0x1A
>> +#define S_LPBK_ACTIVE                        0x1B
>> +#define S_LPBK_EXIT                  0x1C
>> +#define S_LPBK_EXIT_TIMEOUT          0x1D
>> +#define S_HOT_RESET_ENTRY            0x1E
>> +#define S_HOT_RESET                  0x1F
>> +
>> +/* syscfg bits */
>> +#define PCIE_SYS_INT                 BIT(5)
>> +#define PCIE_APP_REQ_RETRY_EN                BIT(3)
>> +#define PCIE_APP_LTSSM_ENABLE                BIT(2)
>> +#define PCIE_APP_INIT_RST            BIT(1)
>> +#define PCIE_DEVICE_TYPE             BIT(0)
>> +#define PCIE_DEFAULT_VAL             PCIE_DEVICE_TYPE
>> +
>> +/* Time to wait between testing the link in msecs (hardware poll interval) */
>> +#define LINK_LOOP_DELAY_MS 1
>> +/* Total amount of time to wait for the link to come up in msecs */
>> +#define LINK_WAIT_MS 120
>> +#define LINK_LOOP_COUNT (LINK_WAIT_MS / LINK_LOOP_DELAY_MS)
>> +
>> +/* st,syscfg offsets */
>> +#define SYSCFG0_REG  1
>> +#define SYSCFG1_REG  2
>> +
>> +#define to_st_pcie(x)        container_of(x, struct st_pcie, pp)
>> +
>> +/**
>> + * struct st_pcie_ops - SOC dependent data
>> + * @init: reference to controller power & reset init routine
>> + * @enable_ltssm: reference to controller link enable routine
>> + * @disable_ltssm:  reference to controller link disable routine
>> + * @phy_auto: flag when phy automatically configured
>> + */
>> +struct st_pcie_ops {
>> +     int (*init)(struct pcie_port *pp);
>> +     int (*enable_ltssm)(struct pcie_port *pp);
>> +     int (*disable_ltssm)(struct pcie_port *pp);
>> +     bool phy_auto;
>> +};
>> +
>> +/**
>> + * struct st_pcie - private data of the controller
>> + * @pp: designware pcie port
>> + * @syscfg0: PCIe configuration 0 register, regmap offset
>> + * @syscfg1: PCIe configuration 1 register, regmap offset
>> + * @phy: associated pcie phy
>> + * @config_area: PCIe configuration space
>> + * @lmi: memory made available to the controller
>> + * @data: SOC dependent data
>> + * @regmap: Syscfg registers bank in which PCIe port is configured
>> + * @pwr: power control
>> + * @rst: reset control
>> + * @reset_gpio: optional reset gpio
>> + * @config_window_start: start address of 64K config space area
>> + */
>> +struct st_pcie {
>> +     struct pcie_port pp;
>> +     int syscfg0;
>> +     int syscfg1;
>> +     struct phy *phy;
>> +     void __iomem *config_area;
>> +     struct resource *lmi;
>> +     const struct st_pcie_ops *data;
>> +     struct regmap *regmap;
>> +     struct reset_control *pwr;
>> +     struct reset_control *rst;
>> +     int reset_gpio;
>> +     phys_addr_t config_window_start;
>> +};
>> +
>> +/*
>> + * Function to test if the link is in an operational state or not. We must
>> + * ensure the link is operational before we try to do a configuration access.
>> + */
>> +static int st_pcie_link_up(struct pcie_port *pp)
>> +{
>> +     u32 status;
>> +     int link_up;
>> +     int count = 0;
>> +
>> +     /*
>> +      * We have to be careful here. This is used in config read/write,
>> +      * The higher levels switch off interrupts, so you cannot use
>> +      * jiffies to do a timeout, or reschedule
>> +      */
>> +     do {
>> +             /*
>> +              * What about L2? I think software intervention is
>> +              * required to get it out of L2, so in effect the link
>> +              * is down. Requires more work when/if we implement power
>> +              * management
>> +              */
>> +             status = readl_relaxed(pp->dbi_base + PORT_LOGIC_DEBUG_REG_0);
>> +             status &= DEBUG_REG_0_LTSSM_MASK;
>> +
>> +             link_up = (status == S_L0) || (status == S_L0S) ||
>> +                       (status == S_L1_IDLE);
>> +
>> +             /*
>> +              * It can take some considerable time for the link to actually
>> +              * come up, caused by the PLLs. Experiments indicate it takes
>> +              * about 8ms to actually bring the link up, but this can vary
>> +              * considerably according to the specification. This code should
>> +              * allow sufficient time
>> +              */
>> +             if (!link_up)
>> +                     mdelay(LINK_LOOP_DELAY_MS);
>> +
>> +     } while (!link_up && ++count < LINK_LOOP_COUNT);
>> +
>> +     return link_up;
>> +}
>> +
>> +/*
>> + * On ARM platforms, we actually get a bus error returned when the PCIe IP
>> + * returns a UR or CRS instead of an OK.
>> + */
>> +static int st_pcie_abort_handler(unsigned long addr, unsigned int fsr,
>> +                              struct pt_regs *regs)
>> +{
>> +     return 0;
>> +}
>> +
>> +/*
>> + * The PCI express core IP expects the following arrangement on it's address
>> + * bus (slv_haddr) when driving config cycles.
>> + * bus_number                [31:24]
>> + * dev_number                [23:19]
>> + * func_number               [18:16]
>> + * unused            [15:12]
>> + * ext_reg_number    [11:8]
>> + * reg_number                [7:2]
>> + *
>> + * Bits [15:12] are unused.
>> + *
>> + * In the glue logic there is a 64K region of address space that can be
>> + * written/read to generate config cycles. The base address of this is
>> + * controlled by CFG_BASE_ADDRESS. There are 8 16 bit registers called
>> + * FUNC0_BDF_NUM to FUNC8_BDF_NUM. These split the bottom half of the 64K
>> + * window into 8 regions at 4K boundaries. These control the bus,device and
>> + * function number you are trying to talk to.
>> + *
>> + * The decision on whether to generate a type 0 or type 1 access is controlled
>> + * by bits 15:12 of the address you write to.  If they are zero, then a type 0
>> + * is generated, if anything else it will be a type 1. Thus the bottom 4K
>> + * region controlled by FUNC0_BDF_NUM can only generate type 0, all the others
>> + * can only generate type 1.
>> + *
>> + * We only use FUNC0_BDF_NUM and FUNC1_BDF_NUM. Which one you use is selected
>> + * by bit 12 of the address you write to. The selected register is then used
>> + * for the top 16 bits of the slv_haddr to form the bus/dev/func, bit 15:12 are
>> + * wired to zero, and bits 11:2 form the address of the register you want to
>> + * read in config space.
>> + *
>> + * We always write FUNC0_BDF_NUM as a 32 bit write. So if we want type 1
>> + * accesses we have to shift by 16 so in effect we are writing to FUNC1_BDF_NUM
>> + */
>> +static inline u32 bdf_num(int bus, int devfn, int is_root_bus)
>> +{
>> +     return ((bus << 8) | devfn) << (is_root_bus ? 0 : 16);
>> +}
>> +
>> +static inline unsigned config_addr(int where, int is_root_bus)
>> +{
>> +     return (where & ~3) | (!is_root_bus << 12);
>> +}
>> +
>> +static int st_pcie_rd_other_conf(struct pcie_port *pp, struct pci_bus *bus,
>> +                              unsigned int devfn, int where, int size,
>> +                              u32 *val)
>> +{
>> +     u32 data;
>> +     u32 bdf;
>> +     struct st_pcie *pcie = to_st_pcie(pp);
>> +     int is_root_bus = pci_is_root_bus(bus);
>> +     int retry_count = 0;
>> +     int ret;
>> +     void __iomem *addr;
>> +
>> +     /*
>> +      * Prerequisite
>> +      * PCI express devices will respond to all config type 0 cycles, since
>> +      * they are point to point links. Thus to avoid probing for multiple
>> +      * devices on the root, dw-pcie already check for us if it is on the
>> +      * root bus / other slots. Also, dw-pcie checks for the link being up
>> +      * as we will hang if we issue a config request and the link is down.
>> +      * A switch will reject requests for slots it knows do not exist.
>> +      */
>> +     bdf = bdf_num(bus->number, devfn, is_root_bus);
>> +     addr = pcie->config_area + config_addr(where,
>> +                     bus->parent->number == pp->root_bus_nr);
>> +retry:
>> +     /* Set the config packet devfn */
>> +     writel_relaxed(bdf, pp->dbi_base + FUNC0_BDF_NUM);
>> +     readl_relaxed(pp->dbi_base + FUNC0_BDF_NUM);
>> +
>> +     ret = dw_pcie_cfg_read(addr, where, size, &data);
>> +
>> +     /*
>> +      * This is intended to help with when we are probing the bus. The
>> +      * problem is that the wrapper logic doesn't have any way to
>> +      * interrogate if the configuration request failed or not.
>> +      * On the ARM we actually get a real bus error.
>> +      *
>> +      * Unfortunately this means it is impossible to tell the difference
>> +      * between when a device doesn't exist (the switch will return a UR
>> +      * completion) or the device does exist but isn't yet ready to accept
>> +      * configuration requests (the device will return a CRS completion)
>> +      *
>> +      * The result of this is that we will miss devices when probing.
>> +      *
>> +      * So if we are trying to read the dev/vendor id on devfn 0 and we
>> +      * appear to get zero back, then we retry the request.  We know that
>> +      * zero can never be a valid device/vendor id. The specification says
>> +      * we must retry for up to a second before we decide the device is
>> +      * dead. If we are still dead then we assume there is nothing there and
>> +      * return ~0
>> +      *
>> +      * The downside of this is that we incur a delay of 1s for every pci
>> +      * express link that doesn't have a device connected.
>> +      */
>> +     if (((where & ~3) == 0) && devfn == 0 && (data == 0 || data == ~0)) {
>> +             if (retry_count++ < 1000) {
>> +                     mdelay(1);
>> +                     goto retry;
>> +             } else {
>> +                     *val = ~0;
>> +                     return PCIBIOS_DEVICE_NOT_FOUND;
>> +             }
>> +     }
>> +
>> +     *val = data;
>> +     return ret;
>> +}
>> +
>> +static int st_pcie_wr_other_conf(struct pcie_port *pp, struct pci_bus *bus,
>> +                              unsigned int devfn, int where, int size,
>> +                              u32 val)
>> +{
>> +     u32 bdf;
>> +     struct st_pcie *pcie = to_st_pcie(pp);
>> +     int is_root_bus = pci_is_root_bus(bus);
>> +     void __iomem *addr;
>> +
>> +     bdf = bdf_num(bus->number, devfn, is_root_bus);
>> +     addr = pcie->config_area + config_addr(where,
>> +                     bus->parent->number == pp->root_bus_nr);
>> +
>> +     /* Set the config packet devfn */
>> +     writel_relaxed(bdf, pp->dbi_base + FUNC0_BDF_NUM);
>> +     readl_relaxed(pp->dbi_base + FUNC0_BDF_NUM);
>> +
>> +     return dw_pcie_cfg_write(addr, where, size, val);
>> +}
>> +
>> +static void st_pcie_board_reset(struct pcie_port *pp)
>> +{
>> +     struct st_pcie *pcie = to_st_pcie(pp);
>> +
>> +     if (!gpio_is_valid(pcie->reset_gpio))
>> +             return;
>> +
>> +     if (gpio_direction_output(pcie->reset_gpio, 0)) {
>> +             dev_err(pp->dev, "Cannot set PERST# (gpio %u) to output\n",
>> +                     pcie->reset_gpio);
>> +             return;
>> +     }
>> +
>> +     /* From PCIe spec */
>> +     usleep_range(1000, 2000);
>> +     gpio_direction_output(pcie->reset_gpio, 1);
>> +
>> +     /*
>> +      * PCIe specification states that you should not issue any config
>> +      * requests until 100ms after asserting reset, so we enforce that here
>> +      */
>> +     usleep_range(100000, 150000);
>> +}
>> +
>> +static void st_pcie_hw_setup(struct pcie_port *pp)
>> +{
>> +     struct st_pcie *pcie = to_st_pcie(pp);
>> +
>> +     dw_pcie_setup_rc(pp);
>> +
>> +     /* Set up the config window to the top of the PCI address space */
>> +     writel_relaxed(pcie->config_window_start,
>> +                    pp->dbi_base + CFG_BASE_ADDRESS);
>> +
>> +     /*
>> +      * Open up memory to the PCI controller. We could do slightly
>> +      * better than this and exclude the kernel text segment and bss etc.
>> +      * They are base/limit registers so can be of arbitrary alignment
>> +      * presumably
>> +      */
>> +     writel_relaxed(pcie->lmi->start, pp->dbi_base + IN0_MEM_ADDR_START);
>> +     writel_relaxed(pcie->lmi->end, pp->dbi_base + IN0_MEM_ADDR_LIMIT);
>> +
>> +     /* Disable the 2nd region */
>> +     writel_relaxed(~0, pp->dbi_base + IN1_MEM_ADDR_START);
>> +     writel_relaxed(0, pp->dbi_base + IN1_MEM_ADDR_LIMIT);
>> +
>> +     writel_relaxed(RC_PASS_ADDR_RANGE, pp->dbi_base + TRANSLATION_CONTROL);
>> +
>> +     /* Now assert the board level reset to the other PCIe device */
>> +     st_pcie_board_reset(pp);
>> +}
>> +
>> +static irqreturn_t st_pcie_msi_irq_handler(int irq, void *arg)
>> +{
>> +     struct pcie_port *pp = arg;
>> +
>> +     return dw_handle_msi_irq(pp);
>> +}
>> +
>> +static void st_msi_init_one(struct pcie_port *pp)
>> +{
>> +     struct st_pcie *pcie = to_st_pcie(pp);
>> +
>> +     /*
>> +      * Set the magic address the hardware responds to. This has to be in
>> +      * the range the PCI controller can write to.
>> +      */
>> +     dw_pcie_msi_init(pp);
>> +
>> +     if ((virt_to_phys((void *)pp->msi_data) < pcie->lmi->start) ||
>> +         (virt_to_phys((void *)pp->msi_data) > pcie->lmi->end))
>> +             dev_err(pp->dev, "MSI addr miss-configured\n");
>> +}
>> +
>> +static void st_pcie_host_init(struct pcie_port *pp)
>> +{
>> +     struct st_pcie *pcie = to_st_pcie(pp);
>> +     int err;
>> +
>> +     /*
>> +      * We have to initialise the PCIe cell on some hardware before we can
>> +      * talk to the phy
>> +      */
>> +     err = pcie->data->init(pp);
>> +     if (err)
>> +             return;
>> +
>> +     err = pcie->data->disable_ltssm(pp);
>> +     if (err) {
>> +             dev_err(pp->dev, "disable ltssm failed, %d\n", err);
>> +             return;
>> +     }
>> +
>> +     if (!pcie->data->phy_auto) {
>> +             /* Now init the associated miphy */
>> +             err = phy_init(pcie->phy);
>> +             if (err < 0) {
>> +                     dev_err(pp->dev, "Cannot init PHY: %d\n", err);
>> +                     return;
>> +             }
>> +     }
>> +
>> +     /* Now do all the register poking */
>> +     st_pcie_hw_setup(pp);
>> +
>> +     /* Re-enable the link */
>> +     err = pcie->data->enable_ltssm(pp);
>> +     if (err)
>> +             dev_err(pp->dev, "enable ltssm failed, %d\n", err);
>> +
>> +     if (IS_ENABLED(CONFIG_PCI_MSI))
>> +             st_msi_init_one(pp);
>> +}
>> +
>> +static struct pcie_host_ops st_pcie_host_ops = {
>> +     .rd_other_conf = st_pcie_rd_other_conf,
>> +     .wr_other_conf = st_pcie_wr_other_conf,
>> +     .link_up = st_pcie_link_up,
>> +     .host_init = st_pcie_host_init,
>> +};
>> +
>> +static int st_pcie_init(struct pcie_port *pp)
>> +{
>> +     struct st_pcie *pcie = to_st_pcie(pp);
>> +     int ret;
>> +
>> +     ret = reset_control_deassert(pcie->pwr);
>> +     if (ret) {
>> +             dev_err(pp->dev, "unable to bring out of powerdown\n");
>> +             return ret;
>> +     }
>> +
>> +     ret = reset_control_deassert(pcie->rst);
>> +     if (ret) {
>> +             dev_err(pp->dev, "unable to bring out of softreset\n");
>> +             return ret;
>> +     }
>> +
>> +     /* Set device type : Root Complex */
>> +     ret = regmap_write(pcie->regmap, pcie->syscfg0, PCIE_DEVICE_TYPE);
>> +     if (ret < 0) {
>> +             dev_err(pp->dev, "unable to set device type\n");
>> +             return ret;
>> +     }
>> +
>> +     usleep_range(1000, 2000);
>> +     return ret;
>> +}
>> +
>> +/* STiH407 */
>> +static int stih407_pcie_enable_ltssm(struct pcie_port *pp)
>> +{
>> +     struct st_pcie *pcie = to_st_pcie(pp);
>> +
>> +     if (!pcie->syscfg1)
>> +             return -EINVAL;
>> +
>> +     return regmap_update_bits(pcie->regmap, pcie->syscfg1,
>> +                               PCIE_APP_LTSSM_ENABLE, PCIE_APP_LTSSM_ENABLE);
>> +}
>> +
>> +static int stih407_pcie_disable_ltssm(struct pcie_port *pp)
>> +{
>> +     struct st_pcie *pcie = to_st_pcie(pp);
>> +
>> +     if (!pcie->syscfg1)
>> +             return -EINVAL;
>> +
>> +     return regmap_update_bits(pcie->regmap, pcie->syscfg1,
>> +                               PCIE_APP_LTSSM_ENABLE, 0);
>> +}
>> +
>> +static struct st_pcie_ops stih407_pcie_ops = {
>> +     .init = st_pcie_init,
>> +     .enable_ltssm = stih407_pcie_enable_ltssm,
>> +     .disable_ltssm = stih407_pcie_disable_ltssm,
>> +};
>> +
>> +static const struct of_device_id st_pcie_of_match[] = {
>> +     { .compatible = "st,stih407-pcie", .data = (void *)&stih407_pcie_ops},
>> +     { },
>> +};
>> +
>> +#ifdef CONFIG_PM
>> +static int st_pcie_suspend(struct device *pcie_dev)
>> +{
>> +     struct st_pcie *pcie = dev_get_drvdata(pcie_dev);
>> +
>> +     /* To guarantee a real phy initialization on resume */
>> +     if (!pcie->data->phy_auto)
>> +             phy_exit(pcie->phy);
>> +
>> +     return 0;
>> +}
>> +
>> +static int st_pcie_resume(struct device *pcie_dev)
>> +{
>> +     struct st_pcie *pcie = dev_get_drvdata(pcie_dev);
>> +
>> +     st_pcie_host_init(&pcie->pp);
>> +
>> +     return 0;
>> +}
>> +#endif
>> +
>> +const struct dev_pm_ops st_pcie_pm_ops = {
>> +     .suspend_noirq = st_pcie_suspend,
>> +     .resume_noirq = st_pcie_resume,
>> +};
>> +
>> +static int __init st_pcie_probe(struct platform_device *pdev)
>> +{
>> +     struct resource *res;
>> +     struct st_pcie *pcie;
>> +     struct device_node *np = pdev->dev.of_node;
>> +     struct pcie_port *pp;
>> +     int ret;
>> +
>> +     pcie = devm_kzalloc(&pdev->dev, sizeof(*pcie), GFP_KERNEL);
>> +     if (!pcie)
>> +             return -ENOMEM;
>> +
>> +     memset(pcie, 0, sizeof(*pcie));
>> +
>> +     pp = &pcie->pp;
>> +     pp->dev = &pdev->dev;
>> +
>> +     /* mem regions */
>> +     res = platform_get_resource_byname(pdev, IORESOURCE_MEM, "dbi");
>> +     pp->dbi_base = devm_ioremap_resource(&pdev->dev, res);
>> +     if (IS_ERR(pp->dbi_base))
>> +             return PTR_ERR(pp->dbi_base);
>> +
>> +     res = platform_get_resource_byname(pdev, IORESOURCE_MEM, "config");
>> +     if (!res)
>> +             return -ENXIO;
>> +
>> +     /* Check that this has sensible values */
>> +     if ((resource_size(res) != CFG_REGION_SIZE) ||
>> +         (res->start & (CFG_REGION_SIZE - 1))) {
>> +             dev_err(&pdev->dev, "Invalid config space properties\n");
>> +             return -EINVAL;
>> +     }
>> +     pcie->config_window_start = res->start;
>> +
>> +     pcie->config_area = devm_ioremap_resource(&pdev->dev, res);
>> +     if (IS_ERR(pcie->config_area))
>> +             return PTR_ERR(pcie->config_area);
>> +
>> +     pcie->lmi = platform_get_resource_byname(pdev, IORESOURCE_MEM,
>> +                                              "mem-window");
>> +     if (!pcie->lmi)
>> +             return -ENXIO;
>> +
>> +     /* regmap registers for PCIe IP configuration */
>> +     pcie->regmap = syscon_regmap_lookup_by_phandle(np, "st,syscfg");
>> +     if (IS_ERR(pcie->regmap)) {
>> +             dev_err(&pdev->dev, "No syscfg phandle specified\n");
>> +             return PTR_ERR(pcie->regmap);
>> +     }
>> +
>> +     ret = of_property_read_u32_index(np, "st,syscfg", SYSCFG0_REG,
>> +                                      &pcie->syscfg0);
>> +     if (ret) {
>> +             dev_err(&pdev->dev, "can't get syscfg0 offset (%d)\n", ret);
>> +             return ret;
>> +     }
>> +
>> +     ret = of_property_read_u32_index(np, "st,syscfg", SYSCFG1_REG,
>> +                                      &pcie->syscfg1);
>> +     if (ret) {
>> +             dev_err(&pdev->dev, "can't get syscfg1 offset (%d)\n", ret);
>> +             return ret;
>> +     }
>> +
>> +     /* retrieve data opts from compatible */
>> +     pcie->data = of_match_node(st_pcie_of_match, np)->data;
>> +     if (!pcie->data) {
>> +             dev_err(&pdev->dev, "compatible data not provided\n");
>> +             return -EINVAL;
>> +     }
>> +
>> +     /* powerdown / resets */
>> +     pcie->pwr = devm_reset_control_get(&pdev->dev, "powerdown");
>> +     if (IS_ERR(pcie->pwr)) {
>> +             dev_err(&pdev->dev, "powerdown reset control not defined\n");
>> +             return -EINVAL;
>
> Please return PTR_ERR(pcie->pwr) instead of '-EINVAL'.
>
ok

>> +     }
>> +
>> +     pcie->rst = devm_reset_control_get(&pdev->dev, "softreset");
>> +     if (IS_ERR(pcie->rst)) {
>> +             dev_err(&pdev->dev, "Soft reset control not defined\n");
>> +             return -EINVAL;
>
> Please return PTR_ERR(pcie->pwr) instead of '-EINVAL'.
>
ok

>> +     }
>> +
>> +     /* phy */
>> +     if (!pcie->data->phy_auto) {
>> +             pcie->phy = devm_phy_get(&pdev->dev, "pcie_phy");
>> +             if (IS_ERR(pcie->phy)) {
>> +                     dev_err(&pdev->dev, "no PHY configured\n");
>> +                     return PTR_ERR(pcie->phy);
>> +             }
>> +     }
>> +
>> +     /* Claim the GPIO for PRST# if available */
>> +     pcie->reset_gpio = of_get_named_gpio(np, "reset-gpio", 0);
>> +     if (!gpio_is_valid(pcie->reset_gpio))
>> +             dev_dbg(&pdev->dev, "No reset-gpio configured\n");
>> +     else {
>> +             ret = devm_gpio_request(&pdev->dev,
>> +                                     pcie->reset_gpio,
>> +                                     "PCIe reset");
>> +             if (ret) {
>> +                     dev_err(&pdev->dev, "Cannot request reset-gpio %d\n",
>> +                             pcie->reset_gpio);
>> +                     return ret;
>> +             }
>> +     }
>> +
>> +     if (IS_ENABLED(CONFIG_PCI_MSI)) {
>> +             pp->msi_irq = platform_get_irq_byname(pdev, "msi");
>> +             if (pp->msi_irq <= 0) {
>> +                     dev_err(&pdev->dev, "failed to get MSI irq\n");
>> +                     return -ENODEV;
>> +             }
>> +
>> +             ret = devm_request_irq(&pdev->dev, pp->msi_irq,
>> +                                    st_pcie_msi_irq_handler,
>> +                                    IRQF_SHARED, "st-pcie-msi", pp);
>> +             if (ret) {
>> +                     dev_err(&pdev->dev, "failed to request MSI irq\n");
>> +                     return -ENODEV;
>> +             }
>> +     }
>> +
>> +     if (IS_ENABLED(CONFIG_ARM)) {
>> +             /*
>> +              * We have to hook the abort handler so that we can intercept
>> +              * bus errors when doing config read/write that return UR,
>> +              * which is flagged up as a bus error
>> +              */
>> +             hook_fault_code(16+6, st_pcie_abort_handler, SIGBUS, 0,
>> +                             "imprecise external abort");
>> +     }
>> +
>> +     pp->root_bus_nr = -1;
>> +     pp->ops = &st_pcie_host_ops;
>> +
>> +     ret = dw_pcie_host_init(pp);
>> +     if (ret) {
>> +             dev_err(&pdev->dev, "failed to initialize host\n");
>> +             return ret;
>> +     }
>> +
>> +     platform_set_drvdata(pdev, pcie);
>> +
>> +     dev_info(&pdev->dev, "Initialized\n");
>> +     return 0;
>> +}
>> +
>> +MODULE_DEVICE_TABLE(of, st_pcie_of_match);
>> +
>> +static struct platform_driver st_pcie_driver = {
>> +     .driver = {
>> +             .name = "st-pcie",
>> +             .of_match_table = st_pcie_of_match,
>> +             .pm = &st_pcie_pm_ops,
>> +     },
>> +};
>> +
>> +/* ST PCIe driver does not allow module unload */
>> +static int __init pcie_init(void)
>> +{
>> +     return platform_driver_probe(&st_pcie_driver, st_pcie_probe);
>> +}
>> +device_initcall(pcie_init);
>> +
>> +MODULE_AUTHOR("Fabrice Gasnier <fabrice.gasnier@st.com>");
>> +MODULE_DESCRIPTION("PCI express Driver for ST SoCs");
>> +MODULE_LICENSE("GPLv2");
>
> Please add one space between 'GPL' and 'v2'.
>
> s/"GPLv2"/"GPL v2"
>
> According to the license_is_gpl_compatible(), the MODULE_LICENSE() string
> for GPL v2 is "GPL v2" not "GPLv2".
>

ok


> Best regards,
> Jingoo Han
>
>> --
>> 1.9.1
>

BR

Gabriel
