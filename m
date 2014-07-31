Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932336AbaGaGyF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Jul 2014 02:54:05 -0400
Received: from mga02.intel.com ([134.134.136.20]:44012 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932320AbaGaGyA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Jul 2014 02:54:00 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.01,770,1400050800"; 
   d="scan'208";a="551685177"
Date: Thu, 31 Jul 2014 14:53:56 +0800
From: Aaron Lu <aaron.lu@intel.com>
To: Rik van Riel <riel@redhat.com>
Cc: Peter Zijlstra <peterz@infradead.org>, LKML <linux-kernel@vger.kernel.org>,
        lkp@01.org, jhladky@redhat.com
Subject: Re: [LKP] [sched/numa] a43455a1d57: +94.1%
 proc-vmstat.numa_hint_faults_local
Message-ID: <20140731065356.GA20462@aaronlu.sh.intel.com>
References: <53d70ee6.JsUEmW5dWsv8dev+%fengguang.wu@intel.com>
 <53D72FF5.90908@intel.com>
 <20140729023940.37b6aebc@annuminas.surriel.com>
 <20140729081712.GS20603@laptop.programming.kicks-ass.net>
 <20140729160437.4561742f@annuminas.surriel.com>
 <20140730021425.GA25023@aaronlu.sh.intel.com>
 <53D9003F.3050900@redhat.com>
 <20140731050454.GA9386@aaronlu.sh.intel.com>
 <53D9E0BF.1020600@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <53D9E0BF.1020600@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 31, 2014 at 02:22:55AM -0400, Rik van Riel wrote:
> -----BEGIN PGP SIGNED MESSAGE-----
> Hash: SHA1
> 
> On 07/31/2014 01:04 AM, Aaron Lu wrote:
> > On Wed, Jul 30, 2014 at 10:25:03AM -0400, Rik van Riel wrote:
> >> On 07/29/2014 10:14 PM, Aaron Lu wrote:
> >>> On Tue, Jul 29, 2014 at 04:04:37PM -0400, Rik van Riel wrote:
> >>>> On Tue, 29 Jul 2014 10:17:12 +0200 Peter Zijlstra
> >>>> <peterz@infradead.org> wrote:
> >>>> 
> >>>>>> +#define NUMA_SCALE 1000 +#define NUMA_MOVE_THRESH 50
> >>>>> 
> >>>>> Please make that 1024, there's no reason not to use power
> >>>>> of two here. This base 10 factor thing annoyed me no end
> >>>>> already, its time for it to die.
> >>>> 
> >>>> That's easy enough.  However, it would be good to know
> >>>> whether this actually helps with the regression Aaron found
> >>>> :)
> >>> 
> >>> Sorry for the delay.
> >>> 
> >>> I applied the last patch and queued the hackbench job to the
> >>> ivb42 test machine for it to run 5 times, and here is the
> >>> result(regarding the proc-vmstat.numa_hint_faults_local
> >>> field): 173565 201262 192317 198342 198595 avg: 192816
> >>> 
> >>> It seems it is still very big than previous kernels.
> >> 
> >> It looks like a step in the right direction, though.
> >> 
> >> Could you try running with a larger threshold?
> >> 
> >>>> +++ b/kernel/sched/fair.c @@ -924,10 +924,12 @@ static inline
> >>>> unsigned long group_faults_cpu(struct numa_group *group, int
> >>>> nid)
> >>>> 
> >>>> /* * These return the fraction of accesses done by a
> >>>> particular task, or - * task group, on a particular numa
> >>>> node.  The group weight is given a - * larger multiplier, in
> >>>> order to group tasks together that are almost - * evenly
> >>>> spread out between numa nodes. + * task group, on a
> >>>> particular numa node.  The NUMA move threshold + * prevents
> >>>> task moves with marginal improvement, and is set to 5%. */ 
> >>>> +#define NUMA_SCALE 1024 +#define NUMA_MOVE_THRESH (5 *
> >>>> NUMA_SCALE / 100)
> >> 
> >> It would be good to see if changing NUMA_MOVE_THRESH to 
> >> (NUMA_SCALE / 8) does the trick.
> > 
> > With your 2nd patch and the above change, the result is:
> > 
> > "proc-vmstat.numa_hint_faults_local": [ 199708, 209152, 200638, 
> > 187324, 196654 ],
> > 
> > avg: 198695
> 
> OK, so it is still a little higher than your original 162245.

The original number is 94500 for ivb42 machine, the 162245 is the sum
of the two numbers above it that are tested on two machines - one is the
number for ivb42 and one is for lkp-snb01. Sorry if that is not clear.

And for the numbers I have given with your patch applied, they are all
for ivb42 alone.

> 
> I guess this is to be expected, since the code will be more
> successful at placing a task on the right node, which results
> in the task scanning its memory more rapidly for a little bit.
> 
> Are you seeing any changes in throughput?

The throughput has almost no change. Your 2nd patch with scale changed
has seen a decrease of 0.1% compared to your original commit that
triggered the report, and that original commit has a increase of 1.2%
compared to its parent commit.

Regards,
Aaron
