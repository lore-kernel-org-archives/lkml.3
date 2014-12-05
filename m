Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751913AbaLEKlO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Dec 2014 05:41:14 -0500
Received: from mailgw01.mediatek.com ([210.61.82.183]:51640 "EHLO
	mailgw01.mediatek.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751122AbaLEKlK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Dec 2014 05:41:10 -0500
X-Listener-Flag: 11101
Subject: Re: [PATCH v5] clocksource: arch_timer: Fix code to use physical
 timers when requested
From: Yingjoe Chen <yingjoe.chen@mediatek.com>
To: Sonny Rao <sonnyrao@chromium.org>
CC: <linux-arm-kernel@lists.infradead.org>,
        Mark Rutland <Mark.Rutland@arm.com>,
        Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>,
        Russell King <linux@arm.linux.org.uk>,
        Sudeep KarkadaNagesha <sudeep.karkadanagesha@arm.com>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        Will Deacon <will.deacon@arm.com>, <linux-kernel@vger.kernel.org>,
        <stable@vger.kernel.org>, <dianders@chromium.org>,
        Marc Zyngier <marc.zyngier@arm.com>,
        Sudeep Holla <Sudeep.Holla@arm.com>, Olof Johansson <olof@lixom.net>,
        Thomas Gleixner <tglx@linutronix.de>,
        Stephen Boyd <sboyd@codeaurora.org>,
        Eddie Huang =?UTF-8?Q?=28=E9=BB=83=E6=99=BA=E5=82=91=29?= 
	<eddie.huang@mediatek.com>
In-Reply-To: <1416812564-26465-1-git-send-email-sonnyrao@chromium.org>
References: <1416812564-26465-1-git-send-email-sonnyrao@chromium.org>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 5 Dec 2014 18:41:04 +0800
Message-ID: <1417776064.14380.17.camel@mtksdaap41>
MIME-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
X-MTK: N
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2014-11-23 at 23:02 -0800, Sonny Rao wrote: 
> This is a bug fix for using physical arch timers when
> the arch_timer_use_virtual boolean is false.  It restores the
> arch_counter_get_cntpct() function after removal in
> 
> 0d651e4e "clocksource: arch_timer: use virtual counters"
> 
> We need this on certain ARMv7 systems which are architected like this:
> diff --git a/arch/arm64/include/asm/arch_timer.h b/arch/arm64/include/asm/arch_timer.h
> index f190971..b1fa4e6 100644
> --- a/arch/arm64/include/asm/arch_timer.h
> +++ b/arch/arm64/include/asm/arch_timer.h
> @@ -104,6 +104,15 @@ static inline void arch_timer_set_cntkctl(u32 cntkctl)
>  	asm volatile("msr	cntkctl_el1, %0" : : "r" (cntkctl));
>  }
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
>  static inline u64 arch_counter_get_cntvct(void)
>  {
>  	u64 cval;

I tested this on an arm64 platform and system fail to boot when apply
this patch.

The boot loader start kernel at EL2, so is_hyp_mode_available() will be
true and we will use physical timer. Without this patch,
arch_timer_read_counter set to arch_counter_get_cntvct even when we use
physical timer which is incorrect but at least system will boot.

I think we still need this function on arm64. We should add BUG() to
arch_timer_init instead, maybe something like this:


@@ -708,9 +708,12 @@ static void __init arch_timer_init(struct device_node *np)
 	 * If we cannot rely on firmware initializing the timer registers then
 	 * we should use the physical timers instead.
 	 */
-	if (IS_ENABLED(CONFIG_ARM) &&
-	    of_property_read_bool(np, "arm,cpu-registers-not-fw-configured"))
+	if (of_property_read_bool(np, "arm,cpu-registers-not-fw-configured")) {
+		if (IS_ENABLED(CONFIG_ARM64))
+			BUG();
+		else
 			arch_timer_use_virtual = false;
+	}

Joe.C


