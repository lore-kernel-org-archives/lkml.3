Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754151AbaDOTVg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Apr 2014 15:21:36 -0400
Received: from e35.co.us.ibm.com ([32.97.110.153]:46852 "EHLO
	e35.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751012AbaDOTVc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Apr 2014 15:21:32 -0400
Date: Tue, 15 Apr 2014 12:21:27 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Christoph Lameter <cl@linux.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: rcu: Replace __this_cpu_ptr uses with raw_cpu_ptr
Message-ID: <20140415192127.GR4496@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <alpine.DEB.2.10.1404151234030.27440@gentwo.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.10.1404151234030.27440@gentwo.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14041519-6688-0000-0000-0000011E4FB4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 15, 2014 at 12:35:13PM -0500, Christoph Lameter wrote:
> 3.15-rc1 has raw_cpu operations. So this patch that you acked before will
> now apply.
> 
> 
> Subject: rcu: Replace __this_cpu_ptr uses with raw_cpu_ptr
> 
> __this_cpu_ptr is being phased out.
> 
> One special case is increment_cpu_stall_ticks().
> A per cpu variable is incremented so use raw_cpu_inc().
> 
> Cc: Dipankar Sarma <dipankar@in.ibm.com>
> Acked-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
> Signed-off-by: Christoph Lameter <cl@linux.com>

Queued for 3.16, thank you Christoph.

							Thanx, Paul

> Index: linux/kernel/rcu/tree.c
> ===================================================================
> --- linux.orig/kernel/rcu/tree.c	2014-04-14 13:24:55.189353922 -0500
> +++ linux/kernel/rcu/tree.c	2014-04-14 13:24:55.185354000 -0500
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
> @@ -2988,7 +2988,7 @@
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
> --- linux.orig/kernel/rcu/tree_plugin.h	2014-04-14 13:24:55.189353922 -0500
> +++ linux/kernel/rcu/tree_plugin.h	2014-04-14 13:24:55.185354000 -0500
> @@ -1855,7 +1855,7 @@
>  	struct rcu_data *rdp;
> 
>  	for_each_rcu_flavor(rsp) {
> -		rdp = __this_cpu_ptr(rsp->rda);
> +		rdp = raw_cpu_ptr(rsp->rda);
>  		if (rdp->qlen_lazy != 0) {
>  			atomic_inc(&oom_callback_count);
>  			rsp->call(&rdp->oom_head, rcu_oom_callback);
> @@ -1997,7 +1997,7 @@
>  	struct rcu_state *rsp;
> 
>  	for_each_rcu_flavor(rsp)
> -		__this_cpu_ptr(rsp->rda)->ticks_this_gp++;
> +		raw_cpu_inc(rsp->rda->ticks_this_gp);
>  }
> 
>  #else /* #ifdef CONFIG_RCU_CPU_STALL_INFO */
> 

