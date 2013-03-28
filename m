Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756792Ab3C1Pp5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Mar 2013 11:45:57 -0400
Received: from e28smtp05.in.ibm.com ([122.248.162.5]:60973 "EHLO
	e28smtp05.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756745Ab3C1Ppw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Mar 2013 11:45:52 -0400
Message-ID: <5154651A.6010304@linux.vnet.ibm.com>
Date: Thu, 28 Mar 2013 21:13:22 +0530
From: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:15.0) Gecko/20120828 Thunderbird/15.0
MIME-Version: 1.0
To: Thomas Gleixner <tglx@linutronix.de>
CC: LKML <linux-kernel@vger.kernel.org>, linux-arch@vger.kernel.org,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Rusty Russell <rusty@rustcorp.com.au>,
        Paul McKenney <paulmck@linux.vnet.ibm.com>,
        Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <peterz@infradead.org>,
        Magnus Damm <magnus.damm@gmail.com>, x86@kernel.org
Subject: Re: [patch 33/34] x86: Use generic idle loop
References: <20130321214930.752934102@linutronix.de> <20130321215235.486594473@linutronix.de>
In-Reply-To: <20130321215235.486594473@linutronix.de>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13032815-8256-0000-0000-000006D7ED30
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/22/2013 03:23 AM, Thomas Gleixner wrote:
> Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
> Cc: x86@kernel.org
> ---
[...]
> +#define POLL_IDLE	(void*) 0x01
> +

[...]

>  #ifdef CONFIG_APM_MODULE
> @@ -411,20 +376,6 @@ void stop_this_cpu(void *dummy)
>  		halt();
>  }
> 
> -/*
> - * On SMP it's slightly faster (but much more power-consuming!)
> - * to poll the ->work.need_resched flag instead of waiting for the
> - * cross-CPU IPI to arrive. Use this option with caution.
> - */
> -static void poll_idle(void)
> -{
> -	trace_cpu_idle_rcuidle(0, smp_processor_id());
> -	local_irq_enable();
> -	while (!need_resched())
> -		cpu_relax();
> -	trace_cpu_idle_rcuidle(PWR_EVENT_EXIT, smp_processor_id());
> -}
> -
>  bool amd_e400_c1e_detected;
>  EXPORT_SYMBOL(amd_e400_c1e_detected);
> 
> @@ -489,7 +440,7 @@ static void amd_e400_idle(void)
>  void __cpuinit select_idle_routine(const struct cpuinfo_x86 *c)
>  {
>  #ifdef CONFIG_SMP
> -	if (x86_idle == poll_idle && smp_num_siblings > 1)
> +	if (x86_idle == POLL_IDLE && smp_num_siblings > 1)
>  		pr_warn_once("WARNING: polling idle and HT enabled, performance may degrade\n");
>  #endif
>  	if (x86_idle)
> @@ -517,8 +468,9 @@ static int __init idle_setup(char *str)
> 
>  	if (!strcmp(str, "poll")) {
>  		pr_info("using polling idle threads\n");
> -		x86_idle = poll_idle;
> +		x86_idle = POLL_IDLE;
>  		boot_option_idle_override = IDLE_POLL;
> +		cpu_idle_poll_ctrl(true);

Why is that POLL_IDLE needed? Won't cpu_idle_poll_ctrl() suffice?

By the way, booting with idle=poll locks up the kernel during boot with
this patch applied (I verified it). So I think we should just skip the
whole POLL_IDLE thing and leave the job to cpu_idle_poll_ctrl().

 
Regards,
Srivatsa S. Bhat

