Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752874Ab3KAOC3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Nov 2013 10:02:29 -0400
Received: from mga02.intel.com ([134.134.136.20]:18474 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751479Ab3KAOC2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Nov 2013 10:02:28 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.93,535,1378882800"; 
   d="scan'208";a="428287921"
Date: Fri, 1 Nov 2013 22:02:44 +0800
From: Yuanhan Liu <yuanhan.liu@linux.intel.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Michel Lespinasse <walken@google.com>, linux-kernel@vger.kernel.org,
        Ingo Molnar <mingo@kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Rik van Riel <riel@redhat.com>
Subject: Re: [PATCH 1/4] mm/rmap: per anon_vma lock
Message-ID: <20131101140244.GE30123@yliu-dev.sh.intel.com>
References: <1383292467-28922-1-git-send-email-yuanhan.liu@linux.intel.com>
 <1383292467-28922-2-git-send-email-yuanhan.liu@linux.intel.com>
 <20131101084329.GB19466@laptop.lan>
 <CANN689HQUv=k4AiD+v3980AmgPXbtcs1HLD7Ec1y8dsOfa_emA@mail.gmail.com>
 <20131101100707.GB30123@yliu-dev.sh.intel.com>
 <20131101101514.GD19466@laptop.lan>
 <20131101114429.GD30123@yliu-dev.sh.intel.com>
 <20131101120745.GC10651@twins.programming.kicks-ass.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131101120745.GC10651@twins.programming.kicks-ass.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 01, 2013 at 01:07:45PM +0100, Peter Zijlstra wrote:
> On Fri, Nov 01, 2013 at 07:44:29PM +0800, Yuanhan Liu wrote:
> > commit 012f18004da33ba672e3c60838cc4898126174d3
> > Author: Rik van Riel <riel@redhat.com>
> > Date:   Mon Aug 9 17:18:40 2010 -0700
> > 
> >     mm: always lock the root (oldest) anon_vma
> > 
> >     Always (and only) lock the root (oldest) anon_vma whenever we do something
> >     in an anon_vma.  The recently introduced anon_vma scalability is due to
> >     the rmap code scanning only the VMAs that need to be scanned.  Many common
> >     operations still took the anon_vma lock on the root anon_vma, so always
> >     taking that lock is not expected to introduce any scalability issues.
> > 
> >     However, always taking the same lock does mean we only need to take one
> >     lock, which means rmap_walk on pages from any anon_vma in the vma is
> >     excluded from occurring during an munmap, expand_stack or other operation
> >     that needs to exclude rmap_walk and similar functions.
> > 
> >     Also add the proper locking to vma_adjust.
> > 
> >     Signed-off-by: Rik van Riel <riel@redhat.com>
> >     Tested-by: Larry Woodman <lwoodman@redhat.com>
> >     Acked-by: Larry Woodman <lwoodman@redhat.com>
> >     Reviewed-by: Minchan Kim <minchan.kim@gmail.com>
> >     Reviewed-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
> >     Acked-by: Mel Gorman <mel@csn.ul.ie>
> >     Acked-by: Linus Torvalds <torvalds@linux-foundation.org>
> >     Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
> >     Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
> 
> Right that commit did.

Sorry again for that! I was jusy being brain dead :(

> I'm still not sure why you change both the
> locking proper and the locking primitive used in one patch set.

convert rwsem to rwlock silightly depends on per anon_vma lock, as it's
a bad idea to do avc allocation inside a spin lock.

Without converting rwsem to rwlock, it's not that useful to introduce
per anon_vma lock, or worse, it may introduce regressions.

> 
> Also, changing the locking proper requires a very detailed explanation
> on why it is correct;

Thanks for the tip. And yes, this patch really lacks of some explanation.
I tried to find some potentional races. I then digged the git history
and found it was per anon_lock at the first time avc was introduced.
It was changed to root locking not for fixing race, thus I think we
can changed it back, and this time, for performance boost.

anon_vma lock owns biggest lock contention on our many-core(say 120)servers
from /proc/lock_stat. I found Ingo's patch makes it better, and since
it's a spin lock, I then tried to narrow down the lock range. Hence,
I wrote this patch.

This patch may be wrong, but I guess it's somehow worthy sending out
for comments.

> we've had far too many 'fun' issues with the
> anon_vma locking in the past.

Yeah, I know. Say, http://lwn.net/Articles/383162/ ;)

Thanks.

	--yliu
