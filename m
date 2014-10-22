Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755985AbaJVQNg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Oct 2014 12:13:36 -0400
Received: from mx2.parallels.com ([199.115.105.18]:59581 "EHLO
	mx2.parallels.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754066AbaJVPpG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Oct 2014 11:45:06 -0400
Date: Wed, 22 Oct 2014 19:44:57 +0400
From: Vladimir Davydov <vdavydov@parallels.com>
To: Johannes Weiner <hannes@cmpxchg.org>
CC: Andrew Morton <akpm@linux-foundation.org>, Hugh Dickins <hughd@google.com>,
        Michal Hocko <mhocko@suse.cz>, <linux-mm@kvack.org>,
        <cgroups@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: Re: [patch 3/4] mm: memcontrol: remove unnecessary PCG_MEM memory
 charge flag
Message-ID: <20141022154457.GA16496@esperanza>
References: <1413818532-11042-1-git-send-email-hannes@cmpxchg.org>
 <1413818532-11042-4-git-send-email-hannes@cmpxchg.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <1413818532-11042-4-git-send-email-hannes@cmpxchg.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 20, 2014 at 11:22:11AM -0400, Johannes Weiner wrote:
> PCG_MEM is a remnant from an earlier version of 0a31bc97c80c ("mm:
> memcontrol: rewrite uncharge API"), used to tell whether migration
> cleared a charge while leaving pc->mem_cgroup valid and PCG_USED set.
> But in the final version, mem_cgroup_migrate() directly uncharges the
> source page, rendering this distinction unnecessary.  Remove it.
> 
> Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>

Reviewed-by: Vladimir Davydov <vdavydov@parallels.com>

> ---
>  include/linux/page_cgroup.h | 1 -
>  mm/memcontrol.c             | 4 +---
>  2 files changed, 1 insertion(+), 4 deletions(-)
> 
> diff --git a/include/linux/page_cgroup.h b/include/linux/page_cgroup.h
> index da62ee2be28b..97536e685843 100644
> --- a/include/linux/page_cgroup.h
> +++ b/include/linux/page_cgroup.h
> @@ -4,7 +4,6 @@
>  enum {
>  	/* flags for mem_cgroup */
>  	PCG_USED = 0x01,	/* This page is charged to a memcg */
> -	PCG_MEM = 0x02,		/* This page holds a memory charge */
>  };
>  
>  struct pglist_data;
> diff --git a/mm/memcontrol.c b/mm/memcontrol.c
> index 9bab35fc3e9e..1d66ac49e702 100644
> --- a/mm/memcontrol.c
> +++ b/mm/memcontrol.c
> @@ -2606,7 +2606,7 @@ static void commit_charge(struct page *page, struct mem_cgroup *memcg,
>  	 *   have the page locked
>  	 */
>  	pc->mem_cgroup = memcg;
> -	pc->flags = PCG_USED | PCG_MEM;
> +	pc->flags = PCG_USED;
>  
>  	if (lrucare)
>  		unlock_page_lru(page, isolated);
> @@ -6177,8 +6177,6 @@ void mem_cgroup_migrate(struct page *oldpage, struct page *newpage,
>  	if (!PageCgroupUsed(pc))
>  		return;
>  
> -	VM_BUG_ON_PAGE(!(pc->flags & PCG_MEM), oldpage);
> -
>  	if (lrucare)
>  		lock_page_lru(oldpage, &isolated);
>  
> -- 
> 2.1.2
> 
