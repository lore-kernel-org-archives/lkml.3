Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753447Ab3JUWze (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Oct 2013 18:55:34 -0400
Received: from ozlabs.org ([203.10.76.45]:55289 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753219Ab3JUWzN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Oct 2013 18:55:13 -0400
From: Michael Neuling <michael.neuling@au1.ibm.com>
To: Vaidyanathan Srinivasan <svaidy@linux.vnet.ibm.com>
cc: Peter Zijlstra <peterz@infradead.org>,
        Mike Galbraith <bitbucket@online.de>, Paul Turner <pjt@google.com>,
        Ingo Molnar <mingo@kernel.org>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        linux-kernel@vger.kernel.org, Anton Blanchard <anton@samba.org>,
        Preeti U Murthy <preeti@linux.vnet.ibm.com>,
        linuxppc-dev@lists.ozlabs.org
Subject: Re: [PATCH 2/3] sched: Fix asymmetric scheduling for POWER7
In-reply-to: <20131021114452.13291.19947.stgit@drishya>
References: <20131021114002.13291.31478.stgit@drishya> <20131021114452.13291.19947.stgit@drishya>
Comments: In-reply-to Vaidyanathan Srinivasan <svaidy@linux.vnet.ibm.com>
   message dated "Mon, 21 Oct 2013 17:14:52 +0530."
X-Mailer: MH-E 8.2; nmh 1.5; GNU Emacs 23.4.1
Date: Tue, 22 Oct 2013 09:55:10 +1100
Message-ID: <21476.1382396110@ale.ozlabs.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Vaidyanathan Srinivasan <svaidy@linux.vnet.ibm.com> wrote:

> Asymmetric scheduling within a core is a scheduler loadbalancing
> feature that is triggered when SD_ASYM_PACKING flag is set.  The goal
> for the load balancer is to move tasks to lower order idle SMT threads
> within a core on a POWER7 system.
> 
> In nohz_kick_needed(), we intend to check if our sched domain (core)
> is completely busy or we have idle cpu.
> 
> The following check for SD_ASYM_PACKING:
> 
>     (cpumask_first_and(nohz.idle_cpus_mask, sched_domain_span(sd)) < cpu)
> 
> already covers the case of checking if the domain has an idle cpu,
> because cpumask_first_and() will not yield any set bits if this domain
> has no idle cpu.
> 
> Hence, nr_busy check against group weight can be removed.
> 
> Reported-by: Michael Neuling <michael.neuling@au1.ibm.com>

Tested-by: Michael Neuling <mikey@neuling.org>

Peter, I tested this only a brief while back but it turned out my test
wasn't stringent enough and it was actually broken (in v3.9).  This
fixes it.

Mikey

> Signed-off-by: Vaidyanathan Srinivasan <svaidy@linux.vnet.ibm.com>
> Signed-off-by: Preeti U Murthy <preeti@linux.vnet.ibm.com>
> ---
>  kernel/sched/fair.c |    4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
> index 12f0eab..828ed97 100644
> --- a/kernel/sched/fair.c
> +++ b/kernel/sched/fair.c
> @@ -5821,8 +5821,8 @@ static inline int nohz_kick_needed(struct rq *rq, int cpu)
>  				goto need_kick_unlock;
>  		}
>  
> -		if (sd->flags & SD_ASYM_PACKING && nr_busy != sg->group_weight
> -		    && (cpumask_first_and(nohz.idle_cpus_mask,
> +		if (sd->flags & SD_ASYM_PACKING &&
> +			(cpumask_first_and(nohz.idle_cpus_mask,
>  					  sched_domain_span(sd)) < cpu))
>  			goto need_kick_unlock;
>  
> 
