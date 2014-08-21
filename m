Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753956AbaHUHM1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Aug 2014 03:12:27 -0400
Received: from mail-qa0-f49.google.com ([209.85.216.49]:61437 "EHLO
	mail-qa0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750951AbaHUHMX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Aug 2014 03:12:23 -0400
MIME-Version: 1.0
In-Reply-To: <53F4B7AB.1020009@ti.com>
References: <1407944075-8093-1-git-send-email-gabriel.fernandez@linaro.org>
	<1407944075-8093-4-git-send-email-gabriel.fernandez@linaro.org>
	<53F4B7AB.1020009@ti.com>
Date: Thu, 21 Aug 2014 09:12:22 +0200
Message-ID: <CAG374jB617upnE0F+ZXkkAR6U6eoGKOPMMWfDFWm0N8WJ+eoVA@mail.gmail.com>
Subject: Re: [PATCH 3/5] phy: miphy28lp: Provide support for the MiPHY28lp
 Generic PHY
From: Gabriel Fernandez <gabriel.fernandez@linaro.org>
To: Kishon Vijay Abraham I <kishon@ti.com>
Cc: Gabriel FERNANDEZ <gabriel.fernandez@st.com>,
        Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        Srinivas Kandagatla <srinivas.kandagatla@gmail.com>,
        Maxime Coquelin <maxime.coquelin@st.com>,
        Patrice Chotard <patrice.chotard@st.com>,
        Russell King <linux@arm.linux.org.uk>,
        Grant Likely <grant.likely@linaro.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "kernel@stlinux.com" <kernel@stlinux.com>,
        alexandre torgue <alexandre.torgue@st.com>,
        Giuseppe Cavallaro <peppe.cavallaro@st.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Kishon,

ok i'll split into specific procedures.

BR

Gabriel.

On 20 August 2014 16:58, Kishon Vijay Abraham I <kishon@ti.com> wrote:
> Hi,
>
> On Wednesday 13 August 2014 09:04 PM, Gabriel FERNANDEZ wrote:
>> The MiPHY28lp is a Generic PHY which can serve various SATA or PCIe
>> or USB3 devices.
>>
>> Signed-off-by: alexandre torgue <alexandre.torgue@st.com>
>> Signed-off-by: Giuseppe Cavallaro <peppe.cavallaro@st.com>
>> Signed-off-by: Gabriel Fernandez <gabriel.fernandez@linaro.org>
>> ---
>>  drivers/phy/Kconfig         |   8 +
>>  drivers/phy/Makefile        |   1 +
>>  drivers/phy/phy-miphy28lp.c | 736 ++++++++++++++++++++++++++++++++++++++++++++
>>  3 files changed, 745 insertions(+)
>>  create mode 100644 drivers/phy/phy-miphy28lp.c
>>
>> diff --git a/drivers/phy/Kconfig b/drivers/phy/Kconfig
>> index 0dd7427..2053f72 100644
>> --- a/drivers/phy/Kconfig
>> +++ b/drivers/phy/Kconfig
>> @@ -230,4 +230,12 @@ config PHY_XGENE
>>       help
>>         This option enables support for APM X-Gene SoC multi-purpose PHY.
>>
>> +config PHY_MIPHY28LP
>> +     tristate "STMicroelectronics MIPHY28LP PHY driver for STiH407"
>> +     depends on ARCH_STI
>> +     depends on GENERIC_PHY
>> +     help
>> +       Enable this to support the miphy transceiver (for SATA/PCIE/USB3)
>> +       that is part of STMicroelectronics STiH407 SoC.
>> +
>>  endmenu
>> diff --git a/drivers/phy/Makefile b/drivers/phy/Makefile
>> index 95c69ed..f7e7c59 100644
>> --- a/drivers/phy/Makefile
>> +++ b/drivers/phy/Makefile
>> @@ -8,6 +8,7 @@ obj-$(CONFIG_BCM_KONA_USB2_PHY)               += phy-bcm-kona-usb2.o
>>  obj-$(CONFIG_PHY_EXYNOS_DP_VIDEO)    += phy-exynos-dp-video.o
>>  obj-$(CONFIG_PHY_EXYNOS_MIPI_VIDEO)  += phy-exynos-mipi-video.o
>>  obj-$(CONFIG_PHY_MVEBU_SATA)         += phy-mvebu-sata.o
>> +obj-$(CONFIG_PHY_MIPHY28LP)          += phy-miphy28lp.o
>>  obj-$(CONFIG_PHY_MIPHY365X)          += phy-miphy365x.o
>>  obj-$(CONFIG_OMAP_CONTROL_PHY)               += phy-omap-control.o
>>  obj-$(CONFIG_OMAP_USB2)                      += phy-omap-usb2.o
>> diff --git a/drivers/phy/phy-miphy28lp.c b/drivers/phy/phy-miphy28lp.c
>> new file mode 100644
>> index 0000000..767614c
>> --- /dev/null
>> +++ b/drivers/phy/phy-miphy28lp.c
>> @@ -0,0 +1,736 @@
>> +/*
>> + * Copyright (C) 2014 STMicroelectronics
>> + *
>> + * STMicroelectronics PHY driver MiPHY28lp (for SoC STiH407).
>> + *
>> + * Author: Alexandre Torgue <alexandre.torgue@st.com>
>> + *
>> + * This program is free software; you can redistribute it and/or modify
>> + * it under the terms of the GNU General Public License version 2, as
>> + * published by the Free Software Foundation.
>> + *
>> + */
>> +
>> +#include <linux/platform_device.h>
>> +#include <linux/io.h>
>> +#include <linux/kernel.h>
>> +#include <linux/module.h>
>> +#include <linux/of.h>
>> +#include <linux/of_platform.h>
>> +#include <linux/of_address.h>
>> +#include <linux/clk.h>
>> +#include <linux/phy/phy.h>
>> +#include <linux/delay.h>
>> +#include <linux/mfd/syscon.h>
>> +#include <linux/regmap.h>
>> +#include <linux/reset.h>
>> +
>> +#include <dt-bindings/phy/phy-miphy28lp.h>
>> +
>> +/* MiPHY registers */
>> +#define MIPHY_STATUS_1               0x02
>> +#define MIPHY_PHY_RDY                0x01
>> +#define MIPHY_PLL_HFC_RDY    0x06
>> +#define MIPHY_COMP_FSM_6     0x3f
>> +#define MIPHY_COMP_DONE              0x80
>> +
>> +#define MIPHY_CTRL_REG               0x04
>> +#define MIPHY_PX_RX_POL              BIT(5)
>> +
>> +/*
>> + * On STiH407 the glue logic can be different among MiPHY devices; for example:
>> + * MiPHY0: OSC_FORCE_EXT means:
>> + *  0: 30MHz crystal clk - 1: 100MHz ext clk routed through MiPHY1
>> + * MiPHY1: OSC_FORCE_EXT means:
>> + *  1: 30MHz crystal clk - 0: 100MHz ext clk routed through MiPHY1
>> + * Some devices have not the possibility to check if the osc is ready.
>> + */
>> +#define MIPHY_OSC_FORCE_EXT  BIT(3)
>> +#define MIPHY_OSC_RDY                BIT(5)
>> +
>> +#define MIPHY_CTRL_MASK              0xf
>> +#define MIPHY_CTRL_DEFAULT   0
>> +#define MIPHY_CTRL_SYNC_D_EN BIT(2)
>> +
>> +/* SATA / PCIe defines */
>> +#define SATA_CTRL_MASK               0x7
>> +#define PCIE_CTRL_MASK               0xff
>> +#define SATA_CTRL_SELECT_SATA        1
>> +#define SATA_CTRL_SELECT_PCIE        0
>> +#define SYSCFG_PCIE_PCIE_VAL 0x80
>> +#define SATA_SPDMODE         1
>> +
>> +struct miphy28lp_phy {
>> +     struct phy *phy;
>> +     struct miphy28lp_dev *phydev;
>> +     void __iomem *base;
>> +     void __iomem *pipebase;
>> +
>> +     bool osc_force_ext;
>> +     bool osc_rdy;
>> +     bool px_rx_pol_inv;
>> +
>> +     struct reset_control *miphy_rst;
>> +
>> +     u32 sata_gen;
>> +
>> +     /* Sysconfig registers offsets needed to configure the device */
>> +     u32 syscfg_miphy_ctrl;
>> +     u32 syscfg_miphy_status;
>> +     u32 syscfg_pci;
>> +     u32 syscfg_sata;
>> +     u8 type;
>> +};
>> +
>> +struct miphy28lp_dev {
>> +     struct device *dev;
>> +     struct regmap *regmap;
>> +     struct mutex miphy_mutex;
>> +     struct miphy28lp_phy **phys;
>> +};
>> +
>> +struct miphy_initval {
>> +     u16 reg;
>> +     u16 val;
>> +};
>> +
>> +enum miphy_sata_gen { SATA_GEN1, SATA_GEN2, SATA_GEN3 };
>> +
>> +static char *miphy_type_name[] = { "sata-up", "pcie-up", "usb3-up" };
>> +
>> +static const struct miphy_initval miphylp28_initvals_sata[] = {
>> +     /* Putting Macro in reset */
>> +     {0x00, 0x01}, {0x00, 0x03},
>> +     /* Wait for a while */
>> +     {0x00, 0x01}, {0x04, 0x1c},
>> +     /* PLL calibration */
>> +     {0xeb, 0x1d}, {0x0d, 0x1e}, {0x0f, 0x00},
>> +     /* Writing The PLL Ratio */
>> +     {0xd4, 0xc8}, {0xd5, 0x00}, {0xd6, 0x00}, {0xd7, 0x00},
>> +     {0xd3, 0x00}, {0x0f, 0x02}, {0x0e, 0x0a}, {0x0f, 0x01},
>> +     {0x0e, 0x0a}, {0x0f, 0x00}, {0x0e, 0x0a}, {0x4e, 0xd1},
>> +     {0x4e, 0xd1},
>> +     /* Rx Calibration */
>> +     {0x99, 0x1f}, {0x0a, 0x41}, {0x7a, 0x0d}, {0x7f, 0x7d},
>> +     {0x80, 0x56}, {0x81, 0x00}, {0x7b, 0x00}, {0xc1, 0x01},
>> +     {0xc2, 0x01}, {0x97, 0xf3}, {0xc9, 0x02}, {0xca, 0x02},
>> +     {0xcb, 0x02}, {0xcc, 0x0a}, {0x9d, 0xe5}, {0x0f, 0x00},
>> +     {0x0e, 0x02}, {0x0e, 0x00}, {0x63, 0x00}, {0x64, 0xaf},
>> +     {0x0f, 0x00}, {0x49, 0x07}, {0x0f, 0x01}, {0x49, 0x07},
>> +     {0x0f, 0x02}, {0x49, 0x07}, {0x0f, 0x03}, {0x49, 0x07},
>> +     {0x0f, 0x00}, {0x4a, 0x50}, {0x4a, 0x53}, {0x4b, 0x00},
>> +     {0x4b, 0x00}, {0x0f, 0x01}, {0x0e, 0x04}, {0x0e, 0x05},
>> +     {0x63, 0x00}, {0x64, 0xae}, {0x0f, 0x00}, {0x49, 0x07},
>> +     {0x0f, 0x01}, {0x49, 0x07}, {0x0f, 0x02}, {0x49, 0x07},
>> +     {0x0f, 0x03}, {0x49, 0x07}, {0x0f, 0x01}, {0x4a, 0x73},
>> +     {0x4a, 0x72}, {0x4b, 0x20}, {0x4b, 0x20}, {0x0f, 0x02},
>> +     {0x0e, 0x09}, {0x0e, 0x0a}, {0x63, 0x00}, {0x64, 0xae},
>> +     {0x0f, 0x00}, {0x49, 0x07}, {0x0f, 0x01}, {0x49, 0x07},
>> +     {0x0f, 0x02}, {0x49, 0x07}, {0x0f, 0x03}, {0x49, 0x07},
>> +     {0x0f, 0x02}, {0x4a, 0xc2}, {0x4a, 0xc0}, {0x4b, 0x20},
>> +     {0x4b, 0x20}, {0xcd, 0x21}, {0xcd, 0x21}, {0x00, 0x00},
>> +     {0x00, 0x01}, {0x00, 0x00}, {0x01, 0x04}, {0x01, 0x05},
>> +     {0xe9, 0x00}, {0x0d, 0x1e}, {0x3a, 0x40}, {0x01, 0x01},
>> +     {0x01, 0x00}, {0xe9, 0x40}, {0x0a, 0x41}, {0x0f, 0X00},
>> +     {0x0b, 0x00}, {0x0b, 0x00}, {0x62, 0x00}, {0x0f, 0x00},
>> +     {0xe3, 0x02}, {0xe3, 0x02}, {0x26, 0x27}, {0x26, 0x00},
>> +     {0x26, 0x62}, {0x26, 0x00}, {0x0f, 0x00}, {0x0f, 0x01},
>> +     {0x0f, 0x02}, {0x0f, 0x00},
>
> I'm not in for doing this sort of initialization. Sorry.
>
> Thanks
> Kishon
