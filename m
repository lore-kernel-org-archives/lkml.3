Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756759Ab3D2OtV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Apr 2013 10:49:21 -0400
Received: from moutng.kundenserver.de ([212.227.17.8]:52929 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756490Ab3D2OtU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Apr 2013 10:49:20 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Simon Horman <horms@verge.net.au>
Subject: Re: [PATCH 03/21] ARM: shmobile: don't call irqchip_init unconditionally
Date: Mon, 29 Apr 2013 16:49:07 +0200
User-Agent: KMail/1.12.2 (Linux/3.8.0-18-generic; KDE/4.3.2; x86_64; ; )
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Bastian Hecht <hechtb+renesas@gmail.com>,
        Kuninori Morimoto <kuninori.morimoto.gx@renesas.com>
References: <1366910944-3033663-1-git-send-email-arnd@arndb.de> <1366910944-3033663-4-git-send-email-arnd@arndb.de> <20130426004835.GA20070@verge.net.au>
In-Reply-To: <20130426004835.GA20070@verge.net.au>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201304291649.08084.arnd@arndb.de>
X-Provags-ID: V02:K0:8oJaIu5w1eL6+8S0QCTL2L2s6pqdhlyWeD38ZmHc6it
 dHGaKN6vq4dngd3jBu+Sb45Sy6+39sB4WCgBAhe0Pbld69DblC
 sXwpdFQcIpXmtjn3u6qhXUx286epnYj9Cbp+8ApjTQKi81olT4
 0jj9a3R3J/CfypUDfzVepEtHvZb7KpHwIBKtX1DQufJF4S1vkN
 dpY8PU3jpKwZF6v/tszvW9wOs3mOITvqd8fVI2XbMgq3NH/Q/D
 jaxkxptWvij0ToKq/X/2Ta+RxRS/zpiGF2QThq8AY/gR8PMMhB
 sxzvNsfB2opEEPogI2w8APkXmGmULLBTh39ocq490h09oFT/4V
 I8iw85garELYmfvGrXhM=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 26 April 2013, Simon Horman wrote:
> > diff --git a/arch/arm/mach-shmobile/intc-r8a7740.c b/arch/arm/mach-shmobile/intc-r8a7740.c
> > index 8871f77..5dc57f1 100644
> > --- a/arch/arm/mach-shmobile/intc-r8a7740.c
> > +++ b/arch/arm/mach-shmobile/intc-r8a7740.c
> > @@ -53,14 +53,23 @@ static void __init r8a7740_init_irq_common(void)
> >  
> >  void __init r8a7740_init_irq_of(void)
> >  {
> > +     if (!IS_ENABLED(CONFIG_OF))
> > +             return;
> > +
> 
> In other parts of the shmobile I believe that such code is
> guarded by #ifdef CONFIG_OF and I believe not guarding this code in
> some way was an oversight.
> 
> The above change seems fine to me.

Ok. The change that broke the code is only present in linux-next from
one of your trees, but is not in arm-soc. Could you include the change
in your tree, either by folding into one of your patches or adapting
my patch appropriately?

> > +
> > +     gic_dist_base = ioremap_nocache(0xc2800000, 0x1000);
> > +     gic_cpu_base = ioremap_nocache(0xc2000000, 0x1000);
> >  
> >       /* initialize the Generic Interrupt Controller PL390 r0p0 */
> >       gic_init(0, 29, gic_dist_base, gic_cpu_base);
> 
> This one seems broken as the armadillo800eva board currently uses
> it to initialise GIC even if CONFIG_ATAGS is not defined.
> 
> I did test the above change on the armadillo800eva board
> with the above change and CONFIG_ATAGS disabled, the result was
> a boot failure. With the change reverted booting seems fine.

Yes, I see my mistake now. The second change was clearly wrong
as this function is also used for DT boards, not for ATAGS boards.

	Arnd
