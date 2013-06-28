Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754862Ab3F1I4m (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Jun 2013 04:56:42 -0400
Received: from merlin.infradead.org ([205.233.59.134]:45638 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750984Ab3F1I4j (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Jun 2013 04:56:39 -0400
Date: Fri, 28 Jun 2013 10:56:27 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
Cc: Mel Gorman <mgorman@suse.de>, Ingo Molnar <mingo@kernel.org>,
        Andrea Arcangeli <aarcange@redhat.com>,
        Johannes Weiner <hannes@cmpxchg.org>, Linux-MM <linux-mm@kvack.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 2/8] sched: Track NUMA hinting faults on per-node basis
Message-ID: <20130628085627.GA28407@twins.programming.kicks-ass.net>
References: <1372257487-9749-1-git-send-email-mgorman@suse.de>
 <1372257487-9749-3-git-send-email-mgorman@suse.de>
 <20130628060829.GA17195@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130628060829.GA17195@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 28, 2013 at 11:38:29AM +0530, Srikar Dronamraju wrote:
> * Mel Gorman <mgorman@suse.de> [2013-06-26 15:38:01]:
> > @@ -826,6 +833,9 @@ void task_numa_fault(int node, int pages, bool migrated)
> >  			p->numa_scan_period + jiffies_to_msecs(10));
> >  
> >  	task_numa_placement(p);
> > +
> > +	/* Record the fault, double the weight if pages were migrated */
> > +	p->numa_faults[node] += pages << migrated;
> 
> 
> Why are we doing this after the placement.
> I mean we should probably be doing this in the task_numa_placement,

The placement only does something when we've completed a full scan; this
would then be the first fault of the next scan. Hence we do placement
first so as not to add this first fault of the next scan to
->numa_faults[].

This all gets changed later on when ->numa_faults_curr[] gets
introduced.
