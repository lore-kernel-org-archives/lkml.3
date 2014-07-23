Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757596AbaGWLo5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jul 2014 07:44:57 -0400
Received: from zene.cmpxchg.org ([85.214.230.12]:33178 "EHLO zene.cmpxchg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755287AbaGWLo4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jul 2014 07:44:56 -0400
Date: Wed, 23 Jul 2014 07:44:49 -0400
From: Johannes Weiner <hannes@cmpxchg.org>
To: Mel Gorman <mgorman@suse.de>
Cc: Andrew Morton <akpm@linux-foundation.org>, Michal Hocko <mhocko@suse.cz>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        Linux-MM <linux-mm@kvack.org>
Subject: Re: [PATCH 1/2] mm: Avoid full RCU lookup of memcg for statistics
 updates
Message-ID: <20140723114449.GE1725@cmpxchg.org>
References: <1406114656-16350-1-git-send-email-mgorman@suse.de>
 <1406114656-16350-2-git-send-email-mgorman@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1406114656-16350-2-git-send-email-mgorman@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 23, 2014 at 12:24:15PM +0100, Mel Gorman wrote:
> When updating memcg VM statistics like PGFAULT we take the rcu read
> lock and lookup the memcg. For statistic updates this is overkill
> when the process may not belong to a memcg. This patch adds a light
> check to check if a memcg potentially exists. It's race-prone in that
> some VM stats may be missed when a process first joins a memcg but
> that is not serious enough to justify a constant performance penalty.

Tasks always belong to a memcg, the root group per default.  There
isn't really any accounting that could be omitted.

> The exact impact of this is difficult to quantify because it's timing
> sensitive, workload sensitive and sensitive to the RCU options set. However,
> broadly speaking there should be less interference due to page fault
> activity in both the number of RCU grace periods and their age.
> 
> Signed-off-by: Mel Gorman <mgorman@suse.de>
> ---
>  include/linux/memcontrol.h | 8 ++++++++
>  1 file changed, 8 insertions(+)
> 
> diff --git a/include/linux/memcontrol.h b/include/linux/memcontrol.h
> index eb65d29..76fa97d 100644
> --- a/include/linux/memcontrol.h
> +++ b/include/linux/memcontrol.h
> @@ -220,6 +220,14 @@ static inline void mem_cgroup_count_vm_event(struct mm_struct *mm,
>  {
>  	if (mem_cgroup_disabled())
>  		return;
> +	/*
> +	 * For statistic updates it's overkill to take the RCU lock and do
> +	 * a fully safe lookup of an associated memcg. Do a simple check
> +	 * first. At worst, we miss a few stat updates when a process is
> +	 * moved to a memcg for the first time.
> +	 */
> +	if (!rcu_access_pointer(mm->owner))
> +		return;

mm->owner is set when the mm is first initialized, it's only NULL
during race conditions on exit.
