Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752425Ab3INEn0 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Sep 2013 00:43:26 -0400
Received: from mail-pb0-f50.google.com ([209.85.160.50]:57353 "EHLO
	mail-pb0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751653Ab3INEnY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Sep 2013 00:43:24 -0400
Date: Sat, 14 Sep 2013 12:43:00 +0800
From: Wang YanQing <udknight@gmail.com>
To: Jiang Liu <liuj97@gmail.com>, Andrew Morton <akpm@linux-foundation.org>,
        Shaohua Li <shli@kernel.org>, Jiang Liu <jiang.liu@huawei.com>,
        Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Steven Rostedt <rostedt@goodmis.org>, Jiri Kosina <trivial@kernel.org>,
        linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org
Cc: gang.chen@asianux.com
Subject: Re: [PATCH v2 01/25] Revert smp: Fix SMP function call empty cpu
 mask race
Message-ID: <20130914044300.GA3438@udknight>
Mail-Followup-To: Wang YanQing <udknight@gmail.com>,
	Jiang Liu <liuj97@gmail.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Shaohua Li <shli@kernel.org>, Jiang Liu <jiang.liu@huawei.com>,
	Ingo Molnar <mingo@elte.hu>,
	Peter Zijlstra <a.p.zijlstra@chello.nl>,
	Steven Rostedt <rostedt@goodmis.org>,
	Jiri Kosina <trivial@kernel.org>, linux-kernel@vger.kernel.org,
	linux-arch@vger.kernel.org, gang.chen@asianux.com
References: <1378915649-16395-1-git-send-email-liuj97@gmail.com>
 <1378915649-16395-2-git-send-email-liuj97@gmail.com>
 <20130914044136.GA2944@udknight>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130914044136.GA2944@udknight>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Sep 14, 2013 at 12:41:36PM +0800, Wang YanQing wrote:
> On Thu, Sep 12, 2013 at 12:07:05AM +0800, Jiang Liu wrote:
> > From: Jiang Liu <jiang.liu@huawei.com>
> > 
> > Commit f44310b98ddb7 "smp: Fix SMP function call empty cpu mask race"
> > introduced field call_function_data->cpumask_ipi to resolve a race
> > condition in smp_call_function_many().
> > 
> > Later commit 9a46ad6d6df3 "smp: make smp_call_function_many() use logic
> > similar to smp_call_function_single()" fixed the same issue in another
> > way when optimizing smp_call_function_many(), which then obsoletes
> > changes introduced by commit f44310b98ddb7. So revert it.
> > 
> > Signed-off-by: Jiang Liu <jiang.liu@huawei.com>
> > Acked-by: Wang YanQing <udknight@gmail.com>
> > Cc: Jiang Liu <liuj97@gmail.com>
> > ---
> >  kernel/smp.c | 16 ++--------------
> >  1 file changed, 2 insertions(+), 14 deletions(-)
> > 
> > diff --git a/kernel/smp.c b/kernel/smp.c
> > index fe9f773..a034712 100644
> > --- a/kernel/smp.c
> > +++ b/kernel/smp.c
> > @@ -23,7 +23,6 @@ enum {
> >  struct call_function_data {
> >  	struct call_single_data	__percpu *csd;
> >  	cpumask_var_t		cpumask;
> > -	cpumask_var_t		cpumask_ipi;
> >  };
> >  
> >  static DEFINE_PER_CPU_SHARED_ALIGNED(struct call_function_data, cfd_data);
> > @@ -47,9 +46,6 @@ hotplug_cfd(struct notifier_block *nfb, unsigned long action, void *hcpu)
> >  		if (!zalloc_cpumask_var_node(&cfd->cpumask, GFP_KERNEL,
> >  				cpu_to_node(cpu)))
> >  			return notifier_from_errno(-ENOMEM);
> > -		if (!zalloc_cpumask_var_node(&cfd->cpumask_ipi, GFP_KERNEL,
> > -				cpu_to_node(cpu)))
> > -			return notifier_from_errno(-ENOMEM);
> >  		cfd->csd = alloc_percpu(struct call_single_data);
> >  		if (!cfd->csd) {
> >  			free_cpumask_var(cfd->cpumask);
> > @@ -64,7 +60,6 @@ hotplug_cfd(struct notifier_block *nfb, unsigned long action, void *hcpu)
> >  	case CPU_DEAD:
> >  	case CPU_DEAD_FROZEN:
> >  		free_cpumask_var(cfd->cpumask);
> > -		free_cpumask_var(cfd->cpumask_ipi);
> >  		free_percpu(cfd->csd);
> >  		break;
> >  #endif
> > @@ -255,9 +250,9 @@ int smp_call_function_single(int cpu, smp_call_func_t func, void *info,
> >  				csd = &__get_cpu_var(csd_data);
> >  
> >  			csd_lock(csd);
> > -
> >  			csd->func = func;
> >  			csd->info = info;
> > +
> >  			generic_exec_single(cpu, csd, wait);
> >  		} else {
> >  			err = -ENXIO;	/* CPU not online */
> > @@ -410,13 +405,6 @@ void smp_call_function_many(const struct cpumask *mask,
> >  	if (unlikely(!cpumask_weight(cfd->cpumask)))
> >  		return;
> >  
> > -	/*
> > -	 * After we put an entry into the list, cfd->cpumask may be cleared
> > -	 * again when another CPU sends another IPI for a SMP function call, so
> > -	 * cfd->cpumask will be zero.
> > -	 */
> > -	cpumask_copy(cfd->cpumask_ipi, cfd->cpumask);
> > -
> >  	for_each_cpu(cpu, cfd->cpumask) {
> >  		struct call_single_data *csd = per_cpu_ptr(cfd->csd, cpu);
> >  		struct call_single_queue *dst =
> > @@ -433,7 +421,7 @@ void smp_call_function_many(const struct cpumask *mask,
> >  	}
> >  
> >  	/* Send a message to all CPUs in the map */
> > -	arch_send_call_function_ipi_mask(cfd->cpumask_ipi);
> > +	arch_send_call_function_ipi_mask(cfd->cpumask);
> >  
> >  	if (wait) {
> >  		for_each_cpu(cpu, cfd->cpumask) {
> > -- 
> > 1.8.1.2
> Hi Liu and all
> 
> Commit 60c323699bb308404dcb60e8808531e02651578a 
> (kernel/smp.c: free related resources when failure occurs in hotplug_cfd())
> is a fix patch for commit you revert, and it had been merged into mainline.
> 
> So could you ajust your patch to revert it together? I don't think we need
> a separate patch to revert 60c323699bb308404dcb60e8808531e02651578a, because
> your patch haven't be merged.
> 
> Thanks.

Add Cc:gang.chen@asianux.com
