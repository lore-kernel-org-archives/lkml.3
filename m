Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756455Ab3CSOaT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Mar 2013 10:30:19 -0400
Received: from merlin.infradead.org ([205.233.59.134]:58904 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755731Ab3CSOaS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Mar 2013 10:30:18 -0400
Message-ID: <1363703415.22553.54.camel@laptop>
Subject: Re: [PATCH 4/8] sched: clean up move_task() and move_one_task()
From: Peter Zijlstra <peterz@infradead.org>
To: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Cc: Ingo Molnar <mingo@redhat.com>,
        Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>,
        linux-kernel@vger.kernel.org
Date: Tue, 19 Mar 2013 15:30:15 +0100
In-Reply-To: <1360820921-2513-5-git-send-email-iamjoonsoo.kim@lge.com>
References: <1360820921-2513-1-git-send-email-iamjoonsoo.kim@lge.com>
	 <1360820921-2513-5-git-send-email-iamjoonsoo.kim@lge.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.2-0ubuntu0.1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2013-02-14 at 14:48 +0900, Joonsoo Kim wrote:
> Some validation for task moving is performed in move_tasks() and
> move_one_task(). We can move these code to can_migrate_task()
> which is already exist for this purpose.

> @@ -4011,18 +4027,7 @@ static int move_tasks(struct lb_env *env)
>  			break;
>  		}
>  
> -		if (throttled_lb_pair(task_group(p), env->src_cpu, env->dst_cpu))
> -			goto next;
> -
> -		load = task_h_load(p);
> -
> -		if (sched_feat(LB_MIN) && load < 16 && !env->sd->nr_balance_failed)
> -			goto next;
> -
> -		if ((load / 2) > env->imbalance)
> -			goto next;
> -
> -		if (!can_migrate_task(p, env))
> +		if (!can_migrate_task(p, env, false, &load))
>  			goto next;
>  
>  		move_task(p, env);

Right, so I'm not so taken with this one. The whole load stuff really
is a balance heuristic that's part of move_tasks(), move_one_task()
really doesn't care about that.

So why did you include it? Purely so you didn't have to re-order the
tests? I don't see any reason not to flip a tests around.

