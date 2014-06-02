Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752790AbaFBXq2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Jun 2014 19:46:28 -0400
Received: from mail-pa0-f48.google.com ([209.85.220.48]:37280 "EHLO
	mail-pa0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751658AbaFBXq0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Jun 2014 19:46:26 -0400
Date: Mon, 2 Jun 2014 16:44:34 -0700 (PDT)
From: Hugh Dickins <hughd@google.com>
X-X-Sender: hugh@eggly.anvils
To: David Rientjes <rientjes@google.com>
cc: Andrew Morton <akpm@linux-foundation.org>,
        Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@suse.cz>,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        cgroups@vger.kernel.org
Subject: Re: [patch] mm, memcg: periodically schedule when emptying page
 list
In-Reply-To: <alpine.DEB.2.02.1406021612550.6487@chino.kir.corp.google.com>
Message-ID: <alpine.LSU.2.11.1406021637170.5627@eggly.anvils>
References: <alpine.DEB.2.02.1406021612550.6487@chino.kir.corp.google.com>
User-Agent: Alpine 2.11 (LSU 23 2013-08-11)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2 Jun 2014, David Rientjes wrote:

> mem_cgroup_force_empty_list() can iterate a large number of pages on an lru and 
> mem_cgroup_move_parent() doesn't return an errno unless certain criteria, none 
> of which indicate that the iteration may be taking too long, is met.
> 
> We have encountered the following stack trace many times indicating
> "need_resched set for > 51000020 ns (51 ticks) without schedule", for example:
> 
> 	scheduler_tick()
> 	<timer irq>
> 	mem_cgroup_move_account+0x4d/0x1d5
> 	mem_cgroup_move_parent+0x8d/0x109
> 	mem_cgroup_reparent_charges+0x149/0x2ba
> 	mem_cgroup_css_offline+0xeb/0x11b
> 	cgroup_offline_fn+0x68/0x16b
> 	process_one_work+0x129/0x350
> 
> If this iteration is taking too long, indicated by need_resched(), then 
> periodically schedule and continue from where we last left off.
> 
> Signed-off-by: David Rientjes <rientjes@google.com>
> ---
>  mm/memcontrol.c | 10 ++++++++--
>  1 file changed, 8 insertions(+), 2 deletions(-)
> 
> diff --git a/mm/memcontrol.c b/mm/memcontrol.c
> --- a/mm/memcontrol.c
> +++ b/mm/memcontrol.c
> @@ -4764,6 +4764,7 @@ static void mem_cgroup_force_empty_list(struct mem_cgroup *memcg,
>  	do {
>  		struct page_cgroup *pc;
>  		struct page *page;
> +		int ret;
>  
>  		spin_lock_irqsave(&zone->lru_lock, flags);
>  		if (list_empty(list)) {
> @@ -4781,8 +4782,13 @@ static void mem_cgroup_force_empty_list(struct mem_cgroup *memcg,
>  
>  		pc = lookup_page_cgroup(page);
>  
> -		if (mem_cgroup_move_parent(page, pc, memcg)) {
> -			/* found lock contention or "pc" is obsolete. */
> +		ret = mem_cgroup_move_parent(page, pc, memcg);
> +		if (ret || need_resched()) {
> +			/*
> +			 * Couldn't grab the page reference, isolate the page,
> +			 * there was a pc mismatch, or we simply need to
> +			 * schedule because this is taking too long.
> +			 */
>  			busy = page;
>  			cond_resched();
>  		} else

Why not just move that cond_resched() down below the if/else?
No need to test need_resched() separately, and this page is not busy.

Hugh
