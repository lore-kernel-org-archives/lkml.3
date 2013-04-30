Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759158Ab3D3C0A (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Apr 2013 22:26:00 -0400
Received: from kirsty.vergenet.net ([202.4.237.240]:57978 "EHLO
	kirsty.vergenet.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758783Ab3D3CZ7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Apr 2013 22:25:59 -0400
Date: Tue, 30 Apr 2013 11:25:55 +0900
From: Simon Horman <horms@verge.net.au>
To: Arnd Bergmann <arnd@arndb.de>
Cc: Kuninori Morimoto <kuninori.morimoto.gx@renesas.com>,
        Bastian Hecht <hechtb+renesas@gmail.com>, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH 03/21] ARM: shmobile: don't call irqchip_init
 unconditionally
Message-ID: <20130430022555.GB24214@verge.net.au>
References: <1366910944-3033663-1-git-send-email-arnd@arndb.de>
 <1366910944-3033663-4-git-send-email-arnd@arndb.de>
 <20130426004835.GA20070@verge.net.au>
 <201304291649.08084.arnd@arndb.de>
 <20130430015840.GG22535@verge.net.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130430015840.GG22535@verge.net.au>
Organisation: Horms Solutions Ltd.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 30, 2013 at 10:58:40AM +0900, Simon Horman wrote:
> On Mon, Apr 29, 2013 at 04:49:07PM +0200, Arnd Bergmann wrote:
> > On Friday 26 April 2013, Simon Horman wrote:
> > > > diff --git a/arch/arm/mach-shmobile/intc-r8a7740.c b/arch/arm/mach-shmobile/intc-r8a7740.c
> > > > index 8871f77..5dc57f1 100644
> > > > --- a/arch/arm/mach-shmobile/intc-r8a7740.c
> > > > +++ b/arch/arm/mach-shmobile/intc-r8a7740.c
> > > > @@ -53,14 +53,23 @@ static void __init r8a7740_init_irq_common(void)
> > > >  
> > > >  void __init r8a7740_init_irq_of(void)
> > > >  {
> > > > +     if (!IS_ENABLED(CONFIG_OF))
> > > > +             return;
> > > > +
> > > 
> > > In other parts of the shmobile I believe that such code is
> > > guarded by #ifdef CONFIG_OF and I believe not guarding this code in
> > > some way was an oversight.
> > > 
> > > The above change seems fine to me.
> > 
> > Ok. The change that broke the code is only present in linux-next from
> > one of your trees, but is not in arm-soc. Could you include the change
> > in your tree, either by folding into one of your patches or adapting
> > my patch appropriately?
> 
> Yes, or of course. I'll queue-up your patch with
> the second hunk (below) removed.
> 
> > > > +
> > > > +     gic_dist_base = ioremap_nocache(0xc2800000, 0x1000);
> > > > +     gic_cpu_base = ioremap_nocache(0xc2000000, 0x1000);
> > > >  
> > > >       /* initialize the Generic Interrupt Controller PL390 r0p0 */
> > > >       gic_init(0, 29, gic_dist_base, gic_cpu_base);
> > > 
> > > This one seems broken as the armadillo800eva board currently uses
> > > it to initialise GIC even if CONFIG_ATAGS is not defined.
> > > 
> > > I did test the above change on the armadillo800eva board
> > > with the above change and CONFIG_ATAGS disabled, the result was
> > > a boot failure. With the change reverted booting seems fine.
> > 
> > Yes, I see my mistake now. The second change was clearly wrong
> > as this function is also used for DT boards, not for ATAGS boards.
> > 
> > 	Arnd

I have queued-up the following in the soc-r8a7740 branch of the
renesas tree and will push it shortly. It should subsequently arrive
in linux-next.

>From ea19ad39e1d2b095fe867103fdf7c8dd8240a832 Mon Sep 17 00:00:00 2001
From: Arnd Bergmann <arnd@arndb.de>
Date: Thu, 25 Apr 2013 19:28:46 +0200
Subject: [PATCH] ARM: shmobile: don't call irqchip_init unconditionally

The irqchip_init function is only available when building
with CONFIG_OF enabled, which causes this build failure for
bonito_defconfig:

arch/arm/mach-shmobile/built-in.o: In function `r8a7740_init_irq_of':
:(.init.text+0x580): undefined reference to `irqchip_init'

This makes the OF portion of the driver conditional, which avoids
the build error and also results in smaller object code OF is disabled,
without the need for an #ifdef.

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Cc: Bastian Hecht <hechtb+renesas@gmail.com>
Cc: Kuninori Morimoto <kuninori.morimoto.gx@renesas.com>
[horms+renesas@verge.net.au: Remove ATAGS portion which causes boot failure]
Signed-off-by: Simon Horman <horms+renesas@verge.net.au>
---
 arch/arm/mach-shmobile/intc-r8a7740.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/arch/arm/mach-shmobile/intc-r8a7740.c b/arch/arm/mach-shmobile/intc-r8a7740.c
index 8871f77..61e2a21 100644
--- a/arch/arm/mach-shmobile/intc-r8a7740.c
+++ b/arch/arm/mach-shmobile/intc-r8a7740.c
@@ -53,6 +53,9 @@ static void __init r8a7740_init_irq_common(void)
 
 void __init r8a7740_init_irq_of(void)
 {
+	if (!IS_ENABLED(CONFIG_OF))
+		return;
+
 	irqchip_init();
 	r8a7740_init_irq_common();
 }
-- 
1.8.2.1

