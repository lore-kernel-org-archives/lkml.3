Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1947520Ab3BIA35 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Feb 2013 19:29:57 -0500
Received: from e37.co.us.ibm.com ([32.97.110.158]:60825 "EHLO
	e37.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1947344Ab3BIA34 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Feb 2013 19:29:56 -0500
Date: Fri, 8 Feb 2013 16:29:34 -0800
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Rusty Russell <rusty@rustcorp.com.au>,
        "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>,
        Arjan van de Veen <arjan@infradead.org>, Paul Turner <pjt@google.com>,
        Richard Weinberger <rw@linutronix.de>,
        Magnus Damm <magnus.damm@gmail.com>
Subject: Re: [patch 01/40] smpboot: Allow selfparking per cpu threads
Message-ID: <20130209002934.GV2666@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20130131120348.372374706@linutronix.de>
 <20130131120741.553993267@linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130131120741.553993267@linutronix.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13020900-7408-0000-0000-00000CA50AC3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 31, 2013 at 12:11:12PM -0000, Thomas Gleixner wrote:
> The stop machine threads are still killed when a cpu goes offline. The
> reason is that the thread is used to bring the cpu down, so it can't
> be parked along with the other per cpu threads.
> 
> Allow a per cpu thread to be excluded from automatic parking, so it
> can park itself once it's done
> 
> Add a create callback function as well.
> 
> Signed-off-by: Thomas Gleixner <tglx@linutronix.de>

Reviewed-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>

> ---
>  include/linux/smpboot.h |    5 +++++
>  kernel/smpboot.c        |    5 +++--
>  2 files changed, 8 insertions(+), 2 deletions(-)
> 
> Index: linux-2.6/include/linux/smpboot.h
> ===================================================================
> --- linux-2.6.orig/include/linux/smpboot.h
> +++ linux-2.6/include/linux/smpboot.h
> @@ -14,6 +14,8 @@ struct smpboot_thread_data;
>   * @thread_should_run:	Check whether the thread should run or not. Called with
>   *			preemption disabled.
>   * @thread_fn:		The associated thread function
> + * @create:		Optional setup function, called when the thread gets
> + *			created (Not called from the thread context)
>   * @setup:		Optional setup function, called when the thread gets
>   *			operational the first time
>   * @cleanup:		Optional cleanup function, called when the thread
> @@ -22,6 +24,7 @@ struct smpboot_thread_data;
>   *			parked (cpu offline)
>   * @unpark:		Optional unpark function, called when the thread is
>   *			unparked (cpu online)
> + * @selfparking:	Thread is not parked by the park function.
>   * @thread_comm:	The base name of the thread
>   */
>  struct smp_hotplug_thread {
> @@ -29,10 +32,12 @@ struct smp_hotplug_thread {
>  	struct list_head		list;
>  	int				(*thread_should_run)(unsigned int cpu);
>  	void				(*thread_fn)(unsigned int cpu);
> +	void				(*create)(unsigned int cpu);
>  	void				(*setup)(unsigned int cpu);
>  	void				(*cleanup)(unsigned int cpu, bool online);
>  	void				(*park)(unsigned int cpu);
>  	void				(*unpark)(unsigned int cpu);
> +	bool				selfparking;
>  	const char			*thread_comm;
>  };
> 
> Index: linux-2.6/kernel/smpboot.c
> ===================================================================
> --- linux-2.6.orig/kernel/smpboot.c
> +++ linux-2.6/kernel/smpboot.c
> @@ -183,9 +183,10 @@ __smpboot_create_thread(struct smp_hotpl
>  		kfree(td);
>  		return PTR_ERR(tsk);
>  	}
> -
>  	get_task_struct(tsk);
>  	*per_cpu_ptr(ht->store, cpu) = tsk;
> +	if (ht->create)
> +		ht->create(cpu);
>  	return 0;
>  }
> 
> @@ -225,7 +226,7 @@ static void smpboot_park_thread(struct s
>  {
>  	struct task_struct *tsk = *per_cpu_ptr(ht->store, cpu);
> 
> -	if (tsk)
> +	if (tsk && !ht->selfparking)
>  		kthread_park(tsk);
>  }
> 
> 
> 

