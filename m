Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752303Ab3I1Hlv (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Sep 2013 03:41:51 -0400
Received: from mail-ea0-f169.google.com ([209.85.215.169]:65488 "EHLO
	mail-ea0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751814Ab3I1Hlt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Sep 2013 03:41:49 -0400
Date: Sat, 28 Sep 2013 09:41:45 +0200
From: Ingo Molnar <mingo@kernel.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Waiman Long <Waiman.Long@hp.com>, Ingo Molnar <mingo@elte.hu>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Rik van Riel <riel@redhat.com>,
        Peter Hurley <peter@hurleysoftware.com>,
        Davidlohr Bueso <davidlohr.bueso@hp.com>,
        Alex Shi <alex.shi@intel.com>, Tim Chen <tim.c.chen@linux.intel.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Andrea Arcangeli <aarcange@redhat.com>,
        Matthew R Wilcox <matthew.r.wilcox@intel.com>,
        Dave Hansen <dave.hansen@intel.com>,
        Michel Lespinasse <walken@google.com>,
        Andi Kleen <andi@firstfloor.org>,
        "Chandramouleeswaran, Aswin" <aswin@hp.com>,
        "Norton, Scott J" <scott.norton@hp.com>
Subject: Re: [PATCH] rwsem: reduce spinlock contention in wakeup code path
Message-ID: <20130928074144.GA17773@gmail.com>
References: <1380308424-31011-1-git-send-email-Waiman.Long@hp.com>
 <CA+55aFxXeQ69B1bfrO+0QtBqm0gt688LOshx=ppNjch10JF8FQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+55aFxXeQ69B1bfrO+0QtBqm0gt688LOshx=ppNjch10JF8FQ@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Linus Torvalds <torvalds@linux-foundation.org> wrote:

> On Fri, Sep 27, 2013 at 12:00 PM, Waiman Long <Waiman.Long@hp.com> wrote:
> >
> > On a large NUMA machine, it is entirely possible that a fairly large 
> > number of threads are queuing up in the ticket spinlock queue to do 
> > the wakeup operation. In fact, only one will be needed.  This patch 
> > tries to reduce spinlock contention by doing just that.
> >
> > A new wakeup field is added to the rwsem structure. This field is set 
> > on entry to rwsem_wake() and __rwsem_do_wake() to mark that a thread 
> > is pending to do the wakeup call. It is cleared on exit from those 
> > functions.
> 
> Ok, this is *much* simpler than adding the new MCS spinlock, so I'm 
> wondering what the performance difference between the two are.
> 
> I'm obviously always in favor of just removing lock contention over 
> trying to improve the lock scalability, so I really like Waiman's 
> approach over Tim's new MCS lock. Not because I dislike MCS locks in 
> general (or you, Tim ;), it's really more fundamental: I just 
> fundamentally believe more in trying to avoid lock contention than in 
> trying to improve lock behavior when that contention happens.
> 
> As such, I love exactly these kinds of things that Wainman's patch does, 
> and I'm heavily biased.

Yeah, I fully agree. The reason I'm still very sympathetic to Tim's 
efforts is that they address a regression caused by a mechanic 
mutex->rwsem conversion:

  5a505085f043 mm/rmap: Convert the struct anon_vma::mutex to an rwsem

... and Tim's patches turn that regression into an actual speedup.

The main regression component happens to be more prominent on larger 
systems which inevitably have higher contention. That was a result of 
mutexes having better contention behavior than rwsems - which was not a 
property Tim picked arbitrarily.

The other advantage would be that by factoring out the MCS code it gets 
reviewed and seen more prominently - this resulted in a micro-optimization 
already. So people working on mutex or rwsem scalability will have a 
chance to help each other.

A third advantage would be that arguably our rwsems degrade on really big 
systems catastrophically. We had that with spinlocks and mutexes and it 
got fixd. Since rwsems are a long-term concern for us I thought that 
something like MCS queueing could be considered a fundamental 
quality-of-implementation requirement as well.

In any case I fully agree that we never want to overdo it, our priority of 
optimization and our ranking will always be:

	- lockless algorithms
	- reduction of critical paths
	...
	- improved locking fast path
	- improved locking slow path

and people will see much better speedups if they concentrate on entries 
higher on this list.

It's a pretty rigid order as well: no slowpath improvement is allowed to 
hurt any of the higher priority optimization concepts and people are 
encouraged to always work on the higher order concepts before considering 
the symptoms of contention.

But as long as contention behavior improvements are cleanly done, don't 
cause regressions, do not hinder primary scalability efforts and the 
numbers are as impressive as Tim's, it looks like good stuff to me.

I was thinking about putting them into the locking tree once the review 
and testing process converges and wanted to send them to you in the v3.13 
merge window.

The only potential downside (modulo bugs) I can see from Tim's patches is 
XFS's heavy dependence on fine behavioral details of rwsem. But if done 
right then none of these scalability efforts should impact those details.

Thanks,

	Ingo
