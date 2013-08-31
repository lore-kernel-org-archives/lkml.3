Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756862Ab3HaUCy (ORCPT <rfc822;w@1wt.eu>);
	Sat, 31 Aug 2013 16:02:54 -0400
Received: from e35.co.us.ibm.com ([32.97.110.153]:55921 "EHLO
	e35.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755037Ab3HaUCx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 31 Aug 2013 16:02:53 -0400
Date: Sat, 31 Aug 2013 13:02:29 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Frederic Weisbecker <fweisbec@gmail.com>, Jiri Olsa <jolsa@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>
Subject: Re: [RFC][PATCH 17/18 v2] ftrace/cpuidle/x86: Mark functions that
 are RCU unsafe
Message-ID: <20130831200229.GX3871@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20130831051117.884125230@goodmis.org>
 <20130831051703.241036187@goodmis.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130831051703.241036187@goodmis.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13083120-4834-0000-0000-00000A9FD84A
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Aug 31, 2013 at 01:11:34AM -0400, Steven Rostedt wrote:
> From: "Steven Rostedt (Red Hat)" <rostedt@goodmis.org>
> 
> Some callbacks of the function tracer use rcu_read_lock(). This means that
> there's places that can not be traced because RCU is not tracking the CPU
> for various reasons (like NO_HZ_FULL and coming back from userspace).
> 
> Thes functions need to be marked so that callbacks that use RCU do not
> trace them.
> 
> Cc: H. Peter Anvin <hpa@zytor.com>
> Cc: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
> Signed-off-by: Steven Rostedt <rostedt@goodmis.org>

Acked-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>

> ---
>  arch/x86/kernel/process.c |    2 ++
>  drivers/cpuidle/cpuidle.c |    2 ++
>  kernel/cpu/idle.c         |    2 ++
>  3 files changed, 6 insertions(+)
> 
> diff --git a/arch/x86/kernel/process.c b/arch/x86/kernel/process.c
> index 83369e5..18739cd 100644
> --- a/arch/x86/kernel/process.c
> +++ b/arch/x86/kernel/process.c
> @@ -17,6 +17,7 @@
>  #include <linux/stackprotector.h>
>  #include <linux/tick.h>
>  #include <linux/cpuidle.h>
> +#include <linux/ftrace.h>
>  #include <trace/events/power.h>
>  #include <linux/hw_breakpoint.h>
>  #include <asm/cpu.h>
> @@ -316,6 +317,7 @@ void default_idle(void)
>  #ifdef CONFIG_APM_MODULE
>  EXPORT_SYMBOL(default_idle);
>  #endif
> +FTRACE_UNSAFE_RCU(default_idle);
> 
>  #ifdef CONFIG_XEN
>  bool xen_set_default_idle(void)
> diff --git a/drivers/cpuidle/cpuidle.c b/drivers/cpuidle/cpuidle.c
> index fdc432f..9515457 100644
> --- a/drivers/cpuidle/cpuidle.c
> +++ b/drivers/cpuidle/cpuidle.c
> @@ -19,6 +19,7 @@
>  #include <linux/ktime.h>
>  #include <linux/hrtimer.h>
>  #include <linux/module.h>
> +#include <linux/ftrace.h>
>  #include <trace/events/power.h>
> 
>  #include "cpuidle.h"
> @@ -168,6 +169,7 @@ int cpuidle_idle_call(void)
> 
>  	return 0;
>  }
> +FTRACE_UNSAFE_RCU(cpuidle_idle_call);
> 
>  /**
>   * cpuidle_install_idle_handler - installs the cpuidle idle loop handler
> diff --git a/kernel/cpu/idle.c b/kernel/cpu/idle.c
> index e695c0a..d9d290f 100644
> --- a/kernel/cpu/idle.c
> +++ b/kernel/cpu/idle.c
> @@ -5,6 +5,7 @@
>  #include <linux/cpu.h>
>  #include <linux/tick.h>
>  #include <linux/mm.h>
> +#include <linux/ftrace.h>
>  #include <linux/stackprotector.h>
> 
>  #include <asm/tlb.h>
> @@ -61,6 +62,7 @@ void __weak arch_cpu_idle(void)
>  	cpu_idle_force_poll = 1;
>  	local_irq_enable();
>  }
> +FTRACE_UNSAFE_RCU(arch_cpu_idle);
> 
>  /*
>   * Generic idle loop implementation
> -- 
> 1.7.10.4
> 
> 

