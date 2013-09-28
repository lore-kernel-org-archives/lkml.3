Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754890Ab3I1TVa (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Sep 2013 15:21:30 -0400
Received: from mail-ee0-f45.google.com ([74.125.83.45]:38134 "EHLO
	mail-ee0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751953Ab3I1TV2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Sep 2013 15:21:28 -0400
Date: Sat, 28 Sep 2013 21:21:23 +0200
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
Message-ID: <20130928192123.GA8228@gmail.com>
References: <1380308424-31011-1-git-send-email-Waiman.Long@hp.com>
 <CA+55aFxXeQ69B1bfrO+0QtBqm0gt688LOshx=ppNjch10JF8FQ@mail.gmail.com>
 <20130928074144.GA17773@gmail.com>
 <CA+55aFyx-Lpqd8i2tHvhXCqL+nJZPq-6SikEkb-cQZEU9ogRjA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+55aFyx-Lpqd8i2tHvhXCqL+nJZPq-6SikEkb-cQZEU9ogRjA@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Linus Torvalds <torvalds@linux-foundation.org> wrote:

> On Sat, Sep 28, 2013 at 12:41 AM, Ingo Molnar <mingo@kernel.org> wrote:
> >
> >
> > Yeah, I fully agree. The reason I'm still very sympathetic to Tim's
> > efforts is that they address a regression caused by a mechanic
> > mutex->rwsem conversion:
> >
> >   5a505085f043 mm/rmap: Convert the struct anon_vma::mutex to an rwsem
> >
> > ... and Tim's patches turn that regression into an actual speedup.
> 
> Btw, I really hate that thing. I think we should turn it back into a 
> spinlock. None of what it protects needs a mutex or an rwsem.
> 
> Because you guys talk about the regression of turning it into a rwsem, 
> but nobody talks about the *original* regression.
> 
> And it *used* to be a spinlock, and it was changed into a mutex back in 
> 2011 by commit 2b575eb64f7a. That commit doesn't even have a reason 
> listed for it, although my dim memory of it is that the reason was 
> preemption latency.

Yeah, I think it was latency.

> And that caused big regressions too.
> 
> Of course, since then, we may well have screwed things up and now we 
> sleep under it, but I still really think it was a mistake to do it in 
> the first place.
> 
> So if the primary reason for this is really just that f*cking anon_vma 
> lock, then I would seriously suggest:
> 
>  - turn it back into a spinlock (or rwlock_t, since we subsequently
>    separated the read and write paths)
> 
>  - fix up any breakage (ie new scheduling points) that exposes
> 
>  - look at possible other approaches wrt latency on that thing.
> 
> Hmm?

If we do that then I suspect the next step will be queued rwlocks :-/ The 
current rwlock_t implementation is rather primitive by modern standards. 
(We'd probably have killed rwlock_t long ago if not for the 
tasklist_lock.)

But yeah, it would work and conceptually a hard spinlock fits something as 
lowlevel as the anon-vma lock.

I did a quick review pass and it appears nothing obvious is scheduling 
with the anon-vma lock held. If it did in a non-obvious way it's likely a 
bug anyway. The hugepage code grew a lot of logic running under the 
anon-vma lock, but it all seems atomic.

So a conversion to rwlock_t could be attempted. (It should be relatively 
easy patch as well, because the locking operation is now nicely abstracted 
out.)

Thanks,

	Ingo
