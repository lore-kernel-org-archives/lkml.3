Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751761AbaLRAdT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Dec 2014 19:33:19 -0500
Received: from kirsty.vergenet.net ([202.4.237.240]:59995 "EHLO
	kirsty.vergenet.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751120AbaLRAdR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Dec 2014 19:33:17 -0500
Date: Thu, 18 Dec 2014 09:33:12 +0900
From: Simon Horman <horms@verge.net.au>
To: Marc Zyngier <marc.zyngier@arm.com>
Cc: Geert Uytterhoeven <geert+renesas@glider.be>,
        Magnus Damm <magnus.damm@gmail.com>,
        Yingjoe Chen <yingjoe.chen@mediatek.com>,
        Jason Cooper <jason@lakedaemon.net>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-sh@vger.kernel.org" <linux-sh@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] ARM: shmobile: r8a7740: Instantiate GIC from C board
 code in legacy builds
Message-ID: <20141218003312.GE1421@verge.net.au>
References: <1418823642-28154-1-git-send-email-geert+renesas@glider.be>
 <54919119.8030208@arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <54919119.8030208@arm.com>
Organisation: Horms Solutions Ltd.
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 17, 2014 at 02:20:09PM +0000, Marc Zyngier wrote:
> On 17/12/14 13:40, Geert Uytterhoeven wrote:
> > As of commit 9a1091ef0017c40a ("irqchip: gic: Support hierarchy irq
> > domain."), armadillo-legacy hangs during boot with:
> > 
> >      sh-tmu.0: ch0: used for clock events
> >      sh-tmu.0: ch0: used for periodic clock events
> >      sh-tmu.0: ch0: failed to request irq 230
> >      sh-tmu.0: ch1: used as clock source
> >      sh-cmt-48.1: ch0: failed to request irq 90
> >      sh-cmt-48.1: ch0: registration failed
> >     earlytimer: unable to probe sh-cmt-48 early.
> >     Calibrating delay loop...
> > 
> > This happens because the IRQ numbers of the GIC are now virtual, and no
> > longer match the hardcoded hardware IRQ numbers in the platform board
> > code.
> > To fix this, instantiate the GIC from platform board code when compiling
> > a legacy kernel, like is done on sh73a0 for kzm9g-legacy.
> 
> Ah, that explains why kzm9g-legacy didn't explode in -next...
> 
> > Signed-off-by: Geert Uytterhoeven <geert+renesas@glider.be>
> > ---
> >  arch/arm/mach-shmobile/setup-r8a7740.c | 7 +++++++
> >  1 file changed, 7 insertions(+)
> > 
> > diff --git a/arch/arm/mach-shmobile/setup-r8a7740.c b/arch/arm/mach-shmobile/setup-r8a7740.c
> > index 79ad93dfdae4ee70..d191cf4197313482 100644
> > --- a/arch/arm/mach-shmobile/setup-r8a7740.c
> > +++ b/arch/arm/mach-shmobile/setup-r8a7740.c
> > @@ -800,7 +800,14 @@ void __init r8a7740_init_irq_of(void)
> >  	void __iomem *intc_msk_base = ioremap_nocache(0xe6900040, 0x10);
> >  	void __iomem *pfc_inta_ctrl = ioremap_nocache(0xe605807c, 0x4);
> >  
> > +#ifdef CONFIG_ARCH_SHMOBILE_LEGACY
> > +	void __iomem *gic_dist_base = ioremap_nocache(0xc2800000, 0x1000);
> > +	void __iomem *gic_cpu_base = ioremap_nocache(0xc2000000, 0x1000);
> > +
> > +	gic_init(0, 29, gic_dist_base, gic_cpu_base);
> > +#else
> >  	irqchip_init();
> > +#endif
> >  
> >  	/* route signals to GIC */
> >  	iowrite32(0x0, pfc_inta_ctrl);
> > 
> 
> Hopefully we'll be able to move away from this kind of thing at some
> point. Until then:
> 
> Acked-by: Marc Zyngier <marc.zyngier@arm.com>

Hi Marc,

I believe that is in progress.

As I understand things the plan is to move away from this when
multiplatform support for the r8a7740 and the Armadillo800-EVM board are
complete. And thus we can remove legacy-C support for that SoC and board.
Lots of deletions!

Geert,

can I confirm that you would like me to pick this up - there are a lot of
changes flying around at the moment?  If so would you like it considered as
a fix for v3.19 and stable? If so I will need some information about what
patch introduced the problem in which release. If not can you state why?

The reason for requesting such information is so that I can pass it on to
the ARM SoC maintainers so it is clear to them how to handle the patch and
why.
