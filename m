Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751924AbaGaFE7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Jul 2014 01:04:59 -0400
Received: from mga11.intel.com ([192.55.52.93]:18516 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751014AbaGaFE6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Jul 2014 01:04:58 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.01,769,1400050800"; 
   d="scan'208";a="578033561"
Date: Thu, 31 Jul 2014 13:04:54 +0800
From: Aaron Lu <aaron.lu@intel.com>
To: Rik van Riel <riel@redhat.com>
Cc: Peter Zijlstra <peterz@infradead.org>, LKML <linux-kernel@vger.kernel.org>,
        lkp@01.org, jhladky@redhat.com
Subject: Re: [LKP] [sched/numa] a43455a1d57: +94.1%
 proc-vmstat.numa_hint_faults_local
Message-ID: <20140731050454.GA9386@aaronlu.sh.intel.com>
References: <53d70ee6.JsUEmW5dWsv8dev+%fengguang.wu@intel.com>
 <53D72FF5.90908@intel.com>
 <20140729023940.37b6aebc@annuminas.surriel.com>
 <20140729081712.GS20603@laptop.programming.kicks-ass.net>
 <20140729160437.4561742f@annuminas.surriel.com>
 <20140730021425.GA25023@aaronlu.sh.intel.com>
 <53D9003F.3050900@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <53D9003F.3050900@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 30, 2014 at 10:25:03AM -0400, Rik van Riel wrote:
> On 07/29/2014 10:14 PM, Aaron Lu wrote:
> > On Tue, Jul 29, 2014 at 04:04:37PM -0400, Rik van Riel wrote:
> >> On Tue, 29 Jul 2014 10:17:12 +0200
> >> Peter Zijlstra <peterz@infradead.org> wrote:
> >>
> >>>> +#define NUMA_SCALE 1000
> >>>> +#define NUMA_MOVE_THRESH 50
> >>>
> >>> Please make that 1024, there's no reason not to use power of two here.
> >>> This base 10 factor thing annoyed me no end already, its time for it to
> >>> die.
> >>
> >> That's easy enough.  However, it would be good to know whether
> >> this actually helps with the regression Aaron found :)
> > 
> > Sorry for the delay.
> > 
> > I applied the last patch and queued the hackbench job to the ivb42 test
> > machine for it to run 5 times, and here is the result(regarding the
> > proc-vmstat.numa_hint_faults_local field):
> > 173565
> > 201262
> > 192317
> > 198342
> > 198595
> > avg:
> > 192816
> > 
> > It seems it is still very big than previous kernels.
> 
> It looks like a step in the right direction, though.
> 
> Could you try running with a larger threshold?
> 
> >> +++ b/kernel/sched/fair.c
> >> @@ -924,10 +924,12 @@ static inline unsigned long group_faults_cpu(struct numa_group *group, int nid)
> >>  
> >>  /*
> >>   * These return the fraction of accesses done by a particular task, or
> >> - * task group, on a particular numa node.  The group weight is given a
> >> - * larger multiplier, in order to group tasks together that are almost
> >> - * evenly spread out between numa nodes.
> >> + * task group, on a particular numa node.  The NUMA move threshold
> >> + * prevents task moves with marginal improvement, and is set to 5%.
> >>   */
> >> +#define NUMA_SCALE 1024
> >> +#define NUMA_MOVE_THRESH (5 * NUMA_SCALE / 100)
> 
> It would be good to see if changing NUMA_MOVE_THRESH to
> (NUMA_SCALE / 8) does the trick.

With your 2nd patch and the above change, the result is:

"proc-vmstat.numa_hint_faults_local": [
  199708,
  209152,
  200638,
  187324,
  196654
  ],

avg:
198695

Regards,
Aaron
