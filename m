Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932342Ab3BIA6v (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Feb 2013 19:58:51 -0500
Received: from e35.co.us.ibm.com ([32.97.110.153]:34106 "EHLO
	e35.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932299Ab3BIA6t (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Feb 2013 19:58:49 -0500
Date: Fri, 8 Feb 2013 16:54:13 -0800
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Rusty Russell <rusty@rustcorp.com.au>,
        "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>,
        Arjan van de Veen <arjan@infradead.org>, Paul Turner <pjt@google.com>,
        Richard Weinberger <rw@linutronix.de>,
        Magnus Damm <magnus.damm@gmail.com>
Subject: Re: [patch 06/40] cpu: hotplug: Split out cpu down functions
Message-ID: <20130209005413.GA2666@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20130131120348.372374706@linutronix.de>
 <20130131120741.897171827@linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130131120741.897171827@linutronix.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13020900-4834-0000-0000-00000371698A
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 31, 2013 at 12:11:16PM -0000, Thomas Gleixner wrote:
> Split cpu_down in separate functions in preparation for state machine
> conversion.
> 
> Signed-off-by: Thomas Gleixner <tglx@linutronix.de>

Reviewed-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>

> ---
>  kernel/cpu.c |   83 +++++++++++++++++++++++++++++++++++++----------------------
>  1 file changed, 53 insertions(+), 30 deletions(-)
> 
> Index: linux-2.6/kernel/cpu.c
> ===================================================================
> --- linux-2.6.orig/kernel/cpu.c
> +++ linux-2.6/kernel/cpu.c
> @@ -206,11 +206,6 @@ static int bringup_cpu(unsigned int cpu)
>  }
> 
>  #ifdef CONFIG_HOTPLUG_CPU
> -
> -static void cpu_notify_nofail(unsigned long val, unsigned int cpu)
> -{
> -	BUG_ON(cpu_notify(val, cpu));
> -}
>  EXPORT_SYMBOL(register_cpu_notifier);
> 
>  void __ref unregister_cpu_notifier(struct notifier_block *nb)
> @@ -278,6 +273,25 @@ static inline void check_for_tasks(int c
>  	write_unlock_irq(&tasklist_lock);
>  }
> 
> +static void cpu_notify_nofail(unsigned long val, unsigned int cpu)
> +{
> +	BUG_ON(cpu_notify(val, cpu));
> +}
> +
> +static int notify_down_prepare(unsigned int cpu)
> +{
> +	int err, nr_calls = 0;
> +
> +	err = __cpu_notify(CPU_DOWN_PREPARE, cpu, -1, &nr_calls);
> +	if (err) {
> +		nr_calls--;
> +		__cpu_notify(CPU_DOWN_FAILED, cpu, nr_calls, NULL);
> +		printk("%s: attempt to take down CPU %u failed\n",
> +				__func__, cpu);
> +	}
> +	return err;
> +}
> +
>  /* Take this CPU down. */
>  static int __ref take_cpu_down(void *_param)
>  {
> @@ -294,37 +308,17 @@ static int __ref take_cpu_down(void *_pa
>  	return 0;
>  }
> 
> -/* Requires cpu_add_remove_lock to be held */
> -static int __ref _cpu_down(unsigned int cpu, int tasks_frozen)
> +static int takedown_cpu(unsigned int cpu)
>  {
> -	int err, nr_calls = 0;
> -
> -	if (num_online_cpus() == 1)
> -		return -EBUSY;
> -
> -	if (!cpu_online(cpu))
> -		return -EINVAL;
> -
> -	cpu_hotplug_begin();
> -
> -	cpuhp_tasks_frozen = tasks_frozen;
> +	int err;
> 
> -	err = __cpu_notify(CPU_DOWN_PREPARE, cpu, -1, &nr_calls);
> -	if (err) {
> -		nr_calls--;
> -		__cpu_notify(CPU_DOWN_FAILED, cpu, nr_calls, NULL);
> -		printk("%s: attempt to take down CPU %u failed\n",
> -				__func__, cpu);
> -		goto out_release;
> -	}
>  	smpboot_park_threads(cpu);
> -
>  	err = __stop_machine(take_cpu_down, NULL, cpumask_of(cpu));
>  	if (err) {
>  		/* CPU didn't die: tell everyone.  Can't complain. */
>  		smpboot_unpark_threads(cpu);
>  		cpu_notify_nofail(CPU_DOWN_FAILED, cpu);
> -		goto out_release;
> +		return err;
>  	}
>  	BUG_ON(cpu_online(cpu));
> 
> @@ -341,10 +335,39 @@ static int __ref _cpu_down(unsigned int 
>  	/* This actually kills the CPU. */
>  	__cpu_die(cpu);
> 
> -	/* CPU is completely dead: tell everyone.  Too late to complain. */
> -	cpu_notify_nofail(CPU_DEAD, cpu);
> +	return 0;
> +}
> 
> +static int notify_dead(unsigned int cpu)
> +{
> +	cpu_notify_nofail(CPU_DEAD, cpu);
>  	check_for_tasks(cpu);
> +	return 0;
> +}
> +
> +/* Requires cpu_add_remove_lock to be held */
> +static int __ref _cpu_down(unsigned int cpu, int tasks_frozen)
> +{
> +	int err;
> +
> +	if (num_online_cpus() == 1)
> +		return -EBUSY;
> +
> +	if (!cpu_online(cpu))
> +		return -EINVAL;
> +
> +	cpu_hotplug_begin();
> +
> +	cpuhp_tasks_frozen = tasks_frozen;
> +
> +	err = notify_down_prepare(cpu);
> +	if (err)
> +		goto out_release;
> +	err = takedown_cpu(cpu);
> +	if (err)
> +		goto out_release;
> +
> +	notify_dead(cpu);
> 
>  out_release:
>  	cpu_hotplug_done();
> 
> 

