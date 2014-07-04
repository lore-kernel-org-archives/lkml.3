Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755779AbaGDIko (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Jul 2014 04:40:44 -0400
Received: from g6t1524.atlanta.hp.com ([15.193.200.67]:52312 "EHLO
	g6t1524.atlanta.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754394AbaGDIkk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Jul 2014 04:40:40 -0400
Message-ID: <1404463234.2457.4.camel@buesod1.americas.hpqcorp.net>
Subject: Re: [regression, 3.16-rc] rwsem: optimistic spinning causing
 performance degradation
From: Davidlohr Bueso <davidlohr@hp.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Jason Low <jason.low2@hp.com>, Dave Chinner <david@fromorbit.com>,
        Tim Chen <tim.c.chen@linux.intel.com>, Ingo Molnar <mingo@kernel.org>,
        linux-kernel@vger.kernel.org,
        Linus Torvalds <torvalds@linux-foundation.org>
Date: Fri, 04 Jul 2014 01:40:34 -0700
In-Reply-To: <20140704075247.GZ19379@twins.programming.kicks-ass.net>
References: <1404413420.8764.42.camel@j-VirtualBox>
	 <20140704010147.GY4453@dastard> <1404438366.8764.121.camel@j-VirtualBox>
	 <1404438890.8764.125.camel@j-VirtualBox>
	 <20140704075247.GZ19379@twins.programming.kicks-ass.net>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.4 (3.6.4-3.fc18) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2014-07-04 at 09:52 +0200, Peter Zijlstra wrote:
> On Thu, Jul 03, 2014 at 06:54:50PM -0700, Jason Low wrote:
> > Subject: [PATCH] rwsem: In rwsem_can_spin_on_owner(), return false if no owner
> > 
> > It was found that the rwsem optimistic spinning feature can potentially degrade
> > performance when there are readers. Perf profiles indicate in some workloads
> > that significant time can be spent spinning on !owner. This is because we don't
> > set the lock owner when readers(s) obtain the rwsem.
> > 
> > In this patch, we'll modify rwsem_can_spin_on_owner() such that we'll return
> > false if there is no lock owner. The rationale is that if we just entered the
> > slowpath, yet there is no lock owner, then there is a possibility that a reader
> > has the lock. To be conservative, we'll avoid spinning in these situations.
> > 
> > Dave Chinner found performance benefits with this patch in the xfs_repair
> > workload, where the total run time went from approximately 4 minutes 24 seconds,
> > down to approximately 1 minute 26 seconds with the patch.
> > 
> > Tested-by: Dave Chinner <dchinner@redhat.com>
> > Signed-off-by: Jason Low <jason.low2@hp.com>
> 
> Davidlohr, you'll be running this through your AIM and other benchmarks,
> I suppose?

I ran it through aim7, and as I suspected we take a performance hit with
'custom' ~-14% throughput for > 300 users (which is still overall quite
higher than rwsems without opt spinning, at around ~+45%), and we
actually improve a bit (~+15%) in 'disk' with >1000 users -- which
afaict resembles Dave's workload a bit. So all in all I'm quite happy
with this patch.

Acked-by: Davidlohr Bueso <davidlohr@hp.com>

