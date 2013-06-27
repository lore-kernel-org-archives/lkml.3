Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753577Ab3F0O5L (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Jun 2013 10:57:11 -0400
Received: from merlin.infradead.org ([205.233.59.134]:59440 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751569Ab3F0O5J (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Jun 2013 10:57:09 -0400
Date: Thu, 27 Jun 2013 16:56:58 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Mel Gorman <mgorman@suse.de>
Cc: Ingo Molnar <mingo@kernel.org>, Andrea Arcangeli <aarcange@redhat.com>,
        Johannes Weiner <hannes@cmpxchg.org>, Linux-MM <linux-mm@kvack.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 7/8] sched: Split accounting of NUMA hinting faults that
 pass two-stage filter
Message-ID: <20130627145658.GV28407@twins.programming.kicks-ass.net>
References: <1372257487-9749-1-git-send-email-mgorman@suse.de>
 <1372257487-9749-8-git-send-email-mgorman@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1372257487-9749-8-git-send-email-mgorman@suse.de>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 26, 2013 at 03:38:06PM +0100, Mel Gorman wrote:
> +void task_numa_fault(int last_nid, int node, int pages, bool migrated)
>  {
>  	struct task_struct *p = current;
> +	int priv = (cpu_to_node(task_cpu(p)) == last_nid);
>  
>  	if (!sched_feat_numa(NUMA))
>  		return;
>  
>  	/* Allocate buffer to track faults on a per-node basis */
>  	if (unlikely(!p->numa_faults)) {
> -		int size = sizeof(*p->numa_faults) * nr_node_ids;
> +		int size = sizeof(*p->numa_faults) * 2 * nr_node_ids;
>  
>  		/* numa_faults and numa_faults_buffer share the allocation */
> -		p->numa_faults = kzalloc(size * 2, GFP_KERNEL);
> +		p->numa_faults = kzalloc(size * 4, GFP_KERNEL);
>  		if (!p->numa_faults)
>  			return;

So you need a buffer 2x the size in total; but you're now allocating
a buffer 4x larger than before.

Isn't doubling size alone sufficient?
