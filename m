Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755756Ab3IEXkM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Sep 2013 19:40:12 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:12542 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752733Ab3IEXkK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Sep 2013 19:40:10 -0400
X-Authority-Analysis: v=2.0 cv=V4T/IJbi c=1 sm=0 a=Sro2XwOs0tJUSHxCKfOySw==:17 a=Drc5e87SC40A:10 a=JDfofD-L5ZgA:10 a=5SG0PmZfjMsA:10 a=kj9zAlcOel0A:10 a=meVymXHHAAAA:8 a=KGjhK52YXX0A:10 a=5p3hctMY2UsA:10 a=VnNF1IyMAAAA:8 a=h-DCAE28DS0zIk-F1VEA:9 a=CjuIK1q_8ugA:10 a=jeBq3FmKZ4MA:10 a=Sro2XwOs0tJUSHxCKfOySw==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 67.255.60.225
Date: Thu, 5 Sep 2013 19:40:05 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: paulmck@linux.vnet.ibm.com
Cc: linux-kernel@vger.kernel.org, mingo@elte.hu, laijs@cn.fujitsu.com,
        dipankar@in.ibm.com, akpm@linux-foundation.org,
        mathieu.desnoyers@efficios.com, josh@joshtriplett.org, niv@us.ibm.com,
        tglx@linutronix.de, peterz@infradead.org, dhowells@redhat.com,
        edumazet@google.com, darren@dvhart.com, fweisbec@gmail.com,
        sbw@mit.edu
Subject: Re: [PATCH] rcu: Is it safe to enter an RCU read-side critical
 section?
Message-ID: <20130905194005.05233798@gandalf.local.home>
In-Reply-To: <20130905210537.GA1662@linux.vnet.ibm.com>
References: <20130905195234.GA20555@linux.vnet.ibm.com>
	<20130905162558.6f13add0@gandalf.local.home>
	<20130905205959.GN3966@linux.vnet.ibm.com>
	<20130905210537.GA1662@linux.vnet.ibm.com>
X-Mailer: Claws Mail 3.9.2 (GTK+ 2.24.20; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 5 Sep 2013 14:05:37 -0700
"Paul E. McKenney" <paulmck@linux.vnet.ibm.com> wrote:


> 
> rcu: Is it safe to enter an RCU read-side critical section?
> 
> There is currently no way for kernel code to determine whether it
> is safe to enter an RCU read-side critical section, in other words,

Shouldn't that be a semi-colon?

	"read-side critical section; in other words,"

> whether or not RCU is paying attention to the currently running CPU.
> Given the large and increasing quantity of code shared by the idle loop
> and non-idle code, the this shortcoming is becoming increasingly painful.

s/the//

> 
> This commit therefore adds rcu_watching_this_cpu(), which returns true
> if it is safe to enter an RCU read-side critical section on the currently
> running CPU.  This function is quite fast, using only a __this_cpu_read().
> However, the caller must disable preemption.
> 
> Reported-by: Steven Rostedt <rostedt@goodmis.org>
> Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
> 
> diff --git a/include/linux/rcupdate.h b/include/linux/rcupdate.h
> index 15d33d9..7c024fd 100644
> --- a/include/linux/rcupdate.h
> +++ b/include/linux/rcupdate.h
> @@ -225,6 +225,9 @@ extern void rcu_idle_enter(void);
>  extern void rcu_idle_exit(void);
>  extern void rcu_irq_enter(void);
>  extern void rcu_irq_exit(void);
> +#if defined(CONFIG_SMP) || defined(CONFIG_RCU_TRACE)
> +extern bool rcu_watching_this_cpu(void);

I'm assuming that rcu is always watching a CPU if "!SMP" and
"!RCU_TRACE". Thus you still need to have:

#else
static inline bool rcu_watching_this_cpu(void)
{
	return true;
}

Otherwise we still fail to compile.

-- Steve

> +#endif /* #if defined(CONFIG_SMP) || defined(CONFIG_RCU_TRACE) */
>  
>  #ifdef CONFIG_RCU_USER_QS
>  extern void rcu_user_enter(void);
> diff --git a/kernel/rcutiny.c b/kernel/rcutiny.c
> index 7e3b0d6..fce820f 100644
> --- a/kernel/rcutiny.c
> +++ b/kernel/rcutiny.c
> @@ -189,6 +189,17 @@ EXPORT_SYMBOL(rcu_is_cpu_idle);
>  
>  #endif /* #ifdef CONFIG_DEBUG_LOCK_ALLOC */
>  
> +#ifdef CONFIG_RCU_TRACE
> +/*
> + * Test whether the current CPU can safely enter RCU read-side critical
> + * sections.  The caller must at least have disabled interrupts.
> + */
> +bool rcu_watching_this_cpu(void)
> +{
> +	return !!rcu_dynticks_nesting;
> +}
> +#endif /* #ifdef CONFIG_RCU_TRACE */
> +
>  /*
>   * Test whether the current CPU was interrupted from idle.  Nested
>   * interrupts don't count, we must be running at the first interrupt
> diff --git a/kernel/rcutree.c b/kernel/rcutree.c
> index a06d172..7b8fcee 100644
> --- a/kernel/rcutree.c
> +++ b/kernel/rcutree.c
> @@ -710,6 +710,18 @@ EXPORT_SYMBOL_GPL(rcu_lockdep_current_cpu_online);
>  #endif /* #if defined(CONFIG_PROVE_RCU) && defined(CONFIG_HOTPLUG_CPU) */
>  
>  /**
> + * rcu_watching_this_cpu - are RCU read-side critical sections safe?
> + *
> + * Return true if RCU is watching the running CPU, which means that this
> + * CPU can safely enter RCU read-side critical sections.  The caller must
> + * have at least disabled preemption.
> + */
> +bool rcu_watching_this_cpu(void)
> +{
> +	return !!__this_cpu_read(rcu_dynticks.dynticks_nesting);
> +}
> +
> +/**
>   * rcu_is_cpu_rrupt_from_idle - see if idle or immediately interrupted from idle
>   *
>   * If the current CPU is idle or running at a first-level (not nested)

