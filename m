Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762895Ab3DDAzB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Apr 2013 20:55:01 -0400
Received: from LGEMRELSE1Q.lge.com ([156.147.1.111]:65383 "EHLO
	LGEMRELSE1Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760034Ab3DDAy7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Apr 2013 20:54:59 -0400
X-AuditID: 9c93016f-b7c18ae000002f5f-9b-515ccf601cda
Date: Thu, 4 Apr 2013 09:55:17 +0900
From: Joonsoo Kim <iamjoonsoo.kim@lge.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Ingo Molnar <mingo@redhat.com>, linux-kernel@vger.kernel.org,
        Mike Galbraith <efault@gmx.de>, Paul Turner <pjt@google.com>,
        Alex Shi <alex.shi@intel.com>,
        Preeti U Murthy <preeti@linux.vnet.ibm.com>,
        Vincent Guittot <vincent.guittot@linaro.org>,
        Morten Rasmussen <morten.rasmussen@arm.com>,
        Namhyung Kim <namhyung@kernel.org>
Subject: Re: [PATCH 2/5] sched: factor out code to should_we_balance()
Message-ID: <20130404005517.GB10683@lge.com>
References: <1364457537-15114-1-git-send-email-iamjoonsoo.kim@lge.com>
 <1364457537-15114-3-git-send-email-iamjoonsoo.kim@lge.com>
 <1364890206.16858.6.camel@laptop>
 <20130402095034.GG16699@lge.com>
 <1364896813.18374.0.camel@laptop>
 <1364898582.18374.17.camel@laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1364898582.18374.17.camel@laptop>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, Peter.

On Tue, Apr 02, 2013 at 12:29:42PM +0200, Peter Zijlstra wrote:
> On Tue, 2013-04-02 at 12:00 +0200, Peter Zijlstra wrote:
> > On Tue, 2013-04-02 at 18:50 +0900, Joonsoo Kim wrote:
> > > 
> > > It seems that there is some misunderstanding about this patch.
> > > In this patch, we don't iterate all groups. Instead, we iterate on
> > > cpus of local sched_group only. So there is no penalty you mentioned.
> > 
> > OK, I'll go stare at it again..
> 
> Ah, I see, you're doing should_we_balance() _before_
> find_busiest_group() and instead you're doing another for_each_cpu() in
> there.
> 
> I'd write the thing like:
> 
> static bool should_we_balance(struct lb_env *env)
> {
> 	struct sched_group *sg = env->sd->groups;
> 	struct cpumask *sg_cpus, *sg_mask;
> 	int cpu, balance_cpu = -1;
> 
> 	if (env->idle == CPU_NEWLY_IDLE)
> 		return true;
> 
> 	sg_cpus = sched_group_cpus(sg);
> 	sg_mask = sched_group_mask(sg);
> 
> 	for_each_cpu_and(cpu, sg_cpus, env->cpus) {
> 		if (!cpumask_test_cpu(cpu, sg_mask))
> 			continue;
> 
> 		if (!idle_cpu(cpu))
> 			continue;
> 
> 		balance_cpu = cpu;
> 		break;
> 	}
> 
> 	if (balance_cpu == -1)
> 		balance_cpu = group_balance_cpu(sg);
> 
> 	return balance_cpu == env->dst_cpu;
> }

Okay. It looks nice.

> 
> I also considered doing the group_balance_cpu() first to avoid having
> to do the idle_cpu() scan, but that's a slight behavioural change
> afaict.

In my quick thought, we can avoid it through below way.

balance_cpu = group_balance_cpu(sg);
if (idle_cpu(balance_cpu))
	return balance_cpu == env->dst_cpu;
else
	do idle_cpus() scan loop

Is it your idea? If not, please let me know your idea.

Thanks.

> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
