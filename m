Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751987Ab3LJV6L (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Dec 2013 16:58:11 -0500
Received: from moutng.kundenserver.de ([212.227.17.10]:62872 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751834Ab3LJV6I (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Dec 2013 16:58:08 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: Sergei Ianovich <ynvich@gmail.com>
Subject: Re: [PATCH 02/11] arm: pxa27x: support ICP DAS LP-8x4x
Date: Tue, 10 Dec 2013 22:57:33 +0100
User-Agent: KMail/1.12.2 (Linux/3.8.0-22-generic; KDE/4.3.2; x86_64; ; )
Cc: Linus Walleij <linus.walleij@linaro.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Eric Miao <eric.y.miao@gmail.com>,
        Russell King <linux@arm.linux.org.uk>,
        Haojian Zhuang <haojian.zhuang@gmail.com>,
        Olof Johansson <olof@lixom.net>, Daniel Mack <zonque@gmail.com>
References: <1385879185-22455-1-git-send-email-ynvich@gmail.com> <CACRpkdYF-O6Qgjue6x+R6fVuSXSyO4YHw1meusuyQhtSA9PnvQ@mail.gmail.com> <1386706817.7152.254.camel@host5.omatika.ru>
In-Reply-To: <1386706817.7152.254.camel@host5.omatika.ru>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201312102257.33942.arnd@arndb.de>
X-Provags-ID: V02:K0:/KGLozxvWNN4ZAXls3JuCqpvld5UpMRhcm4Pv8lmHh8
 Pc4CTISlW5ZfI/QdksQG5SRi6nscjU1nwx7QjGOIFrrGaMGa3R
 S72K4QKqIIav4YE3NqKIDZTOr1Mlh5SXAXWuFWzr6g5mylDA4k
 VOrisaTlCkvmun+AMvoMOBqjNRSh+y1kyNP0YUmCqtcz5zDo/V
 sSlQTbccumEAWGbsY98KR4+9lVXkaGg4qd4L+1TafMpnP+e+s1
 HBpDI50fpAUPDR4XW1iCPdKIaxFjQEYwr/i/jHMFOQ1o7Z2mdj
 lSVATwzGXk7/lUWs+mF+TpA7JSO2XuHJIuZlCdgl939J5F9WxR
 jy9Kt11d0SSADBYqQ0ps=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 10 December 2013, Sergei Ianovich wrote:
> On Tue, 2013-12-10 at 13:33 +0100, Linus Walleij wrote:
> > On Fri, Dec 6, 2013 at 6:14 PM, Arnd Bergmann <arnd@arndb.de> wrote:
> > > On Friday 06 December 2013, Sergei Ianovich wrote:
> > >> On Fri, 2013-12-06 at 01:40 +0100, Arnd Bergmann wrote:
> > >>
> > >> > > +
> > >> > > +static struct irq_chip lp8x4x_irq_chip = {
> > >> > > +     .name                   = "FPGA",
> > >> > > +     .irq_ack                = lp8x4x_ack_irq,
> > >> > > +     .irq_mask               = lp8x4x_mask_irq,
> > >> > > +     .irq_unmask             = lp8x4x_unmask_irq,
> > >> > > +};
> > >> >
> > >> > Please try to move the irqchip code to drivers/irqchip/.
> > >>
> > >> CONFIG_IRQCHIP depends on CONFIG_OF_IRQ which in turn depends on Open
> > >> Firmware.
> > >
> > > Hmm, I wonder if we should try to change Kconfig then. Let's leave it
> > > alone for now, maybe Linus Walleij has some comments since he has
> > > been looking into moving drivers out in the past.
> > 
> > I don't get this, if the subarch has deps in place for IRQCHIP and
> > OF_IRQ just move the implementation to drivers/irqchip/foo.c
> > edit drivers/irqchip/Makefile to compile the file for ARCH_FOO.
> > What would the problem be? It's not like having the irqchip in the
> > object is optional...
> 
> This chip is used only of one machine and only required for
> machine-special devices. If those devices are not selected, the chip
> will just waist memory.

It should be possible to make it a loadable module, with deferred
probing etc. You wouldn't use IRQCHIP_DECLARE() for this though,
but instead have a platform driver that sets up the irq domain.

It probably makes sense to have a single driver file for the
FPGA device that does this, and only split out the other devices
from it that consume the irqs.

> > Another way is to create a separate Kconfig entry for it in
> > drivers/irqchip/Kconfig if you want the set-up to be more
> > distributed, but that is usually just done when the irqchip is
> > used on more than one platform.
> 
> Please consult, how to approach this driver using device tree. If I
> assign an "interrupts" property in the node, and the property will point
> to pxa-gpio interrupt controller using a phandle, is there a guaranty
> that my device will be probed later than pxa-gpio interrupt controller?

Yes, the interrupt controllers get probed in the right order based
on their "interrupt-parent" properties, starting with the root
controller.

If you have a platform driver rather than IRQCHIP_DECLARE(), that gets
initialized after all IRQCHIP_DECLARE() calls, so it's not a problem.

If both the gpio chip and the fpga are loadable modules, it's still
fine, but the probe() function for the fpga needs to call
irq_of_parse_and_map() to get the parent IRQ and bail out of
-EPROBE_DEFER if it gets this error while trying to map the
gpio IRQ.

	Arnd
