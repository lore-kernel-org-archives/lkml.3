Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754067AbaIHPNm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Sep 2014 11:13:42 -0400
Received: from arroyo.ext.ti.com ([192.94.94.40]:35196 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753070AbaIHPNi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Sep 2014 11:13:38 -0400
Message-ID: <540DC75C.40509@ti.com>
Date: Mon, 8 Sep 2014 20:42:28 +0530
From: Kishon Vijay Abraham I <kishon@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.0
MIME-Version: 1.0
To: Gabriel FERNANDEZ <gabriel.fernandez@st.com>,
        Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        Srinivas Kandagatla <srinivas.kandagatla@gmail.com>,
        Maxime Coquelin <maxime.coquelin@st.com>,
        Patrice Chotard <patrice.chotard@st.com>,
        Russell King <linux@arm.linux.org.uk>,
        Grant Likely <grant.likely@linaro.org>
CC: <devicetree@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>, <kernel@stlinux.com>,
        Gabriel Fernandez <gabriel.fernandez@linaro.org>,
        alexandre torgue <alexandre.torgue@st.com>,
        Giuseppe Cavallaro <peppe.cavallaro@st.com>
Subject: Re: [PATCH v2 3/8] phy: miphy28lp: Provide support for the MiPHY28lp
 Generic PHY
References: <1409758637-28654-1-git-send-email-gabriel.fernandez@linaro.org> <1409758637-28654-4-git-send-email-gabriel.fernandez@linaro.org>
In-Reply-To: <1409758637-28654-4-git-send-email-gabriel.fernandez@linaro.org>
Content-Type: text/plain; charset="windows-1252"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Wednesday 03 September 2014 09:07 PM, Gabriel FERNANDEZ wrote:
> The MiPHY28lp is a Generic PHY which can serve various SATA or PCIe
> or USB3 devices.
> 
> Signed-off-by: alexandre torgue <alexandre.torgue@st.com>
> Signed-off-by: Giuseppe Cavallaro <peppe.cavallaro@st.com>
> Signed-off-by: Gabriel Fernandez <gabriel.fernandez@linaro.org>
> ---
>  drivers/phy/Kconfig         |   8 +
>  drivers/phy/Makefile        |   1 +
>  drivers/phy/phy-miphy28lp.c | 985 ++++++++++++++++++++++++++++++++++++++++++++
>  3 files changed, 994 insertions(+)
>  create mode 100644 drivers/phy/phy-miphy28lp.c
> 
> diff --git a/drivers/phy/Kconfig b/drivers/phy/Kconfig
> index 0dd7427..2053f72 100644
> --- a/drivers/phy/Kconfig
> +++ b/drivers/phy/Kconfig
> @@ -230,4 +230,12 @@ config PHY_XGENE
>  	help
>  	  This option enables support for APM X-Gene SoC multi-purpose PHY.
>  
> +config PHY_MIPHY28LP
> +	tristate "STMicroelectronics MIPHY28LP PHY driver for STiH407"
> +	depends on ARCH_STI
> +	depends on GENERIC_PHY

Select GENERIC_PHY so that it's same as other PHY drivers.
> +	help
> +	  Enable this to support the miphy transceiver (for SATA/PCIE/USB3)
> +	  that is part of STMicroelectronics STiH407 SoC.
> +
>  endmenu
> diff --git a/drivers/phy/Makefile b/drivers/phy/Makefile
> index 95c69ed..f7e7c59 100644
> --- a/drivers/phy/Makefile
> +++ b/drivers/phy/Makefile
> @@ -8,6 +8,7 @@ obj-$(CONFIG_BCM_KONA_USB2_PHY)		+= phy-bcm-kona-usb2.o
>  obj-$(CONFIG_PHY_EXYNOS_DP_VIDEO)	+= phy-exynos-dp-video.o
>  obj-$(CONFIG_PHY_EXYNOS_MIPI_VIDEO)	+= phy-exynos-mipi-video.o
>  obj-$(CONFIG_PHY_MVEBU_SATA)		+= phy-mvebu-sata.o
> +obj-$(CONFIG_PHY_MIPHY28LP) 		+= phy-miphy28lp.o
>  obj-$(CONFIG_PHY_MIPHY365X)		+= phy-miphy365x.o
>  obj-$(CONFIG_OMAP_CONTROL_PHY)		+= phy-omap-control.o
>  obj-$(CONFIG_OMAP_USB2)			+= phy-omap-usb2.o
> diff --git a/drivers/phy/phy-miphy28lp.c b/drivers/phy/phy-miphy28lp.c
> new file mode 100644
> index 0000000..aa36cea
> --- /dev/null
> +++ b/drivers/phy/phy-miphy28lp.c
> @@ -0,0 +1,985 @@
> +/*
> + * Copyright (C) 2014 STMicroelectronics
> + *
> + * STMicroelectronics PHY driver MiPHY28lp (for SoC STiH407).
> + *
> + * Author: Alexandre Torgue <alexandre.torgue@st.com>
> + *
> + * This program is free software; you can redistribute it and/or modify
> + * it under the terms of the GNU General Public License version 2, as
> + * published by the Free Software Foundation.
> + *
> + */
> +
> +#include <linux/platform_device.h>
> +#include <linux/io.h>
> +#include <linux/kernel.h>
> +#include <linux/module.h>
> +#include <linux/of.h>
> +#include <linux/of_platform.h>
> +#include <linux/of_address.h>
> +#include <linux/clk.h>
> +#include <linux/phy/phy.h>
> +#include <linux/delay.h>
> +#include <linux/mfd/syscon.h>
> +#include <linux/regmap.h>
> +#include <linux/reset.h>
> +
> +#include <dt-bindings/phy/phy-miphy.h>
> +
> +/* MiPHY mask registers */
> +#define MIPHY_PHY_RDY		0x01
> +#define MIPHY_PLL_HFC_RDY	0x06
> +#define MIPHY_COMP_DONE		0x80
> +
> +#define MIPHY_PX_RX_POL		BIT(5)
> +
> +/* MiPHY registers */
> +#define MIPHY_CONF_RESET		0x00
> +#define MIPHY_RESET			0x01
> +#define MIPHY_STATUS_1			0x02
> +#define MIPHY_CONTROL			0x04
> +#define MIPHY_BOUNDARY_SEL		0x0a
> +#define MIPHY_BOUNDARY_1		0x0b
> +#define MIPHY_BOUNDARY_2		0x0c
> +#define MIPHY_PLL_CLKREF_FREQ		0x0d
> +#define MIPHY_SPEED			0x0e
> +#define MIPHY_CONF			0x0f
> +#define MIPHY_CTRL_TEST_SEL		0x20
> +#define MIPHY_CTRL_TEST_1		0x21
> +#define MIPHY_CTRL_TEST_2		0x22
> +#define MIPHY_CTRL_TEST_3		0x23
> +#define MIPHY_CTRL_TEST_4		0x24
> +#define MIPHY_FEEDBACK_TEST		0x25
> +#define MIPHY_DEBUG_BUS			0x26
> +#define MIPHY_DEBUG_STATUS_MSB		0x27
> +#define MIPHY_DEBUG_STATUS_LSB		0x28
> +#define MIPHY_PWR_RAIL_1		0x29
> +#define MIPHY_PWR_RAIL_2		0x2a
> +#define MIPHY_SYNCHAR_CONTROL		0x30
> +#define MIPHY_COMP_FSM_1		0x3a
> +#define MIPHY_COMP_FSM_6		0x3f
> +#define MIPHY_COMP_POSTP		0x42
> +#define MIPHY_TX_CTRL_1			0x49
> +#define MIPHY_TX_CTRL_2			0x4a
> +#define MIPHY_TX_CTRL_3			0x4b
> +#define MIPHY_TX_CAL_MAN		0x4e
> +#define MIPHY_TST_BIAS_BOOST_2		0x62
> +#define MIPHY_BIAS_BOOST_1		0x63
> +#define MIPHY_BIAS_BOOST_2		0x64
> +#define MIPHY_RX_DESBUFF_FDB_2		0x67
> +#define MIPHY_RX_DESBUFF_FDB_3		0x68
> +#define MIPHY_SIGDET_COMPENS1		0x69
> +#define MIPHY_SIGDET_COMPENS2		0x6a
> +#define MIPHY_JITTER_PERIOD		0x6b
> +#define MIPHY_JITTER_AMPLITUDE_1	0x6c
> +#define MIPHY_JITTER_AMPLITUDE_2	0x6d
> +#define MIPHY_JITTER_AMPLITUDE_3	0x6e
> +#define MIPHY_RX_K_GAIN			0x78
> +#define MIPHY_RX_BUFFER_CTRL		0x7a
> +#define MIPHY_RX_VGA_GAIN		0x7b
> +#define MIPHY_RX_EQU_GAIN_1		0x7f
> +#define MIPHY_RX_EQU_GAIN_2		0x80
> +#define MIPHY_RX_EQU_GAIN_3		0x81
> +#define MIPHY_RX_CAL_CTRL_1		0x97
> +#define MIPHY_RX_CAL_CTRL_2		0x98
> +#define MIPHY_RX_CAL_OFFSET_CTRL	0x99
> +#define MIPHY_RX_CAL_VGA_STEP		0x9a
> +#define MIPHY_RX_CAL_EYE_MIN		0x9d
> +#define MIPHY_RX_CAL_OPT_LENGTH		0x9f
> +#define MIPHY_RX_LOCK_CTRL_1		0xc1
> +#define MIPHY_RX_LOCK_SETTINGS_OPT	0xc2
> +#define MIPHY_RX_LOCK_STEP		0xc4
> +#define MIPHY_RX_SIGDET_SLEEP_OA	0xc9
> +#define MIPHY_RX_SIGDET_SLEEP_SEL	0xca
> +#define MIPHY_RX_SIGDET_WAIT_SEL	0xcb
> +#define MIPHY_RX_SIGDET_DATA_SEL	0xcc
> +#define MIPHY_RX_POWER_CTRL_1		0xcd
> +#define MIPHY_RX_POWER_CTRL_2		0xce
> +#define MIPHY_PLL_CALSET_CTRL		0xd3
> +#define MIPHY_PLL_CALSET_1		0xd4
> +#define MIPHY_PLL_CALSET_2		0xd5
> +#define MIPHY_PLL_CALSET_3		0xd6
> +#define MIPHY_PLL_CALSET_4		0xd7
> +#define MIPHY_PLL_SBR_1			0xe3
> +#define MIPHY_PLL_SBR_2			0xe4
> +#define MIPHY_PLL_SBR_3			0xe5
> +#define MIPHY_PLL_SBR_4			0xe6
> +#define MIPHY_PLL_COMMON_MISC_2		0xe9
> +#define MIPHY_PLL_SPAREIN		0xeb
> +
> +/*
> + * On STiH407 the glue logic can be different among MiPHY devices; for example:
> + * MiPHY0: OSC_FORCE_EXT means:
> + *  0: 30MHz crystal clk - 1: 100MHz ext clk routed through MiPHY1
> + * MiPHY1: OSC_FORCE_EXT means:
> + *  1: 30MHz crystal clk - 0: 100MHz ext clk routed through MiPHY1
> + * Some devices have not the possibility to check if the osc is ready.
> + */
> +#define MIPHY_OSC_FORCE_EXT	BIT(3)
> +#define MIPHY_OSC_RDY		BIT(5)
> +
> +#define MIPHY_CTRL_MASK		0x0f
> +#define MIPHY_CTRL_DEFAULT	0
> +#define MIPHY_CTRL_SYNC_D_EN	BIT(2)
> +
> +/* SATA / PCIe defines */
> +#define SATA_CTRL_MASK		0x07
> +#define PCIE_CTRL_MASK		0xff
> +#define SATA_CTRL_SELECT_SATA	1
> +#define SATA_CTRL_SELECT_PCIE	0
> +#define SYSCFG_PCIE_PCIE_VAL	0x80
> +#define SATA_SPDMODE		1
> +
> +struct miphy28lp_phy {
> +	struct phy *phy;
> +	struct miphy28lp_dev *phydev;
> +	void __iomem *base;
> +	void __iomem *pipebase;
> +
> +	bool osc_force_ext;
> +	bool osc_rdy;
> +	bool px_rx_pol_inv;
> +
> +	struct reset_control *miphy_rst;
> +
> +	u32 sata_gen;
> +
> +	/* Sysconfig registers offsets needed to configure the device */
> +	u32 syscfg_miphy_ctrl;
> +	u32 syscfg_miphy_status;
> +	u32 syscfg_pci;
> +	u32 syscfg_sata;
> +	u8 type;
> +};
> +
> +struct miphy28lp_dev {
> +	struct device *dev;
> +	struct regmap *regmap;
> +	struct mutex miphy_mutex;
> +	struct miphy28lp_phy **phys;
> +};
> +
> +struct miphy_initval {
> +	u16 reg;
> +	u16 val;
> +};
> +
> +enum miphy_sata_gen { SATA_GEN1, SATA_GEN2, SATA_GEN3 };
> +
> +static char *miphy_type_name[] = { "sata-up", "pcie-up", "usb3-up" };
> +
> +static inline void miphy28lp_cfg_out_of_reset(struct miphy28lp_phy *miphy_phy)
> +{
> +	unsigned long finish = jiffies + 5 * HZ;
> +	u8 mask = MIPHY_PLL_HFC_RDY;
> +	u8 val;
> +
> +	do {
> +		val = readb_relaxed(miphy_phy->base + MIPHY_STATUS_1);
> +		if ((val & mask) != mask)
> +			cpu_relax();
> +		else
> +			break;
> +	} while (!time_after_eq(jiffies, finish));
> +}
> +
> +static inline void miphy28lp_configure_reset(struct miphy28lp_phy *miphy_phy)
> +{
> +	void *base = miphy_phy->base;
> +
> +	/* Putting Macro in reset */
> +	writeb_relaxed(0x01, base + MIPHY_CONF_RESET);
> +	writeb_relaxed(0x03, base + MIPHY_CONF_RESET);
> +
> +	/* Wait for a while */
> +	usleep_range(10, 20); /* extra delay after resetting */

How was this delay value derived? If the HW spec says so, it would be better to
document it here. Applicable for all the delays added in this patch.
> +}
> +
> +
> +
> +static inline void miphy28lp_configure_sata(struct miphy28lp_phy *miphy_phy)
> +{
> +	void __iomem *base = miphy_phy->base;
> +
> +	/* Putting Macro in reset */
> +	writeb_relaxed(0x01, base + MIPHY_CONF_RESET);
> +	writeb_relaxed(0x03, base + MIPHY_CONF_RESET);
> +
> +	/* Wait for a while */
> +	usleep_range(10, 20); /* extra delay after resetting */

You already have a function miphy28lp_configure_reset doing the same no?
> +
> +	/* Bringing the MIPHY-CPU registers out of reset */
> +	writeb_relaxed(0x1c, base + MIPHY_CONTROL);
> +
> +	/* Applying PLL Settings */
> +	writeb_relaxed(0x1d, base + MIPHY_PLL_SPAREIN);
> +	writeb_relaxed(0x1e, base + MIPHY_PLL_CLKREF_FREQ);
> +
> +	/* PLL Ratio */
> +	writeb_relaxed(0xc8, base + MIPHY_PLL_CALSET_1);
> +	writeb_relaxed(0x00, base + MIPHY_PLL_CALSET_2);
> +	writeb_relaxed(0x00, base + MIPHY_PLL_CALSET_3);
> +	writeb_relaxed(0x00, base + MIPHY_PLL_CALSET_4);
> +
> +	/* Number of PLL Calibrations */
> +	writeb_relaxed(0x00, base + MIPHY_PLL_CALSET_CTRL);
> +
> +	/* Unbanked Settings */
> +	writeb_relaxed(0xd1, base + MIPHY_TX_CAL_MAN);
> +	writeb_relaxed(0x1f, base + MIPHY_RX_CAL_OFFSET_CTRL);
> +	writeb_relaxed(0x40, base + MIPHY_BOUNDARY_SEL);
> +
> +	/* Banked settings */
> +	/* Gen 1 */
> +	writeb_relaxed(0x00, base + MIPHY_CONF);
> +	writeb_relaxed(0x00, base + MIPHY_SPEED);
> +	writeb_relaxed(0x00, base + MIPHY_BIAS_BOOST_1);

Aren't the 0's default reset values? Can we do only the bare minimal settings
required to get this PHY functions.

> +	writeb_relaxed(0xae, base + MIPHY_BIAS_BOOST_2);
> +
> +	/* TX buffer Settings */
> +	writeb_relaxed(0x53, base + MIPHY_TX_CTRL_2);
> +	writeb_relaxed(0x00, base + MIPHY_TX_CTRL_3);
> +
> +	/* RX Buffer Settings */
> +	writeb_relaxed(0x0d, base + MIPHY_RX_BUFFER_CTRL);
> +	writeb_relaxed(0x7d, base + MIPHY_RX_EQU_GAIN_1);
> +	writeb_relaxed(0x56, base + MIPHY_RX_EQU_GAIN_2);
> +	writeb_relaxed(0x00, base + MIPHY_RX_EQU_GAIN_3);
> +	writeb_relaxed(0x00, base + MIPHY_RX_VGA_GAIN);
> +
> +	/* Gen 2 */
> +	writeb_relaxed(0x01, base + MIPHY_CONF);
> +	writeb_relaxed(0x05, base + MIPHY_SPEED);
> +	writeb_relaxed(0x00, base + MIPHY_BIAS_BOOST_1);
> +	writeb_relaxed(0xae, base + MIPHY_BIAS_BOOST_2);
> +
> +	/* TX buffer Settings */
> +	writeb_relaxed(0x72, base + MIPHY_TX_CTRL_2);
> +	writeb_relaxed(0x20, base + MIPHY_TX_CTRL_3);
> +
> +	/* RX Buffer Settings */
> +	writeb_relaxed(0x0d, base + MIPHY_RX_BUFFER_CTRL);
> +	writeb_relaxed(0x7d, base + MIPHY_RX_EQU_GAIN_1);
> +	writeb_relaxed(0x56, base + MIPHY_RX_EQU_GAIN_2);
> +	writeb_relaxed(0x00, base + MIPHY_RX_EQU_GAIN_3);
> +	writeb_relaxed(0x00, base + MIPHY_RX_VGA_GAIN);
> +
> +	/* Gen 3 */
> +	writeb_relaxed(0x02, base + MIPHY_CONF);
> +	writeb_relaxed(0x0a, base + MIPHY_SPEED);
> +	writeb_relaxed(0x00, base + MIPHY_BIAS_BOOST_1);
> +	writeb_relaxed(0xae, base + MIPHY_BIAS_BOOST_2);
> +
> +	/* TX buffer Settings */
> +	writeb_relaxed(0xc0, base + MIPHY_TX_CTRL_2);
> +	writeb_relaxed(0x20, base + MIPHY_TX_CTRL_3);
> +
> +	/* RX Buffer Settings */
> +	writeb_relaxed(0x0d, base + MIPHY_RX_BUFFER_CTRL);
> +	writeb_relaxed(0x7d, base + MIPHY_RX_EQU_GAIN_1);
> +	writeb_relaxed(0x56, base + MIPHY_RX_EQU_GAIN_2);
> +	writeb_relaxed(0x00, base + MIPHY_RX_EQU_GAIN_3);
> +	writeb_relaxed(0x00, base + MIPHY_RX_VGA_GAIN);
> +
> +	/* Power control */
> +	writeb_relaxed(0x21, base + MIPHY_RX_POWER_CTRL_1);
> +
> +	/* Macro out of reset */
> +	writeb_relaxed(0x00, base + MIPHY_CONF_RESET);
> +
> +	/* Poll for HFC ready after reset release */
> +	/* Compensation measurement */
> +	writeb_relaxed(0x05, base + MIPHY_RESET);
> +	writeb_relaxed(0x00, base + MIPHY_PLL_COMMON_MISC_2);
> +	writeb_relaxed(0x40, base + MIPHY_COMP_FSM_1);
> +	writeb_relaxed(0x00, base + MIPHY_RESET);
> +	writeb_relaxed(0x40, base + MIPHY_PLL_COMMON_MISC_2);

This function can be split into separate smaller functions and can be resued
for pcie and usb3.
> +}
> +
> +static inline void miphy28lp_configure_pcie(struct miphy28lp_phy *miphy_phy)
> +{
> +	void __iomem *base = miphy_phy->base;
> +
> +	/* Putting Macro in reset */
> +	writeb_relaxed(0x01, base + MIPHY_CONF_RESET);
> +	writeb_relaxed(0x03, base + MIPHY_CONF_RESET);
> +
> +	/* Wait for a while */
> +	usleep_range(10, 20); /* extra delay after resetting */
> +
> +	/* Bringing the MIPHY-CPU registers out of reset */
> +	writeb_relaxed(0x01, base + MIPHY_CONF_RESET);
> +	writeb_relaxed(0x14, base + MIPHY_CONTROL);
> +	writeb_relaxed(0x1d, base + MIPHY_PLL_SPAREIN);
> +
> +	/* Applying PLL Settings */
> +	writeb_relaxed(0x1e, base + MIPHY_PLL_CLKREF_FREQ);
> +
> +	/* PLL Ratio */
> +	writeb_relaxed(0xa6, base + MIPHY_PLL_CALSET_1);
> +	writeb_relaxed(0xaa, base + MIPHY_PLL_CALSET_2);
> +	writeb_relaxed(0xaa, base + MIPHY_PLL_CALSET_3);
> +	writeb_relaxed(0x00, base + MIPHY_PLL_CALSET_4);
> +	writeb_relaxed(0x00, base + MIPHY_PLL_CALSET_CTRL);
> +
> +	writeb_relaxed(0xd1, base + MIPHY_TX_CAL_MAN);
> +	writeb_relaxed(0x5f, base + MIPHY_RX_CAL_OFFSET_CTRL);
> +	writeb_relaxed(0x40, base + MIPHY_BOUNDARY_SEL);
> +
> +	/* Banked settings */
> +	/* Gen 1 */
> +	writeb_relaxed(0x00, base + MIPHY_CONF);
> +
> +	writeb_relaxed(0x05, base + MIPHY_SPEED);
> +	writeb_relaxed(0x00, base + MIPHY_BIAS_BOOST_1);
> +	writeb_relaxed(0xa5, base + MIPHY_BIAS_BOOST_2);
> +
> +	/* TX buffer Settings */
> +	writeb_relaxed(0x07, base + MIPHY_TX_CTRL_1);
> +	writeb_relaxed(0x71, base + MIPHY_TX_CTRL_2);
> +	writeb_relaxed(0x60, base + MIPHY_TX_CTRL_3);
> +	 writeb_relaxed(0x98, base + MIPHY_RX_K_GAIN);
> +
> +	/* RX Buffer Settings */
> +	writeb_relaxed(0x0d, base + MIPHY_RX_BUFFER_CTRL);
> +	writeb_relaxed(0x00, base + MIPHY_RX_VGA_GAIN);
> +	writeb_relaxed(0x79, base + MIPHY_RX_EQU_GAIN_1);
> +	writeb_relaxed(0x56, base + MIPHY_RX_EQU_GAIN_2);
> +
> +	/* Gen 2 */
> +	writeb_relaxed(0x01, base + MIPHY_CONF);
> +	writeb_relaxed(0x0a, base + MIPHY_SPEED);
> +	writeb_relaxed(0x00, base + MIPHY_BIAS_BOOST_1);
> +	writeb_relaxed(0xa5, base + MIPHY_BIAS_BOOST_2);
> +
> +	/* TX buffer Settings */
> +	writeb_relaxed(0x07, base + MIPHY_TX_CTRL_1);
> +	writeb_relaxed(0x70, base + MIPHY_TX_CTRL_2);
> +	writeb_relaxed(0x60, base + MIPHY_TX_CTRL_3);
> +	writeb_relaxed(0xcc, base + MIPHY_RX_K_GAIN);
> +
> +	/* RX Buffer Settings */
> +	writeb_relaxed(0x0d, base + MIPHY_RX_BUFFER_CTRL);
> +	writeb_relaxed(0x00, base + MIPHY_RX_VGA_GAIN);
> +	writeb_relaxed(0x78, base + MIPHY_RX_EQU_GAIN_1);
> +	writeb_relaxed(0x07, base + MIPHY_RX_EQU_GAIN_2);
> +
> +	writeb_relaxed(0x21, base + MIPHY_RX_POWER_CTRL_1);
> +
> +	/* Macro out of reset */
> +	writeb_relaxed(0x00, base + MIPHY_CONF_RESET);
> +
> +	/* Poll for HFC ready after reset release */
> +	/* Compensation measurement */
> +	writeb_relaxed(0x05, base + MIPHY_RESET);
> +	writeb_relaxed(0x00, base + MIPHY_PLL_COMMON_MISC_2);
> +	writeb_relaxed(0x1e, base + MIPHY_PLL_CLKREF_FREQ);
> +	writeb_relaxed(0x40, base + MIPHY_COMP_FSM_1);
> +
> +	/* extra delay to wait pll lock */
> +	usleep_range(100, 120);
> +
> +	writeb_relaxed(0x01, base + MIPHY_RESET);
> +	writeb_relaxed(0x00, base + MIPHY_RESET);
> +	writeb_relaxed(0x40, base + MIPHY_PLL_COMMON_MISC_2);
> +	writeb_relaxed(0x02, base + MIPHY_PLL_SBR_1);

Are all these settings necessary? Can't we have a bare minimal settings needed
to get the PHY functional.

Thanks
Kishon
