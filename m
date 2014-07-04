Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760037AbaGDGNN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Jul 2014 02:13:13 -0400
Received: from ipmail05.adl6.internode.on.net ([150.101.137.143]:22853 "EHLO
	ipmail05.adl6.internode.on.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752917AbaGDGNM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Jul 2014 02:13:12 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AohQAMlEtlN5LHZ8PGdsb2JhbABagw2IUqQfAgEHmlYBgQ4XBAEBAQE4NYQDAQEEATocIwULCAMXAQklDwUlAwcMDhOIOgfJcBcYhViGDQGDJAcGhD0FmnWWDoFUKw
Date: Fri, 4 Jul 2014 16:13:06 +1000
From: Dave Chinner <david@fromorbit.com>
To: Jason Low <jason.low2@hp.com>
Cc: Davidlohr Bueso <davidlohr@hp.com>, Peter Zijlstra <peterz@infradead.org>,
        Tim Chen <tim.c.chen@linux.intel.com>, Ingo Molnar <mingo@kernel.org>,
        linux-kernel@vger.kernel.org,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [regression, 3.16-rc] rwsem: optimistic spinning causing
 performance degradation
Message-ID: <20140704061306.GK9508@dastard>
References: <1404413420.8764.42.camel@j-VirtualBox>
 <20140704010147.GY4453@dastard>
 <1404438366.8764.121.camel@j-VirtualBox>
 <1404438890.8764.125.camel@j-VirtualBox>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1404438890.8764.125.camel@j-VirtualBox>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 03, 2014 at 06:54:50PM -0700, Jason Low wrote:
> On Thu, 2014-07-03 at 18:46 -0700, Jason Low wrote:
> > On Fri, 2014-07-04 at 11:01 +1000, Dave Chinner wrote:
> 
> > > FWIW, the rwsems in the struct xfs_inode are often heavily
> > > read/write contended, so there are lots of IO related workloads that
> > > are going to regress on XFS without this optimisation...
> > > 
> > > Anyway, consider the patch:
> > > 
> > > Tested-by: Dave Chinner <dchinner@redhat.com>
> > 
> > Hi Dave,
> > 
> > Thanks for testing. I'll update the patch with an actual changelog.
> 
> ---
> Subject: [PATCH] rwsem: In rwsem_can_spin_on_owner(), return false if no owner
> 
> It was found that the rwsem optimistic spinning feature can potentially degrade
> performance when there are readers. Perf profiles indicate in some workloads
> that significant time can be spent spinning on !owner. This is because we don't
> set the lock owner when readers(s) obtain the rwsem.

I don't think you're being a little shifty with the truth here.
There's no "potentially degrade performance" here - I reported a
massive real world performance regression caused by optimistic
spinning.  That is:

"Commit 4fc828e ("locking/rwsem: Support optimistic spinning")
introduced a major performance regression for workloads such as
xfs_repair which mix read and write locking of the mmap_sem across
many threads. The result was xfs_repair ran 5x slower on 3.16-rc2
than on 3.15 and using 20x more system CPU time."

"Perf profiles indicate....

> In this patch, we'll modify rwsem_can_spin_on_owner() such that we'll return
> false if there is no lock owner. The rationale is that if we just entered the
> slowpath, yet there is no lock owner, then there is a possibility that a reader
> has the lock. To be conservative, we'll avoid spinning in these situations.
> 
> Dave Chinner found performance benefits with this patch in the xfs_repair
> workload, where the total run time went from approximately 4 minutes 24 seconds,
> down to approximately 1 minute 26 seconds with the patch.

Which brought it back to close to the same performance as on 3.15.
This is not a new performance improvement patch - it's a regression
fix and the commit message needs to reflect that.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
