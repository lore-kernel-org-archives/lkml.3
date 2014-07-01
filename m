Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757823AbaGAOu2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Jul 2014 10:50:28 -0400
Received: from mx08-00178001.pphosted.com ([91.207.212.93]:47825 "EHLO
	mx08-00178001.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754767AbaGAOu0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Jul 2014 10:50:26 -0400
Message-ID: <53B2CA71.2080308@st.com>
Date: Tue, 1 Jul 2014 16:49:21 +0200
From: Patrice Chotard <patrice.chotard@st.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: Peter Griffin <peter.griffin@linaro.org>,
        <linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>,
        <p.zabel@pengutronix.de>, <srinivas.kandagatla@gmail.com>,
        <maxime.coquelin@st.com>
Cc: <lee.jones@linaro.org>, <devicetree@vger.kernel.org>,
        Giuseppe Cavallaro <peppe.cavallaro@st.com>
Subject: Re: [PATCH 1/3] drivers: reset: stih407: Add softreset, powerdown
 and picophy controllers
References: <1404225047-9495-1-git-send-email-peter.griffin@linaro.org> <1404225047-9495-2-git-send-email-peter.griffin@linaro.org>
In-Reply-To: <1404225047-9495-2-git-send-email-peter.griffin@linaro.org>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.201.23.18]
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10432:5.12.52,1.0.14,0.0.0000
 definitions=2014-07-01_05:2014-07-01,2014-07-01,1970-01-01 signatures=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Peter

2 minor remarks below

Thanks

On 07/01/2014 04:30 PM, Peter Griffin wrote:
> This patch adds a softreset, powerdown and picophy reset controllers for
> the STiH407 SoC.
>
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
>   .../bindings/reset/st,sti-picophyreset.txt         |  41 ++++++
>   drivers/reset/sti/Kconfig                          |   4 +
>   drivers/reset/sti/Makefile                         |   1 +
>   drivers/reset/sti/reset-stih407.c                  | 159 +++++++++++++++++++++
>   .../dt-bindings/reset-controller/stih407-resets.h  |  60 ++++++++
>   5 files changed, 265 insertions(+)
>   create mode 100644 Documentation/devicetree/bindings/reset/st,sti-picophyreset.txt
>   create mode 100644 drivers/reset/sti/reset-stih407.c
>   create mode 100644 include/dt-bindings/reset-controller/stih407-resets.h
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
> +- #reset-cells: 1, see below
> +
> +example:
> +
> +	picophyreset: picophyreset-controller {
> +		#reset-cells = <1>;
> +		compatible = "st,stih407-picophyreset";
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
>   	bool
>   	select STI_RESET_SYSCFG
>   
> +config STIH407_RESET
> +	bool
> +	select STI_RESET_SYSCFG
> +
>   endif
> diff --git a/drivers/reset/sti/Makefile b/drivers/reset/sti/Makefile
> index be1c976..dc85dfb 100644
> --- a/drivers/reset/sti/Makefile
> +++ b/drivers/reset/sti/Makefile
> @@ -2,3 +2,4 @@ obj-$(CONFIG_STI_RESET_SYSCFG) += reset-syscfg.o
>   
>   obj-$(CONFIG_STIH415_RESET) += reset-stih415.o
>   obj-$(CONFIG_STIH416_RESET) += reset-stih416.o
> +obj-$(CONFIG_STIH407_RESET) += reset-stih407.o
> diff --git a/drivers/reset/sti/reset-stih407.c b/drivers/reset/sti/reset-stih407.c
> new file mode 100644
> index 0000000..1650792
> --- /dev/null
> +++ b/drivers/reset/sti/reset-stih407.c
> @@ -0,0 +1,159 @@
> +/*
> + * Copyright (C) 2013 STMicroelectronics (R&D) Limited
s/2013/2014
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
> +
> +/*
> + * STiH407 Peripheral powerdown definitions.
> + */
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
> +/* Powerdown requests control 1 (High Speed Links) */
> +#define SYSCFG_5001	0x4
> +#define SYSSTAT_5501	0x7d4
> +
> +/* Ethernet powerdown/status/reset */
> +#define	SYSCFG_4032	0x80
> +#define	SYSSTAT_4520	0x820
> +
> +#define	SYSCFG_4002	0x8
> +
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
> +
> +/* Reset Generator control 0/1 */
> +#define	SYSCFG_5131	0x20c
> +#define	SYSCFG_5132	0x210
> +
> +#define LPM_SYSCFG_1    0x4	/* Softreset IRB & SBC UART */
> +
> +#define STIH407_SRST_CORE(_reg, _bit) \
> +	_SYSCFG_RST_CH_NO_ACK(stih407_core, _reg, _bit)
> +
> +#define STIH407_SRST_SBC(_reg, _bit) \
> +	_SYSCFG_RST_CH_NO_ACK(stih407_sbc_reg, _reg, _bit)
> +
> +#define STIH407_SRST_LPM(_reg, _bit) \
> +	_SYSCFG_RST_CH_NO_ACK(stih407_lpm, _reg, _bit)
> +
> +static const struct syscfg_reset_channel_data stih407_softresets[] = {
> +	[STIH407_ETH1_SOFTRESET] = STIH407_SRST_SBC(SYSCFG_4002, 4),
> +	[STIH407_MMC1_SOFTRESET] = STIH407_SRST_CORE(SYSCFG_5132, 3),
> +	[STIH407_USB2_PORT0_SOFTRESET] = STIH407_SRST_CORE(SYSCFG_5132, 28),
> +	[STIH407_USB2_PORT1_SOFTRESET] = STIH407_SRST_CORE(SYSCFG_5132, 29),
> +	[STIH407_PICOPHY_SOFTRESET] = STIH407_SRST_CORE(SYSCFG_5132, 30),
> +	[STIH407_IRB_SOFTRESET] = STIH407_SRST_LPM(LPM_SYSCFG_1, 6),
> +	[STIH407_PCIE0_SOFTRESET] = STIH407_SRST_CORE(SYSCFG_5132, 6),
> +	[STIH407_PCIE1_SOFTRESET] = STIH407_SRST_CORE(SYSCFG_5132, 15),
> +	[STIH407_SATA0_SOFTRESET] = STIH407_SRST_CORE(SYSCFG_5132, 7),
> +	[STIH407_SATA1_SOFTRESET] = STIH407_SRST_CORE(SYSCFG_5132, 16),
> +	[STIH407_MIPHY0_SOFTRESET] = STIH407_SRST_CORE(SYSCFG_5132, 4),
> +	[STIH407_MIPHY1_SOFTRESET] = STIH407_SRST_CORE(SYSCFG_5132, 13),
> +	[STIH407_MIPHY2_SOFTRESET] = STIH407_SRST_CORE(SYSCFG_5132, 22),
> +	[STIH407_SATA0_PWR_SOFTRESET] = STIH407_SRST_CORE(SYSCFG_5132, 5),
> +	[STIH407_SATA1_PWR_SOFTRESET] = STIH407_SRST_CORE(SYSCFG_5132, 14),
> +	[STIH407_DELTA_SOFTRESET] = STIH407_SRST_CORE(SYSCFG_5131, 3),
> +	[STIH407_BLITTER_SOFTRESET] = STIH407_SRST_CORE(SYSCFG_5131, 10),
> +	[STIH407_HDTVOUT_SOFTRESET] = STIH407_SRST_CORE(SYSCFG_5131, 11),
> +	[STIH407_HDQVDP_SOFTRESET] = STIH407_SRST_CORE(SYSCFG_5131, 12),
> +	[STIH407_VDP_AUX_SOFTRESET] = STIH407_SRST_CORE(SYSCFG_5131, 14),
> +	[STIH407_COMPO_SOFTRESET] = STIH407_SRST_CORE(SYSCFG_5131, 15),
> +	[STIH407_HDMI_TX_PHY_SOFTRESET] = STIH407_SRST_CORE(SYSCFG_5131, 21),
> +	[STIH407_JPEG_DEC_SOFTRESET] = STIH407_SRST_CORE(SYSCFG_5131, 23),
> +	[STIH407_VP8_DEC_SOFTRESET] = STIH407_SRST_CORE(SYSCFG_5131, 24),
> +	[STIH407_GPU_SOFTRESET] = STIH407_SRST_CORE(SYSCFG_5131, 30),
> +	[STIH407_HVA_SOFTRESET] = STIH407_SRST_CORE(SYSCFG_5132, 0),
> +	[STIH407_ERAM_HVA_SOFTRESET] = STIH407_SRST_CORE(SYSCFG_5132, 1),
> +	[STIH407_LPM_SOFTRESET] = STIH407_SRST_SBC(SYSCFG_4002, 2),
> +	[STIH407_KEYSCAN_SOFTRESET] = STIH407_SRST_LPM(LPM_SYSCFG_1, 8),
> +};
> +
> +/* PicoPHY reset/control */
> +#define SYSCFG_5061	0x0f4
> +
> +static const struct syscfg_reset_channel_data stih407_picophyresets[] = {
> +	[STIH407_PICOPHY0_RESET] = STIH407_SRST_CORE(SYSCFG_5061, 5),
> +	[STIH407_PICOPHY1_RESET] = STIH407_SRST_CORE(SYSCFG_5061, 6),
> +	[STIH407_PICOPHY2_RESET] = STIH407_SRST_CORE(SYSCFG_5061, 7),
> +};
> +
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
> +
> +
remove extra line
> +static struct of_device_id stih407_reset_match[] = {
> +	{.compatible = "st,stih407-powerdown",
> +	 .data = &stih407_powerdown_controller,},
> +	{.compatible = "st,stih407-softreset",
> +	 .data = &stih407_softreset_controller,},
> +	{.compatible = "st,stih407-picophyreset",
> +	 .data = &stih407_picophyreset_controller,},
> +	{},
> +};
> +
> +static struct platform_driver stih407_reset_driver = {
> +	.probe = syscfg_reset_probe,
> +	.driver = {
> +		   .name = "reset-stih407",
> +		   .owner = THIS_MODULE,
> +		   .of_match_table = stih407_reset_match,
> +		   },
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
> +/* Powerdown requests control 1 */
> +#define STIH407_USB3_POWERDOWN		3
> +#define STIH407_USB2_PORT1_POWERDOWN	4
> +#define STIH407_USB2_PORT0_POWERDOWN	5
> +#define STIH407_PCIE1_POWERDOWN		6
> +#define STIH407_PCIE0_POWERDOWN		7
> +#define STIH407_SATA1_POWERDOWN		8
> +#define STIH407_SATA0_POWERDOWN		9
> +
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
> +
> +/* Picophy reset defines */
> +#define	STIH407_PICOPHY0_RESET	0
> +#define	STIH407_PICOPHY1_RESET	1
> +#define	STIH407_PICOPHY2_RESET	2
> +
> +#endif /* _DT_BINDINGS_RESET_CONTROLLER_STIH407 */

