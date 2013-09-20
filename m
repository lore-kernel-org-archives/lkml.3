Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754811Ab3ITNbg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Sep 2013 09:31:36 -0400
Received: from cantor2.suse.de ([195.135.220.15]:41354 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754629Ab3ITNbf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Sep 2013 09:31:35 -0400
Date: Fri, 20 Sep 2013 14:31:30 +0100
From: Mel Gorman <mgorman@suse.de>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Rik van Riel <riel@redhat.com>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        Ingo Molnar <mingo@kernel.org>, Andrea Arcangeli <aarcange@redhat.com>,
        Johannes Weiner <hannes@cmpxchg.org>, Linux-MM <linux-mm@kvack.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 46/50] sched: numa: Prevent parallel updates to group
 stats during placement
Message-ID: <20130920133130.GY22421@suse.de>
References: <1378805550-29949-1-git-send-email-mgorman@suse.de>
 <1378805550-29949-47-git-send-email-mgorman@suse.de>
 <20130920095526.GT9326@twins.programming.kicks-ass.net>
 <20130920123151.GX22421@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
In-Reply-To: <20130920123151.GX22421@suse.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 20, 2013 at 01:31:51PM +0100, Mel Gorman wrote:
> @@ -1402,14 +1394,15 @@ unlock:
>  	if (!join)
>  		return;
>  
> +	double_lock(&my_grp->lock, &grp->lock);
> +
>  	for (i = 0; i < 2*nr_node_ids; i++) {
> -		atomic_long_sub(p->numa_faults[i], &my_grp->faults[i]);
> -		atomic_long_add(p->numa_faults[i], &grp->faults[i]);
> +		my_grp->faults[i] -= p->numa_faults[i];
> +		grp->faults[i] -= p->numa_faults[i];
> +		WARN_ON_ONCE(grp->faults[i] < 0);
>  	}

That stupidity got fixed

-- 
Mel Gorman
SUSE Labs
