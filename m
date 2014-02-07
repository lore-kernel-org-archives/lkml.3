Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752171AbaBGRJp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Feb 2014 12:09:45 -0500
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:33579 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751319AbaBGRJo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Feb 2014 12:09:44 -0500
Date: Fri, 7 Feb 2014 17:09:03 +0000
From: Will Deacon <will.deacon@arm.com>
To: Fabrice GASNIER <fabrice.gasnier@st.com>
Cc: "linux@arm.linux.org.uk" <linux@arm.linux.org.uk>,
        "u.kleine-koenig@pengutronix.de" <u.kleine-koenig@pengutronix.de>,
        Jonathan Austin <Jonathan.Austin@arm.com>,
        Catalin Marinas <Catalin.Marinas@arm.com>,
        "nico@linaro.org" <nico@linaro.org>,
        "sboyd@codeaurora.org" <sboyd@codeaurora.org>,
        Marc Zyngier <Marc.Zyngier@arm.com>,
        "ben.dooks@codethink.co.uk" <ben.dooks@codethink.co.uk>,
        "vgupta@synopsys.com" <vgupta@synopsys.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "maxime.coquelin@st.com" <maxime.coquelin@st.com>
Subject: Re: [RFC PATCH] ARM: Add imprecise abort enable/disable macro
Message-ID: <20140207170903.GT5976@mudshark.cambridge.arm.com>
References: <1391789955-26927-1-git-send-email-fabrice.gasnier@st.com>
 <1391789955-26927-2-git-send-email-fabrice.gasnier@st.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1391789955-26927-2-git-send-email-fabrice.gasnier@st.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 07, 2014 at 04:19:15PM +0000, Fabrice GASNIER wrote:
> This patch adds imprecise abort enable/disable macros.
> It also enables imprecise aborts when starting kernel.
> 
> Signed-off-by: Fabrice Gasnier <fabrice.gasnier@st.com>
> ---
>  arch/arm/include/asm/irqflags.h |   33 +++++++++++++++++++++++++++++++++
>  arch/arm/kernel/smp.c           |    1 +
>  arch/arm/kernel/traps.c         |    4 ++++
>  3 files changed, 38 insertions(+)
> 
> diff --git a/arch/arm/include/asm/irqflags.h b/arch/arm/include/asm/irqflags.h
> index 3b763d6..82e3834 100644
> --- a/arch/arm/include/asm/irqflags.h
> +++ b/arch/arm/include/asm/irqflags.h
> @@ -51,6 +51,9 @@ static inline void arch_local_irq_disable(void)
>  
>  #define local_fiq_enable()  __asm__("cpsie f	@ __stf" : : : "memory", "cc")
>  #define local_fiq_disable() __asm__("cpsid f	@ __clf" : : : "memory", "cc")
> +
> +#define local_abt_enable()  __asm__("cpsie a	@ __sta" : : : "memory", "cc")
> +#define local_abt_disable() __asm__("cpsid a	@ __cla" : : : "memory", "cc")
>  #else
>  
>  /*
> @@ -130,6 +133,36 @@ static inline void arch_local_irq_disable(void)
>  	: "memory", "cc");					\
>  	})
>  
> +/*
> + * Enable Aborts
> + */
> +#define local_abt_enable()					\
> +	({							\
> +		unsigned long temp;				\
> +	__asm__ __volatile__(					\
> +	"mrs	%0, cpsr		@ sta\n"		\
> +"	bic	%0, %0, %1\n"					\
> +"	msr	cpsr_c, %0"					\
> +	: "=r" (temp)						\
> +	: "r" (PSR_A_BIT)					\

Can you use "i" instead of a register for this constant?

> +	: "memory", "cc");					\

You don't need the "cc" clobber.

> +	})
> +
> +/*
> + * Disable Aborts
> + */
> +#define local_abt_disable()					\
> +	({							\
> +		unsigned long temp;				\
> +	__asm__ __volatile__(					\
> +	"mrs	%0, cpsr		@ cla\n"		\
> +"	orr	%0, %0, %1\n"					\
> +"	msr	cpsr_c, %0"					\
> +	: "=r" (temp)						\
> +	: "r" (PSR_A_BIT)					\
> +	: "memory", "cc");					\
> +	})

Same comments here.

>  #endif
>  
>  /*
> diff --git a/arch/arm/kernel/smp.c b/arch/arm/kernel/smp.c
> index dc894ab..c2093cb 100644
> --- a/arch/arm/kernel/smp.c
> +++ b/arch/arm/kernel/smp.c
> @@ -377,6 +377,7 @@ asmlinkage void secondary_start_kernel(void)
>  
>  	local_irq_enable();
>  	local_fiq_enable();
> +	local_abt_enable();
>  
>  	/*
>  	 * OK, it's off to the idle thread for us
> diff --git a/arch/arm/kernel/traps.c b/arch/arm/kernel/traps.c
> index 4636d56..ef15709 100644
> --- a/arch/arm/kernel/traps.c
> +++ b/arch/arm/kernel/traps.c
> @@ -900,6 +900,10 @@ void __init early_trap_init(void *vectors_base)
>  
>  	flush_icache_range(vectors, vectors + PAGE_SIZE * 2);
>  	modify_domain(DOMAIN_USER, DOMAIN_CLIENT);
> +
> +	/* Enable imprecise aborts */
> +	local_abt_enable();

Surely we want to enable this as early as possible? Now, putting this into
head.S is ugly, as it duplicating it across all the proc*.S files, so why
not setup_arch?

Will
