Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933291Ab3LEAmA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Dec 2013 19:42:00 -0500
Received: from www.linutronix.de ([62.245.132.108]:39942 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933207Ab3LEAl5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Dec 2013 19:41:57 -0500
Date: Thu, 5 Dec 2013 01:41:53 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: Neil Zhang <zhangwm@marvell.com>
cc: mark.rutland@arm.com, haojian.zhuang@gmail.com,
        LKML <linux-kernel@vger.kernel.org>, devicetree@vger.kernel.org,
        LAK <linux-arm-kernel@lists.infradead.org>
Subject: ARM: gic_arch_extn (Was: [PATCH v3] irqchip: mmp: add dt support
 for wakeup)
In-Reply-To: <alpine.DEB.2.02.1312042234190.30673@ionos.tec.linutronix.de>
Message-ID: <alpine.DEB.2.02.1312042347350.30673@ionos.tec.linutronix.de>
References: <1386159214-31483-1-git-send-email-zhangwm@marvell.com> <alpine.DEB.2.02.1312042234190.30673@ionos.tec.linutronix.de>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

@all who feel responsible for gic_arch_extn

On Wed, 4 Dec 2013, Thomas Gleixner wrote:
> I'm going to reply in a separate mail on this, because you have
> brought this to my attention, but you are not responsible in the first
> place for this brainfart.

Who came up with that gic_arch_extn concept in the first place?

It forces all GIC hotpath users to do:

   hotpath_function(x)
   {
   	do_hotpath_work();

	if (random_arch_wants_crap())
	   random_arch_crap(x);
   }

Brilliant design that. Even more so that we have only a few lonely
lusers of this brainfart. Lets look at these ordered by the output of

$ git grep -l gic_arch_extn

arch/arm/mach-imx/gpc.c
arch/arm/mach-omap2/omap-wakeupgen.c
arch/arm/mach-shmobile/intc-sh73a0.c
arch/arm/mach-shmobile/setup-r8a7779.c
arch/arm/mach-tegra/irq.c
arch/arm/mach-ux500/cpu.c

So looking at the first instance makes me go berserk already 

arch/arm/mach-imx/gpc.c

  This has the following repeating pattern:

  imx_gpc_irq_XXX(struct irq_data *d)
  {
	if (d->irq < 32)
	   return;  

  So the person who comitted that crime did notice, that the upper
  layer calls this for all interrupts even those < 32, but he could
  not be arsed to sit down and avoid that.

  Even worse this resulted in the following totaly misleading comment
  above the irq number < 32 check:

  	/* Sanity check for SPI irq */
	if (d->irq < 32)

  This has nothing to do with sanity.

       A sanity check is applied in case that something is expected to
       be always correct, but where we want to catch the corner case
       which we did not imagine yet.

  So what is this (d->irq < 32) check about?

      It's a proof of incompetence because the only lame excuse of
      implementing this nonsense is:

	 /*
	  * We are lazy and do that check on all irqs, but we could
	  * avoid that if we would register a different irq_chip for
	  * these irq lines.
	  */

And I really stop here, because all other places using that nonsense
are more or less equally braindamaged.

I leave that as a an exercise to those who are responsible for the
initial implementation of gic_arch_extn and those who blindly used it.

FYI, this made me even more alert of drivers/irqchip/ being used as a
dump ground for random nonsense. It's on my high prio watch list now
and you better get your gear together and clean up the mess before I
go berserk on you.

Non-Subtle-Hint: Get rid of gic_arch_extn

Thanks,

	tglx
