Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753910Ab3H0OxT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Aug 2013 10:53:19 -0400
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:42967 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753521Ab3H0OxS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Aug 2013 10:53:18 -0400
Date: Tue, 27 Aug 2013 15:52:50 +0100
From: Catalin Marinas <catalin.marinas@arm.com>
To: Sudeep KarkadaNagesha <Sudeep.KarkadaNagesha@arm.com>
Cc: "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Lorenzo Pieralisi <Lorenzo.Pieralisi@arm.com>,
        Will Deacon <Will.Deacon@arm.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Daniel Lezcano <daniel.lezcano@linaro.org>
Subject: Re: [PATCH v4 1/5] ARM/ARM64: arch_timer: add macros for bits in
 control register
Message-ID: <20130827145250.GE27164@darko.cambridge.arm.com>
References: <1377274749-6196-1-git-send-email-Sudeep.KarkadaNagesha@arm.com>
 <1377274749-6196-2-git-send-email-Sudeep.KarkadaNagesha@arm.com>
 <20130827112144.GG19897@arm.com>
 <521C8F82.6070301@arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <521C8F82.6070301@arm.com>
Thread-Topic: [PATCH v4 1/5] ARM/ARM64: arch_timer: add macros for bits in
 control register
Accept-Language: en-GB, en-US
Content-Language: en-US
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 27, 2013 at 12:37:38PM +0100, Sudeep KarkadaNagesha wrote:
> On 27/08/13 12:21, Catalin Marinas wrote:
> > On Fri, Aug 23, 2013 at 05:19:05PM +0100, Sudeep KarkadaNagesha wrote:
> >> From: Sudeep KarkadaNagesha <sudeep.karkadanagesha@arm.com>
> >>
> >> Add macros to describe the bitfields in the ARM architected timer
> >> control register to make code easy to understand.
> >>
> >> Cc: Catalin Marinas <catalin.marinas@arm.com>
> >> Reviewed-by: Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>
> >> Reviewed-by: Will Deacon <will.deacon@arm.com>
> >> Signed-off-by: Sudeep KarkadaNagesha <sudeep.karkadanagesha@arm.com>
> >> ---
> >>  arch/arm/include/asm/arch_timer.h    |  9 +++++++--
> >>  arch/arm64/include/asm/arch_timer.h  | 12 ++++++++----
> >>  include/clocksource/arm_arch_timer.h |  8 ++++++++
> >>  3 files changed, 23 insertions(+), 6 deletions(-)
> >>
> >> diff --git a/arch/arm/include/asm/arch_timer.h b/arch/arm/include/asm/arch_timer.h
> >> index e406d57..9ef74da 100644
> >> --- a/arch/arm/include/asm/arch_timer.h
> >> +++ b/arch/arm/include/asm/arch_timer.h
> >> @@ -95,8 +95,13 @@ static inline void arch_counter_set_user_access(void)
> >>  
> >>  	asm volatile("mrc p15, 0, %0, c14, c1, 0" : "=r" (cntkctl));
> >>  
> >> -	/* disable user access to everything */
> >> -	cntkctl &= ~((3 << 8) | (7 << 0));
> >> +	/* Disable user access to both physical/virtual counters/timers. */
> >> +	/* Also disable virtual event stream */
> >> +	cntkctl &= ~(ARCH_TIMER_USR_PT_ACCESS_EN
> >> +			| ARCH_TIMER_USR_VT_ACCESS_EN
> >> +			| ARCH_TIMER_VIRT_EVT_EN
> >> +			| ARCH_TIMER_USR_VCT_ACCESS_EN
> >> +			| ARCH_TIMER_USR_PCT_ACCESS_EN);
> >>  
> >>  	asm volatile("mcr p15, 0, %0, c14, c1, 0" : : "r" (cntkctl));
> >>  }
> >> diff --git a/arch/arm64/include/asm/arch_timer.h b/arch/arm64/include/asm/arch_timer.h
> >> index 98abd47..00b09d0 100644
> >> --- a/arch/arm64/include/asm/arch_timer.h
> >> +++ b/arch/arm64/include/asm/arch_timer.h
> >> @@ -101,12 +101,16 @@ static inline void arch_counter_set_user_access(void)
> >>  {
> >>  	u32 cntkctl;
> >>  
> >> -	/* Disable user access to the timers and the physical counter. */
> >>  	asm volatile("mrs	%0, cntkctl_el1" : "=r" (cntkctl));
> >> -	cntkctl &= ~((3 << 8) | (1 << 0));
> >>  
> >> -	/* Enable user access to the virtual counter and frequency. */
> >> -	cntkctl |= (1 << 1);
> >> +	/* Disable user access to the timers and the physical counter. */
> >> +	cntkctl &= ~(ARCH_TIMER_USR_PT_ACCESS_EN
> >> +			| ARCH_TIMER_USR_VT_ACCESS_EN
> >> +			| ARCH_TIMER_USR_PCT_ACCESS_EN);
> >> +
> >> +	/* Enable user access to the virtual counter. */
> >> +	cntkctl |= ARCH_TIMER_USR_VCT_ACCESS_EN;
> >> +
> >>  	asm volatile("msr	cntkctl_el1, %0" : : "r" (cntkctl));
> > 
> > For consistency with arm, I think we should also disable the event
> > stream explicitly here.
> > 
> Yes it's done. In PATCH 3/5, a new function arch_timer_evtstrm_config is
> added which is always called(PATCH 4/5). It's either enabled or disabled
> explicitly based on config option for event stream.

OK, just that in this patch arm and arm64 had different settings with
regards to the event stream.

BTW, can we not avoid clearing the event stream via the
arch_timer_evtstrm_config(false) and always assume the default as
disabled? Do you ever go back into low power mode with event stream
disabled and come back with it enabled?

-- 
Catalin
