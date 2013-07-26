Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758344Ab3GZJNA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Jul 2013 05:13:00 -0400
Received: from merlin.infradead.org ([205.233.59.134]:58397 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755173Ab3GZJM4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Jul 2013 05:12:56 -0400
Date: Fri, 26 Jul 2013 11:12:45 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Prarit Bhargava <prarit@redhat.com>
Cc: linux-kernel@vger.kernel.org, John Stultz <john.stultz@linaro.org>,
        Dave Hansen <dave@sr71.net>, x86@kernel.org
Subject: Re: [PATCH] x86, tsc add an initial read offset to __cycles_2_ns()
 calculations
Message-ID: <20130726091245.GF27075@twins.programming.kicks-ass.net>
References: <1374681800-7237-1-git-send-email-prarit@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1374681800-7237-1-git-send-email-prarit@redhat.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 24, 2013 at 12:03:20PM -0400, Prarit Bhargava wrote:
> 
> The TSC can have non-zero values at boot time on Intel Xeon E5 (family 6,
> model 45) aka "SandyBridge" processors.  This is documented in the Errata
> for the E5 processors as BT81.
> 
> The __cycles_2_ns() calculation is known to overflow if a large value of
> cycles is passed into the function.  This is done by design to improve
> precision for smaller significant digits in the calculation.  Since the E5
> processor can pass in a large value,  we need to snapshot the TSC's
> initial value to avoid calculation overflows in the conversions of cycles
> to nanoseconds.
> 
> Tested successfully on various Sandybridge systems as well as a few older
> and newer systems without any issues.
> 
> Signed-off-by: Prarit Bhargava <prarit@redhat.com>
> Cc: John Stultz <john.stultz@linaro.org>
> Cc: Dave Hansen <dave@sr71.net>
> Cc: x86@kernel.org
> ---
>  arch/x86/include/asm/timer.h |   15 +++------------
>  arch/x86/kernel/tsc.c        |   13 +++++++++++++
>  2 files changed, 16 insertions(+), 12 deletions(-)
> 
> diff --git a/arch/x86/include/asm/timer.h b/arch/x86/include/asm/timer.h
> index 34baa0e..f9d666b 100644
> --- a/arch/x86/include/asm/timer.h
> +++ b/arch/x86/include/asm/timer.h
> @@ -12,6 +12,8 @@ extern int recalibrate_cpu_khz(void);
>  
>  extern int no_timer_check;
>  
> +extern unsigned long long tsc_initial_value;
> +
>  /* Accelerators for sched_clock()
>   * convert from cycles(64bits) => nanoseconds (64bits)
>   *  basic equation:
> @@ -59,21 +61,10 @@ static inline unsigned long long __cycles_2_ns(unsigned long long cyc)
>  {
>  	int cpu = smp_processor_id();
>  	unsigned long long ns = per_cpu(cyc2ns_offset, cpu);
> +	cyc -= tsc_initial_value;
>  	ns += mult_frac(cyc, per_cpu(cyc2ns, cpu),
>  			(1UL << CYC2NS_SCALE_FACTOR));
>  	return ns;
>  }

Hurm.. but eventually the TSC value _will_ get that large again, right?
So shouldn't we fix the actual problem?

