Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754567Ab3GaJes (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Jul 2013 05:34:48 -0400
Received: from merlin.infradead.org ([205.233.59.134]:44497 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750775Ab3GaJeq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Jul 2013 05:34:46 -0400
Date: Wed, 31 Jul 2013 11:34:37 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Mel Gorman <mgorman@suse.de>
Cc: Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        Ingo Molnar <mingo@kernel.org>, Andrea Arcangeli <aarcange@redhat.com>,
        Johannes Weiner <hannes@cmpxchg.org>, Linux-MM <linux-mm@kvack.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 15/18] sched: Set preferred NUMA node based on number of
 private faults
Message-ID: <20130731093437.GX3008@twins.programming.kicks-ass.net>
References: <1373901620-2021-1-git-send-email-mgorman@suse.de>
 <1373901620-2021-16-git-send-email-mgorman@suse.de>
 <20130726112050.GJ27075@twins.programming.kicks-ass.net>
 <20130731092938.GM2296@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130731092938.GM2296@suse.de>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 31, 2013 at 10:29:38AM +0100, Mel Gorman wrote:
> > Hurmph I just stumbled upon this PMD 'trick' and I'm not at all sure I
> > like it. If an application would pre-fault/initialize its memory with
> > the main thread we'll collapse it into a PMDs and forever thereafter (by
> > virtue of do_pmd_numa_page()) they'll all stay the same. Resulting in
> > PMD granularity.
> > 
> 
> Potentially yes. When that PMD trick was introduced it was because the cost
> of faults was very high due to a high scanning rate. The trick mitigated
> worse-case scenarios until faults were properly accounted for and the scan
> rates were better controlled. As these *should* be addressed by the series
> I think I will be adding a patch to kick away this PMD crutch and see how
> it looks in profiles.

I've been thinking on this a bit and I think we should split these and
thp pages when we get shared faults from different nodes on them and
refuse thp collapses when the pages are on different nodes.

With the exception that when we introduce the interleave mempolicies we
should define 'different node' as being outside of the interleave mask.
