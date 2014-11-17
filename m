Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751820AbaKQRiV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Nov 2014 12:38:21 -0500
Received: from metis.ext.pengutronix.de ([92.198.50.35]:49709 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750920AbaKQRiU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Nov 2014 12:38:20 -0500
Message-ID: <1416245856.2734.4.camel@pengutronix.de>
Subject: Re: [PATCH v2] ARM: Add imprecise abort enable/disable macro
From: Lucas Stach <l.stach@pengutronix.de>
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
Cc: Fabrice GASNIER <fabrice.gasnier@st.com>, u.kleine-koenig@pengutronix.de,
        jonathan.austin@arm.com, catalin.marinas@arm.com, will.deacon@arm.com,
        nico@linaro.org, sboyd@codeaurora.org, marc.zyngier@arm.com,
        ben.dooks@codethink.co.uk, vgupta@synopsys.com,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        maxime.coquelin@st.com
Date: Mon, 17 Nov 2014 18:37:36 +0100
In-Reply-To: <1392050756-11145-1-git-send-email-fabrice.gasnier@st.com>
References: <1392050756-11145-1-git-send-email-fabrice.gasnier@st.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.12.6-1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-SA-Exim-Connect-IP: 2001:67c:670:100:fa0f:41ff:fe58:4010
X-SA-Exim-Mail-From: l.stach@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Russell,

can you please revisit this patch? It got stuck in February after you
questioned if it works on anything but ARMv7M. Fabrice responded with an
E-Mail that showed that the logic in this patch is supposedly right and
it should work.

Do you still see anything wrong with this patch? It is a prerequisite
for proper PCI abort handling on a number of SoCs and I would like to
see this moving forward.

Thanks,
Lucas

Am Montag, den 10.02.2014, 17:45 +0100 schrieb Fabrice GASNIER:
> This patch adds imprecise abort enable/disable macros.
> It also enables imprecise aborts when starting kernel.
> 
> Changes in v2:
> Only ARMv6 and later have CPSR.A bit. On earlier CPUs,
> and ARMv7M this should be a no-op.
> 
> Signed-off-by: Fabrice Gasnier <fabrice.gasnier@st.com>
> ---
>  arch/arm/include/asm/irqflags.h |   10 ++++++++++
>  arch/arm/kernel/smp.c           |    1 +
>  arch/arm/kernel/traps.c         |    4 ++++
>  3 files changed, 15 insertions(+)
> 
> diff --git a/arch/arm/include/asm/irqflags.h b/arch/arm/include/asm/irqflags.h
> index 3b763d6..8301f87 100644
> --- a/arch/arm/include/asm/irqflags.h
> +++ b/arch/arm/include/asm/irqflags.h
> @@ -51,6 +51,14 @@ static inline void arch_local_irq_disable(void)
>  
>  #define local_fiq_enable()  __asm__("cpsie f	@ __stf" : : : "memory", "cc")
>  #define local_fiq_disable() __asm__("cpsid f	@ __clf" : : : "memory", "cc")
> +
> +#ifndef CONFIG_CPU_V7M
> +#define local_abt_enable()  __asm__("cpsie a	@ __sta" : : : "memory", "cc")
> +#define local_abt_disable() __asm__("cpsid a	@ __cla" : : : "memory", "cc")
> +#else
> +#define local_abt_enable()	do { } while (0)
> +#define local_abt_disable()	do { } while (0)
> +#endif
>  #else
>  
>  /*
> @@ -130,6 +138,8 @@ static inline void arch_local_irq_disable(void)
>  	: "memory", "cc");					\
>  	})
>  
> +#define local_abt_enable()	do { } while (0)
> +#define local_abt_disable()	do { } while (0)
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
> +
>  #else /* ifndef CONFIG_CPU_V7M */
>  	/*
>  	 * on V7-M there is no need to copy the vector table to a dedicated

-- 
Pengutronix e.K.             | Lucas Stach                 |
Industrial Linux Solutions   | http://www.pengutronix.de/  |

