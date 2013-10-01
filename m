Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752266Ab3JAIZz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Oct 2013 04:25:55 -0400
Received: from mail-ea0-f177.google.com ([209.85.215.177]:55979 "EHLO
	mail-ea0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751587Ab3JAIZv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Oct 2013 04:25:51 -0400
Date: Tue, 1 Oct 2013 10:25:47 +0200
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
Message-ID: <20131001082547.GB21793@gmail.com>
References: <CA+55aFxXeQ69B1bfrO+0QtBqm0gt688LOshx=ppNjch10JF8FQ@mail.gmail.com>
 <20130928074144.GA17773@gmail.com>
 <CA+55aFyx-Lpqd8i2tHvhXCqL+nJZPq-6SikEkb-cQZEU9ogRjA@mail.gmail.com>
 <20130928192123.GA8228@gmail.com>
 <CA+55aFyZqV_wJTpd9OVw=kM157Q45byW2F3kjhr5ML5Npz84OA@mail.gmail.com>
 <20130930104408.GW3081@twins.programming.kicks-ass.net>
 <CA+55aFwTCCXaD4S4OPGmwf=fhOwWdxr8NU9uFvdf_nRx0Nk0_w@mail.gmail.com>
 <20130930164141.GH3081@twins.programming.kicks-ass.net>
 <20131001072815.GA20261@gmail.com>
 <20131001080921.GL3081@twins.programming.kicks-ass.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131001080921.GL3081@twins.programming.kicks-ass.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Peter Zijlstra <peterz@infradead.org> wrote:

> On Tue, Oct 01, 2013 at 09:28:15AM +0200, Ingo Molnar wrote:
>
> > That I mostly agree with, except that without a serious usecase do we 
> > have a guarantee that bugs in fancies queueing in rwsems gets ironed 
> > out?
> 
> Methinks mmap_sem is still a big enough lock to work out a locking 
> primitive :-)

I mean the AIM7 usecase probably falls away - we need to find another one 
that shows the inefficiencies.

> In fact, try something like this from userspace:
> 
> n-threads:
> 
>   pthread_mutex_lock(&mutex);
>   foo = mmap();
>   pthread_mutex_lock(&mutex);
> 
>   /* work */
> 
>   pthread_mutex_unlock(&mutex);
>   munma(foo);
>   pthread_mutex_unlock(&mutex);
> 
> vs
> 
> n-threads:
> 
>   foo = mmap();
>   /* work */
>   munmap(foo);
> 
> 
> I've had reports that the former was significantly faster than the
> latter.

That looks like a legitimate pattern that ought to trigger in many apps. 
Would be nice to turn this into a:

	perf bench mm thread-create

testcase or so.

Thanks,

	Ingo
