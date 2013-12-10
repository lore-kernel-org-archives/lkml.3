Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751358Ab3LJAF1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Dec 2013 19:05:27 -0500
Received: from e35.co.us.ibm.com ([32.97.110.153]:49132 "EHLO
	e35.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750699Ab3LJAFZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Dec 2013 19:05:25 -0500
Date: Mon, 9 Dec 2013 16:05:21 -0800
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Christoph Lameter <cl@linux.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: rcu: Avoid irq disable in rcu_cpu_kthread
Message-ID: <20131210000521.GH4208@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <00000142c495b75b-c1878909-baf9-42a8-9ba7-62d216d806a7-000000@email.amazonses.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <00000142c495b75b-c1878909-baf9-42a8-9ba7-62d216d806a7-000000@email.amazonses.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13121000-6688-0000-0000-000004575C51
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 05, 2013 at 09:06:55PM +0000, Christoph Lameter wrote:
> Once we have the per cpu patchset merged we could do the following [it
> even works without that patchset but the __this_cpu ops will not do
> preemption checks]. Would this work?

Looks plausible at first glance.  But are you really seeing performance
issues with this code?  It is only compiled into the kernel when you build
with CONFIG_RCU_BOOST=y -- are you actually using that for your workloads?

							Thanx, Paul

> Subject: rcu: Avoid irq disable in rcu_cpu_kthread
> 
> The use of this_cpu ops avoids numerous address calculations
> and allows to avoid the irq enable/disable sequence through a
> low latency non locking this_cpu_xchg.
> 
> Signed-off-by: Christoph Lameter <cl@linux.com>
> 
> Index: linux/kernel/rcu/tree_plugin.h
> ===================================================================
> --- linux.orig/kernel/rcu/tree_plugin.h	2013-12-03 11:32:23.322999660 -0600
> +++ linux/kernel/rcu/tree_plugin.h	2013-12-03 11:32:23.312999941 -0600
> @@ -1417,33 +1417,29 @@ static int rcu_cpu_kthread_should_run(un
>   */
>  static void rcu_cpu_kthread(unsigned int cpu)
>  {
> -	unsigned int *statusp = this_cpu_ptr(&rcu_cpu_kthread_status);
> -	char work, *workp = this_cpu_ptr(&rcu_cpu_has_work);
> +	char work;
>  	int spincnt;
> 
>  	for (spincnt = 0; spincnt < 10; spincnt++) {
>  		trace_rcu_utilization(TPS("Start CPU kthread@rcu_wait"));
>  		local_bh_disable();
> -		*statusp = RCU_KTHREAD_RUNNING;
> -		this_cpu_inc(rcu_cpu_kthread_loops);
> -		local_irq_disable();
> -		work = *workp;
> -		*workp = 0;
> -		local_irq_enable();
> +		__this_cpu_write(rcu_cpu_kthread_status, RCU_KTHREAD_RUNNING);
> +		__this_cpu_inc(rcu_cpu_kthread_loops);
> +		work = this_cpu_xchg(rcu_cpu_has_work, 0);
>  		if (work)
>  			rcu_kthread_do_work();
>  		local_bh_enable();
> -		if (*workp == 0) {
> +		if (__this_cpu_read(rcu_cpu_has_work) == 0) {
>  			trace_rcu_utilization(TPS("End CPU kthread@rcu_wait"));
> -			*statusp = RCU_KTHREAD_WAITING;
> +			__this_cpu_write(rcu_cpu_kthread_status, RCU_KTHREAD_WAITING);
>  			return;
>  		}
>  	}
> -	*statusp = RCU_KTHREAD_YIELDING;
> +	__this_cpu_write(rcu_cpu_kthread_status, RCU_KTHREAD_YIELDING);
>  	trace_rcu_utilization(TPS("Start CPU kthread@rcu_yield"));
>  	schedule_timeout_interruptible(2);
>  	trace_rcu_utilization(TPS("End CPU kthread@rcu_yield"));
> -	*statusp = RCU_KTHREAD_WAITING;
> +	__this_cpu_write(rcu_cpu_kthread_status, RCU_KTHREAD_WAITING);
>  }
> 
>  /*
> 

