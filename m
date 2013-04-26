Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759272Ab3DZAsl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Apr 2013 20:48:41 -0400
Received: from kirsty.vergenet.net ([202.4.237.240]:47195 "EHLO
	kirsty.vergenet.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758853Ab3DZAsk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Apr 2013 20:48:40 -0400
Date: Fri, 26 Apr 2013 09:48:35 +0900
From: Simon Horman <horms@verge.net.au>
To: Arnd Bergmann <arnd@arndb.de>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Bastian Hecht <hechtb+renesas@gmail.com>,
        Kuninori Morimoto <kuninori.morimoto.gx@renesas.com>
Subject: Re: [PATCH 03/21] ARM: shmobile: don't call irqchip_init
 unconditionally
Message-ID: <20130426004835.GA20070@verge.net.au>
References: <1366910944-3033663-1-git-send-email-arnd@arndb.de>
 <1366910944-3033663-4-git-send-email-arnd@arndb.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1366910944-3033663-4-git-send-email-arnd@arndb.de>
Organisation: Horms Solutions Ltd.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 25, 2013 at 07:28:46PM +0200, Arnd Bergmann wrote:
> The irqchip_init function is only available when building
> with CONFIG_OF enabled, which causes this build failure for
> bonito_defconfig:
> 
> arch/arm/mach-shmobile/built-in.o: In function `r8a7740_init_irq_of':
> :(.init.text+0x580): undefined reference to `irqchip_init'
> 
> This makes both the OF and the ATAGS portion of the driver
> conditional, which avoids the build error and also results
> in smaller object code if not both are enabled, without the
> need for an #ifdef.
> 
> Signed-off-by: Arnd Bergmann <arnd@arndb.de>
> Cc: Bastian Hecht <hechtb+renesas@gmail.com>
> Cc: Simon Horman <horms+renesas@verge.net.au>
> Cc: Kuninori Morimoto <kuninori.morimoto.gx@renesas.com>
> ---
>  arch/arm/mach-shmobile/intc-r8a7740.c | 13 +++++++++++--
>  1 file changed, 11 insertions(+), 2 deletions(-)
> 
> diff --git a/arch/arm/mach-shmobile/intc-r8a7740.c b/arch/arm/mach-shmobile/intc-r8a7740.c
> index 8871f77..5dc57f1 100644
> --- a/arch/arm/mach-shmobile/intc-r8a7740.c
> +++ b/arch/arm/mach-shmobile/intc-r8a7740.c
> @@ -53,14 +53,23 @@ static void __init r8a7740_init_irq_common(void)
>  
>  void __init r8a7740_init_irq_of(void)
>  {
> +	if (!IS_ENABLED(CONFIG_OF))
> +		return;
> +

In other parts of the shmobile I believe that such code is
guarded by #ifdef CONFIG_OF and I believe not guarding this code in
some way was an oversight.

The above change seems fine to me.

>  	irqchip_init();
>  	r8a7740_init_irq_common();
>  }
>  
>  void __init r8a7740_init_irq(void)
>  {
> -	void __iomem *gic_dist_base = ioremap_nocache(0xc2800000, 0x1000);
> -	void __iomem *gic_cpu_base = ioremap_nocache(0xc2000000, 0x1000);
> +	void __iomem *gic_dist_base;
> +	void __iomem *gic_cpu_base;
> +
> +	if (!IS_ENABLED(CONFIG_ATAGS))
> +		return;
> +
> +	gic_dist_base = ioremap_nocache(0xc2800000, 0x1000);
> +	gic_cpu_base = ioremap_nocache(0xc2000000, 0x1000);
>  
>  	/* initialize the Generic Interrupt Controller PL390 r0p0 */
>  	gic_init(0, 29, gic_dist_base, gic_cpu_base);

This one seems broken as the armadillo800eva board currently uses
it to initialise GIC even if CONFIG_ATAGS is not defined.

I did test the above change on the armadillo800eva board
with the above change and CONFIG_ATAGS disabled, the result was
a boot failure. With the change reverted booting seems fine.
