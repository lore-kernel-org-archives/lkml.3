Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751890AbaAPHGA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Jan 2014 02:06:00 -0500
Received: from zene.cmpxchg.org ([85.214.230.12]:47033 "EHLO zene.cmpxchg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750886AbaAPHF6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Jan 2014 02:05:58 -0500
Date: Thu, 16 Jan 2014 02:05:49 -0500
From: Johannes Weiner <hannes@cmpxchg.org>
To: David Rientjes <rientjes@google.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Michal Hocko <mhocko@suse.cz>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        cgroups@vger.kernel.org, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
Subject: Re: [patch -mm] mm, oom: prefer thread group leaders for display
 purposes
Message-ID: <20140116070549.GL6963@cmpxchg.org>
References: <alpine.DEB.2.02.1401151837560.1835@chino.kir.corp.google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.02.1401151837560.1835@chino.kir.corp.google.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 15, 2014 at 06:40:41PM -0800, David Rientjes wrote:
> When two threads have the same badness score, it's preferable to kill the 
> thread group leader so that the actual process name is printed to the 
> kernel log rather than the thread group name which may be shared amongst 
> several processes.
> 
> This was the behavior when select_bad_process() used to do 
> for_each_process(), but it now iterates threads instead and leads to 
> ambiguity.
> 
> Signed-off-by: David Rientjes <rientjes@google.com>
> ---
>  mm/memcontrol.c | 18 +++++++++++-------
>  mm/oom_kill.c   | 12 ++++++++----
>  2 files changed, 19 insertions(+), 11 deletions(-)
> 
> diff --git a/mm/memcontrol.c b/mm/memcontrol.c
> index a815686..b482f49 100644
> --- a/mm/memcontrol.c
> +++ b/mm/memcontrol.c
> @@ -1841,13 +1841,17 @@ static void mem_cgroup_out_of_memory(struct mem_cgroup *memcg, gfp_t gfp_mask,
>  				break;
>  			};
>  			points = oom_badness(task, memcg, NULL, totalpages);
> -			if (points > chosen_points) {
> -				if (chosen)
> -					put_task_struct(chosen);
> -				chosen = task;
> -				chosen_points = points;
> -				get_task_struct(chosen);

Where did that GET go?

> -			}
> +			if (points < chosen_points)
> +				continue;
> +			/* Prefer thread group leaders for display purposes */
> +			if (points == chosen_points &&
> +			    thread_group_leader(chosen))
> +				continue;
> +
> +			if (chosen)
> +				put_task_struct(chosen);

...boom.

> +			chosen = task;
> +			chosen_points = points;
>  		}
>  		css_task_iter_end(&it);
>  	}
> diff --git a/mm/oom_kill.c b/mm/oom_kill.c
> index 054ff47..1dca3d8 100644
> --- a/mm/oom_kill.c
> +++ b/mm/oom_kill.c
> @@ -327,10 +327,14 @@ static struct task_struct *select_bad_process(unsigned int *ppoints,
>  			break;
>  		};
>  		points = oom_badness(p, NULL, nodemask, totalpages);
> -		if (points > chosen_points) {
> -			chosen = p;
> -			chosen_points = points;
> -		}
> +		if (points < chosen_points)
> +			continue;
> +		/* Prefer thread group leaders for display purposes */
> +		if (points == chosen_points && thread_group_leader(chosen))
> +			continue;
> +
> +		chosen = p;
> +		chosen_points = points;
>  	}
>  	if (chosen)
>  		get_task_struct(chosen);
