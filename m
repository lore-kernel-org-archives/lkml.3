Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759653Ab3ICKBW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Sep 2013 06:01:22 -0400
Received: from cantor2.suse.de ([195.135.220.15]:55626 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753421Ab3ICKBU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Sep 2013 06:01:20 -0400
Date: Tue, 3 Sep 2013 12:01:17 +0200
From: Michal Hocko <mhocko@suse.cz>
To: Greg Thelen <gthelen@google.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Johannes Weiner <hannes@cmpxchg.org>,
        Balbir Singh <bsingharora@gmail.com>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        cgroups@vger.kernel.org, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] memcg: fix multiple large threshold notifications
Message-ID: <20130903100117.GA14914@dhcp22.suse.cz>
References: <1377994002-1857-1-git-send-email-gthelen@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1377994002-1857-1-git-send-email-gthelen@google.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat 31-08-13 17:06:42, Greg Thelen wrote:
> A memory cgroup with (1) multiple threshold notifications and (2) at
> least one threshold >=2G was not reliable.  Specifically the
> notifications would either not fire or would not fire in the proper
> order.
> 
> The __mem_cgroup_threshold() signaling logic depends on keeping 64 bit
> thresholds in sorted order.  mem_cgroup_usage_register_event() sorts
> them with compare_thresholds(), which returns the difference of two 64
> bit thresholds as an int.  If the difference is positive but has
> bit[31] set, then sort() treats the difference as negative and breaks
> sort order.
> 
> This fix compares the two arbitrary 64 bit thresholds returning the
> classic -1, 0, 1 result.
> 
> The test below sets two notifications (at 0x1000 and 0x81001000):
>   cd /sys/fs/cgroup/memory
>   mkdir x
>   for x in 4096 2164264960; do
>     cgroup_event_listener x/memory.usage_in_bytes $x | sed "s/^/$x listener:/" &
>   done
>   echo $$ > x/cgroup.procs
>   anon_leaker 500M
> 
> v3.11-rc7 fails to signal the 4096 event listener:
>   Leaking...
>   Done leaking pages.
> 
> Patched v3.11-rc7 properly notifies:
>   Leaking...
>   4096 listener:2013:8:31:14:13:36
>   Done leaking pages.
> 
> The fixed bug is old.  It appears to date back to the introduction of
> memcg threshold notifications in v2.6.34-rc1-116-g2e72b6347c94 "memcg:
> implement memory thresholds"
> 
> Signed-off-by: Greg Thelen <gthelen@google.com>

Acked-by: Michal Hocko <mhocko@suse.cz>

I guess this qualifies to the stable tree.

Thanks!

> ---
>  mm/memcontrol.c | 8 +++++++-
>  1 file changed, 7 insertions(+), 1 deletion(-)
> 
> diff --git a/mm/memcontrol.c b/mm/memcontrol.c
> index 0878ff7..aa44621 100644
> --- a/mm/memcontrol.c
> +++ b/mm/memcontrol.c
> @@ -5616,7 +5616,13 @@ static int compare_thresholds(const void *a, const void *b)
>  	const struct mem_cgroup_threshold *_a = a;
>  	const struct mem_cgroup_threshold *_b = b;
>  
> -	return _a->threshold - _b->threshold;
> +	if (_a->threshold > _b->threshold)
> +		return 1;
> +
> +	if (_a->threshold < _b->threshold)
> +		return -1;
> +
> +	return 0;
>  }
>  
>  static int mem_cgroup_oom_notify_cb(struct mem_cgroup *memcg)
> -- 
> 1.8.4
> 

-- 
Michal Hocko
SUSE Labs
