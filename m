Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754274Ab3JVOg1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Oct 2013 10:36:27 -0400
Received: from e23smtp04.au.ibm.com ([202.81.31.146]:47889 "EHLO
	e23smtp04.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753807Ab3JVOgY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Oct 2013 10:36:24 -0400
Date: Tue, 22 Oct 2013 20:05:59 +0530
From: Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>
To: Vaidyanathan Srinivasan <svaidy@linux.vnet.ibm.com>
Cc: Peter Zijlstra <peterz@infradead.org>,
        Mike Galbraith <bitbucket@online.de>, Paul Turner <pjt@google.com>,
        Ingo Molnar <mingo@kernel.org>, Michael Neuling <mikey@neuling.org>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        linux-kernel@vger.kernel.org, Anton Blanchard <anton@samba.org>,
        Preeti U Murthy <preeti@linux.vnet.ibm.com>,
        linuxppc-dev@lists.ozlabs.org, vincent.guittot@linaro.org,
        suresh.b.siddha@intel.com
Subject: Re: [PATCH 1/3] sched: Fix nohz_kick_needed to consider the nr_busy
 of the parent domain's group
Message-ID: <20131022143559.GA3197@linux.vnet.ibm.com>
Reply-To: Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>
References: <20131021114002.13291.31478.stgit@drishya>
 <20131021114442.13291.99344.stgit@drishya>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <20131021114442.13291.99344.stgit@drishya>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13102214-9264-0000-0000-000004C74207
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Vaidyanathan Srinivasan <svaidy@linux.vnet.ibm.com> [2013-10-21 17:14:42]:

>  	for_each_domain(cpu, sd) {
> -		struct sched_group *sg = sd->groups;
> -		struct sched_group_power *sgp = sg->sgp;
> -		int nr_busy = atomic_read(&sgp->nr_busy_cpus);
> -
> -		if (sd->flags & SD_SHARE_PKG_RESOURCES && nr_busy > 1)
> -			goto need_kick_unlock;
> +		struct sched_domain *sd_parent = sd->parent;
> +		struct sched_group *sg;
> +		struct sched_group_power *sgp;
> +		int nr_busy;
> +
> +		if (sd_parent) {
> +			sg = sd_parent->groups;
> +			sgp = sg->sgp;
> +			nr_busy = atomic_read(&sgp->nr_busy_cpus);
> +
> +			if (sd->flags & SD_SHARE_PKG_RESOURCES && nr_busy > 1)
> +				goto need_kick_unlock;
> +		}
> 
>  		if (sd->flags & SD_ASYM_PACKING && nr_busy != sg->group_weight
>  		    && (cpumask_first_and(nohz.idle_cpus_mask,

CC'ing Suresh Siddha and Vincent Guittot

Please correct me, If my understanding of idle balancing is wrong.
With proposed approach will not idle load balancer kick in, even if
there are busy cpus across groups or if there are 2 busy cpus which
are spread across sockets.

Consider 2 socket machine with 4 processors each (MC and NUMA domains).
If the machine is partial loaded such that cpus 0,4,5,6,7 are busy, then too
nohz balancing is triggered because with this approach
(NUMA)->groups->sgp->nr_busy_cpus is taken in account for nohz kick, while
iterating over MC domain.

Isn't idle load balancer not suppose kick in, even in the case of two busy
cpu's in a dual-core single socket system.

Thanks,
Kamalesh.

