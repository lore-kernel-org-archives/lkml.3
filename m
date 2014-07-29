Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752918AbaG2Iom (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jul 2014 04:44:42 -0400
Received: from mail.skyhub.de ([78.46.96.112]:59332 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752904AbaG2Ioj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jul 2014 04:44:39 -0400
Date: Tue, 29 Jul 2014 10:44:33 +0200
From: Borislav Petkov <bp@alien8.de>
To: "Chen, Gong" <gong.chen@linux.intel.com>
Cc: linux-kernel@vger.kernel.org, mingo@kernel.org, tglx@linutronix.de,
        paulus@samba.org, benh@kernel.crashing.org, tony.luck@intel.com,
        hpa@zytor.com, jkosina@suse.cz, rafael.j.wysocki@intel.com,
        linux@arm.linux.org.uk, ralf@linux-mips.org, schwidefsky@de.ibm.com,
        davem@davemloft.net, viro@zeniv.linux.org.uk, fweisbec@gmail.com,
        cl@linux.com, akpm@linux-foundation.org, axboe@kernel.dk,
        JBottomley@parallels.com, neilb@suse.de, christoffer.dall@linaro.org,
        rostedt@goodmis.org, rric@kernel.org, gregkh@linuxfoundation.org,
        mhocko@suse.cz, david@fromorbit.com
Subject: Re: [RFC PATCH v1 13/70] x86, x2apic_cluster: _FROZEN Cleanup
Message-ID: <20140729084433.GB11179@pd.tnic>
References: <1406080786-3938-1-git-send-email-gong.chen@linux.intel.com>
 <1406080786-3938-14-git-send-email-gong.chen@linux.intel.com>
 <20140723203628.GJ21707@pd.tnic>
 <20140728060455.GB23092@gchen.bj.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20140728060455.GB23092@gchen.bj.intel.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 28, 2014 at 02:04:55AM -0400, Chen, Gong wrote:
> On Wed, Jul 23, 2014 at 10:36:28PM +0200, Borislav Petkov wrote:
> > Those checks dealing with CPU_TASKS_FROZEN in-between make the whole
> > switch statement hard to follow.
> > 
> > How about we go a step further and deal with CPU_UP_CANCELED_FROZEN
> > upfront and even simplify the rest:
> > 
> 
> --------8<--------
> Subject: [RFC PATCH v2 13/70] x86, x2apic_cluster: _FROZEN Cleanup
> 
> Remove XXX_FROZEN state from x86/x2apic_cluster.
> 
> Signed-off-by: Chen, Gong <gong.chen@linux.intel.com>
> Suggested-by: Borislav Petkov <bp@alien8.de>
> ---
>  arch/x86/kernel/apic/x2apic_cluster.c | 37 +++++++++++++++++++++++------------
>  1 file changed, 24 insertions(+), 13 deletions(-)
> 
> diff --git a/arch/x86/kernel/apic/x2apic_cluster.c b/arch/x86/kernel/apic/x2apic_cluster.c
> index e66766b..b8a6ea8 100644
> --- a/arch/x86/kernel/apic/x2apic_cluster.c
> +++ b/arch/x86/kernel/apic/x2apic_cluster.c
> @@ -144,6 +144,20 @@ static void init_x2apic_ldr(void)
>  	}
>  }
>  
> +static void __update_clusterinfo(unsigned int this_cpu)
> +{
> +	unsigned int cpu;
> +
> +	for_each_online_cpu(cpu) {
> +		if (x2apic_cluster(this_cpu) != x2apic_cluster(cpu))
> +			continue;
> +		__cpu_clear(this_cpu, per_cpu(cpus_in_cluster, cpu));
> +		__cpu_clear(cpu, per_cpu(cpus_in_cluster, this_cpu));
> +	}
> +	free_cpumask_var(per_cpu(cpus_in_cluster, this_cpu));
> +	free_cpumask_var(per_cpu(ipi_mask, this_cpu));
> +}
> +
>   /*
>    * At CPU state changes, update the x2apic cluster sibling info.
>    */
> @@ -151,34 +165,31 @@ static int
>  update_clusterinfo(struct notifier_block *nfb, unsigned long action, void *hcpu)
>  {
>  	unsigned int this_cpu = (unsigned long)hcpu;
> -	unsigned int cpu;
>  	int err = 0;
>  
>  	switch (action) {
>  	case CPU_UP_PREPARE:
>  		if (!zalloc_cpumask_var(&per_cpu(cpus_in_cluster, this_cpu),
> -					GFP_KERNEL)) {
> +					GFP_KERNEL))
>  			err = -ENOMEM;
> -		} else if (!zalloc_cpumask_var(&per_cpu(ipi_mask, this_cpu),
> -					       GFP_KERNEL)) {
> +		else if (!zalloc_cpumask_var(&per_cpu(ipi_mask, this_cpu),
> +					     GFP_KERNEL)) {
>  			free_cpumask_var(per_cpu(cpus_in_cluster, this_cpu));
>  			err = -ENOMEM;

You need to start restraining yourself and doing clean patches. Those
changes here are unrelated, please drop them.

Go and reread Documentation/SubmittingPatches, section 3 in particular.

>  		}
>  		break;
>  	case CPU_UP_CANCELED:
> -	case CPU_UP_CANCELED_FROZEN:
>  	case CPU_DEAD:
> -		for_each_online_cpu(cpu) {
> -			if (x2apic_cluster(this_cpu) != x2apic_cluster(cpu))
> -				continue;
> -			__cpu_clear(this_cpu, per_cpu(cpus_in_cluster, cpu));
> -			__cpu_clear(cpu, per_cpu(cpus_in_cluster, this_cpu));
> -		}
> -		free_cpumask_var(per_cpu(cpus_in_cluster, this_cpu));
> -		free_cpumask_var(per_cpu(ipi_mask, this_cpu));
> +		__update_clusterinfo(this_cpu);
> +		break;
> +	default:
>  		break;
>  	}
>  
> +	if (test_and_clear_bit(CPU_TASKS_FROZEN, &action) &&

What.. why?

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
