Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755843Ab3CTHde (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Mar 2013 03:33:34 -0400
Received: from LGEMRELSE6Q.lge.com ([156.147.1.121]:47506 "EHLO
	LGEMRELSE6Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750810Ab3CTHdd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Mar 2013 03:33:33 -0400
X-AuditID: 9c930179-b7c78ae000000e4b-cc-5149664ac8d0
Date: Wed, 20 Mar 2013 16:33:55 +0900
From: Joonsoo Kim <iamjoonsoo.kim@lge.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Ingo Molnar <mingo@redhat.com>,
        Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 4/8] sched: clean up move_task() and move_one_task()
Message-ID: <20130320073355.GC11672@lge.com>
References: <1360820921-2513-1-git-send-email-iamjoonsoo.kim@lge.com>
 <1360820921-2513-5-git-send-email-iamjoonsoo.kim@lge.com>
 <1363703415.22553.54.camel@laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1363703415.22553.54.camel@laptop>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 19, 2013 at 03:30:15PM +0100, Peter Zijlstra wrote:
> On Thu, 2013-02-14 at 14:48 +0900, Joonsoo Kim wrote:
> > Some validation for task moving is performed in move_tasks() and
> > move_one_task(). We can move these code to can_migrate_task()
> > which is already exist for this purpose.
> 
> > @@ -4011,18 +4027,7 @@ static int move_tasks(struct lb_env *env)
> >  			break;
> >  		}
> >  
> > -		if (throttled_lb_pair(task_group(p), env->src_cpu, env->dst_cpu))
> > -			goto next;
> > -
> > -		load = task_h_load(p);
> > -
> > -		if (sched_feat(LB_MIN) && load < 16 && !env->sd->nr_balance_failed)
> > -			goto next;
> > -
> > -		if ((load / 2) > env->imbalance)
> > -			goto next;
> > -
> > -		if (!can_migrate_task(p, env))
> > +		if (!can_migrate_task(p, env, false, &load))
> >  			goto next;
> >  
> >  		move_task(p, env);
> 
> Right, so I'm not so taken with this one. The whole load stuff really
> is a balance heuristic that's part of move_tasks(), move_one_task()
> really doesn't care about that.
> 
> So why did you include it? Purely so you didn't have to re-order the
> tests? I don't see any reason not to flip a tests around.

I think that I'm not fully understand what you are concerning, because of
my poor English. If possible, please elaborate on a problem in more detail.

First of all, I do my best to answer your question.

Patch 4/8, 5/8 are for mitigating useless redoing overhead caused
by LBF_ALL_PINNED. For this purpose, we should check 'cpu affinity'
before evaluating a load. Just moving up can_migrate_task() above
load evaluation code may raise side effect, because can_migrate_task() have
other checking which is 'cache hottness'. I don't want a side effect. So
embedding load evaluation to can_migrate_task() and re-order checking and
makes load evaluation disabled for move_one_task().

If your recommandation is to move up can_mirate_task() above
load evaluation code, yes, I can, and will do that. :)

Please let me know what I am misunderstand.

Thanks.

> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
