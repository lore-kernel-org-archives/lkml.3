Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760502Ab3GaPid (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Jul 2013 11:38:33 -0400
Received: from merlin.infradead.org ([205.233.59.134]:54368 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760392Ab3GaPib (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Jul 2013 11:38:31 -0400
Date: Wed, 31 Jul 2013 17:38:21 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Mel Gorman <mgorman@suse.de>
Cc: Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        Ingo Molnar <mingo@kernel.org>, Andrea Arcangeli <aarcange@redhat.com>,
        Johannes Weiner <hannes@cmpxchg.org>, Linux-MM <linux-mm@kvack.org>,
        LKML <linux-kernel@vger.kernel.org>, riel@redhat.com
Subject: Re: [PATCH] sched, numa: Use {cpu, pid} to create task groups for
 shared faults
Message-ID: <20130731153821.GE3008@twins.programming.kicks-ass.net>
References: <1373901620-2021-1-git-send-email-mgorman@suse.de>
 <20130730113857.GR3008@twins.programming.kicks-ass.net>
 <20130731150751.GA15144@twins.programming.kicks-ass.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130731150751.GA15144@twins.programming.kicks-ass.net>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 31, 2013 at 05:07:51PM +0200, Peter Zijlstra wrote:
> @@ -1260,6 +1400,23 @@ void task_numa_fault(int last_cpupid, in
>  	}
>  
>  	/*
> +	 * First accesses are treated as private, otherwise consider accesses
> +	 * to be private if the accessing pid has not changed
> +	 */
> +	if (unlikely(last_cpupid == (-1 & LAST_CPUPID_MASK))) {
> +		priv = 1;
> +	} else {
> +		int cpu, pid;
> +
> +		cpu = cpupid_to_cpu(last_cpupid);
> +		pid = cpupid_to_pid(last_cpupid);
> +
> +		priv = (pid == (p->pid & LAST__PID_MASK));

So Rik just pointed out that this condition is likely to generate false
positives due to the birthday paradox. The problem with including
cpu/nid information is another kind of false positives.

We've no idea which is worse.. 

> +		if (!priv)
> +			task_numa_group(p, cpu, pid);
> +	}
