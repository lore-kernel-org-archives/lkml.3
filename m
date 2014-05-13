Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753001AbaEMFzG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 May 2014 01:55:06 -0400
Received: from top.free-electrons.com ([176.31.233.9]:35236 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752430AbaEMFzD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 May 2014 01:55:03 -0400
Date: Tue, 13 May 2014 07:54:05 +0200
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
Subject: Re: [PATCH v3 1/6] clocksource: Add support for the Mediatek SoCs
Message-ID: <20140513055405.GA3348@lukather>
References: <1399938570-11356-1-git-send-email-matthias.bgg@gmail.com>
 <1399938570-11356-2-git-send-email-matthias.bgg@gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="sdtB3X0nJg68CQEu"
Content-Disposition: inline
In-Reply-To: <1399938570-11356-2-git-send-email-matthias.bgg@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--sdtB3X0nJg68CQEu
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, May 13, 2014 at 01:49:25AM +0200, Matthias Brugger wrote:
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
>  drivers/clocksource/mtk_timer.c | 263 ++++++++++++++++++++++++++++++++++=
++++++
>  3 files changed, 268 insertions(+)
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
> index 0000000..4b88065
> --- /dev/null
> +++ b/drivers/clocksource/mtk_timer.c
> @@ -0,0 +1,263 @@
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
> +#include <linux/slab.h>
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
> +
> +
> +struct mtk_clock_event_device {
> +	void __iomem *gpt_base;
> +	u32 ticks_per_jiffy;
> +	struct clock_event_device dev;
> +};
> +
> +static inline struct mtk_clock_event_device *to_mtk_clk(
> +				struct clock_event_device *c)
> +{
> +	return container_of(c, struct mtk_clock_event_device, dev);
> +}
> +
> +static void mtk_clkevt_time_stop(struct mtk_clock_event_device *evt, u8 =
timer)
> +{
> +	u32 val =3D readl(evt->gpt_base + TIMER_CTRL_REG(timer));
> +	writel(val & ~TIMER_CTRL_ENABLE, evt->gpt_base +
> +			TIMER_CTRL_REG(timer));
> +}
> +
> +static void mtk_clkevt_time_setup(struct mtk_clock_event_device *evt,
> +				unsigned long delay, u8 timer)
> +{
> +	writel(delay, evt->gpt_base + TIMER_CMP_REG(timer));
> +}
> +
> +static void mtk_clkevt_time_start(struct mtk_clock_event_device *evt,
> +		bool periodic, u8 timer)
> +{
> +	u32 val;
> +
> +	/* Acknowledge interrupt */
> +	writel(GPT_IRQ_ACK(timer), evt->gpt_base + GPT_IRQ_ACK_REG);
> +
> +	val =3D readl(evt->gpt_base + TIMER_CTRL_REG(timer));
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
> +	       evt->gpt_base + TIMER_CTRL_REG(timer));
> +}
> +
> +static void mtk_clkevt_mode(enum clock_event_mode mode,
> +				struct clock_event_device *clk)
> +{
> +	struct mtk_clock_event_device *evt =3D to_mtk_clk(clk);
> +
> +	mtk_clkevt_time_stop(evt, GPT_CLK_EVT);
> +
> +	switch (mode) {
> +	case CLOCK_EVT_MODE_PERIODIC:
> +		mtk_clkevt_time_setup(evt, evt->ticks_per_jiffy, GPT_CLK_EVT);
> +		mtk_clkevt_time_start(evt, true, GPT_CLK_EVT);
> +		break;
> +	case CLOCK_EVT_MODE_ONESHOT:
> +		mtk_clkevt_time_start(evt, false, GPT_CLK_EVT);
> +		break;
> +	case CLOCK_EVT_MODE_UNUSED:
> +	case CLOCK_EVT_MODE_SHUTDOWN:
> +	default:
> +		/* No more interrupts will occur as source is disabled */
> +		break;
> +	}
> +}
> +
> +static int mtk_clkevt_next_event(unsigned long event,
> +				   struct clock_event_device *clk)
> +{
> +	struct mtk_clock_event_device *evt =3D to_mtk_clk(clk);
> +
> +	mtk_clkevt_time_stop(evt, GPT_CLK_EVT);
> +	mtk_clkevt_time_setup(evt, event, GPT_CLK_EVT);
> +	mtk_clkevt_time_start(evt, false, GPT_CLK_EVT);
> +
> +	return 0;
> +}
> +
> +static irqreturn_t mtk_timer_interrupt(int irq, void *dev_id)
> +{
> +	struct mtk_clock_event_device *evt =3D dev_id;
> +
> +	/* Acknowledge timer0 irq */
> +	writel(GPT_IRQ_ACK(GPT_CLK_EVT), evt->gpt_base + GPT_IRQ_ACK_REG);
> +	evt->dev.event_handler(&evt->dev);
> +
> +	return IRQ_HANDLED;
> +}
> +
> +static void mtk_timer_global_reset(struct mtk_clock_event_device *evt)
> +{
> +	/* Disable all interrupts */
> +	writel(0x0, evt->gpt_base + GPT_IRQ_EN_REG);
> +	/* Acknowledge all interrupts */
> +	writel(0x3f, evt->gpt_base + GPT_IRQ_ACK_REG);
> +}
> +
> +static void mtk_timer_reset(struct mtk_clock_event_device *evt, u8 timer)
> +{
> +	writel(TIMER_CTRL_CLEAR | TIMER_CTRL_DISABLE,
> +		evt->gpt_base + TIMER_CTRL_REG(timer));
> +	writel(0x0, evt->gpt_base + TIMER_CMP_REG(timer));
> +}
> +
> +static void __init mtk_timer_init(struct device_node *node)
> +{
> +	struct mtk_clock_event_device *evt;
> +	struct resource res;
> +	unsigned long rate =3D 0;
> +	struct clk *clk;
> +	int ret;
> +	u32 val;
> +
> +	evt =3D kzalloc(sizeof(*evt), GFP_KERNEL);
> +	if (!evt)
> +		panic("Can't allocate mtk clock event driver struct");
> +
> +	evt->dev.name =3D "mtk_tick";
> +	evt->dev.rating =3D 300;
> +	evt->dev.features =3D CLOCK_EVT_FEAT_PERIODIC | CLOCK_EVT_FEAT_ONESHOT;
> +	evt->dev.set_mode =3D mtk_clkevt_mode;
> +	evt->dev.set_next_event =3D mtk_clkevt_next_event;
> +	evt->dev.cpumask =3D cpu_all_mask;

cpu_possible_mask would probably be a better fit. And you still forgot
to set the irq field of this struct.

Maxime

--=20
Maxime Ripard, Free Electrons
Embedded Linux, Kernel and Android engineering
http://free-electrons.com

--sdtB3X0nJg68CQEu
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJTcbN9AAoJEBx+YmzsjxAguF8QAIXKmsZsetM9zWlc3NaoxcRo
mk62Gye3vVA39IdGOf7gVUtao5X2T2je8Du5DGfWhe2cNtRZrhhZGrFnxn2mxnn5
vSu0ieb041NZp+3J8av3CQBog6XWgJyT4nKHZ6rmrx67UxkZLvf9YaKOEuoKwAuP
njb45BVE70TCOyitMi7vk0J/xX4q1jswvONTJZz2LiNJlIasSXil7u4pDDnXT5v7
y5fVqoLZmdNcK4tDyqtlKZUX8OdLh9/biktIaTuQO28PnjpZjLP/g8qeoFtppoFo
akvWpssl1JU9UzBWZ3bsFJZHeBnmWCo1ebyrLqkFj/sGsx3wIx79ZQHYuHtc+JAX
04mLajqdssIziYgtMPrFgPPKMEU1Ivs7dV5LOdJ+33Zh83opluKcPWP1Da6DtOOC
zrZkmB3TR1f0WJl9AU2Sb7WNNRb6O5Rb8nhxROGdz2P28pALF7T6bMNhwnJlt1ee
rKtgJviC0psCqqtCuIOEwIgJjO4ZsCPmZWBs8DfywbKlPK9MpGQFUooolIrbvHu6
s2kY41rH1EQbqIj/PsAw9nS/sSiopRN8VOBCH79sBznxnGesKmg4kS8BBWGlR+CI
T7KlwsWC94hZdgW3eKioNHbOOFelT62IkQB52hrEbBba//qQ/82IStw+/215J3oh
KopDAko7k2hh23H238Mz
=qL8A
-----END PGP SIGNATURE-----

--sdtB3X0nJg68CQEu--
