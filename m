Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754873AbaEKEuQ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 May 2014 00:50:16 -0400
Received: from top.free-electrons.com ([176.31.233.9]:52133 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751232AbaEKEuJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 May 2014 00:50:09 -0400
Date: Sun, 11 May 2014 06:45:26 +0200
From: Maxime Ripard <maxime.ripard@free-electrons.com>
To: Matthias Brugger <matthias.bgg@gmail.com>
Cc: linux-kernel@vger.kernel.org, robh+dt@kernel.org, pawel.moll@arm.com,
        mark.rutland@arm.com, ijc+devicetree@hellion.org.uk,
        galak@codeaurora.org, rdunlap@infradead.org, linux@arm.linux.org.uk,
        daniel.lezcano@linaro.org, tglx@linutronix.de,
        thierry.reding@gmail.com, florian.vaussard@epfl.ch, jic23@kernel.org,
        jason@lakedaemon.net, andrew@lunn.ch, silvio.fricke@gmail.com,
        heiko.stuebner@bq.com, olof@lixom.net, sebastian.hesselbarth@gmail.com,
        sboyd@codeaurora.org, gregory.clement@free-electrons.com,
        arnd@arndb.de, robherring2@gmail.com, marc.zyngier@arm.com,
        devicetree@vger.kernel.org, linux-doc@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH v2 1/4] clocksource: Add support for the Mediatek SoCs
Message-ID: <20140511044526.GQ7047@lukather>
References: <1399772463-859-1-git-send-email-matthias.bgg@gmail.com>
 <1399772463-859-2-git-send-email-matthias.bgg@gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="QL7C2Vd2zSGwwTJM"
Content-Disposition: inline
In-Reply-To: <1399772463-859-2-git-send-email-matthias.bgg@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--QL7C2Vd2zSGwwTJM
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Sun, May 11, 2014 at 03:41:00AM +0200, Matthias Brugger wrote:
> This patch adds a clock source and clock event for the timer found
> on the Mediatek SoCs.
>=20
> The Mediatek General Porpose Timer block provides five 32 bit timers and
> one 64 bit timer.
>=20
> Two 32 bit timers are used:
> TIMER1: clock events supporting periodic and oneshot events
> TIMER2: clock source configured as a free running counter
>=20
> The General Porpose Timer block can be run with two clocks. A 13 MHz syst=
em
> clock and the RTC clock running at 32 KHz. This implementation uses the s=
ystem
> clock.
>=20
> Signed-off-by: Matthias Brugger <matthias.bgg@gmail.com>
> ---
>  drivers/clocksource/Kconfig     |   4 +
>  drivers/clocksource/Makefile    |   1 +
>  drivers/clocksource/mtk_timer.c | 240 ++++++++++++++++++++++++++++++++++=
++++++
>  3 files changed, 245 insertions(+)
>  create mode 100644 drivers/clocksource/mtk_timer.c
>=20
> diff --git a/drivers/clocksource/Kconfig b/drivers/clocksource/Kconfig
> index 96918e1..1f73740 100644
> --- a/drivers/clocksource/Kconfig
> +++ b/drivers/clocksource/Kconfig
> @@ -144,6 +144,10 @@ config VF_PIT_TIMER
>  config SYS_SUPPORTS_SH_CMT
>          bool
> =20
> +config MTK_TIMER
> +	select CLKSRC_MMIO
> +	bool
> +
>  config SYS_SUPPORTS_SH_MTU2
>          bool
> =20
> diff --git a/drivers/clocksource/Makefile b/drivers/clocksource/Makefile
> index 98cb6c5..619d302 100644
> --- a/drivers/clocksource/Makefile
> +++ b/drivers/clocksource/Makefile
> @@ -33,6 +33,7 @@ obj-$(CONFIG_CLKSRC_EXYNOS_MCT)	+=3D exynos_mct.o
>  obj-$(CONFIG_CLKSRC_SAMSUNG_PWM)	+=3D samsung_pwm_timer.o
>  obj-$(CONFIG_VF_PIT_TIMER)	+=3D vf_pit_timer.o
>  obj-$(CONFIG_CLKSRC_QCOM)	+=3D qcom-timer.o
> +obj-$(CONFIG_MTK_TIMER)		+=3D mtk_timer.o
> =20
>  obj-$(CONFIG_ARM_ARCH_TIMER)		+=3D arm_arch_timer.o
>  obj-$(CONFIG_ARM_GLOBAL_TIMER)		+=3D arm_global_timer.o
> diff --git a/drivers/clocksource/mtk_timer.c b/drivers/clocksource/mtk_ti=
mer.c
> new file mode 100644
> index 0000000..796b888
> --- /dev/null
> +++ b/drivers/clocksource/mtk_timer.c
> @@ -0,0 +1,240 @@
> +/*
> + * Mediatek SoCs General-Purpose Timer handling.
> + *
> + * Copyright (C) 2014 Matthias Brugger
> + *
> + * Matthias Brugger <matthias.bgg@gmail.com>
> + *
> + * This program is free software; you can redistribute it and/or modify
> + * it under the terms of the GNU General Public License as published by
> + * the Free Software Foundation; either version 2 of the License, or
> + * (at your option) any later version.
> + *
> + * This program is distributed in the hope that it will be useful,
> + * but WITHOUT ANY WARRANTY; without even the implied warranty of
> + * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> + * GNU General Public License for more details.
> + */
> +
> +#include <linux/clk.h>
> +#include <linux/clockchips.h>
> +#include <linux/interrupt.h>
> +#include <linux/irq.h>
> +#include <linux/irqreturn.h>
> +#include <linux/of.h>
> +#include <linux/of_address.h>
> +#include <linux/of_irq.h>
> +
> +#define GPT_IRQ_EN_REG		0x00
> +#define GPT_IRQ_ENABLE(val)	BIT(val-1)
> +#define GPT_IRQ_ST_REG		0x04
> +#define GPT_IRQ_ACK_REG		0x08
> +#define GPT_IRQ_ACK(val)	BIT(val-1)
> +
> +#define TIMER_CTRL_REG(val)	(0x10 * val)
> +#define TIMER_CTRL_OP(val)	(((val) & 0x3) << 4)
> +#define TIMER_CTRL_OP_ONESHOT	(0)
> +#define TIMER_CTRL_OP_REPEAT	(1)
> +#define TIMER_CTRL_OP_KEEPGO	(2)
> +#define TIMER_CTRL_OP_FREERUN	(3)
> +#define TIMER_CTRL_CLEAR	(2)
> +#define TIMER_CTRL_ENABLE	(1)
> +#define TIMER_CTRL_DISABLE	(0)
> +
> +#define TIMER_CLK_REG(val)	(0x04 + (0x10 * val))
> +#define TIMER_CLK_SRC(val)	(((val) & 0x1) << 4)
> +#define TIMER_CLK_SRC_SYS13M	(0)
> +#define TIMER_CLK_SRC_RTC32K	(1)
> +#define TIMER_CLK_DIV1		(0x0)
> +#define TIMER_CLK_DIV2		(0x1)
> +#define TIMER_CLK_DIV3		(0x2)
> +#define TIMER_CLK_DIV4		(0x3)
> +#define TIMER_CLK_DIV5		(0x4)
> +#define TIMER_CLK_DIV6		(0x5)
> +#define TIMER_CLK_DIV7		(0x6)
> +#define TIMER_CLK_DIV8		(0x7)
> +#define TIMER_CLK_DIV9		(0x8)
> +#define TIMER_CLK_DIV10		(0x9)
> +#define TIMER_CLK_DIV11		(0xA)
> +#define TIMER_CLK_DIV12		(0xB)
> +#define TIMER_CLK_DIV13		(0xC)
> +#define TIMER_CLK_DIV16		(0xD)
> +#define TIMER_CLK_DIV32		(0xE)
> +#define TIMER_CLK_DIV64		(0xF)
> +
> +#define TIMER_CNT_REG(val)	(0x08 + (0x10 * val))
> +#define TIMER_CMP_REG(val)	(0x0C + (0x10 * val))
> +
> +#define GPT_CLK_EVT	1
> +#define GPT_CLK_SRC	2
> +
> +static void __iomem *gpt_base;
> +static u32 ticks_per_jiffy;
> +
> +static void mtk_clkevt_time_stop(u8 timer)
> +{
> +	u32 val =3D readl(gpt_base + TIMER_CTRL_REG(timer));
> +	writel(val & ~TIMER_CTRL_ENABLE, gpt_base + TIMER_CTRL_REG(timer));
> +}
> +
> +static void mtk_clkevt_time_setup(unsigned long delay, u8 timer)
> +{
> +	writel(delay, gpt_base + TIMER_CMP_REG(timer));
> +}
> +
> +static void mtk_clkevt_time_start(bool periodic, u8 timer)
> +{
> +	u32 val;
> +
> +	/* Acknowledge interrupt */
> +	writel(GPT_IRQ_ACK(timer), gpt_base + GPT_IRQ_ACK_REG);
> +
> +	val =3D readl(gpt_base + TIMER_CTRL_REG(timer));
> +
> +	/* Clear 2 bit timer operation mode field */
> +	val &=3D ~TIMER_CTRL_OP(0x3);
> +
> +	if (periodic)
> +		val |=3D TIMER_CTRL_OP(TIMER_CTRL_OP_REPEAT);
> +	else
> +		val |=3D TIMER_CTRL_OP(TIMER_CTRL_OP_ONESHOT);
> +
> +	writel(val | TIMER_CTRL_ENABLE | TIMER_CTRL_CLEAR,
> +	       gpt_base + TIMER_CTRL_REG(timer));
> +}
> +
> +static void mtk_clkevt_mode(enum clock_event_mode mode,
> +			      struct clock_event_device *clk)
> +{
> +	mtk_clkevt_time_stop(GPT_CLK_EVT);
> +
> +	switch (mode) {
> +	case CLOCK_EVT_MODE_PERIODIC:
> +		mtk_clkevt_time_setup(ticks_per_jiffy, GPT_CLK_EVT);
> +		mtk_clkevt_time_start(true, GPT_CLK_EVT);
> +		break;
> +	case CLOCK_EVT_MODE_ONESHOT:
> +		mtk_clkevt_time_start(false, GPT_CLK_EVT);
> +		break;
> +	case CLOCK_EVT_MODE_UNUSED:
> +	case CLOCK_EVT_MODE_SHUTDOWN:
> +	default:
> +		/* No more interrupts will occur as source is disabled */
> +		break;
> +	}
> +}
> +
> +static int mtk_clkevt_next_event(unsigned long evt,
> +				   struct clock_event_device *unused)
> +{
> +	mtk_clkevt_time_stop(GPT_CLK_EVT);
> +	mtk_clkevt_time_setup(evt, GPT_CLK_EVT);
> +	mtk_clkevt_time_start(false, GPT_CLK_EVT);
> +
> +	return 0;
> +}
> +
> +static struct clock_event_device mtk_clockevent =3D {
> +	.name =3D "mtk_tick",
> +	.rating =3D 300,
> +	.features =3D CLOCK_EVT_FEAT_PERIODIC | CLOCK_EVT_FEAT_ONESHOT,
> +	.set_mode =3D mtk_clkevt_mode,
> +	.set_next_event =3D mtk_clkevt_next_event,
> +};
> +
> +
> +static irqreturn_t mtk_timer_interrupt(int irq, void *dev_id)
> +{
> +	struct clock_event_device *evt =3D dev_id;
> +
> +	/* Acknowledge timer0 irq */
> +	writel(GPT_IRQ_ACK(GPT_CLK_EVT), gpt_base + GPT_IRQ_ACK_REG);
> +	evt->event_handler(evt);
> +
> +	return IRQ_HANDLED;
> +}
> +
> +static void mtk_timer_global_reset(void)
> +{
> +	/* Disable all interrupts */
> +	writel(0x0, gpt_base + GPT_IRQ_EN_REG);
> +	/* Acknowledge all interrupts */
> +	writel(0x3f, gpt_base + GPT_IRQ_ACK_REG);
> +}
> +
> +static void mtk_timer_reset(u8 timer)
> +{
> +	writel(TIMER_CTRL_CLEAR | TIMER_CTRL_DISABLE,
> +		gpt_base + TIMER_CTRL_REG(timer));
> +	writel(0x0, gpt_base + TIMER_CMP_REG(timer));
> +}
> +
> +static void __init mtk_timer_init(struct device_node *node)
> +{
> +	struct resource res;
> +	unsigned long rate =3D 0;
> +	struct clk *clk;
> +	int ret, irq;
> +	u32 val;
> +
> +	if (of_address_to_resource(node, 0, &res))
> +		panic("Failed to parse resource\n");
> +
> +	if (!request_mem_region(res.start, resource_size(&res), "mtk-timer"))
> +		panic("Registers are a busy IO resource");
> +
> +	gpt_base =3D ioremap(res.start, resource_size(&res));
> +	if (!gpt_base)
> +		panic("Can't map registers");
> +
> +	irq =3D irq_of_parse_and_map(node, 0);
> +	if (irq <=3D 0)
> +		panic("Can't parse IRQ");
> +
> +	clk =3D of_clk_get(node, 0);
> +	if (IS_ERR(clk))
> +		panic("Can't get timer clock");
> +
> +	clk_prepare_enable(clk);
> +	rate =3D clk_get_rate(clk);
> +
> +	mtk_timer_global_reset();
> +
> +	/* Configure clock source */
> +	mtk_timer_reset(GPT_CLK_SRC);
> +
> +	writel(TIMER_CLK_SRC(TIMER_CLK_SRC_SYS13M) | TIMER_CLK_DIV1,
> +			gpt_base + TIMER_CLK_REG(GPT_CLK_SRC));
> +
> +	writel(TIMER_CTRL_OP(TIMER_CTRL_OP_FREERUN) | TIMER_CTRL_ENABLE,
> +				gpt_base + TIMER_CTRL_REG(GPT_CLK_SRC));
> +
> +	clocksource_mmio_init(gpt_base + TIMER_CNT_REG(GPT_CLK_SRC), node->name,
> +			      rate, 300, 32, clocksource_mmio_readl_up);
> +
> +	ticks_per_jiffy =3D DIV_ROUND_UP(rate, HZ);
> +
> +	/* Configure clock event */
> +	mtk_timer_reset(GPT_CLK_EVT);
> +
> +	writel(TIMER_CLK_SRC(TIMER_CLK_SRC_SYS13M) | TIMER_CLK_DIV1,
> +			gpt_base + TIMER_CLK_REG(GPT_CLK_EVT));
> +	writel(0, gpt_base + TIMER_CMP_REG(GPT_CLK_EVT));
> +
> +	writel(TIMER_CTRL_OP(TIMER_CTRL_OP_REPEAT) | TIMER_CTRL_ENABLE,
> +			gpt_base + TIMER_CTRL_REG(GPT_CLK_EVT));
> +
> +	ret =3D request_irq(irq, mtk_timer_interrupt, IRQF_TIMER | IRQF_IRQPOLL,
> +				"mtk_timer", &mtk_clockevent);
> +	if (ret)
> +		pr_warn("failed to setup irq %d\n", irq);
> +
> +	/* Enable timer0 interrupt */
> +	val =3D readl(gpt_base + GPT_IRQ_EN_REG);
> +	writel(val | GPT_IRQ_ENABLE(GPT_CLK_EVT), gpt_base + GPT_IRQ_EN_REG);
> +
> +	clockevents_config_and_register(&mtk_clockevent, rate, 0x3,
> +					0xffffffff);

You should also set the cpumask and irq fields in mtk_clockevent.

Maxime

--=20
Maxime Ripard, Free Electrons
Embedded Linux, Kernel and Android engineering
http://free-electrons.com

--QL7C2Vd2zSGwwTJM
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.14 (GNU/Linux)

iQIcBAEBAgAGBQJTbwBmAAoJEBx+YmzsjxAgsVQQAJCD1X9iX1eLjaCDbkythLGw
8H4w0uSThcR+01YbDWUM6XOssX4/gFYmP/lNSXjjQFJDboGPwQ9gVeTWaR28pxGf
OYX8+C/MOgheXo9V29Tfx6Xb9jEnQkE9GTv1XUBTD9i5i2IdNy4ek9G2FIQhWLKq
BDZuHBRGMeBEN5b+oiPOZL9wkdSdLxSkXpt/8XAbFmriLU10lu375qTtQ2YtXUjE
O04CqdPp/28pDozkq9pG6vhzLkFW6eGPGoM3PKZYw2AFunZQxK5f4S910PzxSnCY
iXI7sixgq/X38bpsRkskFx6m/9oib/sfG00lKGwKH4rOonk+uSNbUpYsj7uV9y2C
co+ez4m1HNB5IWFxuuA8onp1mnkdy+F61Vb1sYLJTMTGMEQwAFcEukLdpKAWP4qS
DChEZrkhK8nNO4G3V/IvfRhws+ePnseAggjc6P2n1gwD1uPzur49u+c682mRMUZN
TLec2J6DN5zXkK6tw9oPTgFlM9t5HaP+1YlvzWkFWfQsgpAvAtDsl/cKUEDlgyFd
PQovb3OvSbEUNsS7+a9rbGZJN/dv9PRd1qu4ya6vt5W7LWWjmH8pv+xWTYWins1c
1jKrNpItn4D4bCZTwy4B4BR4vsq3YbCo1em40yHQFbQKed+CtiR+hOG6fE5D7X+A
IdDBxYTxojs34/XeAhcW
=h3C5
-----END PGP SIGNATURE-----

--QL7C2Vd2zSGwwTJM--
