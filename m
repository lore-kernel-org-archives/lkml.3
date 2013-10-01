Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752008Ab3JAH2V (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Oct 2013 03:28:21 -0400
Received: from mail-ea0-f170.google.com ([209.85.215.170]:58221 "EHLO
	mail-ea0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751326Ab3JAH2U (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Oct 2013 03:28:20 -0400
Date: Tue, 1 Oct 2013 09:28:15 +0200
From: Ingo Molnar <mingo@kernel.org>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Waiman Long <Waiman.Long@hp.com>, Ingo Molnar <mingo@elte.hu>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Rik van Riel <riel@redhat.com>,
        Peter Hurley <peter@hurleysoftware.com>,
        Davidlohr Bueso <davidlohr.bueso@hp.com>,
        Alex Shi <alex.shi@intel.com>, Tim Chen <tim.c.chen@linux.intel.com>,
        Andrea Arcangeli <aarcange@redhat.com>,
        Matthew R Wilcox <matthew.r.wilcox@intel.com>,
        Dave Hansen <dave.hansen@intel.com>,
        Michel Lespinasse <walken@google.com>,
        Andi Kleen <andi@firstfloor.org>,
        "Chandramouleeswaran, Aswin" <aswin@hp.com>,
        "Norton, Scott J" <scott.norton@hp.com>
Subject: Re: [PATCH] rwsem: reduce spinlock contention in wakeup code path
Message-ID: <20131001072815.GA20261@gmail.com>
References: <1380308424-31011-1-git-send-email-Waiman.Long@hp.com>
 <CA+55aFxXeQ69B1bfrO+0QtBqm0gt688LOshx=ppNjch10JF8FQ@mail.gmail.com>
 <20130928074144.GA17773@gmail.com>
 <CA+55aFyx-Lpqd8i2tHvhXCqL+nJZPq-6SikEkb-cQZEU9ogRjA@mail.gmail.com>
 <20130928192123.GA8228@gmail.com>
 <CA+55aFyZqV_wJTpd9OVw=kM157Q45byW2F3kjhr5ML5Npz84OA@mail.gmail.com>
 <20130930104408.GW3081@twins.programming.kicks-ass.net>
 <CA+55aFwTCCXaD4S4OPGmwf=fhOwWdxr8NU9uFvdf_nRx0Nk0_w@mail.gmail.com>
 <20130930164141.GH3081@twins.programming.kicks-ass.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130930164141.GH3081@twins.programming.kicks-ass.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Peter Zijlstra <peterz@infradead.org> wrote:

> On Mon, Sep 30, 2013 at 09:13:52AM -0700, Linus Torvalds wrote:
>  
> > So unlike a lot of other "let's try to make our locking fancy" that I 
> > dislike because it tends to hide the fundamental problem of 
> > contention, the rwlock patches make me go "those actually _fix_ a 
> > fundamental problem".
> 
> So here I'm slightly disagreeing; fixing a fundamental problem would be 
> coming up a better anon_vma management that doesn't create such immense 
> chains.

So, I think the fundamental problem seems to be that when rwsems are 
applied to this usecase, they still don't perform as well as a primitive 
rwlock.

That means that when rwsems cause a context switch it is a loss, while an 
rwlock_t burning CPU time by looping around is a win. I'm not sure it's 
even about 'immense chains' - if those were true then context-switching 
should actually improve performance by allowing other work to continue 
while the heavy chains are processed.

Alas that's not what happens!

Or is AIM7 essentially triggering a single large lock? I doubt that's the 
case though.

> Its still the same lock, spinlock or not.
> 
> And regardless of if we keep anon_vma lock a rwsem or not; I think we 
> should merge those rwsem patches as they do improve the lock 
> implementation and the hard work has already been done.

That I mostly agree with, except that without a serious usecase do we have 
a guarantee that bugs in fancies queueing in rwsems gets ironed out?

Thanks,

	Ingo
