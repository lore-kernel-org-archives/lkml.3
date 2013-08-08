Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758057Ab3HHRC2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Aug 2013 13:02:28 -0400
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:35211 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752896Ab3HHRC1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Aug 2013 13:02:27 -0400
Date: Thu, 8 Aug 2013 18:02:00 +0100
From: Mark Rutland <mark.rutland@arm.com>
To: Stephen Boyd <sboyd@codeaurora.org>
Cc: Mike Turquette <mturquette@linaro.org>,
        "linux-arm-msm@vger.kernel.org" <linux-arm-msm@vger.kernel.org>,
        Saravana Kannan <skannan@codeaurora.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>
Subject: Re: [PATCH v1 10/14] clk: msm: Add support for MSM8960's
 multimedia clock controller (MMCC)
Message-ID: <20130808170200.GF27325@e106331-lin.cambridge.arm.com>
References: <1374713022-6049-1-git-send-email-sboyd@codeaurora.org>
 <1374713022-6049-11-git-send-email-sboyd@codeaurora.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1374713022-6049-11-git-send-email-sboyd@codeaurora.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Stephen,

On Thu, Jul 25, 2013 at 01:43:38AM +0100, Stephen Boyd wrote:
> Fill in the data and wire up the multimedia clock controller to
> the MSM clock driver. This should allow multimedia device drivers
> to control their clocks on 8960 based platforms.
> 
> Cc: devicetree@vger.kernel.org
> Signed-off-by: Stephen Boyd <sboyd@codeaurora.org>
> ---
>  .../devicetree/bindings/clock/qcom,mmcc.txt        |  38 ++++++
>  drivers/clk/msm/Kconfig                            |   8 ++
>  drivers/clk/msm/Makefile                           |   1 +
>  drivers/clk/msm/core.c                             |   3 +
>  drivers/clk/msm/internal.h                         |   1 +
>  drivers/clk/msm/mmcc-8960.c                        | 142 +++++++++++++++++++++
>  6 files changed, 193 insertions(+)
>  create mode 100644 Documentation/devicetree/bindings/clock/qcom,mmcc.txt
>  create mode 100644 drivers/clk/msm/mmcc-8960.c
> 
> diff --git a/Documentation/devicetree/bindings/clock/qcom,mmcc.txt b/Documentation/devicetree/bindings/clock/qcom,mmcc.txt
> new file mode 100644
> index 0000000..e06577e
> --- /dev/null
> +++ b/Documentation/devicetree/bindings/clock/qcom,mmcc.txt
> @@ -0,0 +1,38 @@
> +MSM Multimedia Clock Controller Binding
> +-----------------------------------------
> +
> +Required properties :
> +- compatible : shall contain at least "qcom,mmcc" and only one of the
> +	       following:
> +
> +			"qcom,mmcc-8660"
> +			"qcom,mmcc-8960"
> +
> +- reg : shall contain base register location and length
> +- clocks : shall contain clocks supplied by the clock controller
> +
> +Example:
> +	clock-controller@4000000 {
> +		compatible = "qcom,mmcc-8960", "qcom,mmcc";
> +		reg = <0x4000000 0x1000>;
> +
> +		clocks {
> +			pll2: pll2 {
> +				#clock-cells = <0>;
> +				compatible = "qcom,pll";
> +				clocks = <&pxo>;
> +			};
> +
> +			mdp_rcg: mdp_rcg {
> +				#clock-cells = <0>;
> +				compatible = "qcom,mn8-dyn-clock";
> +				clocks = <&pxo>, <&pll2>, <&vpll8>;
> +			};
> +
> +			mdp_cxc: mdp_cxc {
> +				#clock-cells = <0>;
> +				compatible = "qcom,cxc-clock";
> +				clocks = <&mdp_rcg>;
> +			};
> +		};
> +	};

Similar to my comments on the previous patch, this seems odd to me.
There's either not enough information in the binding, or there's not
enough in the documentation.

Thanks,
Mark.

> diff --git a/drivers/clk/msm/Kconfig b/drivers/clk/msm/Kconfig
> index 3eaffb6..6147380 100644
> --- a/drivers/clk/msm/Kconfig
> +++ b/drivers/clk/msm/Kconfig
> @@ -11,4 +11,12 @@ config MSM_GCC_8960
>  	  Say Y if you want to use peripheral devices such as UART, SPI,
>  	  i2c, USB, SD/eMMC, SATA, PCIe, etc.
>  
> +config MSM_MMCC_8960
> +	bool "MSM8960 Multimedia Clock Controller"
> +	select MSM_GCC_8960
> +	help
> +	  Support for the multimedia clock controller on msm8960 devices.
> +	  Say Y if you want to support multimedia devices such as display,
> +	  graphics, video encode/decode, camera, etc.
> +
>  endif
> diff --git a/drivers/clk/msm/Makefile b/drivers/clk/msm/Makefile
> index c785943..ae199f5 100644
> --- a/drivers/clk/msm/Makefile
> +++ b/drivers/clk/msm/Makefile
> @@ -8,3 +8,4 @@ clk-msm-$(CONFIG_COMMON_CLK_MSM) += clk-branch.o
>  clk-msm-$(CONFIG_COMMON_CLK_MSM) += core.o
>  
>  clk-msm-$(CONFIG_MSM_GCC_8960) += gcc-8960.o
> +clk-msm-$(CONFIG_MSM_MMCC_8960) += mmcc-8960.o
> diff --git a/drivers/clk/msm/core.c b/drivers/clk/msm/core.c
> index b8e702b..4e8b8d0 100644
> --- a/drivers/clk/msm/core.c
> +++ b/drivers/clk/msm/core.c
> @@ -176,6 +176,9 @@ static const struct of_device_id msm_cc_match_table[] = {
>  #ifdef CONFIG_MSM_GCC_8960
>  	{ .compatible = "qcom,gcc-8960", .data = &msm_gcc_8960_matches },
>  #endif
> +#ifdef CONFIG_MSM_MMCC_8960
> +	{ .compatible = "qcom,mmcc-8960", .data = &msm_mmcc_8960_matches },
> +#endif
>  	{ }
>  };
>  MODULE_DEVICE_TABLE(of, msm_cc_match_table);
> diff --git a/drivers/clk/msm/internal.h b/drivers/clk/msm/internal.h
> index b0ffda7..45435a8 100644
> --- a/drivers/clk/msm/internal.h
> +++ b/drivers/clk/msm/internal.h
> @@ -22,5 +22,6 @@ struct msm_clk_match {
>  };
>  
>  extern const struct msm_clk_match msm_gcc_8960_matches;
> +extern const struct msm_clk_match msm_mmcc_8960_matches;
>  
>  #endif
> diff --git a/drivers/clk/msm/mmcc-8960.c b/drivers/clk/msm/mmcc-8960.c
> new file mode 100644
> index 0000000..e7b7867
> --- /dev/null
> +++ b/drivers/clk/msm/mmcc-8960.c
> @@ -0,0 +1,142 @@
> +/*
> + * Copyright (c) 2013, The Linux Foundation. All rights reserved.
> + *
> + * This software is licensed under the terms of the GNU General Public
> + * License version 2, as published by the Free Software Foundation, and
> + * may be copied, distributed, and modified under those terms.
> + *
> + * This program is distributed in the hope that it will be useful,
> + * but WITHOUT ANY WARRANTY; without even the implied warranty of
> + * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> + * GNU General Public License for more details.
> + */
> +
> +#include <linux/clk-provider.h>
> +
> +#include "internal.h"
> +#include "clk-pll.h"
> +#include "clk-rcg.h"
> +#include "clk-branch.h"
> +
> +static struct pll_desc pll2_desc = {
> +	.l_reg = 0x320,
> +	.m_reg = 0x324,
> +	.n_reg = 0x328,
> +	.config_reg = 0x32c,
> +	.mode_reg = 0x31c,
> +	.status_reg = 0x334,
> +	.status_bit = 16,
> +};
> +
> +#define PXO	0
> +#define PLL2	1
> +#define PLL8	2
> +
> +static u8 mmcc_pxo_pll2_pll8_map[] = {
> +	[PXO]	= 0,
> +	[PLL2]	= 1,
> +	[PLL8]	= 2,
> +};
> +
> +static struct freq_tbl clk_tbl_mdp[] = {
> +	{   9600000, PLL8, 0, 1, 40 },
> +	{  13710000, PLL8, 0, 1, 28 },
> +	{  27000000, PXO,  0, 0,  0 },
> +	{  29540000, PLL8, 0, 1, 13 },
> +	{  34910000, PLL8, 0, 1, 11 },
> +	{  38400000, PLL8, 0, 1, 10 },
> +	{  59080000, PLL8, 0, 2, 13 },
> +	{  76800000, PLL8, 0, 1,  5 },
> +	{  85330000, PLL8, 0, 2,  9 },
> +	{  96000000, PLL8, 0, 1,  4 },
> +	{ 128000000, PLL8, 0, 1,  3 },
> +	{ 160000000, PLL2, 0, 1,  5 },
> +	{ 177780000, PLL2, 0, 2,  9 },
> +	{ 200000000, PLL2, 0, 1,  4 },
> +	{ 228571000, PLL2, 0, 2,  7 },
> +	{ 266667000, PLL2, 0, 1,  3 },
> +	{ }
> +};
> +
> +static struct rcg_dyn_desc mdp_rcg = {
> +	.ctl_reg = 0xc0,
> +	.ns_reg = 0xd0,
> +	.md0_reg = 0xc4,
> +	.md1_reg = 0xc8,
> +	.ctl_bit = 2,
> +	.mnctr0_en_bit = 8,
> +	.mnctr1_en_bit = 5,
> +	.mnctr0_reset_bit = 31,
> +	.mnctr1_reset_bit = 30,
> +	.mnctr0_mode_shift = 9,
> +	.mnctr1_mode_shift = 6,
> +	.src0_sel_shift = 3,
> +	.src1_sel_shift = 0,
> +	.n0_val_shift = 22,
> +	.n1_val_shift = 14,
> +	.m0_val_shift = 8,
> +	.m1_val_shift = 8,
> +	.mux_sel_bit = 11,
> +	.parent_map = mmcc_pxo_pll2_pll8_map,
> +	.freq_tbl = clk_tbl_mdp,
> +};
> +
> +static struct branch_desc mdp_cxc = {
> +	.ctl_reg = 0xc0,
> +	.halt_reg = 0x1d0,
> +	.ctl_bit = 0,
> +	.halt_bit = 10,
> +	.halt_check = BRANCH_HALT,
> +};
> +
> +static struct freq_tbl clk_tbl_rot[] = {
> +	{  27000000, PXO,   1 },
> +	{  29540000, PLL8, 13 },
> +	{  32000000, PLL8, 12 },
> +	{  38400000, PLL8, 10 },
> +	{  48000000, PLL8,  8 },
> +	{  54860000, PLL8,  7 },
> +	{  64000000, PLL8,  6 },
> +	{  76800000, PLL8,  5 },
> +	{  96000000, PLL8,  4 },
> +	{ 100000000, PLL2,  8 },
> +	{ 114290000, PLL2,  7 },
> +	{ 133330000, PLL2,  6 },
> +	{ 160000000, PLL2,  5 },
> +	{ 200000000, PLL2,  4 },
> +	{ }
> +};
> +
> +static struct rcg_dyn_desc rot_rcg = {
> +	.ctl_reg = 0xe0,
> +	.ns_reg = 0xe8,
> +	.ctl_bit = 2,
> +	.pre_div0_shift = 22,
> +	.pre_div1_shift = 26,
> +	.src0_sel_shift = 16,
> +	.src1_sel_shift = 19,
> +	.mux_sel_bit = 30,
> +	.parent_map = mmcc_pxo_pll2_pll8_map,
> +	.freq_tbl = clk_tbl_rot,
> +};
> +
> +static struct branch_desc rot_cxc = {
> +	.ctl_reg = 0xe0,
> +	.halt_reg = 0x1d0,
> +	.ctl_bit = 0,
> +	.halt_bit = 15,
> +	.halt_check = BRANCH_HALT,
> +};
> +
> +static struct of_clk_match msm_mmcc_clk_match[] = {
> +	{ .name = "pll2", .driver_data = &pll2_desc },
> +	{ .name = "mdp_rcg", .driver_data = &mdp_rcg },
> +	{ .name = "mdp_cxc", .driver_data = &mdp_cxc },
> +	{ .name = "rot_rcg", .driver_data = &rot_rcg },
> +	{ .name = "rot_cxc", .driver_data = &rot_cxc },
> +};
> +
> +const struct msm_clk_match msm_mmcc_8960_matches = {
> +	.matches = msm_mmcc_clk_match,
> +	.size = ARRAY_SIZE(msm_mmcc_clk_match)
> +};
> -- 
> The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum,
> hosted by The Linux Foundation
> 
> 
> _______________________________________________
> linux-arm-kernel mailing list
> linux-arm-kernel@lists.infradead.org
> http://lists.infradead.org/mailman/listinfo/linux-arm-kernel
> 
