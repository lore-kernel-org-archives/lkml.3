Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751849AbaBLNHr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Feb 2014 08:07:47 -0500
Received: from eu1sys200aog115.obsmtp.com ([207.126.144.139]:54876 "EHLO
	eu1sys200aog115.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751320AbaBLNHq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Feb 2014 08:07:46 -0500
Message-ID: <52FB7201.20202@st.com>
Date: Wed, 12 Feb 2014 14:07:13 +0100
From: Fabrice Gasnier <fabrice.gasnier@st.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.1.1
MIME-Version: 1.0
To: Fabrice GASNIER <fabrice.gasnier@st.com>, <linux@arm.linux.org.uk>,
        <u.kleine-koenig@pengutronix.de>, <jonathan.austin@arm.com>,
        <catalin.marinas@arm.com>, <will.deacon@arm.com>, <nico@linaro.org>,
        <sboyd@codeaurora.org>, <marc.zyngier@arm.com>,
        <ben.dooks@codethink.co.uk>, <vgupta@synopsys.com>,
        <linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>
Cc: <maxime.coquelin@st.com>
Subject: Re: [PATCH v2] ARM: Add imprecise abort enable/disable macro
References: <1392050756-11145-1-git-send-email-fabrice.gasnier@st.com>
In-Reply-To: <1392050756-11145-1-git-send-email-fabrice.gasnier@st.com>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.201.23.81]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Any comments on this patch ?

Russel, can I add this patch to your patch tracker system ?

Thanks,
Fabrice

On 02/10/2014 05:45 PM, Fabrice GASNIER wrote:
> This patch adds imprecise abort enable/disable macros.
> It also enables imprecise aborts when starting kernel.
>
> Changes in v2:
> Only ARMv6 and later have CPSR.A bit. On earlier CPUs,
> and ARMv7M this should be a no-op.
>
> Signed-off-by: Fabrice Gasnier <fabrice.gasnier@st.com>
> ---
>   arch/arm/include/asm/irqflags.h |   10 ++++++++++
>   arch/arm/kernel/smp.c           |    1 +
>   arch/arm/kernel/traps.c         |    4 ++++
>   3 files changed, 15 insertions(+)
>
> diff --git a/arch/arm/include/asm/irqflags.h b/arch/arm/include/asm/irqflags.h
> index 3b763d6..8301f87 100644
> --- a/arch/arm/include/asm/irqflags.h
> +++ b/arch/arm/include/asm/irqflags.h
> @@ -51,6 +51,14 @@ static inline void arch_local_irq_disable(void)
>   
>   #define local_fiq_enable()  __asm__("cpsie f	@ __stf" : : : "memory", "cc")
>   #define local_fiq_disable() __asm__("cpsid f	@ __clf" : : : "memory", "cc")
> +
> +#ifndef CONFIG_CPU_V7M
> +#define local_abt_enable()  __asm__("cpsie a	@ __sta" : : : "memory", "cc")
> +#define local_abt_disable() __asm__("cpsid a	@ __cla" : : : "memory", "cc")
> +#else
> +#define local_abt_enable()	do { } while (0)
> +#define local_abt_disable()	do { } while (0)
> +#endif
>   #else
>   
>   /*
> @@ -130,6 +138,8 @@ static inline void arch_local_irq_disable(void)
>   	: "memory", "cc");					\
>   	})
>   
> +#define local_abt_enable()	do { } while (0)
> +#define local_abt_disable()	do { } while (0)
>   #endif
>   
>   /*
> diff --git a/arch/arm/kernel/smp.c b/arch/arm/kernel/smp.c
> index dc894ab..c2093cb 100644
> --- a/arch/arm/kernel/smp.c
> +++ b/arch/arm/kernel/smp.c
> @@ -377,6 +377,7 @@ asmlinkage void secondary_start_kernel(void)
>   
>   	local_irq_enable();
>   	local_fiq_enable();
> +	local_abt_enable();
>   
>   	/*
>   	 * OK, it's off to the idle thread for us
> diff --git a/arch/arm/kernel/traps.c b/arch/arm/kernel/traps.c
> index 4636d56..ef15709 100644
> --- a/arch/arm/kernel/traps.c
> +++ b/arch/arm/kernel/traps.c
> @@ -900,6 +900,10 @@ void __init early_trap_init(void *vectors_base)
>   
>   	flush_icache_range(vectors, vectors + PAGE_SIZE * 2);
>   	modify_domain(DOMAIN_USER, DOMAIN_CLIENT);
> +
> +	/* Enable imprecise aborts */
> +	local_abt_enable();
> +
>   #else /* ifndef CONFIG_CPU_V7M */
>   	/*
>   	 * on V7-M there is no need to copy the vector table to a dedicated

