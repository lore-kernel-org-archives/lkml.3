Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757009AbaCEVSE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Mar 2014 16:18:04 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:54478 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756051AbaCEVR7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Mar 2014 16:17:59 -0500
Date: Wed, 5 Mar 2014 13:17:57 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: David Rientjes <rientjes@google.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@suse.cz>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Christoph Lameter <cl@linux-foundation.org>,
        Pekka Enberg <penberg@kernel.org>, Tejun Heo <tj@kernel.org>,
        Mel Gorman <mgorman@suse.de>, Oleg Nesterov <oleg@redhat.com>,
        Rik van Riel <riel@redhat.com>, Jianguo Wu <wujianguo@huawei.com>,
        Tim Hockin <thockin@google.com>, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org, cgroups@vger.kernel.org, linux-doc@vger.kernel.org
Subject: Re: [patch 04/11] mm, memcg: add tunable for oom reserves
Message-Id: <20140305131757.ad538637c096266664c45f04@linux-foundation.org>
In-Reply-To: <alpine.DEB.2.02.1403041955050.8067@chino.kir.corp.google.com>
References: <alpine.DEB.2.02.1403041952170.8067@chino.kir.corp.google.com>
	<alpine.DEB.2.02.1403041955050.8067@chino.kir.corp.google.com>
X-Mailer: Sylpheed 3.2.0beta5 (GTK+ 2.24.10; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 4 Mar 2014 19:59:19 -0800 (PST) David Rientjes <rientjes@google.com> wrote:

> Userspace needs a way to define the amount of memory reserves that
> processes handling oom conditions may utilize.  This patch adds a per-
> memcg oom reserve field and file, memory.oom_reserve_in_bytes, to
> manipulate its value.
> 
> If currently utilized memory reserves are attempted to be reduced by
> writing a smaller value to memory.oom_reserve_in_bytes, it will fail with
> -EBUSY until some memory is uncharged.
> 
> ...
>
> --- a/mm/memcontrol.c
> +++ b/mm/memcontrol.c
> @@ -315,6 +315,9 @@ struct mem_cgroup {
>  	/* OOM-Killer disable */
>  	int		oom_kill_disable;
>  
> +	/* reserves for handling oom conditions, protected by res.lock */
> +	unsigned long long	oom_reserve;

Units?  bytes, I assume.

>  	/* set when res.limit == memsw.limit */
>  	bool		memsw_is_minimum;
>  
> @@ -5936,6 +5939,51 @@ static int mem_cgroup_oom_control_write(struct cgroup_subsys_state *css,
>  	return 0;
>  }
>  
> +static int mem_cgroup_resize_oom_reserve(struct mem_cgroup *memcg,
> +					 unsigned long long new_limit)
> +{
> +	struct res_counter *res = &memcg->res;
> +	u64 limit, usage;
> +	int ret = 0;

The code mixes u64's and unsigned long longs in inexplicable ways. 
Suggest using u64 throughout.

> +	spin_lock(&res->lock);
> +	limit = res->limit;
> +	usage = res->usage;
> +
> +	if (usage > limit && usage - limit > new_limit) {
> +		ret = -EBUSY;
> +		goto out;
> +	}
> +
> +	memcg->oom_reserve = new_limit;
> +out:
> +	spin_unlock(&res->lock);
> +	return ret;
> +}
>
> ...
>
