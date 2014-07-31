Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751548AbaGaP1M (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Jul 2014 11:27:12 -0400
Received: from zene.cmpxchg.org ([85.214.230.12]:58056 "EHLO zene.cmpxchg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751041AbaGaP1L (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Jul 2014 11:27:11 -0400
Date: Thu, 31 Jul 2014 11:26:59 -0400
From: Johannes Weiner <hannes@cmpxchg.org>
To: David Rientjes <rientjes@google.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>,
        Rik van Riel <riel@redhat.com>, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org
Subject: Re: [patch 2/3] mm, oom: remove unnecessary check for NULL zonelist
Message-ID: <20140731152659.GB9952@cmpxchg.org>
References: <alpine.DEB.2.02.1407231814110.22326@chino.kir.corp.google.com>
 <alpine.DEB.2.02.1407231815090.22326@chino.kir.corp.google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.02.1407231815090.22326@chino.kir.corp.google.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 23, 2014 at 06:16:32PM -0700, David Rientjes wrote:
> If the pagefault handler is modified to pass a non-NULL zonelist then an 
> unnecessary check for a NULL zonelist in constrained_alloc() can be removed.
>
> Signed-off-by: David Rientjes <rientjes@google.com>
> ---
>  mm/oom_kill.c | 4 +---
>  1 file changed, 1 insertion(+), 3 deletions(-)
> 
> diff --git a/mm/oom_kill.c b/mm/oom_kill.c
> --- a/mm/oom_kill.c
> +++ b/mm/oom_kill.c
> @@ -208,8 +208,6 @@ static enum oom_constraint constrained_alloc(struct zonelist *zonelist,
>  	/* Default to all available memory */
>  	*totalpages = totalram_pages + total_swap_pages;
>  
> -	if (!zonelist)
> -		return CONSTRAINT_NONE;
>  	/*
>  	 * Reach here only when __GFP_NOFAIL is used. So, we should avoid
>  	 * to kill current.We have to random task kill in this case.
> @@ -696,7 +694,7 @@ void pagefault_out_of_memory(void)
>  
>  	zonelist = node_zonelist(first_memory_node, GFP_KERNEL);
>  	if (try_set_zonelist_oom(zonelist, GFP_KERNEL)) {
> -		out_of_memory(NULL, 0, 0, NULL, false);
> +		out_of_memory(zonelist, 0, 0, NULL, false);

out_of_memory() wants the zonelist that was used during allocation,
not just the random first node's zonelist that's simply picked to
serialize page fault OOM kills system-wide.

This would even change how panic_on_oom behaves for page fault OOMs
(in a completely unpredictable way) if we get CONSTRAINED_CPUSET.

This change makes no sense to me.
