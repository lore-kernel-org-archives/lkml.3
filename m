Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753815Ab3H1JRO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Aug 2013 05:17:14 -0400
Received: from merlin.infradead.org ([205.233.59.134]:57838 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753462Ab3H1JRM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Aug 2013 05:17:12 -0400
Date: Wed, 28 Aug 2013 11:16:53 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Ingo Molnar <mingo@kernel.org>, Joonsoo Kim <iamjoonsoo.kim@lge.com>
Cc: linux-kernel@vger.kernel.org, Mike Galbraith <efault@gmx.de>,
        Paul Turner <pjt@google.com>, Alex Shi <alex.shi@intel.com>,
        Preeti U Murthy <preeti@linux.vnet.ibm.com>,
        Vincent Guittot <vincent.guittot@linaro.org>,
        Morten Rasmussen <morten.rasmussen@arm.com>,
        Namhyung Kim <namhyung@kernel.org>, Lei Wen <leiwen@marvell.com>,
        Joonsoo Kim <js1304@gmail.com>, Rik van Riel <riel@surriel.com>
Subject: Re: [RFC][PATCH 11/10] sched, fair: Reduce local_group logic
Message-ID: <20130828091653.GK10002@twins.programming.kicks-ass.net>
References: <20130819160058.539049611@infradead.org>
 <20130828085542.GI10002@twins.programming.kicks-ass.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130828085542.GI10002@twins.programming.kicks-ass.net>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 28, 2013 at 10:55:42AM +0200, Peter Zijlstra wrote:
> @@ -4690,19 +4694,20 @@ static inline void update_sd_lb_stats(st
>  		 * heaviest group when it is already under-utilized (possible
>  		 * with a large weight task outweighs the tasks on the system).
>  		 */
> +		if (prefer_sibling && sds->local &&
> +		    sds->local_stat.group_has_capacity)
>  			sgs->group_capacity = min(sgs->group_capacity, 1U);

While we're here, I think its always true that sds->local is set,
because env->dst_cpu should always be part of the local group and the
local group is always sd->groups and since that now directly skips to
next_group we'll not get here without this being true.

Hmm?

>  
> +		if (update_sd_pick_busiest(env, sds, sg, sgs)) {
>  			sds->busiest = sg;
>  			sds->busiest_stat = *sgs;
>  		}
>  
> +next_group:
> +		/* Now, start updating sd_lb_stats */
> +		sds->total_load += sgs->group_load;
> +		sds->total_pwr += sgs->group_power;
> +
>  		sg = sg->next;
>  	} while (sg != env->sd->groups);
>  }
