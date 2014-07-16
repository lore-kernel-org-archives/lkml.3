Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934945AbaGPSdG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jul 2014 14:33:06 -0400
Received: from e33.co.us.ibm.com ([32.97.110.151]:44736 "EHLO
	e33.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934637AbaGPSdD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jul 2014 14:33:03 -0400
Date: Wed, 16 Jul 2014 11:32:55 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Pranith Kumar <bobby.prani@gmail.com>
Cc: Ingo Molnar <mingo@kernel.org>, linux-kernel@vger.kernel.org,
        fabf@skynet.be, davidshan@tencent.com, joe@perches.com,
        keescook@chromium.org, Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: Re: [GIT PULL rcu/next] RCU commits for 3.17
Message-ID: <20140716183255.GB8690@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20140713184237.GA30855@linux.vnet.ibm.com>
 <20140716115046.GC28434@gmail.com>
 <20140716131322.GA16396@gmail.com>
 <20140716141707.GU8690@linux.vnet.ibm.com>
 <20140716152629.GA9340@linux.vnet.ibm.com>
 <53C6A0E7.30006@gmail.com>
 <20140716172410.GV8690@linux.vnet.ibm.com>
 <53C6C156.5010207@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <53C6C156.5010207@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14071618-0928-0000-0000-0000036A7CDB
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 16, 2014 at 02:15:50PM -0400, Pranith Kumar wrote:
> 
> On 07/16/2014 01:24 PM, Paul E. McKenney wrote:
> >>> And of course if you don't actually specify a nohz_full= mask, then
> >>> tick_nohz_full_mask can be NULL at RCU initialization time, and if it
> >>> is also true that CONFIG_NO_HZ_FULL_ALL=n, this condition can persist
> >>> forever.
> >>>
> >> Hi Paul,
> >>
> >> The other location where tick_nohz_full_mask is being allocated is in
> >> tick_nohz_init_all(), called from tick_nohz_init(). rcu_init() is called before
> >> tick_nohz_init() in init/main.c. CONFIG_NO_HZ_FULL_ALL for allocation of the
> >> mask does not take effect when rcu_init() runs.
> >>
> >> So if nohz_full command line arg is not specified, tick_nohz_full_mask will
> >> always be NULL when rcu_init() runs. So just checking for tick_nohz_full_mask
> >> is NULL should be enough I guess.
> > Yep, that is indeed one of the conditions called out in the commit log
> > below.
> >
> >                             Thanx, Paul
> >
> 
> Sorry, I was not clear.
> 
> nohz_full= boot time parameter overrides the CONFIG_NO_HZ_FULL_ALL build time parameter.
> The check for !CONFIG_NO_HZ_FULL_ALL will disable masking out the cpus on which NOHZ is
> not enabled using the nohz_full boot time parameter, and hence you will enable callback
> offloading on all CPUs as was previously being done.
> 
> So, if I have CONFIG_NO_HZ_FULL_ALL enabled at build time but pass nohz_cpu=1 at boot
> time, all the CPUs will have callback offloading enabled.
> 
> I think the following looks like what is needed in our case:
> 
> diff --git a/kernel/rcu/tree_plugin.h b/kernel/rcu/tree_plugin.h
> index 00dc411..1123ed4 100644
> --- a/kernel/rcu/tree_plugin.h
> +++ b/kernel/rcu/tree_plugin.h
> @@ -2479,10 +2479,10 @@ static void __init rcu_spawn_nocb_kthreads(struct rcu_state *rsp)
> 
>         if (rcu_nocb_mask == NULL)
>                 return;
> -#if defined(CONFIG_NO_HZ_FULL) && !defined(CONFIG_NO_HZ_FULL_ALL)
> +
>         if (tick_nohz_full_running)
>                 cpumask_or(rcu_nocb_mask, rcu_nocb_mask, tick_nohz_full_mask);
> -#endif /* #if defined(CONFIG_NO_HZ_FULL) && !defined(CONFIG_NO_HZ_FULL_ALL) */
> +
>         if (ls == -1) {
>                 ls = int_sqrt(nr_cpu_ids);
>                 rcu_nocb_leader_stride = ls;

Agreed, and I queued something very similar to this.  Testing is in progress.
If it works, I will send it out.  If you want to see it earlier, it is
at branch rcu/urgent on the -rcu tree.

								Thanx, Paul

