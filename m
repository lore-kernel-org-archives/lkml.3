Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758395AbaGWXGJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jul 2014 19:06:09 -0400
Received: from relay2.sgi.com ([192.48.180.65]:36713 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1757333AbaGWXGH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jul 2014 19:06:07 -0400
X-Greylist: delayed 536 seconds by postgrey-1.27 at vger.kernel.org; Wed, 23 Jul 2014 19:06:06 EDT
Date: Wed, 23 Jul 2014 17:57:42 -0500
From: Alex Thorlton <athorlton@sgi.com>
To: David Rientjes <rientjes@google.com>
Cc: Alex Thorlton <athorlton@sgi.com>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        mgorman@suse.de, riel@redhat.com, kirill.shutemov@linux.intel.com,
        mingo@kernel.org, hughd@google.com, lliubbo@gmail.com,
        hannes@cmpxchg.org, srivatsa.bhat@linux.vnet.ibm.com,
        dave.hansen@linux.intel.com, dfults@sgi.com, hedi@sgi.com
Subject: Re: [BUG] THP allocations escape cpuset when defrag is off
Message-ID: <20140723225742.GU8578@sgi.com>
References: <20140723220538.GT8578@sgi.com>
 <alpine.DEB.2.02.1407231516570.23495@chino.kir.corp.google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.02.1407231516570.23495@chino.kir.corp.google.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 23, 2014 at 03:28:09PM -0700, David Rientjes wrote:
> > My debug code shows that certain code paths are still allowing
> > ALLOC_CPUSET to get pulled off the alloc_flags with the patch, but
> > monitoring the memory usage shows that we're staying on node, aside from
> > some very small allocations, which may be other types of allocations that
> > are not necessarly confined to a cpuset.  Need a bit more research to
> > confirm that.
> > 
> 
> ALLOC_CPUSET should get stripped for the cases outlined in 
> __cpuset_node_allowed_softwall(), specifically for GFP_ATOMIC which does 
> not have __GFP_WAIT set.

Makes sense.  I knew my patch was probably the wrong way to fix this,
but it did serve my purpose :)

> > So, my question ends up being, why do we wipe out ___GFP_WAIT when
> > defrag is off?  I'll trust that there is good reason to do that, but, if
> > so, is the behavior that I'm seeing expected?
> > 
> 
> The intention is to avoid memory compaction (and direct reclaim), 
> obviously, which does not run when __GFP_WAIT is not set.  But you're 
> exactly right that this abuses the allocflags conversion that allows 
> ALLOC_CPUSET to get cleared because it is using the aforementioned 
> GFP_ATOMIC exception for cpuset allocation.
>
> We can't use PF_MEMALLOC or TIF_MEMDIE for hugepage allocation because it 
> affects the allowed watermarks and nothing else prevents memory compaction 
> or direct reclaim from running in the page allocator slowpath.
> 
> So it looks like a modification to the page allocator is needed, see 
> below.

Looks good to me.  Fixes the problem without affecting any of the other
intended functionality.

> It's also been a long-standing issue that cpusets and mempolicies are 
> ignored by khugepaged that allows memory to be migrated remotely to nodes 
> that are not allowed by a cpuset's mems or a mempolicy's nodemask.  Even 
> with this issue fixed, you may find that some memory is migrated remotely, 
> although it may be negligible, by khugepaged.

A bit here and there is manageable.  There is, of course, some work to
be done there, but for now we're mainly concerned with a job that's
supposed to be confined to a cpuset spilling out and soaking up all the
memory on a machine.

Thanks for the help, David.  Much appreciated!

- Alex
