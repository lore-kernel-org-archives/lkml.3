Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760270Ab3LIBrh (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Dec 2013 20:47:37 -0500
Received: from moutng.kundenserver.de ([212.227.126.186]:51293 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760118Ab3LIBrg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Dec 2013 20:47:36 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: Sergei Ianovich <ynvich@gmail.com>
Subject: Re: [PATCH 9/9] ARM: pxa27x: device tree support ICP DAS LP-8x4x
Date: Mon, 9 Dec 2013 02:47:24 +0100
User-Agent: KMail/1.12.2 (Linux/3.8.0-22-generic; KDE/4.3.2; x86_64; ; )
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Daniel Mack <zonque@gmail.com>, Olof Johansson <olof@lixom.net>,
        Linus Walleij <linus.walleij@linaro.org>,
        Rob Herring <rob.herring@calxeda.com>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Russell King <linux@arm.linux.org.uk>,
        Eric Miao <eric.y.miao@gmail.com>,
        Haojian Zhuang <haojian.zhuang@gmail.com>,
        "open list:OPEN FIRMWARE AND..." <devicetree@vger.kernel.org>
References: <1386348542-9584-1-git-send-email-ynvich@gmail.com> <1386543229-1542-1-git-send-email-ynvich@gmail.com> <1386543229-1542-10-git-send-email-ynvich@gmail.com>
In-Reply-To: <1386543229-1542-10-git-send-email-ynvich@gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201312090247.24978.arnd@arndb.de>
X-Provags-ID: V02:K0:eBq5xqy8M6VGsMY7jdGmrCBN0D+aPqKm7lcrartAfe2
 8LJwcC9fVMAaurpoWg1nvTupUCxFqhhTy0+9W736rKKj5CfTtJ
 qcNK2KmOinK/DqAJ/74QIGq1sfyL/3vQ5bU6mW/5MCjnHyV+zY
 abcRPZfzt/MC9iyGC0QMGTu/vKTrX2drjU3uY5zNvpCmNDbiuF
 qh7lYieszjyHeCsrbEk1KoGCtKXiscoL+U4gsc+RyQ30Bk0/0d
 UNa/CyyYeMGLXZ9wPzM6cgIzrq+qE4be8RrQAwTHQrsdoVqoON
 W7s0P2wTNgSXWvvezTPvh5t7uhAdZQN9DQBPSlzihZn2n15Xl4
 8lYZjqatAAtGZUjV3GOQ=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday 08 December 2013, Sergei Ianovich wrote:
> +
> +#ifdef CONFIG_PXA27x
> +extern void __init pxa27x_dt_init_irq(void);

This is not the right place to put an 'extern' declaration, it should go into
a header file if it's really needed. Ideally you would not need it at all
and just add an IRQCHIP_DECLARE() line into the driver to automatically
probe it.

> +static const struct of_dev_auxdata pxa27x_auxdata_lookup[] __initconst = {
> +	OF_DEV_AUXDATA("mrvl,pxa-uart",		0x40100000, "pxa2xx-uart.0", NULL),
> +	OF_DEV_AUXDATA("mrvl,pxa-uart",		0x40200000, "pxa2xx-uart.1", NULL),
> +	OF_DEV_AUXDATA("mrvl,pxa-uart",		0x40700000, "pxa2xx-uart.2", NULL),
> +	OF_DEV_AUXDATA("mrvl,pxa-uart",		0x41600000, "pxa2xx-uart.3", NULL),
> +	OF_DEV_AUXDATA("marvell,pxa-mmc",	0x41100000, "pxa2xx-mci.0", NULL),
> +	OF_DEV_AUXDATA("intel,pxa27x-gpio",	0x40e00000, "pxa27x-gpio", NULL),
> +	OF_DEV_AUXDATA("marvell,pxa-ohci",	0x4c000000, "pxa27x-ohci", NULL),
> +	OF_DEV_AUXDATA("mrvl,pxa-i2c",		0x40301680, "pxa2xx-i2c.0", NULL),
> +	{}
> +};

I guess these are needed only for clock management purposes at the moment?

> +static void __init pxa27x_init_early(void)
> +{
> +	pxa27x_skip_init();
> +}

I would prefer not to have an init_early function at all, and instead
check "if (of_have_populated_dt())" in pxa27x_init, or to split
that function into two.

> +static const char *pxa27x_dt_board_compat[] __initdata = {
> +	"marvell,pxa27x",
> +	NULL,
> +};
> +
> +#ifdef CONFIG_MACH_LP8X4X
> +static const char *lp8x4x_dt_board_compat[] __initdata = {
> +	"marvell,lp8x4x",
> +	NULL,
> +};

Note that you should not have wildcards in any "compatible" strings.
Just list all the combinations here (pxa270, pxa271, pxa272, and whatever
you need for lp8x4x).

> +static void lp8x4x_restart(enum reboot_mode mode, const char *cmd)
> +{
> +	/* Switch off fast-bus and turbo mode */
> +	asm volatile("mcr       p14, 0, %0, c6, c0, 0" : :
> +			"r"(2));
> +	/* SDRAM hangs on watchdog reset on Marvell PXA270 (erratum 71) */
> +	pxa_restart(REBOOT_SOFT, cmd);
> +}
> +#endif
> +#endif

Since the only difference here is the restart logic, I would prefer here to
have only a single DT_MACHINE_START() and do

static void pxa27x_restart(enum reboot_mode mode, const char *cmd)
{
	/* Switch off fast-bus and turbo mode */
	if (of_machine_is_compatible("marvell,lp8x4x"))
		asm volatile("mcr       p14, 0, %0, c6, c0, 0" : : "r"(2));

	/* SDRAM hangs on watchdog reset on Marvell PXA270 (erratum 71) */
	if (of_machine_is_compatible("marvell,pxa270"))
		pxa_restart(REBOOT_SOFT, cmd);
}

	Arnd
