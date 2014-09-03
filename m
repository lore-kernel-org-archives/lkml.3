Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932346AbaICMBZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Sep 2014 08:01:25 -0400
Received: from www.linutronix.de ([62.245.132.108]:43829 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932075AbaICMBY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Sep 2014 08:01:24 -0400
Date: Wed, 3 Sep 2014 14:01:20 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Xiubo Li <Li.Xiubo@freescale.com>
cc: daniel.lezcano@linaro.org, dongsheng.wang@freescale.com,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 5/5] Clocksource: Flextimer: Use Macro for clock source
 selection.
In-Reply-To: <1409031951-39021-6-git-send-email-Li.Xiubo@freescale.com>
Message-ID: <alpine.DEB.2.10.1409031346220.3333@nanos>
References: <1409031951-39021-1-git-send-email-Li.Xiubo@freescale.com> <1409031951-39021-6-git-send-email-Li.Xiubo@freescale.com>
User-Agent: Alpine 2.10 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 26 Aug 2014, Xiubo Li wrote:
> FTM source clock is selectable:
> Source clock can be the system clock, the fixed frequency clock,
> or an external clock.
> Fixed frequency clock is an additional clock input to allow the
> selection of an on chip clock source other than the system clock.
> Selecting external clock connects FTM clock to a chip level input
> pin therefore allowing to synchronize the FTM counter with an off
> chip clock source
> 
> Clock Source Selection:
> Selects one of the three FTM counter clock sources.
> 
> 00 No clock selected. This in effect disables the FTM counter.
> 01 System clock
> ---
> 10 Fixed frequency clock
> 11 External clock
> 
> These two will be useful for the alarm on LS1 platform in late future,
> the system clock's frequency is too high to get a long delay timer when
> go to sleep, so the fixed or external clock could be used instead.

And how is that relevant to changing the mask from a hardcoded value
to a constant? It's still hardcoded at compile time and I don't see
how that helps chosing the clock at runtime for a particular use case.
 
>  #define FTM_SC		0x00
> +#define FTM_SC_CLKS_NON		0
> +#define FTM_SC_CLKS_SYS		1
>  #define FTM_SC_CLK_SHIFT	3
>  #define FTM_SC_CLK_MASK	(0x3 << FTM_SC_CLK_SHIFT)
>  #define FTM_SC_CLK(c)	((c) << FTM_SC_CLK_SHIFT)
> @@ -67,7 +69,7 @@ static inline void ftm_counter_enable(void __iomem *base)
>  	/* select and enable counter clock source */
>  	val = ftm_readl(base + FTM_SC);
>  	val &= ~(FTM_SC_PS_MASK | FTM_SC_CLK_MASK);
> -	val |= priv->ps | FTM_SC_CLK(1);
> +	val |= priv->ps | FTM_SC_CLK(FTM_SC_CLKS_SYS);
>  	ftm_writel(val, base + FTM_SC);
>  }
>  
> @@ -77,7 +79,8 @@ static inline void ftm_counter_disable(void __iomem *base)
>  
>  	/* disable counter clock source */
>  	val = ftm_readl(base + FTM_SC);
> -	val &= ~(FTM_SC_PS_MASK | FTM_SC_CLK_MASK);
> +	val &= ~(FTM_SC_CLK_MASK);

So you remove the FTM_SC_PS_MASK without mentioning it in the
changelog. Either this is by mistake or it wants to be documented WHY
it is not needed in the first place.

Thanks,

	tglx
