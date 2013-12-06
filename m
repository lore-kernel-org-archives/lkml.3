Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758103Ab3LFROb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Dec 2013 12:14:31 -0500
Received: from moutng.kundenserver.de ([212.227.17.8]:53136 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755025Ab3LFRO3 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Dec 2013 12:14:29 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: Sergei Ianovich <ynvich@gmail.com>
Subject: Re: [PATCH 02/11] arm: pxa27x: support ICP DAS LP-8x4x
Date: Fri, 6 Dec 2013 18:14:15 +0100
User-Agent: KMail/1.12.2 (Linux/3.8.0-22-generic; KDE/4.3.2; x86_64; ; )
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Eric Miao <eric.y.miao@gmail.com>,
        Russell King <linux@arm.linux.org.uk>,
        Haojian Zhuang <haojian.zhuang@gmail.com>,
        Olof Johansson <olof@lixom.net>,
        Linus Walleij <linus.walleij@linaro.org>,
        Daniel Mack <zonque@gmail.com>
References: <1385879185-22455-1-git-send-email-ynvich@gmail.com> <201312060140.10376.arnd@arndb.de> <1386347911.7152.70.camel@host5.omatika.ru>
In-Reply-To: <1386347911.7152.70.camel@host5.omatika.ru>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-Id: <201312061814.15730.arnd@arndb.de>
X-Provags-ID: V02:K0:I9iTahQl0VbGumwepaGMWfeEGS1QMj3VR7Nf1/wTPiT
 o9AAtN79fBAH2hOAJdCmPkTTedAcp2PZf4AbmPY7prXjZVUFLd
 P1+j5Hx6qpyIE04BmltsHEs6+G3gwcivQ1c4WoV6yQG1O7ZRNq
 OB49Qv5IHWhN8y7wDq+7gHqfrxc4IqLNTaN2WN96kDdlS3KLRR
 X4icIf234NFQNtnzMONvseXutVzkoWDHfK3y+6Cgd2RlioeJkz
 1io8ffT47q324kl1fUUbmUQzUswGIg49J0x29pD9zmH3QFEQSJ
 PyQcVbQtzD72jm7fHGpnPrCnfefBMsK4XVgl+7CLEiyeM4rzdD
 EKSxz5bOaHbDHTi6Iu6M=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 06 December 2013, Sergei Ianovich wrote:
> On Fri, 2013-12-06 at 01:40 +0100, Arnd Bergmann wrote:
> 
> > Ideally we want shared defconfigs where you enable multiple (or all) pxa boards
> > at once and end up with a kernel that works on all of them.
> > 
> > For most other platforms the goal is even to have a shared defconfig across
> > SoC families, but PXA is one of the exceptions that I would make because
> > it is both old and rather different from even the ARM9 or Marvell Feroceon
> > based SoCs.
> 
> There is probably no in point sharing this config with most other
> devices on PXA2xx SoC. This device is an industrial PC. Its config needs
> to be optimized for low latency even by the cost of greater power
> consumption. It is not supposed to run on batteries or enter any low
> power mode anyway.

Ok, I see. Note that while most of them are mobile, I believe there are
a couple of pxa boards that are in the same category as yours.

Unfortunately, PXA already has most defconfigs than any other platform (25
at the moment) and I would like to see that reduced in the future if
I can find someone to do the work.

> > we try to avoid hardwired virtual addresses entirely and instead use platform
> > device resources, but I realize that there are limits to how far you get with
> > that. Please make an effort to convert as many parts of the FPGA into platform
> > devices with regular resources, but know that we would not enforce this as
> > strictly as we do for new platforms.
> > 
> > > +
> > > +static struct irq_chip lp8x4x_irq_chip = {
> > > +     .name                   = "FPGA",
> > > +     .irq_ack                = lp8x4x_ack_irq,
> > > +     .irq_mask               = lp8x4x_mask_irq,
> > > +     .irq_unmask             = lp8x4x_unmask_irq,
> > > +};
> > 
> > Please try to move the irqchip code to drivers/irqchip/.
> 
> CONFIG_IRQCHIP depends on CONFIG_OF_IRQ which in turn depends on Open
> Firmware.

Hmm, I wonder if we should try to change Kconfig then. Let's leave it
alone for now, maybe Linus Walleij has some comments since he has
been looking into moving drivers out in the past.

> The device is shipped with such a flash device partition table, which
> makes migration to device tree rather difficult. The partition for
> U-Boot is just 256kiB. This is a high aim already. U-Boot needs to be
> compiled without command line help and USB support to fit into this
> size. Otherwise the main flash needs to be repartitioned.
> 
> Could it be acceptable to accept the device without device tree support?

>From my point of view it's ok, but I'll leave that up to Daniel Mack,
since he has been doing all the work on PXA migration to DT lately.
I believe with his work it won't actually be a problem to do DT.

> If so, FPGA irqchip could remain in the machine source file. It is
> highly unlikely, it will ever be reused. In this case all fixed virtual
> address definitions could be moved to the machine source file. The file
> will be the only place where LP8X4X_FPGA_VIRT is used directly.

That sounds reasonable to me as well.

	Arnd
