Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754266Ab3KALoO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Nov 2013 07:44:14 -0400
Received: from mga09.intel.com ([134.134.136.24]:14804 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750787Ab3KALoN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Nov 2013 07:44:13 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.93,535,1378882800"; 
   d="scan'208";a="428228177"
Date: Fri, 1 Nov 2013 19:44:29 +0800
From: Yuanhan Liu <yuanhan.liu@linux.intel.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Michel Lespinasse <walken@google.com>, linux-kernel@vger.kernel.org,
        Ingo Molnar <mingo@kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Rik van Riel <riel@redhat.com>
Subject: Re: [PATCH 1/4] mm/rmap: per anon_vma lock
Message-ID: <20131101114429.GD30123@yliu-dev.sh.intel.com>
References: <1383292467-28922-1-git-send-email-yuanhan.liu@linux.intel.com>
 <1383292467-28922-2-git-send-email-yuanhan.liu@linux.intel.com>
 <20131101084329.GB19466@laptop.lan>
 <CANN689HQUv=k4AiD+v3980AmgPXbtcs1HLD7Ec1y8dsOfa_emA@mail.gmail.com>
 <20131101100707.GB30123@yliu-dev.sh.intel.com>
 <20131101101514.GD19466@laptop.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131101101514.GD19466@laptop.lan>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 01, 2013 at 11:15:14AM +0100, Peter Zijlstra wrote:
> On Fri, Nov 01, 2013 at 06:07:07PM +0800, Yuanhan Liu wrote:
> > > I also want to point out that lately we've seen several changes sent
> > > out that relax locking with no accompanying explanation of why the
> > > relaxed locking would be safe. Please don't do that - having a lot of
> > > performance data is worthless if you can't explain why the new locking
> > > is safe.
> > 
> > Agreed.
> > 
> > > And I'm not asking to prove a negative ('lack of any possible
> > > races') there, but at least in this case one could dig out why the
> > > root anon vma locking was introduced and if they think that this
> > > reason doesn't apply anymore, explain why...
> > 
> > It was introduced by commit 2b575eb6(And, BTW, I'm sorry that this commit log
> > about bb4aa39676f is wrong)
> > 
> >    commit 2b575eb64f7a9c701fb4bfdb12388ac547f6c2b6
> >    Author: Peter Zijlstra <a.p.zijlstra@chello.nl>
> >    Date:   Tue May 24 17:12:11 2011 -0700
> >    
> >        mm: convert anon_vma->lock to a mutex
> >    
> >        Straightforward conversion of anon_vma->lock to a mutex.
> >    
> > As you can see, Peter didn't tell why before. Honestly speaking, that
> > was my originaly concern as well. I tried to find some possible races;
> > I guess I may miss something.
> 
> Bullshit; I didn't change the locking. I only changed the lock primitive
> from a spinlock to a mutex. The anon_vma->root->lock is completely
> unrelated to this change.

Oops, sorry for that. Just made a *horrible* mistake: it was commit
012f18004da33ba672e3c60838cc4898126174d3.


commit 012f18004da33ba672e3c60838cc4898126174d3
Author: Rik van Riel <riel@redhat.com>
Date:   Mon Aug 9 17:18:40 2010 -0700

    mm: always lock the root (oldest) anon_vma

    Always (and only) lock the root (oldest) anon_vma whenever we do something
    in an anon_vma.  The recently introduced anon_vma scalability is due to
    the rmap code scanning only the VMAs that need to be scanned.  Many common
    operations still took the anon_vma lock on the root anon_vma, so always
    taking that lock is not expected to introduce any scalability issues.

    However, always taking the same lock does mean we only need to take one
    lock, which means rmap_walk on pages from any anon_vma in the vma is
    excluded from occurring during an munmap, expand_stack or other operation
    that needs to exclude rmap_walk and similar functions.

    Also add the proper locking to vma_adjust.

    Signed-off-by: Rik van Riel <riel@redhat.com>
    Tested-by: Larry Woodman <lwoodman@redhat.com>
    Acked-by: Larry Woodman <lwoodman@redhat.com>
    Reviewed-by: Minchan Kim <minchan.kim@gmail.com>
    Reviewed-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
    Acked-by: Mel Gorman <mel@csn.ul.ie>
    Acked-by: Linus Torvalds <torvalds@linux-foundation.org>
    Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
    Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>


