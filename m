Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761496Ab3DBK34 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Apr 2013 06:29:56 -0400
Received: from 173-166-109-252-newengland.hfc.comcastbusiness.net ([173.166.109.252]:40337
	"EHLO bombadil.infradead.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1760189Ab3DBK3z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Apr 2013 06:29:55 -0400
Message-ID: <1364898582.18374.17.camel@laptop>
Subject: Re: [PATCH 2/5] sched: factor out code to should_we_balance()
From: Peter Zijlstra <peterz@infradead.org>
To: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Cc: Ingo Molnar <mingo@redhat.com>, linux-kernel@vger.kernel.org,
        Mike Galbraith <efault@gmx.de>, Paul Turner <pjt@google.com>,
        Alex Shi <alex.shi@intel.com>,
        Preeti U Murthy <preeti@linux.vnet.ibm.com>,
        Vincent Guittot <vincent.guittot@linaro.org>,
        Morten Rasmussen <morten.rasmussen@arm.com>,
        Namhyung Kim <namhyung@kernel.org>
Date: Tue, 02 Apr 2013 12:29:42 +0200
In-Reply-To: <1364896813.18374.0.camel@laptop>
References: <1364457537-15114-1-git-send-email-iamjoonsoo.kim@lge.com>
	 <1364457537-15114-3-git-send-email-iamjoonsoo.kim@lge.com>
	 <1364890206.16858.6.camel@laptop> <20130402095034.GG16699@lge.com>
	 <1364896813.18374.0.camel@laptop>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.2-0ubuntu0.1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2013-04-02 at 12:00 +0200, Peter Zijlstra wrote:
> On Tue, 2013-04-02 at 18:50 +0900, Joonsoo Kim wrote:
> > 
> > It seems that there is some misunderstanding about this patch.
> > In this patch, we don't iterate all groups. Instead, we iterate on
> > cpus of local sched_group only. So there is no penalty you mentioned.
> 
> OK, I'll go stare at it again..

Ah, I see, you're doing should_we_balance() _before_
find_busiest_group() and instead you're doing another for_each_cpu() in
there.

I'd write the thing like:

static bool should_we_balance(struct lb_env *env)
{
	struct sched_group *sg = env->sd->groups;
	struct cpumask *sg_cpus, *sg_mask;
	int cpu, balance_cpu = -1;

	if (env->idle == CPU_NEWLY_IDLE)
		return true;

	sg_cpus = sched_group_cpus(sg);
	sg_mask = sched_group_mask(sg);

	for_each_cpu_and(cpu, sg_cpus, env->cpus) {
		if (!cpumask_test_cpu(cpu, sg_mask))
			continue;

		if (!idle_cpu(cpu))
			continue;

		balance_cpu = cpu;
		break;
	}

	if (balance_cpu == -1)
		balance_cpu = group_balance_cpu(sg);

	return balance_cpu == env->dst_cpu;
}

I also considered doing the group_balance_cpu() first to avoid having
to do the idle_cpu() scan, but that's a slight behavioural change
afaict.

