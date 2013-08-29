Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756407Ab3H2LZS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Aug 2013 07:25:18 -0400
Received: from fw-tnat.cambridge.arm.com ([217.140.96.21]:45067 "EHLO
	cam-smtp0.cambridge.arm.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1756379Ab3H2LZO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Aug 2013 07:25:14 -0400
Date: Thu, 29 Aug 2013 12:24:21 +0100
From: Catalin Marinas <catalin.marinas@arm.com>
To: Sudeep KarkadaNagesha <Sudeep.KarkadaNagesha@arm.com>
Cc: "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Lorenzo Pieralisi <Lorenzo.Pieralisi@arm.com>,
        Will Deacon <Will.Deacon@arm.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        Russell King <linux@arm.linux.org.uk>
Subject: Re: [PATCH v5 2/5] ARM: arch_timer: add support to configure and
 enable event stream
Message-ID: <20130829112421.GF13704@arm.com>
References: <1377686689-30828-1-git-send-email-Sudeep.KarkadaNagesha@arm.com>
 <1377686689-30828-3-git-send-email-Sudeep.KarkadaNagesha@arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1377686689-30828-3-git-send-email-Sudeep.KarkadaNagesha@arm.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 28, 2013 at 11:44:46AM +0100, Sudeep KarkadaNagesha wrote:
> From: Sudeep KarkadaNagesha <sudeep.karkadanagesha@arm.com>
> 
> This patch adds support for configuring the event stream frequency
> and enabling it.
> 
> It also adds the hwcaps definitions to the user to detect this event
> stream feature.
> 
> Cc: Russell King <linux@arm.linux.org.uk>
> Cc: Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>
> Cc: Will Deacon <will.deacon@arm.com>
> Cc: Catalin Marinas <catalin.marinas@arm.com>
> Signed-off-by: Sudeep KarkadaNagesha <sudeep.karkadanagesha@arm.com>
> ---
>  arch/arm/include/asm/arch_timer.h | 33 ++++++++++++++++++++++++++++-----
>  arch/arm/include/uapi/asm/hwcap.h |  1 +
>  arch/arm/kernel/setup.c           |  1 +
>  3 files changed, 30 insertions(+), 5 deletions(-)
> 
> diff --git a/arch/arm/include/asm/arch_timer.h b/arch/arm/include/asm/arch_timer.h
> index 1a3e967..4e38609 100644
> --- a/arch/arm/include/asm/arch_timer.h
> +++ b/arch/arm/include/asm/arch_timer.h
> @@ -89,22 +89,45 @@ static inline u64 arch_counter_get_cntvct(void)
>  	return cval;
>  }
>  
> -static inline void arch_counter_set_user_access(void)
> +static inline u32 arch_timer_get_cntkctl(void)
>  {
>  	u32 cntkctl;
> -
>  	asm volatile("mrc p15, 0, %0, c14, c1, 0" : "=r" (cntkctl));
> +	return cntkctl;
> +}
> +
> +static inline void arch_timer_set_cntkctl(u32 cntkctl)
> +{
> +	asm volatile("mcr p15, 0, %0, c14, c1, 0" : : "r" (cntkctl));
> +}
> +
> +static inline void arch_counter_set_user_access(void)
> +{
> +	u32 cntkctl = arch_timer_get_cntkctl();
>  
>  	/* Disable user access to both physical/virtual counters/timers */
> -	/* Also disable virtual event stream */
>  	cntkctl &= ~(ARCH_TIMER_USR_PT_ACCESS_EN
>  			| ARCH_TIMER_USR_VT_ACCESS_EN
> -			| ARCH_TIMER_VIRT_EVT_EN
>  			| ARCH_TIMER_USR_VCT_ACCESS_EN
>  			| ARCH_TIMER_USR_PCT_ACCESS_EN);
> +	arch_timer_set_cntkctl(cntkctl);
> +}

You can keep the ARCH_TIMER_VIRT_EVT_EN clearing here, especially if we
drop the bool enable argument to arch_timer_evtstrm_config(). You can
add the same clearing to arm64 in one of the latter patches.

-- 
Catalin
