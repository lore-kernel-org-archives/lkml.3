Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752239AbaGBIsb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jul 2014 04:48:31 -0400
Received: from mail-ie0-f173.google.com ([209.85.223.173]:34197 "EHLO
	mail-ie0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752051AbaGBIsZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jul 2014 04:48:25 -0400
Date: Wed, 2 Jul 2014 09:48:19 +0100
From: Lee Jones <lee.jones@linaro.org>
To: Peter Griffin <peter.griffin@linaro.org>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        p.zabel@pengutronix.de, srinivas.kandagatla@gmail.com,
        maxime.coquelin@st.com, patrice.chotard@st.com,
        devicetree@vger.kernel.org,
        Giuseppe Cavallaro <peppe.cavallaro@st.com>
Subject: Re: [PATCH 1/3] drivers: reset: stih407: Add softreset, powerdown
 and picophy controllers
Message-ID: <20140702084819.GD10311@lee--X1>
References: <1404225047-9495-1-git-send-email-peter.griffin@linaro.org>
 <1404225047-9495-2-git-send-email-peter.griffin@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1404225047-9495-2-git-send-email-peter.griffin@linaro.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> This patch adds a softreset, powerdown and picophy reset controllers for
> the STiH407 SoC.

s/adds a softreset/adds softreset/

> With this patch three new devices are registered: -
> 1. st,stih407-powerdown
> 2. st,stih407-softreset
> 3. st,stih407-picophyreset
> 
> All three devices use system configuration registers mapped via regmap to
> perform the reset or powerdown. The powerdown controller also has
> an acknowledgement.
> 
> A separate picophy reset controller manages the different reset channels within
> the picophy, which have a different polarity to the other system softresets.
> Managing these different picophy softreset channels is necessary to correctly
> handle resuming from CPS when USB2 devices are plugged into the USB3 port.
> 
> Signed-off-by: Giuseppe Cavallaro <peppe.cavallaro@st.com>
> Signed-off-by: Peter Griffin <peter.griffin@linaro.org>
> ---
>  .../bindings/reset/st,sti-picophyreset.txt         |  41 ++++++
>  drivers/reset/sti/Kconfig                          |   4 +
>  drivers/reset/sti/Makefile                         |   1 +
>  drivers/reset/sti/reset-stih407.c                  | 159 +++++++++++++++++++++
>  .../dt-bindings/reset-controller/stih407-resets.h  |  60 ++++++++

Documentation is normally split out as a separate patch.

>  5 files changed, 265 insertions(+)
>  create mode 100644 Documentation/devicetree/bindings/reset/st,sti-picophyreset.txt
>  create mode 100644 drivers/reset/sti/reset-stih407.c
>  create mode 100644 include/dt-bindings/reset-controller/stih407-resets.h
> 
> diff --git a/Documentation/devicetree/bindings/reset/st,sti-picophyreset.txt b/Documentation/devicetree/bindings/reset/st,sti-picophyreset.txt
> new file mode 100644
> index 0000000..4c756d1
> --- /dev/null
> +++ b/Documentation/devicetree/bindings/reset/st,sti-picophyreset.txt
> @@ -0,0 +1,41 @@
> +STMicroelectronics STi family Sysconfig Picophy SoftReset Controller
> +=============================================================================
> +
> +This binding describes a reset controller device that is used to enable and
> +disable on-chip PicoPHY USB2 phy(s) using "softreset" control bits found in
> +the STi family SoC system configuration registers.
> +
> +The actual action taken when softreset is asserted is hardware dependent.
> +However, when asserted it may not be possible to access the hardware's
> +registers and after an assert/deassert sequence the hardware's previous state
> +may no longer be valid.
> +
> +Please refer to Documentation/devicetree/bindings/reset/reset.txt
> +for common reset controller binding usage.
> +
> +Required properties:
> +- compatible: Should be "st,<chip>-softreset"

You need to list the possible values here in full.

> +- #reset-cells: 1, see below
> +
> +example:

Nit: s/example/Example

> +
> +	picophyreset: picophyreset-controller {
> +		#reset-cells = <1>;
> +		compatible = "st,stih407-picophyreset";

Nit: Stick the compatible string at the top.

> +	};
> +
> +Specifying picophyreset control of devices
> +=======================================
> +
> +Device nodes should specify the reset channel required in their "resets"
> +property, containing a phandle to the picophyreset device node and an
> +index specifying which channel to use, as described in
> +Documentation/devicetree/bindings/reset/reset.txt.
> +
> +example:

'\n'

> +	usb2_picophy0: usbpicophy@0 {
> +		resets = <&picophyreset STIH407_PICOPHY0_RESET>;
> +	};
> +
> +Macro definitions for the supported reset channels can be found in:
> +include/dt-bindings/reset-controller/stih407-resets.h
> diff --git a/drivers/reset/sti/Kconfig b/drivers/reset/sti/Kconfig
> index 88d2d03..f8c15a3 100644
> --- a/drivers/reset/sti/Kconfig
> +++ b/drivers/reset/sti/Kconfig
> @@ -12,4 +12,8 @@ config STIH416_RESET
>  	bool
>  	select STI_RESET_SYSCFG
>  
> +config STIH407_RESET
> +	bool
> +	select STI_RESET_SYSCFG
> +

No help?

>  endif
> diff --git a/drivers/reset/sti/Makefile b/drivers/reset/sti/Makefile
> index be1c976..dc85dfb 100644
> --- a/drivers/reset/sti/Makefile
> +++ b/drivers/reset/sti/Makefile
> @@ -2,3 +2,4 @@ obj-$(CONFIG_STI_RESET_SYSCFG) += reset-syscfg.o
>  
>  obj-$(CONFIG_STIH415_RESET) += reset-stih415.o
>  obj-$(CONFIG_STIH416_RESET) += reset-stih416.o
> +obj-$(CONFIG_STIH407_RESET) += reset-stih407.o

Genuine question: how different are these?  Can they be consolidated?

> diff --git a/drivers/reset/sti/reset-stih407.c b/drivers/reset/sti/reset-stih407.c
> new file mode 100644
> index 0000000..1650792
> --- /dev/null
> +++ b/drivers/reset/sti/reset-stih407.c
> @@ -0,0 +1,159 @@
> +/*
> + * Copyright (C) 2013 STMicroelectronics (R&D) Limited
> + * Author: Giuseppe Cavallaro <peppe.cavallaro@st.com>
> + *
> + * This program is free software; you can redistribute it and/or modify
> + * it under the terms of the GNU General Public License as published by
> + * the Free Software Foundation; either version 2 of the License, or
> + * (at your option) any later version.
> + */
> +#include <linux/module.h>
> +#include <linux/of.h>
> +#include <linux/of_platform.h>
> +#include <linux/platform_device.h>
> +
> +#include <dt-bindings/reset-controller/stih407-resets.h>
> +
> +#include "reset-syscfg.h"

May as well squash these up.

> +/*
> + * STiH407 Peripheral powerdown definitions.
> + */

Should be single line comment.

> +static const char stih407_core[] = "st,stih407-core-syscfg";
> +static const char stih407_sbc_reg[] = "st,stih407-sbc-reg-syscfg";
> +static const char stih407_lpm[] = "st,stih407-lpm-syscfg";
> +
> +#define STIH407_PDN_0(_bit) \
> +	_SYSCFG_RST_CH(stih407_core, SYSCFG_5000, _bit, SYSSTAT_5500, _bit)
> +#define STIH407_PDN_1(_bit) \
> +	_SYSCFG_RST_CH(stih407_core, SYSCFG_5001, _bit, SYSSTAT_5501, _bit)
> +#define STIH407_PDN_ETH(_bit, _stat) \
> +	_SYSCFG_RST_CH(stih407_sbc_reg, SYSCFG_4032, _bit, SYSSTAT_4520, _stat)
> +
> +/* Powerdown requests control 0 */
> +#define SYSCFG_5000	0x0
> +#define SYSSTAT_5500	0x7d0

Separate these with a '\n'.

> +/* Powerdown requests control 1 (High Speed Links) */
> +#define SYSCFG_5001	0x4
> +#define SYSSTAT_5501	0x7d4
> +
> +/* Ethernet powerdown/status/reset */
> +#define	SYSCFG_4032	0x80
> +#define	SYSSTAT_4520	0x820
> +

What does this '\n' separate? Is it an Ethernet related value, or not?

> +#define	SYSCFG_4002	0x8

Can you address the formatting for all of the above.  Sometimes tabs
are used, other times it's spaces and the padding is also different -
can you standardise to 3 values post-fixing the '0x' i.e. 0xNNN.

> +static const struct syscfg_reset_channel_data stih407_powerdowns[] = {
> +	[STIH407_EMISS_POWERDOWN] = STIH407_PDN_0(1),
> +	[STIH407_NAND_POWERDOWN] = STIH407_PDN_0(0),
> +	[STIH407_USB3_POWERDOWN] = STIH407_PDN_1(6),
> +	[STIH407_USB2_PORT1_POWERDOWN] = STIH407_PDN_1(5),
> +	[STIH407_USB2_PORT0_POWERDOWN] = STIH407_PDN_1(4),
> +	[STIH407_PCIE1_POWERDOWN] = STIH407_PDN_1(3),
> +	[STIH407_PCIE0_POWERDOWN] = STIH407_PDN_1(2),
> +	[STIH407_SATA1_POWERDOWN] = STIH407_PDN_1(1),
> +	[STIH407_SATA0_POWERDOWN] = STIH407_PDN_1(0),
> +	[STIH407_ETH1_POWERDOWN] = STIH407_PDN_ETH(0, 2),
> +};

Being a little OCD, I _personally_ like to see the '='s lined up with
tabs, but some maintainers don't like that.  Philipp's call I guess.

[...]

> +static struct syscfg_reset_controller_data stih407_powerdown_controller = {
> +	.wait_for_ack = true,
> +	.nr_channels = ARRAY_SIZE(stih407_powerdowns),
> +	.channels = stih407_powerdowns,
> +};
> +
> +static struct syscfg_reset_controller_data stih407_softreset_controller = {
> +	.wait_for_ack = false,
> +	.active_low = true,
> +	.nr_channels = ARRAY_SIZE(stih407_softresets),
> +	.channels = stih407_softresets,
> +};
> +
> +static struct syscfg_reset_controller_data stih407_picophyreset_controller = {
> +	.wait_for_ack = false,
> +	.nr_channels = ARRAY_SIZE(stih407_picophyresets),
> +	.channels = stih407_picophyresets,
> +};

I believe these should be const.

> +static struct of_device_id stih407_reset_match[] = {
> +	{.compatible = "st,stih407-powerdown",
> +	 .data = &stih407_powerdown_controller,},
> +	{.compatible = "st,stih407-softreset",
> +	 .data = &stih407_softreset_controller,},
> +	{.compatible = "st,stih407-picophyreset",
> +	 .data = &stih407_picophyreset_controller,},

Formatting should be:

	{
		.compatible = "st,stih407-picophyreset",
	 	.data = &stih407_picophyreset_controller,
	},


> +	{},
> +};
> +
> +static struct platform_driver stih407_reset_driver = {
> +	.probe = syscfg_reset_probe,
> +	.driver = {
> +		   .name = "reset-stih407",
> +		   .owner = THIS_MODULE,

Remove this line, it's done for you as part of
platform_driver_register().

> +		   .of_match_table = stih407_reset_match,
> +		   },

Tabbing is borked.

> +};
> +
> +static int __init stih407_reset_init(void)
> +{
> +	return platform_driver_register(&stih407_reset_driver);
> +}
> +
> +arch_initcall(stih407_reset_init);
> diff --git a/include/dt-bindings/reset-controller/stih407-resets.h b/include/dt-bindings/reset-controller/stih407-resets.h
> new file mode 100644
> index 0000000..85448a3
> --- /dev/null
> +++ b/include/dt-bindings/reset-controller/stih407-resets.h
> @@ -0,0 +1,60 @@
> +/*
> + * This header provides constants for the reset controller
> + * based peripheral powerdown requests on the STMicroelectronics
> + * STiH407 SoC.
> + */
> +#ifndef _DT_BINDINGS_RESET_CONTROLLER_STIH407
> +#define _DT_BINDINGS_RESET_CONTROLLER_STIH407
> +
> +/* Powerdown requests control 0 */
> +#define STIH407_EMISS_POWERDOWN		0
> +#define STIH407_NAND_POWERDOWN		1
> +
> +/* Synp GMAC PowerDown */
> +#define	STIH407_ETH1_POWERDOWN		2

For consistency, either add a line here, or remove the one 3 up.

> +/* Powerdown requests control 1 */
> +#define STIH407_USB3_POWERDOWN		3
> +#define STIH407_USB2_PORT1_POWERDOWN	4
> +#define STIH407_USB2_PORT0_POWERDOWN	5
> +#define STIH407_PCIE1_POWERDOWN		6
> +#define STIH407_PCIE0_POWERDOWN		7
> +#define STIH407_SATA1_POWERDOWN		8
> +#define STIH407_SATA0_POWERDOWN		9

Do these all line up in your editor? 

> +/* Reset defines */
> +#define	STIH407_ETH1_SOFTRESET		0
> +#define	STIH407_MMC1_SOFTRESET		1
> +#define	STIH407_PICOPHY_SOFTRESET	2
> +#define	STIH407_IRB_SOFTRESET		3
> +#define	STIH407_PCIE0_SOFTRESET		4
> +#define	STIH407_PCIE1_SOFTRESET		5
> +#define	STIH407_SATA0_SOFTRESET		6
> +#define	STIH407_SATA1_SOFTRESET		7
> +#define	STIH407_MIPHY0_SOFTRESET	8
> +#define	STIH407_MIPHY1_SOFTRESET	9
> +#define	STIH407_MIPHY2_SOFTRESET	10
> +#define	STIH407_SATA0_PWR_SOFTRESET	11
> +#define	STIH407_SATA1_PWR_SOFTRESET	12
> +#define	STIH407_DELTA_SOFTRESET		13
> +#define	STIH407_BLITTER_SOFTRESET	14
> +#define	STIH407_HDTVOUT_SOFTRESET	15
> +#define	STIH407_HDQVDP_SOFTRESET	16
> +#define	STIH407_VDP_AUX_SOFTRESET	17
> +#define	STIH407_COMPO_SOFTRESET		18
> +#define	STIH407_HDMI_TX_PHY_SOFTRESET	19
> +#define	STIH407_JPEG_DEC_SOFTRESET	20
> +#define	STIH407_VP8_DEC_SOFTRESET	21
> +#define	STIH407_GPU_SOFTRESET		22
> +#define	STIH407_HVA_SOFTRESET		23
> +#define	STIH407_ERAM_HVA_SOFTRESET	24
> +#define	STIH407_LPM_SOFTRESET		25
> +#define	STIH407_KEYSCAN_SOFTRESET	26
> +#define	STIH407_USB2_PORT0_SOFTRESET	27
> +#define	STIH407_USB2_PORT1_SOFTRESET	28

Again, you have tabs here and spaces elsewhere.

I suggest you use a single space everywhere after '#define' and then
line up the values on the right with tabs.

> +/* Picophy reset defines */
> +#define	STIH407_PICOPHY0_RESET	0
> +#define	STIH407_PICOPHY1_RESET	1
> +#define	STIH407_PICOPHY2_RESET	2
> +
> +#endif /* _DT_BINDINGS_RESET_CONTROLLER_STIH407 */

-- 
Lee Jones
Linaro STMicroelectronics Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
