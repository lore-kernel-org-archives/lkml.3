Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751043Ab3IPPSl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Sep 2013 11:18:41 -0400
Received: from merlin.infradead.org ([205.233.59.134]:53548 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750988Ab3IPPSk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Sep 2013 11:18:40 -0400
Date: Mon, 16 Sep 2013 17:18:22 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Mel Gorman <mgorman@suse.de>
Cc: Rik van Riel <riel@redhat.com>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        Ingo Molnar <mingo@kernel.org>, Andrea Arcangeli <aarcange@redhat.com>,
        Johannes Weiner <hannes@cmpxchg.org>, Linux-MM <linux-mm@kvack.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 14/50] sched: Set the scan rate proportional to the
 memory usage of the task being scanned
Message-ID: <20130916151822.GE9326@twins.programming.kicks-ass.net>
References: <1378805550-29949-1-git-send-email-mgorman@suse.de>
 <1378805550-29949-15-git-send-email-mgorman@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1378805550-29949-15-git-send-email-mgorman@suse.de>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 10, 2013 at 10:31:54AM +0100, Mel Gorman wrote:
> @@ -860,9 +908,14 @@ void task_numa_fault(int node, int pages, bool migrated)
>  	 * If pages are properly placed (did not migrate) then scan slower.
>  	 * This is reset periodically in case of phase changes
>  	 */
> -        if (!migrated)
> -		p->numa_scan_period = min(sysctl_numa_balancing_scan_period_max,
> +        if (!migrated) {
> +		/* Initialise if necessary */
> +		if (!p->numa_scan_period_max)
> +			p->numa_scan_period_max = task_scan_max(p);
> +
> +		p->numa_scan_period = min(p->numa_scan_period_max,
>  			p->numa_scan_period + jiffies_to_msecs(10));

So the next patch changes the jiffies_to_msec() thing.. is that really
worth a whole separate patch?

Also, I really don't believe any of that is 'right', increasing the scan
period by a fixed amount for every !migrated page is just wrong.

Firstly; there's the migration throttle which basically guarantees that
most pages aren't migrated -- even when they ought to be, thus inflating
the period.

Secondly; assume a _huge_ process, so large that even a small fraction
of non-migrated pages will completely clip the scan period.
