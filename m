Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755244Ab3G2KLL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Jul 2013 06:11:11 -0400
Received: from merlin.infradead.org ([205.233.59.134]:34234 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753139Ab3G2KLJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Jul 2013 06:11:09 -0400
Date: Mon, 29 Jul 2013 12:10:59 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Mel Gorman <mgorman@suse.de>
Cc: Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        Ingo Molnar <mingo@kernel.org>, Andrea Arcangeli <aarcange@redhat.com>,
        Johannes Weiner <hannes@cmpxchg.org>, Linux-MM <linux-mm@kvack.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 02/18] sched: Track NUMA hinting faults on per-node basis
Message-ID: <20130729101059.GC3008@twins.programming.kicks-ass.net>
References: <1373901620-2021-1-git-send-email-mgorman@suse.de>
 <1373901620-2021-3-git-send-email-mgorman@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1373901620-2021-3-git-send-email-mgorman@suse.de>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 15, 2013 at 04:20:04PM +0100, Mel Gorman wrote:
> +++ b/kernel/sched/fair.c
> @@ -815,7 +815,14 @@ void task_numa_fault(int node, int pages, bool migrated)
>  	if (!sched_feat_numa(NUMA))
>  		return;
>  
> -	/* FIXME: Allocate task-specific structure for placement policy here */
> +	/* Allocate buffer to track faults on a per-node basis */
> +	if (unlikely(!p->numa_faults)) {
> +		int size = sizeof(*p->numa_faults) * nr_node_ids;
> +
> +		p->numa_faults = kzalloc(size, GFP_KERNEL);

We should probably stick a __GFP_NOWARN in there.

> +		if (!p->numa_faults)
> +			return;
> +	}
>  
>  	/*
>  	 * If pages are properly placed (did not migrate) then scan slower.
