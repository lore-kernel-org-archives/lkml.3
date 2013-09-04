Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934306Ab3IDB62 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Sep 2013 21:58:28 -0400
Received: from intranet.asianux.com ([58.214.24.6]:42021 "EHLO
	intranet.asianux.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761569Ab3IDB61 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Sep 2013 21:58:27 -0400
X-Spam-Score: -100.9
Message-ID: <52269384.4040802@asianux.com>
Date: Wed, 04 Sep 2013 09:57:24 +0800
From: Chen Gang <gang.chen@asianux.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130110 Thunderbird/17.0.2
MIME-Version: 1.0
To: paulmck@linux.vnet.ibm.com
CC: Chen Gang F T <chen.gang.flying.transformer@gmail.com>,
        dipankar@in.ibm.com,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] kernel/rcutree.c: deem to be lazy if there are no callbacks.
References: <5212E7BB.4020602@asianux.com> <20130820041832.GY29406@linux.vnet.ibm.com> <5212F3E5.7080700@asianux.com> <5212F467.8090407@asianux.com> <52145741.7000008@asianux.com> <20130821142301.GX29406@linux.vnet.ibm.com> <52157F21.5080200@asianux.com> <20130825191839.GA22515@linux.vnet.ibm.com> <521ABB9E.1050209@gmail.com> <5225766F.4000907@asianux.com> <20130903175910.GX3871@linux.vnet.ibm.com>
In-Reply-To: <20130903175910.GX3871@linux.vnet.ibm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/04/2013 01:59 AM, Paul E. McKenney wrote:
> On Tue, Sep 03, 2013 at 01:41:03PM +0800, Chen Gang wrote:
>> Hello Maintainers:
>>
>> Is this issue finished ?
>>
>> If need additional help from me (e.g. some test things, or others, if
>> you have no time, can let me try), please let me know, I should try.
> 
> Ah, sorry, here is the patch.
> 

Thanks.

:-)

> 							Thanx, Paul
> 
> ------------------------------------------------------------------------
> 
>     rcu: Micro-optimize rcu_cpu_has_callbacks()
>     
>     The for_each_rcu_flavor() loop unconditionally scans all flavors, even
>     when the first flavor might have some non-lazy callbacks.  Once the
>     loop has seen a non-lazy callback, further passes through the loop
>     cannot change the state.  This is not a huge problem, given that there
>     can be at most three RCU flavors (RCU-bh, RCU-preempt, and RCU-sched),
>     but this code is on the path to idle, so speeding it up even a small
>     amount would have some benefit.
>     
>     This commit therefore does two things:
>     
>     1.	Rearranges the order of the list of RCU flavors in order to
>     	place the most active flavor first in the list.  The most active
>     	RCU flavor is RCU-preempt, or, if there is no RCU-preempt,
>     	RCU-sched.
>     
>     2.	Reworks the for_each_rcu_flavor() to exit early when the first
>     	non-lazy callback is seen, or, in the case where the caller
>     	does not care about non-lazy callbacks (RCU_FAST_NO_HZ=n),
>     	when the first callback is seen.
>     
>     Reported-by: Chen Gang <gang.chen@asianux.com>
>     Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
> 
> diff --git a/kernel/rcutree.c b/kernel/rcutree.c
> index b1b959d..38596be 100644
> --- a/kernel/rcutree.c
> +++ b/kernel/rcutree.c
> @@ -2756,10 +2756,13 @@ static int rcu_cpu_has_callbacks(int cpu, bool *all_lazy)
>  
>  	for_each_rcu_flavor(rsp) {
>  		rdp = per_cpu_ptr(rsp->rda, cpu);
> -		if (rdp->qlen != rdp->qlen_lazy)
> +		if (!rdp->nxtlist)
> +			continue;
> +		hc = true;
> +		if (rdp->qlen != rdp->qlen_lazy || !all_lazy) {
>  			al = false;
> -		if (rdp->nxtlist)
> -			hc = true;
> +			break;
> +		}
>  	}
>  	if (all_lazy)
>  		*all_lazy = al;
> @@ -3326,8 +3329,8 @@ void __init rcu_init(void)
>  
>  	rcu_bootup_announce();
>  	rcu_init_geometry();
> -	rcu_init_one(&rcu_sched_state, &rcu_sched_data);
>  	rcu_init_one(&rcu_bh_state, &rcu_bh_data);
> +	rcu_init_one(&rcu_sched_state, &rcu_sched_data);
>  	__rcu_init_preempt();
>  	open_softirq(RCU_SOFTIRQ, rcu_process_callbacks);
>  
> 
> 
> 


-- 
Chen Gang
