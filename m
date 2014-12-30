Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752135AbaL3OWJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Dec 2014 09:22:09 -0500
Received: from mail-wg0-f53.google.com ([74.125.82.53]:35971 "EHLO
	mail-wg0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751440AbaL3OWH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Dec 2014 09:22:07 -0500
Date: Tue, 30 Dec 2014 15:22:02 +0100
From: Michal Hocko <mhocko@suse.cz>
To: Vladimir Davydov <vdavydov@parallels.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Johannes Weiner <hannes@cmpxchg.org>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] memcg: fix destination cgroup leak on task charges
 migration
Message-ID: <20141230142202.GC15546@dhcp22.suse.cz>
References: <1419868483-30612-1-git-send-email-vdavydov@parallels.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1419868483-30612-1-git-send-email-vdavydov@parallels.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon 29-12-14 18:54:43, Vladimir Davydov wrote:
> We are supposed to take one css reference per each memory page and per
> each swap entry accounted to a memory cgroup. However, during task
> charges migration we take a reference to the destination cgroup twice
> per each swap entry: first in mem_cgroup_do_precharge()->try_charge()
> and then in mem_cgroup_move_swap_account(), permanently leaking the
> destination cgroup.

Very well spotted!

> The hunk taking the second reference seems to be a leftover from the
> pre-00501b531c472 ("mm: memcontrol: rewrite charge API") era. Remove it
> to fix the leak.

This seems to be a fallout from e8ea14cc6ead (mm: memcontrol: take a
css reference for each charged page) because we only took per-charge
reference for swapped out pages before. In order to keep the balance
correct we had to do that ugly css_get() in mem_cgroup_move_swap_account
and uncharge the origin later on in __mem_cgroup_clear_mc.

The uncharge part for the from memcg should be OK because we do so from
the page counter directly and that doesn't involve reference counting
and then we do css_put_many explicitly.

So unless I have missed something the culrpit is different and so it
doesn't have to go to stable just should appear in a later 3.19 rc.

Fixes: e8ea14cc6ead (mm: memcontrol: take a css reference for each charged page)
> Signed-off-by: Vladimir Davydov <vdavydov@parallels.com>

Acked-by: Michal Hocko <mhocko@suse.cz>

> ---
>  mm/memcontrol.c |   12 ------------
>  1 file changed, 12 deletions(-)
> 
> diff --git a/mm/memcontrol.c b/mm/memcontrol.c
> index ef91e856c7e4..d62c335dfef4 100644
> --- a/mm/memcontrol.c
> +++ b/mm/memcontrol.c
> @@ -3043,18 +3043,6 @@ static int mem_cgroup_move_swap_account(swp_entry_t entry,
>  	if (swap_cgroup_cmpxchg(entry, old_id, new_id) == old_id) {
>  		mem_cgroup_swap_statistics(from, false);
>  		mem_cgroup_swap_statistics(to, true);
> -		/*
> -		 * This function is only called from task migration context now.
> -		 * It postpones page_counter and refcount handling till the end
> -		 * of task migration(mem_cgroup_clear_mc()) for performance
> -		 * improvement. But we cannot postpone css_get(to)  because if
> -		 * the process that has been moved to @to does swap-in, the
> -		 * refcount of @to might be decreased to 0.
> -		 *
> -		 * We are in attach() phase, so the cgroup is guaranteed to be
> -		 * alive, so we can just call css_get().
> -		 */
> -		css_get(&to->css);
>  		return 0;
>  	}
>  	return -EINVAL;
> -- 
> 1.7.10.4
> 

-- 
Michal Hocko
SUSE Labs
