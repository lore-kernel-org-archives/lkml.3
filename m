Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932272Ab3KFNyB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Nov 2013 08:54:01 -0500
Received: from e06smtp11.uk.ibm.com ([195.75.94.107]:55379 "EHLO
	e06smtp11.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932092Ab3KFNx7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Nov 2013 08:53:59 -0500
Date: Wed, 6 Nov 2013 14:53:44 +0100
From: Martin Schwidefsky <schwidefsky@de.ibm.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Vincent Guittot <vincent.guittot@linaro.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Ingo Molnar <mingo@kernel.org>, Paul Turner <pjt@google.com>,
        Morten Rasmussen <Morten.Rasmussen@arm.com>,
        "cmetcalf@tilera.com" <cmetcalf@tilera.com>,
        "tony.luck@intel.com" <tony.luck@intel.com>,
        Alex Shi <alex.shi@intel.com>,
        Preeti U Murthy <preeti@linux.vnet.ibm.com>,
        "linaro-kernel@lists.linaro.org" <linaro-kernel@lists.linaro.org>,
        "Rafael J. Wysocki" <rjw@sisk.pl>,
        Paul McKenney <paulmck@linux.vnet.ibm.com>,
        Jonathan Corbet <corbet@lwn.net>, Thomas Gleixner <tglx@linutronix.de>,
        Len Brown <len.brown@intel.com>,
        Arjan van de Ven <arjan@linux.intel.com>,
        Amit Kucheria <amit.kucheria@linaro.org>,
        Lukasz Majewski <l.majewski@samsung.com>, james.hogan@imgtec.com,
        heiko.carstens@de.ibm.com
Subject: Re: [RFC][PATCH v5 01/14] sched: add a new arch_sd_local_flags for
 sched_domain init
Message-ID: <20131106145344.448d7733@mschwide>
In-Reply-To: <20131105222752.GD16117@laptop.programming.kicks-ass.net>
References: <1382097147-30088-1-git-send-email-vincent.guittot@linaro.org>
	<1382097147-30088-2-git-send-email-vincent.guittot@linaro.org>
	<20131105140626.GP31370@twins.programming.kicks-ass.net>
	<CAKfTPtCYHKRv=w3b4tZV-2BW_a_T+tkO9Qpc0PhLD=uZY1yvfw@mail.gmail.com>
	<20131105222752.GD16117@laptop.programming.kicks-ass.net>
Organization: IBM Corporation
X-Mailer: Claws Mail 3.8.0 (GTK+ 2.24.10; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13110613-5024-0000-0000-000007BCA5DA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 5 Nov 2013 23:27:52 +0100
Peter Zijlstra <peterz@infradead.org> wrote:

> On Tue, Nov 05, 2013 at 03:57:23PM +0100, Vincent Guittot wrote:
> > Your proposal looks fine for me. It's clearly better to move in one
> > place the configuration of sched_domain fields. Have you already got
> > an idea about how to let architecture override the topology?
> 
> Maybe something like the below -- completely untested (my s390 compiler
> is on a machine that's currently powered off).

In principle I do not see a reason why this should not work, but there
are a few more things to take care of. E.g. struct sd_data is defined
in kernel/sched/core.c, cpu_cpu_mask as well. These need to be moved
to a header where arch/s390/kernel/smp.c can pick it up.

I do have the feeling that the sched_domain_topology should be left
where they are, or do we really want to expose more of the scheduler
internals?

> > My primary need comes from the fact that the topology configuration is
> > not the same for all cores
> 
> Do expand.. the various cpu masks used in the topology list are per cpu,
> is that sufficient room to wriggle or do you need more?
> 
> ---
> --- a/arch/s390/kernel/smp.c
> +++ b/arch/s390/kernel/smp.c
> @@ -1070,3 +1070,23 @@ static int __init s390_smp_init(void)
>  	return 0;
>  }
>  subsys_initcall(s390_smp_init);
> +
> +static struct sched_domain_topology_level s390_topology[] = {
> +#ifdef CONFIG_SCHED_SMT
> +	{ cpu_smt_mask, SD_SHARE_CPUPOWER | SD_SHARE_PKG_RESOURCES },
> +#endif
> +#ifdef CONFIG_SCHED_MC
> +	{ cpu_coregroup_mask, SD_SHARE_PKG_RESOURCES },
> +#endif
> +#ifdef CONFIG_SCHED_BOOK
> +	{ cpu_book_mask, },
> +#endif
> +	{ cpu_cpu_mask, },
> +	{ NULL, },
> +};
> +
> +static int __init s390_sched_topology(void)
> +{
> +	sched_domain_topology = s390_topology;
> +}
> +early_initcall(s390_sched_topology);
> --- a/include/linux/sched.h
> +++ b/include/linux/sched.h
> @@ -889,6 +889,20 @@ void free_sched_domains(cpumask_var_t do
> 
>  bool cpus_share_cache(int this_cpu, int that_cpu);
> 
> +typedef const struct cpumask *(*sched_domain_mask_f)(int cpu);
> +
> +#define SDTL_OVERLAP	0x01
> +
> +struct sched_domain_topology_level {
> +	sched_domain_mask_f mask;
> +	int		    sd_flags;
> +	int		    flags;
> +	int		    numa_level;
> +	struct sd_data      data;
> +};
> +
> +extern struct sched_domain_topology_level *sched_domain_topology;
> +
>  #else /* CONFIG_SMP */
> 
>  struct sched_domain_attr;
> --- a/kernel/sched/core.c
> +++ b/kernel/sched/core.c
> @@ -5377,20 +5377,6 @@ enum s_alloc {
>  	sa_none,
>  };
> 
> -struct sched_domain_topology_level;
> -
> -typedef const struct cpumask *(*sched_domain_mask_f)(int cpu);
> -
> -#define SDTL_OVERLAP	0x01
> -
> -struct sched_domain_topology_level {
> -	sched_domain_mask_f mask;
> -	int		    sd_flags;
> -	int		    flags;
> -	int		    numa_level;
> -	struct sd_data      data;
> -};
> -
>  /*
>   * Build an iteration mask that can exclude certain CPUs from the upwards
>   * domain traversal.
> @@ -5841,6 +5827,7 @@ sd_init(struct sched_domain_topology_lev
> 
>  	return sd;
>  }
> +
>  /*
>   * Topology list, bottom-up.
>   */
> @@ -5851,14 +5838,11 @@ static struct sched_domain_topology_leve
>  #ifdef CONFIG_SCHED_MC
>  	{ cpu_coregroup_mask, SD_SHARE_PKG_RESOURCES },
>  #endif
> -#ifdef CONFIG_SCHED_BOOK
> -	{ cpu_book_mask, },
> -#endif
>  	{ cpu_cpu_mask, },
>  	{ NULL, },
>  };
> 
> -static struct sched_domain_topology_level *sched_domain_topology = default_topology;
> +struct sched_domain_topology_level *sched_domain_topology = default_topology;
> 
>  #define for_each_sd_topology(tl)			\
>  	for (tl = sched_domain_topology; tl->mask; tl++)
> 


-- 
blue skies,
   Martin.

"Reality continues to ruin my life." - Calvin.

