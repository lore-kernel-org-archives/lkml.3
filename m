Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934181Ab3LIQ0L (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Dec 2013 11:26:11 -0500
Received: from moutng.kundenserver.de ([212.227.17.8]:62565 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933978Ab3LIQ0G (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Dec 2013 11:26:06 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: Sergei Ianovich <ynvich@gmail.com>
Subject: Re: [PATCH 9/9] ARM: pxa27x: device tree support ICP DAS LP-8x4x
Date: Mon, 9 Dec 2013 17:25:45 +0100
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
References: <1386348542-9584-1-git-send-email-ynvich@gmail.com> <201312090247.24978.arnd@arndb.de> <1386602213.7152.180.camel@host5.omatika.ru>
In-Reply-To: <1386602213.7152.180.camel@host5.omatika.ru>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201312091725.46212.arnd@arndb.de>
X-Provags-ID: V02:K0:JgrrARGBFP1A3MfjQVIhlxAqXCeFhTPRsrPNnxZL5E3
 dsp/8QXa1P3f2EEyfrjhwthsqYqAh9ed2/6hgIoyX8kynFUkp3
 gM6H5i5S/VqR/wfu+oeCq1sKj+A7ExPMgJ9qC1Ky/bUaQRaN+3
 HsBcS3edVMnZfY9xawIc3Ce6yHJ+80DOr4HLmutO7JsqDK3p15
 CZjC3DoaTtJYQ2NuxkPco1HI/FyOhlC32wDsIC7BKyx0CjY3dM
 RLDVbxnrvkeWS4wSo8cL74mr5cUZB36nRnevQ38gsIQPkQwzTU
 LwWqvpGQZ8NCbkdKqLaK+KpqAEiijuXR0lS+I0HIaycbJuKeBV
 NjJ0PssGLqBKKtrKP73M=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 09 December 2013, Sergei Ianovich wrote:
> On Mon, 2013-12-09 at 02:47 +0100, Arnd Bergmann wrote:
> > On Sunday 08 December 2013, Sergei Ianovich wrote:
> > > +
> > > +#ifdef CONFIG_PXA27x
> > > +extern void __init pxa27x_dt_init_irq(void);
> 
> > This is not the right place to put an 'extern' declaration, it should go into
> > a header file if it's really needed. Ideally you would not need it at all
> > and just add an IRQCHIP_DECLARE() line into the driver to automatically
> > probe it.
> 
> I thought I moved it to the header in patch 6/9. I'll just drop the
> line.

Ok.

> IRQCHIP_DECLARE isn't used on pxa_internal_irq_chip in
> arch/arm/mach-pxa/irq.c, probably for a reason.

Yes, you can only use it from drivers in drivers/irqchip/.

> > > +static void __init pxa27x_init_early(void)
> > > +{
> > > +     pxa27x_skip_init();
> > > +}
> > 
> > I would prefer not to have an init_early function at all, and instead
> > check "if (of_have_populated_dt())" in pxa27x_init, or to split
> > that function into two.
> 
> Device tree is populated in init_machine. However, pxa27x_init is
> executed before via postcore_initcall. 

The device tree is populated in unflatten_device_tree(), which gets
called before init_early.

> The only chance to run before is
> to use init_early. What's wrong with this function?

I generally dislike adding any platform specific hooks to "early"
functions, i.e. stuff that runs before init_machine, and I'm pretty
sure it's not necessary here.

> > static void pxa27x_restart(enum reboot_mode mode, const char *cmd)
> > {
> >         /* Switch off fast-bus and turbo mode */
> >         if (of_machine_is_compatible("marvell,lp8x4x"))
> >                 asm volatile("mcr       p14, 0, %0, c6, c0, 0" : : "r"(2));
> > 
> >         /* SDRAM hangs on watchdog reset on Marvell PXA270 (erratum 71) */
> >         if (of_machine_is_compatible("marvell,pxa270"))
> >                 pxa_restart(REBOOT_SOFT, cmd);
> > }
> 
> Nice tip, thanks. I've spent 30 minutes to find something like that.
> 
> If the device has fast SDRAM, which can reset itself in up to 8ms, the
> device is not affected by E71. So both checks are per-device.

Ok.

	Arnd
