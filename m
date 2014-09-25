Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753166AbaIYIyx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Sep 2014 04:54:53 -0400
Received: from mail-bn1bon0148.outbound.protection.outlook.com ([157.56.111.148]:18400
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753040AbaIYIyr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Sep 2014 04:54:47 -0400
Date: Thu, 25 Sep 2014 16:54:04 +0800
From: Shawn Guo <shawn.guo@freescale.com>
To: Xiubo Li <Li.Xiubo@freescale.com>
CC: <shawn.guo@linaro.org>, <mark.rutland@arm.com>,
        <u.kleine-koenig@pengutronix.de>, <linux-kernel@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH v3] ARM: ls1021a: add gating clocks to IP blocks.
Message-ID: <20140925085403.GG6405@dragon>
References: <1411476275-9164-1-git-send-email-Li.Xiubo@freescale.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <1411476275-9164-1-git-send-email-Li.Xiubo@freescale.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Originating-IP: [180.108.234.93]
X-ClientProxiedBy: SINPR01CA009.apcprd01.prod.exchangelabs.com (10.242.48.19)
 To DM2PR03MB350.namprd03.prod.outlook.com (10.141.54.21)
X-Microsoft-Antispam: UriScan:;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:;SRVR:DM2PR03MB350;
X-Forefront-PRVS: 0345CFD558
X-Forefront-Antispam-Report: SFV:NSPM;SFS:(10019020)(6009001)(199003)(24454002)(189002)(51704005)(110136001)(66066001)(80022003)(74502003)(101416001)(50466002)(105586002)(85852003)(97736003)(102836001)(107046002)(77982003)(46102003)(97756001)(47776003)(81542003)(90102001)(85306004)(106356001)(23726002)(74662003)(76176999)(77096002)(92566001)(83322001)(83072002)(4396001)(64706001)(20776003)(46406003)(19580395003)(31966008)(79102003)(42186005)(87976001)(120916001)(81342003)(10300001)(83506001)(95666004)(19580405001)(99396003)(21056001)(33716001)(54356999)(86362001)(76482002)(92726001)(50986999)(33656002)(2004002);DIR:OUT;SFP:1102;SCL:1;SRVR:DM2PR03MB350;H:dragon;FPR:;MLV:sfv;PTR:InfoNoRecords;A:1;MX:1;LANG:en;
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 23, 2014 at 08:44:35PM +0800, Xiubo Li wrote:
> A given application may not use all the peripherals on the device.
> In this case, it may be desirable to disable unused peripherals.
> DCFG provides a mechanism for gating clocks to IP blocks that are
> not used when running an application.
> 
> Signed-off-by: Xiubo Li <Li.Xiubo@freescale.com>
> ---
> 
> Change in V3:
> - Follow's Uwe Kleine-K?nig advices.
> 
> 
>  .../devicetree/bindings/clock/ls1021a-clock.txt    |  33 ++++
>  arch/arm/mach-imx/Makefile                         |   2 +
>  arch/arm/mach-imx/clk-ls1021a.c                    | 200 +++++++++++++++++++++
>  arch/arm/mach-imx/clk.h                            |   8 +
>  include/dt-bindings/clock/ls1021a-clock.h          |  55 ++++++
>  5 files changed, 298 insertions(+)
>  create mode 100644 Documentation/devicetree/bindings/clock/ls1021a-clock.txt
>  create mode 100644 arch/arm/mach-imx/clk-ls1021a.c
>  create mode 100644 include/dt-bindings/clock/ls1021a-clock.h
> 
> diff --git a/Documentation/devicetree/bindings/clock/ls1021a-clock.txt b/Documentation/devicetree/bindings/clock/ls1021a-clock.txt
> new file mode 100644
> index 0000000..950e8d0
> --- /dev/null
> +++ b/Documentation/devicetree/bindings/clock/ls1021a-clock.txt
> @@ -0,0 +1,33 @@
> +Gating clock bindings for Freescale LS1021A SOC
> +
> +Required properties:
> +- compatible:		Should be "fsl,ls1021a-gate"
> +- reg:			Address and length of the register set
> +- #clock-cells:		Should be <1>
> +
> +Optional property:
> +- big-endian:		If present the gate clock base registers are
> +			implemented in big endian mode, otherwise in
> +			little mode.

Do you have a real world example that has the block work in little
endian?  Otherwise, I suggest we make big-endian the default and save
the property for now.

> +
> +The clock consumers should specify the desired clock by having one clock
> +ID in its "clocks" phandle cell.
> +Please see include/dt-bindings/clock/ls1021a-clock.h for the full list of
> +LS1021A clock IDs.
> +
> +Example:
> +
> +gate: gate@1ee0000 {
> +	compatible = "fsl,ls1021a-gate";
> +	reg = <0x0 0x1ee0000 0x0 0x10000>;
> +	#clock-cells = <1>;
> +	big-endian;
> +};
> +
> +wdog0: wdog@2ad0000 {
> +	compatible = "fsl,ls1021a-wdt", "fsl,imx21-wdt";
> +	reg = <0x0 0x2ad0000 0x0 0x10000>;
> +	interrupts = <GIC_SPI 115 IRQ_TYPE_LEVEL_HIGH>;
> +	clocks = <&gate LS1021A_CLK_WDOG12_EN>;
> +	clock-names = "wdog12_en";
> +};
> diff --git a/arch/arm/mach-imx/Makefile b/arch/arm/mach-imx/Makefile
> index 6e4fcd8..f6a1544 100644
> --- a/arch/arm/mach-imx/Makefile
> +++ b/arch/arm/mach-imx/Makefile
> @@ -110,4 +110,6 @@ obj-$(CONFIG_SOC_IMX53) += mach-imx53.o
>  
>  obj-$(CONFIG_SOC_VF610) += clk-vf610.o mach-vf610.o
>  
> +obj-$(CONFIG_SOC_LS1021A) += clk-ls1021a.o
> +
>  obj-y += devices/
> diff --git a/arch/arm/mach-imx/clk-ls1021a.c b/arch/arm/mach-imx/clk-ls1021a.c
> new file mode 100644
> index 0000000..568b592
> --- /dev/null
> +++ b/arch/arm/mach-imx/clk-ls1021a.c
> @@ -0,0 +1,200 @@
> +/*
> + * Copyright 2014 Freescale Semiconductor, Inc.
> + *
> + * This program is free software; you can redistribute it and/or modify
> + * it under the terms of the GNU General Public License as published by
> + * the Free Software Foundation; either version 2 of the License, or
> + * (at your option) any later version.
> + */
> +
> +#include <linux/clk.h>
> +#include <linux/mfd/syscon.h>
> +#include <linux/of_address.h>
> +#include <linux/slab.h>
> +#include <dt-bindings/clock/ls1021a-clock.h>
> +
> +#include "clk.h"
> +
> +/* The DCFG registers are in big endian mode on LS1021A SoC */
> +static u8 ls1021a_clk_shift_none(u8 shift)
> +{
> +	return shift;
> +}
> +
> +static u8 ls1021a_clk_shift_be(u8 shift)
> +{
> +	u8 m, n;
> +
> +	m = shift / 8;
> +	n = shift % 8;
> +
> +	return (u8)((3 - m) * 8 + n);
> +}
> +
> +static u8 (*ls1021a_clk_shift)(u8 shift) = ls1021a_clk_shift_none;
> +
> +static void __init ls1021a_clocks_init(struct device_node *np)
> +{
> +	struct clk_onecell_data *clk_data;
> +	struct clk **clks;
> +	void __iomem *dcfg_base;
> +	int i;
> +
> +#define DCFG_CCSR_DEVDISR1	(dcfg_base + 0x70)
> +#define DCFG_CCSR_DEVDISR2	(dcfg_base + 0x74)
> +#define DCFG_CCSR_DEVDISR3	(dcfg_base + 0x78)
> +#define DCFG_CCSR_DEVDISR4	(dcfg_base + 0x7c)
> +#define DCFG_CCSR_DEVDISR5	(dcfg_base + 0x80)
> +#define DCFG_CCSR_RSTRQMR1	(dcfg_base + 0xc0)
> +
> +	clk_data = kzalloc(sizeof(struct clk_onecell_data), GFP_KERNEL);
> +	clks = kcalloc(LS1021A_CLK_END, sizeof(struct clk *), GFP_KERNEL);

As I replied to v2, I do not think the dynamic allocation is really
necessary for this driver.

> +
> +	BUG_ON(!clk_data || !clks);
> +
> +	dcfg_base = of_iomap(np, 0);
> +
> +	BUG_ON(!dcfg_base);
> +
> +	if (of_property_read_bool(np, "big-endian"))
> +		ls1021a_clk_shift = ls1021a_clk_shift_be;

Suggest to make this default and save the property for now.

> +
> +	clks[LS1021A_CLK_PBL_EN] = ls1021a_clk_gate("pbl_en", "dummy",

So the parent of all these gate clocks are "dummy".  Does it mean that
the clock tree on LS1021A consists of only gate clocks? No dividers
or multiplexers?

> +						DCFG_CCSR_DEVDISR1,
> +						ls1021a_clk_shift(0));

I think we can ignore the 80 columns warning and put these on one line
to make the code a bit easier to read.

> +	clks[LS1021A_CLK_ESDHC_EN] = ls1021a_clk_gate("esdhc_en", "dummy",
> +						DCFG_CCSR_DEVDISR1,
> +						ls1021a_clk_shift(2));
> +	clks[LS1021A_CLK_DMA1_EN] = ls1021a_clk_gate("dma1_en", "dummy",
> +						DCFG_CCSR_DEVDISR1,
> +						ls1021a_clk_shift(8));
> +	clks[LS1021A_CLK_DMA2_EN] = ls1021a_clk_gate("dma2_en", "dummy",
> +						DCFG_CCSR_DEVDISR1,
> +						ls1021a_clk_shift(9));
> +	clks[LS1021A_CLK_USB3_PHY_EN] = ls1021a_clk_gate("usb3_phy_en", "dummy",
> +						DCFG_CCSR_DEVDISR1,
> +						ls1021a_clk_shift(12));
> +	clks[LS1021A_CLK_USB2_EN] = ls1021a_clk_gate("usb2_en", "dummy",
> +						DCFG_CCSR_DEVDISR1,
> +						ls1021a_clk_shift(13));
> +	clks[LS1021A_CLK_SATA_EN] = ls1021a_clk_gate("sata_en", "dummy",
> +						DCFG_CCSR_DEVDISR1,
> +						ls1021a_clk_shift(16));
> +	clks[LS1021A_CLK_USB3_EN] = ls1021a_clk_gate("usb3_en", "dummy",
> +						DCFG_CCSR_DEVDISR1,
> +						ls1021a_clk_shift(17));
> +	clks[LS1021A_CLK_SEC_EN] = ls1021a_clk_gate("sec_en", "dummy",
> +						DCFG_CCSR_DEVDISR1,
> +						ls1021a_clk_shift(22));
> +	clks[LS1021A_CLK_2D_ACE_EN] = ls1021a_clk_gate("2d_ace_en", "dummy",
> +						DCFG_CCSR_DEVDISR1,
> +						ls1021a_clk_shift(30));
> +	clks[LS1021A_CLK_QE_EN] = ls1021a_clk_gate("qe_en", "dummy",
> +						DCFG_CCSR_DEVDISR1,
> +						ls1021a_clk_shift(31));
> +
> +	clks[LS1021A_CLK_ETSEC1_EN] = ls1021a_clk_gate("etsec1_en", "dummy",
> +						DCFG_CCSR_DEVDISR2,
> +						ls1021a_clk_shift(0));
> +	clks[LS1021A_CLK_ETSEC2_EN] = ls1021a_clk_gate("etsec2_en", "dummy",
> +						DCFG_CCSR_DEVDISR2,
> +						ls1021a_clk_shift(1));
> +	clks[LS1021A_CLK_ETSEC3_EN] = ls1021a_clk_gate("etsec3_en", "dummy",
> +						DCFG_CCSR_DEVDISR2,
> +						ls1021a_clk_shift(2));
> +
> +	clks[LS1021A_CLK_PEX1_EN] = ls1021a_clk_gate("pex1_en", "dummy",
> +						DCFG_CCSR_DEVDISR3,
> +						ls1021a_clk_shift(0));
> +	clks[LS1021A_CLK_PEX2_EN] = ls1021a_clk_gate("pex2_en", "dummy",
> +						DCFG_CCSR_DEVDISR3,
> +						ls1021a_clk_shift(1));
> +
> +	clks[LS1021A_CLK_DUART1_EN] = ls1021a_clk_gate("duart1_en", "dummy",
> +						DCFG_CCSR_DEVDISR4,
> +						ls1021a_clk_shift(2));
> +	clks[LS1021A_CLK_DUART2_EN] = ls1021a_clk_gate("duart2_en", "dummy",
> +						DCFG_CCSR_DEVDISR4,
> +						ls1021a_clk_shift(3));
> +	clks[LS1021A_CLK_QSPI_EN] = ls1021a_clk_gate("qspi_en", "dummy",
> +						DCFG_CCSR_DEVDISR4,
> +						ls1021a_clk_shift(4));
> +
> +	clks[LS1021A_CLK_DDR_EN] = ls1021a_clk_gate("ddr_en", "dummy",
> +						DCFG_CCSR_DEVDISR5,
> +						ls1021a_clk_shift(0));
> +	clks[LS1021A_CLK_OCRAM1_EN] = ls1021a_clk_gate("ocram1_en", "dummy",
> +						DCFG_CCSR_DEVDISR5,
> +						ls1021a_clk_shift(4));
> +	clks[LS1021A_CLK_IFC_EN] = ls1021a_clk_gate("ifc_en", "dummy",
> +						DCFG_CCSR_DEVDISR5,
> +						ls1021a_clk_shift(8));
> +	clks[LS1021A_CLK_GPIO_EN] = ls1021a_clk_gate("gpio_en", "dummy",
> +						DCFG_CCSR_DEVDISR5,
> +						ls1021a_clk_shift(9));
> +	clks[LS1021A_CLK_DBG_EN] = ls1021a_clk_gate("dbg_en", "dummy",
> +						DCFG_CCSR_DEVDISR5,
> +						ls1021a_clk_shift(10));
> +	clks[LS1021A_CLK_FLEXCAN1_EN] = ls1021a_clk_gate("flexcan1_en", "dummy",
> +						DCFG_CCSR_DEVDISR5,
> +						ls1021a_clk_shift(12));
> +	clks[LS1021A_CLK_FLEXCAN234_EN] = ls1021a_clk_gate("flexcan234_en",
> +						"dummy", DCFG_CCSR_DEVDISR5,
> +						ls1021a_clk_shift(13));
> +	/* For flextimer 2/3/4/5/6/7/8 */
> +	clks[LS1021A_CLK_FLEXTIMER_EN] = ls1021a_clk_gate("flextimer_en",
> +						"dummy", DCFG_CCSR_DEVDISR5,
> +						ls1021a_clk_shift(14));
> +	clks[LS1021A_CLK_SECMON_EN] = ls1021a_clk_gate("secmon_en", "dummy",
> +						DCFG_CCSR_DEVDISR5,
> +						ls1021a_clk_shift(17));
> +	clks[LS1021A_CLK_WDOG_EN] = ls1021a_clk_gate("wdog_en", "dummy",
> +						DCFG_CCSR_RSTRQMR1,
> +						ls1021a_clk_shift(22));
> +	clks[LS1021A_CLK_WDOG12_EN] = ls1021a_clk_gate("wdog12_en", "wdog_en",
> +						DCFG_CCSR_DEVDISR5,
> +						ls1021a_clk_shift(21));
> +	clks[LS1021A_CLK_I2C23_EN] = ls1021a_clk_gate("i2c23_en", "dummy",
> +						DCFG_CCSR_DEVDISR5,
> +						ls1021a_clk_shift(22));
> +	/* For SAI 1/2/3/4 */
> +	clks[LS1021A_CLK_SAI_EN] = ls1021a_clk_gate("sai_en", "dummy",
> +						DCFG_CCSR_DEVDISR5,
> +						ls1021a_clk_shift(23));
> +	/* For lpuart 2/3/4/5/6  */
> +	clks[LS1021A_CLK_LPUART_EN] = ls1021a_clk_gate("lpuart_en", "dummy",
> +						DCFG_CCSR_DEVDISR5,
> +						ls1021a_clk_shift(24));
> +	clks[LS1021A_CLK_DSPI12_EN] = ls1021a_clk_gate("dspi12_en", "dummy",
> +						DCFG_CCSR_DEVDISR5,
> +						ls1021a_clk_shift(25));
> +	clks[LS1021A_CLK_ASRC_EN] = ls1021a_clk_gate("asrc_en", "dummy",
> +						DCFG_CCSR_DEVDISR5,
> +						ls1021a_clk_shift(26));
> +	clks[LS1021A_CLK_SPDIF_EN] = ls1021a_clk_gate("spdif_en", "dummy",
> +						DCFG_CCSR_DEVDISR5,
> +						ls1021a_clk_shift(27));
> +	clks[LS1021A_CLK_I2C1_EN] = ls1021a_clk_gate("i2c1_en", "dummy",
> +						DCFG_CCSR_DEVDISR5,
> +						ls1021a_clk_shift(29));
> +	clks[LS1021A_CLK_LPUART1_EN] = ls1021a_clk_gate("lpuart1_en", "dummy",
> +						DCFG_CCSR_DEVDISR5,
> +						ls1021a_clk_shift(30));
> +	clks[LS1021A_CLK_FLEXTIMER1_EN] = ls1021a_clk_gate("flextimer1_en",
> +						"dummy", DCFG_CCSR_DEVDISR5,
> +						ls1021a_clk_shift(31));

So "dummy" and ls1021a_clk_shift() are two common things for every
single call of ls1021a_clk_gate().  Can we handle them in
ls1021a_clk_gate() wrapper, so that we can make these calls a bit
shorter?

> +
> +	for (i = 0; i < LS1021A_CLK_END; i++) {
> +		if (IS_ERR(clks[i])) {
> +			pr_err("LS1021A clk %d: register failed with %ld\n",
> +			       i, PTR_ERR(clks[i]));
> +			BUG();
> +		}
> +	}
> +
> +	/* Add the clocks to provider list */
> +	clk_data->clks = clks;
> +	clk_data->clk_num = LS1021A_CLK_END;
> +	of_clk_add_provider(np, of_clk_src_onecell_get, clk_data);
> +}
> +CLK_OF_DECLARE(ls1021a, "fsl,ls1021a-gate", ls1021a_clocks_init);
> diff --git a/arch/arm/mach-imx/clk.h b/arch/arm/mach-imx/clk.h
> index 4cdf8b6..cfbae8c 100644
> --- a/arch/arm/mach-imx/clk.h
> +++ b/arch/arm/mach-imx/clk.h
> @@ -107,6 +107,14 @@ static inline struct clk *imx_clk_gate_dis(const char *name, const char *parent,
>  			shift, CLK_GATE_SET_TO_DISABLE, &imx_ccm_lock);
>  }
>  
> +static inline struct clk *ls1021a_clk_gate(const char *name, const char *parent,
> +		void __iomem *reg, u8 shift)
> +{
> +	return clk_register_gate(NULL, name, parent, CLK_SET_RATE_PARENT |

As the parent of the clocks registered by this function is "dummy" from
what I see, what is the point of setting flag CLK_SET_RATE_PARENT then?

> +			CLK_IGNORE_UNUSED, reg,	shift,

Why flag CLK_IGNORE_UNUSED?

Shawn

> +			CLK_GATE_SET_TO_DISABLE, &imx_ccm_lock);
> +}
> +
>  static inline struct clk *imx_clk_mux(const char *name, void __iomem *reg,
>  		u8 shift, u8 width, const char **parents, int num_parents)
>  {
> diff --git a/include/dt-bindings/clock/ls1021a-clock.h b/include/dt-bindings/clock/ls1021a-clock.h
> new file mode 100644
> index 0000000..09b47d7
> --- /dev/null
> +++ b/include/dt-bindings/clock/ls1021a-clock.h
> @@ -0,0 +1,55 @@
> +/*
> + * Copyright 2014 Freescale Semiconductor, Inc.
> + *
> + * This program is free software; you can redistribute it and/or modify
> + * it under the terms of the GNU General Public License as published by
> + * the Free Software Foundation; either version 2 of the License, or
> + * (at your option) any later version.
> + */
> +
> +#ifndef __DT_BINDINGS_CLOCK_LS1021A_H
> +#define __DT_BINDINGS_CLOCK_LS1021A_H
> +
> +#define LS1021A_CLK_DUMMY	0
> +#define LS1021A_CLK_PBL_EN	1
> +#define LS1021A_CLK_ESDHC_EN	2
> +#define LS1021A_CLK_DMA1_EN	3
> +#define LS1021A_CLK_DMA2_EN	4
> +#define LS1021A_CLK_USB3_PHY_EN	5
> +#define LS1021A_CLK_USB2_EN	6
> +#define LS1021A_CLK_SATA_EN	7
> +#define LS1021A_CLK_USB3_EN	8
> +#define LS1021A_CLK_SEC_EN	9
> +#define LS1021A_CLK_2D_ACE_EN	10
> +#define LS1021A_CLK_QE_EN	11
> +#define LS1021A_CLK_ETSEC1_EN	12
> +#define LS1021A_CLK_ETSEC2_EN	13
> +#define LS1021A_CLK_ETSEC3_EN	14
> +#define LS1021A_CLK_PEX1_EN	15
> +#define LS1021A_CLK_PEX2_EN	16
> +#define LS1021A_CLK_DUART1_EN	17
> +#define LS1021A_CLK_DUART2_EN	18
> +#define LS1021A_CLK_QSPI_EN	19
> +#define LS1021A_CLK_DDR_EN	20
> +#define LS1021A_CLK_OCRAM1_EN	21
> +#define LS1021A_CLK_IFC_EN	22
> +#define LS1021A_CLK_GPIO_EN	23
> +#define LS1021A_CLK_DBG_EN	24
> +#define LS1021A_CLK_FLEXCAN1_EN	25
> +#define LS1021A_CLK_FLEXCAN234_EN	26
> +#define LS1021A_CLK_FLEXTIMER_EN	27
> +#define LS1021A_CLK_SECMON_EN	28
> +#define LS1021A_CLK_WDOG_EN	29
> +#define LS1021A_CLK_WDOG12_EN	30
> +#define LS1021A_CLK_I2C23_EN	31
> +#define LS1021A_CLK_SAI_EN	32
> +#define LS1021A_CLK_LPUART_EN	33
> +#define LS1021A_CLK_DSPI12_EN	34
> +#define LS1021A_CLK_ASRC_EN	35
> +#define LS1021A_CLK_SPDIF_EN	36
> +#define LS1021A_CLK_I2C1_EN	37
> +#define LS1021A_CLK_LPUART1_EN	38
> +#define LS1021A_CLK_FLEXTIMER1_EN	39
> +#define LS1021A_CLK_END		40
> +
> +#endif /* __DT_BINDINGS_CLOCK_LS1021A_H */
> -- 
> 2.1.0.27.g96db324
> 
