Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754790Ab3F0UNH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Jun 2013 16:13:07 -0400
Received: from e38.co.us.ibm.com ([32.97.110.159]:42384 "EHLO
	e38.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754747Ab3F0UNA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Jun 2013 16:13:00 -0400
Date: Thu, 27 Jun 2013 13:12:46 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
Cc: tglx@linutronix.de, peterz@infradead.org, tj@kernel.org, oleg@redhat.com,
        rusty@rustcorp.com.au, mingo@kernel.org, akpm@linux-foundation.org,
        namhyung@kernel.org, walken@google.com, vincent.guittot@linaro.org,
        laijs@cn.fujitsu.com, David.Laight@aculab.com, rostedt@goodmis.org,
        wangyun@linux.vnet.ibm.com, xiaoguangrong@linux.vnet.ibm.com,
        sbw@mit.edu, fweisbec@gmail.com, zhong@linux.vnet.ibm.com,
        nikunj@linux.vnet.ibm.com, linux-pm@vger.kernel.org,
        linux-arch@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Dipankar Sarma <dipankar@in.ibm.com>
Subject: Re: [PATCH v3 16/45] rcu: Use cpu_is_offline_nocheck() to avoid
 false-positive warnings
Message-ID: <20130627201246.GA3828@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20130627195136.29830.10445.stgit@srivatsabhat.in.ibm.com>
 <20130627195517.29830.64108.stgit@srivatsabhat.in.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130627195517.29830.64108.stgit@srivatsabhat.in.ibm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13062720-5518-0000-0000-00000FED0CBD
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 28, 2013 at 01:25:17AM +0530, Srivatsa S. Bhat wrote:
> In RCU code, rcu_implicit_dynticks_qs() checks if a CPU is offline,
> while being protected by a spinlock. At first, it appears as if we need to
> use the get/put_online_cpus_atomic() APIs to properly synchronize with CPU
> hotplug, once we get rid of stop_machine(). However, RCU has adequate
> synchronization with CPU hotplug, making that unnecessary. But since the
> locking details are non-trivial, it is hard to teach this to the rudimentary
> hotplug locking validator.
> 
> So use the _nocheck() variants of the cpu accessor functions to prevent false-
> positive warnings from the CPU hotplug debug code. Also, add a comment
> explaining the hotplug synchronization design used in RCU, so that its easy
> to see why it is justified to use the _nocheck() variants.
> 
> Cc: Dipankar Sarma <dipankar@in.ibm.com>
> Cc: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
> Signed-off-by: Srivatsa S. Bhat <srivatsa.bhat@linux.vnet.ibm.com>

Reviewed-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>

> ---
> 
>  kernel/rcutree.c |   12 +++++++++++-
>  1 file changed, 11 insertions(+), 1 deletion(-)
> 
> diff --git a/kernel/rcutree.c b/kernel/rcutree.c
> index cf3adc6..ced28a45 100644
> --- a/kernel/rcutree.c
> +++ b/kernel/rcutree.c
> @@ -794,7 +794,17 @@ static int rcu_implicit_dynticks_qs(struct rcu_data *rdp)
>  	if (ULONG_CMP_GE(rdp->rsp->gp_start + 2, jiffies))
>  		return 0;  /* Grace period is not old enough. */
>  	barrier();
> -	if (cpu_is_offline(rdp->cpu)) {
> +
> +	/*
> +	 * It is safe to use the _nocheck() version of cpu_is_offline() here
> +	 * (to avoid false-positive warnings from CPU hotplug debug code),
> +	 * because:
> +	 * 1. rcu_gp_init() holds off CPU hotplug operations during grace
> +	 *    period initialization.
> +	 * 2. The current grace period has not ended yet.
> +	 * So it is safe to sample the offline state without synchronization.
> +	 */
> +	if (cpu_is_offline_nocheck(rdp->cpu)) {
>  		trace_rcu_fqs(rdp->rsp->name, rdp->gpnum, rdp->cpu, "ofl");
>  		rdp->offline_fqs++;
>  		return 1;
> 

