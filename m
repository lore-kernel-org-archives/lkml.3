Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753413Ab3K0Kyr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Nov 2013 05:54:47 -0500
Received: from perceval.ideasonboard.com ([95.142.166.194]:52562 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752326Ab3K0Kyn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Nov 2013 05:54:43 -0500
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Magnus Damm <magnus.damm@gmail.com>
Cc: linux-kernel@vger.kernel.org, wsa@the-dreams.de, linus.walleij@linaro.org,
        linux-sh@vger.kernel.org, horms@verge.net.au
Subject: Re: [PATCH] pinctrl: sh-pfc: Initial r7s72100 support
Date: Wed, 27 Nov 2013 11:54:42 +0100
Message-ID: <2184496.xEujhTLELy@avalon>
User-Agent: KMail/4.10.5 (Linux/3.10.17-gentoo; KDE/4.10.5; x86_64; ; )
In-Reply-To: <20131127074122.18314.48522.sendpatchset@w520>
References: <20131127074122.18314.48522.sendpatchset@w520>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Magnus,

Thank you for the patch.

On Wednesday 27 November 2013 16:41:22 Magnus Damm wrote:
> From: Magnus Damm <damm@opensource.se>
> 
> Add r7s72100 PINCTRL support via sh-pfc. At this point this code
> provides enough support to allow use together with the gpio-rz
> driver. Incremental per-device patches will in the future be
> submitted on top of this base patch to allow PINCTRL enablement
> for each individual device.
> 
> Signed-off-by: Magnus Damm <damm@opensource.se>
> ---
> 
>  drivers/pinctrl/sh-pfc/Kconfig        |    5
>  drivers/pinctrl/sh-pfc/Makefile       |    1
>  drivers/pinctrl/sh-pfc/core.c         |    9 +
>  drivers/pinctrl/sh-pfc/core.h         |    1
>  drivers/pinctrl/sh-pfc/pfc-r7s72100.c |  166 ++++++++++++++++++++++++++++++
>  5 files changed, 182 insertions(+)

[snip]

> --- /dev/null
> +++ work/drivers/pinctrl/sh-pfc/pfc-r7s72100.c	2013-11-27 
15:20:28.000000000
> +0900 @@ -0,0 +1,166 @@

[snip]

> +#define RZ_PORT_PIN(bank, pin) (((bank) * 16) + (pin))

Could you move this below closer to the location where it will be used, right 
after the pinmux_pins array ?

> +
> +#define PORT_P_1(bank, pin, fn, sfx) fn(bank, pin, P_##bank##_##pin, sfx)

I'm tempted to call the pins GP_ instead of P_ to be able to reuse the 
existing macros. On the other hand I suppose the datasheet uses P, not GP. 
What's your opinion on that ?

> +
> +#define PORT_P_16(bank, fn, sfx)					\
> +	PORT_P_1(bank, 0,  fn, sfx), PORT_P_1(bank, 1,  fn, sfx),	\
> +	PORT_P_1(bank, 2,  fn, sfx), PORT_P_1(bank, 3,  fn, sfx),	\
> +	PORT_P_1(bank, 4,  fn, sfx), PORT_P_1(bank, 5,  fn, sfx),	\
> +	PORT_P_1(bank, 6,  fn, sfx), PORT_P_1(bank, 7,  fn, sfx),	\
> +	PORT_P_1(bank, 8,  fn, sfx), PORT_P_1(bank, 9,  fn, sfx),	\
> +	PORT_P_1(bank, 10, fn, sfx), PORT_P_1(bank, 11, fn, sfx),	\
> +	PORT_P_1(bank, 12, fn, sfx), PORT_P_1(bank, 13, fn, sfx),	\
> +	PORT_P_1(bank, 14, fn, sfx), PORT_P_1(bank, 15, fn, sfx)
> +
> +#define CPU_ALL_PORT(fn, sfx)						\
> +	PORT_P_16(0, fn, sfx), PORT_P_16(1, fn, sfx),			\
> +	PORT_P_16(2, fn, sfx), PORT_P_16(3, fn, sfx),			\
> +	PORT_P_16(4, fn, sfx), PORT_P_16(5, fn, sfx),			\
> +	PORT_P_16(6, fn, sfx), PORT_P_16(7, fn, sfx),			\
> +	PORT_P_16(8, fn, sfx), PORT_P_16(9, fn, sfx),			\
> +	PORT_P_16(10, fn, sfx), PORT_P_16(11, fn, sfx),			\
> +	PORT_P_16(12, fn, sfx)
> +
> +#define P_ALL(n) GP_ALL(n)
> +
> +enum {
> +	PINMUX_RESERVED = 0,
> +
> +	PINMUX_DATA_BEGIN,
> +	P_ALL(DATA),
> +	PINMUX_DATA_END,
> +
> +	PINMUX_FUNCTION_BEGIN,
> +	P_ALL(PMC_0), P_ALL(PMC_1),
> +	P_ALL(PFC_0), P_ALL(PFC_1),
> +	P_ALL(PFCE_0), P_ALL(PFCE_1),
> +	P_ALL(PFCAE_0), P_ALL(PFCAE_1),
> +	P_ALL(PIBC_0), P_ALL(PIBC_1),
> +	P_ALL(PBDC_0), P_ALL(PBDC_1),
> +	P_ALL(PIPC_0), P_ALL(PIPC_1),
> +	PINMUX_FUNCTION_END,

Only the PMC_1 and PFC* registers seem to be used in your later patches. What 
are the other registers for ? Shouldn't they be omitted if unused ?
> +
> +	PINMUX_MARK_BEGIN,
> +	P_ALL(MARK_FN1), P_ALL(MARK_FN2), P_ALL(MARK_FN3), P_ALL(MARK_FN4),
> +	P_ALL(MARK_FN5), P_ALL(MARK_FN6), P_ALL(MARK_FN7), P_ALL(MARK_FN8),
> +	PINMUX_MARK_END,
> +};
> +
> +#define _P_ALL(n) CPU_ALL_PORT(n, unused)
> +
> +#define _P_GPIO(bank, _pin, _name, sfx)					\
> +	[(bank * 16) + _pin] = {					\
> +		.pin = (bank * 16) + _pin,				\
> +		.name = __stringify(_name),				\
> +		.enum_id = _name##_DATA,				\
> +	}

What about renaming _GP_GPIO to _GP_GPIO32 in sh_pfc.h, and move this macro to 
that header, calling it _GP_GPIO16 ?

> +
> +#define _P_DATA(bank, pin, name, sfx)					\
> +	PINMUX_DATA(name##_DATA, name##_PMC_0,				\
> +		    name##_PIBC_1, name##_PBDC_1)
> +
> +#define _P_FN(n, fn, pfcae, pfce, pfc)					\
> +	PINMUX_DATA(n##_MARK_FN##fn, n##_PMC_1,				\
> +		    n##_PFCAE_##pfcae, n##_PFCE_##pfce, n##_PFC_##pfc)
> +
> +#define _P_MARK_FN1(bank, pin, name, sfx) _P_FN(name, 1, 0, 0, 0)
> +#define _P_MARK_FN2(bank, pin, name, sfx) _P_FN(name, 2, 0, 0, 1)
> +#define _P_MARK_FN3(bank, pin, name, sfx) _P_FN(name, 3, 0, 1, 0)
> +#define _P_MARK_FN4(bank, pin, name, sfx) _P_FN(name, 4, 0, 1, 1)
> +#define _P_MARK_FN5(bank, pin, name, sfx) _P_FN(name, 5, 1, 0, 0)
> +#define _P_MARK_FN6(bank, pin, name, sfx) _P_FN(name, 6, 1, 0, 1)
> +#define _P_MARK_FN7(bank, pin, name, sfx) _P_FN(name, 7, 1, 1, 0)
> +#define _P_MARK_FN8(bank, pin, name, sfx) _P_FN(name, 8, 1, 1, 1)
> +
> +static const u16 pinmux_data[] = {
> +	_P_ALL(_P_DATA), /* PINMUX_DATA(P_M_N_DATA, P_M_N_PMC_0), */
> +	_P_ALL(_P_MARK_FN1), _P_ALL(_P_MARK_FN2),
> +	_P_ALL(_P_MARK_FN3), _P_ALL(_P_MARK_FN4),
> +	_P_ALL(_P_MARK_FN5), _P_ALL(_P_MARK_FN6),
> +	_P_ALL(_P_MARK_FN7), _P_ALL(_P_MARK_FN8),
> +};
> +
> +static struct sh_pfc_pin pinmux_pins[] = {
> +	_P_ALL(_P_GPIO),
> +};
> +
> +static const struct sh_pfc_pin_group pinmux_groups[] = {
> +};
> +
> +static const struct sh_pfc_function pinmux_functions[] = {
> +};
> +
> +#define PFC_REG(idx, name, reg)						\
> +	{ PINMUX_CFG_REG(__stringify(name), reg, 16, 1) {		\
> +		P_##idx##_15_##name##_0, P_##idx##_15_##name##_1,	\
> +		P_##idx##_14_##name##_0, P_##idx##_14_##name##_1,	\
> +		P_##idx##_13_##name##_0, P_##idx##_13_##name##_1,	\
> +		P_##idx##_12_##name##_0, P_##idx##_12_##name##_1,	\
> +		P_##idx##_11_##name##_0, P_##idx##_11_##name##_1,	\
> +		P_##idx##_10_##name##_0, P_##idx##_10_##name##_1,	\
> +		P_##idx##_9_##name##_0, P_##idx##_9_##name##_1,		\
> +		P_##idx##_8_##name##_0, P_##idx##_8_##name##_1,		\
> +		P_##idx##_7_##name##_0, P_##idx##_7_##name##_1,		\
> +		P_##idx##_6_##name##_0, P_##idx##_6_##name##_1,		\
> +		P_##idx##_5_##name##_0, P_##idx##_5_##name##_1,		\
> +		P_##idx##_4_##name##_0, P_##idx##_4_##name##_1,		\
> +		P_##idx##_3_##name##_0, P_##idx##_3_##name##_1,		\
> +		P_##idx##_2_##name##_0, P_##idx##_2_##name##_1,		\
> +		P_##idx##_1_##name##_0, P_##idx##_1_##name##_1,		\
> +		P_##idx##_0_##name##_0, P_##idx##_0_##name##_1 }	\
> +	}
> +
> +#define PFC_REGS(idx)						\
> +	PFC_REG(idx, PMC, (0xfcfe3400 + (idx * 4))),		\
> +	PFC_REG(idx, PFC, (0xfcfe3500 + (idx * 4))),		\
> +	PFC_REG(idx, PFCE, (0xfcfe3600 + (idx * 4))),		\
> +	PFC_REG(idx, PFCAE, (0xfcfe3a00 + (idx * 4))),		\
> +	PFC_REG(idx, PIBC, (0xfcfe7000 + (idx * 4))),		\
> +	PFC_REG(idx, PBDC, (0xfcfe7100 + (idx * 4))),		\
> +	PFC_REG(idx, PIPC, (0xfcfe7200 + (idx * 4)))
> +
> +static struct pinmux_cfg_reg pinmux_config_regs[] = {
> +	PFC_REGS(0), PFC_REGS(1), PFC_REGS(2), PFC_REGS(3),
> +	PFC_REGS(4), PFC_REGS(5), PFC_REGS(6), PFC_REGS(7),
> +	PFC_REGS(8), PFC_REGS(9), PFC_REGS(10), PFC_REGS(11),
> +	PFC_REG(12, PMC, 0xfcfe7b40),
> +	PFC_REG(12, PIBC, 0xfcfe7f00),
> +	{ },
> +};
> +
> +const struct sh_pfc_soc_info r7s72100_pinmux_info = {
> +	.name = "r7s72100_pfc",
> +
> +	.function = { PINMUX_FUNCTION_BEGIN, PINMUX_FUNCTION_END },
> +
> +	.pins = pinmux_pins,
> +	.nr_pins = ARRAY_SIZE(pinmux_pins),
> +	.groups = pinmux_groups,
> +	.nr_groups = ARRAY_SIZE(pinmux_groups),
> +	.functions = pinmux_functions,
> +	.nr_functions = ARRAY_SIZE(pinmux_functions),
> +
> +	.cfg_regs = pinmux_config_regs,
> +
> +	.gpio_data = pinmux_data,
> +	.gpio_data_size = ARRAY_SIZE(pinmux_data),
> +};

-- 
Regards,

Laurent Pinchart
