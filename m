Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965565Ab3E2K0X (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 May 2013 06:26:23 -0400
Received: from mx1.redhat.com ([209.132.183.28]:48621 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965527Ab3E2K0V (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 May 2013 06:26:21 -0400
Date: Wed, 29 May 2013 12:26:01 +0200
From: Andrew Jones <drjones@redhat.com>
To: tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com, x86@kernel.org,
        a.p.zijlstra@chello.nl, fenghua.yu@intel.com
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] sched/x86: construct all sibling maps if smt
Message-ID: <20130529102600.GA10582@hawk.usersys.redhat.com>
References: <1369674540-10601-1-git-send-email-drjones@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1369674540-10601-1-git-send-email-drjones@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 27, 2013 at 07:09:00PM +0200, Andrew Jones wrote:
> Commit 316ad248307fb ("sched/x86: Rewrite set_cpu_sibling_map()") broke
> the construction of sibling maps, which also broke the booted_cores
> accounting.
> 
> Before the rewrite, if smt was present, then each map was updated for
> each smt sibling. After the rewrite only cpu_sibling_mask gets updated,
> as the llc and core maps depend on 'has_mc = x86_max_cores > 1' instead.
> This leads to problems with topologies like the following
> 
> (qemu -smp sockets=2,cores=1,threads=2)
> 
> processor	: 0
> physical id	: 0
> siblings	: 1    <= should be 2
> core id		: 0
> cpu cores	: 1
> 
> processor	: 1
> physical id	: 0
> siblings	: 1    <= should be 2
> core id		: 0
> cpu cores	: 0    <= should be 1
> 
> processor	: 2
> physical id	: 1
> siblings	: 1    <= should be 2
> core id		: 0
> cpu cores	: 1
> 
> processor	: 3
> physical id	: 1
> siblings	: 1    <= should be 2
> core id		: 0
> cpu cores	: 0    <= should be 1
> 
> This patch restores the former construction by defining has_mc as
> (has_smt || x86_max_cores > 1). This should be fine as there were no
> (has_smt && !has_mc) conditions in the context.
> 
> Signed-off-by: Andrew Jones <drjones@redhat.com>
> ---
>  arch/x86/kernel/smpboot.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/arch/x86/kernel/smpboot.c b/arch/x86/kernel/smpboot.c
> index 9c73b51817e47..886a3234eaff3 100644
> --- a/arch/x86/kernel/smpboot.c
> +++ b/arch/x86/kernel/smpboot.c
> @@ -372,15 +372,15 @@ static bool __cpuinit match_mc(struct cpuinfo_x86 *c, struct cpuinfo_x86 *o)
>  
>  void __cpuinit set_cpu_sibling_map(int cpu)
>  {
> -	bool has_mc = boot_cpu_data.x86_max_cores > 1;
>  	bool has_smt = smp_num_siblings > 1;
> +	bool has_mc = has_smt || boot_cpu_data.x86_max_cores > 1;
>  	struct cpuinfo_x86 *c = &cpu_data(cpu);
>  	struct cpuinfo_x86 *o;
>  	int i;
>  
>  	cpumask_set_cpu(cpu, cpu_sibling_setup_mask);
>  
> -	if (!has_smt && !has_mc) {
> +	if (!has_mc) {
>  		cpumask_set_cpu(cpu, cpu_sibling_mask(cpu));
>  		cpumask_set_cpu(cpu, cpu_llc_shared_mask(cpu));
>  		cpumask_set_cpu(cpu, cpu_core_mask(cpu));
> -- 
> 1.8.1.4
>

Any acks? This patch fixes a regression. Also, in case anybody is
wondering, this is not the same regression as was already fixed with

ceb1cbac8eda6 sched/x86: Calculate booted cores after construction of sibling_mask

(Hmm, I probably should have renamed has_mc to has_mp, as the redefinition
expands its scope. I'm not sure if that deserves a v2 though.)

drew
