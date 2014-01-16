Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752812AbaAPOVp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Jan 2014 09:21:45 -0500
Received: from cantor2.suse.de ([195.135.220.15]:44057 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751435AbaAPOVn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Jan 2014 09:21:43 -0500
Date: Thu, 16 Jan 2014 15:21:41 +0100
From: Michal Hocko <mhocko@suse.cz>
To: David Rientjes <rientjes@google.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Johannes Weiner <hannes@cmpxchg.org>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        cgroups@vger.kernel.org, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
Subject: Re: [patch v2 -mm] mm, oom: prefer thread group leaders for display
 purposes
Message-ID: <20140116142141.GF28157@dhcp22.suse.cz>
References: <alpine.DEB.2.02.1401151837560.1835@chino.kir.corp.google.com>
 <20140116070549.GL6963@cmpxchg.org>
 <alpine.DEB.2.02.1401152344560.14407@chino.kir.corp.google.com>
 <alpine.DEB.2.02.1401152345330.14407@chino.kir.corp.google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.02.1401152345330.14407@chino.kir.corp.google.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed 15-01-14 23:46:44, David Rientjes wrote:
> When two threads have the same badness score, it's preferable to kill the 
> thread group leader so that the actual process name is printed to the 
> kernel log rather than the thread group name which may be shared amongst 
> several processes.

I am not sure I understand this. Is this about ->comm? If yes then why
couldn't the group leader do PR_SET_NAME?

> This was the behavior when select_bad_process() used to do 
> for_each_process(), but it now iterates threads instead and leads to 
> ambiguity.
> 
> Signed-off-by: David Rientjes <rientjes@google.com>
> ---
>  v2: fixes missing get_task_struct() found by Johannes.
> 
>  mm/memcontrol.c | 19 ++++++++++++-------
>  mm/oom_kill.c   | 12 ++++++++----
>  2 files changed, 20 insertions(+), 11 deletions(-)
> 
> diff --git a/mm/memcontrol.c b/mm/memcontrol.c
> index a815686..d69c4b3 100644
> --- a/mm/memcontrol.c
> +++ b/mm/memcontrol.c
> @@ -1841,13 +1841,18 @@ static void mem_cgroup_out_of_memory(struct mem_cgroup *memcg, gfp_t gfp_mask,
>  				break;
>  			};
>  			points = oom_badness(task, memcg, NULL, totalpages);
> -			if (points > chosen_points) {
> -				if (chosen)
> -					put_task_struct(chosen);
> -				chosen = task;
> -				chosen_points = points;
> -				get_task_struct(chosen);
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
> +			chosen = task;
> +			chosen_points = points;
> +			get_task_struct(chosen);
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

-- 
Michal Hocko
SUSE Labs
