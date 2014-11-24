Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753016AbaKXJBo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Nov 2014 04:01:44 -0500
Received: from mail-wg0-f51.google.com ([74.125.82.51]:36775 "EHLO
	mail-wg0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752935AbaKXJBl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Nov 2014 04:01:41 -0500
Message-ID: <5472F3F0.8060701@linaro.org>
Date: Mon, 24 Nov 2014 10:01:36 +0100
From: Daniel Lezcano <daniel.lezcano@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:31.0) Gecko/20100101 Thunderbird/31.2.0
MIME-Version: 1.0
To: Sonny Rao <sonnyrao@chromium.org>, linux-arm-kernel@lists.infradead.org
CC: linux-kernel@vger.kernel.org, dianders@chromium.org,
        Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>,
        Sudeep KarkadaNagesha <sudeep.karkadanagesha@arm.com>,
        Olof Johansson <olof@lixom.net>, Thomas Gleixner <tglx@linutronix.de>,
        Will Deacon <will.deacon@arm.com>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Russell King <linux@arm.linux.org.uk>,
        Sudeep Holla <Sudeep.Holla@arm.com>,
        Mark Rutland <Mark.Rutland@arm.com>,
        Stephen Boyd <sboyd@codeaurora.org>,
        Marc Zyngier <marc.zyngier@arm.com>, stable@vger.kernel.org
Subject: Re: [PATCH v5] clocksource: arch_timer: Fix code to use physical
 timers when requested
References: <1416812564-26465-1-git-send-email-sonnyrao@chromium.org>
In-Reply-To: <1416812564-26465-1-git-send-email-sonnyrao@chromium.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/24/2014 08:02 AM, Sonny Rao wrote:
> This is a bug fix for using physical arch timers when
> the arch_timer_use_virtual boolean is false.  It restores the
> arch_counter_get_cntpct() function after removal in
>
> 0d651e4e "clocksource: arch_timer: use virtual counters"
>
> We need this on certain ARMv7 systems which are architected like this:
>
> * The firmware doesn't know and doesn't care about hypervisor mode and
>    we don't want to add the complexity of hypervisor there.
>
> * The firmware isn't involved in SMP bringup or resume.
>
> * The ARCH timer come up with an uninitialized offset between the
>    virtual and physical counters.  Each core gets a different random
>    offset.
>
> * The device boots in "Secure SVC" mode.
>
> * Nothing has touched the reset value of CNTHCTL.PL1PCEN or
>    CNTHCTL.PL1PCTEN (both default to 1 at reset)
>
> One example of such as system is RK3288 where it is much simpler to
> use the physical counter since there's nobody managing the offset and
> each time a core goes down and comes back up it will get reinitialized
> to some other random value.
>
> Fixes: 0d651e4e65e9 ("clocksource: arch_timer: use virtual counters")
> Cc: stable@vger.kernel.org
> Signed-off-by: Sonny Rao <sonnyrao@chromium.org>
> Acked-by: Olof Johansson <olof@lixom.net>


Catalin,

are you ok with this patch ?

Thanks
   -- Daniel

> ---
> v2: Add fixes tag to commit message, cc stable, copy Doug's
>      description of the systems which need this in commit message.
> v3: Don't change the memory-mapped physical timer/counter code
> v4: remove the memory-mapped physical counter code since it's not used
> v5: rebase and make AArch64 version of arch_counter_get_cntpct call BUG()
> ---
>   arch/arm/include/asm/arch_timer.h    | 9 +++++++++
>   arch/arm64/include/asm/arch_timer.h  | 9 +++++++++
>   drivers/clocksource/arm_arch_timer.c | 5 ++++-
>   3 files changed, 22 insertions(+), 1 deletion(-)
>
> diff --git a/arch/arm/include/asm/arch_timer.h b/arch/arm/include/asm/arch_timer.h
> index 92793ba..d4ebf56 100644
> --- a/arch/arm/include/asm/arch_timer.h
> +++ b/arch/arm/include/asm/arch_timer.h
> @@ -78,6 +78,15 @@ static inline u32 arch_timer_get_cntfrq(void)
>   	return val;
>   }
>
> +static inline u64 arch_counter_get_cntpct(void)
> +{
> +	u64 cval;
> +
> +	isb();
> +	asm volatile("mrrc p15, 0, %Q0, %R0, c14" : "=r" (cval));
> +	return cval;
> +}
> +
>   static inline u64 arch_counter_get_cntvct(void)
>   {
>   	u64 cval;
> diff --git a/arch/arm64/include/asm/arch_timer.h b/arch/arm64/include/asm/arch_timer.h
> index f190971..b1fa4e6 100644
> --- a/arch/arm64/include/asm/arch_timer.h
> +++ b/arch/arm64/include/asm/arch_timer.h
> @@ -104,6 +104,15 @@ static inline void arch_timer_set_cntkctl(u32 cntkctl)
>   	asm volatile("msr	cntkctl_el1, %0" : : "r" (cntkctl));
>   }
>
> +static inline u64 arch_counter_get_cntpct(void)
> +{
> +	/*
> +	 * AArch64 kernel and user space mandate the use of CNTVCT.
> +	 */
> +	BUG();
> +	return 0;
> +}
> +
>   static inline u64 arch_counter_get_cntvct(void)
>   {
>   	u64 cval;
> diff --git a/drivers/clocksource/arm_arch_timer.c b/drivers/clocksource/arm_arch_timer.c
> index 43005d4..1fa2af9 100644
> --- a/drivers/clocksource/arm_arch_timer.c
> +++ b/drivers/clocksource/arm_arch_timer.c
> @@ -462,7 +462,10 @@ static void __init arch_counter_register(unsigned type)
>
>   	/* Register the CP15 based counter if we have one */
>   	if (type & ARCH_CP15_TIMER) {
> -		arch_timer_read_counter = arch_counter_get_cntvct;
> +		if (arch_timer_use_virtual)
> +			arch_timer_read_counter = arch_counter_get_cntvct;
> +		else
> +			arch_timer_read_counter = arch_counter_get_cntpct;
>   	} else {
>   		arch_timer_read_counter = arch_counter_get_cntvct_mem;
>
>


-- 
  <http://www.linaro.org/> Linaro.org │ Open source software for ARM SoCs

Follow Linaro:  <http://www.facebook.com/pages/Linaro> Facebook |
<http://twitter.com/#!/linaroorg> Twitter |
<http://www.linaro.org/linaro-blog/> Blog

