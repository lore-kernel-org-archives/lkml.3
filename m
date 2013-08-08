Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758053Ab3HHRAs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Aug 2013 13:00:48 -0400
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:35180 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757864Ab3HHRAq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Aug 2013 13:00:46 -0400
Date: Thu, 8 Aug 2013 18:00:15 +0100
From: Mark Rutland <mark.rutland@arm.com>
To: Stephen Boyd <sboyd@codeaurora.org>
Cc: Mike Turquette <mturquette@linaro.org>,
        "linux-arm-msm@vger.kernel.org" <linux-arm-msm@vger.kernel.org>,
        Saravana Kannan <skannan@codeaurora.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>
Subject: Re: [PATCH v1 09/14] clk: msm: Add support for MSM8960's global
 clock controller (GCC)
Message-ID: <20130808170015.GE27325@e106331-lin.cambridge.arm.com>
References: <1374713022-6049-1-git-send-email-sboyd@codeaurora.org>
 <1374713022-6049-10-git-send-email-sboyd@codeaurora.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1374713022-6049-10-git-send-email-sboyd@codeaurora.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Stephen,

On Thu, Jul 25, 2013 at 01:43:37AM +0100, Stephen Boyd wrote:
> Fill in the data and wire up the global clock controller to the
> MSM clock driver. This should allow most non-multimedia device
> drivers to control their clocks on 8960 based platforms.
> 
> Cc: devicetree@vger.kernel.org
> Signed-off-by: Stephen Boyd <sboyd@codeaurora.org>
> ---
>  .../devicetree/bindings/clock/qcom,gcc.txt         |  55 +++++++
>  drivers/clk/msm/Kconfig                            |  10 ++
>  drivers/clk/msm/Makefile                           |   2 +
>  drivers/clk/msm/core.c                             |   3 +
>  drivers/clk/msm/gcc-8960.c                         | 174 +++++++++++++++++++++
>  drivers/clk/msm/internal.h                         |   2 +
>  6 files changed, 246 insertions(+)
>  create mode 100644 Documentation/devicetree/bindings/clock/qcom,gcc.txt
>  create mode 100644 drivers/clk/msm/gcc-8960.c
> 
> diff --git a/Documentation/devicetree/bindings/clock/qcom,gcc.txt b/Documentation/devicetree/bindings/clock/qcom,gcc.txt
> new file mode 100644
> index 0000000..2311e1a
> --- /dev/null
> +++ b/Documentation/devicetree/bindings/clock/qcom,gcc.txt
> @@ -0,0 +1,55 @@
> +MSM Global Clock Controller Binding
> +-----------------------------------
> +
> +Required properties :
> +- compatible : shall contain at least "qcom,gcc" and only one of the
> +              following:
> +
> +                       "qcom,gcc-8660"
> +                       "qcom,gcc-8960"
> +
> +- reg : shall contain base register location and length
> +- clocks : shall contain clocks supplied by the clock controller
> +
> +Example:
> +       clock-controller@900000 {
> +               compatible = "qcom,gcc-8960", "qcom,gcc";
> +               reg = <0x900000 0x4000>;
> +
> +               clocks {
> +                       pxo: pxo {
> +                               #clock-cells = <0>;
> +                               compatible = "fixed-clock";
> +                               clock-frequency = <27000000>;
> +                       };
> +
> +                       pll8: pll8 {
> +                               #clock-cells = <0>;
> +                               compatible = "qcom,pll";
> +                               clocks = <&pxo>;
> +                       };
> +
> +                       vpll8: vpll8 {
> +                               #clock-cells = <0>;
> +                               compatible = "qcom,pll-vote";
> +                               clocks = <&pll8>;
> +                       };
> +
> +                       gsbi5_uart_rcg: gsbi5_uart_rcg {
> +                               #clock-cells = <0>;
> +                               compatible = "qcom,p2-mn16-clock";
> +                               clocks = <&pxo>, <&vpll8>;
> +                       };
> +
> +                       gsbi5_uart_clk: gsbi5_uart_cxc {
> +                               #clock-cells = <0>;
> +                               compatible = "qcom,cxc-clock";
> +                               clocks = <&gsbi5_uart_rcg>;
> +                       };
> +
> +                       gsbi5_uart_ahb: gsbi5_uart_ahb {
> +                               #clock-cells = <0>;
> +                               compatible = "qcom,cxc-hg-clock";
> +                       };
> +               };
> +       };

I'm slightly confused by this. How is each of the clocks described in
the clocks node related to a portion of the register set?

If the set of clocks is fixed, surely the gcc node gives you enough
information alone, and the whole block can be modelled as a single
provider of multiple clock outputs, or it's not fixed, and some linkage
needs to be defined?

The code seems to imply the former, unless only a subset of clocks may
be present? In that case, the set of clocks which might be present
should be described in the binding.

Thanks,
Mark.

> diff --git a/drivers/clk/msm/Kconfig b/drivers/clk/msm/Kconfig
> index bf7e3d2..3eaffb6 100644
> --- a/drivers/clk/msm/Kconfig
> +++ b/drivers/clk/msm/Kconfig
> @@ -2,3 +2,13 @@ menuconfig COMMON_CLK_MSM
>         tristate "Support for Qualcomm's MSM designs"
>         depends on OF
> 
> +if COMMON_CLK_MSM
> +
> +config MSM_GCC_8960
> +       bool "MSM8960 Global Clock Controller"
> +       help
> +         Support for the global clock controller on msm8960 devices.
> +         Say Y if you want to use peripheral devices such as UART, SPI,
> +         i2c, USB, SD/eMMC, SATA, PCIe, etc.
> +
> +endif
> diff --git a/drivers/clk/msm/Makefile b/drivers/clk/msm/Makefile
> index 9cfd0d7..c785943 100644
> --- a/drivers/clk/msm/Makefile
> +++ b/drivers/clk/msm/Makefile
> @@ -6,3 +6,5 @@ clk-msm-$(CONFIG_COMMON_CLK_MSM) += clk-rcg2.o
>  clk-msm-$(CONFIG_COMMON_CLK_MSM) += clk-branch.o
> 
>  clk-msm-$(CONFIG_COMMON_CLK_MSM) += core.o
> +
> +clk-msm-$(CONFIG_MSM_GCC_8960) += gcc-8960.o
> diff --git a/drivers/clk/msm/core.c b/drivers/clk/msm/core.c
> index b1904c0..b8e702b 100644
> --- a/drivers/clk/msm/core.c
> +++ b/drivers/clk/msm/core.c
> @@ -173,6 +173,9 @@ typedef struct clk *
>                 struct cc_data *cc);
> 
>  static const struct of_device_id msm_cc_match_table[] = {
> +#ifdef CONFIG_MSM_GCC_8960
> +       { .compatible = "qcom,gcc-8960", .data = &msm_gcc_8960_matches },
> +#endif
>         { }
>  };
>  MODULE_DEVICE_TABLE(of, msm_cc_match_table);
> diff --git a/drivers/clk/msm/gcc-8960.c b/drivers/clk/msm/gcc-8960.c
> new file mode 100644
> index 0000000..b57d2dd
> --- /dev/null
> +++ b/drivers/clk/msm/gcc-8960.c
> @@ -0,0 +1,174 @@
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
> +static struct pll_desc pll8_desc = {
> +       .l_reg = 0x3144,
> +       .m_reg = 0x3148,
> +       .n_reg = 0x314c,
> +       .config_reg = 0x3154,
> +       .mode_reg = 0x3140,
> +       .status_reg = 0x3158,
> +       .status_bit = 16,
> +};
> +
> +static struct pll_vote_desc pll8_vote_desc = {
> +       .vote_reg = 0x34c0,
> +       .vote_bit = 8,
> +};
> +
> +#define PXO    0
> +#define PLL8   1
> +
> +static u8 gcc_pxo_pll8_map[] = {
> +       [PXO]   = 0,
> +       [PLL8]  = 3,
> +};
> +
> +static struct freq_tbl clk_tbl_gsbi_uart[] = {
> +       {  1843200, PLL8, 2,  6, 625 },
> +       {  3686400, PLL8, 2, 12, 625 },
> +       {  7372800, PLL8, 2, 24, 625 },
> +       { 14745600, PLL8, 2, 48, 625 },
> +       { 16000000, PLL8, 4,  1,   6 },
> +       { 24000000, PLL8, 4,  1,   4 },
> +       { 32000000, PLL8, 4,  1,   3 },
> +       { 40000000, PLL8, 1,  5,  48 },
> +       { 46400000, PLL8, 1, 29, 240 },
> +       { 48000000, PLL8, 4,  1,   2 },
> +       { 51200000, PLL8, 1,  2,  15 },
> +       { 56000000, PLL8, 1,  7,  48 },
> +       { 58982400, PLL8, 1, 96, 625 },
> +       { 64000000, PLL8, 2,  1,   3 },
> +       { }
> +};
> +
> +static struct rcg_desc gsbi5_uart_rcg = {
> +       .ctl_reg = 0x2a54,
> +       .ns_reg = 0x2a54,
> +       .md_reg = 0x2a50,
> +       .ctl_bit = 11,
> +       .mnctr_en_bit = 8,
> +       .mnctr_reset_bit = 7,
> +       .mnctr_mode_shift = 5,
> +       .pre_div_shift = 3,
> +       .src_sel_shift = 0,
> +       .n_val_shift = 16,
> +       .m_val_shift = 16,
> +       .parent_map = gcc_pxo_pll8_map,
> +       .freq_tbl = clk_tbl_gsbi_uart,
> +};
> +
> +static struct branch_desc gsbi5_uart_cxc = {
> +       .ctl_reg = 0x2a54,
> +       .halt_reg = 0x2fd0,
> +       .ctl_bit = 9,
> +       .halt_bit = 22,
> +       .halt_check = BRANCH_HALT,
> +};
> +
> +static struct rcg_desc gsbi6_uart_rcg = {
> +       .ctl_reg = 0x2a74,
> +       .ns_reg = 0x2a74,
> +       .md_reg = 0x2a70,
> +       .ctl_bit = 11,
> +       .mnctr_en_bit = 8,
> +       .mnctr_reset_bit = 7,
> +       .mnctr_mode_shift = 5,
> +       .pre_div_shift = 3,
> +       .src_sel_shift = 0,
> +       .n_val_shift = 16,
> +       .m_val_shift = 16,
> +       .parent_map = gcc_pxo_pll8_map,
> +       .freq_tbl = clk_tbl_gsbi_uart,
> +};
> +
> +static struct branch_desc gsbi6_uart_cxc = {
> +       .ctl_reg = 0x2a74,
> +       .halt_reg = 0x2fd0,
> +       .ctl_bit = 9,
> +       .halt_bit = 18,
> +       .halt_check = BRANCH_HALT,
> +};
> +
> +static struct branch_desc gsbi5_uart_ahb = {
> +       .ctl_reg = 0x2a40,
> +       .halt_reg = 0x2fd0,
> +       .hwcg_reg = 0x2a40,
> +       .ctl_bit = 4,
> +       .hwcg_bit = 6,
> +       .halt_bit = 23,
> +       .halt_check = BRANCH_HALT,
> +};
> +
> +static struct freq_tbl clk_tbl_gsbi_qup[] = {
> +       {  1100000, PXO,  1, 2, 49 },
> +       {  5400000, PXO,  1, 1,  5 },
> +       { 10800000, PXO,  1, 2,  5 },
> +       { 15060000, PLL8, 1, 2, 51 },
> +       { 24000000, PLL8, 4, 1,  4 },
> +       { 25600000, PLL8, 1, 1, 15 },
> +       { 27000000, PXO,  1, 0,  0 },
> +       { 48000000, PLL8, 4, 1,  2 },
> +       { 51200000, PLL8, 1, 2, 15 },
> +       { }
> +};
> +
> +static struct rcg_desc gsbi5_qup_rcg = {
> +       .ctl_reg = 0x2a4c,
> +       .ns_reg = 0x2a4c,
> +       .md_reg = 0x2a48,
> +       .ctl_bit = 11,
> +       .mnctr_en_bit = 8,
> +       .mnctr_reset_bit = 7,
> +       .mnctr_mode_shift = 5,
> +       .pre_div_shift = 3,
> +       .src_sel_shift = 0,
> +       .n_val_shift = 16,
> +       .m_val_shift = 16,
> +       .parent_map = gcc_pxo_pll8_map,
> +       .freq_tbl = clk_tbl_gsbi_qup,
> +};
> +
> +static struct branch_desc gsbi5_qup_cxc = {
> +       .ctl_reg = 0x2a4c,
> +       .halt_reg = 0x2fd0,
> +       .ctl_bit = 9,
> +       .halt_bit = 20,
> +       .halt_check = BRANCH_HALT,
> +};
> +
> +static struct of_clk_match msm_gcc_clk_match[] = {
> +       { .name = "cxo" },
> +       { .name = "pxo" },
> +       { .name = "pll8", .driver_data = &pll8_desc },
> +       { .name = "vpll8", .driver_data = &pll8_vote_desc },
> +       { .name = "gsbi5_uart_rcg", .driver_data = &gsbi5_uart_rcg },
> +       { .name = "gsbi5_uart_cxc", .driver_data = &gsbi5_uart_cxc },
> +       { .name = "gsbi6_uart_rcg", .driver_data = &gsbi6_uart_rcg },
> +       { .name = "gsbi6_uart_cxc", .driver_data = &gsbi6_uart_cxc },
> +       { .name = "gsbi5_uart_ahb", .driver_data = &gsbi5_uart_ahb },
> +       { .name = "gsbi5_qup_rcg", .driver_data = &gsbi5_qup_rcg },
> +       { .name = "gsbi5_qup_cxc", .driver_data = &gsbi5_qup_cxc },
> +};
> +
> +const struct msm_clk_match msm_gcc_8960_matches = {
> +       .matches = msm_gcc_clk_match,
> +       .size = ARRAY_SIZE(msm_gcc_clk_match)
> +};
> diff --git a/drivers/clk/msm/internal.h b/drivers/clk/msm/internal.h
> index 177bd3b..b0ffda7 100644
> --- a/drivers/clk/msm/internal.h
> +++ b/drivers/clk/msm/internal.h
> @@ -21,4 +21,6 @@ struct msm_clk_match {
>         size_t size;
>  };
> 
> +extern const struct msm_clk_match msm_gcc_8960_matches;
> +
>  #endif
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
