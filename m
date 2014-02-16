Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752860AbaBPQRy (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Feb 2014 11:17:54 -0500
Received: from e35.co.us.ibm.com ([32.97.110.153]:36016 "EHLO
	e35.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752451AbaBPQRw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Feb 2014 11:17:52 -0500
Date: Sun, 16 Feb 2014 08:17:45 -0800
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Christoph Lameter <cl@linux.com>
Cc: Tejun Heo <tj@kernel.org>, akpm@linuxfoundation.org, rostedt@goodmis.org,
        linux-kernel@vger.kernel.org, Ingo Molnar <mingo@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Dipankar Sarma <dipankar@in.ibm.com>
Subject: Re: [PATCH 24/48] rcu: Replace __this_cpu_ptr uses with raw_cpu_ptr
Message-ID: <20140216161745.GC4250@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20140214201841.826179349@linux.com>
 <20140214201906.486328867@linux.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140214201906.486328867@linux.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14021616-6688-0000-0000-0000069F4B88
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 14, 2014 at 02:19:05PM -0600, Christoph Lameter wrote:
> [Patch depends on another patch in this series that introduces raw_cpu_ops]
> 
> __this_cpu_ptr is being phased out.
> 
> One special case is increment_cpu_stall_ticks().
> A per cpu variable is incremented so use raw_cpu_inc().
> 
> Cc: Dipankar Sarma <dipankar@in.ibm.com>
> Cc: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
> Signed-off-by: Christoph Lameter <cl@linux.com>

Acked-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>

> Index: linux/kernel/rcu/tree.c
> ===================================================================
> --- linux.orig/kernel/rcu/tree.c	2014-02-03 13:23:21.855072103 -0600
> +++ linux/kernel/rcu/tree.c	2014-02-03 13:23:21.845072311 -0600
> @@ -1951,7 +1951,7 @@
>  static void rcu_adopt_orphan_cbs(struct rcu_state *rsp, unsigned long flags)
>  {
>  	int i;
> -	struct rcu_data *rdp = __this_cpu_ptr(rsp->rda);
> +	struct rcu_data *rdp = raw_cpu_ptr(rsp->rda);
> 
>  	/* No-CBs CPUs are handled specially. */
>  	if (rcu_nocb_adopt_orphan_cbs(rsp, rdp, flags))
> @@ -2334,7 +2334,7 @@
>  __rcu_process_callbacks(struct rcu_state *rsp)
>  {
>  	unsigned long flags;
> -	struct rcu_data *rdp = __this_cpu_ptr(rsp->rda);
> +	struct rcu_data *rdp = raw_cpu_ptr(rsp->rda);
> 
>  	WARN_ON_ONCE(rdp->beenonline == 0);
> 
> @@ -2936,7 +2936,7 @@
>  static void rcu_barrier_func(void *type)
>  {
>  	struct rcu_state *rsp = type;
> -	struct rcu_data *rdp = __this_cpu_ptr(rsp->rda);
> +	struct rcu_data *rdp = raw_cpu_ptr(rsp->rda);
> 
>  	_rcu_barrier_trace(rsp, "IRQ", -1, rsp->n_barrier_done);
>  	atomic_inc(&rsp->barrier_cpu_count);
> Index: linux/kernel/rcu/tree_plugin.h
> ===================================================================
> --- linux.orig/kernel/rcu/tree_plugin.h	2014-02-03 13:23:21.855072103 -0600
> +++ linux/kernel/rcu/tree_plugin.h	2014-02-03 13:23:21.845072311 -0600
> @@ -1848,7 +1848,7 @@
>  	struct rcu_data *rdp;
> 
>  	for_each_rcu_flavor(rsp) {
> -		rdp = __this_cpu_ptr(rsp->rda);
> +		rdp = raw_cpu_ptr(rsp->rda);
>  		if (rdp->qlen_lazy != 0) {
>  			atomic_inc(&oom_callback_count);
>  			rsp->call(&rdp->oom_head, rcu_oom_callback);
> @@ -1990,7 +1990,7 @@
>  	struct rcu_state *rsp;
> 
>  	for_each_rcu_flavor(rsp)
> -		__this_cpu_ptr(rsp->rda)->ticks_this_gp++;
> +		raw_cpu_inc(rsp->rda->ticks_this_gp);
>  }
> 
>  #else /* #ifdef CONFIG_RCU_CPU_STALL_INFO */
> 

