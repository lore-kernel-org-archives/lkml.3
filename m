Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752717Ab3HUS1Z (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Aug 2013 14:27:25 -0400
Received: from mx1.redhat.com ([209.132.183.28]:14185 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752245Ab3HUS1Y (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Aug 2013 14:27:24 -0400
Date: Wed, 21 Aug 2013 14:26:46 -0400
From: Don Zickus <dzickus@redhat.com>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Peter Zijlstra <peterz@infradead.org>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        John Stultz <john.stultz@linaro.org>,
        Steven Rostedt <rostedt@goodmis.org>
Subject: Re: [RFC PATCH 2/6] x86: nsecs to cycles conversion
Message-ID: <20130821182646.GU239280@redhat.com>
References: <1377103341-15235-1-git-send-email-fweisbec@gmail.com>
 <1377103341-15235-3-git-send-email-fweisbec@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1377103341-15235-3-git-send-email-fweisbec@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 21, 2013 at 06:42:17PM +0200, Frederic Weisbecker wrote:
> hw_nmi_get_sample_period() is simply a conversion from a period
> to cycles. Lets generalize the API naming so that it can be used for
> wider purpose than just watchdog perf event settings. Also it makes the
> function name less opaque about what it really does.
> 

<snip>

> diff --git a/arch/x86/include/asm/cycles.h b/arch/x86/include/asm/cycles.h
> new file mode 100644
> index 0000000..7dedeb3
> --- /dev/null
> +++ b/arch/x86/include/asm/cycles.h
> @@ -0,0 +1,11 @@
> +#ifndef _ASM_X86_CYCLES_H
> +#define _ASM_X86_CYCLES_H
> +
> +#include <linux/time.h>
> +#include <asm/tsc.h>
> +
> +static inline u64 nsecs_to_cycles(u64 nsecs)
> +{
> +	return (u64)((cpu_khz) * nsecs) / NSEC_PER_MSEC;
> +}
> +#endif /* #ifndef _ASM_X86_CYCLES_H */
> diff --git a/arch/x86/kernel/apic/hw_nmi.c b/arch/x86/kernel/apic/hw_nmi.c
> index a698d71..4015906 100644
> --- a/arch/x86/kernel/apic/hw_nmi.c
> +++ b/arch/x86/kernel/apic/hw_nmi.c
> @@ -19,13 +19,6 @@
>  #include <linux/module.h>
>  #include <linux/delay.h>
>  
> -#ifdef CONFIG_HARDLOCKUP_DETECTOR
> -u64 hw_nmi_get_sample_period(int watchdog_thresh)
> -{
> -	return (u64)(cpu_khz) * 1000 * watchdog_thresh;
> -}
> -#endif
> -
>  #ifdef arch_trigger_all_cpu_backtrace
>  /* For reliability, we're prepared to waste bits here. */
>  static DECLARE_BITMAP(backtrace_mask, NR_CPUS) __read_mostly;
> diff --git a/kernel/watchdog.c b/kernel/watchdog.c
> index 1241d8c..e04887c 100644
> --- a/kernel/watchdog.c
> +++ b/kernel/watchdog.c
> @@ -26,6 +26,7 @@
>  #include <linux/sched/rt.h>
>  
>  #include <asm/irq_regs.h>
> +#include <asm/cycles.h>
>  #include <linux/kvm_para.h>
>  #include <linux/perf_event.h>

Do you have to wrap the above with #ifdef CONFIG_HARDLOCKUP_DETECTOR?
Otherwise non-x86 boxes won't compile unless I missed stub
nsecs_to_cycles() somewhere.

Cheers,
Don
