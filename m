Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757673AbaISPNI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Sep 2014 11:13:08 -0400
Received: from bombadil.infradead.org ([198.137.202.9]:49430 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756797AbaISPKK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Sep 2014 11:10:10 -0400
Date: Thu, 18 Sep 2014 19:28:35 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Dave Hansen <dave@sr71.net>
Cc: mingo@kernel.org, hpa@linux.intel.com, brice.goglin@gmail.com,
        bp@alien8.de, linux-kernel@vger.kernel.org,
        dave.hansen@linux.intel.com
Subject: Re: [RFC][PATCH 4/6] sched: eliminate "DIE" domain level when NUMA
 present
Message-ID: <20140918172835.GS2840@worktop.localdomain>
References: <20140917223310.026BCC2C@viggo.jf.intel.com>
 <20140917223316.FCEAF8FB@viggo.jf.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140917223316.FCEAF8FB@viggo.jf.intel.com>
User-Agent: Mutt/1.5.22.1 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 17, 2014 at 03:33:16PM -0700, Dave Hansen wrote:
> 
> From: Dave Hansen <dave.hansen@linux.intel.com>
> 
> The "DIE" topology level is currently defined like this:
> 
> static inline const struct cpumask *cpu_cpu_mask(int cpu)
> {
>         return cpumask_of_node(cpu_to_node(cpu));
> }
> 
> But that makes very little sense on a NUMA system since
> the lowest-domain NUMA node is guaranteed to be essentially
> the same as this level.
> 
> We leave this for systems that are !CONFIG_NUMA and that
> might need a top-level domain.
> 
> This also keeps us from having screwy topologies when the
> smallest NUMA node is only _part_ of the die.
> 
> Signed-off-by: Dave Hansen <dave.hansen@linux.intel.com>
> ---
> 
>  b/kernel/sched/core.c |    2 ++
>  1 file changed, 2 insertions(+)
> 
> diff -puN kernel/sched/core.c~die-is-NUMA-based-and-screwed-up kernel/sched/core.c
> --- a/kernel/sched/core.c~die-is-NUMA-based-and-screwed-up	2014-09-17 15:28:57.867588315 -0700
> +++ b/kernel/sched/core.c	2014-09-17 15:28:57.873588591 -0700
> @@ -6141,7 +6141,9 @@ static struct sched_domain_topology_leve
>  #ifdef CONFIG_SCHED_MC
>  	{ cpu_coregroup_mask, cpu_core_flags, SD_INIT_NAME(MC) },
>  #endif
> +#ifndef CONFIG_NUMA
>  	{ cpu_cpu_mask, SD_INIT_NAME(DIE) },
> +#endif
>  	{ NULL, },
>  };

Yeah, no. Also, looking at it now, I see why it worked and how its been
wrong :-) As you say it returns the node mask, not the PKG mask as it
should have been doing.

So don't change the default topology, in general I'd say its still true
that you get one or more packages inside a node. Change override the
default topology in arch code.



