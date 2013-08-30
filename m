Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755155Ab3H3KB3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Aug 2013 06:01:29 -0400
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:42602 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754102Ab3H3KB2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Aug 2013 06:01:28 -0400
Date: Fri, 30 Aug 2013 11:01:05 +0100
From: Will Deacon <will.deacon@arm.com>
To: Christoph Lameter <cl@linux.com>
Cc: Tejun Heo <tj@kernel.org>,
        "akpm@linuxfoundation.org" <akpm@linuxfoundation.org>,
        Russell King <linux@arm.linux.org.uk>,
        Catalin Marinas <Catalin.Marinas@arm.com>,
        "linux-arch@vger.kernel.org" <linux-arch@vger.kernel.org>,
        Steven Rostedt <srostedt@redhat.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [gcv v3 27/35] arm: Replace __get_cpu_var uses
Message-ID: <20130830100105.GF25628@mudshark.cambridge.arm.com>
References: <20130828193457.140443630@linux.com>
 <00000140c67834c9-cc2bec76-2d70-48d1-a35b-6e2d5dedf22b-000000@email.amazonses.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <00000140c67834c9-cc2bec76-2d70-48d1-a35b-6e2d5dedf22b-000000@email.amazonses.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Christoph,

Sorry for the delay in looking at this, I've been on holiday for a week.
Comments inline.

On Wed, Aug 28, 2013 at 08:48:23PM +0100, Christoph Lameter wrote:
> Transformations done to __get_cpu_var()
> 
> 
> 1. Determine the address of the percpu instance of the current processor.
> 
>         DEFINE_PER_CPU(int, y);
>         int *x = &__get_cpu_var(y);
> 
>     Converts to
> 
>         int *x = this_cpu_ptr(&y);
> 
> 
> 2. Same as #1 but this time an array structure is involved.
> 
>         DEFINE_PER_CPU(int, y[20]);
>         int *x = __get_cpu_var(y);
> 
>     Converts to
> 
>         int *x = this_cpu_ptr(y);

This is the flavour we have for ARM's hw_breakpoint code, where we have an
array of perf_event * instead of int...

> Index: linux/arch/arm/kernel/hw_breakpoint.c
> ===================================================================
> --- linux.orig/arch/arm/kernel/hw_breakpoint.c  2013-08-26 13:48:40.956794980 -0500
> +++ linux/arch/arm/kernel/hw_breakpoint.c       2013-08-26 13:48:40.952795024 -0500
> @@ -344,13 +344,13 @@ int arch_install_hw_breakpoint(struct pe
>                 /* Breakpoint */
>                 ctrl_base = ARM_BASE_BCR;
>                 val_base = ARM_BASE_BVR;
> -               slots = (struct perf_event **)__get_cpu_var(bp_on_reg);
> +               slots = (struct perf_event **)__this_cpu_read(bp_on_reg);

...so I don't think this is quite right, and indeed, we get a bunch of errors
from GCC:

arch/arm/kernel/hw_breakpoint.c: In function ‘arch_install_hw_breakpoint’:
arch/arm/kernel/hw_breakpoint.c:347:33: error: incompatible types when assigning to type ‘struct perf_event *[16]’ from type ‘struct perf_event **’
arch/arm/kernel/hw_breakpoint.c:347:1: error: incompatible types when assigning to type ‘struct perf_event *[16]’ from type ‘struct perf_event **’
arch/arm/kernel/hw_breakpoint.c:347:1: error: incompatible types when assigning to type ‘struct perf_event *[16]’ from type ‘struct perf_event **’
arch/arm/kernel/hw_breakpoint.c:347:1: error: incompatible types when assigning to type ‘struct perf_event *[16]’ from type ‘struct perf_event **’

changing to match your recipe still doesn't work, however:

arch/arm/kernel/hw_breakpoint.c: In function ‘arch_install_hw_breakpoint’:
arch/arm/kernel/hw_breakpoint.c:347:33: error: cast specifies array type

> Index: linux/arch/arm64/kernel/debug-monitors.c
> ===================================================================
> --- linux.orig/arch/arm64/kernel/debug-monitors.c       2013-08-26 13:48:40.956794980 -0500
> +++ linux/arch/arm64/kernel/debug-monitors.c    2013-08-26 13:48:40.952795024 -0500
> @@ -98,11 +98,11 @@ void enable_debug_monitors(enum debug_el
> 
>         WARN_ON(preemptible());
> 
> -       if (local_inc_return(&__get_cpu_var(mde_ref_count)) == 1)
> +       if (this_cpu_inc_return(mde_ref_count) == 1)
>                 enable = DBG_MDSCR_MDE;

I'm not sure that this is safe. We rely on local_inc_return to be atomic
with respect to the current CPU, which will end up being a wrapper around
atomic64_inc_return. However, this_cpu_inc_return simply uses a lock, so
other people accessing the count in a different manner (local_dec_and_test
below) may break local atomicity unless we start disabling interrupts or
something horrible like that.
 
>         if (el == DBG_ACTIVE_EL1 &&
> -           local_inc_return(&__get_cpu_var(kde_ref_count)) == 1)
> +           this_cpu_inc_return(kde_ref_count) == 1)
>                 enable |= DBG_MDSCR_KDE;
> 
>         if (enable && debug_enabled) {
> @@ -118,11 +118,11 @@ void disable_debug_monitors(enum debug_e
> 
>         WARN_ON(preemptible());
> 
> -       if (local_dec_and_test(&__get_cpu_var(mde_ref_count)))
> +       if (local_dec_and_test(this_cpu_ptr(&mde_ref_count)))
>                 disable = ~DBG_MDSCR_MDE;
> 
>         if (el == DBG_ACTIVE_EL1 &&
> -           local_dec_and_test(&__get_cpu_var(kde_ref_count)))
> +           local_dec_and_test(this_cpu_ptr(&kde_ref_count)))
>                 disable &= ~DBG_MDSCR_KDE;
> 
>         if (disable) {

Will
